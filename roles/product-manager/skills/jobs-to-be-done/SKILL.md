---
name: jobs-to-be-done
description: Use to articulate why a customer hires a product — the functional, emotional, and social job they're trying to get done. Anchored in Clayton Christensen's JTBD theory.
intent: |
  Produces a Jobs-to-be-Done statement that names the underlying job a
  customer hires the product for. Distinguishes the job (durable) from
  the solution (changeable). Surfaces competitive alternatives and the
  triggers/anxieties around the switch.
type: component
theme: discovery
best_for:
  - Framing a problem space before designing solutions
  - Competitive analysis that goes beyond feature-comparison
  - Strategy work asking "what business are we really in?"
  - Onboarding-flow design (the job is most-active during purchase/onboarding)
scenarios:
  - "PM defining the market for a new B2B compliance tool"
  - "Designer scoping the homepage hero around the customer's job"
  - "Marketing-expert positioning against a non-obvious competitive alternative"
estimated_time: 30-90 minutes (depending on whether discovery evidence exists)
---

# Jobs-to-be-Done statement

> v0 draft. Ported and re-authored from Clayton Christensen + Bob Moesta synthesis patterns. Editorial review recommended.

## Purpose

Produce a clear, evidence-anchored statement of the *job* a customer hires the product for. Goes beyond "users want feature X" to "users have a problem in their life, and they're hiring something — your product, a competitor, a spreadsheet, or do-nothing — to make progress on it."

Used as input to PRDs, positioning statements, and competitive analyses.

## Key Concepts

### The job, not the solution

Christensen (*Competing Against Luck*): customers don't "buy products"; they "hire products" to do jobs. The job is durable — it exists whether or not your product exists. The product is the changeable thing. Designing for the job survives technology shifts; designing for the product doesn't.

Classic example: customers hire McDonald's milkshakes (Christensen's research) to (a) make the morning commute less boring, and (b) keep them full until lunch. The job has nothing to do with milkshakes specifically. Competitive alternatives: bagels, bananas, coffee, music podcasts, doing nothing.

### Three dimensions of any job

- **Functional** — what the customer is trying to accomplish, mechanically.
- **Emotional** — how they want to feel (or avoid feeling) while doing it.
- **Social** — how they want to be seen (or avoid being seen) by others.

Skipping the emotional and social dimensions is the most common JTBD failure.

### The four forces of switching (Moesta)

When customers switch from one solution to another:

