---
name: success-metrics
description: "Produces a metric stack for a feature, launch or quarter: one primary metric, a counter-metric against gaming, guardrails for adjacent health, and leading indicators; also critiques an existing metric definition or dashboard metric for missing counter-metrics, unscoped populations and gaming surfaces. Use before instrumentation to define what good looks like, or when asked to review, challenge or tighten a metric definition. For finance metrics (ARR, NRR, Rule of 40, burn multiple) use saas-revenue-growth-metrics or saas-economics-efficiency-metrics; to draft OKRs use okrs."
role: product-manager
intent: |
  Produces a metric stack for a feature, launch, or quarter: the one primary
  metric that signals success, the counter-metric that guards against gaming,
  the guardrails that protect adjacent health, and the leading indicators that
  provide early signal. This is the PM's metric-design discipline; it precedes
  the data-scientist's definitional and measurement work.
type: component
theme: measurement
best_for:
  - Defining success before writing a PRD
  - Preparing a launch brief's measurement section
  - Pre-instrumentation alignment so engineering builds the right events
  - Preventing metric-gaming after a launch
scenarios:
  - "PM shipping a new onboarding flow and needing a success metric before standups start"
  - "Team debating whether DAU or retention is the right north star for a new feature"
  - "Quarterly planning asking 'how will we know Q3 was successful?'"
  - "Launch post-mortem revealing the team had no pre-agreed counter-metric"
estimated_time: 30-60 minutes (with existing discovery evidence); 60-90 minutes (without)
---

# Success metrics

> v0 draft. Anchored in Cagan's four-risk framing, Doshi's decision-quality discipline, Wodtke's OKR-shaped criteria, and Cutler's systems-thinking on north-star metrics. Editorial review recommended.

## Purpose

Define what good looks like for a feature, launch, or quarter before the team starts building or shipping.

The artifact is a metric stack: a primary metric, a counter-metric, guardrail metrics, and leading indicators — each with a rationale. The purpose is alignment before measurement: the team should be able to state, before launch, exactly what signal would tell them the work succeeded, and what signal would tell them it harmed something they care about.

Distinct from the data-scientist's `metric-definition` (a future `data-scientist` role skill): the PM names *which* metrics matter and *why*; the data-scientist verifies definitional integrity, measurement validity, and statistical soundness. This skill produces the brief that the data-scientist's skill validates.

## Key Concepts

### Four-risk framing (Cagan)

Cagan (*Inspired*, *Empowered*) identifies four risks every product team faces:

- **Value risk** — will users actually use/buy it?
- **Usability risk** — can they use it without struggling?
- **Feasibility risk** — can we build it sustainably?
- **Business viability risk** — does it make sense for the company?

A metric stack covers all four, even if unevenly. A success metric that only measures value risk (e.g. activation rate) while ignoring business viability (e.g. cost-per-activation) leaves half the question unanswered. When drafting the stack, ask: which of the four risks does each metric address?

### Primary metric + counter-metric (Doshi)

Doshi's decision-quality discipline: a single primary metric without a counter-metric will be optimized until it destroys something else. Classic example: optimizing click-through rate drives towards clickbait. The counter-metric is not the opposite of the primary; it is the adjacent variable that would be harmed by single-minded primary-metric optimization.

The counter-metric is not optional. A metric stack without a counter-metric is incomplete.

Doshi also distinguishes *decision quality* from *outcome quality*: a good metric stack survives both. If a team hits its primary metric through a Type-1 decision (irreversible, wrong approach) versus a Type-2 decision (reversible, experimental), the stack should be designed to surface the difference. The revisit condition (see Step 5) is how this discipline becomes operational.

### OKR-shaped success criteria (Wodtke)

Wodtke (*Radical Focus*): success criteria are the Key Results side of an OKR. They are not aspirational statements; they are observable, bounded outcomes. "Improve retention" is not a success criterion. "Increase 30-day retention from 42% to 52% by end of Q3" is.

The OKR frame disciplines success metrics: a metric without a target and a time horizon is not a metric, it is a direction.

### Systems-thinking on which metrics drive the system (Cutler)

