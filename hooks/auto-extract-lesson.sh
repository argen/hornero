#!/usr/bin/env bash
# Stop-hook helper: automatically triggers lesson extraction at session end.
#
# Reads Claude Code's Stop hook payload from stdin. If this is a re-stop
# (the agent has already addressed our previous directive), exits silently
# so the session can end. Otherwise emits a `decision: block` directive
# instructing the agent to scan the session for lesson signal and produce
# proposals via the extract-lesson skill — without the user having to
# type /extract-lesson explicitly.
#
# Honoured opt-outs:
#   HORNERO_NO_AUTO_EXTRACT=1   — disable for this session only
#
# Failure modes are deliberate no-ops: if anything goes wrong (jq missing,
# malformed payload, unwritable stdout), the hook exits 0 silently so the
# session is never blocked by hook breakage.

set -u

# Opt-out: respect user preference if set.
if [[ "${HORNERO_NO_AUTO_EXTRACT:-0}" == "1" ]]; then
  exit 0
fi

# Read Claude Code's hook payload (JSON on stdin). Cap at 64KB to avoid
# pathological inputs — the only field we read is small.
payload=$(head -c 65536 2>/dev/null || true)

# If stop_hook_active is true, the agent already saw our previous block
# directive and acted on it. Don't loop — let the session stop.
if printf '%s' "$payload" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

# Emit the Stop-hook directive. Claude Code reads JSON on stdout: a
# `decision: block` response feeds `reason` back to the model as a
# follow-up instruction. The instruction tells the agent to self-filter
# (most sessions have no real signal and should stop in one line).
cat <<'JSON'
{"decision":"block","reason":"Before ending the session, run the extract-lesson skill (skills/extract-lesson/SKILL.md). Scan the conversation for: (1) corrections the user made to your approach; (2) surprises that revealed a missing guardrail; (3) validated non-obvious approaches the user explicitly approved; (4) patterns that recurred across this session. If you find genuine signal — not routine task completion — produce up to 3 concrete proposals per the skill's Step 4, each naming a target file (role / skill / CLAUDE.md / AGENTS.md / project memory) and the exact change. Then ask the user to accept / edit / reject each one. If the session had no real signal, say 'No lessons to extract — routine task completion.' in one line and stop. Do not edit harness files without explicit user approval (Pitfall 2). To opt out of automatic extraction for a session, the user can set HORNERO_NO_AUTO_EXTRACT=1 in the shell environment before launching Claude Code."}
JSON
