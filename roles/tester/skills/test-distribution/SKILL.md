---
name: test-distribution
description: Use when a team needs to audit the current distribution of their test suite across the pyramid (unit / integration / E2E) and receive a reasoned rebalance recommendation.
intent: |
  Audits the current test-suite shape, identifies problem signals (slow CI,
  flaky E2Es, gaps in fast feedback), and recommends a rebalance with
  explicit reasoning. The recommendation cites the pyramid as default but
  names the Honeycomb and Testing Trophy alternatives when they fit the
  context better.
type: component
theme: test-strategy
best_for:
  - A CI pipeline that takes more than 15 minutes to give feedback
  - A suite where most tests are E2E and the team has lost trust in them
  - A new service where no test strategy has been set yet
  - A post-incident review that surfaces a coverage gap
  - A team that suspects their test investment is in the wrong layer
scenarios:
  - "Auditing a React app where 80% of tests are Cypress E2E and CI takes 40 minutes"
  - "Setting a distribution target for a new backend microservice"
  - "Post-incident: 'we had tests, why didn't they catch it?' — answer: wrong layer"
  - "Rebalancing a legacy monolith whose only tests are integration tests against the DB"
estimated_time: 30-60 minutes (first audit); 15 minutes (lightweight check)
---

# Test distribution

> v0 draft. Grounded in Mike Cohn's test pyramid (*Succeeding with Agile*, 2009), Jez Humble & David Farley's continuous-delivery discipline (*Continuous Delivery*, 2010), Kent Beck's unit-test-first principle, James Bach & Michael Bolton's HTSM as a check on pyramid dogma, and the Honeycomb and Testing Trophy as named counter-shapes.

## Purpose

The test pyramid is the most-cited and most-misapplied model in software testing. Cohn named it as a rule of thumb: write many fast unit tests, fewer integration tests, fewest (and slowest) end-to-end tests. The model is sound in most contexts; it is routinely violated in two directions:

1. **Ice-cream cone** — E2E-heavy, unit-light. The shape most AI-generated suites default to and most teams drift toward under deadline pressure. CI is slow, flakiness is high, and fast feedback disappears.
2. **Unit-only** — fast, but never validates that the units compose correctly. Integration bugs surface in production.

This skill audits the current shape, names the signals that show it is causing problems, and produces a concrete rebalance recommendation — with the pyramid as the default but the Honeycomb and Trophy as named alternatives when they fit better.

Humble & Farley: the pipeline is the test. A suite whose distribution prevents fast feedback is a broken pipeline.

## Key Concepts

### The pyramid (Cohn)

Three layers, named by volume and speed:

- **Unit** — tests a single function or class in isolation. No I/O, no network, no database. Milliseconds per test. Volume: hundreds to thousands.
- **Integration** — tests that two or more components work together. May touch a real database, a message queue, or an HTTP endpoint. Seconds per test. Volume: tens to hundreds.
- **E2E / UI** — tests the full stack through the UI or public API. Real browser, real services, real network. Tens of seconds per test. Volume: tens at most.

The pyramid's core claim: unit tests are cheap and fast enough to have many; E2E tests are expensive and slow enough to have few. Most value per CI-minute comes from unit tests.

### The common counter-shapes

**Ice-cream cone (inverted pyramid).** Unit tests at the tip, E2E at the base. Signs: CI > 20 minutes; Flake rate > 5%; teams habitually add Playwright/Cypress tests for new features; engineers don't run the full suite locally. Root cause: E2E tests are visible and satisfying to write; unit tests require seams and design work the team hasn't done.

**Honeycomb (Google / service architectures).** Unit testing is de-emphasised relative to integration testing. Services are thin wrappers over infrastructure; testing the unit in isolation tests almost nothing real. Google's engineering blog describes this as appropriate for service-mesh architectures where the interesting behaviour is in the service-to-service contract, not the individual function. Counter to the pyramid — but not wrong, in context.

**Testing Trophy (Kent C. Dodds).** Unit tests at the base, a large middle layer of integration tests, a small top of E2E. Static analysis (types, lint) is treated as a first layer below unit. Dodds' framing: the integration layer gives the highest confidence-per-dollar because it exercises components as users would, without the fragility of full E2E. Popular in React/Node ecosystems.

**Integration-heavy (some service architectures).** A service that mostly coordinates between other services has little interesting unit-testable logic; its integration tests against a test double of downstream services are the load-bearing layer. Not an anti-pattern if the distribution is intentional.

