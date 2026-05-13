# Role cheatsheet

One-page quick reference for invoking Hornero roles. For depth, read the specific `roles/<role>/ROLE.md`.

## The seven roles at a glance

| Role | Watches for | Anchor experts |
|---|---|---|
| **software-engineer** | Correctness, idioms, dead code, tests, security basics | Beck, Fowler, Ousterhout, SRE Book |
| **product-manager** | Problem fit, scope, success criteria, evidence | Cagan, Torres, Eriksson, Perri, Doshi |
| **designer** | UX flow, states, accessibility, hierarchy | Norman, Nielsen, Cooper, Hall, Holmes |
| **tester** | Coverage, edge cases, risk, flakiness | Bach/Bolton, Hendrickson, Beck, Cohn |
| **security-expert** | Threats, controls, auth, dependencies, AI risk | OWASP, NIST, Shostack, Schneier, MITRE |
| **data-scientist** | Validity, causality, bias, model risk | Pearl, Kohavi, Wickham, Kahneman, Sculley |
| **marketing-expert** | Positioning, narrative, channel, copy | Dunford, Sharp, Raskin, Wiebe, Ritson |

## What each role does *not* review

| Role | Stays out of |
|---|---|
| software-engineer | Strategy (PM), UX nuance (designer), threat modeling (security) |
| product-manager | Implementation choices, UI fidelity, test plans, threat surface |
| designer | Code, architecture, business strategy, copy/positioning |
| tester | Architecture decisions, product strategy, visual design |
| security-expert | Code style, UX of security flows, A/B test design |
| data-scientist | Pipeline code quality, security boundaries, viz aesthetics |
| marketing-expert | Roadmap, feasibility, A/B design, code |

## Quick-pick by work type

| You're reviewing... | Invoke |
|---|---|
| A typo fix | None |
| A small bug fix | software-engineer (or skip) |
| A feature PR | software-engineer + tester |
| A user-facing feature PR | + designer + product-manager |
| An auth/data-flow PR | + security-expert |
| A measurement-affecting PR | + data-scientist |
| A launch artifact | product-manager + designer + marketing-expert |
| An RFC / design doc | product-manager + software-engineer + security-expert (often) |
| A pricing change | product-manager + marketing-expert + data-scientist |
| An incident post-mortem | security-expert + software-engineer + tester |

## Invocation patterns

In a Hornero-equipped session the **dispatcher** (see [`../CLAUDE.md`](../CLAUDE.md)) usually picks the role from `CATALOG.md` based on your prompt. You only force a choice when you want to override the dispatcher.

### Single role (dispatcher picks)
> "Review this [artifact] — focus on [specific concern]. ≤200 lines."

The agent declares which role it's adopting in one line before starting. Redirect with one word ("designer instead").

### Single role (force the choice)
> "Use the [role] role to review this [artifact]. Focus on [specific concern]. ≤200 lines."

### Multiple roles via skill
> "Run multi-role-review on [artifact]. Use [role1], [role2], [role3]."

(The dispatcher should auto-escalate to multi-role-review when two or more roles' triggers fire strongly on the same prompt.)

### With context (better)
> "Run multi-role-review on [artifact]. Use [role1] (focus: X), [role2] (focus: Y), [role3] (focus: Z). Context: [why this matters]."

## Reviewer mode vs producer mode

Each role works in two modes:

- **Reviewer** — critiques an existing artifact. Default for `multi-role-review`.
- **Producer** — creates an artifact (PRD, threat model, test plan, etc.) from a problem statement.

Reviewer mode: "Review this RFC from the security lens."
Producer mode: "Produce a threat model for this feature." (Dispatcher picks `security-expert` / `threat-model`.)

## Cost-vs-value calibration

A multi-role review costs ~5-15 min and 4-7x the tokens of a single-role review.

Invoke when:
- Cost of getting it wrong is high (production breakage, public launch, security incident)
- Work crosses multiple concerns
- Team is debating something cross-functional

Don't invoke when:
- The work is bounded to one concern
- A single expert can adjudicate
- You're prototyping / exploring

## When in doubt

- One role: software-engineer (most generally applicable)
- Two roles: software-engineer + tester
- Three roles: + the one most-affected by the change (PM/designer/security/data/marketing)
- More than three: pause and re-justify

## Where the depth lives

| Need | Read |
|---|---|
| What this role thinks | `roles/<role>/ROLE.md` |
| Who this role learns from | `roles/<role>/sources.md` |
| How to orchestrate roles | `playbooks/orchestration-heuristics.md` |
| How multi-role-review works | `skills/multi-role-review/SKILL.md` |
| Day-1 setup | `playbooks/onboarding.md` |
| Weekly maintenance | `playbooks/feedback-ritual.md` |
