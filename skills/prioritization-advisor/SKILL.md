---
name: prioritization-advisor
description: Use to triage a backlog or set of options into Do-Now / Defer / Discard — applying LNO, ICE-with-confidence, and the four-risks lens to produce a ranked list with explicit reasoning and rank-change conditions.
role: product-manager
intent: |
  Triages a backlog, set of competing features, or set of strategic options
  into Do-Now / Defer / Discard. Applies LNO (Doshi), ICE-with-confidence
  (Gilad), and the four-risks lens (Cagan) to surface not just ranking but
  the reasoning behind it and what would change the rank. Forces choice:
  if everything is priority 1, nothing is.
type: interactive
theme: prioritization
best_for:
  - Backlog grooming before quarterly planning
  - Triaging a list of competing feature requests
  - Deciding which of several strategic options to pursue this quarter
  - A roadmap review asking "what should we drop?"
scenarios:
  - "PM with 18 backlog items and two weeks of engineering capacity"
  - "Team debate: 'we want to do A, B, C, and D this quarter but feasibility says only two are possible'"
  - "Leadership asking which three initiatives to staff from a list of seven"
  - "Post-discovery: 5 opportunities surfaced, only one can go into the next sprint"
estimated_time: 30-60 minutes (list ≤10 items); 60-120 minutes (list >10 items)
---

# Prioritization advisor

> v0 draft. Anchored in Doshi (LNO + Type-1/Type-2 framing), Gilad (*Evidence-Guided*, ICE-with-confidence), Cagan (four-risks lens), and Wodtke (forces choice). Editorial review recommended.

## Purpose

Triage a backlog or set of options into **Do-Now / Defer / Discard** — with reasoning per item, and an explicit statement of what evidence would change the rank.

The skill's job is to make the tradeoffs legible, not to make them disappear. Good prioritization produces two things: a clear ranked list and a clear account of what was deprioritized and why. Without the second, the team can't course-correct when evidence changes.

This skill does not replace judgment. It forces judgment to be explicit. The output is a triaged list that a PM can defend, a team can pressure-test, and a stakeholder can understand.

## Key Concepts

### LNO — every task is Leverage, Neutral, or Overhead (Doshi)

Shreyas Doshi: not all tasks return the same value for the same effort. Before any scoring framework, PM energy should be concentrated on **Leverage** tasks — those where doing them *well* (not just doing them) has a 10x payoff. Neutral tasks are worth doing but don't compound. Overhead tasks are necessary but should be minimized.

Prioritization that treats every backlog item as equally worth scoring is a category error. LNO is the triage that happens *before* ICE or RICE. If an item is Overhead, deprioritizing it or delegating it is the right answer — no scoring needed.

LNO also provides the Type-1 / Type-2 framing: Leverage tasks are often Type-1 (the decision is hard to reverse; the cost of a wrong call is high). Overhead tasks are almost always Type-2 (reversible, low cost). A high-RICE item that's also a Type-1 decision warrants deeper deliberation than its score alone implies.

### ICE-with-confidence (Gilad)

Itamar Gilad (*Evidence-Guided*): ICE (Impact, Confidence, Ease) is a lightweight scoring framework. The modification Gilad contributes is the **confidence interval** — scoring is not just about the estimate, but about how much evidence supports it.

- **Impact.** How much will this move the primary metric if it works?
- **Confidence.** How certain are we that it will work? What evidence do we have?
- **Ease.** How much effort does it require?

ICE score = (Impact × Confidence × Ease) / 3 (or sum; convention varies — what matters is the relative ranking, not the absolute number).

The confidence dimension is load-bearing. An idea with high impact and high ease but low confidence (no customer evidence, untested hypothesis) scores lower than it appears. Gilad's evidence-weighting prevents high-RICE/ICE items from jumping the queue on charisma alone.

### RICE supplemental note

RICE (Reach × Impact × Confidence / Effort) is the Sean Ellis / Growth-community lineage popularized via product blogs. It adds **Reach** as a dimension — how many users are affected — which ICE omits. Gilad notes RICE and ICE are cousins; the confidence dimension is shared. For this skill, ICE-with-confidence is the default because it is faster; add a Reach dimension when volume-of-affected-users is genuinely in dispute.

