#!/usr/bin/env bash
# score.sh — interactive scoring + aggregation for multi-role-review evals.
#
# Per-run scoring (human): walks the four rubric dimensions interactively,
# writes evals/runs/<task-slug>/score_human.json.
# (Legacy: if score.json exists and score_human.json does not, score.json
# is read as a human score for backward compatibility.)
#
# Per-run scoring (LLM judge): delegates to evals/judge.py, writes
# evals/runs/<task-slug>/score_llm.json.
#
# Aggregation: reads score_human.json + score_llm.json under evals/runs/,
# reports per-task means and delta (human − LLM). Flags |delta| ≥ 0.25.
# Human score takes precedence for the reported mean; LLM score is shown
# alongside for calibration.
#
# Usage:
#   ./evals/score.sh evals/runs/<task-slug>          # human score
#   ./evals/score.sh --judge evals/runs/<task-slug>  # LLM judge score
#   ./evals/score.sh --aggregate                     # aggregate both

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ─── Aggregate mode ───────────────────────────────────────────────────
# ─── Helpers ──────────────────────────────────────────────────────────

# Extract a numeric field from a score JSON file using jq (if available) or grep.
_score_field() {
  local file="$1" field="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -r ".${field} // empty" "$file" 2>/dev/null
  else
    grep -E "\"${field}\":" "$file" | sed -E 's/.*: *([0-9.]+).*/\1/' | head -1
  fi
}

# Return the authoritative human score file for a run directory.
# Prefers score_human.json; falls back to score.json (legacy).
_human_score_file() {
  local dir="$1"
  if [[ -f "${dir}/score_human.json" ]]; then echo "${dir}/score_human.json"
  elif [[ -f "${dir}/score.json" ]]; then echo "${dir}/score.json"
  else echo ""
  fi
}

