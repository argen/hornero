---
name: hubspot-pipeline-readout
description: Use when a PM needs a current read on the GTM pipeline — stage-by-stage health, deal velocity by segment, ICP-fit pattern of who's actually moving — without waiting for a Tuesday sales-ops sync. Reads HubSpot via MCP; produces a one-page readout that names what's moving, what's stuck, and the one question the data raises.
role: product-manager
intent: |
  Make pipeline state legible to the PM without a sales-ops handoff. Most
  product-affecting GTM signal — which segments are converting, which
  deals are stalling at which stage, whether the ICP claim is showing up
  in actual won deals — lives in HubSpot but never makes it into product
  reviews until weeks after it would have changed a decision.
type: workflow
theme: revenue
resources:
  - hubspot
best_for:
  - Pre-roadmap-call check: which segments are deals actually closing in?
  - Quarterly planning input: is the GTM motion supporting the strategic ICP claim?
  - Pricing-change debate: how much pipeline is at risk in the current stage distribution?
  - Renewal forecasting: are the at-risk accounts the ones the product team thinks they are?
scenarios:
  - "PM preparing for the Q3 roadmap call needs to know whether mid-market deals are actually closing, or just appearing in the top-of-funnel. Runs the readout, sees mid-market stalls at Stage 3 (Demo Complete), surfaces a hypothesis: the demo flow is missing the mid-market budget-justification piece."
  - "Pricing-test debate: VP Sales wants to raise the floor for SMB. The readout shows SMB pipeline is 18% of forecast revenue but 42% of deal count — confirms the volume claim and the question shifts from 'should we?' to 'what's the segment-specific churn risk?'."
  - "Renewal cycle approaching: the readout shows three at-risk enterprise accounts the product team didn't have on its list. Two are tied to the same un-shipped feature. Surfaces a roadmap question for the next review."
estimated_time: 10-20 minutes
---

# HubSpot pipeline readout

## Purpose

PMs working in B2B startups operate downstream of the GTM motion, but the data that names *which* segments are moving, *where* deals stall, and *whether the ICP claim is showing up in actual won-deal patterns* lives in HubSpot. Most product reviews don't see it until sales-ops compiles a Tuesday slide deck — by which point the relevant decision has already been made on intuition.

This skill is the structured pass that puts a current pipeline read into the PM's hands directly. It answers three questions: what's moving (by stage, by segment), what's stuck (which stages have deals aging past the historical median), and who's actually closing (which ICP segments are showing up in won deals vs the claim).

The output is a one-page readout with the question the data raises — not a full sales-ops dashboard. Sales-ops owns the dashboard; this skill owns the PM lens.

## Key Concepts

### Three sections, in this order

The readout has three sections, deliberately ordered:

1. **Stage health** — for each deal stage in the primary pipeline, how many deals are in it, what's their median age in stage, how does that compare to the rolling 90-day median? Stages where age has crept up are the leading indicators.
2. **Segment velocity** — deals that closed (won or lost) in the last 30 days, grouped by segment (enterprise / mid-market / SMB based on company size or annual revenue property). Median time-to-close per segment. Win rate per segment.
3. **ICP fit pattern** — won deals in the last quarter: do they match the company's stated ICP? Compare the company-property distribution (industry, size, region) of recent wins against the ICP claim in the positioning statement (if a chronicle entry captures it) or the PM's working definition.

The ordering matters. Stage health is the operational read; segment velocity is the trend; ICP fit is the strategic test. PMs who reverse the order (start with ICP fit) end up in strategy-debate territory before they've confirmed the data is real.

### Pipeline scope: name it explicitly

HubSpot supports multiple deal pipelines (New Business, Renewal, Partner, etc.). The readout runs against **one named pipeline** per invocation. The default is the team's primary new-business pipeline; if the PM is doing a renewal-focused read, that's a separate invocation against the Renewal pipeline.

Don't try to merge pipelines into one readout. The stage definitions, win/loss semantics, and time-to-close norms are pipeline-specific; a merged readout averages signals that mean different things.

### Stage-age is the leading indicator, win rate is the lagging one

