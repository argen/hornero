---
name: property-spec
description: Use when a tester needs to write a property-based test specification — naming the invariants that should hold across many inputs and expressing them in Hypothesis, fast-check, ScalaCheck, or QuickCheck.
intent: |
  Produces a property specification that names the invariants of a system
  and expresses them as runnable generators + assertions in the relevant
  property-test library. Catches the class of bugs that example-based
  tests miss by construction: bugs that only appear at unusual inputs the
  team didn't think to write by hand.
type: component
theme: test-strategy
best_for:
  - A codec, serialiser, or protocol where round-trip identity should hold
  - A function that should be idempotent (calling twice is the same as calling once)
  - A refactor where the new implementation should be equivalent to the old one across all inputs
  - A financial or ordering system where invariants must hold (money is conserved; timestamps are monotone)
  - Any area where example tests keep finding one edge case at a time
scenarios:
  - "Writing properties for a JSON ↔ model round-trip before a serialisation refactor"
  - "Specifying idempotence for a retry-safe payment-capture endpoint"
  - "Equivalence-checking a rewritten sort against the stdlib sort"
  - "Oracle-testing a fast path against a slow but obviously-correct reference"
  - "Invariant-checking that cart totals are always non-negative after any sequence of operations"
estimated_time: 30-90 minutes (first property spec); 10-20 minutes (adding properties to an existing suite)
---

# Property spec

> v0 draft. Grounded in John Hughes' QuickCheck paper (2000) and Quviq work on property-based testing, Kent Beck's test-first discipline (*Test-Driven Development by Example*, 2002), James Bach & Michael Bolton's HTSM dimensions (Data and Time are where properties shine), and Gojko Adzic's framing of tests as specifications (*Specification by Example*, 2011).

## Purpose

Example-based tests check specific inputs the author thought of. Property-based tests generate thousands of inputs the author didn't think of, looking for inputs that violate a stated invariant. The two techniques are complementary: examples anchor visible, business-readable scenarios; properties hunt the dark matter of input space.

Three things this skill delivers:

1. **Name the properties** — the invariants the system should satisfy before picking a library or writing a line of code.
2. **Express them as generators + assertions** in the relevant library (Hypothesis for Python; fast-check for TypeScript/JavaScript; ScalaCheck for Scala; QuickCheck or Hedgehog for Haskell).
3. **Document what the properties protect** so future engineers don't weaken or delete them under pressure.

Hughes: "Instead of specifying that a function returns the right result for two or three inputs, we can specify that it returns the right result for all inputs we can generate." That sentence is the skill's mandate.

## Key Concepts

### The property categories

Seven canonical categories cover most useful properties:

1. **Round-trip** — `decode(encode(x)) == x`. Applies to any codec, serialiser, URL encoder, compression, encryption, or parser. The encode step transforms; the decode step inverts. The property asserts identity after the round-trip. Variant: *round-trip the other direction* — `encode(decode(b)) == b`.

2. **Idempotence** — `f(f(x)) == f(x)`. Applies to any operation that should be safe to apply twice: `normalise`, `deduplicate`, `trim`, `apply_migration`, `retry_capture`. A failing idempotence property is almost always a real bug — the function accumulates side effects it shouldn't.

3. **Equivalence** — `refactored(x) == original(x)` for all `x`. The strongest safety net for refactors. Run the old and new implementation in parallel against the same generated inputs. Any divergence is a regression. Discard the old implementation only after the equivalence property is confirmed over a large input space.

4. **Invariants** — assertions that hold *regardless of the input*. Examples: total money in the system is conserved across any transfer; list length is the same after a `sort`; a sorted list is always ascending; a timestamp is always after the epoch; a cart total is always >= 0. Invariants are checked *after* any operation, not just after specific operations.

5. **Oracle** — `fast_impl(x) == slow_but_correct_impl(x)`. When you have a reference implementation (the old code, a brute-force algorithm, a third-party library), use it as an oracle. The property generates inputs and asserts the two implementations agree. Useful for optimisation — prove the fast path matches the slow path before removing the slow path.

