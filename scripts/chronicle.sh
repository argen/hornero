#!/usr/bin/env bash
# chronicle.sh — single CLI for the Hornero Chronicle layer.
#
# Subcommands:
#   propose   Create a staged entry in chronicle/proposals/<uuid>.md
#             (no LLM in this path; takes CLI args, writes a fixed shape)
#   commit    Move a proposal → chronicle/entries/<id>.md, regenerate SUMMARY.md
#   query     Filter committed entries deterministically. Output is byte-stable.
#   summary   Regenerate chronicle/SUMMARY.md from chronicle/entries/
#   validate  Lint every chronicle/entries/*.md against the schema
#
# Design notes:
#   * The write path is LLM-free. The shape is fixed; the validator is regex/grep.
#   * `query` output is sorted (date desc, id asc) and emits a fixed Markdown
#     header + table, so byte-equality assertions in the test harness work.
#   * The proposals/ → entries/ split is the human gate. `propose` does not
#     write to entries/, and `query` does not look at proposals/.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHRONICLE_DIR="${ROOT}/chronicle"
ENTRIES_DIR="${CHRONICLE_DIR}/entries"
PROPOSALS_DIR="${CHRONICLE_DIR}/proposals"
INGESTION_DIR="${CHRONICLE_DIR}/ingestion"
SOURCE_DIR="${CHRONICLE_DIR}/source"
SUMMARY_FILE="${CHRONICLE_DIR}/SUMMARY.md"

LEGAL_STATUSES=(validated open superseded refuted)
LEGAL_ROLES=(product-manager cross-role software-engineer designer tester security-expert marketing-expert data-scientist)
# Sourcing is ordered strongest → weakest. An entry's value is the weakest
# source the decision rests on, so a `documented` entry rests entirely on
# durable evidence and an `industry` entry leans at least partly on generic
# field knowledge.
LEGAL_SOURCING=(documented verbal intuition industry)
# Entry types.
#   `decision`    — Rumelt's strategy kernel + a validation plan. The original shape.
#   `hypothesis`  — an open assumption under test; resolves into a decision when
#                   evidence accumulates or the assumption is refuted.
#   `stakeholder` — one entry per person the team coordinates with; tracks their
#                   asks, concerns, and decision affinity over time.
LEGAL_TYPES=(decision hypothesis stakeholder)
# Ingestion source kinds — looser than entry types because the working layer is
# looser than the durable layer. Add freely as new artifact shapes show up.
LEGAL_INGESTION_KINDS=(interview meeting doc screenshot dashboard chat other)

REQUIRED_FIELDS=(id title date status confidence source_role sourcing type scope affected_areas decision)
OPTIONAL_FIELDS=(alternatives_considered rejected_reason evidence supersedes superseded_by review_after session_id)
# Body sections depend on `type`. All lists have six entries; the validator
# picks one based on the entry's type frontmatter (with `decision` as the
# fallback when type is missing — that failure is caught by REQUIRED_FIELDS).
REQUIRED_SECTIONS_DECISION=("## Diagnosis" "## Decision" "## Coherent actions" "## Alternatives rejected" "## Validation plan" "## Notes")
REQUIRED_SECTIONS_HYPOTHESIS=("## Assumption" "## Prediction" "## Falsifier" "## Evidence Log" "## Resolution" "## Notes")
REQUIRED_SECTIONS_STAKEHOLDER=("## Role & influence" "## Open asks" "## Concerns" "## Last contact" "## Decision affinity" "## Notes")

# ─── helpers ──────────────────────────────────────────────────────────

usage() {
  cat <<'EOF'
chronicle.sh — Hornero Chronicle CLI

Usage:
  scripts/chronicle.sh propose   --title ... --topic ... --status ... [--confidence N] \
                                  --source-role ROLE --sourcing VALUE [--type TYPE] \
                                  --scope a,b --affected-areas a,b \
                                  --decision "..." [--alternatives "..."] \
                                  [--rejected-reason "..."] [--validation "..."] \
                                  [--evidence id1,id2] [--supersedes ID] \
                                  [--review-after YYYY-MM-DD] [--session-id ID] \
                                  [--diagnosis "..."] [--coherent-actions "..."] \
                                  [--assumption "..."] [--prediction "..."] \
                                  [--falsifier "..."] [--evidence-log "..."] \
                                  [--resolution "..."] \
                                  [--role-influence "..."] [--open-asks "..."] \
                                  [--concerns "..."] [--last-contact "..."] \
                                  [--decision-affinity "..."]
                                  # sourcing ∈ {documented, verbal, intuition, industry} —
                                  # the weakest source the decision rests on.
                                  # type ∈ {decision, hypothesis, stakeholder} — default decision.
                                  # Hypothesis flags scaffold the assumption-under-test body;
                                  # stakeholder flags scaffold a per-person profile.
  scripts/chronicle.sh ingest    --path FILE --source-role ROLE --sourcing VALUE \
                                  [--kind KIND] [--title "..."]
                                  # Copies FILE to chronicle/source/<uuid>.<ext> (gitignored)
                                  # and creates a synthesis stub under
                                  # chronicle/ingestion/<date>-<slug>.md for the agent to fill in.
                                  # kind ∈ {interview, meeting, doc, screenshot, dashboard, chat, other}.
  scripts/chronicle.sh commit    <proposal-uuid-or-path>
  scripts/chronicle.sh query     [--topic SLUG] [--scope TAG] [--role NAME] \
                                  [--status NAME] [--sourcing NAME] [--type NAME] \
                                  [--keyword WORD] [--limit N]
  scripts/chronicle.sh summary
  scripts/chronicle.sh validate  [path...]   # defaults to all entries
  scripts/chronicle.sh review                # weekly health sweep — six structured checks
  scripts/chronicle.sh --help
EOF
}

