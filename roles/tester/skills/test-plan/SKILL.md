---
name: test-plan
description: Use when a tester needs to produce or critique a test plan — a risk-driven document that names what's at stake, how it will be tested, and what coverage is deliberately deferred.
intent: |
  Produces or evaluates a test plan that resists three common failures:
  test theatre (compliance over learning), coverage-by-numbers (lines over
  risk), and happy-path-only thinking. The plan is anchored to Bach &
  Bolton's Heuristic Test Strategy Model so coverage is reasoned about
  across multiple dimensions (Structure, Function, Data, Platform,
  Operations, Time) rather than as a single percentage.
type: component
theme: test-strategy
best_for:
  - A non-trivial feature about to enter implementation or release
  - A regression-prone area where current test coverage is unknown
  - A pre-release readiness review for a critical-path system
  - A re-platforming or major refactor that needs an explicit safety net
scenarios:
  - "Planning tests for a new permissions model that touches 6 services"
  - "Auditing the test plan for a Black Friday checkout-flow change"
  - "Producing a plan for a payment-provider swap"
  - "Building a regression strategy for a system that just had three production incidents"
estimated_time: 45-90 minutes (first draft); 10-20 minutes (critique)
---

# Test plan

> v0 draft. Grounded in James Bach & Michael Bolton's Heuristic Test Strategy Model (RST methodology), Cem Kaner's context-driven principles, Lisa Crispin & Janet Gregory's Agile Testing Quadrants, and Gojko Adzic's Specification by Example.

## Purpose

Produce a test plan that:

1. **Names the risks** — what specifically could go wrong in this area, with what consequence to whom.
2. **Maps tests to risks**, not to lines of code. Each test exists because of a risk it addresses.
3. **Spans HTSM dimensions** — not just function, but data, platform, operations, time.
4. **States what is deliberately not tested**, and why.
5. **Is a working document**, not a compliance artifact — written for the team that will execute it, not for an auditor.

A test plan is not a list of test cases; it is the reasoning that makes a list of test cases coherent. Without the reasoning, the list is unmaintainable: future engineers can't tell which cases are load-bearing, so they keep them all, the suite slows, and the team stops trusting it.

## Key Concepts

### Bach & Bolton's HTSM

The **Heuristic Test Strategy Model** (Rapid Software Testing methodology) frames coverage across multiple dimensions:

- **Structure** — what the product is made of (code, data, interfaces, dependencies).
- **Function** — what the product does (features, capabilities).
- **Data** — what the product processes (inputs, outputs, stores, transforms).
- **Platform** — what the product runs on (OS, browser, network, hardware).
- **Operations** — how the product is used (workflows, user journeys, ops procedures).
- **Time** — how the product behaves over time (concurrency, ordering, age, scheduled jobs, daylight savings, leap years).

A test plan that addresses only Function is the most common failure mode. The Time dimension is the most frequently missing.

### Kaner's context-driven principles

Seven principles, of which the load-bearing ones for test planning are:

1. **The value of any practice depends on its context.** Plans copied across teams without adaptation fail.
2. **There are good practices in context, but no best practices.** The plan says *why* a technique fits this context, not "because the playbook says so."
3. **People, working together, are the most important part of any project's context.** A plan that doesn't account for who will run it is incomplete.

### The pyramid as heuristic, not law

Cohn's test pyramid (many unit, fewer integration, fewest E2E) is a useful default and a frequently-misapplied one. The plan states *its* distribution and the reasoning — including when it deliberately departs from the pyramid (the "test trophy" or "honeycomb" patterns are sometimes correct).

### Specification by Example

Adzic: examples drawn from the problem domain double as tests *and* specifications. A test plan that includes example-driven acceptance tests creates artifacts that survive the code's evolution because they speak the domain's language, not the implementation's.

### Risk first, coverage second

The plan opens with risks, not with techniques. If you can't articulate the worst plausible defect in the area, the plan is premature.

### Negative space

A good plan inventories what the system *refuses* to do: rejected inputs, denied transitions, refused operations. Negative-space tests catch a category of bug example-based positive tests cannot.

### Deliberate non-coverage

Mature plans name what is **not** tested, and why. "We are not testing the export-to-PDF feature in this plan because (a) it has not changed and (b) it has its own regression suite owned by team Y."

## Application

### Step 1 — Frame context and risk

Before drafting the plan, the tester gathers:

- **Change context.** What is being built, fixed, or migrated? Link the PRD, RFC, or ticket.
- **Audience context.** Who runs this plan? A single engineer? A QA team? An exploratory-mob session?
- **Risk inventory.** Three to seven specific risks. For each: what could go wrong, who is harmed, how badly. Avoid "users could have a bad experience" — that's a feeling, not a risk. Aim for "if the rate-limiter releases tokens twice on retry, paid customers could be over-billed by up to 2x their order total."

If you can't articulate at least three risks, stop. The work hasn't been examined seriously yet.

### Step 2 — Draft the plan using the template