6. **Commutativity** — `f(a, b) == f(b, a)`. Applies to merges, set operations, commutative arithmetic, concurrent writes where order shouldn't matter. A failing commutativity property surfaces ordering bugs.

7. **Associativity** — `f(f(a, b), c) == f(a, f(b, c))`. Applies to reducers, fold operations, combinators. A failing associativity property surfaces hidden state that shouldn't exist.

### Bach & Bolton's HTSM fit

Properties shine across two HTSM dimensions that example tests routinely miss:

- **Data** — properties exercise ranges, boundaries, nulls, empty collections, large inputs, special characters, RTL strings. Generators are systematic where example authors are lazy.
- **Time** — ordering and commutativity properties expose concurrency and sequencing bugs that no single example can reproduce.

### Generators are specifications

The generator (the thing that produces inputs) is itself a specification of the input domain. A generator that produces `int | None` says "this function must handle None." A generator that produces only positive integers says "we're not specifying behaviour for negatives." Writing the generator forces the team to be explicit about scope.

### Shrinking is the diagnostic

Hughes' key insight: when a property fails, the library shrinks the counterexample to its minimal form — the smallest input that still breaks the property. The shrunk counterexample is usually a precise bug report. "Month 13 breaks the validator" is better than "random 47-character string containing UTF-8 codepage 0x2028 followed by month 73 breaks the validator."

### Properties are tests too

Beck: the test-first discipline applies to properties. Write the property before writing (or refactoring) the implementation. A property that passes on the first run without being exercised is not yet a test — either the generator is too narrow, or the assertion is vacuous, or the property doesn't exercise a real constraint.

## Application

### Step 1 — Name the properties before coding

Before opening a library, list the properties the function or module should satisfy. Ask:

- What should be *invariant* after any operation on this system?
- What transformations are *reversible*?
- What operations should be *safe to repeat*?
- Does this code replace an existing implementation I can *compare against*?
- Are there *ordering or combining* constraints (commutativity, associativity)?

Write them as sentences first. "The cart total is always ≥ 0 after any sequence of add/remove operations." That sentence is the property; the code expresses it.

### Step 2 — Choose the library

| Language | Library | Notes |
|---|---|---|
| Python | Hypothesis | `@given`, `st.` strategy namespace; stateful testing via `RuleBasedStateMachine` |
| TypeScript / JavaScript | fast-check | `fc.property`, `fc.assert`; `fc.record` for structured objects |
| Scala | ScalaCheck | `forAll`, `Gen`; integrates with ScalaTest and MUnit |
| Haskell | QuickCheck | origin; `prop_`, `Arbitrary` class |
| Haskell | Hedgehog | integrated shrinking; structured generators |
| Java / Kotlin | jqwik | `@Property`, `@ForAll` |

### Step 3 — Write the property spec template

```markdown
# Property spec — <module / function>

- **Author:** <tester name>
- **Date:** <YYYY-MM-DD>
- **Library:** <Hypothesis | fast-check | ScalaCheck | ...>
- **Linked work:** <PR, ticket, or refactor plan>

## Properties

### P1 — <property name> (<category>)

**Invariant:** <one sentence. "For any valid X, f(f(x)) == f(x).">

**Generator:** <what inputs are generated; what constraints apply; what is excluded>

**Assertion:** <what is checked against the generated input>

**Why it matters:** <what bug class does this catch that examples cannot?>

**Library expression:**

\`\`\`python
# (or TypeScript, Scala, etc.)
@given(st.text())
def test_normalise_is_idempotent(s):
    assert normalise(normalise(s)) == normalise(s)
\`\`\`

### P2 — ...
```

### Step 4 — Run, analyse, shrink

1. Run the suite. If a property fails immediately, the shrunk counterexample is usually the bug.
2. If the property passes on the first run, increase the number of examples (`max_examples=1000` in Hypothesis; `numRuns: 1000` in fast-check) and check for vacuous success — does the generator actually produce the boundary values you care about?
3. Use `assume()` (Hypothesis) or `fc.pre()` (fast-check) sparingly — every `assume` narrows the input space. If you're discarding >50% of generated inputs, rewrite the generator to be more precise.
4. For stateful systems (Hypothesis `RuleBasedStateMachine`; fast-check `fc.asyncModelRun`), define the model and its commands. The library explores command sequences, not just individual values.