# ─── Aggregate mode ───────────────────────────────────────────────────
if [[ "${1:-}" == "--aggregate" || "${1:-}" == "-a" ]]; then
  echo "Aggregating scored runs in evals/runs/..."
  echo

  if ! command -v jq >/dev/null 2>&1; then
    echo "(note: jq not found — using best-effort grep parser; install jq for robust parsing)" >&2
  fi

  # Header
  printf "%-36s %6s %6s  %s\n" "task" "human" "llm" "delta / flags"
  printf -- "%.0s-" {1..72}; echo

  total_sum=0
  total_count=0
  flag_count=0

  for run_dir in evals/runs/*/; do
    [[ -d "$run_dir" ]] || continue
    task=$(basename "$run_dir")

    human_file=$(_human_score_file "$run_dir")
    llm_file="${run_dir}score_llm.json"

    [[ -z "$human_file" && ! -f "$llm_file" ]] && continue

    human_mean=""
    llm_mean=""

    if [[ -n "$human_file" ]]; then
      c=$(_score_field "$human_file" source_citation_rate)
      d=$(_score_field "$human_file" finding_distinctness)
      f=$(_score_field "$human_file" conflict_surfacing)
      a=$(_score_field "$human_file" actionability)
      [[ -n "$c" && -n "$d" && -n "$f" && -n "$a" ]] && \
        human_mean=$(awk -v a="$c" -v b="$d" -v c="$f" -v d="$a" 'BEGIN{ printf "%.3f", (a+b+c+d)/4 }')
    fi

    if [[ -f "$llm_file" ]]; then
      c=$(_score_field "$llm_file" source_citation_rate)
      d=$(_score_field "$llm_file" finding_distinctness)
      f=$(_score_field "$llm_file" conflict_surfacing)
      a=$(_score_field "$llm_file" actionability)
      [[ -n "$c" && -n "$d" && -n "$f" && -n "$a" ]] && \
        llm_mean=$(awk -v a="$c" -v b="$d" -v c="$f" -v d="$a" 'BEGIN{ printf "%.3f", (a+b+c+d)/4 }')
    fi

    # Compute delta and flag if |delta| >= 0.25
    delta_str=""
    flag=""
    if [[ -n "$human_mean" && -n "$llm_mean" ]]; then
      delta_str=$(awk -v h="$human_mean" -v l="$llm_mean" 'BEGIN{ printf "%+.3f", h-l }')
      flag=$(awk -v h="$human_mean" -v l="$llm_mean" \
        'BEGIN{ d=h-l; if(d<0)d=-d; print (d>=0.25) ? " ← review" : "" }')
      [[ -n "$flag" ]] && flag_count=$((flag_count+1))
    fi

    printf "%-36s %6s %6s  %s%s\n" \
      "${task:0:36}" \
      "${human_mean:----}" \
      "${llm_mean:----}" \
      "${delta_str}" \
      "${flag}"

    # Accumulate using human mean if available, else LLM mean
    report_mean="${human_mean:-$llm_mean}"
    if [[ -n "$report_mean" ]]; then
      total_sum=$(awk -v s="$total_sum" -v m="$report_mean" 'BEGIN{ printf "%.6f", s+m }')
      total_count=$((total_count+1))
    fi
  done

  printf -- "%.0s-" {1..72}; echo
  if [[ $total_count -gt 0 ]]; then
    overall=$(awk -v s="$total_sum" -v n="$total_count" 'BEGIN{ printf "%.3f", s/n }')
    printf "%-36s %6s\n" "MEAN (n=$total_count)" "$overall"
    echo
    target_met=$(awk -v m="$overall" 'BEGIN{ print (m >= 0.8) ? "yes" : "no" }')
    echo "v1 target (mean ≥ 0.8 across 20 runs): $target_met"
    [[ $total_count -lt 20 ]] && echo "  (n=$total_count; target requires n≥20)"
    [[ $flag_count -gt 0 ]] && echo
    [[ $flag_count -gt 0 ]] && echo "  ← $flag_count run(s) flagged for human review (|human−llm| ≥ 0.25)"
    [[ $flag_count -gt 0 ]] && echo "    Re-score flagged runs with: ./evals/score.sh evals/runs/<task-slug>"
  else
    echo "No scored runs found under evals/runs/."
    echo "Score a run:      ./evals/score.sh evals/runs/<task-slug>"
    echo "LLM judge a run:  ./evals/score.sh --judge evals/runs/<task-slug>"
  fi
  exit 0
fi

# ─── LLM judge mode ───────────────────────────────────────────────────
if [[ "${1:-}" == "--judge" ]]; then
  shift
  RUN_DIR="${1:-}"
  if [[ -z "$RUN_DIR" ]]; then
    echo "Usage: $0 --judge evals/runs/<task-slug>" >&2
    exit 2
  fi
  exec python3 evals/judge.py "$RUN_DIR"
fi

# ─── Per-run scoring ──────────────────────────────────────────────────
RUN_DIR="${1:-}"
if [[ -z "$RUN_DIR" ]]; then
  echo "Usage:" >&2
  echo "  $0 evals/runs/<task-slug>     # score a single run" >&2
  echo "  $0 --aggregate                # aggregate across all runs" >&2
  exit 2
fi

if [[ ! -d "$RUN_DIR" ]]; then
  echo "Not a directory: $RUN_DIR" >&2
  exit 1
fi

SYNTH="$RUN_DIR/synthesis.md"
if [[ ! -f "$SYNTH" ]]; then
  echo "Missing synthesis at $SYNTH — run multi-role-review first." >&2
  exit 1
fi

TASK_SLUG=$(basename "$RUN_DIR")
SCORE_FILE="$RUN_DIR/score_human.json"

echo "Scoring run: $TASK_SLUG"
echo "Synthesis: $SYNTH ($(wc -l < "$SYNTH" | tr -d ' ') lines)"
echo
echo "Read the synthesis carefully, then score each dimension against"
echo "evals/rubric.md. Use 0, 0.25, 0.5, 0.75, or 1.0 — not finer."
echo

ask_dimension() {
  local label="$1"; local desc="$2"
  local value=""
  local rationale=""

  echo "─── $label ─────────────────────────────────────"
  echo "$desc"
  while true; do
    read -r -p "  score (0 / 0.25 / 0.5 / 0.75 / 1.0): " value
    case "$value" in
      0|0.0|0.25|0.5|0.75|1|1.0) break ;;
      *) echo "  invalid; please enter one of 0, 0.25, 0.5, 0.75, 1.0" ;;
    esac
  done
  read -r -p "  one-line rationale: " rationale

  echo "$value|$rationale"
}

CITE=$(ask_dimension "Source-citation rate" "Fraction of findings citing a named source from a role's sources.md.")
DISTINCT=$(ask_dimension "Finding distinctness" "Did each role surface non-overlapping findings?")
CONFLICT=$(ask_dimension "Conflict surfacing" "Did the synthesis name real, non-trivial conflicts between roles?")
ACTION=$(ask_dimension "Actionability" "Could a reader act on the synthesis without going back to role artifacts?")

cite_val="${CITE%%|*}";   cite_note="${CITE#*|}"
dist_val="${DISTINCT%%|*}"; dist_note="${DISTINCT#*|}"
conf_val="${CONFLICT%%|*}"; conf_note="${CONFLICT#*|}"
act_val="${ACTION%%|*}";   act_note="${ACTION#*|}"

mean=$(awk -v a="$cite_val" -v b="$dist_val" -v c="$conf_val" -v d="$act_val" 'BEGIN{ printf "%.3f", (a+b+c+d)/4 }')

cat > "$SCORE_FILE" <<EOF
{
  "task": "$TASK_SLUG",
  "scored_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "rubric_version": "v0",
  "judge": "human",
  "source_citation_rate": $cite_val,
  "source_citation_rationale": "$cite_note",
  "finding_distinctness": $dist_val,
  "finding_distinctness_rationale": "$dist_note",
  "conflict_surfacing": $conf_val,
  "conflict_surfacing_rationale": "$conf_note",
  "actionability": $act_val,
  "actionability_rationale": "$act_note",
  "mean": $mean
}
EOF

echo
echo "Wrote $SCORE_FILE"
echo "  citation:     $cite_val"
echo "  distinct:     $dist_val"
echo "  conflict:     $conf_val"
echo "  actionable:   $act_val"
echo "  mean:         $mean"
echo
echo "LLM judge this run:  ./evals/score.sh --judge $RUN_DIR"
echo "Aggregate all runs:  ./evals/score.sh --aggregate"
