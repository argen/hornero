---
name: positioning-statement
description: Use to draft or critique a positioning statement using Geoffrey Moore's template, sharpened by April Dunford's framing.
intent: |
  Produces a sharp, specific positioning statement. Surfaces fuzzy elements
  before they propagate into copy, sales decks, and product strategy. Bad
  positioning kills good products; this skill catches it early.
type: component
theme: positioning
best_for:
  - Defining or revising product positioning
  - Pre-launch alignment across product, marketing, sales
  - Diagnosing why "buyers don't get it" or sales cycles are stalling
  - Repositioning after a category shift or competitor move
scenarios:
  - "PM and marketing-expert aligning on positioning before launch"
  - "Reviewer diagnosing a positioning statement that's true of every competitor"
  - "Sharpening positioning when sales reports 'buyers think we're just another X'"
estimated_time: 45-90 minutes (collaborative draft); 5-10 minutes (critique)
---

# Positioning statement

> v0 draft. Combines Moore's template (canonical) with Dunford's sharpening method. Editorial review recommended.

## Purpose

Produce a positioning statement that is specific, differentiated, and useful as a decision-making reference for product, marketing, and sales. The skill exists because positioning is most teams' weakest artifact: a "for everyone, against no one" statement that fits every competitor in the category.

## Key Concepts

### Moore's template

Geoffrey Moore (*Crossing the Chasm*):

> **For** [target customer]
> **Who** [statement of need or opportunity]
> **The [product name]** is a [product category]
> **That** [statement of differentiated benefit]
> **Unlike** [primary competitive alternative]
> **Our product** [statement of primary differentiation]

Six slots. Each must be filled with specificity. A positioning statement where any slot is generic is a positioning statement that doesn't position.

### Dunford's sharpening

April Dunford (*Obviously Awesome*) extends Moore's template with five components that must be defined *before* the template is filled:

1. **Competitive alternatives** — what the customer would use instead. Broad: includes manual approaches, do-nothing, adjacent categories. Drives the "unlike" slot.
2. **Unique attributes** — what your product has/does that the alternatives don't. Specific, not vague.
3. **Value** — what those attributes enable for the customer. Translates attribute → outcome.
4. **Market category** — what frame of reference puts your product where buyers can find it.
5. **Who cares most** — the segment for whom the value is most acute. Drives the "for" slot.

Most positioning failures happen because teams skip these five and jump straight to filling the Moore template.

### The differentiation test

A positioning statement that survives this test is sharp:

> Replace your product's name with a competitor's name. Does the statement still read true?

If yes, the positioning is generic. If no, you have positioning.

## Application

### Step 1 — Define the five components (Dunford)

Before drafting the statement, walk through each component:

**Competitive alternatives.** What would the customer use instead of your product? Cast wide. Include:
- Direct competitors
- Adjacent-category tools used informally
- Manual approaches (spreadsheets, paper, email)
- Hiring people / consultants
- Doing nothing

**Unique attributes.** What your product has/does that the alternatives don't. Be specific. "User-friendly" is not an attribute; "completes the X workflow in 3 clicks vs Y's 12 clicks" is.

**Value.** For each attribute, what outcome does it enable? "3 clicks instead of 12" → "user can run this 4x more often without thinking about it" → "decisions get made on fresh data."

**Market category.** Frame of reference that puts the product in the buyer's mental shelf. Categories like "BI tool" or "design tool" are crowded; sometimes a sub-category ("BI tool for data engineers" / "design tool for marketing teams") or a new category ("revenue intelligence") is sharper. Don't invent categories nobody knows; do find the frame that makes you most-different.

**Who cares most.** The segment for whom the value is most acute. Specific: title, company stage, current pain. "B2B SaaS founders, Series A–B, no in-house data team" beats "businesses that want insights."

### Step 2 — Fill Moore's template

With the five components defined, the template fills almost mechanically:

```markdown
For [who-cares-most segment]
Who [the pain or opportunity the value addresses]
[Product] is a [market category]
That [unique value]
Unlike [primary competitive alternative]
[Product] [primary differentiation translated to the alternative's language]
```

### Step 3 — Apply the differentiation test

Swap your product's name with each named competitive alternative. For each swap, ask: does the statement still read true?

If yes for any swap, sharpen that line. The "unlike" and "that" lines are usually the culprits.

### Step 4 — Apply the "so what?" test

For each clause, ask: "so what — what does the reader do differently because of this?" If a clause can be deleted with no loss of decision-relevance, delete it.

### Step 5 — Use the positioning everywhere

