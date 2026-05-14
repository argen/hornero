---
description: Run multi-role-review directly — parallel critique by 2-7 named role personas, then synthesised. Use when you already know the role mix or when no single role is integrating.
argument-hint: <target> [— roles: role1, role2, ...]
---

# /review

The user wants a multi-role review. This is the generic orchestrator-worker mechanism — any role mix, no PM framing assumed. (If the integrating thread is the customer job, use `/orchestrate` instead.)

## What to do

1. **Load the skill**: read [`skills/multi-role-review/SKILL.md`](../../skills/multi-role-review/SKILL.md) end to end. It is the canonical procedure — detailed delegation, parallel dispatch, artifact passing, hard caps (max 7 roles, one layer of nesting), end-state evaluation.

2. **Triage the role choice in one line**:
   - If the user named roles, accept them (with one push-back if the mix looks off).
   - If not, infer 2-5 roles from the artifact's surface area (engineer/tester for code; engineer/tester/security for sensitive code; PM/designer/engineer for product features; PM/marketing/tester/security/data-scientist for launches; etc.).
   - Declare the choice in one line before dispatching:
     ```
     /review — dispatching <role1>, <role2>, <role3> in parallel; will synthesise non-overlapping findings + conflicts + ranked recommendations.
     ```

3. **Available reviewer subagents** (one per Hornero role, in [`agents/`](../../agents/), spawn via Agent tool with `subagent_type: "<name>"`):
   - `software-engineer-reviewer`
   - `product-manager-reviewer`
   - `designer-reviewer`
   - `tester-reviewer`
   - `security-expert-reviewer`
   - `marketing-expert-reviewer`
   - `data-scientist-reviewer`

4. **Dispatch in parallel** — single message with multiple Agent tool calls. Each agent gets a detailed brief (scope, output format, success criteria, what's out of scope) and the artifact path/contents.

5. **Synthesise** per the skill: non-overlapping findings, named conflicts, ranked recommendations. Do not relay raw subagent output.

## Task

$ARGUMENTS
