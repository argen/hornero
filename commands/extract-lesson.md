---
description: Scan the current session for surprises and corrections; propose durable updates to roles, skills, CLAUDE.md, or AGENTS.md. Run habitually — the harness compounds only when lessons feed back.
---

# /extract-lesson

The user is ending a working session and wants to capture what should outlast it.

## What to do

1. **Load and follow [`skills/extract-lesson/SKILL.md`](../../skills/extract-lesson/SKILL.md)** — it is the canonical procedure. Do not improvise.

2. **Scan the conversation** (and recent commits if relevant) for:
   - Surprises — moments where the agent's first instinct was wrong.
   - Corrections — direct user feedback ("no", "stop doing X", "yes that was right").
   - Repeated rework — patterns the skill/role definitions should have prevented.
   - Validated approaches — non-obvious choices the user confirmed.

3. **Propose specific deltas** — exact files, exact edits. Not "we should update the security role"; instead, "update `roles/security-expert/ROLE.md` line 47 to add: ...".

   Candidate targets:
   - A role's `ROLE.md` (mindset/heuristics/anti-patterns).
   - A skill's `SKILL.md` (procedure, examples, common pitfalls).
   - `CLAUDE.md` / `AGENTS.md` (dispatcher behaviour, project conventions).
   - A playbook (when the lesson is about workflow, not role substance).
   - `~/.claude/projects/<this-project>/memory/` (when the lesson is project-specific, not Hornero-wide).

4. **Ask before writing.** Show the proposed deltas; let the user accept/edit/reject each. Only then write.

5. **If nothing was surprising**, say so in one line and stop. Forced lessons rot the harness.
