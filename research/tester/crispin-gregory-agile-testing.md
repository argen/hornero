# Lisa Crispin & Janet Gregory — distilled

> *Agile Testing* (2009), *More Agile Testing* (2014), and *Agile Testing Condensed* (2019). The defining practitioner texts on what testing looks like inside agile teams; the source of the Agile Testing Quadrants model.

## Why it matters for AI-coding

AI-generated test suites collapse an important distinction: tests can support development (guide the code being built) or critique the product (find things the customer would hate). An AI left to its own defaults generates the former almost exclusively — unit tests that follow the implementation, assertion-level checks that confirm code ran. The Agile Testing Quadrants force the explicit question "what is this test *for* and who is its audience?" before a single test is written.

Without this framing, AI-assisted teams end up with a suite that is technically broad but strategically lopsided: high confidence in the code's internal consistency, low confidence in whether the product does what the customer needs. Crispin & Gregory's quadrant model is the corrective lens.

## Key concepts the role pulls from

- **The Agile Testing Quadrants.** A 2x2 grid organising tests by two axes: Q1/Q2 support the team; Q3/Q4 critique the product. Q1/Q3 are technology-facing; Q2/Q4 are business-facing. Most AI-generated suites live entirely in Q1 (unit/component, technology-facing, support-development); Q2 (acceptance tests, functional, business-facing) and Q3 (exploratory, usability, user-acceptance, business-facing) require deliberate human investment. Powers `test-plan`'s test-distribution and audience sections.
- **Whole-team quality.** Testing is not a QA-department function; it's a shared responsibility that includes developers, testers, PMs, and customers. The tester's role is to embed quality thinking in the whole team, not to be the last gatekeeper. Powers the `pre-release-test-pass` workflow's multi-stakeholder framing.
- **Test automation pyramid by quadrant.** Q1 should be almost entirely automated; Q2 should be mostly automated with human review; Q3 and Q4 are primarily human-driven. Misassigning a Q3 activity (exploratory testing) to Q1 automation is a category error that explains why automated suites miss UX and integration bugs.
- **"Test early, test often, test in context."** Crispin & Gregory's integration of agile release rhythms with testing rhythms: tests are written in the same sprint as the feature they address, not after the feature is "done." This disciplines AI-assisted teams to treat test generation as a part of each development task, not a cleanup pass.
- **Release readiness as an ongoing property.** Rather than a pre-release scramble, Crispin & Gregory model release readiness as a continuously-maintained state. The `pre-release-test-pass` skill's framing — "the pass should produce no surprises for a team running well" — comes from this.

## What to actually read (1-hour budget)

- *Agile Testing* — chapters 5-7 (the Quadrants in detail, with examples by quadrant; this is the conceptual core). ~40 pages.
- *Agile Testing Condensed* — if you have 30 minutes instead of an hour; the 2019 condensation is deliberately brief and updates the original for CI/CD contexts.
- *More Agile Testing* — Part III ("What Does Agile Testing Look Like?") adds the CI/CD integration chapter that the 2009 original predates.

## What to skip

- The detailed project-management and team-structure chapters in *Agile Testing* (Chapters 2-4) — historically important for making the case that testers belong in agile teams; operationally thin today.
- *More Agile Testing*'s sections on test tools and tooling surveys — dated; tools have moved substantially since 2014.

## How this anchors role skills

- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — the Quadrants structure the test-distribution section; the "audience" field in the plan template reflects Q2/Q4's business-facing orientation; the reasoning for choosing a test level maps to quadrant placement.
- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — whole-team quality framing appears in the workflow's multi-stakeholder framing; release-readiness-as-ongoing-property motivates the pass's follow-up tracking across releases.

## Cross-role connection

The Quadrants' business-facing axis (Q2/Q4) aligns directly with the product-manager role's success-criteria discipline: the PM's "desired outcome" column in a PRD seeds the business-facing acceptance criteria that live in Q2. A PM who asks "how will we know this feature works?" and a tester who asks "which quadrant does that test live in?" are asking the same question from different seats. The methodology makes this connection explicit: the `test-plan` skill's risk section and the `prd` skill's success-criteria section share vocabulary so that quadrant-placement decisions can be traced directly back to product outcomes.

