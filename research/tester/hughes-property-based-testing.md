# John Hughes — distilled

> "QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs" (Hughes & Claessen, ICFP 2000). Chalmers University / Quviq. Property-based testing is now widely adopted: Hypothesis (Python), fast-check (TypeScript), ScalaCheck, PropEr (Erlang), and many others.

## Why it matters for AI-coding

AI-generated tests are example-based by construction: the model generates specific input/output pairs that it believes are representative. This is precisely the class of test that property-based testing was designed to complement — and, in many cases, to expose as insufficient.

A test suite that AI generates might cover `month=1`, `month=6`, and `month=12`. It will miss `month=13` and `month=0` unless someone specifically asked for it. Property-based testing inverts the direction: instead of "here are the examples I thought of," it says "here is the rule that must hold for all inputs in this domain" — and then generates thousands of examples, including ones no human would have thought of.

For AI-assisted teams, this is a structural gap. The AI will generate confident-looking coverage from a handful of examples; property-based tests will find the edge the AI's training distribution didn't include.

## Key concepts the role pulls from

- **Property vs example.** An example test asserts `f(2, 3) == 5`. A property test asserts `for all a, b in ℤ: f(a, b) == f(b, a)` (commutativity) and generates thousands of `(a, b)` pairs to check it. The property is the rule; the framework finds the counterexample. Powers `regression-test`'s triangulation rationale — when the rule can be stated as a property, a property test is a stronger guard than any parametrised example set.
- **Shrinking.** When QuickCheck finds a failing case, it automatically shrinks the input to the smallest counterexample that still fails. A test that finds a failure on `month=13047` and automatically shrinks it to `month=13` is operationally more useful than a raw-failure random input. Shrinking is what makes property-based testing practical rather than just probabilistic.
- **Oracle properties.** The common property shapes that apply across problem domains: idempotence (`f(f(x)) == f(x)`), round-trip (`decode(encode(x)) == x`), commutativity, associativity, monotonicity, invariant preservation under operations. These are the vocabulary the tester uses when converting a specification into properties. Powers `test-plan`'s data-dimension coverage — many data-handling bugs are oracle-property violations.
- **Stateful property testing.** Hughes's later work (Quviq) extended QuickCheck to stateful systems: generate sequences of operations and verify that system invariants hold throughout. This is the class of test that catches race conditions, concurrent-state bugs, and ordering-dependent failures — the "Time" dimension of the HTSM that example-based tests almost never cover.
- **Model-based testing.** The approach of specifying a simpler reference implementation (the "model") and checking that the real implementation agrees with it on all generated inputs. For refactors and re-platformings, the model is the previous implementation — property tests confirm the new one matches.

## What to actually read (1-hour budget)

- **The original QuickCheck paper** — 12 pages, freely available. Read for the conceptual argument (why properties catch more than examples) and the shrinking mechanism. The Haskell is readable even if you don't know the language.
- **Hypothesis documentation** (for Python teams) or **fast-check** (for TypeScript) — the "Why property-based testing?" introductory sections in each library's docs are 15-minute reads that land the concept in a familiar context.
- **Hughes' Strange Loop 2019 talk "How to Specify It"** — 45 minutes, available on YouTube. The clearest practitioner treatment of the five oracle-property patterns.

## What to skip

- Deep academic extensions of QuickCheck (coverage-guided generation, formal-proof integration) — important for researchers; tangential for the methodology's practical scope.
- Early Haskell-specific API details in the paper — the concepts transfer; the Haskell syntax is now superseded by the 20+ years of language-specific implementations.

## How this anchors role skills

- [`regression-test`](../../roles/tester/skills/regression-test/SKILL.md) — property tests are the strongest form of the triangulation pattern; when a bug is a violation of an oracle property (idempotence, round-trip, range), the companion to the reproducing example-test is a property test over the rule.
- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — the Data dimension of the HTSM coverage table should include property tests for data-transformation invariants; the Time dimension's concurrency row maps naturally to stateful property testing.

## Cross-role connection

Property-based testing's use of random generation with coverage goals is the engineer's analogue of the data-scientist's randomized experiment design: both replace "the examples I thought of" with "a principled sample from the space of possible inputs/subjects." Both disciplines exist precisely because human intuition about representative examples is systematically biased. The data-scientist's concern about confounders in observational studies parallels the property-tester's concern about the coverage of the example set — each is asking "what am I missing because I only see what I chose to look at?"
