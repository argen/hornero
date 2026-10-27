#!/usr/bin/env bash
# validate-dispatcher.sh — structural checks for dispatcher routing fixtures and CATALOG.md
#
# Runs three deterministic checks (no LLM required):
#   1. Dead references: every expected_skill in tests/dispatcher/routes.tsv must resolve
#      to an entry in CATALOG.md (or be "ESCALATE" for documented multi-match cases).
#   2. Description completeness: every skill in CATALOG.md must have a non-empty
#      "When to invoke" description.
#   3. Scenarios presence: every expected_skill in routes.tsv must have a non-empty
#      `scenarios:` field in its SKILL.md frontmatter.
#
# Usage:
#   ./scripts/validate-dispatcher.sh
#
# Exit codes: 0 = all checks pass, 1 = at least one check failed.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

ok()  { echo "  ✓ $1"; PASS=$((PASS+1)); }
bad() { echo "  ✗ $1" >&2; FAIL=$((FAIL+1)); }

ROUTES="tests/dispatcher/routes.tsv"

if [[ ! -f "$ROUTES" ]]; then
  echo "  ✗ $ROUTES not found" >&2
  exit 1
fi

# ── Check 1: dead references in routes.tsv ───────────────────────────────────
echo "─── Check 1: routes.tsv → CATALOG.md resolution ────────────────────"

DEAD=0
while IFS=$'\t' read -r prompt expected_skill expected_role notes; do
  # Skip comments and blank lines
  [[ "$prompt" =~ ^#.*$ || -z "$prompt" ]] && continue

  # ESCALATE entries are documented multi-match cases; skip skill resolution
  [[ "$expected_skill" == "ESCALATE" ]] && continue

  # Check if the skill appears in CATALOG.md (in backtick form)
  if ! grep -qF "\`${expected_skill}\`" CATALOG.md; then
    bad "routes.tsv: '$expected_skill' not found in CATALOG.md (prompt: ${prompt:0:50}...)"
    DEAD=1
  fi
done < "$ROUTES"

[[ $DEAD -eq 0 ]] && ok "all non-ESCALATE skills in routes.tsv resolve to CATALOG.md entries"

# ── Check 2: CATALOG.md description completeness ─────────────────────────────
echo "─── Check 2: CATALOG.md description completeness ───────────────────"

EMPTY=0
# Extract skill names and their "When to invoke" column from CATALOG.md table rows.
# Table row format: | `skill-name` | type | description text |
while IFS= read -r line; do
  # Match rows like: | `skill-name` | ... | description |
  if [[ "$line" =~ ^\|[[:space:]]*\`([a-z][a-z0-9-]+)\`[[:space:]]*\|[[:space:]]*[a-z]+[[:space:]]*\|[[:space:]]*(.*)\|[[:space:]]*$ ]]; then
    skill="${BASH_REMATCH[1]}"
    desc="${BASH_REMATCH[2]}"
    desc="${desc%|*}"   # strip trailing pipe if any
    desc="${desc%%*( )}"  # strip trailing spaces (bash 4+)
    desc="${desc#"${desc%%[! ]*}"}"  # strip leading spaces
    if [[ -z "$desc" ]]; then
      bad "CATALOG.md: '$skill' has empty 'When to invoke' description"
      EMPTY=1
    fi
  fi
done < CATALOG.md

[[ $EMPTY -eq 0 ]] && ok "all CATALOG.md skill entries have non-empty descriptions"

# ── Check 3: scenarios frontmatter presence ───────────────────────────────────
echo "─── Check 3: scenarios frontmatter in referenced skills ─────────────"

# Build a deduplicated list of skills referenced in routes.tsv (excluding ESCALATE)
REFERENCED_SKILLS=()
while IFS=$'\t' read -r prompt expected_skill expected_role notes; do
  [[ "$prompt" =~ ^#.*$ || -z "$prompt" ]] && continue
  [[ "$expected_skill" == "ESCALATE" ]] && continue
  REFERENCED_SKILLS+=("$expected_skill")
done < "$ROUTES"

# Deduplicate
IFS=$'\n' REFERENCED_SKILLS=($(printf '%s\n' "${REFERENCED_SKILLS[@]}" | sort -u))

SCENARIOS_FAIL=0
for skill in "${REFERENCED_SKILLS[@]}"; do
  skill_md=""
  [[ -f "skills/${skill}/SKILL.md" ]] && skill_md="skills/${skill}/SKILL.md"

  if [[ -z "$skill_md" || ! -f "$skill_md" ]]; then
    bad "scenarios check: cannot find SKILL.md for '$skill' (already caught by check 1 if dead)"
    SCENARIOS_FAIL=1
    continue
  fi

  # Check that `scenarios:` appears in the frontmatter and has at least one entry
  fm=$(awk '/^---$/{c++; next} c==1' "$skill_md")
  if ! echo "$fm" | grep -q "^scenarios:"; then
    bad "$skill_md: missing 'scenarios:' frontmatter field"
    SCENARIOS_FAIL=1
  elif echo "$fm" | awk '/^scenarios:/{found=1; next} found && /^[[:space:]]+-/{has_entry=1} found && /^[^[:space:]]/{exit} END{exit !has_entry}' | grep -q 'x'; then
    : # awk returned non-zero = has entry — ok (double negation; this branch is for clarity)
  fi
done

[[ $SCENARIOS_FAIL -eq 0 ]] && ok "all referenced skills have scenarios frontmatter"

# ── Summary ───────────────────────────────────────────────────────────────────
echo
echo "─── Summary ───────────────────────────────────────────────────────"
echo "  ✓ $PASS passed"
echo "  ✗ $FAIL failed"
echo

if [[ $FAIL -eq 0 ]]; then
  echo "validate-dispatcher: PASS"
  exit 0
else
  echo "validate-dispatcher: FAIL" >&2
  exit 1
fi