### Four-risks lens (Cagan)

Cagan (*Inspired*, *Empowered*): a high-RICE or high-ICE item that is untested on **value risk** (will users actually use it?) is still high-risk. Scoring frameworks measure relative priority within a set of assumptions; they don't validate the assumptions. The four-risks lens overlays the scoring:

- An item with high ICE but unvalidated value risk should not be Do-Now without a discovery spike.
- An item with high ICE but known feasibility risk needs an engineering feasibility check before commitment.
- An item with high ICE but low business viability (it may hurt margins or conflict with strategy) needs a business check before commitment.

A Do-Now recommendation that ignores unvalidated risk is not prioritization; it is wishful thinking with arithmetic.

### Forces choice (Wodtke)

Wodtke (*Radical Focus*): if everything is priority 1, nothing is. The output of prioritization is not a ranked list — it is a constrained list. The constraint is real capacity: this sprint, this quarter, this team at this size. If the Do-Now list is longer than the team can actually execute, the triage is not done.

The skill requires the PM to name the capacity constraint before scoring. Without it, every item is "potentially Do-Now."

## Application

Six steps; total PM time 30-120 minutes depending on list size.

### Step 1 — State the constraint (5 minutes)

Before touching the list, state:

- **The horizon.** What period is this prioritization for? (Sprint, quarter, half-year?)
- **The capacity.** What is the realistic execution capacity? (Engineering weeks, design cycles, etc.)
- **The strategy anchor.** What is the team's primary outcome target for this horizon? (The OKR Objective, or the north star metric direction.)

The strategy anchor is how the PM avoids local-optimization — each item is triaged against "does this advance the primary outcome target?" not against "is this a reasonable thing to do?"

### Step 2 — LNO pre-sort (10-15 minutes)

For each item in the list, assign: **L** (Leverage), **N** (Neutral), or **O** (Overhead).

- **Leverage.** If done well, moves the strategy anchor by 10x. The work requires judgment, PM involvement, customer insight.
- **Neutral.** Worth doing; contributes but doesn't compound.
- **Overhead.** Necessary maintenance, compliance, or ops work. Low ceiling on return regardless of effort.

Move all **O** items to a separate "Overhead" list. These do not compete with L and N items for prioritization — they compete for the minimum viable overhead budget. Do-Now applies to Overhead items only when they are blocking or legally required.

### Step 3 — ICE scoring with confidence (15-30 minutes)

For the remaining L and N items, score each on:

| Dimension | 1–10 | What it means |
|-----------|------|---------------|
| Impact | 1-10 | Expected movement in the strategy-anchor metric if this item succeeds |
| Confidence | 1-10 | Evidence quality: 10 = validated with data; 5 = qualitative interviews; 1 = pure hypothesis |
| Ease | 1-10 | Inverse of effort: 10 = a day of work; 1 = a quarter of work |

ICE score = sum or average (use consistently within a session; what matters is relative rank).

**Confidence scoring guide:**
- 9-10: A/B tested, statistically significant, or replicated across segments
- 7-8: Qualitative evidence from 5+ customer interviews; or analytics data that is suggestive but not conclusive
- 5-6: One or two data points; expert intuition with some prior signal
- 3-4: Team hypothesis with no customer evidence
- 1-2: Executive assertion; no supporting evidence

### Step 4 — Four-risks overlay (10-15 minutes)

For each item scored Do-Now candidate (top third of ICE scores), ask:

1. **Value risk.** Is there evidence users will actually use this? If unvalidated, add a discovery spike to the Do-Now scope before building.
2. **Usability risk.** Has a rough prototype or concept been shown to users? If unvalidated on a complex interaction, flag for design review before committing.
3. **Feasibility risk.** Has engineering reviewed the scope? If not, flag for a feasibility check before the item enters the sprint.
4. **Business viability risk.** Does this item conflict with pricing, strategy, or margin constraints? If unreviewed, flag for a stakeholder check.

An item with unvalidated risks does not get demoted automatically — but the Do-Now scope expands to include the validation step. "Do-Now: discovery spike to validate value, then build" is a legitimate Do-Now call.

### Step 5 — Build the triaged list (5-10 minutes)

Produce a table with three sections:

