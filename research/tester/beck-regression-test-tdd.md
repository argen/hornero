# Kent Beck — distilled (tester lens)

> *Test-Driven Development by Example* (2002), read from the tester's angle: tests as the harness for safe change, not as the red-green-refactor development microcycle. The engineer-side reading is at [`../../research/software-engineer/beck-tdd-by-example.md`](../software-engineer/beck-tdd-by-example.md); this note covers what the tester role draws from the same source.

## Why it matters for AI-coding

AI agents are unusually fast at generating code. The regression-test discipline — every bug fix ships with a failing-then-passing test — is the harness that makes that speed safe. Without it, AI-assisted codebases accumulate a quiet category of technical debt: bugs that were fixed once but never pinned, so they return when the AI (or any developer) touches the same surface again.

Beck's insight, from the tester's seat, is that a failing test is a better bug report than any prose description: it is unambiguous, it is executable, and it stays relevant after the prose description is forgotten. AI doesn't naturally do this — it fixes bugs without pinning them, because it has no stake in the next time the code changes. The discipline must be imposed; this note is where the tester role's `regression-test` skill grounds that imposition.

## Key concepts the role pulls from

- **Reproduce before fix.** The bug-fix variant of Beck's Red phase: before changing any production code, write a test that demonstrates the bug. This is mechanically the same as starting with a failing test, but the motivation is different — not design, but verification that the bug is understood well enough to define "fixed." Powers `regression-test`'s Step 1-2.
- **The test as commitment.** Beck frames a failing test as a promise: the implementation must eventually satisfy it. In the tester's reading, a regression test is a promise about a specific bug's not-coming-back. The test outlasts the conversation about the bug; it is the durable artifact of a fix.
- **Triangulation.** Beck introduces multiple tests to force an implementation to generalise. The tester applies this to regression: a single test for month=13 might be satisfied by a special-case fix; a triangulated set (month=0, month=13, month=99, month=-1) forces the range rule. This is the "companion parametrised test" pattern in `regression-test`'s examples.
- **Green means safe to change, not correct.** Beck's formulation: the suite green-lit means we're in a known state, not a provably correct state. For the tester, this disciplines the release-readiness recommendation: a green suite is necessary, not sufficient. "The pipeline went green" is not a `pre-release-test-pass`.
- **Tests as documentation of intent.** Beck's test names in Part I of *TDD by Example* read as specification: `testMultiplication`, `testEquality`, `testFrancMultiplication`. The tester role's insistence on bug-referencing test names (see `regression-test`) extends this into the bug-discipline context.

## What to actually read (1-hour budget)

- *TDD by Example* — Part I, chapters 1-6 only (about 30 pages). The first six Money Example chapters demonstrate the full reproduce-then-fix cycle in miniature: the failing test appears first, the minimum code follows, then the test suite is the guide for refactoring.
- The bug-fix variant is not explicitly developed in the book — apply the first-six-chapters discipline to the context "a bug report replaces the first failing test."
- The engineer-side note covers the full Part I if you have more time.

## What to skip

- Part II (building xUnit) — it is the engineer-side's reading; the tester's role is in *using* the framework, not building it.
- The "what is TDD good for" advocacy sections — you already know; you're here for the technique.

## How this anchors role skills

- [`regression-test`](../../roles/tester/skills/regression-test/SKILL.md) — the reproduce-before-fix rule is Beck's Red phase applied to bugs; the "pin the bug, then fix" two-step maps directly to Red→Green; the triangulation pattern powers the companion-parametrised-test recommendation.
- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — "green means safe to change, not correct" is the explicit framing behind the pass's "CI is necessary, not sufficient" principle.

## Cross-role connection

This note shares an author with the software-engineer role's [`beck-tdd-by-example.md`](../software-engineer/beck-tdd-by-example.md) — the same book, two readings. The engineer's reading emphasises the development microcycle (Red/Green/Refactor as a design tool). The tester's reading emphasises the regression-test discipline (failing test before fix, test as durable harness). When the two roles collaborate on a bug fix, the tester writes or reviews the regression test; the engineer runs it in the Red phase and makes it green; the two notes describe the same event from adjacent seats.

