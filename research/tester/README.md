# Research — tester

Distilled notes from the tester role's anchor bibliography. See [`../../roles/tester/sources.md`](../../roles/tester/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the tester role on a non-trivial task and you've never read these, here's the priority order:

1. **[`bach-bolton-rst-htsm.md`](bach-bolton-rst-htsm.md)** — Rapid Software Testing methodology + the Heuristic Test Strategy Model; the strategic frame all the tester skills sit inside.
2. **[`hendrickson-explore-it.md`](hendrickson-explore-it.md)** — chartered, time-boxed, heuristic-guided exploration; the tour catalogue; powers `exploratory-charter`.
3. **[`beck-regression-test-tdd.md`](beck-regression-test-tdd.md)** — the red-green-refactor loop read from the tester's seat; tests as the harness for safe change; reproduce-before-fix discipline.
4. **[`cohn-test-pyramid.md`](cohn-test-pyramid.md)** — the test pyramid (the most-cited and most-misapplied mental model for test distribution); the ice-cream-cone anti-pattern; stated-reasoning requirement.
5. **[`adzic-specification-by-example.md`](adzic-specification-by-example.md)** — tests as living documentation; example-driven specification; tests that describe intent, not implementation.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| James Bach & Michael Bolton | ✓ [`bach-bolton-rst-htsm.md`](bach-bolton-rst-htsm.md) | `test-plan`, `exploratory-charter`, `pre-release-test-pass` |
| Elisabeth Hendrickson | ✓ [`hendrickson-explore-it.md`](hendrickson-explore-it.md) | `exploratory-charter`, `pre-release-test-pass`, `test-plan` |
| Lisa Crispin & Janet Gregory | ✓ [`crispin-gregory-agile-testing.md`](crispin-gregory-agile-testing.md) | `test-plan`, `pre-release-test-pass` |
| Cem Kaner | ✓ [`kaner-context-driven.md`](kaner-context-driven.md) | `test-plan`, `regression-test` |
| Gojko Adzic | ✓ [`adzic-specification-by-example.md`](adzic-specification-by-example.md) | `test-plan`, `regression-test` |
| Kent Beck | ✓ [`beck-regression-test-tdd.md`](beck-regression-test-tdd.md) | `regression-test`, `pre-release-test-pass` |
| Jez Humble & David Farley | ✓ [`humble-farley-continuous-delivery.md`](humble-farley-continuous-delivery.md) | `pre-release-test-pass`, `test-plan` |
| John Hughes | ✓ [`hughes-property-based-testing.md`](hughes-property-based-testing.md) | `regression-test`, `test-plan` |
| Maaret Pyhäjärvi | ✓ [`pyhajarvi-ensemble-testing.md`](pyhajarvi-ensemble-testing.md) | `exploratory-charter`, `pre-release-test-pass`, `regression-test` |
| Mike Cohn | ✓ [`cohn-test-pyramid.md`](cohn-test-pyramid.md) | `test-plan`, `pre-release-test-pass` |

## See also

- `../../roles/tester/sources.md` — the full bibliography these notes summarise.
- `../../roles/tester/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
