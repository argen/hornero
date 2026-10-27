---
name: competitive-teardown
description: Use when a PM needs to convert "we should look at competitor X" into a defensible position on what to build, refuse to build, and watch — structured analysis of a competitor's product, positioning, packaging, switching costs, and observable strategy.
role: product-manager
intent: |
  Produces a structured competitive teardown: product surface map,
  segment classification (Moore), disruption classification (Christensen),
  JTBD comparison, switching-cost asymmetry, and — the load-bearing
  output — a Strategic Implications section in Rumelt's diagnosis shape.
  The PM owns the strategy framing; the marketing-expert's
  positioning-canvas owns the commercial / comms framing.
type: component
theme: strategy
best_for:
  - Converting a competitor raise or launch into a strategic decision
  - Feeding the strategy-kernel's diagnosis with external evidence
  - Stress-testing the bet-portfolio against a specific competitive posture
  - Briefing the marketing-expert before a positioning refresh
scenarios:
  - "A competitor just closed a $40M Series B and is expanding upmarket"
  - "Sales keeps losing to a specific competitor; PM needs to understand why"
  - "PM preparing the annual kernel refresh and wants external diagnosis input"
  - "New entrant targeting our core segment with a lower-priced tier"
estimated_time: 4-8 hours (first teardown); 1-2 hours (refresh on a prior teardown)
---

# Competitive teardown

> v0 draft. Grounded in Christensen's disruption and JTBD theory, Moore's adoption-curve
> segment model, Rumelt's diagnosis framing, Cagan's stance on competitive analysis as
> strategic input, and Cutler's systems framing for competitors. Editorial review recommended.

## Purpose

Produce a structured competitive teardown — the artifact a PM uses to convert "we should
look at competitor X" into a defensible position on what we do, refuse to do, and watch for.

**Cross-role boundary (load-bearing).** This skill and the marketing-expert's
`positioning-canvas` cover adjacent but distinct territory:

- **competitive-teardown (PM)** produces *strategic implications* — what to build, refuse
  to build, and watch. It feeds the strategy kernel's diagnosis (Rumelt) and the
  bet-portfolio's evidence weighting. The PM owns this framing.
- **positioning-canvas (marketing-expert)** produces *positioning copy* — how to talk
  against the competitor in narrative, copy, and channel. It feeds the launch brief and the
  positioning statement. The marketing-expert owns this framing.

The teardown ends with an explicit handoff note to the marketing-expert. Writing positioning
copy or launch claims is out of scope for this skill. Referencing the competitor's posture
to inform copy is the marketing-expert's job, using the teardown as input.

The teardown also differs from the PM's `positioning-statement` skill: the positioning
statement is an *internal* product-strategy artifact in Moore's template shape; the teardown
is a *research and analysis* artifact that feeds the positioning statement (and the kernel,
and the bets) with external evidence.

## Key Concepts

### Christensen's disruption lens