```markdown
# Test plan — <feature / area / release>

- **Author:** <tester name>
- **Status:** Draft | In review | Active | Archived
- **Linked work:** <PRD, RFC, ticket links>
- **Audience:** <who runs this>
- **Last updated:** <YYYY-MM-DD>

## Context

<3-6 sentences. What is being built or changed. Why it matters. What
prior incidents or known weak areas inform this plan.>

## Risks (ranked)

| # | Risk | Worst-case consequence | Likelihood | Mitigation by tests |
|---|------|------------------------|------------|---------------------|
| 1 | <specific scenario>  | <observable harm>      | H/M/L     | <how tests address it> |
| 2 | …    |                        |           |                       |

(3-7 risks. Specificity beats taxonomy.)

## Coverage by HTSM dimension

For each dimension, name what gets tested at what level (unit /
integration / E2E / exploratory / production observability). Mark
deliberate gaps.

- **Structure:** <how code/data structure is exercised>
- **Function:** <which features and which paths>
- **Data:** <input ranges, edge values, malformed, large, empty>
- **Platform:** <OS / browsers / network / dependencies>
- **Operations:** <user journeys, ops runbooks>
- **Time:** <concurrency, ordering, age, scheduling, TZ/DST>

## Test distribution

<Stated distribution: e.g., "60% unit, 25% integration, 10% contract,
5% E2E + targeted exploratory." Reasoning included — why this shape
for this context.>

## Test inventory

### Automated tests (new + existing)

<List by area, not by test file. Each entry: what it asserts, what risk
it addresses, where it lives.>

### Exploratory charters

<Hendrickson-style charters; see `roles/tester/skills/exploratory-charter/`.>

### Specification-by-Example scenarios

<Adzic-style; written in domain language.>

## Out of scope (deliberate)

<What this plan does NOT cover, and why.>

## Pipeline expectations

<What CI/CD signals tell us this plan is working: failure surfacing time,
flakiness budget, what gates release.>

## Open questions

<Each owned by a named person with a deadline.>

## Roll-off

<When this plan retires or is folded into a regression baseline.>
```

### Step 3 — Self-review against seven checks

Before circulating:

1. **Risks-first check.** The risk section reads as scenarios, not vibes. Each risk is specific enough that a test could disprove it.
2. **HTSM-span check.** All six dimensions are addressed (covered or explicitly deferred). Time is almost never "N/A" — examine again if you wrote that.
3. **Pyramid-reasoning check.** The chosen distribution has a stated *why*. "Standard pyramid" is not a why.
4. **Negative-space check.** At least one test asserts behaviour the system refuses (e.g., rejected input, denied state transition).
5. **Out-of-scope check.** At least one item present. If everything is in scope, scope is fuzzy.
6. **Assertion-quality check.** Open three tests in the inventory at random. Does each have a real assertion, or just a call that confirms "code ran"?
7. **Pipeline-feedback check.** The plan names what CI tells us, not just what it gates.

### Step 4 — Circulate, defend, revise

Share with engineering, PM, and (for risky surfaces) security and SRE. Treat reviewer pushback as information, not opposition. A reviewer who says "I'd test X differently" has revealed an assumption your plan was hiding.

### Step 5 — Maintain as work proceeds

The plan lives as long as the area lives, with periodic refresh. When a production incident hits this area, the plan's risk section gets updated — incident → new risk row → new test. This is the harness compounding.

## Examples

### Example 1 — Risk section that earns its place (good)

```markdown
## Risks (ranked)

| # | Risk | Worst-case | Likelihood | Mitigation |
|---|------|------------|-----------|------------|
| 1 | Rate-limiter releases retried tokens twice in network-partition scenarios | Paid customers over-billed up to 2x order total; trust loss; refund cost | M (we partition ~monthly in prod) | Property test on token-release idempotence (all retry paths); integration test of partition recovery; production alert on duplicate-token-id rate |
| 2 | Concurrent updates to shared cart from two devices cause line-item loss | Lost sale; missing order; CS ticket | M | Integration test of two-writer scenario; pessimistic-lock contract test; load test at 100 concurrent updates/cart |
| 3 | Daylight-saving rollover in scheduled order-cleanup job double-deletes orders | Up to 1 hour of orders deleted twice from queue (idempotency saves us); customer support load | L (twice yearly) | Time-based test running the job across 2026-11-01 02:30 boundary in fake clock; idempotency assertion on delete-op |
| 4 | Postgres replica lag during checkout causes "your cart is empty" errors | Cart-abandonment spike; revenue loss | H during deploys | Contract test of read-after-write with replica delay; production alert on replica-lag threshold |
```

Each risk is concrete, has a falsifiable mitigation, and ties to a real failure mode. A reader can argue with the likelihoods — which is the point.

### Example 2 — HTSM section that catches Time (good)

```markdown
## Coverage by HTSM dimension

- **Time:**
  - Concurrent updates: integration test with 10 concurrent writers per cart.
  - Replica lag: contract test asserting read-after-write within 500ms.
  - DST rollover: time-mocked job run across 2026-11-01 boundary (US TZ) and 2027-03-28 (EU TZ).
  - Leap second: explicitly NOT covered; we accept up to 1s drift in scheduled jobs.
  - Long-running session: 24h-aged cart still checkout-able (manual exploratory + nightly synthetic).
```

