# Jez Humble & David Farley — distilled

> *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation* (2010). With later extension in *Accelerate* (Nicole Forsgren, Jez Humble, Gene Kim, 2018) which grounds CD in the four DORA metrics.

## Why it matters for AI-coding

AI accelerates code generation; the deployment pipeline becomes the bottleneck and the regression surface simultaneously. A team shipping AI-generated changes at 3x their previous velocity has tripled the pressure on their pipeline without necessarily tripling their test coverage, their flake-mitigation discipline, or their deployment-configuration confidence.

Humble & Farley's core claim — the deployment pipeline is a testing artifact, not a delivery mechanism — reframes the problem. Every stage of the pipeline tells you something about the release candidate. If the pipeline is slow, noisy, or narrowly scoped, high-velocity AI generation doesn't accelerate delivery; it accelerates the discovery that the pipeline wasn't fit for purpose.

## Key concepts the role pulls from

- **The deployment pipeline as testing artifact.** Not a conveyor belt that moves code to production, but a structured sequence of quality gates — unit tests, integration tests, acceptance tests, performance checks, deployment-config validation, smoke tests in staging — each of which produces evidence. The tester's job in a CD context is to ensure each stage is producing useful signal, not just passing. Powers `pre-release-test-pass`'s suite-readout step and `test-plan`'s pipeline-expectations section.
- **Fast feedback, staged.** Humble & Farley's pipeline design principle: cheap-and-fast checks run first (unit, lint, static analysis); expensive-and-slow checks run later (integration, E2E, performance). The tester's distribution decisions in `test-plan` are pipeline-architecture decisions — putting slow tests early degrades the feedback loop for everyone.
- **The four DORA metrics.** From *Accelerate*: deployment frequency, lead time for changes, mean time to restore, change failure rate. These are the metrics that correlate with team performance in high-performing organisations. The tester's contribution is directly visible in change-failure rate (bugs that reach production) and mean time to restore (how quickly a failing release is diagnosed). Powers the tester role's vocabulary for reporting test-strategy effectiveness to stakeholders.
- **"Release is a business decision, deploy is a technical one."** Humble & Farley's separation of deployability from release. Decoupling these means the pipeline should always be deployable — the suite should always be green — and the release decision is about readiness, not ability. This is the frame behind `pre-release-test-pass`'s "the pass should produce no surprises for a team running well."
- **Shift-left testing.** The cost of finding a bug rises steeply the later in the pipeline it is found. Humble & Farley's empirical framing: find it in a unit test (seconds), find it in E2E (minutes), find it in production (hours/days + customer impact). Test-plan decisions about which risk to cover at which level are cost-of-detection decisions.

## What to actually read (1-hour budget)

- *Continuous Delivery* — Chapter 4 (Implementing a Testing Strategy) is the most directly useful chapter for this role. 30 pages. Also Chapter 3 (Continuous Integration) for the feedback-loop discipline.
- *Accelerate* — Part I (the research findings) and Chapter 7 (DORA metrics in detail). 60 pages. Read as a companion to understand why these pipeline disciplines are empirically load-bearing.

## What to skip

- *Continuous Delivery* chapters on specific tools (Maven, Ant, NAnt, specific CI servers) — very 2010; the principles are durable but the tooling is a museum.
- *Accelerate*'s appendices on survey methodology — valuable for the researchers; tangential for practitioners.

## How this anchors role skills

- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — the CD frame ("pipeline is necessary, not sufficient") is explicitly stated in the skill's Key Concepts section; the suite-readout step (Step 4) is Humble & Farley's pipeline-as-evidence discipline operationalised; the DORA framing appears when the pass reports against stakeholder metrics.
- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — the pipeline-expectations section of the plan template and the "Pitfall 6 — Pipeline as gate, not feedback" pitfall both cite Humble & Farley directly.

## Cross-role connection

The CD pipeline as safety net is the operationalisation of the software-engineer role's refactoring discipline: "tests stay green throughout" (from `refactor-plan`) presupposes a pipeline that runs reliably and fast enough to provide feedback within the refactor's attention span. If the pipeline takes 40 minutes to run, the engineer can't realistically keep it green throughout a refactor session. Humble & Farley's fast-feedback staging is the infrastructure prerequisite for the engineer-role's refactoring safety guarantees. In cross-role terms: the tester is the maintainer of the pipeline's signal quality; the engineer is the consumer of that signal. When the pipeline is noisy or slow, that is a tester-role concern before it is an engineer-role concern.


