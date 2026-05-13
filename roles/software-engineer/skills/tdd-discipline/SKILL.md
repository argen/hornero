---
name: tdd-discipline
description: Use when implementing a behaviour change (feature or bug fix) and you want each step driven by a failing test — red, green, refactor — with each phase respected, not collapsed.
intent: |
  Walks an engineer (or an AI coding agent) through Kent Beck's red-green-
  refactor loop with enough structure that the discipline survives time
  pressure. Three things distinguish disciplined TDD from "writing tests
  alongside code": the test must fail first, for the right reason; the
  production code is the minimum to pass; refactoring happens only on
  green and never carries new behaviour.
type: workflow
theme: code-change
best_for:
  - Bug fixes (the test reproduces the bug first; the fix turns it green)
  - New features with a clear external-behaviour shape
  - Untangling logic where the team has lost confidence in correctness
  - AI-agent-generated changes where the test is the only check against
    plausible-but-wrong code
scenarios:
  - "Implementing a new validation rule on user signup"
  - "Fixing a regression where invoices over $10k bypass tax calculation"
  - "Adding a new endpoint that filters orders by status"
  - "Driving an AI agent's implementation of a parser change"
estimated_time: 5-40 minutes per red-green-refactor cycle; the workflow is iterated, not run once
---

# TDD discipline — Red, Green, Refactor

> v0 draft. Grounded in Kent Beck's *Test-Driven Development by Example* (2002) and *Tidy First?* (2023), with adaptations for AI-coding workflows informed by Chris MDP's "Coding with AI" and Gergely Orosz's observations on AI-coding adoption.

## Purpose

Drive each behaviour change through the red-green-refactor loop:

1. **Red** — write a test that pins down the desired behaviour. Run it. Confirm it fails for the right reason.
2. **Green** — write the minimum production code to make the test pass.
3. **Refactor** — only on green, improve structure without changing behaviour. Tests stay green throughout.

The discipline matters for the same reason a chef's knife technique matters: the loop is what protects you when you're tired, under deadline, or working in code you don't fully understand. Skipping a phase ("the test will obviously fail, I'll just write the code") is the move that lets bugs in.

For AI-coding contexts: TDD is **the** load-bearing safety net. A generated implementation is plausibly-correct prose dressed as code. The failing test is the only mechanism that distinguishes "the model wrote what we asked for" from "the model wrote what looks like the right answer."

## Key Concepts

### Beck's three phases as distinct moves

Kent Beck (*Test-Driven Development by Example*): red, green, and refactor are three different cognitive modes.

- **Red** is design — you are deciding what the code should do, from the outside.
- **Green** is implementation — you are making the test pass, by any means necessary including "fake it" or duplication.
- **Refactor** is cleanup — you are improving the structure of green code.

The bugs slip in when these modes collapse into "writing code." Beck's claim, validated across decades of practice: **separating them lets you do each better**.

### The red phase: failing for the right reason

A test that fails because of a typo, a missing import, or the wrong test runner has not validated anything. The Red phase ends only when:

1. The test runs.
2. The test fails.
3. The failure message correctly describes the not-yet-implemented behaviour.

If the failure is a `NameError`, the test isn't ready. If the failure is `expected 7, got nothing`, the test is ready and Green can begin.

### Minimum code to pass

Beck's "fake it 'til you make it" rule: when the test asserts `result == 7`, returning `7` is a legitimate first move. The next test forces generalisation. This sounds silly until you've watched an engineer go from "add this feature" to a 600-line implementation that the tests don't actually exercise — generalising prematurely is the most common path to over-engineered code.

In practice: the production code is the *smallest change that turns the current test green without breaking the previous tests*. Anything beyond that is speculation.

### Triangulation

Beck again: when a single test passes with a hard-coded value, write a second test with different inputs. The two tests together force a real implementation. This is *triangulation* — using examples to drive out the general case. Three concrete tests typically suffice; if it still feels like the implementation is over-fit, add a fourth.

### Refactor only on green

The refactor phase only ever begins when *all* tests are green. If you refactor on red, you've conflated structural and behavioural change (see [`refactor-plan`](../refactor-plan/SKILL.md)) and lost the ability to tell which one broke. If a test goes red during refactor, you've changed behaviour by accident — revert, not patch.

### Tidy-first or tidy-after

