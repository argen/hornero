# Marty Cagan — distilled

> *Inspired: How to Create Tech Products Customers Love* (2008, rev. 2017), *Empowered: Ordinary People, Extraordinary Products* (2020, with Chris Jones), *Transformed: Moving to the Product Operating Model* (2024). The Silicon Valley Product Group canon.

## Why it matters for AI-coding

Cagan's framing is *more*, not less, important when an AI agent collapses the implementation cost of a feature toward zero. If the engineering side is cheap and fast, the bottleneck moves entirely to "are we building the right thing" — which is exactly the territory Cagan polices. The four big risks (**value, usability, feasibility, business viability**) become the PM's checklist whenever an AI proposes to build something, because the AI can answer feasibility but consistently bluffs the other three.

Cagan's strongest anti-pattern — the *feature factory*, where output volume substitutes for outcome — is the AI-era's most likely failure mode. AI tools generate output unusually fast; without a Cagan-shaped PM in the loop, what you ship is *more*, not necessarily *better*. The PM-orchestrator skill (`cross-functional-orchestration`) inherits Cagan's "frame as customer job, name the outcome, name the alternative considered" discipline directly.

## Key concepts the role pulls from

- **The four big risks.** Value (will customers buy/use?), Usability (can they figure it out?), Feasibility (can we build it?), Business viability (does it work for our business?). Every PRD critique passes through this checklist. Powers the `prd` skill's success-criteria + counter-metric structure.
- **Product discovery vs. delivery.** Discovery is "are we building the right thing"; delivery is "are we building the thing right." Most AI tools collapse these — Cagan's separation forces explicit decisioning at each phase. Powers `discovery-interview-prep` and the discovery-leg of `cross-functional-orchestration`.
- **Empowered product teams.** Teams given problems to solve, not features to build. The opposite of the feature-factory anti-pattern. Underwrites the methodology's preference for *outcome-shaped* PRDs over *output-shaped* spec docs.
- **The product manager's job.** Not project management, not feature prioritisation in a vacuum, not stakeholder relay. The PM owns understanding the four risks and resolving them. Cagan is brutal about PMs who confuse roadmap maintenance with product management.
- **Strong opinions, loosely held.** Cagan's stance on PM decisiveness — make the call with the evidence available, change it cheaply when better evidence arrives. The `cross-functional-orchestration` "revisit condition" output borrows this directly.

## What to actually read (1-hour budget)

- *Inspired* (2017 edition) — **chapters 1-4** (the product role, the product team, product principles) and **chapters 7-9** (discovery techniques). ~80 pages. The most-replicable PM-foundations in book form.
- If you have a second hour: *Empowered* **chapters 1-3** (vision, strategy, principles) for the leadership context that makes Cagan's PM stance operationally possible.

## What to skip

- *Inspired*'s appendices on PM hiring — aged into HR-process territory; not load-bearing for the methodology.
- Most of *Transformed* unless you're an executive deciding to adopt the product operating model org-wide. The PM-operator chapters from *Inspired* + *Empowered* cover the day-to-day frame.

## How this anchors role skills

- [`prd`](../../roles/product-manager/skills/prd/SKILL.md) — the four-big-risks checklist is the load-bearing critique structure; the "outcome over output" stance shapes the success-metric + counter-metric requirement.
- [`cross-functional-orchestration`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — the customer-job framing, the outcome-shaped synthesis, and the "alternative considered + revisit condition" output structure all inherit from Cagan's decision-quality stance.
- [`discovery-interview-prep`](../../roles/product-manager/skills/discovery-interview-prep/SKILL.md) — the discovery-vs-delivery distinction underpins why this skill exists as a separate artifact from the PRD.
- General review heuristic: when the PM role flags a PRD as "feature-shaped" or "missing the customer-job frame," the citation is Cagan.

## Cross-role connection

Cagan's four risks split cleanly across the methodology's reviewer roles: **feasibility** → engineer, **usability** → designer, **value** + **business viability** → PM and marketing. This is not coincidental — the multi-role-review skill is, in one reading, Cagan's four risks operationalised as parallel role-shaped critiques. When the PM-orchestrator picks the role mix for `/orchestrate`, the four risks are the implicit triage frame.
