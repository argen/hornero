# Roles

Each role is a persona an agent (or subagent) can adopt to critique work, produce role-specific artifacts, or contribute to a multi-role review.

## The role

| Role | Reviewer focus | Producer artifacts |
|---|---|---|
| [`product-manager`](product-manager/ROLE.md) | Problem fit, scope, user value, success criteria, strategic posture | PRDs, JTBD, positioning, OKRs, strategy kernel, bet portfolio, success metrics, prioritization, problem framing, interview synthesis, competitive teardown, revenue architecture, journey maps, story maps, opportunity-solution trees, finance reads, market sizing, acquisition-channel calls, press releases, workshop plans, linear triage, cross-functional orchestration |

## How to invoke a role

In a Hornero-equipped session (one where `CLAUDE.md` is loaded and `CATALOG.md` is up to date), you usually don't name the role at all — the **dispatcher** in [`../CLAUDE.md`](../CLAUDE.md) matches your prompt against role triggers and announces the role it's adopting in one line before doing the work. See the dispatcher section of the root README for the protocol.

### Single role (dispatcher)

When work would benefit from one specific lens, describe the task; let the dispatcher pick:

> "Review this PRD draft — focus on problem fit and success criteria. ≤200 lines."

The agent should announce e.g. `Adopting `product-manager` — the artifact is a PRD draft` before starting. Override with one word ("designer instead") if it picks wrong.

### Forcing a specific role

If you want to bypass dispatch and name the role yourself:

> "Use the `product-manager` role to review this PRD draft."

### Cross-functional decisions

When a decision crosses concerns (launch readiness, contested calls), use `/orchestrate` — the PM frames the work as a customer job and synthesises into a product decision (outcomes, success criteria, alternative considered, revisit condition) via the `cross-functional-orchestration` skill.

### Producer vs reviewer mode

Each role works in two modes, controlled by the `mode:` frontmatter in `ROLE.md`:

- **Reviewer** — critique an artifact from that role's lens (spawned by name via `product-manager-reviewer` in Claude Code, or the equivalent native path in Codex).
- **Producer** — generate that role's artifact (PRD, OKRs, strategy kernel, etc.). Invoke via the role's component or workflow skills (`skills/<name>/SKILL.md` with `role: <role>`).

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