Cutler (North Star Framework): not all metrics are equal. Some metrics are *outputs* (what the system produces); some are *inputs* (what drives the system); some are *health metrics* (what keeps the system viable). Optimizing an output metric without understanding what inputs drive it leads to interventions that move the metric without moving the system.

The leading-indicator discipline follows from this: which input metrics, when they move, predict the output metric will follow? These are the early signals that tell a team whether to keep building or change course before the primary metric has enough data.

### Guardrail metrics

A guardrail metric is a signal that must stay within acceptable bounds regardless of what happens to the primary metric. Examples: page load time must not exceed 3s; support ticket volume must not increase >10%; revenue-per-seat must not fall below the pricing floor. Guardrails protect adjacent areas of the system from spillover harm.

Guardrails differ from counter-metrics: a counter-metric specifically guards against gaming the primary; a guardrail protects the broader system.

## Application

### Step 1 — State the outcome the work is supposed to produce (5-10 minutes)

Before naming any metric, state the customer and business outcome the feature, launch, or quarter is trying to produce. One sentence each:

- **Customer outcome.** What progress does the customer make as a result of this work? (Christensen JTBD language: what job does this make easier or better?)
- **Business outcome.** What business result follows if the customer outcome is real?

If these can't be stated in one sentence each, the success-metric exercise is premature. The team doesn't know what they're measuring yet.

### Step 2 — Name the primary metric (10-15 minutes)

The primary metric is the single number that, if it moves in the right direction within a defined time horizon, tells the team the work succeeded on the customer outcome.

Tests for a good primary metric:

1. **Sensitivity test.** Will the metric actually move if the feature works? A metric too far upstream (e.g. LTV) may not move in the time horizon even if the feature is a success. Too downstream (e.g. button clicks) and it moves for the wrong reasons.
2. **Decision test (Cutler).** If this metric moves, would it change a roadmap or resourcing decision? If the answer is no, it is a vanity metric.
3. **Customer-outcome test.** Does this metric trace back to the customer outcome stated in Step 1? If moving the metric does not imply customer progress, it is a proxy that may be gamed.
4. **OKR-shape test (Wodtke).** Does the metric have a baseline, a target, and a horizon? "Activation rate" is not a metric. "Increase activation rate from 34% to 45% within 60 days of launch" is.

Write the primary metric in full, with baseline, target, and horizon.

### Step 3 — Name the counter-metric (10-15 minutes)

Ask: if the team optimizes the primary metric single-mindedly for 90 days, what adjacent variable would be damaged?

Examples:
- Primary: activation rate → Counter: day-7 retention (activating users who churn immediately is worse than not activating them)
- Primary: NPS → Counter: support-ticket volume (NPS can be inflated by survey-time selection bias; ticket volume is harder to fake)
- Primary: revenue → Counter: margin or churn rate (revenue optimized through discounts destroys the counter)

The counter-metric does not need a target in the same way the primary does — it often needs a floor ("must not fall below X") or a ceiling ("must not rise above Y") rather than a directional target.

### Step 4 — Name the guardrail metrics (5-10 minutes)

List the adjacent system metrics that must stay within acceptable bounds regardless of the primary metric's direction. Each guardrail should have an explicit bound.

Heuristic for identification: look at Cagan's four risks. Each risk that isn't addressed by the primary or counter metric probably warrants a guardrail. Feasibility risk often surfaces here (engineering health: build time, error rate, infrastructure cost). Business viability risk often surfaces here (unit economics).

### Step 5 — Name the leading indicators (10-15 minutes)

Leading indicators are input metrics that, when they move, predict the primary metric will follow — typically days or weeks earlier. They are early-warning and early-confirmation signals.

To identify leading indicators, ask: "What would users need to do in week 1 for the primary metric to move in week 8?" The answer is usually a usage or engagement signal closer to the moment of use.

Leading indicators allow the team to make in-flight corrections before waiting for the primary metric to accumulate enough data. They are especially valuable for:

- Low-frequency events (purchases, renewals, churns) where the primary metric has a long feedback loop
- Large-scale launches where a leading indicator going wrong early is cheaper to fix than waiting for the primary metric to confirm

Leading indicators are not commitments — they may fail to predict if the model is wrong. They are hypotheses about causation, and Cutler's systems-thinking applies: moving a leading indicator that doesn't actually drive the primary is optimizing the input without changing the output.

