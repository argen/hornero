---
name: regression-test
description: Use when a bug has been reported and the team needs to produce a failing test that reproduces it before the fix lands — the test is the guard against the bug coming back.
intent: |
  Produces or evaluates a regression test that reproduces a reported
  bug. The test fails on the current code, passes after the fix, and
  remains in the suite as a guard. This skill enforces three disciplines
  the team usually skips under deadline pressure: reproduce before
  fixing, write the test at the right level, and name the bug in the
  test so future readers don't delete it.
type: component
theme: bug-discipline
best_for:
  - A bug report that the team intends to fix
  - A near-miss in production that escaped existing coverage
  - A recurring bug that has been "fixed" before and returned
  - An AI-generated change that the team suspects introduced a regression
scenarios:
  - "Writing the reproducing test for BUG-1247 (cards with month=13 accepted)"
  - "Authoring a regression test after a Black Friday incident around cart-state loss"
  - "Pinning a known timezone bug before a refactor of the scheduling subsystem"
  - "Adding the missing test for a bug the team has now seen three times"
estimated_time: 15-60 minutes (the test, not the fix)
---

# Regression test

> v0 draft. Grounded in Kent Beck's *Test-Driven Development by Example* (2002), Michael Feathers' *Working Effectively with Legacy Code* (2004), Gojko Adzic on examples-as-specifications, and Google SRE's blameless-postmortem culture.

## Purpose

Convert a bug report into a failing test before fixing. The test:

1. **Reproduces the bug** with minimum setup.
2. **Fails for the same reason** the bug fails in production.
3. **Will pass after the fix lands** — and never again silently regress.
4. **Names the bug** so future readers don't mistake it for an arbitrary test.

This skill is a tester-side complement to the engineer-side [`tdd-discipline`](../../../software-engineer/skills/tdd-discipline/SKILL.md). Engineers should be doing this anyway; testers institutionalize it — for incidents, for known bugs, for "we've seen this before" situations where a regression test is the cheapest insurance the team can buy.

A bug fixed without a reproducing test is a bug that will return. The test is the only credible commitment the team makes to the bug's not-coming-back.

## Key Concepts

### Reproduce before fix

The first move on a bug report is *not* "investigate the code." It is "make the bug happen in a test." Two outcomes:

- **You can reproduce it.** Now you have a failing test and a clear definition of "fixed."
- **You cannot reproduce it.** The bug report is missing information, the bug depends on environment, or the bug doesn't exist as described. Each of these is critical information; each is invisible until you tried to reproduce.

Skipping reproduction is the single most common slip into "I thought I fixed it but didn't" — because the engineer never confirmed the bug existed in the form the report claimed.

### The right level

A regression test sits at the level where the bug *manifests*, not where it was caused. A timezone bug whose root cause is a util function may manifest at the API layer; the test goes at the API layer, because that's where the user sees it. The test for the util function is a different test (a unit test of the root cause); both are valuable, but the regression guard is the manifestation-level one.

Feathers's framing applies: introduce a seam if necessary to test at the right level, but don't degrade the test by pushing it to a level where the original report wouldn't have been visible.

### Pin the bug, then fix

Feathers's characterisation tests reapply here: in legacy code, the first test may pin the bug as it currently exists (e.g., "validation accepts month=13 because the range check is wrong"). The fix changes the test to assert correct behaviour ("validation rejects month=13"). Two distinct moves; two distinct review surfaces.

### Examples as specifications

Adzic: the test, written in domain language, doubles as documentation of the rule the bug violated. A test named `test_credit_card_with_month_13_is_rejected_because_months_are_one_through_twelve` is a runnable rule. A test named `test_validation_works` is no use to anyone in six months.

### Name the bug in the test

The test's name, docstring, or a load-bearing comment refers to the bug ID (`BUG-1247`, the incident ID, or the date and a sentence). Three reasons:

1. **Future readers don't delete it.** A test named `test_edge_case_2` looks deletable. A test referencing `BUG-1247 — incident 2025-09-12` does not.
2. **The fix's PR is connected to the test.** Reviewers can trace test → bug → fix.
3. **When the test fails years later, the failure message points the next person at the original context.**

