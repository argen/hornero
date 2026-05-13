#!/usr/bin/env bash
# smoke-check.sh — end-to-end install verification for Hornero
#
# Runs validate-skill.sh on every SKILL.md, regenerates CATALOG.md and
# checks for drift, and (optionally) exercises install.sh against the
# real ~/.claude. Used as a pre-release sanity check and as the
# scripting half of the "clean-install verification" Roadmap item.
#
# Usage:
#   ./scripts/smoke-check.sh                 # validate + catalog-drift + dry-run install
#   ./scripts/smoke-check.sh --install       # additionally exercise install.sh against ~/.claude
#   ./scripts/smoke-check.sh --reinstall     # uninstall first, then install (destructive: replaces manifest)
#   ./scripts/smoke-check.sh -h              # this help

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

INSTALL=0
REINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --install)   INSTALL=1 ;;
    --reinstall) INSTALL=1; REINSTALL=1 ;;
    -h|--help)
      sed -n '2,15p' "$0"; exit 0 ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 2
      ;;
  esac
done

PASS=0
FAIL=0

step() {
  echo
  echo "─── $1 ─────────────────────────────────────────"
}

ok() { echo "  ✓ $1"; PASS=$((PASS+1)); }
bad() { echo "  ✗ $1" >&2; FAIL=$((FAIL+1)); }

# ─── Step 1: every SKILL.md validates ────────────────────────────────
step "validate-skill.sh on every shipped SKILL.md"

SKILLS=()
while IFS= read -r line; do SKILLS+=("$line"); done < <(find skills roles -name SKILL.md -type f | sort)
echo "  scanning ${#SKILLS[@]} skill files..."

if ./scripts/validate-skill.sh "${SKILLS[@]}" >/tmp/hornero-validate.log 2>&1; then
  ok "all ${#SKILLS[@]} skills passed anatomy lint"
else
  bad "validate-skill.sh failed (see /tmp/hornero-validate.log)"
  tail -20 /tmp/hornero-validate.log >&2
fi

# ─── Step 2: every ROLE.md has the required frontmatter ──────────────
step "ROLE.md frontmatter check"

ROLE_FAIL=0
for role_md in roles/*/ROLE.md; do
  for field in name description mode; do
    if ! awk '/^---$/{c++; next} c==1' "$role_md" | grep -q "^${field}:"; then
      bad "$role_md missing frontmatter field: $field"
      ROLE_FAIL=1
    fi
  done
done
[[ $ROLE_FAIL -eq 0 ]] && ok "all 7 ROLE.md files have name + description + mode"

# ─── Step 3: every agents/<role>-reviewer.md has the required fields ─
step "agents/ subagent frontmatter check"

AGENT_FAIL=0
for agent_md in agents/*.md; do
  [[ "$(basename "$agent_md")" == ".gitkeep" ]] && continue
  for field in name description tools; do
    if ! awk '/^---$/{c++; next} c==1' "$agent_md" | grep -q "^${field}:"; then
      bad "$agent_md missing frontmatter field: $field"
      AGENT_FAIL=1
    fi
  done
done
agent_count=$(find agents -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')
[[ $AGENT_FAIL -eq 0 ]] && ok "all $agent_count agent definitions have name + description + tools"

# ─── Step 4: CATALOG.md is up to date ────────────────────────────────
step "CATALOG.md drift check"

cp CATALOG.md /tmp/hornero-catalog-before.md
./scripts/catalog.sh >/dev/null
if diff -q /tmp/hornero-catalog-before.md CATALOG.md >/dev/null; then
  ok "CATALOG.md is up to date"
else
  bad "CATALOG.md was stale — regenerated. Commit the change."
  diff /tmp/hornero-catalog-before.md CATALOG.md | head -20 >&2
fi
rm -f /tmp/hornero-catalog-before.md

# ─── Step 5: every CATALOG-listed skill name resolves to a file ──────
step "CATALOG.md → SKILL.md resolution"

RESOLVE_FAIL=0
# Extract skill names from the catalog tables (anything in `backticks` in the
# first column of a row starting with `| \``)
CATALOG_NAMES=()
while IFS= read -r line; do CATALOG_NAMES+=("$line"); done < <(grep -E "^\| \`[a-z][a-z0-9-]+\`" CATALOG.md | sed -E 's/^\| `([^`]+)`.*/\1/' | sort -u)

