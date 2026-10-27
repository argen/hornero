---
name: prd
description: "Produces or critiques a PRD that anchors a feature in a problem statement, exposes solution-shaped thinking before it ossifies, pairs every success metric with a counter-metric, and names what is deliberately out of scope. Use when asked to write, review, or tighten a PRD or product spec. If the problem is not yet framed use problem-framing-canvas first; for a lightweight pre-implementation problem statement before code use spec-the-problem."
role: product-manager
intent: |
  Produces or evaluates a PRD that resists the build-trap. The PRD is
  problem-driven (not solution-driven), outcome-focused (not output-focused),
  and explicit about success criteria, counter-metrics, and what is NOT
  in scope.
type: component
theme: discovery-delivery
resources:
  - linear
  - jira
best_for:
  - A non-trivial feature requiring cross-team alignment
  - A product decision needing visible problem/value articulation
  - Replacing a vague "we should build X" with a testable specification
scenarios:
  - "PM drafting the PRD for a new dashboards feature"
  - "Reviewer critiquing a PRD that is solution-shaped"
  - "Aligning engineering and design before sprint kickoff"
estimated_time: 30-60 minutes (first draft); 5-10 minutes (critique)
---

# PRD — Product Requirements Document

> v0 draft. Ported and re-authored from patterns in [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) by Dean Peters, with expansions per Hornero's bibliography (Marty Cagan, Melissa Perri, Itamar Gilad). Editorial review needed before production use.

## Purpose

Produce a PRD that anchors a product change to a problem, articulates measurable success, and resists scope creep. The artifact serves three audiences: engineering (what to build), design (what user experience to design for), and leadership (why this is worth doing).

A good PRD reads less like a feature spec and more like a hypothesis statement. It can be reviewed, contested, and updated as evidence accumulates.

## Key Concepts

### Problem-driven, not solution-driven

Cagan (*Inspired*): the PM's first job is to ensure the team is solving the right problem. A PRD that opens with "we will build X" has skipped the work.

The PRD opens with **Problem** — who is affected, what they currently do (and why it falls short), and what evidence supports the problem's scale.

### Outcomes over outputs

Perri (*Escaping the Build Trap*): shipped features are not wins; moved customer or business metrics are.

The PRD names a **target outcome** — what we expect to be different in the world if this works. "Reduce abandoned checkout rate from 18% to ≤12%" is an outcome. "Add a quick-checkout button" is an output.

### Cagan's four risks

Every PRD addresses (or explicitly defers) the four risks:

- **Value** — will users actually want this?
- **Usability** — can they use it effectively?
- **Feasibility** — can we build it within constraints?
- **Business viability** — does it work for the business?

A PRD silent on any of the four is incomplete.

### Counter-metrics

Goodhart's law: any optimized metric distorts. Each success metric in the PRD is paired with a counter-metric — what would tell us the headline metric improved at the cost of something else?

### Explicit out-of-scope

Itamar Gilad's evidence-weighting includes "what does this not address?" The PRD names at least one related concern that is deferred, with a reason.

## Application

### Step 1 — Gather inputs

Before writing, the PM should have:

- Discovery evidence (interviews, usage data, support tickets) supporting the problem
- A clear sense of the affected user segment
- Engineering input on feasibility (informal at this stage)
- Design input on the user-experience shape (informal)
- A view of how this fits the product strategy

If any of these are missing, that's discovery work, not PRD work.

### Step 2 — Draft the PRD using the template

```markdown
# PRD — <feature/change name>

**Author:** <PM name>
**Status:** Draft | In Review | Approved | Shipped
**Last updated:** <YYYY-MM-DD>

## Problem
<2-3 sentences. Who is affected, what they currently do, why it falls short.
Cite evidence: number of interviews, support ticket trends, usage data,
percentage of users affected.>

## Why now
<Why this problem warrants attention now. What changed, or what's the cost
of waiting. If "we've meant to fix this for years" applies, name why now
is different.>

## Hypothesis
We believe that <change>
For <user segment>
Will result in <outcome>
We will know we're right when <observable signal>

## Target outcome
- **Headline metric:** <metric + baseline + target + horizon>
- **Counter-metric:** <metric that would indicate the headline improved
  at unacceptable cost>
- **Leading indicators:** <signals visible before the headline moves>

## Solution direction
<NOT a detailed solution spec. The shape of the solution.
Constraints the solution must respect.
Open questions the solution must answer.>

## Risks (Cagan's four)
- **Value risk:** <how we mitigate or test>
- **Usability risk:** <ditto>
- **Feasibility risk:** <ditto>
- **Business viability risk:** <ditto>

## Out of scope
<At least one related concern explicitly deferred, with reason.>

## Success criteria
- <measurable, observable, falsifiable>
- <ditto>

## What we will learn
<If this ships and works: what does that teach us?
If this ships and fails: what does that teach us?
If neither outcome would teach us anything, the work isn't worth doing.>

## Dependencies and constraints
<Engineering, design, legal, regulatory, infrastructure dependencies.
Hard constraints (e.g., GDPR, contract obligations, platform requirements).>

## Stakeholders
<Who needs to review. Who needs to be informed. Who decides.>
```

