#!/usr/bin/env bash
# play-against.sh — antagonistic role critique tool + seeded-flaw regression check.
#
# Two modes, one script:
#   ./scripts/play-against.sh <role> <artifact>   Open interactive Claude with a
#                                                  pre-seeded reviewer prompt.
#   ./scripts/play-against.sh --check              Non-interactive regression: run
#                                                  the seeded fixtures and assert
#                                                  each role-reviewer caught its
#                                                  planted flaw.
#
# --check drives interactive Claude via scripts/lib/play-against.expect — it
# does NOT use `claude -p`. The harness exercises the same path real users hit.
#
# Roles: product-manager · designer · software-engineer · tester ·
       security-expert · marketing-expert · data-scientist
# Token budget per --check case: ~5k tokens (fixture + invocation + critique).
# Full --check run (7 roles): ~45k tokens.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

EXPECT_DRIVER="${ROOT}/scripts/lib/play-against.expect"
SENTINEL="###DONE_REVIEW###"
LEGAL_ROLES=(product-manager designer software-engineer tester security-expert marketing-expert data-scientist)

usage() {
  cat <<'EOF'
play-against.sh — get an antagonistic role critique of an artifact

Usage:
  ./scripts/play-against.sh <role> <artifact>   Interactive Claude critique
  ./scripts/play-against.sh --check             Run the seeded-flaw regression
  ./scripts/play-against.sh --help              This message

Roles: product-manager · designer · software-engineer · tester ·
       security-expert · marketing-expert · data-scientist

Interactive mode launches `claude` with a pre-seeded prompt — you read the
critique on screen and stay in the session for follow-ups. --check mode is
non-interactive (driven by `expect`) and is the regression net for the role
personas.
EOF
}

contains() {
  local needle="$1"; shift
  local x; for x in "$@"; do [[ "$x" == "$needle" ]] && return 0; done
  return 1
}

build_prompt() {
  local role="$1" artifact="$2"
  cat <<EOF
Use the ${role}-reviewer subagent to review the file at ${artifact}. Find the top 3 problems with the artifact. Be antagonistic — do not rubber-stamp.

When you have finished the review, end your response with the exact string ${SENTINEL} on a line by itself.
EOF
}

require_claude() {
  if ! command -v claude >/dev/null 2>&1; then
    echo "✗ claude CLI not found on PATH" >&2
    exit 2
  fi
}

require_expect() {
  if ! command -v expect >/dev/null 2>&1; then
    echo "✗ expect not installed (brew install expect / apt install expect)" >&2
    exit 2
  fi
}

# Strip ANSI/CSI/OSC escape sequences from a transcript so grep is reliable.
strip_ansi() {
  # CSI: ESC [ ... letter ; OSC: ESC ] ... BEL ; other ESC sequences too.
  perl -pe 's/\e\[[0-9;?]*[a-zA-Z]//g; s/\e\][^\a]*\a//g; s/\e[()][A-Z0-9]//g; s/\r//g'
}

run_check_one() {
  local role="$1" fixture="$2"
  shift 2
  local signatures=("$@")

  if [[ ! -f "$fixture" ]]; then
    echo "  ✗ fixture not found: $fixture" >&2
    return 1
  fi

  local prompt
  prompt="$(build_prompt "$role" "$fixture")"

  local transcript
  transcript="$(mktemp -t hornero-play-against.XXXXXX)"

  echo "  → spawning claude for ${role}-reviewer …"
  if PROMPT="$prompt" expect -f "$EXPECT_DRIVER" >"$transcript" 2>&1; then
    : # expect exited 0
  else
    local rc=$?
    echo "  ✗ expect driver exited ${rc}" >&2
    tail -20 "$transcript" >&2
    return 1
  fi

  local stripped
  stripped="$(strip_ansi <"$transcript")"

  for sig in "${signatures[@]}"; do
    if echo "$stripped" | grep -qiF -- "$sig"; then
      echo "  ✓ ${role} caught the planted flaw — matched signature: '${sig}'"
      rm -f "$transcript"
      return 0
    fi
  done

  echo "  ✗ ${role} did NOT mention the planted flaw" >&2
  echo "    expected one of: ${signatures[*]}" >&2
  echo "    transcript: $transcript" >&2
  return 1
}

