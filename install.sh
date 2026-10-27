#!/usr/bin/env bash
# install.sh — install Hornero into ~/.claude and/or ~/.codex
#
# Optional. Hornero already works as the project itself: clone the repo,
# open it in Claude Code or Codex, and CLAUDE.md / AGENTS.md will be read
# from the repo root. Run this installer only if you want the roles, skills,
# subagents, and slash commands (skills with type: command) available
# globally across all your projects.
#
# Usage:
#   ./install.sh                    # Claude Code only (default)
#   ./install.sh --claude           # Claude Code only (explicit)
#   ./install.sh --codex            # Codex only — full set (skills + agents + hooks)
#   ./install.sh --both             # Claude Code + Codex
#   ./install.sh --force            # overwrite without asking
#   ./install.sh --dry-run          # show what would be installed; don't write
#   ./install.sh --uninstall        # remove Hornero-installed files
#   ./install.sh --list-resources   # print the resource catalog (no install)
#
# What gets installed where (slash commands ship as skills):
#   Claude target: skills (flat, one dir per skill) → ~/.claude/skills/
#                  reviewer agent              → ~/.claude/agents/
#                  resource cards (read-only)   → ~/.claude/hornero-resources/
#   Codex target:  skills (flat layout)          → ~/.agents/skills/ (shared cross-agent path)
#                  reviewer agent (TOML)       → ~/.codex/agents/
#                  session hooks                → ~/.codex/hooks.json
#                  resource cards (read-only)   → ~/.codex/hornero-resources/
#                  (AGENTS.md is read from the current working directory;
#                   no install step needed for the dispatcher itself.)
#
# Lighter path for skills only, across ~75 agents (no agents/hooks/resources):
#   npx skills add argen/hornero

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
CODEX_DIR="${HOME}/.codex"
AGENTS_SKILLS_DIR="${HOME}/.agents/skills"
MANIFEST="${REPO_DIR}/.hornero-manifest"

FORCE=0
DRY_RUN=0
UNINSTALL=0
LIST_RESOURCES=0
TARGET="claude"  # claude | codex | both

for arg in "$@"; do
  case "$arg" in
    --claude)          TARGET="claude" ;;
    --codex)           TARGET="codex" ;;
    --both)            TARGET="both" ;;
    --force)           FORCE=1 ;;
    --dry-run)         DRY_RUN=1 ;;
    --uninstall)       UNINSTALL=1 ;;
    --list-resources)  LIST_RESOURCES=1 ;;
    -h|--help)
      sed -n '2,33p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown flag: $arg" >&2
      exit 2
      ;;
  esac
done

# ---------- --list-resources (short-circuit) ----------
if [[ $LIST_RESOURCES -eq 1 ]]; then
  if [[ ! -d "${REPO_DIR}/resources" ]]; then
    echo "No resources/ directory found at ${REPO_DIR}/resources" >&2
    exit 1
  fi
  echo "Hornero resources (read-only data-source cards)"
  echo "─────────────────────────────────────────────────"
  printf "%-14s  %-12s  %s\n" "slug" "status" "consumers"
  printf "%-14s  %-12s  %s\n" "----" "------" "---------"
  for card in "${REPO_DIR}/resources"/*/RESOURCE.md; do
    [[ -f "$card" ]] || continue
    slug=$(basename "$(dirname "$card")")
    status=$(awk '/^---$/{c++; next} c==1 && /^status:/{ sub(/^status:[[:space:]]*/,""); print; exit }' "$card")
    # Count used_by entries (inline + block) — same parse as smoke-check.
    inline=$(awk '/^---$/{c++; next} c==1 && /^used_by:[[:space:]]*\[/{ sub(/^used_by:[[:space:]]*\[/,""); sub(/\].*/,""); gsub(/[ \t]/,""); print }' "$card")
    block=$(awk '/^---$/{c++; next} c==1 {
      if (in_block && /^[[:space:]]+-/) { sub(/^[[:space:]]+-[[:space:]]*/,""); print; next }
      if (in_block && /^[^[:space:]]/) { in_block=0 }
      if (/^used_by:[[:space:]]*$/) { in_block=1; next }
    }' "$card")
    count=$(printf '%s\n%s\n' "$inline" "$block" | tr ',' '\n' | sed '/^$/d' | wc -l | tr -d ' ')
    printf "%-14s  %-12s  %d skill(s)\n" "$slug" "$status" "$count"
  done
  echo
  echo "Each card lives at resources/<slug>/RESOURCE.md and documents the MCP"
  echo "server, auth, object model, and curl-based fallback. Skills opt in via"
  echo "their frontmatter \`resources:\` field; Hornero stays usable when no MCP"
  echo "server is configured (graceful degradation via the Fallback section)."
  exit 0