### Fast feedback as the constraint (Humble & Farley)

The goal of any distribution is *fast, reliable feedback*. A suite that takes 45 minutes to run gives feedback too late to be useful in a short-cycle delivery team. The target: a full suite run (unit + integration + a smoke slice of E2E) in under 10 minutes on CI. If that target can't be met, the distribution is wrong.

### HTSM as a check on pyramid dogma (Bach & Bolton)

The pyramid is a speed heuristic, not a coverage framework. A suite that satisfies the pyramid but covers only Function and ignores Data, Time, and Operations has an acceptable shape but inadequate coverage. The distribution audit checks shape; the test plan checks coverage across HTSM dimensions. They are separate concerns.

### Problem signals

These signal the wrong distribution before you count tests:

| Signal | Likely cause |
|---|---|
| CI > 20 minutes | E2E-heavy or integration tests doing too much setup |
| Flake rate > 3% per week | E2E tests depending on timing, network, or external state |
| "The suite passed but prod is broken" | Unit-only; integration layer missing |
| Engineers skip running the suite locally | Suite is too slow for local feedback |
| New features default to Cypress/Playwright tests | No established unit/integration pattern |
| Test suite time grew 2× in the last 6 months | Tests are being added at the wrong layer |

## Application

### Step 1 — Count and classify

Enumerate all test files and classify each as unit, integration, or E2E. Most test runners make this straightforward:

```bash
# pytest: count by directory convention
find tests/ -name "*.py" | xargs grep -l "@pytest.mark.unit" | wc -l
find tests/ -name "*.py" | xargs grep -l "@pytest.mark.integration" | wc -l
find tests/e2e/ -name "*.py" | wc -l

# Jest / Vitest: count by file path pattern
find src/ -name "*.test.ts" | wc -l          # unit (co-located)
find tests/integration/ -name "*.test.ts" | wc -l
find tests/e2e/ -name "*.spec.ts" | wc -l

# Timing by layer (pytest)
pytest --co -q tests/unit/ | tail -1         # count
pytest tests/unit/ --tb=no -q 2>&1 | tail -2  # duration
```

If tests are not classified by convention, classify a sample of 20 at random — enough to estimate the shape.

### Step 2 — Measure CI time per layer

In the CI config (`.github/workflows/`, `Jenkinsfile`, `.circleci/config.yml`), identify how long each layer takes. If layers run together, add timing markers or split them.

Target values (as defaults; context adjusts):

| Layer | Target duration (CI) | Acceptable upper bound |
|---|---|---|
| Unit | < 3 min | 5 min |
| Integration | < 5 min | 10 min |
| E2E (smoke slice) | < 5 min | 10 min |
| Full suite | < 10 min | 15 min |

### Step 3 — Fill in the audit template

```markdown
# Test-distribution audit — <project / service>

- **Author:** <name>
- **Date:** <YYYY-MM-DD>
- **Baseline branch:** <main / SHA>

## Current shape

| Layer | Count | % of suite | CI time | Flake rate (4 weeks) |
|---|---|---|---|---|
| Unit | <N> | <x>% | <t> min | <f>% |
| Integration | <N> | <x>% | <t> min | <f>% |
| E2E | <N> | <x>% | <t> min | <f>% |
| Property-based | <N> | <x>% | <t> min | — |
| **Total** | | **100%** | **<t> min** | |

**Shape name:** Pyramid / Ice-cream cone / Honeycomb / Trophy / Other: <describe>

## Problem signals present

- [ ] CI > 15 minutes
- [ ] Flake rate > 3%/week
- [ ] No unit tests for core domain logic
- [ ] E2E tests for every new feature
- [ ] Engineers avoid running suite locally
- [ ] Recent incident not caught by any layer
- [ ] Other: <describe>

## Root cause (3-5 sentences)

<Why the current shape exists: historical decisions, team norms, missing
infrastructure, AI-generated test defaults, etc.>

## Recommended shape

| Layer | Current % | Target % | Rationale |
|---|---|---|---|
| Unit | <x>% | <y>% | <why> |
| Integration | <x>% | <y>% | <why> |
| E2E | <x>% | <y>% | <why> |
| Property-based | <x>% | <y>% | <why> |

**Model:** Pyramid / Honeycomb / Trophy / custom — and why this model fits
this context.

## Rebalance actions

<Ordered list. For each action: what to add, what to move, what to delete,
estimated effort, expected signal improvement.>

## Pipeline changes

<What CI changes enable the new distribution: parallel layers, separate
fast-feedback job, flaky-test quarantine policy.>

## Counter-model considered and rejected

<Name any alternative model considered and explain why it was not chosen
for this context. This makes the recommendation defensible.>
```

