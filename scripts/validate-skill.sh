#!/usr/bin/env bash
# validate-skill.sh — lint a Hornero SKILL.md file
#
# Checks (v0, will tighten over phases):
#   1. YAML frontmatter present with required fields
#   2. All six anatomy sections present (Purpose, Key Concepts,
#      Application, Examples, Common Pitfalls, References)
#   3. Anti-patterns / Common Pitfalls section is non-empty
#   4. References section is non-empty (citation discipline)
#
# Phase 2+: cross-check that every named framework in Key Concepts
# appears in the role's sources.md.

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: $0 <SKILL.md> [SKILL.md ...]" >&2
  exit 2
fi

FAIL=0

required_frontmatter=(name description type)
required_sections=("## Purpose" "## Key Concepts" "## Application" "## Examples" "## Common Pitfalls" "## References")

for file in "$@"; do
  echo "→ $file"

  if [[ ! -f "$file" ]]; then
    echo "  ✗ file not found"; FAIL=1; continue
  fi

  # Frontmatter check — block must start at line 1 with ---
  if ! head -1 "$file" | grep -q '^---$'; then
    echo "  ✗ missing YAML frontmatter (must start with ---)"; FAIL=1
  fi

  for field in "${required_frontmatter[@]}"; do
    if ! awk '/^---$/{c++; next} c==1' "$file" | grep -q "^${field}:"; then
      echo "  ✗ frontmatter missing required field: ${field}"; FAIL=1
    fi
  done

  # Anatomy sections
  for section in "${required_sections[@]}"; do
    if ! grep -Fq "$section" "$file"; then
      echo "  ✗ missing section: ${section}"; FAIL=1
    fi
  done

  # Extract content of a named "## " section (between its header and the next "## " header or EOF)
  section_content() {
    local sec="$1"; local f="$2"
    awk -v sec="$sec" '
      $0 == sec { in_sec = 1; next }
      in_sec && /^## / { exit }
      in_sec { print }
    ' "$f"
  }

  if ! section_content "## References" "$file" | grep -qE '\S'; then
    echo "  ✗ References section is empty"; FAIL=1
  fi

  if ! section_content "## Common Pitfalls" "$file" | grep -qE '\S'; then
    echo "  ✗ Common Pitfalls section is empty"; FAIL=1
  fi

done

if [[ $FAIL -eq 0 ]]; then
  echo
  echo "✓ all skills passed"
else
  echo
  echo "✗ validation failed" >&2
  exit 1
fi