**Do-Now** — items to execute within the stated horizon, in rough execution order. Capacity-bounded: the Do-Now list must fit the capacity stated in Step 1.

**Defer** — items worth doing but not within this horizon. Include a condition for promotion: what evidence or event would move this to Do-Now?

**Discard** — items that are Overhead-only, have no evidence of value, or conflict with the strategy anchor. Include the reason for discard: this allows the team to resurface the item if the reason changes.

### Step 6 — State what would change the rank (5 minutes)

For each Do-Now item, state: what evidence or event would cause this item to be demoted?

For each Defer item, state: what evidence or event would cause this item to be promoted?

This step is Doshi's decision-quality discipline applied to prioritization: the reasoning is recorded so the team can assess whether the prioritization was good, independently of whether the outcomes were good.

## Examples

### Example — Triage output for a growth team (Q3 backlog)

**Constraint.** Q3 horizon. 6 engineering weeks available after planned infrastructure work. Strategy anchor: increase weekly active users (WAU) from 4,200 to 6,000 by end of Q3.

**LNO pre-sort result.** 2 items classified Overhead (dependency upgrades, log rotation fix) — moved to overhead budget; not included in scoring below.

```markdown
# Prioritization — Growth team Q3 backlog

## Do-Now (capacity: 6 eng-weeks)

| Item | ICE score | L/N | Risks | Eng-weeks |
|------|-----------|-----|-------|-----------|
| Email re-engagement flow | 8.1 | L | Value: validated (2 prior A/B tests show 18% WAU lift). Feasibility: confirmed by eng lead. | 2.5 |
| Onboarding step-2 redesign | 7.4 | L | Value: qualitative interviews (n=6). Feasibility: confirmed. Usability: design review needed first. | 2.0 |
| Share-to-social feature | 6.8 | N | Value: unvalidated. Add discovery spike (0.5 weeks) before build commitment. | 0.5 (spike) + 1.0 (if validated) |

**Total Do-Now: 6.0 eng-weeks (incl. spike; share-to-social build contingent on spike outcome.)**

## Defer

| Item | ICE score | L/N | Promote condition |
|------|-----------|-----|-------------------|
| Native mobile push | 5.2 | L | Promote if WAU stalls at ≥5,000 and retention data shows mobile-engagement gap. |
| Bulk import feature | 4.7 | N | Promote if B2B segment analysis shows it is a conversion blocker for ≥15% of trials. |
| Gamification badges | 3.9 | N | Promote if share-to-social spike shows social-proof is the primary engagement driver. |

## Discard

| Item | Reason |
|------|--------|
| Password-free login via magic link | Overlaps with SSO work already planned for platform team in Q4; duplicate effort. Resurface if SSO scope contracts. |
| "Tips & tricks" tooltip tour | No customer evidence of confusion; no support tickets. Three team members like this; no external signal. |

## What would change ranks

- Email re-engagement (Do-Now): demote if deliverability data from the pilot shows <5% open rate; the lift assumption depends on a 22% open rate.
- Native mobile push (Defer): promote immediately if Q2 cohort analysis (due July 15) shows mobile users have 2x retention of web users.
- Gamification badges (Defer): discard permanently if share-to-social spike shows users don't share.
```

What makes this good: the constraint is explicit; the LNO sort removed noise before scoring; the ICE scores include a confidence judgment (share-to-social is unvalidated, so it earns a spike rather than a build slot); the four-risks overlay caught the value-risk gap; the promote/demote conditions make the prioritization falsifiable.

## Common Pitfalls

### Pitfall 1 — Scoring without a capacity constraint

**Symptom.** Every item above a threshold score ends up as Do-Now; the Do-Now list is 12 items and the team has capacity for 3.

**Consequence.** The prioritization produces a ranked list, not a triaged one. The team tries to do everything at lower quality.

**Fix.** State the capacity constraint before scoring (Step 1). The Do-Now list must fit the constraint. If it doesn't, keep cutting until it does. Wodtke: if everything is priority 1, nothing is.

### Pitfall 2 — Treating ICE/RICE scores as objective

**Symptom.** The team runs the scoring framework and treats the output as the answer, with no discussion of the inputs.