Win rate moves slowly and is noisy below a few dozen deals per quarter — it's not a useful weekly signal for most B2B teams. Stage-age (median days a deal sits in stage X before moving) moves with the GTM motion and is sensitive to changes in deal velocity. The readout prioritises stage-age as the headline signal; win rate appears in the segment-velocity section as supporting data.

### Compare to a baseline, not in isolation

Every "this stage is stuck" finding is computed as **current median age in stage** vs **rolling 90-day median age in stage**. An absolute "5 days in Demo Complete" is meaningless without context — for some teams that's fast; for others it's catastrophic. The comparison is the signal.

If 90 days of history isn't available (new pipeline, restructured stages), the readout says so and flags every finding as preliminary.

### What this skill is NOT

- **Not a forecast.** Pipeline forecasting is a sales-ops job; this is a current-state read.
- **Not a deal-by-deal triage.** A list of every stuck deal would be sales-ops territory. The readout names the *pattern* — "5 mid-market deals stuck in Demo Complete" — and lists the top 3 as exemplars.
- **Not a churn-risk dashboard.** Customer-update + the Renewal pipeline read is closer to that need; this skill is about *new business and deal velocity*, not retention.

## Application

### Inputs the user provides

- **Pipeline name or id.** Default: the team's primary new-business pipeline. The skill lists available pipelines if the input is ambiguous.
- **Segment definition** (optional). Default: derive from the company `size` property (e.g. `1-50` = SMB, `51-500` = mid-market, `500+` = enterprise). If the team uses a custom property for segment, name it.
- **ICP claim** (optional, for Section 3). Default: pull from the most recent `type: decision` chronicle entry tagged `positioning` or `icp`. If no chronicle context exists, the readout's Section 3 says "no ICP claim found; skipping fit-pattern test".

### What the skill does

1. **Read pipeline structure.** Call HubSpot to list stages in the named pipeline with their display labels and internal IDs. Map them once for the rest of the run.
2. **Pull deal-state snapshot.** For each open deal: stage, days-in-stage, owner, associated company, associated company size / segment, amount.
3. **Compute baseline** (rolling 90-day median age per stage).
4. **Pull closed-recent.** Deals closed (won or lost) in the last 30 days; time-to-close per deal.
5. **Pull won-recent for ICP test.** Deals closed-won in the last quarter; pull associated company properties (industry, size, region).
6. **Synthesize** into the three-section readout. Each finding cites the underlying number; the readout's *one question* is the question the PM would raise in the next product review if all they had was this readout.

### Cost & rate-limit awareness

HubSpot's standard tier is 100 requests per 10 seconds per private app. A full pipeline readout typically uses 6-12 API calls (one for stages, batched search for open deals, batched property reads, two date-windowed searches for closed deals). Well within the budget. If the portal has 5,000+ open deals, the search-and-paginate cost grows — the skill caps at 500 open deals per stage and flags the truncation.

### Auth and fallback

If the HubSpot MCP server is not connected, the skill surfaces the `curl` recipes from [`resources/hubspot/RESOURCE.md`](../../resources/hubspot/RESOURCE.md) for the three core queries (list stages, search open deals, search closed deals) and stops. The PM runs them, pastes results back, and the skill can synthesize from there — but the structured path is MCP.

## Examples

### Pre-roadmap-call readout