die() { echo "✗ $*" >&2; exit 1; }
log() { echo "$*" >&2; }

contains() {
  local needle="$1"; shift
  local x; for x in "$@"; do [[ "$x" == "$needle" ]] && return 0; done
  return 1
}

# slug: lowercase, alnum-and-dash only, collapse runs of dashes, trim
slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' \
    | cut -c1-80
}

uuid() {
  if command -v uuidgen >/dev/null 2>&1; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    # POSIX fallback — not RFC4122 but unique enough for proposal naming
    printf '%s-%s' "$(date -u +%Y%m%d%H%M%S)" "$RANDOM$RANDOM"
  fi
}

iso_date() { date -u +%Y-%m-%d; }

# extract a single-line frontmatter scalar
fm_scalar() {
  local field="$1" file="$2"
  awk -v field="^${field}:" '
    /^---$/ { c++; next }
    c==1 && $0 ~ field { sub(field"[[:space:]]*", ""); gsub(/^"|"$/, ""); print; exit }
  ' "$file"
}

# extract a YAML list field (inline `[a, b]`) and emit comma-joined, quotes stripped
fm_list() {
  local field="$1" file="$2"
  awk -v field="^${field}:" '
    /^---$/ { c++; next }
    c==1 && $0 ~ field {
      sub(field"[[:space:]]*", "")
      gsub(/^\[|\]$/, "")
      gsub(/"/, "")
      gsub(/, */, ",")
      gsub(/^ +| +$/, "")
      print; exit
    }
  ' "$file"
}

# ─── propose ──────────────────────────────────────────────────────────

cmd_propose() {
  local title="" topic="" status="open" confidence="0.50" source_role="" sourcing="" type="decision"
  local scope="" affected_areas="" decision="" alternatives="" rejected_reason=""
  local validation="" evidence="" supersedes="" review_after="" session_id=""
  local diagnosis="" coherent_actions=""
  local assumption="" prediction="" falsifier="" evidence_log="" resolution=""
  local role_influence="" open_asks="" concerns="" last_contact="" decision_affinity=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --title)             title="$2"; shift 2 ;;
      --topic)             topic="$2"; shift 2 ;;
      --status)            status="$2"; shift 2 ;;
      --confidence)        confidence="$2"; shift 2 ;;
      --source-role)       source_role="$2"; shift 2 ;;
      --sourcing)        sourcing="$2"; shift 2 ;;
      --type)              type="$2"; shift 2 ;;
      --scope)             scope="$2"; shift 2 ;;
      --affected-areas)    affected_areas="$2"; shift 2 ;;
      --decision)          decision="$2"; shift 2 ;;
      --alternatives)      alternatives="$2"; shift 2 ;;
      --rejected-reason)   rejected_reason="$2"; shift 2 ;;
      --validation)        validation="$2"; shift 2 ;;
      --evidence)          evidence="$2"; shift 2 ;;
      --supersedes)        supersedes="$2"; shift 2 ;;
      --review-after)      review_after="$2"; shift 2 ;;
      --session-id)        session_id="$2"; shift 2 ;;
      --diagnosis)         diagnosis="$2"; shift 2 ;;
      --coherent-actions)  coherent_actions="$2"; shift 2 ;;
      --assumption)        assumption="$2"; shift 2 ;;
      --prediction)        prediction="$2"; shift 2 ;;
      --falsifier)         falsifier="$2"; shift 2 ;;
      --evidence-log)      evidence_log="$2"; shift 2 ;;
      --resolution)        resolution="$2"; shift 2 ;;
      --role-influence)    role_influence="$2"; shift 2 ;;
      --open-asks)         open_asks="$2"; shift 2 ;;
      --concerns)          concerns="$2"; shift 2 ;;
      --last-contact)      last_contact="$2"; shift 2 ;;
      --decision-affinity) decision_affinity="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown propose flag: $1" ;;
    esac
  done

  [[ -n "$title" ]]            || die "propose requires --title"
  [[ -n "$decision" ]]         || die "propose requires --decision (one-sentence claim, used as the index-friendly copy regardless of type)"
  [[ -n "$source_role" ]]      || die "propose requires --source-role"
  [[ -n "$sourcing" ]]       || die "propose requires --sourcing (one of: ${LEGAL_SOURCING[*]})"
  [[ -n "$scope" ]]            || die "propose requires --scope"
  [[ -n "$affected_areas" ]]   || die "propose requires --affected-areas"

  contains "$status" "${LEGAL_STATUSES[@]}" || die "status must be one of: ${LEGAL_STATUSES[*]}"
  contains "$source_role" "${LEGAL_ROLES[@]}" || die "source_role must be one of: ${LEGAL_ROLES[*]}"
  contains "$sourcing" "${LEGAL_SOURCING[@]}" || die "sourcing must be one of: ${LEGAL_SOURCING[*]}"
  contains "$type" "${LEGAL_TYPES[@]}" || die "type must be one of: ${LEGAL_TYPES[*]}"

  # Confidence must be a number in [0,1]
  if ! awk -v c="$confidence" 'BEGIN { if (c+0 < 0 || c+0 > 1) exit 1 }'; then
    die "confidence must be a number in [0, 1] (got: ${confidence})"
  fi

  mkdir -p "$PROPOSALS_DIR"
  local proposal_id; proposal_id="$(uuid)"
  local proposal_path="${PROPOSALS_DIR}/${proposal_id}.md"

  local today; today="$(iso_date)"
  local slug; slug="$(slugify "$title")"
  local final_id="${today}-${slug}"

  yaml_list() {
    local raw="$1"
    [[ -z "$raw" ]] && { printf '[]'; return; }
    printf '['
    local first=1 item
    IFS=',' read -ra arr <<<"$raw"
    for item in "${arr[@]}"; do
      item="${item#"${item%%[![:space:]]*}"}"
      item="${item%"${item##*[![:space:]]}"}"
      [[ $first -eq 1 ]] || printf ', '
      printf '%s' "\"${item}\""
      first=0
    done
    printf ']'
  }

  {
    echo "---"
    echo "id: ${final_id}"
    echo "title: ${title}"
    echo "date: ${today}"
    echo "status: ${status}"
    echo "confidence: ${confidence}"
    echo "source_role: ${source_role}"
    echo "sourcing: ${sourcing}"
    echo "type: ${type}"
    echo "scope: $(yaml_list "$scope")"
    echo "affected_areas: $(yaml_list "$affected_areas")"
    echo "decision: ${decision}"
    [[ -n "$alternatives" ]]      && echo "alternatives_considered: $(yaml_list "$alternatives")"
    [[ -n "$rejected_reason" ]]   && echo "rejected_reason: $(yaml_list "$rejected_reason")"
    [[ -n "$evidence" ]]          && echo "evidence: $(yaml_list "$evidence")"
    [[ -n "$supersedes" ]]        && echo "supersedes: ${supersedes}"
    [[ -n "$review_after" ]]      && echo "review_after: ${review_after}"
    [[ -n "$session_id" ]]        && echo "session_id: ${session_id}"
    echo "---"
    echo
    if [[ "$type" == "hypothesis" ]]; then
      echo "## Assumption"
      echo
      echo "${assumption:-${decision}}"
      echo
      echo "## Prediction"
      echo
      echo "${prediction:-_TODO: what we expect to observe if the assumption holds. Be specific enough to verify._}"
      echo
      echo "## Falsifier"
      echo
      echo "${falsifier:-_TODO: the observation that would refute this hypothesis. If none comes to mind, the hypothesis is not testable yet._}"
      echo
      echo "## Evidence Log"
      echo
      echo "${evidence_log:-_TODO: append-only rows as evidence accumulates. Each row: dash-space, ISO date, em-dash, sourcing enum, em-dash, observation._}"
      echo
      echo "## Resolution"
      echo
      echo "${resolution:-_Open. Link to the decision entry that resolves this hypothesis once one exists._}"
      echo
      echo "## Notes"
      echo
    elif [[ "$type" == "stakeholder" ]]; then
      echo "## Role & influence"
      echo
      echo "${role_influence:-_TODO: their role, who they report to, and where their decision influence is strongest._}"
      echo
      echo "## Open asks"
      echo
      echo "${open_asks:-_TODO: append-only rows as new asks arrive. Each row: dash-space, ISO date, em-dash, the ask, em-dash, source._}"
      echo
      echo "## Concerns"
      echo
      echo "${concerns:-_TODO: what they are worried about, with a date when each concern was surfaced._}"
      echo
      echo "## Last contact"
      echo
      echo "${last_contact:-_TODO: ISO date and a one-line summary of the most recent conversation._}"
      echo
      echo "## Decision affinity"
      echo
      echo "${decision_affinity:-_TODO: what they will reliably support, what they will reliably oppose, and where they are neutral but vocal._}"
      echo
      echo "## Notes"
      echo
    else
      echo "## Diagnosis"
      echo
      echo "${diagnosis:-_TODO: name the central challenge the decision is responding to._}"
      echo
      echo "## Decision"
      echo
      echo "${decision}"
      echo
      echo "## Coherent actions"
      echo
      echo "${coherent_actions:-_TODO: bulleted resource-allocation steps that operationalise the decision._}"
      echo
      echo "## Alternatives rejected"
      echo
      if [[ -n "$alternatives" ]]; then
        IFS=',' read -ra alts <<<"$alternatives"
        IFS=',' read -ra reasons <<<"$rejected_reason"
        local i=0
        for alt in "${alts[@]}"; do
          local reason="${reasons[$i]:-unspecified}"
          echo "- **${alt# }** — ${reason# }"
          i=$((i+1))
        done
      else
        echo "_TODO: list every alternative seriously considered, with one reason each._"
      fi
      echo
      echo "## Validation plan"
      echo
      echo "${validation:-_TODO: observable signals that will confirm or refute this decision._}"
      echo
      echo "## Notes"
      echo
    fi
  } > "$proposal_path"

  log "↪ wrote proposal: ${proposal_path}"
  log "  final id on commit will be: ${final_id}"
  log "  next: edit the file if needed, then run:"
  log "    scripts/chronicle.sh commit ${proposal_id}"

  echo "$proposal_id"
}

