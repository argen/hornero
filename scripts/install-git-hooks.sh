#!/usr/bin/env bash
# install-git-hooks.sh — opt-in installer for Hornero's local pre-commit shim.
#
# Symlinks scripts/hooks/pre-commit into .git/hooks/pre-commit. The same
# validators run in CI; this is the local mirror that catches breakage before
# you push. CI is the authoritative gate — running this is a convenience, not
# a requirement. Re-run to repair a broken symlink.
#
# Usage:
#   ./scripts/install-git-hooks.sh           # install (or repair) the symlink
#   ./scripts/install-git-hooks.sh --remove  # uninstall the symlink

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "✗ not inside a git repository" >&2
  exit 1
}

cd "$ROOT"

HOOK_SRC="scripts/hooks/pre-commit"
HOOK_DST=".git/hooks/pre-commit"

if [[ "${1:-}" == "--remove" ]]; then
  if [[ -L "$HOOK_DST" ]]; then
    rm "$HOOK_DST"
    echo "✓ removed $HOOK_DST"
  else
    echo "  no symlink at $HOOK_DST — nothing to do"
  fi
  exit 0
fi

if [[ ! -f "$HOOK_SRC" ]]; then
  echo "✗ source hook not found: $HOOK_SRC" >&2
  exit 1
fi

if [[ ! -x "$HOOK_SRC" ]]; then
  chmod +x "$HOOK_SRC"
fi

mkdir -p "$(dirname "$HOOK_DST")"

if [[ -e "$HOOK_DST" && ! -L "$HOOK_DST" ]]; then
  echo "✗ $HOOK_DST exists and is not a symlink — refusing to overwrite" >&2
  echo "  back it up and re-run, or remove it manually." >&2
  exit 1
fi

# Use a repo-relative path so the symlink stays valid after a worktree move.
ln -sf "../../$HOOK_SRC" "$HOOK_DST"
echo "✓ installed $HOOK_DST → $HOOK_SRC"
echo "  next commit will run: validate-skill, validate-resource, test-validate-resource, smoke-check"
