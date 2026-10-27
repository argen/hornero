# Clayton Christensen — distilled

> *The Innovator's Dilemma* (1997); *Competing Against Luck: The Story of Innovation and Customer Choice* (2016, with Taddy Hall, Karen Dillon, David Duncan). Harvard Business School. Two bodies of work: disruption theory (the mechanism by which incumbents lose markets to entrants) and Jobs-to-be-Done theory (the mechanism by which customers choose products). Together they define the competitive-strategy vocabulary the product-manager role operates in.

## Why it matters for AI-coding

AI generates features. It can produce a roadmap of plausible-sounding improvements for any product in minutes. What it cannot do is ask the right prior question: what job is the customer hiring this product for? Without a JTBD anchor, AI-generated features are optimizations on a product the customer may be replacing — or comparisons against competitors the customer doesn't actually consider alternatives.

Christensen's disruption theory adds a further warning: AI tools may be generating features that sustain current architecture against the wrong threat. Disruptors don't compete on the same dimensions incumbents optimize. A PM who hasn't absorbed the disruption argument will use AI to optimize their product into a corner.

## Key concepts the role pulls from

- **Jobs-to-be-Done.** Customers don't "buy products"; they "hire products" to make progress on a job in their lives. The job is durable — it predates and will outlast your product. Designing for the job (rather than for the product) produces strategies that survive technology shifts. The Hornero `jobs-to-be-done` skill is built entirely on this: three job dimensions (functional, emotional, social), four forces of switching, broad competitive alternatives. This is the primary cite for that skill.
- **Competitive alternatives — broad, not narrow.** Christensen's milkshake research (the McDonald's breakfast milkshake hired for a commute job, not a dessert job) demonstrates that the real competitive alternative is often not another product in the same category. Competitive alternatives include manual approaches, adjacent tools used informally, doing nothing, and solutions that don't look like products at all. The `jobs-to-be-done` skill's Step 2 and the `positioning-statement` skill's "unlike" slot both require this broadening.
- **Disruption theory.** Disruptors enter at the low end (or in non-consumption) with products that are "good enough" for the job, then improve along a different performance trajectory until they overshoot the incumbent's value proposition. The incumbent is trapped because its best customers — the ones who provide the most revenue and the most product feedback — are precisely the ones who need more of what the disruptor is systematically ignoring. Used in competitive analysis: a product optimized for its most demanding users is structurally vulnerable to an entrant optimized for a different job.
- **The three job dimensions.** Functional, emotional, social. A product that only serves the functional job is priced on the commoditizing dimension; emotional and social jobs are where switching costs and brand loyalty live. The `jobs-to-be-done` skill's Common Pitfall 2 ("only functional dimension") is Christensen's observation made operational.
- **The integrative question.** "What job is the customer hiring this product for?" is Christensen's diagnostic question — the one that reframes competitive analysis, feature prioritization, positioning, and pricing in a single move. Its power is in the scope of the reframe: the same question re-anchors every downstream product decision.

## What to actually read (1-hour budget)

- *Competing Against Luck* — **Chapters 1-4** (the JTBD theory, the milkshake story, the three job dimensions, the four forces). ~80 pages. This is the more immediately operational of the two books for a practicing PM.
- *The Innovator's Dilemma* — **Chapters 1-3** (the disruption mechanism; why incumbents rationally ignore the threat). ~60 pages. The foundational argument. If time-constrained, read the HBR article "Disruptive Technologies: Catching the Wave" (Bower and Christensen, 1995) — 20 pages, same core argument.
- The Christensen Institute has accessible primers on both theories online. Good for a first encounter; not a substitute for either book.

## What to skip

- *Competing Against Luck*'s later chapters on organizational implementation of JTBD research (chapters 7-10) are valuable for a CPO or Head of Research building a systematic program; for an individual PM, the framework from chapters 1-4 is sufficient.
- *The Innovator's Dilemma*'s detailed disk-drive industry analysis (chapters 1-2 deep dive) is the evidence base for the theory; if you trust the theory, the worked examples in chapter 1's summary are sufficient.
- *How Will You Measure Your Life?* (Christensen's personal/career book) is not load-bearing for the product-manager role.

## How this anchors role skills

- [`jobs-to-be-done`](../../skills/jobs-to-be-done/SKILL.md) — Christensen is the primary anchor. Every section of the skill — the JTBD statement template, the three job dimensions, the four forces, the broad-alternatives requirement, the three tests — is Christensen (with Bob Moesta providing the switch-interview technique).
- [`positioning-statement`](../../skills/positioning-statement/SKILL.md) — the "unlike [primary competitive alternative]" slot in Moore's template is populated from the JTBD's broad-alternatives analysis. Christensen's milkshake research is the example of why the alternative is broader than "other products in the category."
- [`cross-functional-orchestration`](../../skills/cross-functional-orchestration/SKILL.md) — Step 1 (frame the question as a customer job) uses JTBD vocabulary: the PM restates the cross-functional ask in terms of the job the customer is hiring the product for before dispatching any role reviewer.

## Cross-role connection

Christensen's disruption theory and the marketing-expert role's positioning-canvas skill share a structural assumption: the relevant competitive frame is defined by the customer's job, not by the industry classification. A positioning canvas that maps against "direct competitors" is Christensen-non-compliant; one that asks "what does the customer use instead, broadly?" is JTBD-aligned. The marketing role's `positioning-canvas` and the PM role's `jobs-to-be-done` are designed to feed each other.