Christensen (*The Innovator's Dilemma*, 1997; *Competing Against Luck*, 2016): is this
competitor **disruptive** or **sustaining**?

- A **sustaining** competitor improves on dimensions existing customers value. Same game;
  response is direct — match, exceed, or out-segment.
- A **disruptive** competitor enters at the low end (or a non-consuming segment), worse on
  traditional metrics but with a different cost structure, business model, or job served.
  Direct competition at their price point destroys margin without addressing the segment
  they're winning.

Diagnostic: if they're worse on the attributes your customers care about but winning a
segment you're not serving, it's disruptive. PMs default to treating every competitor as
sustaining (feature comparisons, roadmap races) — often wrong when the entrant is
structurally disruptive.

### Moore's segment fit

Moore (*Crossing the Chasm*, 1991 rev. 2014) frames competition as segment-level, not
product-level. A competitor winning **innovators** / **early adopters** is not
automatically competing with a product winning **pragmatists** — same category, different
adoption-curve segments.

The strategic question is whether segments overlap *now* and whether they will as either
product matures. A disruptive entrant in the innovator segment is a pragmatist-segment
threat in 18-24 months if they cross the chasm.

### Rumelt's diagnosis input

Rumelt (*Good Strategy / Bad Strategy*, 2011): strategy begins with **diagnosis** — naming
the crux of the challenge. A teardown without implications that change the diagnosis is
reportage, not strategy.

Strategic Implications must answer: what does this competitor's posture **force us to
confront**? Rumelt's fluff diagnostic applies — "we should continue to differentiate"
changes no decision. Each implication must be actionable: build, refuse, or watch.

### JTBD-based comparison

Christensen and Moesta (*Competing Against Luck*, 2016): the right comparison unit is the
**job being hired for**, not the feature set.

- Different feature set, **same job**, same segment → most dangerous configuration.
- Similar feature set, **different job**, different segment → may be less threatening than
  feature overlap suggests.

Use the [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) vocabulary; anchor on existing
JTBD artifact if one exists.

### Switching costs — both directions

Asymmetry compounds advantage; teardowns routinely cover only one direction.

- **To the competitor (from us):** data migration, retraining, lock-in, integration
  rebuilds, switching anxiety.
- **From the competitor (to us or anyone):** same categories, shaped by their architecture
  and pricing model.

High exit friction (annual contracts, proprietary formats, deep integrations) compounds
installed-base advantage. Low exit friction relies on continuous re-winning — strategically
different.

### Cutler's systems framing

Cutler (Amplitude / The Beautiful Mess): competitors are **systems** (product + pricing +
GTM + support + ecosystem), not feature lists. A product-surface-only teardown misses
pricing-model asymmetry, GTM-motion reach, ecosystem lock-in, support moat. Resists Cagan's
feature-comparison trap — the integrations directory may be the real moat.

## Application

### Step 1 — Define scope

Before gathering evidence, name:

- **Which competitor.** One per teardown. Broad competitive landscapes belong in market
  research; a teardown is a deep read on one specific competitor.
- **Which segments.** Which of their segments (or yours) are in scope? A competitor may
  serve multiple segments; focus on the segments that overlap with your current or intended
  market.
- **Which job-being-hired.** Use the `jobs-to-be-done` skill vocabulary. What job does
  this teardown focus on? If unclear, Step 6 will surface it.
- **Time horizon.** What triggered this teardown — a funding round, a product launch, a
  sales pattern, an annual refresh? The trigger shapes urgency and depth.

### Step 2 — Gather public-facing evidence

Gather before analyzing. Evidence sources, in roughly descending freshness:

- **Product trial** — sign up (free tier or trial), go through the activation flow, note
  the first-session experience, and map the conversion funnel. What does the product push
  users toward? What job does the activation flow implicitly assume?
- **Pricing and packaging page** — screenshot and record: tier names, tier features,
  pricing structure (seat-based, usage-based, flat), minimum contract, annual discount,
  enterprise callouts.
- **Positioning copy** — homepage hero, tagline, case-study titles, the "for [who]" claim
  if explicit, the category they're claiming.
- **Customer reviews** — G2, Capterra, Trustpilot, Reddit threads. Read both positive and
  negative. Negatives surface switching-cost friction and job-fit gaps; positives surface
  what job the product is actually hired for.
- **Employee and public posts** — LinkedIn job posts (what roles they're hiring = GTM
  motion); founder posts (what narrative they're shaping); press releases and funding
  announcements (what they claim to investors about segment and positioning).
- **Integrations directory** — what tools do they integrate with? Integration depth signals
  ecosystem lock-in and target-buyer stack. A deep Salesforce integration signals
  enterprise-buyer targeting; a deep Shopify integration signals e-commerce SMB.

Mark each evidence item with its source and date. Teardowns age; evidence provenance matters.

### Step 3 — Map the product surface

Using trial and public evidence:

- **What's in each tier.** Table format: rows = feature / capability, columns = tier.
  Note what's behind paywalls and what's on the conversion funnel.
- **Activation flow.** From sign-up to first value moment: what are the steps? What does
  the product ask the user to do first? What job does the onboarding implicitly serve?
- **Conversion funnel shape.** Where does the product push users toward paid? Time-based
  trial, feature gate, seat limit, usage limit? This reveals the pricing theory.

### Step 4 — Map the competitor's positioning

- **Category claim** — what category do they say they're in? What category does their
  copy imply? Are these the same or different?
- **Target buyer** — who does their copy address? Is it a job title, a company size, a
  pain, a segment?
- **Magic gift / narrative shape** — what promised land do they offer? Raskin's narrative
  model: the "before" state (the problem), the "after" state (the promised land), and the
  thing that blocks the transition (which they claim to remove).
- **Competitive alternatives they name or imply** — who do they position against? A
  competitor's "unlike X" claim tells you their primary perceived threat and their
  intended segment.

### Step 5 — Classify by Moore and Christensen

With the product surface and positioning mapped:

**Moore segment classification:**
- Which adoption-curve segment does this competitor win? (Innovators / Early Adopters /
  Early Majority [Pragmatists] / Late Majority [Conservatives] / Laggards.)
- What evidence supports this? (Review language, pricing point, activation complexity,
  integration depth, support model.)
- Does their segment overlap with ours? Where on the adoption curve are we? Are we ahead,
  behind, or adjacent?

**Christensen disruption classification:**
- **Sustaining** — better on dimensions our customers already value, in the same segment.
- **Disruptive (low-end)** — worse on traditional metrics but cheaper / simpler /
  sufficient for a segment we're not fully serving.
- **Disruptive (new-market)** — creating a new market from non-consumption; the product
  does something previously done without a product (manual, offline, DIY).
- **Neither** — sometimes a competitor is a peer in a crowded market with no structural
  asymmetry. This is a valid classification; it implies a different kind of response.

Document the classification and the evidence that supports it. Disagreement about
classification is where strategic conversations should happen — surface it explicitly.

### Step 6 — JTBD comparison

Using `jobs-to-be-done` skill vocabulary:

- **What job is the competitor hired for?** Write a functional job statement anchored in
  their review evidence and activation flow: *When [situation], [buyer] wants to
  [motivation], so they can [outcome].*
- **What job are we hired for?** Use the existing JTBD artifact if one exists; draft one
  if not.
- **Do the jobs overlap?** Same job, different execution → direct competition. Same
  job, different segment sub-type → adjacent competition. Different jobs → possibly
  not competing at all, even if feature sets look similar.
- **Four forces of switching** (Moesta): for a buyer currently using the competitor,
  what is the Push (dissatisfaction with them), Pull (attraction to us), Anxiety (risk of
  switching to us), and Habit (inertia with them)? These four forces shape the acquisition
  strategy, not just the product strategy.

### Step 7 — Identify switching-cost asymmetries

For each direction:

- **Costs to switch to the competitor (from us):** data migration complexity, retraining
  burden, integration rebuilds, contractual lock-in, loss of historical data.
- **Costs to switch from the competitor (to us or anyone):** same categories, but shaped
  by their architecture and pricing model.

Classify each cost as **structural** (baked into their architecture or contract model —
hard to change) or **experiential** (friction that feels high but could be reduced with
a migration tool, a champion, or a compelling enough reason to switch).

Note the asymmetry: if their exit friction is higher than their entry friction, they
compound advantage over time. If ours is higher, so do we.

### Step 8 — Write the Strategic Implications section

This is the load-bearing output. Rumelt-shaped: each implication names something the
competitor's posture **forces us to confront** in our own diagnosis.

Format each implication as:

```
**Implication N — [Short label].**
[One paragraph: what the competitor's posture reveals about the competitive landscape
and what it means for our diagnosis.]
Recommendation: **Build** / **Refuse** / **Watch** — [Specific decision or
direction implied.]
```

Aim for 3-5 implications. An implication that restates "we should continue to
differentiate" is Rumelt's fluff — reject and rewrite. Each implication must change
or confirm a decision.

### Step 9 — Cross-reference the kernel and bet portfolio

- **Strategy kernel** — does this teardown change the diagnosis? Does the competitor's
  posture reveal a challenge that was previously understated or misclassified? If the
  kernel's diagnosis was "our primary challenge is feature depth," but the teardown shows
  the competitor is winning on distribution, the diagnosis may need revision.
- **Bet portfolio** — does the teardown change the evidence weighting on any active bet?
  If a bet is premised on a competitive assumption the teardown disproves, that bet's
  confidence rating should decrease. If the teardown confirms an assumption, the bet's
  confidence may increase.

### Step 10 — Marketing handoff note

End the teardown with an explicit handoff paragraph:

> **For the marketing-expert:** [2-4 sentences naming what this teardown surfaces that is
> relevant to positioning copy and the positioning canvas. Do not write the copy here.
> Name the relevant facts: competitor's category claim, their target-buyer framing, the
> job-overlap finding, the switching-cost asymmetry. The marketing-expert's
> positioning-canvas and positioning-statement skills consume these as inputs.]

## Examples

### Worked example: vertical SaaS bookkeeping teardown

**Scope.** Competitor: Ledgerly (fictional), a bookkeeping platform for e-commerce SMBs.
Trigger: Ledgerly closed a $30M Series B and announced a new "analytics" tier.
Segment focus: e-commerce SMBs ($1M-$10M GMV, 1-3 FTEs in finance).
Job focus: "close the books in 2 days."

The full walk-through (product surface map, positioning map, Moore and Christensen classification, JTBD comparison, switching-cost asymmetry, four strategic implications, and the marketing handoff note) is in [`examples.md`](examples.md).

## Common Pitfalls

### Pitfall 1 — Feature-list teardown with no strategic implications

**Symptom:** The teardown is a table of competitor capabilities vs ours. The "conclusions"
section says "we are competitive in most areas."

**Consequence:** No decision is changed. The teardown consumed 4 hours and produced no
strategy input (Cagan: feature comparison is not competitive analysis).

**Fix:** The Strategic Implications section is non-negotiable. If you can't write 3
implications that would change a build/refuse/watch decision, the teardown isn't finished.
Go back to the JTBD comparison and the Christensen classification — those are where
implications live.

### Pitfall 2 — Comparing on our jobs, not theirs

**Symptom:** The JTBD comparison asks "how do they perform on the job we're hired for"
rather than "what job are they actually hired for."

**Consequence:** The competitor appears to fail on your metrics, which produces false
confidence. A competitor hired for a different job will not look like a threat until they
shift segments — at which point it's late.

**Fix:** Start the JTBD comparison from their review evidence, not from your JTBD
artifact. Let their customers' words define the job first, then compare.

### Pitfall 3 — No segment classification

**Symptom:** The teardown treats the competitor as competing with all users in the
category, regardless of adoption curve position.

**Consequence:** Urgency is miscalibrated. A competitor winning innovators is not an
immediate pragmatist-segment threat; treating them as one wastes attention and roadmap
resources. Conversely, a competitor crossing the chasm into pragmatists is a more urgent
threat than their market share alone suggests.

**Fix:** Moore's segment classification is required. Name which adoption-curve segment
they win and whether that overlaps with yours now or will in 12-24 months.

### Pitfall 4 — Strategic implications that aren't implications

**Symptom:** Implication reads: "We should continue to invest in our core differentiators
and monitor the competitive landscape."

**Consequence:** No decision changes. Rumelt's fluff diagnostic: abstract restatement of
the obvious dressed in strategic language.

**Fix:** Each implication must contain a specific **Build / Refuse / Watch** tag and a
decision direction. If the implication doesn't change what the team builds next quarter,
it is filler. Reject and rewrite.

### Pitfall 5 — Static teardown that never updates

**Symptom:** The teardown is filed and referenced 18 months later as if current.

**Consequence:** Competitors change; teardowns rot. A teardown based on a competitor's
pre-Series B product is wrong after a Series B.

**Fix:** Date every evidence item. Note refresh triggers at the bottom of the teardown:
a funding round, a new product tier, a pricing change, an acquisition, a significant shift
in G2 review sentiment. Assign a review date — typically 6 months for active competitive
threats, 12 months for monitored-but-not-urgent competitors.

### Pitfall 6 — Crossing into marketing's lane

**Symptom:** The teardown includes recommended positioning copy, tagline alternatives, or
campaign angles against the competitor.

**Consequence:** PM is doing marketing's job with less context; the marketing-expert's
canvas and launch brief are undermined because the strategy framing is pre-empted.

**Fix:** The teardown produces strategic input; the marketing handoff note names what
marketing should pick up. Stop there. The marketing-expert's `positioning-canvas` consumes
the teardown and produces the commercial framing.

## References

- **Clayton Christensen** — *The Innovator's Dilemma* (1997, Harvard Business Review
  Press); *Competing Against Luck: The Story of Innovation and Customer Choice* (2016,
  with Taddy Hall, Karen Dillon, David Duncan). Disruption classification and JTBD
  theory. See `roles/product-manager/sources.md`.
- **Geoffrey Moore** — *Crossing the Chasm: Marketing and Selling Disruptive Products to
  Mainstream Customers* (1991, rev. 2014). Adoption-curve segment model and the
  pragmatist-segment question. See `roles/product-manager/sources.md`.
- **Richard Rumelt** — *Good Strategy / Bad Strategy: The Difference and Why It Matters*
  (2011). The diagnosis-forces-what-to-confront framing; fluff diagnostic for strategic
  implications. See `roles/product-manager/sources.md`.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017).
  Competitive analysis as strategic input, not feature comparison. See
  `roles/product-manager/sources.md`.
- **John Cutler** — Amplitude / The Beautiful Mess writing. Systems framing for
  "competitor as product + pricing + GTM + ecosystem." See
  `roles/product-manager/sources.md`.
- **Bob Moesta** — switch-interview methodology; four forces of switching (Push / Pull /
  Anxiety / Habit). Cited via `jobs-to-be-done` skill vocabulary.
- **Related Hornero skills:**
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the teardown's Strategic
    Implications section feeds the kernel's diagnosis. A teardown without a kernel
    reference is incomplete strategy work.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — the teardown changes the evidence
    weighting on active bets; cross-reference explicitly in Step 9.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — the JTBD comparison in Step 6
    uses this skill's vocabulary and templates. If a JTBD artifact already exists, use
    it as the anchor.
  - a future `marketing-expert` role's `positioning-canvas` skill —
    the cross-role partner for the commercial view. The teardown feeds the canvas; the
    canvas produces the positioning copy. PM owns strategy framing; marketing owns
    commercial framing.
  - [`positioning-statement`](../positioning-statement/SKILL.md) — the PM-side
    positioning artifact in Moore's template shape; the teardown's competitive evidence
    feeds the "unlike" slot.
