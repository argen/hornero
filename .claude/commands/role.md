---
description: Invoke a single Hornero role for a focused critique or artifact. Usage:- /role <role-name> <task>. Roles- software-engineer, product-manager, designer, tester, security-expert, marketing-expert, data-scientist.
argument-hint: <role-name> <task>
---

# /role

The user wants a single named role to do the work. **Do not improvise the role.** Use the matching reviewer subagent or the role's `ROLE.md` directly.

## What to do

1. **Parse the role name** from the start of `$ARGUMENTS`. Valid roles:
   - `software-engineer` / `engineer`
   - `product-manager` / `pm`
   - `designer`
   - `tester`
   - `security-expert` / `security`
   - `marketing-expert` / `marketing`
   - `data-scientist`

   If the name doesn't match, list the valid roles in one line and ask which.

2. **For a reviewer task** (the default — "review X", "audit X", "critique X"): spawn the matching reviewer subagent via the Agent tool, e.g. `subagent_type: "tester-reviewer"`. The subagent definitions are in [`agents/`](../../agents/) and are self-contained — they don't need ROLE.md at runtime.

3. **For a producer task** ("draft an ADR", "write a test plan", "produce a threat model"): adopt the role yourself rather than spawning a reviewer. Load:
   - `roles/<role>/ROLE.md` — mindset and heuristics.
   - The matching component or workflow skill in `roles/<role>/skills/<skill>/SKILL.md` (the one whose `description` matches the artifact). Scan [`CATALOG.md`](../../CATALOG.md) if uncertain.

4. **Declare your choice in one line** before starting:
   ```
   /role <name> — adopting <reviewer subagent | role + skill>; <one-sentence plan>.
   ```

5. **Stay inside the role's mandate.** If the task drifts (security work in an engineer brief, marketing work in a PM brief), say so and ask if the user wants to add another role via `/review` or `/orchestrate`.

## Task

$ARGUMENTS