fi

want_claude() { [[ "$TARGET" == "claude" || "$TARGET" == "both" ]]; }
want_codex()  { [[ "$TARGET" == "codex"  || "$TARGET" == "both" ]]; }

echo "Hornero installer"
echo "  Repo:    ${REPO_DIR}"
echo "  Target:  ${TARGET}"
want_claude && echo "  Claude:  ${CLAUDE_DIR}"
want_codex  && echo "  Codex:   ${CODEX_DIR}"
echo

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

# ---------- Pre-flight ----------
if want_claude && [[ ! -d "${CLAUDE_DIR}" ]]; then
  echo "✗ ${CLAUDE_DIR} not found. Is Claude Code installed?" >&2
  echo "  (use --codex to install Codex-only, or --both to attempt both)" >&2
  exit 1
fi

if want_codex && [[ ! -d "${CODEX_DIR}" ]]; then
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "Note: ${CODEX_DIR} not found. Would create it (or skip Codex if Codex CLI isn't installed)."
  else
    echo "Note: ${CODEX_DIR} not found — creating. If you don't have Codex CLI installed yet, this is harmless."
    mkdir -p "${CODEX_DIR}"
  fi
fi

# Reset manifest at start of fresh install (dry-run does not touch manifest)
[[ $DRY_RUN -eq 0 ]] && : > "${MANIFEST}.tmp"

PLANNED="$(mktemp)"
trap 'rm -f "$PLANNED"' EXIT

record() {
  echo "$1" >> "$PLANNED"
  [[ $DRY_RUN -eq 0 ]] && echo "$1" >> "${MANIFEST}.tmp"
  return 0
}

confirm_overwrite() {
  local target="$1"
  [[ ! -e "$target" ]] && return 0
  [[ $FORCE -eq 1 ]] && return 0
  [[ $DRY_RUN -eq 1 ]] && return 0
  local ans=""
  if ! read -r -p "  Overwrite ${target}? [y/N] " ans </dev/tty 2>/dev/null; then
    echo "  (no tty; refusing overwrite of ${target}; use --force to override)" >&2
    return 1
  fi
  [[ "$ans" == "y" || "$ans" == "Y" ]]
}

