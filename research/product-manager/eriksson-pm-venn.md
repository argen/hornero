# Martin Eriksson — distilled

> The PM Venn diagram (Tech / Business / UX) — Eriksson's model of the PM role, first articulated publicly around 2011, codified in *Product Leadership* (2017, with Richard Banfield and Nate Walkingshaw). The most-cited single-image definition of what a product manager actually does.

## Why it matters for AI-coding

AI tools can prompt engineers and can prompt marketers. What they cannot do is hold the three lenses simultaneously — technical feasibility, customer desirability, and business viability — and keep them in productive tension. The risk in AI-assisted product teams is that the PM collapses into one of three degraded modes: "the one who writes prompts for engineers," "the one who writes copy for marketers," or "the one who runs JIRA." Eriksson's Venn is the corrective: the PM role is defined by the *intersection*, and losing any one of the three lenses destroys the role.

In a team where AI generates features, writes code, and drafts copy at speed, the PM is the person whose job is to keep asking: does this serve the customer? can engineering actually maintain it? does it sustain the business? All three, simultaneously, with real evidence.

## Key concepts the role pulls from

- **The PM Venn.** Intersection of Technology, Business, and User Experience. The PM doesn't need to be the best engineer, designer, or analyst in the room — they need to hold the view across all three. Powers the role-scoping section of `cross-functional-orchestration` and the "integrator, not adjudicator" framing.
- **PM as integrator, not owner of any single function.** Eriksson is explicit: the PM is not the CEO of the product. They are the person accountable for the integrated view. The `cross-functional-orchestration` skill's "PM does not pretend to be a security oracle" language is Eriksson's framing made operational.
- **Product Leadership alignment.** *Product Leadership* (2017) extends the Venn to the organizational level: product leaders multiply good product work by building the conditions for integrated teams. The PM-as-coach stance in `cross-functional-orchestration`'s synthesis step reflects this.
- **The minimum role set.** Eriksson argues the PM's contribution to any cross-functional conversation is keeping it small enough to decide. Don't invite seven functions when three will do. The `cross-functional-orchestration` step on role selection inherits this directly.
- **Tech × Business × UX as a critique frame.** When reviewing a PRD, proposal, or roadmap item, a fast Eriksson-style check asks: which of the three lenses is underrepresented? If the answer is "UX," the designer hasn't been pulled in. If "Tech," engineering hasn't been asked whether it's buildable. This is the implicit triage behind the `prd` skill's role-mix recommendations.

## What to actually read (1-hour budget)

- The PM Venn diagram itself — it's public, reproduced in dozens of places, and survives as a stand-alone artifact. Five minutes. Start here.
- *Product Leadership* (2017) — **Part I** ("What is Product Leadership?" and "The PM Role") and **Part III** ("Building a Product Culture"). The Venn becomes organizational in Part III. ~60 pages total.
- If you want the community-context version: Eriksson's Mind the Product conference keynotes (2012–2016 especially) are on YouTube and complement the book with practitioner war stories.

## What to skip

- *Product Leadership*'s middle section on hiring and career ladders — it's valuable for a VP of Product building a team but tangential for an individual PM or an agent adopting the role.
- The sections on managing remote teams have been superseded by better operational literature (GitLab, Basecamp, etc.). Read the frameworks; skip the process suggestions.

## How this anchors role skills

- [`cross-functional-orchestration`](../../skills/cross-functional-orchestration/SKILL.md) — Eriksson is explicitly cited in the skill's Key Concepts ("PM as integrator, not adjudicator"); the Venn is the implicit structure behind the role-mix triage step.
- [`prd`](../../skills/prd/SKILL.md) — the three-lens check (Tech feasibility, Business viability, UX desirability) maps to Cagan's four big risks; Eriksson's Venn is the faster heuristic for spotting which lens is missing.
- General role-clarification: when someone asks "what does a PM do?" the Eriksson Venn is the one-image answer. The methodology treats it as foundational, not as a simplification.

## Cross-role connection

The PM Venn maps onto the multi-role-review skill's role composition logic. Tech → engineer reviewer. UX → designer reviewer. Business → PM + marketing reviewer. A `multi-role-review` that includes all three covers the Venn; one that drops a leg loses the integration. Eriksson's model is, in this reading, a justification for why the multi-role-review pattern exists at all.