### Step 5 — Document and commit the spec

The spec markdown lives alongside the test file. It explains the *why* behind each property — the same way an ADR explains an architecture decision. Without the spec, future engineers see a strange parameterised test and don't understand what it's guarding.

## Examples

### Example 1 — Round-trip property for a JSON codec (Python / Hypothesis)

**Context:** a team is refactoring their domain-model-to-JSON serialiser. They want to confirm the new serialiser is invertible before removing the old one.

**Property spec (markdown):**

```markdown
### P1 — Codec round-trip (round-trip)

**Invariant:** For any valid Order, deserialise(serialise(order)) == order.

**Generator:** Hypothesis composite strategy producing Order instances with:
  - id: UUID
  - amount: Decimal in range [0.01, 99999.99] with 2 dp
  - currency: sampled from ("USD", "EUR", "GBP", "JPY")
  - status: sampled from OrderStatus enum
  - items: list of 0..20 LineItem instances (sku: text, qty: int [1..100])

**Excluded from generator:** Decimal NaN, Infinity; currency codes not in the
  supported set; negative amounts (tested separately as invariant).

**Assertion:** deserialised object equals original under __eq__.

**Why it matters:** Any field that fails to survive the round-trip is a silent
  data-loss bug that examples may miss — especially optional or enum fields.
```

**Test (Python / Hypothesis):**

```python
from hypothesis import given, settings
from hypothesis import strategies as st
from decimal import Decimal
from myapp.orders import Order, LineItem, OrderStatus
from myapp.serialise import serialise_order, deserialise_order

order_strategy = st.builds(
    Order,
    id=st.uuids(),
    amount=st.decimals(min_value=Decimal("0.01"), max_value=Decimal("99999.99"),
                       places=2, allow_nan=False, allow_infinity=False),
    currency=st.sampled_from(["USD", "EUR", "GBP", "JPY"]),
    status=st.sampled_from(OrderStatus),
    items=st.lists(
        st.builds(LineItem,
                  sku=st.text(min_size=1, max_size=20),
                  qty=st.integers(min_value=1, max_value=100)),
        max_size=20,
    ),
)

@given(order_strategy)
@settings(max_examples=500)
def test_order_codec_round_trip(order):
    """
    P1: round-trip. Any Order survives serialise → deserialise unchanged.
    Protects against silent field loss in the new serialiser.
    """
    assert deserialise_order(serialise_order(order)) == order
```

When this property first runs, Hypothesis may surface a failing case immediately — for example, a `Decimal("10.10")` surviving as `10.1` (trailing zero stripped) if `__eq__` uses float comparison. The shrunk counterexample is the precise diagnosis.

### Example 2 — Idempotence property for a normalisation function (TypeScript / fast-check)

```typescript
import * as fc from "fast-check";
import { normaliseAddress } from "../src/address";

// P2 — Idempotence: normalising twice equals normalising once.
// Catches accidental state accumulation in normalise (e.g., double-trimming
// that corrupts multi-space Unicode values, or double-lowercasing
// that mishandles locale-sensitive casefold).
test("normaliseAddress is idempotent", () => {
  fc.assert(
    fc.property(fc.string({ minLength: 0, maxLength: 200 }), (addr) => {
      expect(normaliseAddress(normaliseAddress(addr))).toEqual(
        normaliseAddress(addr)
      );
    }),
    { numRuns: 1000 }
  );
});
```

### Example 3 — Equivalence property for a refactored sort (ScalaCheck)

```scala
import org.scalacheck.Prop.forAll
import org.scalacheck.Properties

object SortSpec extends Properties("Sort") {
  // P3 — Equivalence: new sort output matches stdlib sort for all inputs.
  // Discard the old sort only after this property is confirmed green.
  property("newSortEqualsStdlibSort") = forAll { (xs: List[Int]) =>
    NewSort.sort(xs) == xs.sorted
  }

  // P4 — Invariant: sorted list is always non-decreasing.
  property("sortedListIsNonDecreasing") = forAll { (xs: List[Int]) =>
    val sorted = NewSort.sort(xs)
    sorted.zip(sorted.tail).forall { case (a, b) => a <= b }
  }
}
```

