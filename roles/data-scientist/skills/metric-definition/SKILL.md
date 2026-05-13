---
name: metric-definition
description: Use when a team is defining a new metric or auditing an existing one — to nail down the one-sentence definition, the unit of analysis, the counter-metric, the gaming surface, and the ownership.
intent: |
  Produces or critiques a metric definition that two engineers on
  different teams would compute identically. Resists three failure
  modes the work-week usually accepts: ambiguous definitions ("daily
  active users" with five plausible meanings), unpaired metrics
  (single number with no counter-metric, ripe for Goodhart), and
  unowned metrics (when the numbers move, nobody is responsible).
type: component
theme: measurement-rigor
best_for:
  - Defining a north-star or input metric before it drives prioritization
  - Auditing a dashboard metric that two teams interpret differently
  - Replacing a vanity metric with one that ties to outcomes
  - Hardening a metric that an A/B test is about to use
scenarios:
  - "Defining 'active customer' for a B2B SaaS dashboard"
  - "Auditing 'engagement' on a content platform"
  - "Hardening 'time-to-second-analysis' before a feature launch test"
  - "Replacing 'monthly logins' with a metric that doesn't game itself"
estimated_time: 30-60 minutes (first definition); 15-30 minutes (audit of existing)
---

# Metric definition

> v0 draft. Grounded in Ron Kohavi's *Trustworthy Online Controlled Experiments* (2020) on metric design and SRM, Cassie Kozyrkov on decision intelligence (metrics-before-models), Charles Goodhart's law as canonised in operational use ("when a measure becomes a target, it ceases to be a good measure"), and Donald Campbell's "Campbell's law" companion (also from the 1970s social-science measurement literature).

## Purpose

Produce a metric definition that:

1. **Two engineers on different teams would compute identically** — same numerator, same denominator, same exclusions, same window.
2. **Names its purpose** — what decision does this metric support, and who owns those decisions.
3. **Has a counter-metric** — what would tell us the headline metric improved at the cost of something else.
4. **Names its gaming surface** — what behaviour could move this metric in a way that didn't reflect real progress.
5. **Has an owner** — when the number moves, who is paged, who is asked.

A metric without a definition is ambient noise that periodically erupts into a debate. A metric without a counter-metric is a Goodhart's-law accident waiting for an incentive change. A metric without ownership is a metric that survives long after it stopped being load-bearing.

## Key Concepts

### Kohavi's metric design principles

From *Trustworthy Online Controlled Experiments* (Kohavi, Tang, Xu, 2020):

- **OEC** (Overall Evaluation Criterion) — a single metric that captures whether the change is good for the long term. Composed from guardrails + drivers, not bolted on.
- **Guardrail metrics** — non-degradation constraints (latency, error rate, abuse signals). The experiment can win on OEC and still ship — but only if no guardrail breaches.
- **Sample Ratio Mismatch (SRM)** — when the split between control and treatment differs from the planned proportion. Almost always indicates a broken randomization, not real signal.
- **Operational metrics** — what the team monitors weekly; not the same as OEC.

### Goodhart's law (and Campbell's law)

> "When a measure becomes a target, it ceases to be a good measure." (Goodhart, 1975; popularised by Marilyn Strathern, 1997.)

Campbell's law (1976): "The more any quantitative social indicator is used for social decision-making, the more subject it will be to corruption pressures and the more apt it will be to distort and corrupt the social processes it is intended to monitor."

Both surface the same problem: optimisation under measurement degrades the relationship between the measure and the underlying truth. Counter-metrics, owner accountability, and periodic re-validation are the operational defences.

### The counter-metric principle

For every leading metric, name the **easiest move that improves it at the cost of something else.** The counter-metric is whatever watches for that move. Examples:

- *Headline*: signups. *Easy move*: relax email verification. *Counter*: 7-day-retention of signed-up cohort.
- *Headline*: response-time. *Easy move*: drop the 99th percentile. *Counter*: tail latency (p99, p99.9).
- *Headline*: active users. *Easy move*: spam re-engagement notifications. *Counter*: 30-day churn rate.
- *Headline*: conversion. *Easy move*: dark-pattern UI. *Counter*: 30-day return + complaint rate.

If you can't name the easy move, you don't understand the metric well enough yet.

### Unit-of-analysis discipline

The denominator's noun matters more than the numerator's. "20% conversion" can mean any of:

- 20% of *sessions* convert.
- 20% of *visitors* convert.
- 20% of *visits-by-eligible-users* convert.
- 20% of *new visitors* convert.
- 20% of *exposed visitors* convert.

Each gives different answers and supports different decisions. The definition must specify the noun.

### Population, window, exclusions

- **Population** — who is counted? Logged-in only? Including bots? Including internal employees? Including users in the EU (GDPR-suppressed)?
- **Window** — over what time period? Rolling 7-day? Calendar week? Trailing 28-day?
- **Exclusions** — refunded? Cancelled? Test accounts? Inactive cohort? Users who opted out?

Two teams looking at the "same" metric with different population / window / exclusions are looking at different metrics.

### Decision-first design (Kozyrkov)

Cassie Kozyrkov: choose the decision first, the metric second. A metric without a decision it supports is a vanity number. The definition section must state *what decision this metric will inform*. "Helpful to look at" is not a decision.

### The Goodhart proxy hazard

Every leading metric is a *proxy* for an outcome the team actually cares about. The closer the proxy to the outcome, the harder it is to game (but the harder it is to measure quickly). Document the proxy relationship: "this metric is a proxy for X; we believe the relationship holds because Y; we will re-check the relationship every Z."

## Application

### Step 1 — State the decision (5-10 minutes)

Before writing the definition, write:

- **What decision will this metric support?** Be specific: "decide whether to invest in onboarding optimisation in Q3" — not "understand user behaviour."
- **Who makes that decision?** A specific role / person.
- **What threshold would change the decision?** "We invest if 7-day-retention is below 30%; we don't if above 35%; we revisit between."

If you can't answer these, the metric isn't ready to define — discovery work comes first.

### Step 2 — Write the one-sentence definition

Use this template:

> *"<Metric name> is the <numerator noun> per <denominator noun>, measured over <window>, for <population>, excluding <exclusions>."*

Examples:

- "Daily active users is the count of distinct logged-in users who issued at least one API request in a UTC calendar day, excluding internal employees and bot user-agents."
- "Activation rate is the proportion of new-signup users who complete the 'first analysis' event within 7 days of signup, excluding signups that didn't verify email."
- "Refund rate is the dollar value of refunds processed in a calendar month divided by gross billings in that same month, including refunds against billings from prior months."

The template is awkward on purpose — it forces explicitness. After v0, you can re-write more naturally but the components must remain visible.

### Step 3 — Name the counter-metric

For each definition, write the **easiest move that improves the metric at the cost of something else**, then write the counter-metric that would catch that move.

```markdown
**Headline:** activation rate (above).
**Easiest gaming move:** lower the bar of 'first analysis' to anything that loads a page.
**Counter-metric:** 30-day retention of activated cohort (proves the activation event correlates with real progress).
**Re-validate proxy relationship:** quarterly, by recomputing activated→retained correlation on the latest cohort.
```

If multiple gaming moves are plausible, write multiple counter-metrics.

### Step 4 — Name the gaming surface

Beyond the easiest-move counter-metric, list:

- **Internal gaming risks** — incentives that could push teams to move this number unhealthily.
- **External gaming risks** — adversaries (fraud, spam, bots) whose behaviour could move this number.
- **Definition drift risks** — changes to how the underlying data is generated (a new event firing, an old event deprecated) that could move the number without anything real changing.

Each risk gets a one-line mitigation: monitoring, audit, periodic re-validation, or "accept and document."

### Step 5 — Assign an owner

A named role / person who:

- Is paged when the metric moves outside its baseline range.
- Decides whether a definitional change requires a re-baselining.
- Holds the relationship between the metric and the decision it supports.

If no owner can be named, the metric isn't operationally real. Park it.

### Step 6 — Document and circulate

The definition lives in:

- A canonical metrics doc / wiki / dbt model — the source-of-truth location for the team.
- The dashboard that displays it (definition shown on hover or in a sidebar).
- The experimentation platform's metric registry, if used (Kohavi's recommendation; turns metric definitions into versioned objects).

