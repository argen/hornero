#!/usr/bin/env bash
# validate-resource.sh — lint a Hornero RESOURCE.md file
#
# Mirrors validate-skill.sh. Enforces:
#   1. YAML frontmatter present with required fields
#   2. type ∈ {data-source}; status ∈ {stable, stretch, experimental}
#   3. All six anatomy sections present:
#      Purpose, MCP Server, Object Model, Common Gotchas,
#      Fallback Without MCP, References
#   4. References + Fallback Without MCP sections non-empty
#   5. Stable resources must declare mcp.install (not "tbd")

set -uo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: $0 <RESOURCE.md> [RESOURCE.md ...]" >&2
  exit 2
fi

FAIL=0

required_frontmatter=(name description type status mcp)
required_sections=("## Purpose" "## MCP Server" "## Object Model" "## Common Gotchas" "## Fallback Without MCP" "## References")
legal_types=(data-source)
legal_statuses=(stable stretch experimental)

# Extract a nested scalar under a top-level `mcp:` block. Returns empty if absent.
mcp_subfield() {
  local key="$1" f="$2"
  awk -v pat="^[[:space:]]+${key}:" '
    /^---$/ { c++; next }
    c==1 && /^mcp:[[:space:]]*$/ { in_mcp=1; next }
    c==1 && in_mcp && /^[^[:space:]]/ { in_mcp=0 }
    c==1 && in_mcp && $0 ~ pat {
      sub(/^[[:space:]]+[^:]+:[[:space:]]*/, ""); gsub(/^"|"$/, ""); print; exit
    }
  ' "$f"
}

# Extract a single-line scalar frontmatter value (first match between --- delimiters).
fm_value() {
  local field="$1" f="$2"
  awk -v field="^${field}:" '
    /^---$/ { c++; next }
    c==1 && $0 ~ field { sub(field"[[:space:]]*", ""); print; exit }
  ' "$f"
}

# Extract section body (between "## X" and the next "## " header or EOF).
section_content() {
  local sec="$1" f="$2"
  awk -v sec="$sec" '
    $0 == sec { in_sec = 1; next }
    in_sec && /^## / { exit }
    in_sec { print }
  ' "$f"
}

contains() {
  local needle="$1"; shift
  local x
  for x in "$@"; do [[ "$x" == "$needle" ]] && return 0; done
  return 1
}

for file in "$@"; do
  echo "→ $file"

  if [[ ! -f "$file" ]]; then
    echo "  ✗ file not found"; FAIL=1; continue
  fi

  if ! head -1 "$file" | grep -q '^---$'; then
    echo "  ✗ missing YAML frontmatter (must start with ---)"; FAIL=1
  fi

  for field in "${required_frontmatter[@]}"; do
    if ! awk '/^---$/{c++; next} c==1' "$file" | grep -q "^${field}:"; then
      echo "  ✗ frontmatter missing required field: ${field}"; FAIL=1
    fi
  done

  type_val=$(fm_value type "$file")
  if [[ -n "$type_val" ]] && ! contains "$type_val" "${legal_types[@]}"; then
    echo "  ✗ type must be one of: ${legal_types[*]} (got: ${type_val})"; FAIL=1
  fi

  status_val=$(fm_value status "$file")
  if [[ -n "$status_val" ]] && ! contains "$status_val" "${legal_statuses[@]}"; then
    echo "  ✗ status must be one of: ${legal_statuses[*]} (got: ${status_val})"; FAIL=1
  fi

  # `name:` must match the directory basename (e.g. resources/linear/RESOURCE.md → name: linear).
  name_val=$(fm_value name "$file")
  dir_name=$(basename "$(dirname "$file")")
  if [[ -n "$name_val" && -n "$dir_name" && "$name_val" != "$dir_name" ]]; then
    echo "  ✗ frontmatter name must match directory basename (name: ${name_val}, dir: ${dir_name})"; FAIL=1
  fi

  for section in "${required_sections[@]}"; do
    if ! grep -Fq "$section" "$file"; then
      echo "  ✗ missing section: ${section}"; FAIL=1
    fi
  done

  if ! section_content "## References" "$file" | grep -qE '\S'; then
    echo "  ✗ References section is empty"; FAIL=1
  fi

  if ! section_content "## Fallback Without MCP" "$file" | grep -qE '\S'; then
    echo "  ✗ Fallback Without MCP section is empty"; FAIL=1
  fi

  # `mcp:` block must contain a nested `server:`. (mcp itself is in required_frontmatter,
  # so its presence is enforced above; this enforces the *shape*.)
  if awk '/^---$/{c++; next} c==1' "$file" | grep -q "^mcp:"; then
    if [[ -z "$(mcp_subfield server "$file")" ]]; then
      echo "  ✗ mcp.server is required inside the mcp block"; FAIL=1
    fi
  fi

  # Stable resources must declare a real mcp.install (not "tbd"). The check is
  # explicitly anchored inside the `mcp:` block — a top-level `install:` elsewhere
  # does not satisfy this.
  if [[ "$status_val" == "stable" ]]; then
    install_val=$(mcp_subfield install "$file")
    if [[ -z "$install_val" || "$install_val" == "tbd" ]]; then
      echo "  ✗ stable resource must declare mcp.install (not 'tbd')"; FAIL=1
    fi
  fi

done

if [[ $FAIL -eq 0 ]]; then
  echo
  echo "✓ all resources passed"
else
  echo
  echo "✗ validation failed" >&2
  exit 1
fi
