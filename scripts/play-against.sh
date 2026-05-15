#!/usr/bin/env bash
# play-against.sh — antagonistic role critique tool + seeded-flaw regression check.
#
# Two modes, one script:
#   ./scripts/play-against.sh <role> <artifact>   Open interactive Claude with a
#                                                  pre-seeded reviewer prompt.
#   ./scripts/play-against.sh --check              Non-interactive regression: run
#                                                  the seeded PM fixture and assert
#                                                  the product-manager-reviewer
#                                                  caught its planted flaw.
#
# --check drives interactive Claude via scripts/lib/play-against.expect — it
# does NOT use `claude -p`. The harness exercises the same path real users hit.
#
# Roles available: product-manager only (Hornero currently ships PM-only).
# The multi-role legal-role list is preserved in version control history;
# re-expansion of the role set will require extending LEGAL_ROLES here.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

EXPECT_DRIVER="${ROOT}/scripts/lib/play-against.expect"
SENTINEL="###DONE_REVIEW###"
LEGAL_ROLES=(product-manager)

usage() {
  cat <<'EOF'
play-against.sh — get an antagonistic role critique of an artifact

Usage:
  ./scripts/play-against.sh <role> <artifact>   Interactive Claude critique
  ./scripts/play-against.sh --check             Run the PM seeded-flaw regression
  ./scripts/play-against.sh --help              This message

Roles: product-manager (only role currently shipped)

Interactive mode launches `claude` with a pre-seeded prompt — you read the
critique on screen and stay in the session for follow-ups. --check mode is
non-interactive (driven by `expect`) and covers product-manager only.
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

strip_ansi() {
  perl -pe 's/\e\[[0-9;?]*[a-zA-Z]//g; s/\e\][^\a]*\a//g; s/\e[()][A-Z0-9]//g; s/\r//g'
}

TRANSCRIPT_DIR="${ROOT}/tests/seeded/last-run"

persist_transcript() {
  local slug="$1" src="$2"
  mkdir -p "$TRANSCRIPT_DIR"
  cp "$src" "$TRANSCRIPT_DIR/${slug}.log"
  strip_ansi <"$src" > "$TRANSCRIPT_DIR/${slug}.stripped.log"
  echo "    transcript: tests/seeded/last-run/${slug}.stripped.log"
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

  local tmp
  tmp="$(mktemp -t hornero-play-against.XXXXXX)"
  local slug
  slug="$(basename "$fixture" .md)-vs-${role}"

  echo "  → spawning claude for ${role}-reviewer …"
  if PROMPT="$prompt" expect -f "$EXPECT_DRIVER" >"$tmp" 2>&1; then
    : # expect exited 0
  else
    local rc=$?
    echo "  ✗ expect driver exited ${rc}" >&2
    tail -20 "$tmp" >&2
    persist_transcript "$slug" "$tmp"
    rm -f "$tmp"
    return 1
  fi

  local stripped
  stripped="$(strip_ansi <"$tmp")"

  for sig in "${signatures[@]}"; do
    if echo "$stripped" | grep -qiF -- "$sig"; then
      echo "  ✓ ${role} caught the planted flaw — matched signature: '${sig}'"
      persist_transcript "$slug" "$tmp"
      rm -f "$tmp"
      return 0
    fi
  done

  echo "  ✗ ${role} did NOT mention the planted flaw" >&2
  echo "    expected one of: ${signatures[*]}" >&2
  persist_transcript "$slug" "$tmp"
  rm -f "$tmp"
  return 1
}

# Negative control: run a CLEAN artifact through a reviewer and assert that
# NONE of the flaw signatures fire. Proves the signatures aren't noise — a
# well-built artifact should not trigger them.
run_negative_one() {
  local role="$1" fixture="$2"
  shift 2
  local forbidden=("$@")

  if [[ ! -f "$fixture" ]]; then
    echo "  ✗ fixture not found: $fixture" >&2
    return 1
  fi

  local prompt
  prompt="$(build_prompt "$role" "$fixture")"

  local tmp
  tmp="$(mktemp -t hornero-play-against.XXXXXX)"
  local slug
  slug="$(basename "$fixture" .md)-vs-${role}-negative"

  echo "  → spawning claude for ${role}-reviewer (negative control) …"
  if PROMPT="$prompt" expect -f "$EXPECT_DRIVER" >"$tmp" 2>&1; then
    : # expect exited 0
  else
    local rc=$?
    echo "  ✗ expect driver exited ${rc}" >&2
    tail -20 "$tmp" >&2
    persist_transcript "$slug" "$tmp"
    rm -f "$tmp"
    return 1
  fi

  local stripped
  stripped="$(strip_ansi <"$tmp")"

  local hit=""
  for sig in "${forbidden[@]}"; do
    if echo "$stripped" | grep -qiF -- "$sig"; then
      hit="$sig"
      break
    fi
  done

  if [[ -z "$hit" ]]; then
    echo "  ✓ ${role} did not spuriously flag the clean artifact"
    persist_transcript "$slug" "$tmp"
    rm -f "$tmp"
    return 0
  fi

  echo "  ✗ ${role} FIRED on a clean artifact — signature '${hit}' appeared" >&2
  echo "    this means the signature is too liberal; eyeball the transcript" >&2
  persist_transcript "$slug" "$tmp"
  rm -f "$tmp"
  return 1
}

check_mode() {
  require_claude; require_expect
  local fail=0

  echo "↪ play-against.sh --check (product-manager only)"
  echo

  echo "[pos] product-manager-reviewer ← tests/seeded/weak-prd.md"
  echo "      (planted flaw: activity-metric success criteria, no counter-metric)"
  run_check_one product-manager tests/seeded/weak-prd.md \
    counter-metric gaming Goodhart "activity metric" outcome || fail=1
  echo

  echo "[neg] product-manager-reviewer ← tests/seeded/clean-prd.md (negative control)"
  echo "      (a properly-built PRD; PM signatures must NOT fire)"
  run_negative_one product-manager tests/seeded/clean-prd.md \
    counter-metric gaming Goodhart "activity metric" outcome || fail=1
  echo

  if [[ $fail -eq 0 ]]; then
    echo "✓ product-manager-reviewer caught the seeded flaw; negative control clean"
    echo "  transcripts: tests/seeded/last-run/"
    exit 0
  else
    echo "✗ at least one case failed — see above (transcripts in tests/seeded/last-run/)" >&2
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
