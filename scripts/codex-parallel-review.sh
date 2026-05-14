#!/usr/bin/env bash
# codex-parallel-review.sh — fan out Hornero reviewer subagents as parallel Codex CLI processes.
#
# Claude Code spawns reviewer subagents in parallel via its first-class `Agent`
# tool. Codex CLI does not expose an equivalent primitive at parity, but its
# non-interactive `codex exec` mode is good enough to fan reviewers out as
# subprocesses. This script is that fan-out: one `codex exec` per role,
# briefed with the reviewer file + the artifact, run in parallel, with outputs
# collected per-role for the orchestrator (you) to synthesise.
#
# This is the Codex-side answer to `agents/<role>-reviewer.md` parallel
# dispatch. See AGENTS.md § Subagents in Codex for the protocol context.
#
# Usage:
#   ./scripts/codex-parallel-review.sh <artifact-path> [role ...]
#   ./scripts/codex-parallel-review.sh --dry-run <artifact-path> [role ...]
#   ./scripts/codex-parallel-review.sh -h
#
# Examples:
#   # Review a PR diff with the default mix (engineer + tester + security)
#   ./scripts/codex-parallel-review.sh tmp/pr-1247.diff software-engineer tester security-expert
#
#   # Full sweep across all 7 reviewers
#   ./scripts/codex-parallel-review.sh tmp/launch-plan.md \
#     product-manager designer software-engineer tester security-expert \
#     marketing-expert data-scientist
#
#   # See what would run without actually invoking codex
#   ./scripts/codex-parallel-review.sh --dry-run tmp/pr-1247.diff software-engineer tester
#
# Outputs:
#   tmp/codex-reviews/<role>-review-<timestamp>.md     # final assistant message per role
#   tmp/codex-reviews/<role>-stderr-<timestamp>.log    # stderr per role (debug)
#   tmp/codex-reviews/INDEX-<timestamp>.md             # one-line-per-role summary index
#
# Exit codes:
#   0  every reviewer succeeded
#   1  at least one reviewer failed (see per-role stderr logs)
#   2  argument or environment error
#
# Constraints (documented in AGENTS.md):
#   - All subprocesses share the same OpenAI auth + rate-limit bucket.
#   - Each is started with --ephemeral (no rollout state leakage between roles).
#   - Sandbox is read-only by default; reviewers do not write to the workspace.
#   - The artifact must be a single readable file. To review a diff, pre-render
#     it (`git diff <base>..HEAD > tmp/pr.diff`) and pass the file.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DEFAULT_ROLES=(software-engineer tester security-expert)
VALID_ROLES=(software-engineer tester designer security-expert marketing-expert product-manager data-scientist)

DRY_RUN=0
ARTIFACT=""
ROLES=()

usage() {
  sed -n '2,30p' "$0"
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)    usage 0 ;;
    --dry-run)    DRY_RUN=1; shift ;;
    --)           shift; break ;;
    -*)
      echo "error: unknown flag: $1" >&2
      usage 2
      ;;
    *)
      if [[ -z "$ARTIFACT" ]]; then
        ARTIFACT="$1"
      else
        ROLES+=("$1")
      fi
      shift
      ;;
  esac
done

if [[ -z "$ARTIFACT" ]]; then
  echo "error: artifact path required" >&2
  usage 2
fi

if [[ ! -f "$ARTIFACT" ]]; then
  echo "error: artifact not found: $ARTIFACT" >&2
  exit 2
fi

