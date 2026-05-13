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

> v0 status: `software-engineer`, `tester`, `designer`, `security-expert`, `marketing-expert` (4 skills each), and `product-manager` (6 skills, including the `cross-functional-orchestration` workflow that lets PM act as the PM-framed orchestrator on cross-functional work) have full content (ROLE + sources + skills). `data-scientist` has ROLE.md + sources.md scaffolded; its skills land in a later phase.

## How to invoke a role

In a Hornero-equipped session (one where `CLAUDE.md` is loaded and `CATALOG.md` is up to date), you usually don't name the role at all — the **dispatcher** in [`../CLAUDE.md`](../CLAUDE.md) matches your prompt against role triggers and announces the role it's adopting in one line before doing the work. See the dispatcher section of the root README for the protocol.

### Single role (dispatcher)

When work would benefit from one specific lens, describe the task; let the dispatcher pick:

> "Review this PRD draft — focus on problem fit and success criteria. ≤200 lines."

The agent should announce e.g. `Adopting `product-manager` — the artifact is a PRD draft` before starting. Override with one word ("designer instead") if it picks wrong.

### Forcing a specific role

If you want to bypass dispatch and name the role yourself:

> "Use the `product-manager` role to review this PRD draft."

### Multiple roles

When a decision is cross-functional, the dispatcher should auto-escalate to `multi-role-review`. To force it:

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