### Don't over-fix in the test

The test asserts the bug is fixed; it does not assert every nearby thing also works correctly. Other tests cover those. A regression test that drifts into "while-I'm-here" assertions becomes hard to maintain and obscures what it's guarding.

### "We've seen this before" gets a test no matter what

If the team can say "this is the third time we've fixed this," a regression test is mandatory regardless of how trivial the fix looks. Pyhäjärvi: recurring bugs are evidence of a missing test, not of a careless team.

## Application

### Step 1 — Read the bug report carefully

Before writing any test, the tester (or the engineer fixing) extracts from the report:

- **Inputs / preconditions.** What state, account, configuration, data was in place?
- **Steps.** What was done, in what order?
- **Observed behaviour.** What happened, exactly?
- **Expected behaviour.** What should have happened, per the team's understanding?
- **Environment.** Browser, OS, version, locale, timezone, anything that could matter.

If any of these is missing, the bug report is the problem — go back to whoever filed it before writing a test. Reproducing a bug from an incomplete report is guessing.

### Step 2 — Reproduce in the smallest possible test

1. **Pick the level.** Unit, integration, contract, end-to-end — whichever level the bug manifests at.
2. **Strip the setup to the minimum.** A reproducing test that requires 200 lines of setup is itself a bug — the bug under test was probably easier to reproduce than that, and the setup is hiding the real cause.
3. **Run the test.** Confirm it fails.
4. **Read the failure message.** Does it describe the bug, or does it describe something else (setup error, missing dependency)? If the latter, the test isn't reproducing the bug yet.
5. **Confirm the failure is *the* bug**, not *a* bug. Sometimes the test reveals an adjacent issue; in that case, file the adjacent issue and refocus the test.

### Step 3 — Name the test for posterity

The test name and/or docstring/comment names the bug:

```python
def test_credit_card_month_13_is_rejected_BUG_1247():
    """
    BUG-1247: card validator accepted month=13 because the range check
    used `<` instead of `<=`. Returning customer was billed against an
    invalid-month token and the charge failed downstream with an unclear
    error. Fix: range check is now 1..12 inclusive.
    """
    ...
```

Or in a language without docstrings, a load-bearing comment with the same content:

```typescript
// BUG-1247 (incident 2025-09-12): validator accepted month=13.
test("credit card with month 13 is rejected", () => {
  ...
});
```

The bug ID, the date, and the one-sentence why are the three load-bearing pieces.

### Step 4 — Author the assertion at the manifestation level

The assertion describes what the user sees, not what the code does internally. Compare:

```python
# Implementation-coupled (brittle, unhelpful)
assert validator._range_check_lo == 1 and validator._range_check_hi == 12

# Manifestation-level (durable, informative)
assert validate_card({"month": 13, ...}) == ValidationError(field="month")
```

The manifestation test survives refactors of the validator's internals; the implementation-coupled one breaks every time you touch the file.

### Step 5 — Run the test before the fix

Run it. Confirm it fails. Save the failure output in the bug ticket or PR description. This is the evidence the test reproduced the bug — and the evidence the fix actually fixes it (when the same test goes green).

If the bug was rare or environment-dependent, run the test multiple times to confirm it fails *reliably*. A flaky reproducing test is no reproducing test at all.

### Step 6 — Make the fix; confirm green

Engineer applies the fix; the test goes green. All other tests stay green. The PR description includes:

- Bug ID and one-sentence description.
- Link to the reproducing test (file + line).
- Failure output before; pass output after.

### Step 7 — Land both together

The reproducing test and the fix land in the same PR. Never as separate PRs. Two reasons:

1. **The test without the fix is a broken build** for everyone else.
2. **The fix without the test is unverifiable** — reviewers can't tell whether the fix actually addresses the reported bug.

If the team has a no-failing-tests rule that prevents committing a red test, the workflow is: test + fix in the same commit, or the test in a separate commit with `xfail`/`skip` marker referencing the bug ID, followed by the fix commit that un-marks it. Either is fine; never just-the-fix.

### Step 8 — Update the test plan and (where appropriate) the post-mortem

For high-severity bugs:

