---
name: specification-by-example
description: Use when a team needs to write example-driven scenarios that double as acceptance tests — concrete, executable, readable by non-technical stakeholders, derived from acceptance criteria not bug reports.
intent: |
  Produces a set of given-when-then scenarios traceable from a feature or
  PRD to an acceptance test suite. The artifact is readable by product,
  engineering, and QA alike; it becomes the living documentation that
  survives the code's evolution. Adzic methodology.
type: component
theme: test-strategy
best_for:
  - A new feature with a PRD or acceptance criteria to be translated into scenarios
  - A domain rule that stakeholders and engineers understand differently
  - A team that has user stories but no executable acceptance tests
  - Pre-implementation: scenarios written in a workshop before a line of code
  - A legacy surface where the real business rules are undocumented and need to be surfaced
scenarios:
  - "Writing acceptance scenarios for a tiered-pricing feature before implementation"
  - "Facilitating a scenario workshop for a discount-code redemption flow"
  - "Producing Given-When-Then scenarios from a PRD's acceptance criteria"
  - "Creating living documentation for a complex permissions model"
  - "Surfacing hidden business rules in a legacy billing system by writing scenarios that force explicit decisions"
estimated_time: 60-120 minutes (scenario workshop + write-up); 20-40 minutes (solo spec from a clear PRD)
---

# Specification by example

> v0 draft. Grounded in Gojko Adzic's *Specification by Example* (2011) and *Bridging the Communication Gap* (2009), Lisa Crispin & Janet Gregory's ATDD discipline (*Agile Testing*, 2009), Mike Cohn's acceptance-criteria origins, and Maaret Pyhäjärvi's ensemble specification practice.

## Purpose

Specifications-by-example are *forward-looking* acceptance tests: concrete scenarios written before (or simultaneous with) implementation, derived from product acceptance criteria, readable by non-technical stakeholders, and executable as tests. They differ from regression tests in origin and audience:

| | Specification by example | Regression test |
|---|---|---|
| **Origin** | Acceptance criteria, PRD, domain rules | A reported bug |
| **Timing** | Written before or during implementation | Written after a defect is confirmed |
| **Audience** | Product, engineering, QA together | Engineering and QA |
| **Purpose** | Forward-spec: define what "done" means | Guard: prevent a known bug from returning |
| **Artifact** | Multi-scenario Given-When-Then | Single reproducing test |

See [`regression-test`](../regression-test/SKILL.md) for the bug-driven complement.

Adzic: the value of this technique is not in the automation (though automation is a goal) but in the *conversation the scenarios force*. Writing "Given a user with a 10% discount code, When they apply it to a £50 order, Then the total is £45" forces the team to agree on whether the discount applies before or after VAT, whether it stacks with other discounts, and what happens at £0. Those are domain decisions that belong in the specification, not in the implementation.

Crispin & Gregory: these scenarios are the Agile Testing Quadrant Q2 artifacts — *business-facing, team-supporting* tests that drive development. They are the most collaborative and most neglected quadrant.

## Key Concepts

### Given-When-Then (Gherkin)

The canonical format:

```gherkin
Given <a precondition — the state of the world before the action>
When  <an action — what the actor does>
Then  <an outcome — the observable result>
```

Variations:

- Multiple `And` or `But` lines continue a Given, When, or Then.
- `Scenario Outline` / `Examples` tables express the same scenario over multiple input sets — the Gherkin equivalent of parameterised tests.
- Background declares setup shared across all scenarios in a feature file.

The format is human-first. A product manager should be able to read every scenario and say "yes, that's the rule" or "no, that's wrong." If a scenario requires understanding the codebase to evaluate it, it's too technical.

### Living documentation

Adzic: scenarios are only *specifications by example* if they stay in sync with the code. A scenario that passes in the test suite is proof the system behaves that way. A scenario that is never automated is just a document — valuable, but not living. The goal is automation, even if it happens after the initial workshop.

The artifact lives in version control, next to or near the code it specifies, and is updated when the behaviour changes. When it drifts, the team has a conversation about whether the code or the spec is wrong. That conversation is the technique's core value.

### Scenario workshops (Pyhäjärvi / Adzic)

The best specifications come from workshops where product, engineering, and QA sit together (or meet synchronously) and work through examples collaboratively. Pyhäjärvi's ensemble specification practice: one driver writes scenarios on screen; everyone else navigates, questions, and corrects. The workshop surfaces hidden assumptions, naming conflicts, and missing cases that no individual would find alone.