From Beck's *Tidy First?* (2023): structural changes (tidyings) can come *before* the red phase (to make the code easy to add the test to) or *after* the green phase (to clean up the result). They cannot ride inside the green phase, where the rule is "minimum code to pass." Naming when you tidy is a small but load-bearing discipline.

### Bug fixes start with a failing test reproducing the bug

The bug-fix variant: the first move is a test that *fails because the bug exists*. The fix then turns the test green. Without this, "fixed" cannot be distinguished from "wrote different code that has the same bug differently."

### AI-coding amplifies the value

Chris MDP, Gergely Orosz, and Simon Willison have all noted: AI-generated code is dangerous in proportion to how plausibly-correct it looks. The failing test is the harness's truth-teller. When you ask an agent to "implement X," the test for X is non-negotiable — preferably written first, by a human or a deliberately-separated agent step.

## Application

The workflow is a small loop iterated many times. Each iteration ships one behaviour change to one test.

### Step 0 — Frame the change

Before writing any test, write one or two sentences on what behaviour change this commit will deliver. If you can't, you're not ready for TDD — you're still in design. Drop back to a quick spike (or an RFC if the change is big enough) and return when the behaviour shape is clear.

### Step 1 — RED: write the failing test

1. **Pick the smallest behaviour to add.** Resist writing a test for the whole feature; pick the smallest assertable slice. (For a parser: one valid input, one specific output.)
2. **Write the test.** It should read as a description of behaviour, not implementation.
3. **Run the test.** Confirm it fails. Read the failure message.
4. **Verify the failure is "for the right reason."** The error should describe the missing behaviour, not a setup problem.
   - `NameError: X is not defined` → ambiguous; could be wrong test, could be the not-yet-implemented thing. Stub the symbol so the failure becomes informative.
   - `expected 7, got 0` → good. The test runs and is asserting on the actual code path.
5. **Capture the failure output.** Paste it into the commit/PR description or your scratch notes. Future-you will want to see what Red looked like.

If the test passes when first run, **stop**. Either the behaviour already exists (the test is redundant — delete it or assert something new) or the test is wrong (rewrite it). A test that passes on first write has validated nothing.

### Step 2 — GREEN: write the minimum code to pass

1. **Make the failing test pass.** Fastest path; ugliest is fine.
2. **Do not write code that no test requires.** The "minimum" rule is literal. If you find yourself writing a branch, a parameter, or a class because "we'll need it later," stop — that's speculation, not green.
3. **Run the test.** Confirm it passes. Run all tests. Confirm none have gone red.
4. **Commit.** This commit represents one behaviour added, with a test that proves it.

Beck's "fake it" rule applies here. If `return 7` is the minimum and the test passes, that's legitimate. The next Red step (Step 1 of the next cycle) will force generalisation.

### Step 3 — REFACTOR: improve structure on green

