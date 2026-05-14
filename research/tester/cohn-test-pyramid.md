# Mike Cohn — distilled

> *Succeeding with Agile: Software Development Using Scrum* (2009); *Agile Estimating and Planning* (2005). Mountain Goat Software. The test pyramid was introduced in *Succeeding with Agile* and has since become the most-cited and most-misapplied mental model in software testing.

## Why it matters for AI-coding

AI-generated test suites default to end-to-end tests. The reason is structural: the AI sees the user stories, the API contracts, the acceptance criteria — all the artifacts that describe what the system should do from the outside. It writes tests that verify that. The result is a test suite shaped like an inverted pyramid: heavy at the top (E2E), thin in the middle (integration), almost nothing at the base (unit).

This matters because inverted-pyramid suites are slow, flaky, and expensive to maintain. They fail for the wrong reasons (network timeouts, test-environment state, browser rendering) and pass for the wrong reasons (the E2E path happens to avoid the buggy code path). When the inverted-pyramid suite breaks, it breaks loudly and takes a long time to fix. The team learns to distrust it.

Cohn's test pyramid — many unit, fewer integration, fewest E2E — is the corrective frame. It doesn't apply mechanically to every project, and that's the second reason it matters: the methodology teaches when to depart from the pyramid, not just what it says.

## Key concepts the role pulls from

- **The test pyramid.** Three levels: unit tests at the base (fast, cheap, many), service/integration tests in the middle (medium speed/cost, medium quantity), UI/E2E tests at the top (slow, expensive, few). The pyramid's shape encodes two principles: (1) fast feedback should come from the largest fraction of the suite; (2) the cost of test maintenance should be proportional to the value of the coverage. Powers `test-plan`'s "test distribution" section and its insistence on stated reasoning.
- **Unit tests as design pressure.** Cohn's framing (following Beck): unit tests are so cheap to write and run that you should have many of them. High unit-test cost is usually a design smell — the code is hard to test because it is entangled. This is the tester's leverage point on architectural conversations: "this is hard to unit-test" is a design critique.
- **The test pyramid as a thinking tool, not a law.** Cohn introduced the pyramid as a heuristic; it is widely applied as a mandate. Real distributions depend on context: a system with a thin domain layer and complex integration points (e.g., an aggregator) might legitimately have more integration tests than unit tests. The "test trophy" (more integration, fewer unit) and "honeycomb" (many integration, few unit, some E2E) patterns are sometimes correct. The methodology's `test-plan` skill requires the team to state the distribution and justify it — "standard pyramid" is not a justification.
- **The ice-cream cone anti-pattern.** The inverted pyramid (many E2E, few unit) that most teams drift toward under deadline pressure, and that AI-generated suites produce by default. Naming this anti-pattern gives teams vocabulary to critique their own distribution without pointing fingers at individuals.
- **Cost of test levels.** Cohn's supporting economics: a unit test that runs in 10ms, a service test that runs in 1s, an E2E test that runs in 30s — a suite with 10,000 unit, 1,000 integration, and 100 E2E runs in 2 minutes total. Swap those ratios and you get a suite that takes 90 minutes. This is the concrete argument for the pyramid; without the economics, the pyramid is just a shape.

## What to actually read (1-hour budget)

- *Succeeding with Agile* — Chapter 16 (the test pyramid is introduced here, in ~10 pages). Read the chapter, not a summary.
- Martin Fowler's [bliki entry on the test pyramid](https://martinfowler.com/bliki/TestPyramid.html) — a 10-minute read that synthesises Cohn, Kent Beck, and more recent elaborations (ice-cream cone, test trophy). The bliki is more current than the 2009 book for the contemporary state of the debate.
- For the "when to depart" argument: Kent C. Dodds on the "testing trophy" and Spotify's "honeycomb" pattern — short blog posts; both are 15-minute reads.

## What to skip

- The rest of *Succeeding with Agile* outside ch. 16 — it is a Scrum implementation guide; the test pyramid is the load-bearing concept for this role.
- *Agile Estimating and Planning* — not relevant to test distribution; useful for the PM role's planning work instead.

## How this anchors role skills

- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — the "Test distribution" section of the plan template cites Cohn; the "Pyramid-reasoning check" (Step 3, item 3) requires stated reasoning, not just the shape; Pitfall 1 (coverage-percentage as plan) and its fix both reference the pyramid debate.
- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — the suite-readout step (Step 4) includes mapping the suite's tests to HTSM dimensions — which implicitly surfaces whether the distribution is pyramid or ice-cream-cone shaped.

## Cross-role connection

The test pyramid is shared vocabulary between the tester role and the software-engineer role. Both reference it — the engineer from a design-pressure and fast-feedback angle, the tester from a distribution-audit and release-readiness angle. When the two roles collaborate on a test-plan review, the pyramid is the common language for discussing whether the suite's cost/coverage profile is appropriate for the system's risk profile.
