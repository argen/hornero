#!/usr/bin/env bash
# validate-skill.sh — lint a Hornero SKILL.md file
#
# Checks (v0, will tighten over phases):
#   1. YAML frontmatter present with required fields
#   2. All six anatomy sections present (Purpose, Key Concepts,
#      Application, Examples, Common Pitfalls, References)
#   3. Anti-patterns / Common Pitfalls section is non-empty
#   4. References section is non-empty (citation discipline)
#   5. Single-line name/description values are YAML-safe: an unquoted value
#      must not contain ': ', ':<TAB>', ' #' or end in ':', must not start
#      with a YAML indicator character, and a leading quote must be closed
#   6. description is at most 1024 characters (Claude API limit)
#   7. Warn (non-fatal) when a file exceeds 500 lines
#
# Skills with `type: command` (slash commands) are exempt from checks 2-4:
# they need only name, description, and type.
#
# Check 5 is a targeted heuristic, not a YAML parser (no YAML library is
# assumed). It only inspects single-line `name:` / `description:` values;
# multi-line block scalars and other fields are not checked.
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

  fm_value() {
    awk '/^---$/{c++; next} c==1' "$2" | sed -n "s/^$1:[[:space:]]*//p" | head -1
  }

  indicator='^[]`*&!|>%@[{#?,}-]'
  for field in name description; do
    val=$(fm_value "$field" "$file")
    case "$val" in
      \"*)
        if [[ ${#val} -lt 2 || ! "$val" =~ [^\\]\"$ ]]; then
          echo "  ✗ frontmatter: ${field} has an unclosed quote"; FAIL=1
        fi
        ;;
      \'*)
        if [[ ${#val} -lt 2 || "$val" != *\' ]]; then
          echo "  ✗ frontmatter: ${field} has an unclosed quote"; FAIL=1
        fi
        ;;
      "|"*|">"*) ;;
      *)
        if [[ "$val" == *": "* || "$val" == *":"$'\t'* || "$val" == *: || "$val" =~ $indicator ]]; then
          echo "  ✗ frontmatter: ${field} must be quoted (contains ': ' or YAML indicator)"; FAIL=1
        elif [[ "$val" == *" #"* ]]; then
          echo "  ✗ frontmatter: ${field} must be quoted (contains ' #' comment start)"; FAIL=1
        fi
        ;;
    esac
  done

  desc=$(fm_value description "$file")
  case "$desc" in
    \"*\"|\'*\') desc="${desc:1:${#desc}-2}" ;;
  esac
  if [[ ${#desc} -gt 1024 ]]; then
    echo "  ✗ description exceeds 1024 characters (${#desc})"; FAIL=1
  fi

  if [[ $(wc -l < "$file") -gt 500 ]]; then
    echo "  ⚠ over 500 lines; consider moving depth to a sibling reference.md"
  fi

  # Slash-command skills carry no six-section anatomy.
  if [[ "$(fm_value type "$file")" == "command" ]]; then
    continue
  fi

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
