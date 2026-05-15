# Role cheatsheet

One-page quick reference for invoking Hornero roles. For depth, read the specific `roles/<role>/ROLE.md`.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role
> (`product-manager`) plus six cross-role process skills. The multi-role
> table this cheatsheet used to be — six other lenses with their anchor
> experts, "what each role does not review" rows, quick-pick combinations —
> is preserved in git history and returns alongside the retired roles. See
> [`../ROADMAP.md`](../ROADMAP.md) for the re-expansion plan.

## The product manager at a glance

| Role | Watches for | Anchor experts |
|---|---|---|
| **product-manager** | Problem fit, scope, success criteria, evidence, strategic posture | Cagan, Torres, Eriksson, Perri, Doshi, Cutler, Patton, Wodtke, Gilad, Christensen, Moore, Rumelt |

## What the PM does *not* review

| Role | Stays out of |
|---|---|
| product-manager | Implementation choices, UI fidelity, test plans, threat surface, measurement validity, GTM copy — those reviewers will return once the corresponding roles are restored |

Until they are, when a prompt asks about implementation, UX, testing, security, data, or marketing specifically, the dispatcher should either reframe the question as a *product decision* (what problem, what outcomes, what evidence, what alternative we considered) or honestly tell the user the relevant lens is not currently shipped.

## Quick-pick by work type

| You're working on... | Invoke |
|---|---|
| A PRD draft | `product-manager` / `prd` |
| A jobs-to-be-done articulation | `product-manager` / `jobs-to-be-done` |
| A positioning statement | `product-manager` / `positioning-statement` |
| A success-metric definition | `product-manager` / `success-metrics` |
| A prioritization decision | `product-manager` / `prioritization-advisor` |
| A strategy kernel (diagnosis + guiding policy + actions) | `product-manager` / `strategy-kernel` |
| A bet portfolio | `product-manager` / `bet-portfolio` |
| Interview prep / synthesis | `product-manager` / `discovery-interview-prep` or `interview-synthesis` |
| Competitive teardown | `product-manager` / `competitive-teardown` |
| Linear triage | `product-manager` / `linear-triage` |
| OKRs | `product-manager` / `okrs` |
| Problem framing | `product-manager` / `problem-framing-canvas` |
| Revenue / funnel architecture | `product-manager` / `revenue-architecture` |
| Cross-functional decision orchestration | `product-manager` / `cross-functional-orchestration` |

## Invocation patterns

The **dispatcher** (see [`../CLAUDE.md`](../CLAUDE.md)) picks the skill from `CATALOG.md` based on your prompt. You only force a choice when you want to override the dispatcher.

### Dispatcher-led
> "Sharpen the positioning for the new tier."

The agent declares which skill it's adopting in one line before starting. Redirect with one word ("use okrs instead").

### Force the choice
> "Use the `prd` skill to draft a PRD for the cohort-duplicate fix."

## Reviewer mode vs producer mode

The role works in two modes:

- **Reviewer** — critiques an existing artifact via the `product-manager-reviewer` subagent.
- **Producer** — creates an artifact (PRD, positioning, OKRs, strategy kernel, …) from a problem statement.

Reviewer mode: "Have product-manager-reviewer pass over this PRD draft."
Producer mode: "Produce a PRD for the cohort-duplicate fix." (Dispatcher picks `product-manager` / `prd`.)

## Where the depth lives

| Need | Read |
|---|---|
| What this role thinks | `roles/product-manager/ROLE.md` |
| Who this role learns from | `roles/product-manager/sources.md` |
| How orchestration *will* work | `playbooks/orchestration-heuristics.md` *(dormant)* |
| Day-1 setup | `playbooks/onboarding.md` |
| Weekly maintenance | `playbooks/feedback-ritual.md` |
| Re-expansion plan | `../ROADMAP.md` |