Circulate to: the decision-owner, the team that produces the data, and a sibling team that uses the metric. Each gets to challenge the definition before it's adopted.

## Examples

### Example 1 — A defensible activation metric (good)

```markdown
# Metric — activation_rate

**Decision supported:** invest in onboarding optimisation if activation_rate
< 30% for two consecutive months; hold if 30-35%; redirect investment
elsewhere if > 35%.

**Owner:** Growth PM (currently @arielle).

**One-sentence:** activation_rate is the proportion of new-signup users
who complete the 'first analysis' event within 7 days of email
verification, where 'first analysis' means: created a cohort, ran a
report against it, and viewed at least one row of results. Population
excludes internal employees (@*.internal email) and users who never
verified email. Window is 7 days from email-verification timestamp,
not signup timestamp.

**Counter-metrics:**
- 30-day retention of activated cohort (>= 50% baseline). Catches the
  gaming move of "lower the bar of 'first analysis' to a no-op page
  view."
- 7-day support-ticket rate from activated cohort (<= 5% baseline).
  Catches "we activated them by confusing them into clicking through
  a tutorial they didn't understand."

**Gaming surface:**
- Internal: Growth team is measured on this; the bar of 'first
  analysis' could erode over time. Mitigation: definitional changes
  require eng-lead + decision-owner sign-off; activation event is
  versioned in the metric registry.
- External: bot signups inflate the denominator. Mitigation: bot-
  signup-rate guardrail (currently 0.3%; alarm at 1%).
- Definition drift: 'first analysis' relies on a specific event in
  the events pipeline; if that event is deprecated, the metric breaks
  silently. Mitigation: event-deprecation review includes metric
  registry.

**Baseline:** 32% (trailing 28 days as of 2026-05-01). Re-baselining
every 90 days unless the definition changes.

**Re-validation:** quarterly proxy check — recompute activated→retained
correlation on the latest cohort. If correlation drops below 0.4,
revisit the definition.
```