```
# Pipeline readout — New Business — 2026-05-20

## Stage health

| Stage              | Open deals | Median age (days) | 90-day baseline | Drift |
|--------------------|------------|-------------------|-----------------|-------|
| Discovery          | 42         | 4                 | 5               | -1    |
| Demo Complete      | 28         | 11                | 6               | +5 ⚠  |
| Proposal           | 19         | 8                 | 9               | -1    |
| Negotiation        | 14         | 12                | 11              | +1    |
| Verbal Yes         | 7          | 4                 | 5               | -1    |

**Drift finding:** Demo Complete is sitting 5 days longer than the 90-day
baseline. 28 deals affected.

## Segment velocity (last 30 days closed)

| Segment      | Closed | Won | Win rate | Median time-to-close |
|--------------|--------|-----|----------|----------------------|
| SMB          | 22     | 9   | 41%      | 18 days              |
| Mid-market   | 14     | 4   | 29%      | 47 days              |
| Enterprise   | 6      | 3   | 50%      | 89 days              |

**Pattern:** Mid-market win rate is lowest, time-to-close is mid-range. The
stage-health drift in Demo Complete and the mid-market win-rate gap are
consistent with: mid-market deals are getting through demo but losing in
the post-demo gap. (Hypothesis, not conclusion — would need to look at
which stage they're losing in.)

## ICP fit pattern (last quarter, won deals)

Stated ICP (per `2026-03-15-positioning-statement` chronicle entry):
"B2B SaaS companies, 50-500 employees, on AWS, with engineering-led
buying motion."

Of 18 won deals last quarter:
- 12 (67%) match all four criteria.
- 4 match three of four (typically failing on "engineering-led" — sales-led wins).
- 2 are clear outliers (one 1,200-person services firm, one consumer-facing B2B).

Won-deal industry distribution: Fintech (5), Devtools (4), Analytics (3),
HR/Payroll (3), Healthtech (2), Other (1). Devtools and Analytics are
overweight vs the ICP's "engineering-led" claim (suggests claim is
holding); HR/Payroll is the surprise (3 wins in a segment the ICP doesn't
name).

## The question this raises

Is HR/Payroll a real second segment we should formalise, or is it three
wins from one good AE? Worth a 15-minute look at where those three deals
came from before the Q3 ICP review.
```

## Common Pitfalls

1. **Running against a merged pipeline view.** Don't. Each pipeline (New Business, Renewal, Partner) has different stage semantics and time norms. Run them separately.
2. **Citing absolute stage-age numbers without the baseline.** "Demo Complete sits at 11 days" is meaningless. "Demo Complete sits at 11 days vs 6-day baseline" is the finding. Always pair with the comparison.
3. **Treating the segment win rate as a primary metric.** Win rate is noisy under ~30 deals per segment per quarter. Use stage-age drift and time-to-close as the headline signals; win rate is supporting context.
4. **Confusing won-deal industry distribution with TAM.** The won-deal industries are who actually bought, not who's in the addressable market. Use this to validate (or surprise) the ICP claim, not to size the market.
5. **Reading "no ICP claim found" as the skill failing.** It's the skill telling you the company hasn't recorded an explicit ICP and the team is making positioning decisions on intuition. That's a finding for the *next* chronicle entry, not a bug in this readout.
6. **Pulling the readout weekly without acting on it.** If the same drift finding appears three weeks running with no team conversation, the readout has become a ritual. Bring it to the next product review with the question; don't let the data quietly age.
7. **Asking HubSpot to be the source of truth for revenue.** HubSpot is the GTM motion. Booked revenue lives in the billing system. For deal *value*, treat HubSpot as the team's working forecast — directionally right, not auditable.

## References

- [`resources/hubspot/RESOURCE.md`](../../resources/hubspot/RESOURCE.md) — HubSpot MCP capabilities, deal/company/pipeline object model, gotchas, fallback recipes.
- [`skills/positioning-statement/SKILL.md`](../positioning-statement/SKILL.md) — produces the ICP claim Section 3 tests against.
- [`skills/revenue-architecture/SKILL.md`](../revenue-architecture/SKILL.md) — the broader system this pipeline read sits within; revenue-architecture maps the full funnel, this skill is a current-state read on the GTM stage.
- [`skills/saas-revenue-growth-metrics/SKILL.md`](../saas-revenue-growth-metrics/SKILL.md) — for the metric definitions (CAC, LTV, win rate) the readout implicitly draws on.
- [`skills/customer-update/SKILL.md`](../../skills/customer-update/SKILL.md) — when the readout surfaces an at-risk account, the update goes onto the customer's chronicle entry via this skill.
- [`skills/query-warehouse/SKILL.md`](../../skills/query-warehouse/SKILL.md) — when product-usage data needs to be cross-referenced with pipeline state (e.g. "are the at-risk accounts also showing low product engagement?"), the warehouse skill is the read primitive.
