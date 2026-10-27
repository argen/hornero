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
while IFS= read -r line; do SKILLS+=("$line"); done < <(find skills -name SKILL.md -type f | sort)
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
role_count=$(find roles -mindepth 2 -maxdepth 2 -name ROLE.md -type f | wc -l | tr -d ' ')
[[ $ROLE_FAIL -eq 0 ]] && ok "all $role_count ROLE.md files have name + description + mode"

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

# Build a set of valid names from the filesystem: skills, role names, and
# resources. Anything CATALOG.md references must resolve
# to one of these.
FS_NAMES=()
while IFS= read -r line; do FS_NAMES+=("$line"); done < <(
  find skills -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
  find roles -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
  find resources -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null
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
# install.sh refuses to run without ~/.claude; CI runners have none, so point HOME at a scratch dir.
DRY_HOME=$(mktemp -d); mkdir -p "$DRY_HOME/.claude"
HOME="$DRY_HOME" ./install.sh --dry-run >"$DRY_LOG" 2>&1 || true
rm -rf "$DRY_HOME"

expected_skills=$(find skills -mindepth 2 -type f ! -name '.*' | wc -l | tr -d ' ')
expected_agents=$(find agents -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')
expected_resources=$(find resources -mindepth 2 -maxdepth 2 -name RESOURCE.md -type f 2>/dev/null | wc -l | tr -d ' ')
expected_total=$((expected_skills + expected_agents + expected_resources))

actual_total=$(grep -c "would install:" "$DRY_LOG" || true)

if [[ "$expected_total" == "$actual_total" ]]; then
  ok "install.sh --dry-run reports $actual_total files (matches $expected_skills skills + $expected_agents agents + $expected_resources resources)"
else
  bad "install.sh --dry-run mismatch: expected $expected_total, got $actual_total (see $DRY_LOG)"
fi

# ─── Step 7: flat skills layout ───────────────────────────────────────
step "skills/ layout (no symlinks; role: names a real role)"

LAYOUT_FAIL=0

while IFS= read -r link; do
  bad "symlink under skills/: $link (skills must be real directories)"
  LAYOUT_FAIL=1
done < <(find skills -type l)

for skill_md in skills/*/SKILL.md; do
  role=$(awk '/^---$/{c++; next} c==1 && /^role:/{sub(/^role:[[:space:]]*/,""); print; exit}' "$skill_md")
  [[ -z "$role" ]] && continue
  if [[ ! -f "roles/${role}/ROLE.md" ]]; then
    bad "$skill_md: role '$role' has no roles/${role}/ROLE.md"
    LAYOUT_FAIL=1
  fi
done

if [[ $LAYOUT_FAIL -eq 0 ]]; then
  role_skill_count=$(grep -l '^role:' skills/*/SKILL.md | wc -l | tr -d ' ')
  total_skill_count=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
  ok "$total_skill_count skill dirs, none symlinked; $role_skill_count carry a valid role:"
fi

# ─── Step 8: Codex plugin manifest + agent TOMLs ──────────────────────
step "Codex plugin parity (.codex-plugin/plugin.json + .codex/agents/*.toml)"

CODEX_FAIL=0

# 8a. .codex-plugin/plugin.json exists and parses as JSON.
if [[ ! -f .codex-plugin/plugin.json ]]; then
  bad ".codex-plugin/plugin.json missing"
  CODEX_FAIL=1
elif ! python3 -m json.tool .codex-plugin/plugin.json >/dev/null 2>&1; then
  bad ".codex-plugin/plugin.json is not valid JSON"
  CODEX_FAIL=1
fi

# 8b. .codex-plugin name + version match .claude-plugin (stay-in-sync invariant).
if [[ -f .codex-plugin/plugin.json && -f .claude-plugin/plugin.json ]]; then
  for field in name version; do
    claude_val=$(python3 -c "import json; print(json.load(open('.claude-plugin/plugin.json')).get('${field}', ''))" 2>/dev/null)
    codex_val=$(python3 -c "import json; print(json.load(open('.codex-plugin/plugin.json')).get('${field}', ''))" 2>/dev/null)
    if [[ "$claude_val" != "$codex_val" ]]; then
      bad "manifest ${field} drift: .claude-plugin='${claude_val}' .codex-plugin='${codex_val}'"
      CODEX_FAIL=1
    fi
  done
fi

# 8c. Every agents/*.md has a corresponding .codex/agents/<name>.toml that parses.
for src in agents/*.md; do
  [[ -f "$src" ]] || continue
  [[ "$(basename "$src")" == ".gitkeep" ]] && continue
  name=$(awk '/^---$/{c++; next} c==1 && /^name:/{sub(/^name:[[:space:]]*/,""); print; exit}' "$src")
  target=".codex/agents/${name}.toml"
  if [[ ! -f "$target" ]]; then
    bad "missing Codex agent: $target (run scripts/build-codex-agents.sh)"
    CODEX_FAIL=1
    continue
  fi
  if ! python3 -c "import tomllib; tomllib.load(open('${target}','rb'))" >/dev/null 2>&1; then
    bad "Codex agent TOML fails to parse: $target"
    CODEX_FAIL=1
    continue
  fi
  # Codex ignores sandbox_mode in custom agent files (subagents inherit the parent
  # sandbox), so a generated TOML carrying it is stale; it must set an effort instead.
  if grep -q '^sandbox_mode' "$target"; then
    bad "stale sandbox_mode in $target (run scripts/build-codex-agents.sh)"
    CODEX_FAIL=1
  fi
  if ! grep -q '^model_reasoning_effort = "medium"' "$target"; then
    bad "missing model_reasoning_effort in $target (run scripts/build-codex-agents.sh)"
    CODEX_FAIL=1
  fi
  # Description in TOML must match description in Markdown frontmatter.
  md_desc=$(awk '/^---$/{c++; next} c==1 && /^description:/{
    sub(/^description:[[:space:]]*/,""); sub(/[[:space:]]+$/,"")
    if ($0 ~ /^".*"$/) { $0 = substr($0, 2, length($0) - 2); gsub(/\\"/, "\"") }
    print; exit}' "$src")
  toml_desc=$(python3 -c "import tomllib; print(tomllib.load(open('${target}','rb')).get('description',''))" 2>/dev/null)
  if [[ "$md_desc" != "$toml_desc" ]]; then
    bad "description drift: $src ↔ $target (run scripts/build-codex-agents.sh)"
    CODEX_FAIL=1
  fi