1. **Confirm all tests are green.** If they're not, skip this step.
2. **Identify structural improvements** — duplication to remove, names to clarify, decomposition to extract. Use Fowler's catalogue vocabulary: Extract Function, Rename Variable, Inline Variable.
3. **Apply one refactoring at a time.** Run tests after each. If a test goes red, *revert*, don't patch.
4. **Stop early.** Refactor only as much as the current behaviour-set warrants. Premature abstraction (Metz's wrong-abstraction trap) is the bigger risk than under-cleanup. Wait for the Rule of Three before extracting.
5. **Commit the refactor separately** from the Green commit. Two small commits beat one bigger one.

If there's nothing to refactor — the green code is already clean — that's fine. Skip to the next Red.

### Step 4 — Loop or stop

- **Next behaviour to add?** Return to Step 1.
- **All behaviours covered?** Stop. Move on. Resist "while I'm here" creep.

### Step 5 — Defensive AI-agent variant

When directing an AI agent (Claude Code, a subagent, etc.) through TDD:

1. **You write the test, or the agent writes it first in isolation** with explicit instructions: "Write only the failing test; do not implement."
2. **Run the test yourself; verify the failure for the right reason.** Do not delegate this check.
3. **Then direct the agent to implement minimum code to pass.** Constrain scope: "Make this one test pass; do not modify other files; do not add features."
4. **You run the full test suite.** Generated code is suspect until it has been observed to pass *the test you wrote* and *not break the rest*.
5. **Refactor as a separate step** with its own prompt, only on green.

The separation of "agent writes test" and "agent writes implementation" matters because a single agent given both jobs will write test-and-code that pass each other regardless of whether they correspond to the intended behaviour.

## Examples

### Example 1 — Bug fix (good)

A user reports: "Invoices over $10,000 are being created without tax calculated."

**RED — write the failing test:**

```python
def test_invoice_above_10k_calculates_tax():
    invoice = Invoice(subtotal=Decimal("10500.00"), tax_rate=Decimal("0.20"))
    assert invoice.tax == Decimal("2100.00")
    assert invoice.total == Decimal("12600.00")
```

Run: `FAILED test_invoice.py::test_invoice_above_10k_calculates_tax - assert Decimal("0.00") == Decimal("2100.00")`

Failure is "for the right reason" — the tax field is calculated to zero rather than the expected amount. We have reproduced the bug.

**GREEN — minimum code to pass:**

Investigation reveals `Invoice.calculate_tax` has `if self.subtotal < 10000:` (off-by-one boundary). Change to `<=` — wait, that's still buggy at $10k. Correct fix: remove the cap entirely; tax applies regardless of subtotal.

```python
# Before
def calculate_tax(self):
    if self.subtotal < 10000:
        return self.subtotal * self.tax_rate
    return Decimal("0.00")

# After
def calculate_tax(self):
    return self.subtotal * self.tax_rate
```

Run all tests: green. Commit: "fix(invoice): apply tax regardless of subtotal amount."

**REFACTOR — on green:**

The change removed a branch; the method is now a one-liner. Inline it into the `tax` property and delete the method. Tests still green. Commit: "refactor(invoice): inline calculate_tax."

Two commits. Each does one thing. A future reader can `git bisect` cleanly.

### Example 2 — Feature with triangulation (good)

Adding a function that classifies strings as `palindrome | not-palindrome`.

**Cycle 1 — RED:**

```python
def test_single_char_is_palindrome():
    assert is_palindrome("a") == True
```

Run: `NameError: name 'is_palindrome' is not defined`. Stub the function: `def is_palindrome(s): pass`. Run again: `assert None == True` — informative failure.

**Cycle 1 — GREEN:**

```python
def is_palindrome(s):
    return True
```

Test passes. Yes, this is silly. That's the point — minimum to pass.

**Cycle 2 — RED:** (triangulation)

```python
def test_two_different_chars_is_not_palindrome():
    assert is_palindrome("ab") == False
```

Fails: `assert True == False`. Good.

**Cycle 2 — GREEN:**

```python
def is_palindrome(s):
    return s == s[::-1]
```

Both tests pass. The second test forced the real implementation.

**Cycle 3 — RED:** (edge case)

```python
def test_empty_string_is_palindrome():
    assert is_palindrome("") == True
```

Passes immediately. **Stop.** This test was redundant — it added nothing the existing code didn't already handle. Delete it (or keep it as documentation if it's a meaningfully-different example). The discipline: when a test passes on first write, it has not driven any code.

### Example 3 — Failure mode (bad)

```
Engineer: "I'll just add the validation and write the test after."
[writes 80 lines of validation logic]
[writes one test that exercises the happy path]
Test: green ✓
```

Failures: no Red phase — there was never a failing test, so the test doesn't prove the code does what was intended. Behaviour is over-specified relative to what was demanded. Edge cases are untested. Six months later, someone changes the validation; the single test still passes, but the original intent is gone because there's no record of what behaviour was actually being demanded.

## Common Pitfalls

### Pitfall 1 — The test that passes on first write

**Symptom:** You wrote a test, ran it, and it passed. You shrug and move on.

**Consequence:** The test has driven no behaviour. It may be wrong (asserts the existing behaviour, not the intended one). It may be redundant. Either way, it's not a TDD test.

**Fix:** Investigate why. If the behaviour already exists, you didn't need this test — delete it or assert something new. If the test is wrong, fix it. Never carry a never-failed test as if it had been driving design.

### Pitfall 2 — Skipping Red because "it'll obviously fail"

**Symptom:** "I know the code doesn't have this yet, so I'll write the code, then the test."

**Consequence:** The most common slip into test-after development. Sometimes the test doesn't actually exercise the new code path. Sometimes the new code path has a bug the test happens not to catch. The discipline that catches both — running the test and watching it fail — is the discipline you skipped.

**Fix:** Run the test before writing production code, even if you're 100% sure it'll fail. The 30 seconds you save by skipping is the 30 seconds that catches the bug.

### Pitfall 3 — Refactoring on red