### Step 6 — Review against the four-risk frame (5 minutes)

Map each metric to the four risks:

| Metric | Type | Risk addressed |
|--------|------|----------------|
| [Primary] | primary | [value / usability / feasibility / viability] |
| [Counter] | counter | [value / usability / feasibility / viability] |
| [Guardrail 1] | guardrail | [value / usability / feasibility / viability] |
| [Guardrail 2] | guardrail | [...] |
| [Leading indicator 1] | leading | [...] |

If any of the four risks is entirely unrepresented, add a guardrail or note explicitly that the risk is out of scope and why.

### Step 7 — Write the revisit condition (5 minutes)

Per Doshi's decision-quality discipline: state the specific signal that would trigger a re-evaluation of the metric stack itself, not just the work. The metric stack is also a hypothesis. If the leading indicators don't predict the primary, the model is wrong.

A revisit condition example: "If 30-day retention (counter-metric) drops by >5 points while activation rate (primary) is hitting target, we revisit whether activation is the right primary metric for this cohort."

### Output discipline

When the response critiques or produces an artifact:

- **Ground each finding.** Name the framework and its author and work, drawn from this skill's References (for example "Cagan's four big risks, *Inspired*"). Cite only what the finding actually rests on.
- **Name a trade-off.** State at least one cost the recommendation accepts and take a position on it.
- **End with next actions.** Close with one to three concrete actions, each with a deliverable or owner (for example "rewrite the problem section with ticket counts and interview evidence"). Never end on "align", "iterate" or "more research".

## Examples

### Example 1 — Metric stack for a new onboarding flow

**Customer outcome.** New users who sign up for a project-management tool reach their first completed project within their first session, rather than abandoning after setup.

**Business outcome.** 30-day retention increases because users who complete a project in the first session have 2x the 30-day retention rate of users who don't (hypothesis from cohort analysis).

```markdown
# Success metrics — Onboarding redesign (Q3 2026)

**Primary metric.**
First-session project-completion rate: the % of new signups who complete at
least one project milestone in session 1. Baseline: 18%. Target: ≥30%.
Horizon: 60 days post-launch.
Risk addressed: value risk (are users actually using the product in a
meaningful way in the session?).

**Counter-metric.**
Day-7 retention: must not fall below current baseline of 38%. Guards against
optimizing for superficial completions that don't retain. (Users who "complete"
a project by clicking through steps without real content churn at the same
rate as users who abandon; if this is happening, activation is a vanity metric.)
Risk addressed: value risk (long-horizon).

**Guardrail metrics.**
- Median time-to-first-completion: must not rise above 12 minutes. Guards
  against a completion rate that is achieved by lengthening the session to
  the point of frustration.
  Risk addressed: usability risk.
- Onboarding error rate: must not exceed 2%. New events are instrumented;
  guard against introducing a broken state.
  Risk addressed: feasibility risk.
- Support tickets tagged "onboarding confused": must not increase >15% vs
  prior-month baseline.
  Risk addressed: usability risk.

**Leading indicators.**
- Step-2 completion rate (users who reach the "name your first project" screen):
  expected to move within 3 days. If this doesn't rise with the new flow, the
  top-of-funnel change isn't working.
- Time-on-step-2: if users spend >3 minutes on the naming step, the UI is
  confusing; investigate before waiting for first-session completion data.

**Revisit condition.**
If by day 30, first-session project-completion rate is hitting target (≥30%)
but day-7 retention is flat or falling, we revisit whether "project completion
in session 1" is actually the right causal input to retention, or whether
we are measuring a behavior that correlates with motivated users rather than
causing motivation.
```

What makes this stack good: the primary metric has a baseline, target, and horizon. The counter-metric specifically guards against the gaming path (superficial completions). Guardrails cover usability and feasibility. Leading indicators enable early course-correction before 60 days pass. The revisit condition turns the stack into a falsifiable model.

### Example 2 — Bad metric stack (failure)

```markdown
**Primary metric.** Improve user activation.

**Counter-metric.** N/A.

**Guardrails.** None.

**Leading indicators.** Engagement.
```