done

if [[ $CODEX_FAIL -eq 0 ]]; then
  agent_count=$(find .codex/agents -maxdepth 1 -name '*.toml' -type f | wc -l | tr -d ' ')
  ok "manifest valid + in sync; ${agent_count} Codex agent TOMLs parse and match Markdown sources"
fi

# ─── Step 9: every RESOURCE.md validates ─────────────────────────────
step "validate-resource.sh on every resources/*/RESOURCE.md"

RESOURCES=()
if [[ -d resources ]]; then
  while IFS= read -r line; do RESOURCES+=("$line"); done < <(find resources -name RESOURCE.md -type f | sort)
fi

if [[ ${#RESOURCES[@]} -eq 0 ]]; then
  ok "no resources/ shipped yet — skipping resource validation"
else
  echo "  scanning ${#RESOURCES[@]} resource files..."
  if ./scripts/validate-resource.sh "${RESOURCES[@]}" >/tmp/hornero-validate-resource.log 2>&1; then
    ok "all ${#RESOURCES[@]} resources passed anatomy lint"
  else
    bad "validate-resource.sh failed (see /tmp/hornero-validate-resource.log)"
    tail -20 /tmp/hornero-validate-resource.log >&2
  fi
fi

# ─── Step 10: bidirectional skill ↔ resource cross-reference ─────────
step "skill resources: ↔ RESOURCE.md used_by: bidirectional cross-ref"

XREF_FAIL=0

# 10a. Every skill `resources:` slug must resolve to a real RESOURCE.md.
#      Frontmatter shape: `resources:\n  - linear\n  - jira` OR `resources: [linear, jira]`.
while IFS= read -r skill_md; do
  fm=$(awk '/^---$/{c++; next} c==1' "$skill_md")
  # Capture the `resources:` block — either inline list or YAML block scalar.
  inline=$(echo "$fm" | awk '/^resources:[[:space:]]*\[/{ sub(/^resources:[[:space:]]*\[/,""); sub(/\].*/,""); gsub(/[ \t]/,""); print }')
  block=$(echo "$fm" | awk '
    /^resources:[[:space:]]*$/ { in_block=1; next }
    in_block && /^[[:space:]]+-/ { sub(/^[[:space:]]+-[[:space:]]*/,""); print; next }
    in_block && /^[^[:space:]]/ { exit }
  ')
  slugs=$(printf '%s\n%s\n' "$inline" "$block" | tr ',' '\n' | sed '/^$/d' | sort -u)
  for slug in $slugs; do
    if [[ ! -f "resources/${slug}/RESOURCE.md" ]]; then
      bad "$skill_md cites resources/${slug} but resources/${slug}/RESOURCE.md does not exist"
      XREF_FAIL=1
    fi
  done
done < <(find skills -name SKILL.md -type f)

# 10b. Every RESOURCE.md `used_by:` slug must resolve to a real SKILL.md.
#      Slug shape: `<skill>` (a legacy `<role>/<skill>` prefix is tolerated).
#      Parses both YAML shapes (inline `used_by: [a, b]` and block list `- a\n- b`).
#      Known limitation: only verifies the file path resolves; does not catch the
#      case where a stale `<role>/` prefix happens to coincide with another real
#      skill path.
if [[ -d resources ]]; then
  while IFS= read -r res_md; do
    fm=$(awk '/^---$/{c++; next} c==1' "$res_md")
    inline=$(echo "$fm" | awk '/^used_by:[[:space:]]*\[/{ sub(/^used_by:[[:space:]]*\[/,""); sub(/\].*/,""); gsub(/[ \t]/,""); print }')
    block=$(echo "$fm" | awk '
      /^used_by:[[:space:]]*$/ { in_block=1; next }
      in_block && /^[[:space:]]+-/ { sub(/^[[:space:]]+-[[:space:]]*/,""); print; next }
      in_block && /^[^[:space:]]/ { exit }
    ')
    refs=$(printf '%s\n%s\n' "$inline" "$block" | tr ',' '\n' | sed '/^$/d')
    for ref in $refs; do
      # Strip quotes if present
      ref="${ref//\"/}"; ref="${ref//\'/}"
      # A legacy "<role>/" prefix is tolerated; skills are flat now.
      target="skills/${ref##*/}/SKILL.md"
      if [[ ! -f "$target" ]]; then
        bad "$res_md back-references $ref but $target does not exist"
        XREF_FAIL=1
      fi
    done
  done < <(find resources -name RESOURCE.md -type f)
fi

if [[ $XREF_FAIL -eq 0 ]]; then
  ok "skill ↔ resource cross-references are consistent"
fi

# ─── Step 11: chronicle harness (validate + deterministic harness) ────
step "chronicle: validate + deterministic harness"

if [[ -x ./scripts/chronicle.sh ]]; then
  if ./scripts/chronicle.sh validate >/tmp/hornero-chronicle-validate.log 2>&1; then
    ok "$(tail -1 /tmp/hornero-chronicle-validate.log)"
  else
    bad "chronicle.sh validate failed (see /tmp/hornero-chronicle-validate.log)"
    tail -20 /tmp/hornero-chronicle-validate.log >&2
  fi
else
  bad "scripts/chronicle.sh missing or not executable"
fi

if [[ -x ./scripts/test-chronicle.sh ]]; then
  if ./scripts/test-chronicle.sh >/tmp/hornero-chronicle-test.log 2>&1; then
    ok "$(tail -1 /tmp/hornero-chronicle-test.log)"
  else
    bad "test-chronicle.sh failed (see /tmp/hornero-chronicle-test.log)"
    tail -25 /tmp/hornero-chronicle-test.log >&2
  fi
else
  bad "scripts/test-chronicle.sh missing or not executable"
fi

# ─── Step 12: dispatcher routing fixtures ────────────────────────────
step "dispatcher: routing fixtures + catalog description completeness"

if [[ -x ./scripts/validate-dispatcher.sh ]]; then
  if ./scripts/validate-dispatcher.sh >/tmp/hornero-dispatcher.log 2>&1; then
    ok "$(grep -c '✓' /tmp/hornero-dispatcher.log 2>/dev/null || echo 0) dispatcher checks passed"
  else
    bad "validate-dispatcher.sh failed (see /tmp/hornero-dispatcher.log)"
    tail -20 /tmp/hornero-dispatcher.log >&2
  fi
else
  bad "scripts/validate-dispatcher.sh missing or not executable"
fi

# ─── Step 13: claude plugin validate on a dereferenced copy ──────────
step "claude plugin validate (dereferenced copy)"

if ! command -v claude >/dev/null 2>&1; then
  echo "  skipped: claude CLI not installed"
else
  DEREF="$(mktemp -d)"
  trap 'rm -rf "$DEREF"' EXIT
  # The validator does not follow symlinks; a running session does. Copy only tracked
  # files (working-tree content), then replace each symlink with a copy of its target.
  # Without --strict: --strict also fails on directory-profile warnings (icon, CLAUDE.md at root).
  git ls-files -z | tar --null -T - -cf - | tar -xf - -C "$DEREF"
  while IFS= read -r -d '' link; do
    [[ -L "$link" ]] || continue
    rel="${link#"$DEREF"/}"
    tgt="$(readlink "$link")"
    [[ "$tgt" == /* ]] || tgt="$PWD/$(dirname "$rel")/$tgt"
    rm "$link"
    if [[ -e "$tgt" ]]; then
      cp -RL "$tgt" "$link"
    else
      echo "  warning: dangling symlink skipped: $rel" >&2
    fi
  done < <(find "$DEREF" -type l -print0)
  find "$DEREF" -name .DS_Store -delete
  if claude plugin validate "$DEREF" >/tmp/hornero-plugin-validate.log 2>&1; then
    ok "claude plugin validate passed (errors only; warnings tolerated)"
  else
    bad "claude plugin validate failed (see /tmp/hornero-plugin-validate.log)"
    { grep -E '✘|❯' /tmp/hornero-plugin-validate.log | head -20 || true; tail -20 /tmp/hornero-plugin-validate.log; } >&2
  fi
  rm -rf "$DEREF"
fi

# ─── Step 14: relative markdown links resolve ─────────────────────────
step "relative markdown link existence (scripts/check-md-links.sh)"

if ./scripts/check-md-links.sh >/tmp/hornero-md-links.log 2>&1; then
  ok "$(tail -1 /tmp/hornero-md-links.log | sed 's/^✓ //')"
else
  bad "broken relative markdown links (see /tmp/hornero-md-links.log)"
  head -30 /tmp/hornero-md-links.log >&2
fi

# ─── Step 15 (optional): real install + verify ────────────────────────
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