### Step 3 — Review against four checks

Before circulating, the PM verifies:

1. **Problem-shape check.** The opening 100 words describe a problem; not a feature. Re-read the first paragraph. Does it pass?
2. **Outcome-shape check.** Success criteria are measurable, observable, falsifiable. Could a colleague tell six months later whether they were met?
3. **Risk-coverage check.** All four Cagan risks addressed (or explicitly deferred with reason).
4. **Out-of-scope check.** At least one item present.

If any check fails, revise.

### Step 4 — Circulate and revise

Share with engineering, design, leadership. Treat the PRD as a hypothesis statement open to revision, not a frozen contract. Track changes in a "decisions log" appended to the bottom; don't silently rewrite.

### Step 5 — Maintain as work proceeds

The PRD is a living document while work is in flight. Decisions, scope changes, and evidence updates land in the log. After ship, the PRD's success criteria become the readout reference.

## Examples

### Example 1 — Solution-shaped (failure → fix)

**Initial PRD opening:**
> "We will build a quick-checkout button on the cart page."

**Problem-shape check fails.** Revised opening:

> "**Problem.** 18% of users abandon cart at the payment step. Of those, exploratory interviews (n=12) suggest 60% leave because the checkout flow asks for information they consider unnecessary at that point (account creation, marketing consent, address verification). Support tickets correlate: 4% of cart-abandonment-related tickets explicitly mention 'too many steps.' Affected users skew toward mobile (76% of abandons)."

The revised PRD then explores solutions — quick-checkout button is one; deferring account creation to post-purchase is another; one-tap-pay is a third. Solution emerges from problem, not the reverse.

### Example 2 — Outcome-shape (good)

```markdown
## Target outcome
- **Headline metric:** Cart abandonment rate at payment step
  Baseline: 18% (Q4 2025); Target: ≤12% (within 90 days post-launch)
- **Counter-metric:** Post-purchase refund rate
  Baseline: 2.1%; Tolerance: ≤2.5% (small increase acceptable; large
  increase indicates we sold to confused buyers)
- **Leading indicators:**
  - Time spent on payment-step page (decreases if friction down)
  - Click-through from cart to payment-confirmation
```

The headline + counter pairing means the team can't "win" by selling to confused customers. The leading indicators give early signal before the 90-day window completes.

## Common Pitfalls

### Pitfall 1 — Hidden solution in problem statement

**Symptom:** Problem reads "users need a faster checkout" — the word "checkout" preempts other solutions (one-click pay, deferred account creation, etc.).

**Consequence:** Team locks into a single solution before exploring alternatives.

**Fix:** Problem describes user state (abandons at payment step) and the user's experience (friction perceived as unnecessary information requests), not the solution shape.

### Pitfall 2 — Unfalsifiable success criteria

**Symptom:** "Users will have a better experience" or "engagement will improve."

**Consequence:** No way to know if the work succeeded; team optimizes vibes.

**Fix:** Every success criterion has a metric, a baseline, a target, and a horizon. If "what would tell us we're wrong?" has no answer, the criterion is unfalsifiable.

### Pitfall 3 — No counter-metric

**Symptom:** Headline metric only, no paired counter.

**Consequence:** Team can optimize the headline at the cost of overall outcome (Goodhart's law).

**Fix:** Every headline metric ships with a counter. If you can't think of one, ask "how could this metric improve while making things worse for the business or user?"

### Pitfall 4 — All four risks "low"

**Symptom:** Every Cagan risk rated low; no mitigations described.

**Consequence:** Either the team is overconfident, or the PRD is performative. Both are dangerous.

**Fix:** At least two of the four risks should be substantive enough to warrant a mitigation. If they aren't, this isn't a feature worth a PRD — it's a small change.

### Pitfall 5 — No out-of-scope

**Symptom:** The out-of-scope section is blank or says "nothing."

**Consequence:** Scope creeps mid-build; related concerns fold in; ship date slips.

**Fix:** Every PRD names at least one deferred concern. "Bulk operations" is a common deferral for single-record features.

## References

- **Marty Cagan** — *Inspired*; the four risks framework. See `roles/product-manager/sources.md`.
- **Teresa Torres** — *Continuous Discovery Habits*; opportunity-evidence link supporting "Problem" section.
- **Melissa Perri** — *Escaping the Build Trap*; outcomes over outputs.
- **Itamar Gilad** — *Evidence-Guided*; explicit risk coverage.
- **Dean Peters** — [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills); the PRD template structure draws on patterns from his skill repo.
- **Related Hornero skills:**
  - `skills/spec-the-problem/SKILL.md` — runs at session level; this is the role-level production version.
  - `skills/jobs-to-be-done/SKILL.md` — JTBD statement that informs the Problem section.
  - `skills/discovery-interview-prep/SKILL.md` — produces evidence cited in the Problem section.