Failures: "improve user activation" has no baseline, no target, no horizon — not a metric, a direction. No counter-metric — gaming path is open. No guardrails — adjacent system health unprotected. "Engagement" is not a leading indicator, it is a category. Nothing in this stack would change a decision or surface a problem.

## Common Pitfalls

### Pitfall 1 — Primary metric without a target and horizon

**Symptom.** The metric is named but not shaped: "we're measuring retention."

**Consequence.** The team can always claim success or deflect failure — "retention is trending in the right direction" means nothing without a baseline and a target.

**Fix.** Wodtke's OKR shape: baseline, target, horizon. All three, every time.

### Pitfall 2 — No counter-metric

**Symptom.** One metric in the stack; the team optimizes it for a quarter; adjacent metrics degrade silently.

**Consequence.** Classic example: maximizing activation rate by lowering the activation bar inflates the primary metric while destroying day-7 retention.

**Fix.** For every primary metric, ask: "What would be damaged if we optimized this single-mindedly?" The answer is the counter-metric. It is not optional.

### Pitfall 3 — Guardrails added after the fact

**Symptom.** A metric is proposed as a guardrail during a post-mortem ("we should have been watching X").

**Consequence.** By the time the guardrail is added, the harm has already happened. The discipline is only valuable pre-launch.

**Fix.** Guardrail identification in Step 4 is done before launch, before instrumentation, before the sprint starts. If you are adding guardrails in a post-mortem, you have learned something for next time; you haven't protected this launch.

### Pitfall 4 — Leading indicators treated as primary metrics

**Symptom.** A team declares success based on a leading indicator ("step-2 completion is up 20%") without checking whether the primary metric moved.

**Consequence.** The model connecting the leading indicator to the primary metric was wrong; the team shipped and moved on without validating it.

**Fix.** Leading indicators are hypotheses about causation. The revisit condition (Step 7) explicitly tests whether the leading indicator model was right.

### Pitfall 5 — Metric stack produced without the data-scientist

**Symptom.** PM produces the stack; nobody checks whether the events are instrumented, whether the baseline is valid, whether the metric is computable from existing data.

**Consequence.** Launch day reveals the primary metric is not measurable because the event wasn't built.

**Fix.** The metric stack is a brief, not a finished artifact. After Step 7, route to the data-scientist's `metric-definition` skill for definitional integrity and measurement validation. PM names which metrics; data-scientist validates that they are measurable.

### Pitfall 6 — Confusing the metric stack with OKRs

**Symptom.** The team has OKRs for the quarter and assumes the KRs are the success metric stack for each feature.

**Consequence.** OKRs operate at a team or product level; feature-level success metrics are more granular. A feature may contribute to a KR without being directly measured by it. Without feature-level metrics, the PM can't diagnose whether a KR is moving because of which feature.

**Fix.** OKRs and feature metric stacks are complementary, not identical. The feature metric stack feeds up into the KR; the KR measures the aggregate. Both are needed.

## References

- **Marty Cagan** — *Inspired* (2008, rev. 2017); *Empowered* (2020, with Chris Jones). The four-risk framework (value, usability, feasibility, viability) — each risk should be represented in the metric stack.
- **Shreyas Doshi** — High-quality-decisions methodology; decision quality vs. outcome quality; the Type-1/Type-2 decision framing. The counter-metric discipline and the revisit condition directly operationalize Doshi's framework.
- **Christina Wodtke** — *Radical Focus* (2016, rev. 2021). OKR-shaped success criteria: baseline, target, horizon. The Key Result side of an OKR is the canonical form of a well-shaped metric.
- **John Cutler** — North Star Framework; product systems thinking. The distinction between output metrics, input metrics, and health metrics underlies the leading-indicator and guardrail discipline.
- **Related Hornero skills:**
  - a future `data-scientist` role's `metric-definition` skill — downstream of this skill. PM names which metrics; data-scientist verifies definitional integrity and measurement validity.
  - [`okrs`](../okrs/SKILL.md) — OKRs operate at team/product level; feature metric stacks are the more granular complement. Primary metrics trace up to KRs.
  - [`prd`](../prd/SKILL.md) — the success-metrics stack belongs in the PRD's success-criteria section.
  - [`cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — the "outcomes we'll watch" section in the decision recommendation should be drawn from a success-metrics stack.
