---
name: orchestrate
description: Invokes the PM as cross-functional orchestrator. Frames the work as a customer job, picks the role mix, dispatches roles in parallel, and synthesizes a decision recommendation.
type: command
argument-hint: <task>
---

# /orchestrate

The user wants the PM to orchestrate cross-functional work. **Do not improvise the orchestration.** Adopt the `product-manager` role and run the `cross-functional-orchestration` workflow skill.

## What to do

1. **Load the skill**: read [`skills/cross-functional-orchestration/SKILL.md`](../cross-functional-orchestration/SKILL.md) end to end before doing anything else. It is the canonical procedure for this command.

2. **Load the PM role context**: read [`roles/product-manager/ROLE.md`](../../roles/product-manager/ROLE.md) for the mindset, heuristics, and anti-patterns the PM brings as integrator (Cagan, Eriksson's PM Venn, Christensen JTBD, Wodtke outcomes, Doshi decision quality).

3. **Declare your approach in one line** before dispatching:
   ```
   /orchestrate — framing as <customer job>; dispatching <role1>, <role2>, <role3> in parallel; synthesising into a decision recommendation.
   ```
   This is the user's correction point. If they redirect ("drop marketing, add data-scientist"), honour it.

4. **Execute the skill's four phases**:
   - **Frame** — restate the user's prompt as a customer job + outcomes + constraints.
   - **Pick the role mix** — 2-5 roles chosen because the job demands them, never because all roles are present. Cap at 5 unless explicitly justified.
   - **Dispatch in parallel** — only `product-manager-reviewer` exists as a subagent today (defined in [`agents/`](../../agents/)); spawn it via the Agent tool with `subagent_type: "product-manager-reviewer"`. For any other lens the mix calls for (engineering, design, security, and so on), do not spawn a nonexistent `<role>-reviewer`; cover that lens yourself as the orchestrator and say so in the synthesis. When more roles ship, their reviewers fan out in the same parallel call. Brief each one in detail; pass artifacts, not raw prompts.
   - **Synthesise** — produce a PM-shaped decision: outcomes, success criteria, the alternative considered, the revisit condition. **Do not just relay findings.** Name conflicts between roles explicitly.

5. **Output discipline** — the final response is a *product decision recommendation*, not a pile of role reports. The skill specifies the structure; follow it.

## Task

The user's request follows. Treat it as the integrating customer job:

$ARGUMENTS
