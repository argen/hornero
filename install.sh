#!/usr/bin/env bash
# install.sh — install Hornero skills and agents into ~/.claude
#
# Copies all SKILL.md files (per-role and cross-role) and agent definitions
# into ~/.claude/, with confirmation on overwrite.
#
# Usage:
#   ./install.sh             # interactive: ask before each overwrite
#   ./install.sh --force     # overwrite without asking
#   ./install.sh --dry-run   # show what would be installed; don't write
#   ./install.sh --uninstall # remove Hornero-installed files

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
MANIFEST="${CLAUDE_DIR}/.hornero-manifest"

FORCE=0
DRY_RUN=0
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --force)     FORCE=1 ;;
    --dry-run)   DRY_RUN=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 2
      ;;
  esac
done

echo "Hornero installer"
echo "  Repo:   ${REPO_DIR}"
echo "  Target: ${CLAUDE_DIR}"
echo

if [[ ! -d "${CLAUDE_DIR}" ]]; then
  echo "✗ ${CLAUDE_DIR} not found. Is Claude Code installed?" >&2
  exit 1
fi

# ---------- Uninstall ----------
if [[ $UNINSTALL -eq 1 ]]; then
  if [[ ! -f "${MANIFEST}" ]]; then
    echo "No manifest found at ${MANIFEST}. Nothing to uninstall."
    exit 0
  fi
  echo "Removing Hornero-installed files listed in ${MANIFEST}:"
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if [[ -e "$path" ]]; then
      echo "  - $path"
      [[ $DRY_RUN -eq 0 ]] && rm -f "$path"
    fi
  done < "${MANIFEST}"
  [[ $DRY_RUN -eq 0 ]] && rm -f "${MANIFEST}"
  echo "✓ uninstalled"
  exit 0
fi

# ---------- Install ----------
mkdir -p "${CLAUDE_DIR}/skills"
mkdir -p "${CLAUDE_DIR}/agents"

# Reset manifest at start of fresh install (dry-run does not touch manifest)
[[ $DRY_RUN -eq 0 ]] && : > "${MANIFEST}.tmp"

record() {
  # record an installed file in the manifest temp
  [[ $DRY_RUN -eq 0 ]] && echo "$1" >> "${MANIFEST}.tmp"
}

confirm_overwrite() {
  local target="$1"
  [[ ! -e "$target" ]] && return 0
  [[ $FORCE -eq 1 ]] && return 0
  read -r -p "  Overwrite ${target}? [y/N] " ans </dev/tty
  [[ "$ans" == "y" || "$ans" == "Y" ]]
}

install_skill() {
  local src="$1"        # path to SKILL.md
  local name="$2"       # skill folder name
  local target_dir="${CLAUDE_DIR}/skills/${name}"
  local target="${target_dir}/SKILL.md"

  if confirm_overwrite "$target"; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  would install: ${src#${REPO_DIR}/}  →  ${target}"
    else
      mkdir -p "${target_dir}"
      cp "$src" "$target"
      echo "  installed:    ${name}"
      record "$target"
    fi
  else
    echo "  skipped:      ${name}"
  fi
}

install_agent() {
  local src="$1"
  local fname; fname=$(basename "$src")
  local target="${CLAUDE_DIR}/agents/${fname}"

  if confirm_overwrite "$target"; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  would install: ${src#${REPO_DIR}/}  →  ${target}"
    else
      cp "$src" "$target"
      echo "  installed:    ${fname}"
      record "$target"
    fi
  else
    echo "  skipped:      $(basename "$src")"
  fi
}

# Cross-role process skills
echo "Cross-role skills:"
while IFS= read -r -d '' file; do
  name=$(basename "$(dirname "$file")")
  install_skill "$file" "$name"
done < <(find "${REPO_DIR}/skills" -name "SKILL.md" -print0 2>/dev/null)

# Per-role skills — prefix with role name to avoid collisions
echo
echo "Per-role skills:"
while IFS= read -r -d '' file; do
  role=$(basename "$(dirname "$(dirname "$file")")")
  skill=$(basename "$(dirname "$file")")
  install_skill "$file" "${role}-${skill}"
done < <(find "${REPO_DIR}/roles" -path "*/skills/*/SKILL.md" -print0 2>/dev/null)

# Agents
echo
echo "Agents:"
if [[ -d "${REPO_DIR}/agents" ]]; then
  for f in "${REPO_DIR}/agents"/*.md; do
    [[ -f "$f" ]] || continue
    install_agent "$f"
  done
fi

# Finalize manifest
if [[ $DRY_RUN -eq 0 ]]; then
  mv "${MANIFEST}.tmp" "${MANIFEST}"
  echo
  echo "Manifest written to ${MANIFEST}"
fi

# Stop hook recommendation
echo
echo "──────────────────────────────────────────────────────────────"
echo "Recommended addition to ${CLAUDE_DIR}/settings.json:"
cat <<'EOF'

  "hooks": {
    "Stop": [
      { "command": "echo 'session ending — consider /extract-lesson' " }
    ]
  }

EOF
echo "──────────────────────────────────────────────────────────────"
echo
echo "Next steps:"
echo "  1. Open playbooks/onboarding.md"
echo "  2. Try a real task with one of the cross-role skills"
echo "  3. Run /harness-check on your current repo"
echo
[[ $DRY_RUN -eq 1 ]] && echo "(dry run — nothing was written)"
