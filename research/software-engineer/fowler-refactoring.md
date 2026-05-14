# Martin Fowler — distilled

> *Refactoring: Improving the Design of Existing Code* (1999; 2nd ed. 2018) — primary work. Plus *Patterns of Enterprise Application Architecture* (2002) and the [martinfowler.com](https://martinfowler.com/) essay archive (strangler fig, branch by abstraction, feature toggles, lightweight ADRs).

## Why it matters for AI-coding

Fowler's catalogue is the shared vocabulary of safe code change. When the methodology says "extract method" or "introduce parameter object" in a refactor plan, both human and AI agents know exactly what's meant — because Fowler named the moves and stabilised the language across the industry. Without that shared vocabulary, every refactor description has to be re-invented in prose, which is slow and ambiguous.

Beyond the catalogue, Fowler's essay-length writing on evolutionary architecture (strangler fig, branch by abstraction, feature toggles) is the methodology's source for "how do we change running systems safely?" The answer is almost never "rewrite"; it's almost always a Fowler-named pattern that lets the system change in increments while staying live.

## Key concepts the role pulls from

- **The refactoring catalogue.** ~70 named moves with mechanics + motivation + example. The mechanical steps for each (e.g., Extract Method's six-step recipe) are what makes them safe under refactoring. Powers `refactor-plan`'s "sequence" section.
- **"Refactoring is behaviour-preserving."** The defining constraint. Tests must stay green throughout. Mixed-mode commits (refactor + behaviour change) violate this and are explicitly discouraged.
- **The strangler fig pattern.** Build the new system alongside the old; route traffic gradually; retire the old once new is proven. The default for non-trivial system replacements.
- **Branch by abstraction.** When strangler-fig isn't the right shape, introduce an internal abstraction, evolve the implementation behind it, retire the old implementation. Same pattern, shorter timeframe.
- **Feature toggles / feature flags.** Decouple deploy from release; small commits can ship without exposing user-visible change. Underpins the methodology's "small, reversible steps" preference.
- **Lightweight ADRs (essay).** "Documenting Architecture Decisions" (Nygard's original) endorsed and expanded; the format the engineer's `adr` skill ports directly.
- **"Is high quality software worth the cost?"** Argues quality reduces *cost* of change, not just risk — the framing the methodology uses when defending tests and refactoring against schedule pressure.

## What to actually read (1-hour budget)

- *Refactoring* (2nd ed.), **Chapters 1-3** (~80 pages). Chapter 1 walks a single example end-to-end (the videotape rental kata, JavaScript in 2nd edition). Chapter 2 defines refactoring and the principles. Chapter 3 — "Bad Smells in Code" — is the diagnostic catalogue.
- Skim the catalogue (Chapters 6-12). You're not reading it; you're learning where to look up "extract method" or "move function" when you need it.
- One essay: ["Strangler Fig Application"](https://martinfowler.com/bliki/StranglerFigApplication.html) (~10 minutes).

## What to skip

- *Patterns of Enterprise Application Architecture* — historically important but most of the patterns are now framework defaults (Object-Relational Mapping, MVC, etc.). Read PoEAA only if you're designing something that doesn't have a framework default.
- *Refactoring* 1st edition — Java/Smalltalk-flavoured; the 2nd edition (JavaScript) is more readable and the catalogue is unchanged.

## How this anchors role skills

- [`refactor-plan`](../../roles/software-engineer/skills/refactor-plan/SKILL.md) — uses Fowler's catalogue vocabulary directly; the "sequence" section is a series of named refactorings.
- [`adr`](../../roles/software-engineer/skills/adr/SKILL.md) — Fowler's endorsement of Nygard's lightweight ADR format is one of the citation chains.
- [`rfc`](../../roles/software-engineer/skills/rfc/SKILL.md) — when an RFC proposes a non-trivial system change, the engineer-mode review heuristic asks "could this be a strangler-fig instead?" — direct Fowler.
- General review heuristic: when the role critiques a "rewrite" proposal, the counter is Fowler — almost always there's a smaller, evolutionary path.

## Cross-role connection

Fowler's strangler-fig and branch-by-abstraction patterns also show up in the tester's `pre-release-test-pass` workflow when assessing migration risk. Same vocabulary, applied from the testing side.