**Symptom:** Mid-implementation, you notice some adjacent code is ugly and tidy it while the test is still red.

**Consequence:** When you run tests again and one is failing, you can't tell whether the new behaviour is incomplete or the tidy broke an existing one. Cognitive load spikes; mistakes follow.

**Fix:** Beck's tidy-first/tidy-after rule. If you spot a tidy opportunity, note it. Finish green. Refactor on green. The discipline costs nothing and prevents a real failure mode.

### Pitfall 4 — Speculative generality in Green

**Symptom:** The test asks for X; the implementation does X + 3 things you anticipate needing.

**Consequence:** The extra 3 things aren't covered by tests, so they may not work. They constrain future change (you have to keep them working in subsequent refactors). They make the diff harder to review. They are the most common source of premature abstraction.

**Fix:** Minimum code to pass — literally. If you find yourself adding scope, write another failing test first to justify it. If you can't write a failing test for it, you don't need it yet.

### Pitfall 5 — Tests that test the implementation, not the behaviour

**Symptom:** Tests assert internal call sequences ("then `helper_method` is called twice"), depend on private attributes, mock everything down to the standard library.

**Consequence:** Refactoring breaks tests even though behaviour is preserved. The team learns that "TDD makes refactor hard" — when the real problem is bad tests.

**Fix:** Tests assert observable outputs, not internal mechanism. If you're tempted to test internal sequencing, you may be testing the wrong abstraction — write the test at a higher level instead.

### Pitfall 6 — Reproduction-test skipping on bug fixes

**Symptom:** A bug is reported; the engineer investigates, finds the cause, fixes it, and ships. No reproducing test was written.

**Consequence:** The fix may be wrong (you found *a* cause, not necessarily *the* cause). The bug may recur (no test guards against it). The fix can't be reviewed for relevance — reviewers can't tell what bug it addresses.

**Fix:** Every bug fix opens with a failing test that reproduces the bug. The fix turns the test green. Both ride in the same PR. This is non-negotiable.

### Pitfall 7 — One giant test instead of many small ones

**Symptom:** A single test sets up a complex scenario, exercises 10 code paths, and asserts 20 things.

**Consequence:** When it fails, you know "something is wrong" but not what. Triangulation can't happen — there's nothing for the next test to force.

**Fix:** Small tests, one behavioural assertion per test. Triangulation works only when each test is small enough to point at one specific behaviour.

### Pitfall 8 — Trusting the agent's claim that it "ran the tests"

**Symptom:** AI agent reports "all tests pass" without you having seen the output.

**Consequence:** Agents have been observed to confidently report green when the test wasn't actually invoked, or when a different test suite was run, or when an irrelevant failure was waved away.

**Fix:** *You* run the suite. Or, at minimum, view the test runner's output yourself rather than trusting the agent's summary. The whole TDD discipline rests on the failure being observed; outsourcing the observation defeats the practice.

## References

- **Kent Beck** — *Test-Driven Development by Example* (2002). The canonical book; red-green-refactor and "fake it" are from here. See `roles/software-engineer/sources.md`.
- **Kent Beck** — *Tidy First? A Personal Exercise in Empirical Software Design* (2023). The structural/behavioural separation that disciplines the Refactor phase.
- **Martin Fowler** — *Refactoring* (2nd ed., 2018); the catalogue of moves used in the Refactor phase. See also [`refactor-plan`](../refactor-plan/SKILL.md).
- **Sandi Metz** — "The Wrong Abstraction" (2016); the discipline of waiting before extracting.
- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/); the harness-compounding argument that frames TDD as the AI-coding safety net.
- **Gergely Orosz** — *The Software Engineer's Guidebook* and *The Pragmatic Engineer* essays on AI-coding adoption in real engineering teams.
- **Simon Willison** — [simonwillison.net](https://simonwillison.net/) — practical observations on LLM-tool reliability that motivate the AI-agent variant.
- **Related Hornero skills:**
  - [`refactor-plan`](../refactor-plan/SKILL.md) — for the planning of larger refactors; this skill is the loop, that one is the strategy.
  - [`adr`](../adr/SKILL.md) — for capturing decisions that emerge during TDD (e.g., "we accept fake-it indefinitely for this seam").
  - [`rfc`](../rfc/SKILL.md) — for proposals too large to drive purely through TDD; the RFC settles direction, TDD implements.
  - `skills/spec-the-problem/SKILL.md` — runs before TDD when the behaviour shape isn't yet clear.