### Step 4 — Recommend using a named model, with reasoning

Do not just state "add more unit tests." Name the target model and defend it:

- **Pyramid** — appropriate when the team has significant domain logic that can be tested in isolation, low infrastructure coupling, and a fast feedback mandate. The default.
- **Honeycomb** — appropriate when the codebase is a thin service layer over infrastructure (DB, queue, third-party API); unit tests test almost nothing real; the interesting behaviour is in service contracts.
- **Trophy** — appropriate when the primary value is confidence that components work together as users experience them; the unit layer is thin; integration tests are well-factored and fast.

State one model explicitly. Hybrid or "it depends" recommendations without a named anchor are not actionable.

### Step 5 — Define the fast-feedback job

Regardless of the full-suite shape, define a fast-feedback job in CI that runs within 5 minutes and gates PRs:

- All unit tests.
- Smoke integration tests (a subset that exercises the critical path; skips slow setup).
- No E2E in the fast-feedback job.

The full suite (including E2E and property tests with high `max_examples`) runs on merge-to-main or on a nightly cron. The fast-feedback job is what engineers run on every push.

## Examples

### Example 1 — Ice-cream cone audit with rebalance recommendation

**Context:** A React/Node e-commerce app. The team added Cypress tests for every new feature over two years. CI takes 38 minutes. Engineers merge and go home; they don't watch the pipeline.

**Audit output (current shape):**

```markdown
## Current shape

| Layer | Count | % | CI time | Flake rate |
|---|---|---|---|---|
| Unit | 41 | 8% | 1 min | 0.2% |
| Integration | 23 | 4% | 3 min | 1.0% |
| E2E (Cypress) | 487 | 88% | 34 min | 9.1% |
| Total | 551 | 100% | 38 min | — |

Shape: Ice-cream cone. E2E-dominated.

## Problem signals present

- [x] CI > 15 minutes (38 min)
- [x] Flake rate > 3%/week (9.1% on E2E layer)
- [x] E2E tests for every new feature (explicit team norm since 2023)
- [x] Engineers avoid running suite locally ("too slow")

## Root cause

The team adopted Cypress in 2022 for a checkout-flow spike. It gave visible
confidence; the norm generalised. Engineers write Cypress tests because they
already know how; writing a unit test for a React component requires mocking
setup the team hasn't invested in. The 487 Cypress tests test the same paths
at slightly different starting states, producing high volume with low marginal
signal, and the suite compounds flakiness from external dependencies.

## Recommended shape

| Layer | Current % | Target % | Rationale |
|---|---|---|---|
| Unit | 8% | 55% | React Testing Library for component logic; pure-function unit tests for domain logic; fast, zero-flake |
| Integration | 4% | 30% | API integration tests (supertest or similar) replace the E2E layer for backend paths; still exercises real DB |
| E2E | 88% | 15% | Keep E2E for the three critical user journeys: checkout, login, and payment; delete duplicates |

Model: Testing Trophy. The integration layer (API + component interaction) gives
highest confidence/speed ratio for this React+Node stack. Not Pyramid because
the unit layer alone won't validate the API surface.

## Rebalance actions

1. Delete E2E tests that duplicate API-layer integration tests (estimated 200 tests; 2 sprints).
2. Add React Testing Library component tests for 15 high-change components (1 sprint).
3. Add API integration test suite with supertest covering all checkout endpoints (1 sprint).
4. Keep 15 Cypress tests: login flow, checkout, Stripe payment, password reset, account creation.
5. Define fast-feedback CI job: unit + API integration smoke (target < 5 min).

## Counter-model considered and rejected

Honeycomb considered: rejected because the frontend layer has substantial
component logic (form validation, cart state) that is testable in isolation and
benefits from unit coverage. The Honeycomb shape would underweight that layer.
```

### Example 2 — Lightweight check (good)

When a full audit is not warranted (a new microservice, a team discussion), a five-minute check:

```
Unit: 0 tests.
Integration: 12 tests (DB + HTTP client).
E2E: 0 tests.
CI: 8 seconds.

Shape: Integration-only. Appropriate for a thin service that wraps a DB.
Signal: acceptable — no problem signals. Recommend adding property tests
for the data-transformation functions (3 pure functions with non-trivial logic).
No rebalance needed at this time.
```