What's good: the decision is explicit; the definition would compute identically across teams; the counter-metrics catch the obvious gaming moves; the gaming surface is itemised; there's an owner and a re-validation schedule.

### Example 2 — A vanity metric replaced (good critique → good replacement)

Before (vanity):

```markdown
**Engagement:** total content views per month.
```

Critique: no unit of analysis (views by whom?); no exclusions (bots? internal?); no counter-metric (easy move: auto-play videos until a "view" is logged); no decision tied to it; no owner.

After (replacement):

```markdown
**Decision supported:** allocate content-creation budget by topic area
if topic engagement_score > 1.5 for two consecutive months.

**Owner:** Content Lead (@jordan).

**One-sentence:** topic_engagement_score is the harmonic mean of three
measures, each computed per topic per calendar month, over the
population of authenticated logged-in users (excluding internal):

  - returning_view_rate: proportion of distinct users who viewed any
    piece in this topic in the prior 90 days who view again this month
  - read-through_rate: proportion of in-topic views that reach >= 80%
    scroll depth
  - share_rate: proportion of in-topic views that produce a share
    event within 24 hours of the view

**Counter-metric:** distinct-creator-count per topic (>= 5 baseline).
A high engagement_score concentrated on one or two creators is a
fragile topic, not a healthy one.

**Gaming surface:**
- Auto-play / scroll-back-to-top tactics — caught by scroll-depth
  requirement and share-rate (autoplay doesn't produce shares).
- Bot views — bot-detection guardrail at view-event level.

**Baseline:** TBD post-3-month-observation period; topic-level
baselines will differ.

**Re-validation:** semi-annual proxy check — does engagement_score
correlate with subscription retention 90 days later?
```

What changed: from a single gameable number to a composite tied to a decision, with population and exclusion rules, counter-metrics, and a proxy-relationship re-validation.

### Example 3 — Failure mode (bad)

```markdown
**Metric:** Active users.

We measure it weekly. It's gone up 15% this quarter.
```

Failures: ambiguous definition (active how?); no population (logged-in? including bots?); no window per data point (does "weekly" mean rolling 7-day or calendar week?); no counter-metric; no decision the metric supports; no owner; no gaming-surface analysis. The 15% rise is uninterpretable — could be real, could be definitional drift, could be a bot wave, could be the metric breaking and a counting bug double-counting.

## Common Pitfalls

### Pitfall 1 — Single-number, no counter-metric

**Symptom:** A team's headline metric is named, baselined, and tracked — with no companion that would expose unhealthy improvement.

**Consequence:** Goodhart's law fires. The team's incentives align on the move that exploits the gap between the metric and the underlying truth; everyone is doing what's measured; nothing important is improving.

**Fix:** Every leading metric gets at least one counter-metric. If you can't think of one, you don't understand the metric.

### Pitfall 2 — Unit-of-analysis ambiguity

**Symptom:** "Conversion is 20%." Twenty percent of what? Sessions? Visitors? Eligible visitors?

**Consequence:** Teams cite different numbers for "the same metric"; analyses contradict each other; trust in the data erodes.