# Build a set of actual skill names from the filesystem (cross-role skills, per-role skills, and role names)
FS_NAMES=()
while IFS= read -r line; do FS_NAMES+=("$line"); done < <(
  find skills -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
  find roles -mindepth 3 -maxdepth 3 -type d -path "*/skills/*" -exec basename {} \;
  find roles -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
)

for name in "${CATALOG_NAMES[@]}"; do
  found=0
  for fs in "${FS_NAMES[@]}"; do
    if [[ "$fs" == "$name" ]]; then found=1; break; fi
  done
  if [[ $found -eq 0 ]]; then
    bad "CATALOG.md lists '$name' but no matching directory exists"
    RESOLVE_FAIL=1
  fi
done
[[ $RESOLVE_FAIL -eq 0 ]] && ok "every CATALOG entry resolves (${#CATALOG_NAMES[@]} entries checked)"

# ─── Step 6: install.sh --dry-run shows the expected count ───────────
step "install.sh --dry-run count"

DRY_LOG=/tmp/hornero-dry.log
./install.sh --dry-run >"$DRY_LOG" 2>&1 || true

expected_skills=$(find skills roles -name SKILL.md -type f | wc -l | tr -d ' ')
expected_agents=$(find agents -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')
expected_total=$((expected_skills + expected_agents))

actual_total=$(grep -c "would install:" "$DRY_LOG" || true)

if [[ "$expected_total" == "$actual_total" ]]; then
  ok "install.sh --dry-run reports $actual_total files (matches $expected_skills skills + $expected_agents agents)"
else
  bad "install.sh --dry-run mismatch: expected $expected_total, got $actual_total (see $DRY_LOG)"
fi

# ─── Step 7 (optional): real install + verify ─────────────────────────
if [[ $INSTALL -eq 1 ]]; then
  step "install.sh against ~/.claude"

  if [[ $REINSTALL -eq 1 && -f "$HOME/.claude/.hornero-manifest" ]]; then
    echo "  --reinstall: uninstalling first..."
    ./install.sh --uninstall >/tmp/hornero-uninstall.log 2>&1 || true
    ok "uninstall completed"
  fi

  ./install.sh --force >/tmp/hornero-install.log 2>&1 || true

  if [[ -f "$HOME/.claude/.hornero-manifest" ]]; then
    installed_count=$(wc -l < "$HOME/.claude/.hornero-manifest" | tr -d ' ')
    if [[ "$installed_count" == "$expected_total" ]]; then
      ok "manifest lists $installed_count files (matches expected $expected_total)"
    else
      bad "manifest count $installed_count != expected $expected_total"
    fi

    # Spot-check: every manifest path exists
    missing=0
    while IFS= read -r path; do
      [[ -z "$path" ]] && continue
      [[ ! -f "$path" ]] && { bad "manifest path missing on disk: $path"; missing=1; }
    done < "$HOME/.claude/.hornero-manifest"
    [[ $missing -eq 0 ]] && ok "every manifest path exists on disk"
  else
    bad "no manifest written to ~/.claude/.hornero-manifest"
  fi
fi

# ─── Summary ──────────────────────────────────────────────────────────
echo
echo "─── Summary ───────────────────────────────────────"
echo "  ✓ $PASS passed"
echo "  ✗ $FAIL failed"
echo

if [[ $FAIL -eq 0 ]]; then
  echo "smoke-check: PASS"
  exit 0
else
  echo "smoke-check: FAIL" >&2
  exit 1
fi
