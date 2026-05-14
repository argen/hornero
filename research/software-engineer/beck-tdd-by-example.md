# Kent Beck — distilled

> *Test-Driven Development by Example* (2002), with sidelong reference to *Extreme Programming Explained* (1999, rev. 2004) and *Tidy First?* (2023).

## Why it matters for AI-coding

Beck's TDD discipline (Red → Green → Refactor) is the load-bearing safety net for any AI-generated code change. The agent generates plausible-looking code; without a failing test driving it, plausible is often what you get instead of correct. The discipline forces the agent to (a) state the expected behaviour as a test before writing implementation and (b) earn each green by writing the minimum code that satisfies the test.

Beck's separate contribution in *Tidy First?* — the framing of "tidyings" as small, behaviour-preserving structural moves that ship independently of feature work — gives the methodology its vocabulary for in-flight refactoring during a session. Untidy code can be left untidy *if* the team chooses; the methodology resists the silent drift of "while-I-was-here" refactors mixed into feature PRs.

## Key concepts the role pulls from

- **Red / Green / Refactor.** The three-phase loop. Each phase has one job; collapsing them defeats the discipline. Powers the `tdd-discipline` skill.
- **"Make it work, make it right, make it fast."** Sequence matters. Pursuing performance during the Green phase is premature; pursuing aesthetics during Red is procrastination.
- **The triangulation pattern.** Multiple tests force the implementation to generalise. A single test invites the "return the literal expected value" anti-fix.
- **Fake-it-till-you-make-it.** Start with a hardcoded constant return; let subsequent tests force generalisation. Reduces the mental load of the first Green.
- **Tidyings (from *Tidy First?*).** Small, ≤20-minute structural improvements that don't change behaviour. Land in their own commit, not bundled with features.
- **XP practices (from *XP Explained*).** Pair programming, continuous integration, collective ownership, simple design. Modern industry still draws from this set; the methodology's "harness compounds" view inherits from XP's continuous-improvement framing.

## What to actually read (1-hour budget)

- *TDD by Example*, **Part I — The Money Example** (chapters 1-17, ~80 pages). The full TDD loop walked over a single multi-currency example. The most-replicable demonstration of the discipline in book form.
- If you have a second hour: *Tidy First?* (short, ~100 pages). The vocabulary of tidyings — "Cohesion order," "Move declaration and initialization together," "Extract Helper" — gives names to the small moves you already make.

## What to skip

- *TDD by Example* Part II (the xUnit framework example) — has aged into a museum piece; modern test frameworks have absorbed the lessons.
- Most of *XP Explained*'s organisational claims about pair-programming-everywhere; the practices that survived are well-known; the prescriptive parts are dated.

## How this anchors role skills

- [`tdd-discipline`](../../roles/software-engineer/skills/tdd-discipline/SKILL.md) — the workflow IS Beck's Red/Green/Refactor with an AI-agent variant in Step 4. Direct quote of the discipline.
- [`refactor-plan`](../../roles/software-engineer/skills/refactor-plan/SKILL.md) — borrows *Tidy First?*'s tidying-vocabulary for the small-step plan section.
- [`tester` / `regression-test`](../../roles/tester/skills/regression-test/SKILL.md) — applies Red/Green specifically to bug fixes: the failing test reproduces the bug before any fix lands.
- General review heuristic: when the role critiques a diff with no tests, the citation is Beck.

## Cross-role connection

Beck appears in the tester role's bibliography as well, where the same TDD discipline anchors `regression-test`. The duplication is deliberate — these are shared canon between engineer and tester roles, the closest siblings in the methodology.