Key questions to ask in the workshop:

- "What is the simplest example that shows the rule?"
- "What is an example that shows the rule does NOT apply?"
- "What happens at the boundaries?" (zero, one, max, just-over-max)
- "What do we want to explicitly leave unspecified for now?"

### Acceptance criteria → scenarios: the derivation

A PRD acceptance criterion is usually an intent: "Users with premium accounts can export to CSV." Scenarios flesh it out:

- Happy path: a premium user exports a dataset.
- Sad path: a free-tier user tries to export — what do they see?
- Edge: a premium user with an empty dataset exports — what is the file?
- Boundary: a dataset with 1,000,001 rows (over the export limit) — what happens?
- State: a user whose premium account just expired during export.

Each of these is a scenario. The original acceptance criterion implied all five; only the workshop (or a very careful tester) produces all five before shipping.

### Naming: scenarios as rules

Each scenario's name is the rule it embodies, stated as a fact or as the condition:

```gherkin
Scenario: Premium users can export non-empty datasets as CSV
Scenario: Free-tier users see an upgrade prompt on export attempt
Scenario: Exporting an empty dataset produces a CSV with headers only
```

Not:

```gherkin
Scenario: Test export
Scenario: Export case 3
```

The names are the navigable index of domain knowledge. They should read like a specification document.

### Traceability

Each scenario traces to an acceptance criterion or user story. The trace lives in a comment, a tag (`@AC-47`), or in the linked ticket. When the acceptance criterion changes, the linked scenarios are the first things to review.

## Application

### Step 1 — Gather inputs

Before writing scenarios:

1. **Read the PRD or feature spec.** Extract acceptance criteria as a list. If there are no acceptance criteria, the work is incomplete — stop and produce them (with the PM) before writing scenarios.
2. **Identify the actors.** Who interacts with this feature? Different actors often produce different scenarios.
3. **Identify the domain objects.** What entities are created, read, updated, or deleted? What are their valid states?
4. **Identify the rules.** What constraints apply? When does the action succeed? When does it fail? What changes?

### Step 2 — Run or simulate a scenario workshop

If the team can meet (synchronously): 60-minute session with PM, one engineer, one QA. Driver writes on screen; others question.

If working solo from a PRD: for each acceptance criterion, produce:

- One **happy path** scenario (action succeeds, state changes as expected).
- One or two **sad path** scenarios (action fails; error is meaningful).
- Boundary scenarios at the edges of ranges.
- State-transition scenarios if the feature involves state machines.

### Step 3 — Write the feature file

```gherkin
Feature: <Feature name — short, domain-language>

  <Optional: 2-3 sentence description of the feature and its goal.>

  Background:
    Given <shared setup for all scenarios in this file>

  Scenario: <Rule the scenario embodies>
    Given <precondition>
    When  <action>
    Then  <observable outcome>
    And   <additional outcome if needed>

  Scenario Outline: <Rule with multiple inputs>
    Given a user with a <discount_type> discount
    When  they apply it to an order of <order_total>
    Then  the total is <expected_total>

    Examples:
      | discount_type | order_total | expected_total |
      | 10%           | £50.00      | £45.00         |
      | 10%           | £0.01       | £0.01          |
      | flat £5       | £50.00      | £45.00         |
      | flat £5       | £4.99       | £0.00          |
```

### Step 4 — Review with stakeholders

Circulate the feature file before implementation. Product confirms the rules are correct. Engineering confirms the scenarios are technically meaningful. QA confirms the coverage is adequate — especially edge cases.

A reviewer who says "I'd add a scenario for X" has revealed a missing case. Add it. A reviewer who says "scenario Y is wrong" has revealed a specification error. Fix it before implementation begins.

### Step 5 — Automate (incrementally)

Automate scenarios in the same sprint or as the feature is built, not months later. Two paths:

- **Cucumber / Behave / SpecFlow** — step definitions connect Gherkin to test code. The Gherkin file is the specification; the step definitions are the automation harness.
- **Gherkin-shaped tests without a BDD framework** — test names mirror the scenario text; the test body implements the given-when-then. The Gherkin file still exists as documentation; the test file implements it without the glue-code overhead.

For small teams: Gherkin-shaped test names without a full BDD framework is often faster and just as readable. The discipline is in the scenario names and the traceability, not in the tooling.