check_mode() {
  require_claude; require_expect
  local fail=0

  echo "↪ play-against.sh --check"
  echo

  echo "[1/7] product-manager-reviewer ← tests/seeded/weak-prd.md"
  echo "      (planted flaw: activity-metric success criteria, no counter-metric)"
  run_check_one product-manager tests/seeded/weak-prd.md \
    counter-metric gaming Goodhart "activity metric" outcome || fail=1
  echo

  echo "[2/7] designer-reviewer ← tests/seeded/weak-design.md"
  echo "      (planted flaw: happy-path-only flow — no empty/error/loading states)"
  run_check_one designer tests/seeded/weak-design.md \
    "empty state" "error state" loading "state inventory" "edge case" || fail=1
  echo

  echo "[3/7] software-engineer-reviewer ← tests/seeded/weak-plan.md"
  echo "      (planted flaw: in-place NOT NULL migration, no rollback, no concurrency note)"
  run_check_one software-engineer tests/seeded/weak-plan.md \
    rollback reversible concurrent backfill "in place" || fail=1
  echo

  echo "[4/7] tester-reviewer ← tests/seeded/weak-test-plan.md"
  echo "      (planted flaw: happy-path-only coverage, no risk analysis, no negative cases)"
  run_check_one tester tests/seeded/weak-test-plan.md \
    risk "negative" "failure mode" "edge case" boundary "happy path" HTSM || fail=1
  echo

  echo "[5/7] security-expert-reviewer ← tests/seeded/weak-auth-flow.md"
  echo "      (planted flaw: user enumeration via 404 on /request; plaintext token storage)"
  run_check_one security-expert tests/seeded/weak-auth-flow.md \
    enumeration "threat model" "trust boundary" OWASP "attack surface" "timing" "plaintext" || fail=1
  echo

  echo "[6/7] marketing-expert-reviewer ← tests/seeded/weak-launch-brief.md"
  echo "      (planted flaw: no audience, no alternatives, generic 'all-in-one' positioning)"
  run_check_one marketing-expert tests/seeded/weak-launch-brief.md \
    positioning "for whom" "who is this for" Dunford alternative category competitive || fail=1
  echo

  echo "[7/7] data-scientist-reviewer ← tests/seeded/weak-experiment.md"
  echo "      (planted flaw: no MDE/power calc, peeking enabled, no SRM check, no pre-registration)"
  run_check_one data-scientist tests/seeded/weak-experiment.md \
    MDE power peeking "pre-registration" "sample size" "effect size" SRM "multiple testing" || fail=1
  echo

  if [[ $fail -eq 0 ]]; then
    echo "✓ all 7 role personas caught their seeded flaw"
    exit 0
  else
    echo "✗ at least one role failed to push back — see above" >&2
    exit 1
  fi
}

interactive_mode() {
  local role="$1" artifact="$2"
  require_claude

  if ! contains "$role" "${LEGAL_ROLES[@]}"; then
    echo "✗ unknown role: ${role} (expected one of: ${LEGAL_ROLES[*]})" >&2
    exit 2
  fi

  if [[ ! -f "$artifact" ]]; then
    echo "✗ artifact not found: ${artifact}" >&2
    exit 2
  fi

  local prompt
  prompt="$(build_prompt "$role" "$artifact")"

  echo "↪ launching claude with the ${role}-reviewer prompt seeded …"
  echo "  (artifact: ${artifact})"
  echo
  exec claude "$prompt"
}

# ─── arg parsing ──────────────────────────────────────────────────────
case "${1:-}" in
  ""|-h|--help) usage; exit 0 ;;
  --check)      check_mode ;;
  *)
    if [[ $# -lt 2 ]]; then
      echo "✗ need <role> <artifact> (or --check)" >&2
      usage >&2
      exit 2
    fi
    interactive_mode "$1" "$2"
    ;;
esac