- **Push** of the current situation (what's making them dissatisfied)
- **Pull** of the new solution (what's attractive about it)
- **Anxiety** about the new (what could go wrong)
- **Habit** with the current (inertia)

A new solution wins when Push + Pull > Anxiety + Habit. JTBD interviews surface all four.

### Competitive alternatives — broad, not narrow

Competitors include anything the customer might hire for the same job. For a calendar app: other calendar apps, but also paper notebooks, Apple's built-in calendar, asking-an-assistant, just-remembering, calendar-anxiety-itself (some users intentionally don't keep one).

Defining competitors narrowly (only "other calendar apps") misses the real competitive landscape.

## Application

### Step 1 — Identify the customer and the switch moment

Pick a real customer or segment. Identify the moment they switched to your product (or tried to). The interview / analysis centers on that moment.

If no real customer exists yet (early-stage product), pick a target persona and a hypothesized switch moment. Mark the JTBD as "hypothesized" rather than "evidence-anchored."

### Step 2 — Gather evidence

For evidence-anchored JTBD:

- **Switch interviews** (Moesta methodology) — talk to 5-10 customers who switched, ideally recently. Ask about the timeline of the switch: when did dissatisfaction begin? what triggered the search? what was considered? why this product specifically?
- **Review mining** — Wiebe's voice-of-customer technique. Read product reviews, support tickets, sales-call transcripts. Look for "I switched from X because..." or "I was using X but..."
- **Analytics signals** — first-action data; what users do in the first session correlates with what job they're hiring the product for.

### Step 3 — Draft the JTBD statement

Use this template:

```markdown
# JTBD — <product / segment>

**Customer.** <Specific. Title, life stage, current situation.>

**Job.**
- **Functional.** When <situation>, I want to <motivation>, so I can
  <outcome>.
- **Emotional.** I want to feel <feeling> (and/or avoid feeling
  <other feeling>).
- **Social.** I want to be seen as <perception> by <audience>.

**Switch context.**
- **Push.** <What in the current situation is making them dissatisfied.>
- **Pull.** <What about a different solution is attractive.>
- **Anxiety.** <What could go wrong if they switch.>
- **Habit.** <What's keeping them with the current solution.>

**Competitive alternatives.**
<Broad list. Other products, manual approaches, do-nothing,
hire-someone, etc.>

**Evidence.**
<Number of interviews; review-mining sources; analytics signals.
For hypothesized JTBD, mark as such.>
```

### Step 4 — Test the JTBD against challenges

Three tests:

1. **Does the job exist without your product?** If yes, you've named a real job. If no, you've named a feature.
2. **Could the same job describe a wildly different solution?** Christensen's milkshake job could be served by bagels. If your job is so specific only your product satisfies it, the job is over-narrow.
3. **Does naming the job change a design or business decision?** If the JTBD statement, taken seriously, would change something downstream (positioning, onboarding flow, pricing tier), it's a useful job. If it changes nothing, it's a vanity exercise.

### Step 5 — Use it

The JTBD becomes input to:

- PRDs (informs the Problem section)
- Positioning statements (the "for [target] who [need]" is the customer with the job)
- Onboarding design (the first session should make progress on the job, fast)
- Competitive analyses (the alternatives column comes from the JTBD)
- Marketing messaging (lead with the outcome the job aims at, not the feature)

## Examples

### Example 1 — Good JTBD for a B2B contract-review tool

**Customer.** Mid-senior in-house counsel at a Series B–D SaaS company; reviews 15-30 contracts per week, mostly customer agreements and vendor MSAs.

**Functional.** When I receive a customer agreement to review, I want to identify deviations from our standard terms and the business risk those deviations carry, so I can either approve fast or flag the specific issues for negotiation.

**Emotional.** I want to feel competent and unblocked; I want to avoid feeling like the bottleneck the sales team complains about.

**Social.** I want to be seen by the sales team as a partner who unblocks deals, and by the CFO as a careful guardian of risk.

**Push.** Manual redlining in Word; comparing the inbound contract clause-by-clause against the playbook in my head takes 2-4 hours per agreement; sales team escalates anything sitting >24 hours.

**Pull.** A tool that highlights deviations against a stored playbook would cut the comparison work to 15-30 minutes; my sales partners stop escalating.

**Anxiety.** What if the tool misses a critical deviation? My professional liability is real.

**Habit.** Word is the universal contract-editing tool; switching tools means clients/counterparts need to receive output back in Word.

**Competitive alternatives.** Manual review (current); junior counsel review with senior signoff (some companies); Ironclad / LinkSquares / Spotdraft (CLM tools); not-reviewing-customer-paper-at-all (some startups' approach).

**Evidence.** 8 switch interviews; 30 reviews mined from G2; analytics from beta program (first-session behavior).

### Example 2 — Bad JTBD (failure)

**Customer.** Knowledge workers.

**Functional.** Get things done faster.

**Emotional.** Feel productive.

**Social.** N/A.

**Push/Pull/Anxiety/Habit.** Blank.

**Competitive alternatives.** Other productivity apps.

**Evidence.** None.

**What's wrong.** "Knowledge workers" is not a segment. "Get things done faster" is not a job. "Feel productive" is not an emotion (it's a tautology). Anxiety and habit are blank. Competitors are narrow. No evidence.

This JTBD changes no downstream decision. It's vanity. Reject and re-do.

## Common Pitfalls

### Pitfall 1 — Confusing the job with the solution

**Symptom:** Job reads "users want a quick-checkout button." That's a solution, not a job.

**Fix:** The job exists without your product. Ask "what is the customer trying to accomplish? what alternatives could they hire instead?"

### Pitfall 2 — Only functional dimension

**Symptom:** Functional is rich; emotional and social are blank or generic.

**Fix:** Most products lose on the emotional or social dimension, not the functional. Slack vs email is partly functional (asynchronous-yet-fast), but a lot of the switch was social (modern, less corporate). Always investigate all three.

### Pitfall 3 — Over-narrow competitive alternatives

**Symptom:** "Competitors are other tools in our category."

**Consequence:** Misses the most common alternative — manual approaches, "do nothing," and adjacent-category tools used informally.

**Fix:** Ask "what do non-customers use?" The answer is usually a spreadsheet, an email, paper, or nothing.

### Pitfall 4 — No evidence, no flag

**Symptom:** JTBD reads as fact; no source attribution; based on team intuition.

**Consequence:** Team treats hypothesized JTBD as proven JTBD; strategy built on assumption.

**Fix:** Mark explicitly as "hypothesized — pending discovery interviews" if no evidence yet. Hypothesized JTBD is fine to start; pretending it's evidence-anchored when it isn't is not.

### Pitfall 5 — Inert JTBD

**Symptom:** Team writes the JTBD; nothing downstream changes; the artifact sits in a doc.

**Fix:** Step 4 — does naming the job change a decision? If no, the JTBD is wrong, over-vague, or too late. Use it in the next PRD, positioning statement, or onboarding redesign or discard.

## References

- **Clayton Christensen** — *Competing Against Luck* (with Taddy Hall, Karen Dillon, David Duncan); JTBD origin in product strategy.
- **Bob Moesta** — switch-interview methodology; four forces of progress.
- **Theodore Levitt** — "Marketing Myopia" (1960); the original "people don't buy quarter-inch drills, they buy quarter-inch holes" framing.
- **Tony Ulwick** — *What Customers Want*; Outcome-Driven Innovation (more quantitative cousin of JTBD).
- **Joanna Wiebe** — voice-of-customer mining methodology (see marketing-expert role).
- **Related Hornero skills:**
  - [`prd`](../prd/SKILL.md) — JTBD feeds the PRD's Problem section.
  - [`positioning-statement`](../positioning-statement/SKILL.md) — JTBD feeds positioning's "for [target] who [need]" line.
  - [`roles/marketing-expert/skills/positioning-canvas`](../../../marketing-expert/skills/positioning-canvas/SKILL.md) — JTBD's "competitive alternatives" feeds the positioning canvas.
  - [`roles/product-manager/skills/cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — the PM-orchestrator's Step 1 frames the customer job using this skill's vocabulary.
