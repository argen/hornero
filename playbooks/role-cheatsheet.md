# Role cheatsheet

One-page quick reference for invoking Hornero roles. For depth, read the specific `roles/<role>/ROLE.md`.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role
> (`product-manager`) — now carrying 37 skills across discovery,
> strategy, AI-PM, finance, outside-in, GTM, workshops + delivery, and the
> PM-to-Director career arc — plus eight cross-role process skills. The
> multi-role table this cheatsheet used to be (six other lenses with their
> anchor experts and quick-pick combinations) is preserved in git history
> and returns alongside the retired roles. See
> [`../ROADMAP.md`](../ROADMAP.md) for the re-expansion plan.

## The product manager at a glance

| Role | Watches for | Anchor experts |
|---|---|---|
| **product-manager** | Problem fit, scope, success criteria, evidence, strategic posture, finance literacy, outside-in scanning, the career-altitude arc | Cagan, Torres, Eriksson, Perri, Doshi, Cutler, Patton, Wodtke, Gilad, Christensen, Moore, Rumelt — plus (theme-extended) Skok / OpenView / Tunguz / Sacks / Gurley for finance, Kalbach + Gothelf & Seiden for discovery/experience, Watkins + Zhuo for the career arc, Bryar & Carr for working-backwards, Kaner + Parker + Knapp for facilitation |

## What the PM does *not* review

| Role | Stays out of |
|---|---|
| product-manager | Implementation choices, UI fidelity, test plans, threat surface, measurement validity, GTM copy — those reviewers will return once the corresponding roles are restored |

Until they are, when a prompt asks about implementation, UX, testing, security, data, or marketing specifically, the dispatcher should either reframe the question as a *product decision* (what problem, what outcomes, what evidence, what alternative we considered) or honestly tell the user the relevant lens is not currently shipped.

## Quick-pick by work type

The full one-line index lives in [`../CATALOG.md`](../CATALOG.md). This is the navigational shortcut.

### Discovery
| You're working on... | Invoke |
|---|---|
| Interview prep | `product-manager` / `discovery-interview-prep` |
| Interview synthesis | `product-manager` / `interview-synthesis` |
| Jobs-to-be-done articulation | `product-manager` / `jobs-to-be-done` |
| Problem framing | `product-manager` / `problem-framing-canvas` |
| Opportunity-solution tree | `product-manager` / `opportunity-solution-tree` |
| Lightweight hypothesis persona | `product-manager` / `proto-persona` |
| Customer journey map | `product-manager` / `customer-journey-map` |

### Strategy + planning
| You're working on... | Invoke |
|---|---|
| Strategy kernel (diagnosis + guiding policy + actions) | `product-manager` / `strategy-kernel` |
| Bet portfolio | `product-manager` / `bet-portfolio` |
| PRD draft | `product-manager` / `prd` |
| OKRs | `product-manager` / `okrs` |
| Prioritization decision | `product-manager` / `prioritization-advisor` |
| Success-metric definition | `product-manager` / `success-metrics` |
| Competitive teardown | `product-manager` / `competitive-teardown` |
| Revenue / funnel architecture | `product-manager` / `revenue-architecture` |

### Positioning + GTM
| You're working on... | Invoke |
|---|---|
| Positioning statement | `product-manager` / `positioning-statement` |
| Amazon-style press release | `product-manager` / `press-release` |

### AI-PM
| You're working on... | Invoke |
|---|---|
| Self-diagnose AI-shaped readiness | `product-manager` / `ai-shaped-readiness-advisor` |
| Context engineering for an AI feature | `product-manager` / `context-engineering-advisor` |

### Finance literacy
| You're working on... | Invoke |
|---|---|
| Read revenue/growth metrics (ARR, NRR, CAC payback…) | `product-manager` / `saas-revenue-growth-metrics` |
| Read efficiency metrics (Rule of 40, burn multiple…) | `product-manager` / `saas-economics-efficiency-metrics` |
| Look up a SaaS metric definition | `product-manager` / `finance-metrics-quickref` |
| Size a market | `product-manager` / `tam-sam-som-calculator` |
| Feature-investment decision through a finance lens | `product-manager` / `feature-investment-advisor` |
| Set or change pricing | `product-manager` / `finance-based-pricing-advisor` |
| Full business-health pass | `product-manager` / `business-health-diagnostic` |

### Outside-in
| You're working on... | Invoke |
|---|---|
| Macro environment scan (PESTEL) | `product-manager` / `pestel-analysis` |
| Structured research on a company | `product-manager` / `company-research` |
| Acquisition-channel decision | `product-manager` / `acquisition-channel-advisor` |

### Workshops + delivery
| You're working on... | Invoke |
|---|---|
| Plan or run a product workshop | `product-manager` / `workshop-facilitation` |
| Story map (spine + walking skeleton + slices) | `product-manager` / `user-story-mapping` |

### Career + leadership
| You're working on... | Invoke |
|---|---|
| Diagnose PM-to-Director altitude/horizon gaps | `product-manager` / `altitude-horizon-framework` |
| Coach a Director transition | `product-manager` / `director-readiness-advisor` |
| New VP/CPO 30-60-90 onboarding | `product-manager` / `executive-onboarding-playbook` |
| Prep a product-sense interview answer | `product-manager` / `product-sense-interview-answer` |

### Operations + orchestration
| You're working on... | Invoke |
|---|---|
| Linear triage | `product-manager` / `linear-triage` |
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
