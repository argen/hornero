#!/usr/bin/env bash
# test-validate-resource.sh — fixture-based tests for validate-resource.sh
#
# Each case builds a temp RESOURCE.md and asserts validate-resource.sh either
# passes or rejects it for the *right* reason. Run from the repo root.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="${SCRIPT_DIR}/validate-resource.sh"

if [[ ! -x "$VALIDATOR" ]]; then
  echo "✗ validator not executable at $VALIDATOR" >&2
  exit 1
fi

PASS=0
FAIL=0
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

assert_pass() {
  local name="$1" file="$2"
  if "$VALIDATOR" "$file" >/dev/null 2>&1; then
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  else
    echo "  ✗ ${name} — expected pass but failed"; FAIL=$((FAIL+1))
    "$VALIDATOR" "$file" 2>&1 | sed 's/^/      /'
  fi
}

assert_fail() {
  local name="$1" file="$2" expect_msg="$3"
  local out
  out="$("$VALIDATOR" "$file" 2>&1)" && rc=0 || rc=$?
  if [[ $rc -eq 0 ]]; then
    echo "  ✗ ${name} — expected failure but passed"; FAIL=$((FAIL+1))
  elif ! echo "$out" | grep -qF "$expect_msg"; then
    echo "  ✗ ${name} — failed but wrong reason; expected '${expect_msg}'"; FAIL=$((FAIL+1))
    echo "$out" | sed 's/^/      /'
  else
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  fi
}

# ---------- fixtures ----------
write_good() {
  cat > "$1" <<'EOF'
---
name: linear
description: Linear is a fast issue tracker used for product engineering work.
type: data-source
status: stable
mcp:
  server: "@modelcontextprotocol/server-linear"
  install: "claude mcp add linear -- npx -y @modelcontextprotocol/server-linear"
  auth_env: [LINEAR_API_KEY]
  capabilities: [issues, projects, cycles, comments, search]
object_model: [Issue, Project, Cycle, Team, Label, State]
used_by:
  - product-manager/linear-triage
fallback: prose
---

## Purpose

What it is.

## MCP Server

Install line.

## Object Model

Entities.

## Common Gotchas

Watch out.

## Fallback Without MCP

curl recipe.

## References

- Linear docs
EOF
}

write_stretch() {
  cat > "$1" <<'EOF'
---
name: datadog
description: Observability platform.
type: data-source
status: stretch
mcp:
  server: tbd
  install: tbd
  auth_env: []
  capabilities: []
object_model: []
used_by: []
fallback: prose
---

## Purpose

What it is.

## MCP Server

No mature server yet.

## Object Model

Metrics, monitors, dashboards.

## Common Gotchas

Tag cardinality cost.

## Fallback Without MCP

API curl.

## References

- Datadog docs
EOF
}

echo "Testing validate-resource.sh"

# Helper: place a fixture in $TMP/<slug>/RESOURCE.md so dirname matches name: <slug>
fixture_dir() {
  local slug="$1"
  mkdir -p "$TMP/$slug"
  echo "$TMP/$slug/RESOURCE.md"
}

# Pass cases
LINEAR_GOOD=$(fixture_dir linear); write_good "$LINEAR_GOOD"
assert_pass "stable resource — full frontmatter + all 6 sections" "$LINEAR_GOOD"

DATADOG_STRETCH=$(fixture_dir datadog); write_stretch "$DATADOG_STRETCH"
assert_pass "stretch resource — install:tbd is allowed" "$DATADOG_STRETCH"

# Fail cases — missing frontmatter
NO_FM=$(fixture_dir no-fm); echo "## Purpose" > "$NO_FM"
assert_fail "no frontmatter" "$NO_FM" "missing YAML frontmatter"

# Fail — missing required field
NO_NAME=$(fixture_dir no-name); write_good "$NO_NAME"; sed -i.bak '/^name: /d' "$NO_NAME"
assert_fail "missing frontmatter field: name" "$NO_NAME" "frontmatter missing required field: name"

# Fail — wrong type
WRONG_TYPE=$(fixture_dir wrong-type); write_good "$WRONG_TYPE"; sed -i.bak '1,/^---$/!{/^name: /s/.*/name: wrong-type/;}' "$WRONG_TYPE"
sed -i.bak2 's/^type: data-source/type: skill/' "$WRONG_TYPE"
assert_fail "illegal type" "$WRONG_TYPE" "type must be one of"

