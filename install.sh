#!/usr/bin/env bash
# install.sh — copy Hornero skills and agents into ~/.claude
#
# Status: v0 stub. Will be fleshed out in phase 3.
# Current behavior: prints what *would* be installed.

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Hornero installer — v0 stub"
echo
echo "Repo:   ${REPO_DIR}"
echo "Target: ${CLAUDE_DIR}"
echo

if [[ ! -d "${CLAUDE_DIR}" ]]; then
  echo "✗ ${CLAUDE_DIR} not found. Is Claude Code installed?" >&2
  exit 1
fi

echo "Would install:"

for role_dir in "${REPO_DIR}"/roles/*/; do
  role=$(basename "$role_dir")
  if [[ -d "${role_dir}skills" ]]; then
    count=$(find "${role_dir}skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$count" -gt 0 ]]; then
      echo "  - ${count} skill(s) from roles/${role}/skills/ → ~/.claude/skills/${role}/"
    fi
  fi
done

if [[ -d "${REPO_DIR}/skills" ]]; then
  count=$(find "${REPO_DIR}/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$count" -gt 0 ]]; then
    echo "  - ${count} cross-role skill(s) from skills/ → ~/.claude/skills/"
  fi
fi

if [[ -d "${REPO_DIR}/agents" ]]; then
  count=$(find "${REPO_DIR}/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$count" -gt 0 ]]; then
    echo "  - ${count} agent definition(s) from agents/ → ~/.claude/agents/"
  fi
fi

echo
echo "Recommended Stop hook for ~/.claude/settings.json:"
echo '  "hooks": { "Stop": [{ "command": "echo run /extract-lesson if anything surprised you" }] }'
echo
echo "Next: open playbooks/onboarding.md"
echo
echo "(This is a stub — real install logic ships in phase 3.)"
