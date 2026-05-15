#!/usr/bin/env bash
# build-plugin-skills.sh — create flat skills/<name>/ symlinks for every
# per-role skill so the Claude Code plugin loader discovers them.
#
# The plugin loader expects skills at skills/<name>/SKILL.md (one level
# deep). Hornero's canonical layout nests per-role skills at
# roles/<role>/skills/<skill>/SKILL.md (two levels deep). Symlinks bridge
# the gap without duplicating files or breaking the role-grouping
# structure that catalog.sh, install.sh, and ROLE.md links rely on.
#
# Idempotent: re-running cleans up dangling/stale symlinks and re-creates
# them from scratch. Commits the resulting symlinks to git (mode 120000).
#
# Usage:
#   ./scripts/build-plugin-skills.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Sanity: cross-role skills are real directories at skills/. We must not
# touch them. Build a set of cross-role skill names to skip.
CROSS_ROLE_SKILLS=()
while IFS= read -r line; do CROSS_ROLE_SKILLS+=("$line"); done < <(
  find skills -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
)

is_cross_role() {
  local name="$1"
  for crs in "${CROSS_ROLE_SKILLS[@]}"; do
    [[ "$crs" == "$name" ]] && return 0
  done
  return 1
}

# Sweep dangling / stale symlinks first (idempotency).
for entry in skills/*; do
  if [[ -L "$entry" ]]; then
    target="$(readlink "$entry")"
    if [[ ! -e "$entry" ]]; then
      echo "  cleaning dangling symlink: $entry → $target"
      rm "$entry"
    fi
  fi
done

# Walk every per-role skill and ensure a top-level symlink exists.
created=0
existed=0
for skill_md in roles/*/skills/*/SKILL.md; do
  skill_dir="$(dirname "$skill_md")"          # roles/<role>/skills/<skill>
  skill_name="$(basename "$skill_dir")"       # <skill>
  role_name="$(basename "$(dirname "$(dirname "$skill_dir")")")"  # <role>

  if is_cross_role "$skill_name"; then
    echo "  ✗ name collision: per-role '$skill_name' (role=$role_name) collides with cross-role skill" >&2
    exit 1
  fi

  target="../roles/$role_name/skills/$skill_name"
  link="skills/$skill_name"

  if [[ -L "$link" ]]; then
    current_target="$(readlink "$link")"
    if [[ "$current_target" == "$target" ]]; then
      existed=$((existed+1))
      continue
    else
      echo "  retargeting $link: $current_target → $target"
      rm "$link"
    fi
  elif [[ -e "$link" ]]; then
    echo "  ✗ refusing to overwrite non-symlink: $link" >&2
    exit 1
  fi

  ln -s "$target" "$link"
  created=$((created+1))
done

echo
echo "✓ build-plugin-skills: $created created, $existed already correct"
echo "  total per-role skill symlinks: $(find skills -mindepth 1 -maxdepth 1 -type l | wc -l | tr -d ' ')"
echo "  total cross-role skill dirs:   $(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
