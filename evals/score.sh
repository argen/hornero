#!/usr/bin/env bash
# score.sh — interactive scoring + aggregation for multi-role-review evals.
#
# Per-run scoring: walks the four rubric dimensions, asks for 0 / 0.25 / 0.5 /
# 0.75 / 1.0, captures a one-line rationale per dimension, writes
# evals/runs/<task-slug>/score.json.
#
# Aggregation: reads every score.json under evals/runs/, reports per-task
# mean and the cross-task mean (the v1 target is ≥ 0.8 across 20 tasks).
#
# Usage:
#   ./evals/score.sh evals/runs/<task-slug>     # score a single run
#   ./evals/score.sh --aggregate                # aggregate across all runs

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ─── Aggregate mode ───────────────────────────────────────────────────
if [[ "${1:-}" == "--aggregate" || "${1:-}" == "-a" ]]; then
  echo "Aggregating scored runs in evals/runs/..."
  echo
  printf "%-40s %8s %8s %8s %8s %8s\n" "task" "cite" "distinct" "conflict" "action" "mean"
  printf -- "%.0s-" {1..82}; echo

  total_sum=0
  total_count=0

  for score_file in evals/runs/*/score.json; do
    [[ -f "$score_file" ]] || continue
    task=$(basename "$(dirname "$score_file")")

    cite=$(grep -E '"source_citation_rate":' "$score_file" | sed -E 's/.*: *([0-9.]+).*/\1/')
    distinct=$(grep -E '"finding_distinctness":' "$score_file" | sed -E 's/.*: *([0-9.]+).*/\1/')
    conflict=$(grep -E '"conflict_surfacing":' "$score_file" | sed -E 's/.*: *([0-9.]+).*/\1/')
    action=$(grep -E '"actionability":' "$score_file" | sed -E 's/.*: *([0-9.]+).*/\1/')
    mean=$(awk -v a="$cite" -v b="$distinct" -v c="$conflict" -v d="$action" 'BEGIN{ printf "%.3f", (a+b+c+d)/4 }')

    printf "%-40s %8s %8s %8s %8s %8s\n" "$task" "$cite" "$distinct" "$conflict" "$action" "$mean"

    total_sum=$(awk -v s="$total_sum" -v m="$mean" 'BEGIN{ printf "%.6f", s + m }')
    total_count=$((total_count + 1))
  done

  printf -- "%.0s-" {1..82}; echo
  if [[ $total_count -gt 0 ]]; then
    overall=$(awk -v s="$total_sum" -v n="$total_count" 'BEGIN{ printf "%.3f", s / n }')
    printf "%-40s %8s %8s %8s %8s %8s\n" "MEAN (n=$total_count)" "" "" "" "" "$overall"
    echo
    target_met=$(awk -v m="$overall" 'BEGIN{ print (m >= 0.8) ? "yes" : "no" }')
    echo "v1 target (mean ≥ 0.8 across 20 runs): $target_met"
    [[ $total_count -lt 20 ]] && echo "  (n=$total_count; target requires n≥20)"
  else
    echo "No score.json files found under evals/runs/."
    echo "Run ./evals/score.sh evals/runs/<task-slug> to score a run."
  fi
  exit 0
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
SCORE_FILE="$RUN_DIR/score.json"

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
echo "Run ./evals/score.sh --aggregate to see the running mean."
