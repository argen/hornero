# Research — software-engineer

Distilled notes from the software-engineer role's anchor bibliography. See [`../../roles/software-engineer/sources.md`](../../roles/software-engineer/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the software-engineer role on a non-trivial task and you've never read these, here's the priority order:

1. **[`beck-tdd-by-example.md`](beck-tdd-by-example.md)** — the discipline that defines `tdd-discipline` and `regression-test` (the tester's sibling).
2. **[`ousterhout-philosophy-of-software-design.md`](ousterhout-philosophy-of-software-design.md)** — the complexity-as-central-cost lens; antidote to clean-code orthodoxy.
3. **[`fowler-refactoring.md`](fowler-refactoring.md)** — the refactoring catalogue; powers `refactor-plan`.
4. **[`metz-wrong-abstraction.md`](metz-wrong-abstraction.md)** — single essay, foundational for resisting premature abstraction (a chronic AI-coding failure mode).
5. **[`google-sre-book.md`](google-sre-book.md)** — toil, SLOs, postmortems; the production-reality canon.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| Kent Beck | ✓ [`beck-tdd-by-example.md`](beck-tdd-by-example.md) | `tdd-discipline`, `refactor-plan`, tester's `regression-test` |
| Martin Fowler | ✓ [`fowler-refactoring.md`](fowler-refactoring.md) | `refactor-plan`, `rfc`, `adr` |
| John Ousterhout | ✓ [`ousterhout-philosophy-of-software-design.md`](ousterhout-philosophy-of-software-design.md) | `rfc`, `adr`, design discussions in reviews |
| Sandi Metz | ✓ [`metz-wrong-abstraction.md`](metz-wrong-abstraction.md) | `refactor-plan`, code-review |
| Google SRE | ✓ [`google-sre-book.md`](google-sre-book.md) | reliability discussions in reviews |
| Fred Brooks | — | estimation, scope-negotiation |
| Eric Evans | — | `rfc`, domain-modeling |
| Will Larson | — | `rfc`, engineering-strategy |
| Tanya Reilly | — | `rfc`, design-doc craft |
| Gergely Orosz | — | engineering-practice |

The 5 unstarted notes (Brooks, Evans, Larson, Reilly, Orosz) will follow when an active task requires the methodology to draw on them more heavily.

## See also

- `../../roles/software-engineer/sources.md` — the full bibliography these notes summarise.
- `../../roles/software-engineer/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