# ─── commit ───────────────────────────────────────────────────────────

cmd_commit() {
  local arg="${1:-}"
  [[ -n "$arg" ]] || die "commit requires a proposal uuid or path"

  local proposal_path
  if [[ -f "$arg" ]]; then
    proposal_path="$arg"
  elif [[ -f "${PROPOSALS_DIR}/${arg}.md" ]]; then
    proposal_path="${PROPOSALS_DIR}/${arg}.md"
  else
    die "proposal not found: ${arg}"
  fi

  local final_id; final_id="$(fm_scalar id "$proposal_path")"
  [[ -n "$final_id" ]] || die "proposal missing id field"

  local target="${ENTRIES_DIR}/${final_id}.md"
  [[ -f "$target" ]] && die "entry already exists: ${target}"

  mkdir -p "$ENTRIES_DIR"
  cp "$proposal_path" "$target"

  # Validate the would-be entry. On failure, remove the copy and bail.
  if ! validate_one "$target" >&2; then
    rm -f "$target"
    die "validation failed; entry not committed"
  fi

  # Handle supersedes: flip the predecessor's status to superseded + set superseded_by
  local pred; pred="$(fm_scalar supersedes "$target")"
  if [[ -n "$pred" ]]; then
    local pred_path="${ENTRIES_DIR}/${pred}.md"
    [[ -f "$pred_path" ]] || die "supersedes target not found: ${pred}"
    # in-place mutation: status → superseded; add superseded_by if absent
    awk -v new_id="$final_id" '
      BEGIN { in_fm = 0; fm_count = 0; sb_set = 0 }
      /^---$/ { fm_count++; if (fm_count == 1) in_fm = 1; else in_fm = 0; print; next }
      in_fm && /^status:/ { print "status: superseded"; next }
      in_fm && /^superseded_by:/ { print "superseded_by: " new_id; sb_set = 1; next }
      { print }
      END { }
    ' "$pred_path" > "${pred_path}.tmp"
    if ! grep -q '^superseded_by:' "${pred_path}.tmp"; then
      awk -v new_id="$final_id" '
        /^---$/ { c++; if (c == 2) { print "superseded_by: " new_id } print; next }
        { print }
      ' "${pred_path}.tmp" > "${pred_path}.tmp2"
      mv "${pred_path}.tmp2" "${pred_path}.tmp"
    fi
    mv "${pred_path}.tmp" "$pred_path"
    log "  ↪ predecessor ${pred} flipped to superseded"
  fi

  rm -f "$proposal_path"
  log "✓ committed: ${target}"

  cmd_summary
}