if [[ ${#ROLES[@]} -eq 0 ]]; then
  ROLES=("${DEFAULT_ROLES[@]}")
fi

# Validate role names against agents/<role>-reviewer.md.
for role in "${ROLES[@]}"; do
  if [[ ! " ${VALID_ROLES[*]} " == *" $role "* ]]; then
    echo "error: unknown role: $role" >&2
    echo "       valid: ${VALID_ROLES[*]}" >&2
    exit 2
  fi
  if [[ ! -f "agents/${role}-reviewer.md" ]]; then
    echo "error: agents/${role}-reviewer.md not found" >&2
    exit 2
  fi
done

# Require codex unless dry-running. We deliberately do NOT auto-install codex.
if [[ $DRY_RUN -eq 0 ]] && ! command -v codex >/dev/null 2>&1; then
  echo "error: codex CLI not on PATH" >&2
  echo "       install per https://github.com/openai/codex, or pass --dry-run" >&2
  exit 2
fi

mkdir -p tmp/codex-reviews
TS="$(date -u +%Y%m%dT%H%M%SZ)"
INDEX="tmp/codex-reviews/INDEX-${TS}.md"

# Strip the YAML frontmatter from a reviewer file so the body can be used as
# a system prompt. The frontmatter is delimited by --- on its own line.
strip_frontmatter() {
  awk '
    BEGIN { in_fm=0; done=0 }
    /^---$/ {
      if (done == 0 && in_fm == 0) { in_fm=1; next }
      if (done == 0 && in_fm == 1) { in_fm=0; done=1; next }
    }
    done == 1 { print }
  ' "$1"
}

# Build the per-role prompt: reviewer system prompt + artifact content +
# explicit handoff line. Codex receives it as a single positional argument.
build_prompt() {
  local role="$1"
  local artifact_path="$2"
  printf '%s\n\n' "$(strip_frontmatter "agents/${role}-reviewer.md")"
  printf '\n## Artifact under review\n\n'
  printf 'Path: `%s`\n\n' "$artifact_path"
  printf -- '---\n\n'
  cat "$artifact_path"
  printf '\n\n---\n\n'
  printf 'Produce your review now. Stay within the output discipline above.\n'
}

run_reviewer() {
  local role="$1"
  local out="tmp/codex-reviews/${role}-review-${TS}.md"
  local err="tmp/codex-reviews/${role}-stderr-${TS}.log"
  local prompt
  prompt="$(build_prompt "$role" "$ARTIFACT")"

  if [[ $DRY_RUN -eq 1 ]]; then
    printf 'DRY-RUN [%s]: would invoke codex exec → %s\n' "$role" "$out"
    printf '  prompt length: %d chars\n' "${#prompt}"
    return 0
  fi

  # --ephemeral: no rollout file written; fresh context per invocation.
  # --skip-git-repo-check: artifact may live outside a git repo.
  # --sandbox read-only: reviewer must not write to the workspace.
  # -o: capture final assistant message to file.
  codex exec \
    --ephemeral \
    --skip-git-repo-check \
    --sandbox read-only \
    -o "$out" \
    "$prompt" \
    >/dev/null 2>"$err"
}

echo "codex-parallel-review: ${#ROLES[@]} reviewer(s) against $ARTIFACT"
echo "  timestamp: $TS"
echo "  roles: ${ROLES[*]}"
echo

# Fan out. Parallel indexed arrays (PIDS[i] ↔ ROLES[i]) keep us compatible
# with macOS-stock bash 3.2, which lacks associative arrays.
PIDS=()
for role in "${ROLES[@]}"; do
  run_reviewer "$role" &
  pid=$!
  PIDS+=("$pid")
  echo "  [$role] started (pid $pid)"
done

# Collect.
FAILED=0
{
  printf '# Codex parallel review — %s\n\n' "$TS"
  printf 'Artifact: `%s`\n\n' "$ARTIFACT"
  printf '| Role | Status | Output |\n|---|---|---|\n'
} > "$INDEX"

for i in "${!ROLES[@]}"; do
  role="${ROLES[$i]}"
  if wait "${PIDS[$i]}"; then
    out="tmp/codex-reviews/${role}-review-${TS}.md"
    if [[ $DRY_RUN -eq 1 ]]; then
      printf '| %s | DRY-RUN | (would write to %s) |\n' "$role" "$out" >> "$INDEX"
    else
      printf '| %s | ok | [`%s`](%s) |\n' "$role" "$out" "$(basename "$out")" >> "$INDEX"
    fi
    echo "  [$role] ✓"
  else
    err="tmp/codex-reviews/${role}-stderr-${TS}.log"
    printf '| %s | FAILED | see `%s` |\n' "$role" "$err" >> "$INDEX"
    echo "  [$role] ✗ failed — see $err"
    FAILED=1
  fi
done

echo
echo "index: $INDEX"

if [[ $FAILED -eq 1 ]]; then
  exit 1
fi

exit 0