### Step 6 — Update as behaviour changes

When a feature changes, the scenarios change first (or simultaneously). A failing scenario is not a broken test — it is the system telling you the spec has changed. Decide: is the new behaviour correct? Update the scenario. Is the new behaviour a regression? Revert the code.

Adzic: living documentation that is kept in sync is the most durable form of specification the team can produce. A wiki page goes stale; a green scenario is current.

## Examples

### Example 1 — Tiered pricing feature (complete feature file)

**Context:** A SaaS product is adding a tiered pricing feature. The PRD says: "Users on the Pro plan pay $29/month for up to 5 seats, then $7/seat/month for additional seats. Users on the Free plan pay $0 and are capped at 1 seat. Billing is computed on the first day of the month."

**Feature file produced by the scenario workshop:**

```gherkin
Feature: Tiered seat billing

  The Pro plan bills $29/month for up to 5 seats.
  Additional seats are billed at $7/seat/month.
  The Free plan is capped at 1 seat with no charge.
  Billing is computed on the first of the month.

  @AC-112
  Scenario: Pro plan with seats within the included tier
    Given a Pro workspace with 3 seats
    When  the billing cycle runs on the first of the month
    Then  the invoice is $29.00
    And   the invoice line reads "3 seats — Pro plan (5 included)"

  @AC-112
  Scenario: Pro plan with seats above the included tier
    Given a Pro workspace with 8 seats
    When  the billing cycle runs on the first of the month
    Then  the invoice is $50.00
    # $29 base + (8 - 5) * $7 = $29 + $21 = $50
    And   the invoice has two line items: base fee and overage

  @AC-112
  Scenario Outline: Pro plan billing at tier boundary and above
    Given a Pro workspace with <seats> seats
    When  the billing cycle runs
    Then  the invoice total is <expected>

    Examples:
      | seats | expected | note                   |
      | 1     | $29.00   | well below included    |
      | 5     | $29.00   | exactly at included    |
      | 6     | $36.00   | one over included      |
      | 100   | $679.00  | 95 overage seats       |

  @AC-113
  Scenario: Free plan user is capped at 1 seat
    Given a Free workspace with 1 seat
    When  an admin attempts to add a second seat
    Then  they see "Upgrade to Pro to add more seats"
    And   the seat count remains 1

  @AC-113
  Scenario: Free plan incurs no charge
    Given a Free workspace with 1 seat
    When  the billing cycle runs on the first of the month
    Then  no invoice is generated
    And   the workspace is not charged

  @AC-114
  Scenario: Billing runs on the first, not on the seat-addition date
    Given a Pro workspace with 3 seats added on the 15th
    When  the 15th billing check runs
    Then  no invoice is generated
    When  the 1st of the next month billing cycle runs
    Then  the invoice is $29.00
```

What the workshop surfaced that the PRD did not spell out:
- The invoice line-item format (important for customer trust and CS queries).
- Whether the seat cap on Free is enforced at add-time or at billing time.
- The billing-date rule needs a scenario to prove it's not prorated mid-month.

### Example 2 — Failure mode (bad)

```gherkin
Feature: Discount

  Scenario: Test discount
    Given the system is running
    When  the user uses a discount
    Then  the discount is applied
```

Failures: "the system is running" is not a precondition — it's noise. "Uses a discount" gives no domain context (what type? what code? what order?). "The discount is applied" is not an observable outcome — what does "applied" mean precisely? A product manager cannot confirm this is correct. This scenario neither specifies nor tests anything meaningful.

## Common Pitfalls

### Pitfall 1 — Scenario-after-the-fact

**Symptom:** Scenarios are written *from* the code that already exists. Every scenario passes immediately; they describe current behaviour, not specified behaviour.

**Consequence:** The scenarios are not specifications — they are reverse-engineered tests. They cannot catch regressions introduced by changes made after they were written.

**Fix:** Adzic — examples come from the problem domain, not the implementation. Write scenarios before or during implementation. If writing after, treat each scenario as a question: "is this the rule we intended?" and correct where the code was wrong.

### Pitfall 2 — Technical language leaking in

**Symptom:** Scenarios contain words like "POST to /api/v2/orders", "the database is updated", "the HTTP response is 200", "the Vue component re-renders."

**Consequence:** Product managers and non-technical stakeholders can't read them. The scenarios don't serve as a shared language. They become another engineering artifact that only engineers maintain.