The positioning statement is not a private document; it's the source for downstream artifacts:

- Homepage hero copy
- Sales-deck opening
- Onboarding's first message
- Sales objection-handling
- Press releases / launch narratives

If these artifacts contradict the positioning, either the artifacts are wrong (fix them) or the positioning is wrong (revise).

## Examples

### Example 1 — Generic (failure)

> For **businesses** who **want better insights**, **DataCo** is a **data platform** that **delivers AI-powered analytics**. Unlike **other tools**, **DataCo** is **easy to use and powerful**.

**Failures:**
- "Businesses" — no segment.
- "Better insights" — vague pain.
- "Data platform" — broad category.
- "AI-powered analytics" — every competitor claims this.
- "Other tools" — no specific alternative.
- "Easy to use and powerful" — said by every product, contradicts itself.

The differentiation test: replace "DataCo" with "Tableau," "Looker," "Power BI." The statement reads true for all. Generic.

### Example 2 — Sharp (good)

> For **B2B SaaS founders at Series A or B without an in-house data team**, who **need monthly board metrics from product + revenue data but spend half the month wrangling spreadsheets**, **Metricly** is a **board-metrics service**, **not a BI tool**: we **deliver the 12 board-relevant metrics each month as a finished narrative**, not a dashboard to interpret. Unlike **Tableau or Looker** (which assume you have a data engineer) or **outsourced analyst firms** (which take 6 weeks per change), **Metricly** **ships ready-to-paste board updates within 5 business days, including the why behind each number**.

The differentiation test: replace "Metricly" with Tableau / Looker. Doesn't read true (those don't deliver ready-to-paste narratives). Replace with an analyst firm. Doesn't read true (those don't ship in 5 days). Replace with a competitor in the "board-metrics service" category. If specific competitors exist, sharpen further.

This positioning is also doing strategic work: it explicitly *narrows* the audience (excluding companies with data teams) and explicitly *categorizes against* both BI tools and analyst firms. Some buyers will self-select out; that's the discipline.

## Common Pitfalls

### Pitfall 1 — Positioning for everyone

**Symptom:** "For businesses." "For teams." "For users."

**Consequence:** Speaks to no one specifically; no segment self-recognizes.

**Fix:** Dunford's "who cares most" — the segment for whom the value is most acute. Other segments are secondary, addressed later, or not at all.

### Pitfall 2 — Differentiation by adjective

**Symptom:** Differentiation is "easier," "faster," "more powerful," "more flexible."

**Consequence:** Every competitor claims the same adjectives; the differentiator differentiates nothing.

**Fix:** Replace adjectives with concrete attributes. "Easier" → "3 clicks vs 12." "Faster" → "5 business days vs 6 weeks." If you can't quantify, name a specific behavior that's different.

### Pitfall 3 — Generic competitive alternatives

**Symptom:** "Unlike other tools" / "unlike legacy approaches."

**Consequence:** The "unlike" slot does no work.

**Fix:** Name 1-2 specific alternatives. If the team is afraid of naming competitors by name in a public-facing artifact, the *internal* positioning statement still names them; public-facing copy can soften.

### Pitfall 4 — Category by aspiration

**Symptom:** Inventing a category nobody knows. "We're a category-creating revenue-intelligence-experience platform."

**Consequence:** Buyers can't find you; salespeople can't reference-sell.

**Fix:** Place yourself in a category buyers already shop in, then differentiate. New categories are occasionally the right move (Salesforce did it; HubSpot did it) but require sustained investment in category education.

### Pitfall 5 — Positioning that no one believes internally

**Symptom:** The positioning is sharp on paper; nobody on the team actually says it; sales reps use their own pitch.

**Consequence:** External positioning erodes; the team telegraphs incoherence.

**Fix:** Test internally before externally. If the sales team won't say it, either they don't believe it or the positioning is wrong. Address before launching.

## References

- **Geoffrey Moore** — *Crossing the Chasm*; the positioning template is from this book.
- **April Dunford** — *Obviously Awesome*; the five-components-first methodology.
- **Bob Moesta** — JTBD-driven understanding of the customer for the "who" slot.
- **Andy Raskin** — strategic narrative; positioning feeds the narrative's "promised land" beat.
- **Related Hornero skills:**
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD identifies the customer and the alternatives that feed positioning.
  - a future `marketing-expert` role's `positioning-canvas` skill — Dunford-style positioning canvas as a more detailed cousin.
  - a future `marketing-expert` role's `strategic-narrative` skill — uses positioning as input.
