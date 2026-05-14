# Sandi Metz — distilled

> ["The Wrong Abstraction"](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) (2016 essay). Plus *Practical Object-Oriented Design in Ruby* (POODR, 2012) and *99 Bottles of OOP* (2018, with Katrina Owen) as the longer-form context.

## Why it matters for AI-coding

"Duplication is far cheaper than the wrong abstraction" is the single most-cited essay in this methodology's anti-pattern catalogue. The reason: AI-generated code tends to introduce premature abstraction (DRY everything, factor out helpers eagerly, generalise from one example) — exactly the failure mode Metz names.

The essay's core observation: **a wrong abstraction is much more expensive to remove than duplicate code is to live with**. New requirements arrive that don't fit the abstraction; people add parameters to "shoehorn" the new case in; the abstraction accumulates flag arguments and conditional behaviour; eventually it's both more complex *and* less general than just having three similar pieces of code would have been.

The fix is counter-intuitive: when faced with code that "smells DRY-violating," prefer duplication until the *true* abstraction shape is revealed by multiple actual instances. Three similar things, all of which need a particular change, can reveal an abstraction that one or two never could.

## Key concepts the role pulls from

- **"Prefer duplication over the wrong abstraction."** The headline thesis. AI agents need this constraint explicitly — their default reach is for the abstraction.
- **The cost asymmetry.** Wrong abstraction is expensive to remove (you have to unwind the shoehorn parameters, the conditional branches, the implicit contracts) — duplication is cheap to remove (delete it when the abstraction is clear).
- **Re-inlining is a legitimate move.** When you discover the abstraction is wrong, inlining the abstraction back into N copies is the right first move, not "incrementally fix the abstraction."
- **The Sandi Metz Rules (heuristics, not laws).** 100-line classes; 5-line methods; 4-argument methods. Useful as triage flags; pointless as bureaucracy.

## What to actually read (1-hour budget)

- **["The Wrong Abstraction"](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)** — the essay (~5 minutes). The whole argument is here.
- If you have more: POODR Chapter 6 on inheritance (where abstraction-pulled-too-soon shows up most explicitly).
- Even more: *99 Bottles of OOP* walks the "shameless green" → tidy refactor → real abstraction sequence on a single tiny problem, ~100 pages.

## What to skip

POODR's Ruby-specific chapters age okay but the language conventions are tangential to the lessons; if you don't read Ruby, skim. The lessons travel.

## How this anchors role skills

- [`refactor-plan`](../../roles/software-engineer/skills/refactor-plan/SKILL.md) — the "what NOT to refactor" section cites Metz; the methodology's preference for "leave the duplication; refactor when the third instance arrives" is direct Metz.
- General review heuristic: when the role flags an AI-generated PR for premature abstraction, the citation is the Wrong Abstraction essay.
- [`rfc`](../../roles/software-engineer/skills/rfc/SKILL.md) — RFCs that propose a new framework / helper / abstraction get the "have we seen three instances of this need yet?" sanity check.

## Connection to Ousterhout

Metz's "wrong abstraction" and Ousterhout's "shallow modules" are siblings — both diagnose over-decomposition. Metz looks at it from the duplication-vs-abstraction tradeoff; Ousterhout from the interface-vs-implementation tradeoff. Same intuition, different starting points. When the methodology critiques over-decomposition, both citations are usually relevant.

## On the "Rules"

The Sandi Metz Rules (100-line class, 5-line method, 4-arg method) are useful *as triggers to look harder*, not as hard limits. The methodology does not enforce them mechanically; the role's review uses them to flag candidates for deeper look, not as auto-fail criteria.