Not every audit produces a major rebalancing recommendation. The lightweight check can confirm the current shape is correct.

## Common Pitfalls

### Pitfall 1 — Pyramid as universal law

**Symptom:** The audit recommends "more unit tests" regardless of the architecture. Service mesh? Thin API wrapper? Doesn't matter — more unit tests.

**Consequence:** Unit tests are written for trivial pass-through functions; integration bugs accumulate; the team's confidence doesn't improve.

**Fix:** Name the model that fits the context. Honeycomb is the right default for service architectures. Trophy is the right default for React/Node full-stack apps. Pyramid is the right default for domain-rich applications with isolated business logic.

### Pitfall 2 — Counting tests instead of measuring CI time

**Symptom:** The audit counts tests and reports percentages but ignores duration per layer.

**Consequence:** A team adds 50 unit tests (fast) and 2 E2E tests (slow); the count looks like "pyramid" but CI time is unchanged because the 2 E2E tests take 10 minutes.

**Fix:** Measure CI time per layer, not just count. The goal is fast feedback, not a specific ratio.

### Pitfall 3 — Treating flakiness as a distribution problem

**Symptom:** Audit recommends "move to unit tests" as the fix for a 12% flake rate.

**Consequence:** If the flake is caused by a poorly-written test (timing-dependent, shared state), moving the layer doesn't fix the flake — the flake moves with the test.

**Fix:** Investigate flaky tests before rebalancing. A flaky integration test may need a better fixture; a flaky E2E test may need an explicit wait; neither requires moving to a different layer.

### Pitfall 4 — Rebalance without pipeline changes

**Symptom:** The audit recommends a new distribution; the CI pipeline is not updated; the E2E tests still run on every PR.

**Consequence:** The new unit tests run alongside the old E2E tests; CI is now slower than before; the team regrets the rebalance.

**Fix:** Define the fast-feedback CI job first. The rebalance is only visible as an improvement if the pipeline reflects the new distribution.

### Pitfall 5 — Deleting E2E tests without replacement coverage

**Symptom:** Audit recommends reducing E2E from 80% to 15%; team deletes 65% of tests; no integration tests are added.

**Consequence:** Coverage drops; the next production incident isn't caught.

**Fix:** Rebalance is two-phase: add the lower-layer tests first; delete the upper-layer tests second, after the new tests are confirmed green.

### Pitfall 6 — Audit as one-time exercise

**Symptom:** The distribution is audited once; a target is set; nobody checks it again. Six months later, E2E dominates again.

**Consequence:** The audit produced a snapshot, not a discipline.

**Fix:** Add the distribution audit to the quarterly test-plan review. Three minutes to re-run the count; compare against the target. Signal early.

## References

- **Mike Cohn** — *Succeeding with Agile* (2009); the test pyramid. The canonical reference. See `roles/tester/sources.md`.
- **Jez Humble & David Farley** — *Continuous Delivery* (2010); the pipeline as the test; slow E2E tests break delivery cadence. See `roles/tester/sources.md`.
- **Kent Beck** — *Test-Driven Development by Example* (2002); unit-test-first discipline; the foundation of the pyramid's bottom layer. See `roles/tester/sources.md`.
- **James Bach & Michael Bolton** — Heuristic Test Strategy Model; the pyramid is a speed heuristic, not a coverage framework; HTSM covers what the pyramid ignores. See `roles/tester/sources.md`.
- **Kent C. Dodds** — "Write tests. Not too many. Mostly integration." (blog, 2018); Testing Trophy model; high-value integration layer for React/Node stacks.
- **Google Testing Blog** — Honeycomb model for service architectures; integration-heavy shape appropriate for thin service layers. [testing.googleblog.com](https://testing.googleblog.com/).
- **Related Hornero skills:**
  - [`test-plan`](../test-plan/SKILL.md) — the plan states the target distribution and the reasoning; this skill audits whether the suite matches the plan.
  - [`pre-release-test-pass`](../pre-release-test-pass/SKILL.md) — the release workflow asks "is the suite in good shape?" — this audit answers that question.
  - [`property-spec`](../property-spec/SKILL.md) — property tests occupy the unit/integration boundary and should be tracked in the distribution audit.
  - [`exploratory-charter`](../exploratory-charter/SKILL.md) — exploratory sessions are off-pyramid; they complement the suite, not substitute for it.