- The [`test-plan`](../test-plan/SKILL.md) for this area gains a row in its Risks table reflecting what was missed.
- The post-mortem (if there is one) names this test as a follow-up action and points to it.

This is the feedback-loop discipline from Chris MDP's "Coding with AI" (see `roles/tester/sources.md` and `methodology.md`) — each bug becomes a permanent piece of the harness.

## Examples

### Example 1 — Reproducing test for a date-handling bug (good)

```python
# tests/billing/test_card_validation.py

import pytest
from billing.cards import validate_card, ValidationError

def test_card_with_month_above_12_is_rejected_BUG_1247():
    """
    BUG-1247 (incident 2025-09-12): the card validator accepted
    month=13 (and any month up to 99) because the upper-bound check
    used `month < 13` where it should have used `month <= 12`. A returning
    customer was charged against an invalid-month token; the charge
    failed at the provider with an unclear error and the cart was
    silently abandoned.

    This test pins the rejection. The fix changes the range check
    in billing/cards.py:42.
    """
    card = {
        "number": "4242424242424242",
        "month": 13,
        "year": 2030,
        "cvv": "123",
    }
    with pytest.raises(ValidationError) as exc:
        validate_card(card)
    assert exc.value.field == "month"
    assert "1" in exc.value.message and "12" in exc.value.message


@pytest.mark.parametrize("invalid_month", [0, 13, 99, -1])
def test_card_validator_rejects_out_of_range_months_BUG_1247(invalid_month):
    """
    Companion to test_card_with_month_above_12_is_rejected_BUG_1247.
    Asserts the validator rejects 0, negative, and large-positive months.
    The original bug was upper-bound; this triangulates the rule.
    """
    card = {
        "number": "4242424242424242",
        "month": invalid_month,
        "year": 2030,
        "cvv": "123",
    }
    with pytest.raises(ValidationError):
        validate_card(card)
```

What's good:
- Test name names the bug ID.
- Docstring tells a future reader what the bug was, why, and where the fix went.
- Assertion is at the manifestation level (`ValidationError` raised with `field="month"`), not the implementation level.
- A second test triangulates the rule — defends against the upper-bound bug being "fixed" by accidentally introducing a different range bug.

### Example 2 — Reproducing an intermittent bug (good)

```python
def test_cart_writes_under_replica_lag_are_visible_to_read_BUG_1308():
    """
    BUG-1308 (incidents 2025-10-12, -19, -26): under Postgres replica
    lag of ~300ms, the read-after-write for cart state was hitting the
    replica before write propagation. Users saw "empty cart" on the
    page they had just added an item to.

    Reproduction requires injected replica lag; we use a fixture that
    rebinds the read connection to a delayed proxy.
    """
    with replica_lag(milliseconds=500):
        user = make_user()
        cart = add_to_cart(user, SKU_WIDGET, qty=2)
        # The bug: this read used to return [] because it hit the replica.
        items = get_cart_items(user)
        assert items == [(SKU_WIDGET, 2)]
```

The bug was intermittent in production; the test is deterministic because the lag is injected. The fixture lives next to the test and can be reused by other tests of the same class of bug.

### Example 3 — Failure mode (bad)

```python
def test_card_validation():
    card = {"month": 13}
    assert not validate_card(card)
```

Failures: name doesn't link to the bug; no docstring; assertion doesn't say *why* the validation should fail (could be wrong card number, wrong month, wrong year, missing CVV); a future reader sees an arbitrary test they may delete; if the assertion changes from `not validate_card(card)` to `validate_card(card) is None` because the API changed, the test silently keeps passing for the wrong reason.

## Common Pitfalls

### Pitfall 1 — Fix-first, test-later (or never)

**Symptom:** Engineer reads the bug, sees the cause, ships a fix; the test "will follow."

**Consequence:** The test never follows, or follows in a separate PR that asserts something subtly different from what the bug demonstrated. The bug returns; nobody connects it.

**Fix:** Reproduce-before-fix is a hard rule. The PR contains both.

### Pitfall 2 — Test at the wrong level

**Symptom:** A bug that manifested in the checkout UI is "fixed" by a test on a helper function that the UI no longer uses.