**Fix:** The denominator's noun is part of the metric's name (informally) and definitely part of its definition. Two teams should never compute different numerators because they thought "user" meant different things.

### Pitfall 3 — Decision-free metrics

**Symptom:** A metric exists "because the dashboard shows it" or "because the previous PM tracked it." Nobody can name the decision it informs.

**Consequence:** Metric-watching consumes attention without producing action. Worse: the metric occasionally drives a decision *post-hoc*, because someone needed evidence for a call they wanted to make.

**Fix:** Kozyrkov — choose the decision, then the metric. Metrics that don't pass this test get archived.

### Pitfall 4 — Definition drift

**Symptom:** The event behind the metric is renamed, deprecated, or supplemented. The number moves, but it's not the world that changed — it's the measurement.

**Consequence:** Teams chase a "trend" that isn't real; sometimes a real movement is masked by simultaneous drift; trust in historical comparisons collapses.

**Fix:** Metric definitions get versioned. Event-deprecation reviews include the metric registry. When a definition changes, the metric is re-baselined and the old definition's history is preserved separately.

### Pitfall 5 — No owner

**Symptom:** When the number moves, multiple people look at each other; eventually someone takes it on as overtime.

**Consequence:** Anomalies linger; metric-debt accumulates (definitions get fuzzier, gaming surfaces widen); the team loses the ability to react in time.

**Fix:** Named owner, paged on anomaly, accountable for definitional integrity. If no owner can be named, the metric isn't operationally real — archive it.

### Pitfall 6 — SRM-blindness

**Symptom:** A/B tests are run without checking whether the variants are receiving the planned proportion of traffic.

**Consequence:** Kohavi's specific finding: many "winning" experiments are SRM-driven artefacts. Randomization can break silently and produce spurious differences.

**Fix:** Every experiment run on this metric includes an SRM chi-squared check. Failing SRM invalidates the experiment; the cause is investigated before any decision.

### Pitfall 7 — Proxy hazard ignored

**Symptom:** The metric is a proxy for an outcome (e.g., "activation" as proxy for "long-term retention"), but the team treats the proxy as the outcome.

**Consequence:** The team optimises the proxy until the relationship to the underlying outcome breaks (Goodhart again). Then "we improved activation but retention didn't move."

**Fix:** Document the proxy → outcome relationship explicitly. Re-validate periodically. When the relationship degrades, the metric's role changes.

### Pitfall 8 — Confusing operational with experimental

**Symptom:** A metric used for weekly operations (e.g., "active users this week") is also used as an OEC in A/B tests.

**Consequence:** Kohavi: operational metrics are often too noisy or slow-moving to be useful as experimentation OECs. Tests under-power; teams over-conclude.

**Fix:** Operational metrics and experimentation OECs are different metric classes. The latter need power-analysis-friendly variance properties; the former just need to be legible to humans tracking the business.

## References

- **Ron Kohavi, Diane Tang & Ya Xu** — *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing* (2020); OEC design, guardrails, SRM. See `roles/data-scientist/sources.md`.
- **Cassie Kozyrkov** — Decision-intelligence framing: decisions first, metrics second.
- **Charles Goodhart** — "Problems of Monetary Management" (1975), the original statement of Goodhart's law; popularised by Marilyn Strathern (1997).
- **Donald Campbell** — Campbell's law (1976); sibling formulation of the same proxy-corruption pressure.
- **Andrew Gelman & Richard McElreath** — *Bayesian Data Analysis*; *Statistical Rethinking*. Distributional thinking that pairs with definitional rigour.
- **Hadley Wickham** — *R for Data Science*; tidy-data discipline as the foundation for any defensible numerator/denominator.
- **Cathy O'Neil** — *Weapons of Math Destruction* (2016); consequence audit for metrics that drive consequential decisions.
- **Related Hornero skills:**
  - [`experiment-design`](../experiment-design/SKILL.md) — uses metric definitions as OEC + guardrails.
  - [`causal-dag`](../causal-dag/SKILL.md) — when the metric definition implies causal claims, the DAG makes the assumed structure explicit.
  - [`pre-launch-measurement-audit`](../pre-launch-measurement-audit/SKILL.md) — uses this skill to audit the metric stack before a launch.
  - `roles/product-manager/skills/okrs/SKILL.md` — outcomes-first; metrics serve the outcome.
  - `roles/product-manager/skills/prd/SKILL.md` — PRD success criteria are metric definitions in disguise.
