# John Ousterhout — distilled

> *A Philosophy of Software Design* (2018; 2nd ed. 2021). A Stanford CS 190 course in book form. Reads in an afternoon; argues with you for years.

## Why it matters for AI-coding

Ousterhout is the load-bearing counterpoint to *Clean Code* orthodoxy in this methodology. AI agents trained on the public corpus reach for "small functions, lots of them, one responsibility each" by default — which Ousterhout calls "shallow modules" and argues actively increases complexity, because the cost of understanding now spans many tiny interfaces.

The framing "complexity is the central cost" gives the methodology a single dimension along which to evaluate code-review findings: *does this change reduce or increase the cognitive load of the system?* That dimension is more useful than "is this DRY?" or "does this follow the Single Responsibility Principle?" because it forces concrete reasoning about who reads the code and at what altitude.

## Key concepts the role pulls from

- **Complexity is the central cost.** Other quality dimensions (testability, modifiability, etc.) follow from complexity reduction. The role's reviews score this dimension first.
- **Deep modules vs. shallow modules.** A module is "deep" if its interface is much simpler than its implementation. Shallow modules — small classes with small interfaces — *increase* system-wide complexity because the user has to understand many interfaces.
- **Define errors out of existence.** Where possible, make error conditions impossible by API design rather than handle them everywhere. Classic example: a substring operation that returns an empty string on out-of-range indices rather than throwing.
- **Comments should describe things that are not obvious from the code.** Anti to "self-documenting code"; *some* things need a comment because they're not in the code (invariants, why-not-the-other-thing, performance constraints, gotchas).
- **Strategic vs. tactical programming.** "I just want to get this to work" is tactical; it accumulates complexity. Strategic programming spends extra effort up front to keep the design clean — pays back over the life of the system.
- **The "obvious" check.** When reading code, can you tell what it does without thinking hard? If not, the code is unclear regardless of how short it is.

## What to actually read (1-hour budget)

The whole book is ~170 pages and reads at conversational pace. If you're truly time-constrained:

- **Chapter 4 — "Modules Should Be Deep"** (the central thesis).
- **Chapter 13 — "Comments Should Describe Things That Are Not Obvious from the Code"** (the anti to "comments are a smell").
- **Chapter 19 — "Software Trends"** — the chapter where Ousterhout argues with TDD, design patterns, agile, and Clean Code, all at once. Use it to know what *not* to dogmatise.

## What to skip

Nothing important to skip. The book is the right length for what it covers; chapters not listed above are still useful, just less load-bearing for the methodology.

## How this anchors role skills

- General review heuristic: when the role flags an over-abstracted PR as creating "many small interfaces with little behind them," the citation is Ousterhout.
- [`refactor-plan`](../../roles/software-engineer/skills/refactor-plan/SKILL.md) — the "before" section ("what complexity does this code currently impose?") is Ousterhout-flavoured.
- [`rfc`](../../roles/software-engineer/skills/rfc/SKILL.md) — RFCs that propose new abstractions get a sanity check: is the new module deep, or are we adding shallow modules?
- [`adr`](../../roles/software-engineer/skills/adr/SKILL.md) — when an ADR captures an "errors-out-of-existence" decision, the citation chain is Ousterhout.
- Anti-pattern detection: "premature abstraction" (Metz's Wrong Abstraction) and "shallow modules" (Ousterhout) are siblings — different vocabularies, same diagnosis.

## Cross-role connection

Ousterhout's "complexity is the central cost" framing also surfaces in the designer role's heuristics — Norman's "minimise cognitive load" is the user-side analogue. Different works, same intuition.
