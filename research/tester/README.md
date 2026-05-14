# Research — tester

Distilled notes from the tester role's anchor bibliography. See [`../../roles/tester/sources.md`](../../roles/tester/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the tester role on a non-trivial task and you've never read these, here's the priority order:

1. **[`bach-bolton-rst-htsm.md`](bach-bolton-rst-htsm.md)** — Rapid Software Testing methodology + the Heuristic Test Strategy Model; the strategic frame all the tester skills sit inside.
2. **[`hendrickson-explore-it.md`](hendrickson-explore-it.md)** — chartered, time-boxed, heuristic-guided exploration; the tour catalogue; powers `exploratory-charter`.
3. **Beck — TDD by Example** (note pending; also in software-engineer/) — the red-green-refactor loop; the foundational microcycle of test-first development. (Shared anchor with software-engineer role.)
4. **Cohn — Succeeding with Agile** (note pending) — the test pyramid (the most-cited and most-misapplied mental model for test distribution).
5. **Adzic — Specification by Example** (note pending) — tests as living documentation; example-driven specification.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| James Bach & Michael Bolton | ✓ [`bach-bolton-rst-htsm.md`](bach-bolton-rst-htsm.md) | `test-plan`, `exploratory-charter`, `pre-release-test-pass` |
| Elisabeth Hendrickson | ✓ [`hendrickson-explore-it.md`](hendrickson-explore-it.md) | `exploratory-charter`, `pre-release-test-pass`, `test-plan` |
| Lisa Crispin & Janet Gregory | — | test-strategy, `test-plan` |
| Cem Kaner | — | context-driven principles in `test-plan` |
| Gojko Adzic | — | specification-by-example |
| Kent Beck | — | `regression-test` (engineer-shared anchor) |
| Jez Humble & David Farley | — | CD discipline, pre-release-test-pass |
| John Hughes | — | property-based testing |
| Maaret Pyhäjärvi | — | exploratory-charter, ensemble testing |
| Mike Cohn | — | test-pyramid in `test-plan` critique |

## See also

- `../../roles/tester/sources.md` — the full bibliography these notes summarise.
- `../../roles/tester/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