# ─── validate ─────────────────────────────────────────────────────────

validate_one() {
  local file="$1"
  local rel="${file#$ROOT/}"
  local fail=0

  if [[ ! -f "$file" ]]; then
    echo "  ✗ ${rel}: file not found"; return 1
  fi

  if ! head -1 "$file" | grep -q '^---$'; then
    echo "  ✗ ${rel}: missing frontmatter (must start with ---)"; fail=1
  fi

  # Required fields
  for field in "${REQUIRED_FIELDS[@]}"; do
    if ! awk '/^---$/{c++; next} c==1' "$file" | grep -q "^${field}:"; then
      echo "  ✗ ${rel}: missing required field: ${field}"; fail=1
    fi
  done

  # Unknown fields (anything in frontmatter not in required ∪ optional, and not a comment)
  local known=(); known+=("${REQUIRED_FIELDS[@]}" "${OPTIONAL_FIELDS[@]}")
  local fm_fields
  fm_fields="$(awk '/^---$/{c++; next} c==1 && /^[a-z_]+:/{ sub(/:.*/, ""); print }' "$file")"
  for f in $fm_fields; do
    if ! contains "$f" "${known[@]}"; then
      echo "  ✗ ${rel}: unknown frontmatter field: ${f}"; fail=1
    fi
  done

  # id matches filename
  local id; id="$(fm_scalar id "$file")"
  local basename; basename="$(basename "$file" .md)"
  if [[ "$id" != "$basename" ]]; then
    echo "  ✗ ${rel}: id (${id}) does not match filename (${basename}.md)"; fail=1
  fi

  # date matches date in id
  local date_val; date_val="$(fm_scalar date "$file")"
  local id_date="${id:0:10}"
  if [[ "$date_val" != "$id_date" ]]; then
    echo "  ✗ ${rel}: date (${date_val}) does not match id-date (${id_date})"; fail=1
  fi
  if ! [[ "$date_val" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "  ✗ ${rel}: date must be ISO YYYY-MM-DD (got: ${date_val})"; fail=1
  fi

  # status in legal set
  local status; status="$(fm_scalar status "$file")"
  if ! contains "$status" "${LEGAL_STATUSES[@]}"; then
    echo "  ✗ ${rel}: status (${status}) not in ${LEGAL_STATUSES[*]}"; fail=1
  fi

  # confidence ∈ [0,1]
  local conf; conf="$(fm_scalar confidence "$file")"
  if ! awk -v c="$conf" 'BEGIN { if (c+0 < 0 || c+0 > 1 || c == "") exit 1 }'; then
    echo "  ✗ ${rel}: confidence (${conf}) must be a number in [0, 1]"; fail=1
  fi

  # source_role in legal set
  local role; role="$(fm_scalar source_role "$file")"
  if ! contains "$role" "${LEGAL_ROLES[@]}"; then
    echo "  ✗ ${rel}: source_role (${role}) not in ${LEGAL_ROLES[*]}"; fail=1
  fi

  # sourcing in legal set
  local prov; prov="$(fm_scalar sourcing "$file")"
  if [[ -n "$prov" ]] && ! contains "$prov" "${LEGAL_SOURCING[@]}"; then
    echo "  ✗ ${rel}: sourcing (${prov}) not in ${LEGAL_SOURCING[*]}"; fail=1
  fi

  # type in legal set (missing required is already caught above)
  local type_v; type_v="$(fm_scalar type "$file")"
  if [[ -n "$type_v" ]] && ! contains "$type_v" "${LEGAL_TYPES[@]}"; then
    echo "  ✗ ${rel}: type (${type_v}) not in ${LEGAL_TYPES[*]}"; fail=1
  fi

  # Required sections present, in order — branch on type
  local -a sections
  case "$type_v" in
    hypothesis)  sections=("${REQUIRED_SECTIONS_HYPOTHESIS[@]}") ;;
    stakeholder) sections=("${REQUIRED_SECTIONS_STAKEHOLDER[@]}") ;;
    *)           sections=("${REQUIRED_SECTIONS_DECISION[@]}") ;;
  esac
  local found_idx=0
  while IFS= read -r line; do
    if [[ "$line" == "${sections[$found_idx]}" ]]; then
      found_idx=$((found_idx + 1))
      [[ $found_idx -eq ${#sections[@]} ]] && break
    fi
  done < "$file"
  if [[ $found_idx -lt ${#sections[@]} ]]; then
    echo "  ✗ ${rel}: required sections missing or out of order. Expected (in order): ${sections[*]}"; fail=1
  fi

  # Evidence IDs resolve (only if entries dir exists and we're validating from there)
  local evidence; evidence="$(fm_list evidence "$file")"
  if [[ -n "$evidence" ]]; then
    IFS=',' read -ra ids <<<"$evidence"
    for eid in "${ids[@]}"; do
      eid="${eid//\"/}"
      eid="${eid// /}"
      [[ -z "$eid" ]] && continue
      # check sibling entries dir of the file, falls back to default entries dir
      local entries_dir; entries_dir="$(dirname "$file")"
      if [[ ! -f "${entries_dir}/${eid}.md" ]]; then
        echo "  ✗ ${rel}: evidence id (${eid}) does not resolve in $(realpath --relative-to="$ROOT" "$entries_dir" 2>/dev/null || basename "$entries_dir")"
        fail=1
      fi
    done
  fi

  return $fail
}

cmd_validate() {
  local files=()
  if [[ $# -gt 0 ]]; then
    files=("$@")
  else
    if [[ -d "$ENTRIES_DIR" ]]; then
      while IFS= read -r f; do
        files+=("$f")
      done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -type f | sort)
    fi
  fi

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "✓ no chronicle entries to validate (skipping)"
    return 0
  fi

  local total=0 fail_count=0
  for f in "${files[@]}"; do
    total=$((total + 1))
    if ! validate_one "$f"; then
      fail_count=$((fail_count + 1))
    fi
  done

  if [[ $fail_count -eq 0 ]]; then
    echo "✓ chronicle: ${total} entries valid"
    return 0
  else
    echo "✗ chronicle: ${fail_count}/${total} entries failed validation" >&2
    return 1
  fi
}

# ─── query ────────────────────────────────────────────────────────────

cmd_query() {
  local topic="" scope="" role="" status="" sourcing="" type="" keyword=""
  local limit=50

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic)       topic="$2"; shift 2 ;;
      --scope)       scope="$2"; shift 2 ;;
      --role)        role="$2"; shift 2 ;;
      --status)      status="$2"; shift 2 ;;
      --sourcing)  sourcing="$2"; shift 2 ;;
      --type)        type="$2"; shift 2 ;;
      --keyword)     keyword="$2"; shift 2 ;;
      --limit)       limit="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown query flag: $1" ;;
    esac
  done

  local matches=()
  if [[ -d "$ENTRIES_DIR" ]]; then
    while IFS= read -r f; do
      [[ -f "$f" ]] || continue
      local id; id="$(fm_scalar id "$f")"
      local title; title="$(fm_scalar title "$f")"
      local date_v; date_v="$(fm_scalar date "$f")"
      local s_role; s_role="$(fm_scalar source_role "$f")"
      local s_status; s_status="$(fm_scalar status "$f")"
      local s_prov; s_prov="$(fm_scalar sourcing "$f")"
      local s_type; s_type="$(fm_scalar type "$f")"
      local s_scope; s_scope="$(fm_list scope "$f")"

      [[ -n "$role" && "$s_role" != "$role" ]] && continue
      [[ -n "$status" && "$s_status" != "$status" ]] && continue
      [[ -n "$sourcing" && "$s_prov" != "$sourcing" ]] && continue
      [[ -n "$type" && "$s_type" != "$type" ]] && continue
      [[ -n "$scope" && ",${s_scope}," != *",${scope},"* ]] && continue
      if [[ -n "$topic" ]]; then
        # Topic is a hint-tag — match against id or any scope tag (substring on id)
        if [[ "$id" != *"$topic"* && ",${s_scope}," != *",${topic},"* ]]; then
          continue
        fi
      fi
      if [[ -n "$keyword" ]]; then
        if ! grep -qiF -- "$keyword" "$f"; then
          continue
        fi
      fi

      # Build a sort key: date_desc, id_asc → "9999-MM-DD - DATE | ID"
      local inverted; inverted="$(awk -v d="$date_v" 'BEGIN {
        split(d, parts, "-");
        y = 9999 - parts[1]; m = 99 - parts[2]; day = 99 - parts[3];
        printf "%04d-%02d-%02d", y, m, day
      }')"
      matches+=("${inverted}|${id}|${date_v}|${s_status}|${s_type}|${s_role}|${s_prov}|${s_scope}|${title}")
    done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -type f | sort)
  fi

  # Deterministic sort
  local sorted=()
  if [[ ${#matches[@]} -gt 0 ]]; then
    while IFS= read -r line; do sorted+=("$line"); done < <(printf '%s\n' "${matches[@]}" | sort)
  fi

  # Emit fixed-shape Markdown
  echo "# Chronicle query"
  echo ""
  echo "Filters: topic=${topic:-*} scope=${scope:-*} role=${role:-*} status=${status:-*} sourcing=${sourcing:-*} type=${type:-*} keyword=${keyword:-*} limit=${limit}"
  echo ""
  local count=0
  if [[ ${#sorted[@]} -eq 0 ]]; then
    echo "No matches."
    return 0
  fi
  echo "| date | id | type | status | role | sourcing | scope | title |"
  echo "|---|---|---|---|---|---|---|---|"
  for line in "${sorted[@]}"; do
    [[ $count -ge $limit ]] && break
    IFS='|' read -r _inv id date_v status_v type_v role_v prov_v scope_v title <<<"$line"
    echo "| ${date_v} | ${id} | ${type_v} | ${status_v} | ${role_v} | ${prov_v} | ${scope_v} | ${title} |"
    count=$((count + 1))
  done
  echo ""
  echo "${count} match(es)."
}

# ─── summary ──────────────────────────────────────────────────────────

cmd_summary() {
  local entries=()
  if [[ -d "$ENTRIES_DIR" ]]; then
    while IFS= read -r f; do
      entries+=("$f")
    done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -type f | sort -r)
  fi

  {
    echo "# Chronicle — Summary"
    echo ""
    echo "> Auto-regenerated by \`scripts/chronicle.sh summary\`. Do not hand-edit. To change an entry, edit its file under \`chronicle/entries/\` and rerun the command."
    echo ""
    if [[ ${#entries[@]} -eq 0 ]]; then
      echo "_No entries yet. This file is regenerated when the first decision is committed._"
      echo ""
      echo "## How to read this"
      echo ""
      echo "Each section below lists committed decisions, newest first. Rows show: \`id\`, status, source role, scope tags, one-line decision. Click any \`id\` to read the full entry. \`chronicle-recall\` performs filtered queries; this file is the cold-start digest."
      echo ""
      echo "## Index"
      echo ""
      echo "_(empty)_"
    else
      echo "## How to read this"
      echo ""
      echo "Newest first. Each row links to the full entry under \`chronicle/entries/\`. Use \`scripts/chronicle.sh query\` for filtered access."
      echo ""
      echo "## Index"
      echo ""
      echo "| date | id | type | status | role | sourcing | scope | title |"
      echo "|---|---|---|---|---|---|---|---|"
      for f in "${entries[@]}"; do
        local id; id="$(fm_scalar id "$f")"
        local title; title="$(fm_scalar title "$f")"
        local date_v; date_v="$(fm_scalar date "$f")"
        local s_role; s_role="$(fm_scalar source_role "$f")"
        local s_status; s_status="$(fm_scalar status "$f")"
        local s_prov; s_prov="$(fm_scalar sourcing "$f")"
        local s_type; s_type="$(fm_scalar type "$f")"
        local s_scope; s_scope="$(fm_list scope "$f")"
        echo "| ${date_v} | [\`${id}\`](entries/${id}.md) | ${s_type} | ${s_status} | ${s_role} | ${s_prov} | ${s_scope} | ${title} |"
      done
    fi
  } > "$SUMMARY_FILE"

  log "✓ regenerated ${SUMMARY_FILE#$ROOT/} (${#entries[@]} entries)"
}

# ─── ingest ──────────────────────────────────────────────────────────

cmd_ingest() {
  local path="" kind="other" source_role="" sourcing="" title=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --path)         path="$2"; shift 2 ;;
      --kind)         kind="$2"; shift 2 ;;
      --source-role)  source_role="$2"; shift 2 ;;
      --sourcing)     sourcing="$2"; shift 2 ;;
      --title)        title="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown ingest flag: $1" ;;
    esac
  done

  [[ -n "$path" ]]         || die "ingest requires --path <file>"
  [[ -f "$path" ]]         || die "ingest: file not found: $path"
  [[ -n "$source_role" ]]  || die "ingest requires --source-role"
  [[ -n "$sourcing" ]]     || die "ingest requires --sourcing (one of: ${LEGAL_SOURCING[*]})"

  contains "$source_role" "${LEGAL_ROLES[@]}" || die "source_role must be one of: ${LEGAL_ROLES[*]}"
  contains "$sourcing" "${LEGAL_SOURCING[@]}" || die "sourcing must be one of: ${LEGAL_SOURCING[*]}"
  contains "$kind" "${LEGAL_INGESTION_KINDS[@]}" || die "kind must be one of: ${LEGAL_INGESTION_KINDS[*]}"

  # Title defaults to filename sans extension
  if [[ -z "$title" ]]; then
    title="$(basename "$path")"
    title="${title%.*}"
  fi

  mkdir -p "$INGESTION_DIR" "$SOURCE_DIR"

  local today; today="$(iso_date)"
  local slug; slug="$(slugify "$title")"
  local id="${today}-${slug}"
  local target="${INGESTION_DIR}/${id}.md"
  [[ -f "$target" ]] && die "ingestion stub already exists: ${target} (rename via --title to disambiguate)"

  # Preserve raw under chronicle/source/<uuid>.<ext>
  local ext="${path##*.}"
  [[ "$ext" == "$path" ]] && ext="txt"   # no extension → call it txt
  local src_uuid; src_uuid="$(uuid)"
  local source_target="${SOURCE_DIR}/${src_uuid}.${ext}"
  cp "$path" "$source_target"

  # The source_path field stays relative to repo root so the synthesis is portable
  local rel_source="chronicle/source/${src_uuid}.${ext}"

  {
    echo "---"
    echo "id: ${id}"
    echo "title: ${title}"
    echo "date: ${today}"
    echo "source_path: ${rel_source}"
    echo "source_kind: ${kind}"
    echo "source_role: ${source_role}"
    echo "sourcing: ${sourcing}"
    echo "---"
    echo
    echo "## Summary"
    echo
    echo "_TODO: 1-3 sentences distilling the artifact._"
    echo
    echo "## Observations"
    echo
    echo "_TODO: bulleted observations. Tag each inline with a sourcing label \`[documented]\`, \`[verbal]\`, \`[intuition]\`, or \`[industry]\` so the entry's overall sourcing field can be derived from the weakest tag below._"
    echo
    echo "## Implications"
    echo
    echo "_TODO: which chronicle entries (decisions, hypotheses, stakeholders) does this update? Propose with \`scripts/chronicle.sh propose ...\` when appropriate; link supersedes when this refutes a prior entry._"
    echo
    echo "## Notes"
    echo
  } > "$target"

  log "↪ ingested: ${path}"
  log "  source preserved: ${source_target} (gitignored)"
  log "  synthesis stub:   ${target}"
  log "  next: open the stub, fill in the body, then propose any chronicle entries it implies."

  echo "$target"
}

# ─── review ──────────────────────────────────────────────────────────
#
# Six chronicle-health checks. Each emits a Markdown section; either a
# bulleted list of findings or a single "OK" line. The output is consumed
# by the /review skill, which decides which findings to act on directly
# (e.g. propose a status change) and which to surface for a human call.

# entry-iteration helper: print "<file>\t<id>\t<type>\t<status>\t<review_after>\t<sourcing>"
# for every committed entry. Empty lines for missing fields.
_review_iter() {
  [[ -d "$ENTRIES_DIR" ]] || return 0
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$f" \
      "$(fm_scalar id "$f")" \
      "$(fm_scalar type "$f")" \
      "$(fm_scalar status "$f")" \
      "$(fm_scalar review_after "$f")" \
      "$(fm_scalar sourcing "$f")"
  done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -type f | sort)
}

cmd_review() {
  local today; today="$(iso_date)"
  echo "# Chronicle review — ${today}"
  echo
  echo "> Output of \`scripts/chronicle.sh review\`. Six health checks across the chronicle layer. The \`/review\` skill consumes this report and decides which findings to act on directly versus surface for a human call."
  echo

  # ── 1. Hypotheses past review_after still open ─────────────────────
  echo "## 1. Stale hypotheses (review_after passed, status still open)"
  echo
  local found=0
  while IFS=$'\t' read -r file id type status review_after sourcing; do
    [[ "$type" == "hypothesis" ]] || continue
    [[ "$status" == "open" ]] || continue
    [[ -n "$review_after" ]] || continue
    if [[ "$review_after" < "$today" ]]; then
      local title; title="$(fm_scalar title "$file")"
      echo "- \`${id}\` — review_after was ${review_after}; status still \`open\`. Title: ${title}"
      found=1
    fi
  done < <(_review_iter)
  [[ $found -eq 0 ]] && echo "OK — no stale hypotheses."
  echo

  # ── 2. Validated decisions whose review_after has passed ──────────
  echo "## 2. Decisions overdue for revisit (status validated, review_after passed)"
  echo
  found=0
  while IFS=$'\t' read -r file id type status review_after sourcing; do
    [[ "$type" == "decision" ]] || continue
    [[ "$status" == "validated" ]] || continue
    [[ -n "$review_after" ]] || continue
    if [[ "$review_after" < "$today" ]]; then
      local title; title="$(fm_scalar title "$file")"
      echo "- \`${id}\` — review_after was ${review_after}; still \`validated\` without a fresh revisit. Title: ${title}"
      found=1
    fi
  done < <(_review_iter)
  [[ $found -eq 0 ]] && echo "OK — no overdue decisions."
  echo

  # ── 3. Stakeholders not contacted in >60 days ─────────────────────
  echo "## 3. Stale stakeholder contact (no Last contact update in 60+ days)"
  echo
  found=0
  while IFS=$'\t' read -r file id type status review_after sourcing; do
    [[ "$type" == "stakeholder" ]] || continue
    # Parse first ISO date in the Last contact section
    local last
    last="$(awk '
      /^## Last contact[[:space:]]*$/ { in_sec = 1; next }
      in_sec && /^## / { exit }
      in_sec {
        if (match($0, /[0-9]{4}-[0-9]{2}-[0-9]{2}/)) {
          print substr($0, RSTART, RLENGTH); exit
        }
      }
    ' "$file")"
    if [[ -z "$last" ]]; then
      local title; title="$(fm_scalar title "$file")"
      echo "- \`${id}\` — no parseable date in \`## Last contact\`. Title: ${title}"
      found=1
      continue
    fi
    # macOS BSD date math
    local last_epoch today_epoch days
    last_epoch="$(date -j -f "%Y-%m-%d" "${last}" "+%s" 2>/dev/null || echo "")"
    today_epoch="$(date -j -f "%Y-%m-%d" "${today}" "+%s" 2>/dev/null || echo "")"
    if [[ -z "$last_epoch" || -z "$today_epoch" ]]; then continue; fi
    days=$(( (today_epoch - last_epoch) / 86400 ))
    if [[ $days -ge 60 ]]; then
      local title; title="$(fm_scalar title "$file")"
      echo "- \`${id}\` — last contact ${last} (${days} days ago). Title: ${title}"
      found=1
    fi
  done < <(_review_iter)
  [[ $found -eq 0 ]] && echo "OK — every stakeholder has been touched in the last 60 days."
  echo

  # ── 4. Thin sourcing on validated entries ─────────────────────────
  echo "## 4. Thin sourcing on validated entries (sourcing ∈ {intuition, industry})"
  echo
  found=0
  while IFS=$'\t' read -r file id type status review_after sourcing; do
    [[ "$status" == "validated" ]] || continue
    if [[ "$sourcing" == "intuition" || "$sourcing" == "industry" ]]; then
      local title; title="$(fm_scalar title "$file")"
      echo "- \`${id}\` — \`status: validated\` rests on \`sourcing: ${sourcing}\`. Title: ${title}"
      found=1
    fi
  done < <(_review_iter)
  [[ $found -eq 0 ]] && echo "OK — every validated entry rests on \`documented\` or \`verbal\` sourcing."
  echo

  # ── 5. Supersedes chain integrity ─────────────────────────────────
  echo "## 5. Supersedes chain integrity (broken predecessor or successor links)"
  echo
  found=0
  while IFS=$'\t' read -r file id type status review_after sourcing; do
    local pred; pred="$(fm_scalar supersedes "$file")"
    if [[ -n "$pred" ]]; then
      if [[ ! -f "${ENTRIES_DIR}/${pred}.md" ]]; then
        echo "- \`${id}\` — \`supersedes: ${pred}\` but \`${pred}.md\` does not exist."
        found=1
      else
        # The predecessor should carry superseded_by pointing back
        local back; back="$(fm_scalar superseded_by "${ENTRIES_DIR}/${pred}.md")"
        if [[ "$back" != "$id" ]]; then
          echo "- \`${pred}\` — superseded by \`${id}\` but its \`superseded_by\` field is \`${back:-<unset>}\`. Mismatch."
          found=1
        fi
      fi
    fi
    local sb; sb="$(fm_scalar superseded_by "$file")"
    if [[ -n "$sb" ]]; then
      if [[ ! -f "${ENTRIES_DIR}/${sb}.md" ]]; then
        echo "- \`${id}\` — \`superseded_by: ${sb}\` but \`${sb}.md\` does not exist."
        found=1
      fi
    fi
  done < <(_review_iter)
  [[ $found -eq 0 ]] && echo "OK — every supersedes chain links both directions."
  echo

  # ── 6. Scope-tag entropy (tags used by only one entry) ────────────
  echo "## 6. Scope-tag entropy (tags used by exactly one entry — candidates to merge)"
  echo
  if [[ -d "$ENTRIES_DIR" ]]; then
    # Aggregate scope tags across entries, count occurrences
    local tmp; tmp="$(mktemp)"
    while IFS= read -r f; do
      [[ -f "$f" ]] || continue
      local s; s="$(fm_list scope "$f")"
      [[ -z "$s" ]] && continue
      printf '%s\n' "$s" | tr ',' '\n' | sed -E 's/^ +| +$//g; /^$/d'
    done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -type f | sort) > "$tmp"
    local singletons
    singletons="$(sort "$tmp" | uniq -c | awk '$1 == 1 {print $2}' | sort)"
    rm -f "$tmp"
    if [[ -z "$singletons" ]]; then
      echo "OK — every scope tag is used by at least two entries."
    else
      while IFS= read -r tag; do
        echo "- \`${tag}\` — used by exactly one entry. Consider merging into an existing tag or accepting as singleton."
      done <<<"$singletons"
    fi
  else
    echo "OK — no chronicle directory yet."
  fi
  echo
  echo "---"
  echo
  echo "Run \`/review\` to act on these findings; the agent will propose chronicle entry updates for the unambiguous fixes and surface the rest for a human call."
}

# ─── arg parsing ─────────────────────────────────────────────────────

case "${1:-}" in
  ""|-h|--help) usage; exit 0 ;;
  propose)  shift; cmd_propose "$@" ;;
  commit)   shift; cmd_commit "$@" ;;
  ingest)   shift; cmd_ingest "$@" ;;
  query)    shift; cmd_query "$@" ;;
  summary)  shift; cmd_summary ;;
  validate) shift; cmd_validate "$@" ;;
  review)   shift; cmd_review ;;
  *) die "unknown subcommand: $1 (see --help)" ;;
esac