copy_file() {
  local src="$1" target="$2" label="$3"
  if confirm_overwrite "$target"; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  would install: ${src#${REPO_DIR}/}  →  ${target}"
      record "$target"
    else
      mkdir -p "$(dirname "$target")"
      cp "$src" "$target"
      echo "  installed:    ${label}"
      record "$target"
    fi
  else
    echo "  skipped:      ${label}"
    # a declined overwrite is still ours if the previous install wrote it
    if [[ -f "${MANIFEST}" ]] && grep -qxF "$target" "${MANIFEST}"; then record "$target"; fi
  fi
}

skill_name() {
  local rel="${1#${REPO_DIR}/skills/}"
  echo "${rel%%/*}"
}

install_skill() {
  local src="$1" name="$2"
  local rel="${src#${REPO_DIR}/skills/${name}/}"
  copy_file "$src" "${CLAUDE_DIR}/skills/${name}/${rel}" "skill: ${name}/${rel}"
}

install_agent() {
  local src="$1"
  local fname; fname=$(basename "$src")
  copy_file "$src" "${CLAUDE_DIR}/agents/${fname}" "agent: ${fname}"
}

install_codex_skill() {
  local src="$1" name="$2"
  local rel="${src#${REPO_DIR}/skills/${name}/}"
  copy_file "$src" "${AGENTS_SKILLS_DIR}/${name}/${rel}" "codex skill: ${name}/${rel}"
}

install_codex_agent() {
  local src="$1"
  local fname; fname=$(basename "$src")
  copy_file "$src" "${CODEX_DIR}/agents/${fname}" "codex agent: ${fname}"
}

install_codex_hooks() {
  local src="$1"
  copy_file "$src" "${CODEX_DIR}/hooks.json" "codex hooks"
}

install_resource_cards() {
  # Copy resources/<slug>/RESOURCE.md into <host_dir>/hornero-resources/<slug>/
  # so installed skills can resolve relative cross-refs even when the repo
  # checkout isn't on disk. Read-only; never auto-mutated by Hornero.
  local host_dir="$1" label_prefix="$2"
  [[ -d "${REPO_DIR}/resources" ]] || return 0
  for card in "${REPO_DIR}/resources"/*/RESOURCE.md; do
    [[ -f "$card" ]] || continue
    local slug; slug=$(basename "$(dirname "$card")")
    copy_file "$card" "${host_dir}/hornero-resources/${slug}/RESOURCE.md" "${label_prefix} resource: ${slug}"
  done
}

# ---------- Claude install ----------
if want_claude; then
  echo "Claude — skills:"
  while IFS= read -r -d '' file; do
    name=$(skill_name "$file")
    install_skill "$file" "$name"
  done < <(find "${REPO_DIR}/skills" -mindepth 2 -type f ! -name '.*' -print0 2>/dev/null)

  echo
  echo "Claude — reviewer agent:"
  if [[ -d "${REPO_DIR}/agents" ]]; then
    for f in "${REPO_DIR}/agents"/*.md; do
      [[ -f "$f" ]] || continue
      install_agent "$f"
    done
  fi

  echo
  echo "Claude — resource cards (→ ${CLAUDE_DIR}/hornero-resources/):"
  install_resource_cards "${CLAUDE_DIR}" "claude"
fi

# ---------- Codex install ----------
if want_codex; then
  echo
  echo "Codex — skills (→ ${AGENTS_SKILLS_DIR}/, shared by Codex, Cursor, Copilot, Gemini CLI):"
  while IFS= read -r -d '' file; do
    name=$(skill_name "$file")
    install_codex_skill "$file" "$name"
  done < <(find "${REPO_DIR}/skills" -mindepth 2 -type f ! -name '.*' -print0 2>/dev/null)

  echo
  echo "Codex — reviewer agent (TOML → ${CODEX_DIR}/agents/):"
  if [[ -d "${REPO_DIR}/.codex/agents" ]]; then
    for f in "${REPO_DIR}/.codex/agents"/*.toml; do
      [[ -f "$f" ]] || continue
      install_codex_agent "$f"
    done
  else
    echo "  ✗ ${REPO_DIR}/.codex/agents not found — run ./scripts/build-codex-agents.sh first" >&2
  fi

  echo
  echo "Codex — session hooks (→ ${CODEX_DIR}/hooks.json):"
  if [[ -f "${REPO_DIR}/hooks/hooks.json" ]]; then
    install_codex_hooks "${REPO_DIR}/hooks/hooks.json"
  fi

  echo
  echo "Codex — resource cards (→ ${CODEX_DIR}/hornero-resources/):"
  install_resource_cards "${CODEX_DIR}" "codex"

  echo
  echo "  Skills-only alternative for any agent: npx skills add argen/hornero"
  echo "  Note: AGENTS.md is read by Codex from the current working directory."
  echo "  If you want Hornero's dispatcher protocol active in every project,"
  echo "  copy AGENTS.md into the project root, or invoke Codex from inside"
  echo "  the Hornero repo."
fi

# ---------- Prune files the previous install wrote but this one does not ----------
# Covers layouts from older versions (commands/, prompts/, <role>-<skill>/).
# Entries outside the targets being installed are carried over untouched.
if [[ -f "${MANIFEST}" ]]; then
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    in_scope=0
    want_claude && [[ "$path" == "${CLAUDE_DIR}/"* ]] && in_scope=1
    want_codex  && [[ "$path" == "${CODEX_DIR}/"*  ]] && in_scope=1
    want_codex  && [[ "$path" == "${AGENTS_SKILLS_DIR}/"* ]] && in_scope=1
    if [[ $in_scope -eq 0 ]]; then
      [[ $DRY_RUN -eq 0 ]] && echo "$path" >> "${MANIFEST}.tmp"
      continue
    fi
    grep -qxF "$path" "$PLANNED" && continue
    if [[ -e "$path" ]]; then
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "  would remove stale: ${path}"
      else
        echo "  removed stale: ${path}"
        rm -f "$path"
        rmdir "$(dirname "$path")" 2>/dev/null || true
      fi
    fi
  done < "${MANIFEST}"
fi

# Finalize manifest
if [[ $DRY_RUN -eq 0 ]]; then
  mv "${MANIFEST}.tmp" "${MANIFEST}"
  echo
  echo "Manifest written to ${MANIFEST}"
fi

# Stop hook recommendation
if want_claude; then
  echo
  echo "──────────────────────────────────────────────────────────────"
  echo "Recommended addition to ${CLAUDE_DIR}/settings.json:"
  cat <<EOF

  "hooks": {
    "Stop": [
      { "command": "bash ${REPO_DIR}/hooks/auto-extract-lesson.sh" }
    ]
  }

EOF
  echo "(auto-runs extract-lesson at session end; opt out with HORNERO_NO_AUTO_EXTRACT=1)"
  echo "──────────────────────────────────────────────────────────────"
fi

echo
echo "Next steps:"
echo "  1. Open playbooks/onboarding.md  (or run /kickoff in your AI tool)"
echo "  2. Try a real task — e.g. /kickoff, /orchestrate, or /role product-manager <task>"
echo "  3. Run /harness-check on your current repo"
echo
[[ $DRY_RUN -eq 1 ]] && echo "(dry run — nothing was written)"
