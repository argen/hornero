# Geoffrey Moore — distilled

> *Crossing the Chasm: Marketing and Selling Disruptive Products to Mainstream Customers* (1991, revised 2014). HarperBusiness. The adoption-lifecycle framework (Technology Adoption Lifecycle: Innovators → Early Adopters → Early Majority → Late Majority → Laggards) and the discontinuity between Early Adopters and Early Majority — the chasm — that kills most technology products. Also the source of the six-slot positioning statement template the Hornero `positioning-statement` skill is built on.

## Why it matters for AI-coding

AI marketing tools optimize for mainstream messaging. They're trained on a corpus of established-product copy, landing pages written for large audiences, and general-audience collateral. When applied to an early-stage or emerging-category product, they generate content pitched at the Early Majority — pragmatists who want references, integration stories, and low-switching-cost reassurance — rather than the Early Adopters who will actually buy the product first.

Moore's chasm framing is the reminder that the early-adopter-to-early-majority transition is not continuous. Different buyers, different risk tolerance, different buying criteria, different reference networks. An AI tool that generates a "most-users" message is actively harmful at the crossing point, because it speaks to the wrong audience at the wrong moment.

## Key concepts the role pulls from

- **The Technology Adoption Lifecycle.** Five segments: Innovators (enthusiasts, buy for the technology), Early Adopters (visionaries, buy for strategic advantage), Early Majority (pragmatists, buy for proven ROI), Late Majority (conservatives, buy when it's standard), Laggards (skeptics, buy when forced). Most technology products succeed with the first two and never cross to the third. The chasm is the gap between Early Adopters and Early Majority.
- **The chasm.** Early Adopters take risks; Early Majority requires references from other Early Majority members. The reference network doesn't exist yet when you're crossing — Early Adopters don't sell to pragmatists. This is the operational trap: a product loved by visionaries will not automatically sell to pragmatists. Different message, different channel, different proof points, different sales motion.
- **The bowling alley strategy.** Cross the chasm by targeting a single beachhead segment of the Early Majority — one vertical, one use case, one geography — and dominating it completely before expanding. The beachhead gives you the Early Majority references that the next segment requires. The `positioning-statement` skill's "for [who cares most]" slot operationalises this: be specific enough to name the beachhead, not broad enough to describe the eventual full market.
- **The whole product.** Early Majority pragmatists don't buy the core product; they buy the whole product — core product plus integrations, services, support, documentation, ecosystem partners. The "generic product" (what ships) vs. the "whole product" (what the customer actually needs to solve their problem) gap is why sales stall after the chasm crossing attempt. Used in `prd` when scope discussions ignore adjacent dependencies.
- **The positioning statement template.** Moore's six slots: For / Who / [Product] is a / That / Unlike / [Product]. The most widely used positioning template in tech product marketing. The `positioning-statement` skill builds directly on this structure, sharpened by Dunford's five-components-first methodology.

## What to actually read (1-hour budget)

- **Chapters 1-4** of the revised 2014 edition — the adoption lifecycle, the chasm definition, why Early Adopter success does not predict Early Majority success, and the whole-product argument. ~90 pages. This is the core of the book; everything else is application of these ideas.
- **Chapter 5** — the bowling-alley strategy and beachhead-market selection. The most actionable chapter for a PM planning a go-to-market sequence. 30 pages.
- The positioning template is in Chapter 7; it's eight lines. Read the chapter (~20 pages) for the rationale; the template itself is all you need operationally.

## What to skip

- The revised 2014 edition updates the examples from disk drives and PDAs to cloud software and mobile; the 1991 examples are dated but the framework is not. If you have the 1991 edition, the concepts are identical — just mentally substitute SaaS for enterprise software.
- Chapters 8-10 on the tornado and main-street phases (Late Majority + commoditization) are load-bearing for a platform or ecosystem product but less relevant for an individual PM at crossing-the-chasm stage.
- *Inside the Tornado* (Moore, 1995) extends the framework for post-chasm scaling; don't read it until the product has successfully crossed.

## How this anchors role skills

- [`positioning-statement`](../../skills/positioning-statement/SKILL.md) — Moore is the primary anchor for the template. The six-slot structure, the differentiation-test, and the "unlike [specific alternative]" discipline are Moore. Dunford sharpens the method; Moore provides the template.
- [`cross-functional-orchestration`](../../skills/cross-functional-orchestration/SKILL.md) — adoption-lifecycle framing informs the PM's framing step when the cross-functional question is a go-to-market decision. "Are we at the early-adopter or early-majority stage?" is a load-bearing question for picking the right message, channel, and success criteria.
- [`prd`](../../skills/prd/SKILL.md) — the whole-product concept surfaces in the PRD's scope and dependency sections. A PRD that ships the core product without considering the integrations and support the Early Majority requires is chasm-incompatible.

## Cross-role connection

Moore's bowling-alley strategy and the marketing-expert role's positioning-canvas skill are tightly coupled: the canvas defines who cares most and why (Dunford), and the bowling-alley selects the first beachhead segment (Moore). Together they produce a sequenced go-to-market plan: win the beachhead with precise positioning, generate Early Majority references, expand to adjacent segments. The PM's `cross-functional-orchestration` and the marketing-expert's `positioning-canvas` are the joint operators of this sequence.
