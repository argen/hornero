# Roles

Each role is a persona an agent (or subagent) can adopt to critique work, produce role-specific artifacts, or contribute to a multi-role review.

## The seven seed roles

| Role | Reviewer focus | Producer artifacts |
|---|---|---|
| [`software-engineer`](software-engineer/ROLE.md) | Correctness, idioms, dead code, tests, security basics | Implementation plans, code, test cases |
| [`product-manager`](product-manager/ROLE.md) | Problem fit, scope, user value, success criteria | PRDs, prioritization, success metrics |
| [`designer`](designer/ROLE.md) | UX flow, accessibility, platform conventions, missing states | UI specs, interaction patterns, design critiques |
| [`tester`](tester/ROLE.md) | Coverage, edge cases, test pyramid, flakiness risks | Test plans, regression suites, exploratory test charters |
| [`security-expert`](security-expert/ROLE.md) | Threat surface, auth, data handling, dependencies | Threat models, security reviews, hardening checklists |
| [`data-scientist`](data-scientist/ROLE.md) | Measurement validity, statistical soundness, bias | Experiment designs, metric definitions, analysis plans |
| [`marketing-expert`](marketing-expert/ROLE.md) | Positioning, audience clarity, message-market fit | Launch narratives, positioning docs, copy critiques |

> v0 status: `software-engineer` (4 skills), `tester` (4 skills), and `product-manager` (5 skills) have full content (ROLE + sources + skills). `designer`, `security-expert`, `data-scientist`, and `marketing-expert` have ROLE.md + sources.md scaffolded; their skills land in later phases.

## How to invoke a role

### Single role

When work would benefit from one specific lens:

> "Adopt the product-manager role from `roles/product-manager/ROLE.md` and review this PRD draft. Focus on problem fit and success criteria. Report findings in ≤200 lines."

### Multiple roles

When a decision is cross-functional, use the `multi-role-review` skill:

> "Run multi-role-review on this RFC with product-manager, security-expert, and software-engineer roles."

The orchestrator (the lead agent) will:
1. Decompose the task per role
2. Spawn role subagents in parallel
3. Collect their condensed findings
4. Synthesize into a unified report

See [`../skills/multi-role-review/SKILL.md`](../skills/multi-role-review/SKILL.md) (shipping in phase 2) for the full protocol.

### Producer vs reviewer mode

Each role works in two modes, controlled by the `mode:` frontmatter in `ROLE.md`:

- **Reviewer** — critique an artifact from that role's lens. Default for `multi-role-review`.
- **Producer** — generate that role's artifact (PRD, threat model, test plan, etc.). Invoke via the role's component or workflow skills under `<role>/skills/`.

## Anatomy of a role

Every `ROLE.md` follows the same template:

```markdown
---
name: <role-slug>
description: <one-line: what this role does and when to invoke>
mode: [reviewer | producer | both]
---

# <Role>

## Mindset
What this role values. What they assume by default. What they fear most.

## Canonical sources
The anchors. See sources.md for depth.

## What they look for (reviewer mode)
Broad pass first, deep-dive heuristics second.

## What they produce (producer mode)
Concrete artifacts, each linked to a corresponding component skill.

## Triggers — when to invoke this role

## Anti-patterns — failure modes

## Handoffs — which roles feed in / consume from this role

## Skills index — list of skills under skills/, by type
```

Per-role bibliographies live in `<role>/sources.md`, capped at ~10 anchor entries plus a "see also" list.