The Time row alone catches four failure modes most plans miss. The leap-second deferral is a deliberate non-coverage decision rather than an omission.

### Example 3 — Failure mode (bad)

```markdown
## Risks
- Bugs in the new checkout.
- Users may have a bad experience.

## Tests
- We will test the checkout.
- 90% code coverage required.
- Manual QA pass before release.
```

Failures: risks are not scenarios; tests are not strategies; coverage metric stands in for thought; "manual QA pass" is not a plan. A reader gains no understanding of what is being tested or why.

## Common Pitfalls

### Pitfall 1 — Coverage-percentage as plan

**Symptom:** The plan's central metric is line/branch coverage; risks are absent or vague.

**Consequence:** Tests increase, defects don't decrease, suite slows. The team stops trusting coverage numbers because they no longer correspond to confidence.

**Fix:** Bach/Bolton — coverage is a heuristic, not a metric. Open with risks; choose techniques per risk; track assertion quality, not line counts.

### Pitfall 2 — Function-only coverage

**Symptom:** Tests exercise features (login, checkout, search) but ignore Data variations, Platform variability, Operations sequences, and Time.

**Consequence:** Production incidents repeatedly arrive from dimensions the plan never covered (timezone bugs, concurrency, dependency upgrades).

**Fix:** HTSM dimension check is non-negotiable. The Time row routinely surfaces the most-missed class of defect.

### Pitfall 3 — Happy-path-only thinking

**Symptom:** Every listed test exercises the success path. Error paths, rejected inputs, denied transitions are absent.

**Consequence:** Bug reports cluster in negative space; the team accumulates a backlog of "edge cases" that were structurally inevitable.

**Fix:** Negative-space check — for each functional area, ask "what does this refuse to do?" and assert it.

### Pitfall 4 — Borrowed plan, foreign context

**Symptom:** Plan copied from another team / project / SaaS template, applied unchanged.

**Consequence:** Kaner's first principle violated. The plan asserts things irrelevant to this context and omits things specific to it.

**Fix:** Plans don't travel; structures travel. Adopt the HTSM scaffold, draft the risk list from this context, justify the distribution for this team.

### Pitfall 5 — Assertion-free test inventory

**Symptom:** The inventory lists 200 tests; a sampled three of them assert nothing (or assert `result is not None`).

**Consequence:** The pipeline goes green; the product is broken; the team learns to distrust the suite.

**Fix:** Assertion-quality spot-check. Each plan-listed test must have a substantive assertion tied to a risk row.

### Pitfall 6 — Pipeline as gate, not feedback

**Symptom:** CI runs the suite and either green-lights or red-lights the release. Beyond pass/fail, the team learns nothing.

**Consequence:** Failures are batched until they're impossible to debug; flaky tests get retried until green; trust erodes.

**Fix:** Humble/Farley — the pipeline is the test. State, in the plan, what specific signals CI surfaces (latency regressions, flake rates, slow-test alerts).

### Pitfall 7 — Plan as compliance artifact

**Symptom:** The plan is written for a release sign-off form, not for the engineers running it. Padded with templated language; light on context.

**Consequence:** The artifact exists; the testing doesn't. After release, the plan is filed; nobody references it again.

**Fix:** Write for the audience that will *use* it. If your plan is required for compliance but not for execution, write the compliance summary as a separate artifact; keep the working plan honest.

## References

- **James Bach & Michael Bolton** — Rapid Software Testing (RST); Heuristic Test Strategy Model. See `roles/tester/sources.md`. [satisfice.com](https://www.satisfice.com/) and [developsense.com](https://developsense.com/).
- **Cem Kaner** — context-driven testing principles; *Lessons Learned in Software Testing* (2001, with Bach & Pettichord).
- **Lisa Crispin & Janet Gregory** — *Agile Testing* (2009); *More Agile Testing* (2014); the Agile Testing Quadrants.
- **Gojko Adzic** — *Specification by Example* (2011); domain-language acceptance tests.
- **Mike Cohn** — *Succeeding with Agile* (2009); test pyramid (used here as a heuristic to argue with, not a rule).
- **Jez Humble & David Farley** — *Continuous Delivery* (2010); pipeline as feedback mechanism.
- **Related Hornero skills:**
  - [`exploratory-charter`](../exploratory-charter/SKILL.md) — the exploratory inventory referenced by this plan.
  - [`regression-test`](../regression-test/SKILL.md) — incidents feed back into the plan via failing tests authored here.
  - [`pre-release-test-pass`](../pre-release-test-pass/SKILL.md) — the workflow that uses this plan at release time.
  - `roles/software-engineer/skills/tdd-discipline/SKILL.md` — handoff: change-level TDD lives there; suite-level strategy lives here.
  - `roles/product-manager/skills/prd/SKILL.md` — the PRD's success criteria seed this plan's risk section.
