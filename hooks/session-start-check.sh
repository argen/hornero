#!/usr/bin/env bash
# session-start-check.sh — lightweight structural guard on SessionStart.
#
# Checks that the three files the dispatcher and chronicle layer depend on
# are present. Runs in ~1s (no skill validation, no catalog regeneration).
# Warns on stderr if any are missing; does not block the session.
#
# End users don't modify harness files, so a warning is enough — they can
# flag the issue and it will resolve on the next `smoke-check.sh` run.

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

MISSING=0

for required_file in \
  "CATALOG.md" \
  "DISPATCHER.md" \
  "chronicle/SCHEMA.md"
do
  if [[ ! -f "${PLUGIN_ROOT}/${required_file}" ]]; then
    echo "Hornero: WARNING — ${required_file} missing from ${PLUGIN_ROOT}" >&2
    echo "  Run \`bash scripts/smoke-check.sh\` to diagnose." >&2
    MISSING=$((MISSING+1))
  fi
done

exit 0  # Always exit 0 — structural warnings must not block the session