**Fix:** Use domain language. "A user places an order" instead of "POST /orders." "The order appears in the user's order history" instead of "the database order table has a row." Domain language survives API redesigns; endpoint-level language doesn't.

### Pitfall 3 — Happy-path-only scenarios

**Symptom:** The feature file has ten happy-path scenarios and no sad paths, no boundary cases, no state-transition scenarios.

**Consequence:** The implementation can pass all scenarios while failing on the first real user who tries something slightly off the happy path.

**Fix:** For every acceptance criterion, ask: "When does this NOT work? What happens then?" At least one sad-path scenario per rule. At least one boundary scenario for every range or limit.

### Pitfall 4 — Never automated

**Symptom:** The feature file is written in the workshop; a ticket is created to "automate the scenarios"; the ticket lives in the backlog for months.

**Consequence:** The scenarios are documentation, not living documentation. They drift. After six months nobody trusts them.

**Fix:** Automate in the same sprint. If full Gherkin tooling is too heavyweight, use Gherkin-shaped test names and a co-located test file. The automation doesn't need to be fancy; it needs to exist.

### Pitfall 5 — Scenario count explosion

**Symptom:** The feature file has 80 scenarios for a single feature. Every edge case, every combination of inputs, is its own scenario.

**Consequence:** Scenarios become impossible to review and maintain. The workshop takes four hours. Engineers tune them out.

**Fix:** Use `Scenario Outline` with `Examples` tables for parameterised cases. Keep the narrative scenarios to the key rules (happy path, key sad paths, key boundaries). Property tests (see [`property-spec`](../property-spec/SKILL.md)) are the right tool for exhaustive combinatorial coverage — scenarios are the right tool for named, business-readable rules.

### Pitfall 6 — Scenarios not linked to acceptance criteria

**Symptom:** The feature file exists but the link to the PRD's acceptance criteria is missing. Six months later, a scenario is deleted as "redundant" without knowing it was the only test for AC-112.

**Consequence:** Acceptance criteria go uncovered silently.

**Fix:** Tag each scenario with the acceptance criterion it covers (`@AC-112`). When a criterion changes, find the tagged scenarios and update them together.

### Pitfall 7 — Mistaken for regression tests

**Symptom:** The team writes specification-by-example scenarios for a reported bug. The scenario describes the buggy state. It passes immediately on the fixed code. It's committed. Nobody ever checks if it actually guards the regression.

**Consequence:** The scenario is misclassified. It may not be a regression guard; it may be a specification of the fix, which is useful but different.

**Fix:** Bug-driven tests belong in [`regression-test`](../regression-test/SKILL.md). Specification-by-example is forward-looking: it specifies what the system should do, derived from acceptance criteria, before the implementation. The two skills are complementary, not interchangeable.

## References

- **Gojko Adzic** — *Specification by Example* (2011); *Bridging the Communication Gap* (2009). The methodology that names and defines this practice. See `roles/tester/sources.md`.
- **Lisa Crispin & Janet Gregory** — *Agile Testing* (2009); *More Agile Testing* (2014); the ATDD discipline and the Agile Testing Quadrants that place specification-by-example in Q2 (business-facing, team-supporting). See `roles/tester/sources.md`.
- **Mike Cohn** — *Succeeding with Agile* (2009); acceptance criteria as the precursors to acceptance tests. See `roles/tester/sources.md`.
- **Maaret Pyhäjärvi** — ensemble specification practice; writing scenarios as a whole-team activity. See `roles/tester/sources.md`.
- **Related Hornero skills:**
  - [`regression-test`](../regression-test/SKILL.md) — the bug-driven complement: single-example, backward-looking, from a defect report. Cross-reference: if you are writing a test to pin a bug, use that skill.
  - [`property-spec`](../property-spec/SKILL.md) — the exhaustive complement: invariants across generated inputs. Scenarios are named rules; properties are exhaustive checks. Use both.
  - [`test-plan`](../test-plan/SKILL.md) — the plan's "Specification-by-Example scenarios" section is populated from this skill's output.
  - [`exploratory-charter`](../exploratory-charter/SKILL.md) — when scenarios reveal missing understanding of the domain, an exploratory charter investigates before the scenarios are finalised.
  - `roles/product-manager/skills/prd/SKILL.md` — acceptance criteria in the PRD are the direct input to this skill.