**Consequence.** The confidence scores are uniformly high (everyone is optimistic); impact scores are uniformly optimistic; the framework launders intuition as arithmetic.

**Fix.** The confidence dimension is load-bearing (Gilad). Each item's confidence score requires an evidence citation. No citation = confidence ≤3. The PM should surface scoring disagreements as the most important part of the session, not paper over them with averages.

### Pitfall 3 — Skipping LNO — scoring everything equally

**Symptom.** A compliance ticket, a Leverage feature, and a technical-debt item are all scored in the same ICE session and compete for the same slots.

**Consequence.** Overhead items occasionally score high on Ease and displace Leverage work. The team does easy Overhead tasks at the expense of hard Leverage ones.

**Fix.** LNO pre-sort is Step 2, before scoring. Overhead items move to the overhead budget; they do not compete with L and N items.

### Pitfall 4 — Ignoring the four-risks overlay

**Symptom.** The Do-Now list is locked in after ICE scoring; nobody asks whether the items have validated value, usability, feasibility, or business risk.

**Consequence.** High-ICE items go straight into sprints with untested assumptions; the team builds for 6 weeks and launches to low adoption because value risk was never tested.

**Fix.** Step 4 adds the risk overlay to every Do-Now candidate. An item with unvalidated value risk earns a discovery spike before the build slot, not instead of it. The Do-Now call includes the validation work.

### Pitfall 5 — No promote/demote conditions

**Symptom.** Defer items sit in the backlog indefinitely with no mechanism for re-evaluation. Discard items are never revisited even when their discard reason has changed.

**Consequence.** The backlog accumulates debt; genuinely valuable items atrophy in Defer; the team debates the same items every quarter from scratch.

**Fix.** Step 6 is a contract with the future. Every Defer item has a promote condition. Every Discard item has an explicit reason (which becomes the condition for resurface). The conditions are dated or event-triggered — not "we'll revisit later."

### Pitfall 6 — Prioritization as theatre

**Symptom.** The scoring session happens; the list is produced; the team ships roughly what it was going to ship anyway; nothing is dropped.

**Consequence.** The exercise costs 2 hours and produces no decision. The team learns that prioritization is ceremony, not discipline.

**Fix.** The output is only valid if something was Discarded or Deferred that had previously been assumed Do-Now. If nothing was dropped, the exercise was calibration at best, theatre at worst. Ask: what did we say no to? If the answer is nothing, revisit the capacity constraint.

## References

- **Shreyas Doshi** — LNO framework (Leverage / Neutral / Overhead); high-quality-decisions methodology; Type-1 vs Type-2 decision framing. LNO is the pre-sort discipline; Type-1/Type-2 framing disciplines the deliberation depth required per item.
- **Itamar Gilad** — *Evidence-Guided* (2024); ICE-with-confidence; the Confidence Meter. Gilad's key contribution is forcing evidence-weighting into the confidence dimension rather than treating all scores as equally valid intuitions.
- **Marty Cagan** — *Inspired* (2008, rev. 2017); *Empowered* (2020). Four-risks lens (value, usability, feasibility, business viability); the principle that a high-scoring item with unvalidated risk is still high-risk.
- **Christina Wodtke** — *Radical Focus* (2016, rev. 2021). Forces choice: "if everything is priority 1, nothing is." The capacity-constraint discipline is Wodtke's contribution to the scoring frameworks.
- **Related Hornero skills:**
  - [`okrs`](../okrs/SKILL.md) — the strategy anchor in Step 1 is the OKR Objective. Prioritization without an OKR anchor is local optimization.
  - [`success-metrics`](../success-metrics/SKILL.md) — the Impact dimension in ICE should be anchored to the primary metric in the success-metrics stack. An item's impact score is more honest when there's a real metric it's being measured against.
  - [`problem-framing-canvas`](../problem-framing-canvas/SKILL.md) — an item with low confidence that fails the four-risks overlay may need a problem-framing-canvas pass before it can be scored honestly.
  - [`cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — when a prioritization decision is genuinely contested across functions (engineering vs. PM vs. business), escalate to cross-functional orchestration rather than resolving it in this skill.
  - [`prd`](../prd/SKILL.md) — Do-Now items that clear the four-risks overlay become candidates for a PRD.