# Fail — illegal status
BAD_STATUS=$(fixture_dir bad-status); write_good "$BAD_STATUS"; sed -i.bak 's/^name: linear/name: bad-status/' "$BAD_STATUS"; sed -i.bak2 's/^status: stable/status: WIP/' "$BAD_STATUS"
assert_fail "illegal status" "$BAD_STATUS" "status must be one of"

# Fail — missing section
NO_MCP_SEC=$(fixture_dir no-mcp-section); write_good "$NO_MCP_SEC"; sed -i.bak 's/^name: linear/name: no-mcp-section/' "$NO_MCP_SEC"
awk '!/^## MCP Server$/' "$NO_MCP_SEC" > "$NO_MCP_SEC.tmp" && mv "$NO_MCP_SEC.tmp" "$NO_MCP_SEC"
assert_fail "missing ## MCP Server section" "$NO_MCP_SEC" "missing section: ## MCP Server"

# Fail — empty section (references)
EMPTY_REFS=$(fixture_dir empty-refs); write_good "$EMPTY_REFS"; sed -i.bak 's/^name: linear/name: empty-refs/' "$EMPTY_REFS"
awk '
  /^## References$/ { print; in_refs=1; next }
  in_refs && /^## / { in_refs=0 }
  in_refs { next }
  { print }
' "$EMPTY_REFS" > "$EMPTY_REFS.tmp" && mv "$EMPTY_REFS.tmp" "$EMPTY_REFS"
assert_fail "empty References" "$EMPTY_REFS" "References section is empty"

# Fail — stable resource with mcp.install: tbd (only stretch allowed)
STABLE_TBD=$(fixture_dir stable-tbd); write_good "$STABLE_TBD"; sed -i.bak 's/^name: linear/name: stable-tbd/' "$STABLE_TBD"
sed -i.bak2 's|^  install: .*|  install: tbd|' "$STABLE_TBD"
assert_fail "stable status forbids install: tbd" "$STABLE_TBD" "stable resource must declare mcp.install"

# Fail — frontmatter `name:` ≠ directory basename
NAME_MISMATCH=$(fixture_dir mismatch-dir); write_good "$NAME_MISMATCH"  # name: linear, dir: mismatch-dir
assert_fail "name mismatch directory basename" "$NAME_MISMATCH" "name must match directory basename"

# Fail — missing mcp block entirely (stable)
NO_MCP=$(fixture_dir no-mcp); write_good "$NO_MCP"; sed -i.bak 's/^name: linear/name: no-mcp/' "$NO_MCP"
awk '
  /^mcp:/ { in_mcp=1; next }
  in_mcp && /^[^[:space:]]/ { in_mcp=0 }
  in_mcp { next }
  { print }
' "$NO_MCP" > "$NO_MCP.tmp" && mv "$NO_MCP.tmp" "$NO_MCP"
assert_fail "missing mcp block" "$NO_MCP" "frontmatter missing required field: mcp"

# Fail — top-level install: outside mcp block (stable) — must not satisfy the install check
mkdir -p "$TMP/install-outside-mcp"
INSTALL_OUTSIDE="$TMP/install-outside-mcp/RESOURCE.md"
cat > "$INSTALL_OUTSIDE" <<'EOF'
---
name: install-outside-mcp
description: Test fixture.
type: data-source
status: stable
install: "claude mcp add linear -- npx -y server"
mcp:
  server: "@modelcontextprotocol/server-linear"
  install: tbd
  auth_env: [LINEAR_API_KEY]
  capabilities: []
object_model: [Issue]
used_by: []
fallback: prose
---

## Purpose

x

## MCP Server

x

## Object Model

x

## Common Gotchas

x

## Fallback Without MCP

x

## References

- x
EOF
assert_fail "install: outside mcp does not satisfy stable's mcp.install requirement" "$INSTALL_OUTSIDE" "stable resource must declare mcp.install"

# Fail — mcp block without nested server
NO_MCP_SERVER=$(fixture_dir no-mcp-server); write_good "$NO_MCP_SERVER"; sed -i.bak 's/^name: linear/name: no-mcp-server/' "$NO_MCP_SERVER"
awk '
  /^  server:/ { next }
  { print }
' "$NO_MCP_SERVER" > "$NO_MCP_SERVER.tmp" && mv "$NO_MCP_SERVER.tmp" "$NO_MCP_SERVER"
assert_fail "mcp block missing nested server" "$NO_MCP_SERVER" "mcp.server"

echo
echo "Passed: $PASS  Failed: $FAIL"
[[ $FAIL -eq 0 ]] || exit 1
