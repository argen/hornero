---
description: Invoke the PM as cross-functional orchestrator. Frames the work as a customer job, picks the role mix, dispatches roles in parallel, synthesizes a decision recommendation.
argument-hint: <task — what to orchestrate>
---

# /orchestrate

The user wants the PM to orchestrate cross-functional work. **Do not improvise the orchestration.** Adopt the `product-manager` role and run the `cross-functional-orchestration` workflow skill.

## What to do

1. **Load the skill**: read [`roles/product-manager/skills/cross-functional-orchestration/SKILL.md`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) end to end before doing anything else. It is the canonical procedure for this command.

2. **Load the PM role context**: read [`roles/product-manager/ROLE.md`](../../roles/product-manager/ROLE.md) for the mindset, heuristics, and anti-patterns the PM brings as integrator (Cagan, Eriksson's PM Venn, Christensen JTBD, Wodtke outcomes, Doshi decision quality).

3. **Declare your approach in one line** before dispatching:
   ```
   /orchestrate — framing as <customer job>; dispatching <role1>, <role2>, <role3> in parallel via multi-role-review; synthesising into a decision recommendation.
   ```
   This is the user's correction point. If they redirect ("drop marketing, add data-scientist"), honour it.

4. **Execute the skill's four phases**:
   - **Frame** — restate the user's prompt as a customer job + outcomes + constraints.
   - **Pick the role mix** — 2-5 roles chosen because the job demands them, never because all roles are present. Cap at 5 unless explicitly justified.
   - **Dispatch via [`skills/multi-role-review`](../../skills/multi-role-review/SKILL.md)** — spawn the chosen reviewer subagents in parallel (use Agent tool with `subagent_type: "<role>-reviewer"` for each — these are defined in [`agents/`](../../agents/)). Brief each one in detail; pass artifacts, not raw prompts.
   - **Synthesise** — produce a PM-shaped decision: outcomes, success criteria, the alternative considered, the revisit condition. **Do not just relay findings.** Name conflicts between roles explicitly.

5. **Output discipline** — the final response is a *product decision recommendation*, not a pile of role reports. The skill specifies the structure; follow it.

## Task

The user's request follows. Treat it as the integrating customer job:

$ARGUMENTS