## Common Pitfalls

### Pitfall 1 — Generator too narrow to find bugs

**Symptom:** Property has been green for months; a hand-written example test finds a bug the property "should have caught."

**Consequence:** The team concludes properties are not useful. The real cause is that the generator excluded the failure space.

**Fix:** Review the generator for `assume`/`pre` calls that narrow inputs. Check that boundary values (empty string, zero, `None`, maximum int) are reachable. Run with `max_examples=10000` periodically on CI; locally before shipping.

### Pitfall 2 — Vacuous assertion

**Symptom:** Property passes instantly and always. The test would pass even if the function under test were `return None`.

**Consequence:** False confidence. The property gives no signal.

**Fix:** Test the property against a known-broken implementation first (the "is this test falsifiable?" check). If it passes against the broken version, the assertion is too weak.

### Pitfall 3 — Asserting implementation, not invariant

**Symptom:** Property asserts internal call counts, specific intermediate state, or implementation-specific serialisation format.

**Consequence:** Property breaks on every refactor; team weakens it; the invariant is lost.

**Fix:** Properties should assert *observable outcomes* (the round-trip reconstructs the object; the sort is ordered) not *internal mechanism* (the sort used merge sort and called merge() 7 times).

### Pitfall 4 — Replacing example tests entirely

**Symptom:** Team deletes all example-based tests and replaces with properties, because "properties are more powerful."

**Consequence:** Business-readable acceptance scenarios disappear. Non-technical stakeholders can't read a property test; they can read a named example. Properties don't replace specification by example.

**Fix:** Properties and examples are complementary. Examples are business-readable specifications of named cases; properties are exhaustive checks of invariants. Keep both.

### Pitfall 5 — Stateful testing deferred indefinitely

**Symptom:** Properties cover pure functions; the stateful API (the cart service, the queue, the state machine) has no property coverage.

**Consequence:** The most dangerous bugs — invalid state transitions, interleaved-operation invariant violations — go undetected.

**Fix:** Hypothesis `RuleBasedStateMachine` or fast-check `fc.asyncModelRun` cover stateful systems. Start with one state machine per service with three to five commands; expand as the test infrastructure matures.

### Pitfall 6 — No spec document alongside the tests

**Symptom:** The test file contains properties; the *why* is undocumented. A future engineer sees `test_normalise_is_idempotent` and doesn't know why idempotence matters for this function.

**Consequence:** Properties get weakened or deleted when they fail, because reviewers don't understand what they're guarding.

**Fix:** A spec markdown (Step 3) accompanies the test file. Each property entry takes three minutes to write; it is permanent documentation of the invariant.

## References

- **John Hughes** — "QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs" (ICFP 2000); Quviq property-based testing research. The origin of the field. See `roles/tester/sources.md`.
- **Kent Beck** — *Test-Driven Development by Example* (2002); test-first discipline applies to properties: write the property before (or simultaneous with) the implementation. See `roles/tester/sources.md`.
- **James Bach & Michael Bolton** — Heuristic Test Strategy Model; the Data and Time HTSM dimensions are where property-based testing delivers most value. See `roles/tester/sources.md`.
- **Gojko Adzic** — *Specification by Example* (2011); properties are specifications-by-property, complementary to specifications-by-example. See `roles/tester/sources.md`.
- **Related Hornero skills:**
  - [`regression-test`](../regression-test/SKILL.md) — when a property finds a counterexample, that counterexample becomes a pinned regression test.
  - [`specification-by-example`](../specification-by-example/SKILL.md) — the complementary approach: named, business-readable scenarios versus exhaustive invariant checks.
  - [`test-plan`](../test-plan/SKILL.md) — the plan names which areas warrant property coverage and why.
  - [`test-distribution`](../test-distribution/SKILL.md) — property tests typically sit at the unit/integration boundary; the pyramid audit tracks them.
