---
description: Invoke a single Hornero role for a focused critique or artifact. Usage:- /role <role-name> <task>. Currently only role- product-manager.
argument-hint: <role-name> <task>
---

# /role

The user wants a single named role to do the work. **Do not improvise the role.** Use the matching reviewer subagent or the role's `ROLE.md` directly.

## What to do

1. **Parse the role name** from the start of `$ARGUMENTS`. Valid role today:
   - `product-manager` / `pm`

   The retired roles (`software-engineer`, `designer`, `tester`, `security-expert`, `marketing-expert`, `data-scientist`) are dormant pending re-expansion — if the user names one, say so and offer to handle the PM-shaped part of the request, or to redirect to `product-manager`.

2. **For a reviewer task** (the default — "review X", "audit X", "critique X"): spawn the matching reviewer subagent via the Agent tool, e.g. `subagent_type: "product-manager-reviewer"`. The subagent definition is in [`agents/`](../../agents/) and is self-contained — it doesn't need ROLE.md at runtime.

3. **For a producer task** ("draft a PRD", "produce a positioning canvas", "frame this as a problem"): adopt the role yourself rather than spawning a reviewer. Load:
   - `roles/<role>/ROLE.md` — mindset and heuristics.
   - The matching component or workflow skill in `roles/<role>/skills/<skill>/SKILL.md` (the one whose `description` matches the artifact). Scan [`CATALOG.md`](../../CATALOG.md) if uncertain.

4. **Declare your choice in one line** before starting:
   ```
   /role <name> — adopting <reviewer subagent | role + skill>; <one-sentence plan>.
   ```

5. **Stay inside the role's mandate.** If the task drifts into a retired role's territory (e.g., a security-shaped question landing on the PM), say so and offer the closest PM-shaped reframing (e.g., a product decision about acceptable risk posture) rather than improvising the missing lens.

## Task

$ARGUMENTS