**Consequence:** The bug can return through a different code path; the test gives a false sense of security.

**Fix:** Test at the manifestation level (where the user saw it). If a lower-level test is also valuable, add it as a companion — don't substitute.

### Pitfall 3 — Anonymous test

**Symptom:** Test name is generic (`test_edge_case_2`, `test_validation`); no docstring; no bug reference.

**Consequence:** Future readers don't know why this test exists. They refactor and delete it. The bug returns and nobody connects it to the test that used to guard against it.

**Fix:** Bug ID, one-sentence why, link to fix location. Make the test undeletable through ignorance.

### Pitfall 4 — Over-fitted test

**Symptom:** Test asserts not just the bug's manifestation but a dozen nearby things, including internal call sequences.

**Consequence:** Test breaks on every refactor of the area. Team grows resentful; "regression tests are flaky"; tests get deleted or weakened.

**Fix:** One assertion per test (or one cluster of closely-related assertions). The companion-test pattern handles triangulation. Internal behaviour belongs in unit tests of the internals.

### Pitfall 5 — Reproducing test for an unreproducible bug

**Symptom:** Engineer can't reproduce the bug locally; ships a fix anyway based on log inspection.

**Consequence:** The fix may not address the real cause. The bug may return in a way that the fix doesn't prevent.

**Fix:** Either find the missing reproduction condition (environment, data, timing) and inject it into the test, or escalate — "this bug is unreproducible; we are not ready to fix it; we need more information." The latter is a legitimate outcome.

### Pitfall 6 — Implementation-coupled assertion

**Symptom:** Test asserts on private attributes, internal method calls, or specific log messages.

**Consequence:** Test breaks on innocent refactor; team learns "tests are brittle"; test gets weakened to make it pass; bug protection erodes.

**Fix:** Manifestation-level assertion. What does the user / caller / consumer see? Assert that.

### Pitfall 7 — Forgetting to update the test plan

**Symptom:** Bug is fixed; reproducing test is added; the area's test plan is unchanged.

**Consequence:** Future test-plan reviews don't capture the new risk class. The team accumulates fixed-but-uncaptured bugs.

**Fix:** Every high-severity regression test triggers a one-line addition to the area's test plan: "BUG-1247 — out-of-range months — now covered by tests/billing/test_card_validation.py."

### Pitfall 8 — Test-as-fix

**Symptom:** A bug report is "fixed" by adding a test that documents the buggy behaviour as the expected behaviour, because changing the code is too hard.

**Consequence:** The bug is now baked into the regression suite. The team has institutionalised the wrong behaviour.

**Fix:** If the right fix is too expensive right now, mark the test `xfail`/`skip` with the bug ID and a TODO. *Never* assert that the bug is the spec.

## References

- **Kent Beck** — *Test-Driven Development by Example* (2002); reproduce-before-fix is the bug-fix variant of the red phase. See `roles/tester/sources.md`.
- **Michael Feathers** — *Working Effectively with Legacy Code* (2004); characterisation tests; seams introduced to enable reproduction.
- **Gojko Adzic** — *Specification by Example* (2011); tests as runnable domain rules.
- **Google SRE** — blameless-postmortem culture; regression tests as the durable artifact a postmortem produces. *Site Reliability Engineering* (2016, eds. Beyer, Jones, Petoff, Murphy), ch. 15.
- **Maaret Pyhäjärvi** — *Exploratory Testing* (2017); recurring bugs as evidence of missing tests.
- **Related Hornero skills:**
  - [`test-plan`](../test-plan/SKILL.md) — the area's plan absorbs the new risk row.
  - [`exploratory-charter`](../exploratory-charter/SKILL.md) — bugs surfaced in exploration come here for permanent capture.
  - [`pre-release-test-pass`](../pre-release-test-pass/SKILL.md) — the release workflow that consumes regression tests as gating signal.
  - `roles/software-engineer/skills/tdd-discipline/SKILL.md` — engineer-side companion; bug-fix variant of red-green-refactor.
  - `roles/software-engineer/skills/refactor-plan/SKILL.md` — when a regression test is also a characterisation test introduced ahead of a refactor.
