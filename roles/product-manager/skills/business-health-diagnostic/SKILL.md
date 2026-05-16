---
name: business-health-diagnostic
description: Use when a PM needs a structured business-health pass — growth × efficiency × retention × runway — before a strategy debate, a board prep, or a quarterly review, integrating the four SaaS-metrics dimensions into one read.
intent: |
  Synthesises four metric dimensions — growth, efficiency, retention, and
  runway/cash — into a single health read that names the binding constraint
  rather than listing every amber signal. The pass is diagnostic, not
  prescriptive: it tells you which dimension is the load-bearing problem and
  why; it does not output a feature roadmap. Consumes the companion component
  skills saas-revenue-growth-metrics, saas-economics-efficiency-metrics, and
  finance-metrics-quickref as its measurement layer.
type: workflow
theme: finance
best_for:
  - A PM preparing for a board or investor update who needs a single honest read before the slide deck starts
  - A quarterly business review where each function has its own story and nobody has named the binding constraint
  - A strategy or planning session where growth looks fine but something feels off in the numbers
scenarios:
  - "We're 60% YoY growth but burning hard — I need to know whether our unit economics justify the burn before the board ask"
  - "QBR is in two days and we have four different dashboard stories; I need one coherent health pass"
  - "New PM stepping into a Series C product — what does the business actually look like underneath the narrative?"
estimated_time: "60-120 minutes (full pass); 20-30 minutes (focused dimension)"
---

# Business health diagnostic

> v0 draft. Primary grounding: David Skok's SaaS metrics canon, Bessemer Venture Partners Cloud Index benchmarks, OpenView Partners SaaS benchmarking, David Sacks on burn multiple, Bill Gurley on unit-economics-first. Consumes the Hornero component skills `saas-revenue-growth-metrics`, `saas-economics-efficiency-metrics`, and `finance-metrics-quickref`. Synthesis cue adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/business-health-diagnostic) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.

## Purpose

Read the business health across four dimensions — growth, efficiency, retention, and runway/cash — and name the binding constraint: the one dimension whose weakness makes the other three moot.

This is a diagnostic workflow, not a strategy prescription. It tells you *what is true* about the business today, which dimension is most load-bearing, and what signals to watch. The recommendations that follow from that diagnosis belong in `strategy-kernel`, `bet-portfolio`, or `success-metrics` — not here. A health pass that drifts into roadmap recommendations has confused diagnosis with treatment.

The PM altitude here is above the feature plane but below the CFO plane. You are not calculating bond covenants or running scenario-model waterfalls. You are asking: *can this business sustain itself long enough to find or prove its next bet?* That question has an answer in the data, and this skill surfaces it.

## Key Concepts

### The four dimensions

Skok's SaaS metrics canon establishes that a healthy SaaS business must hold four properties simultaneously. They are not independent — each one constrains the others:

**1. Growth** — is the business getting larger fast enough to justify its risk profile and burn? Growth is measured in ARR/MRR absolute and rate (YoY, MoM), new logo velocity, and quick ratio (new MRR / churned MRR). Bessemer's Cloud Index benchmarks by ARR band: at $10M ARR, 80% YoY is the top quartile; at $100M ARR, 50% is top quartile; at $250M+ ARR, 30% sustains a growth-company multiple. Growth without retention is a leaky bucket; growth without unit economics is a bonfire.

**2. Efficiency** — is the growth being purchased at a price the business can sustain? Efficiency's primary signals are the Rule of 40 (growth rate + EBITDA margin; above 40 is a healthy balance), the magic number (net new ARR / prior-quarter S&M spend; above 0.75 means S&M is compounding, below 0.5 means it's burning inefficiently), and gross margin (SaaS norm: 70–80%; below 60% signals infrastructure or COGS problems that compound at scale). David Sacks' burn multiple (net burn / net new ARR) frames the same question from the cash side: a burn multiple above 2.0 means you're spending more than $2 to generate $1 of new ARR — a structural problem, not a temporary phase.

**3. Retention** — is the business keeping what it earns? Retention is the load-bearing mechanic for SaaS compounding. Net Revenue Retention (NRR) is the single most informative retention signal: above 120% means the base is expanding without new logos; below 100% means the base is contracting and every growth metric is fighting a headwind. Monthly gross churn above 3% has a half-life problem: at 3% monthly, you replace 32% of the base annually. Cohort-level retention shapes the diagnosis — a flat average NRR that conceals degrading recent cohorts is a leading indicator that growth or pricing changes have introduced a product-market fit crack.

**4. Runway and cash** — does the business have enough time to find and prove the next inflection? Runway translates all three upstream dimensions into a survival constraint. Sacks frames it simply: if burn multiple is above 2.0 and runway is below 12 months, you are not operating with strategic optionality — you are reacting to the next financing event. Below 6 months of runway, the health diagnostic changes character entirely: it becomes a triage, not a review.

### How the dimensions interact

The dimensions form a dependency chain. Skok and Gurley both emphasise unit-economics-first: you can grow your way into a good Rule of 40 or NRR story only if the unit economics (LTV:CAC, payback period, gross margin) are structurally sound. The diagnostic reads them in dependency order:

1. **Retention first** — a base that is contracting makes growth spend purely defensive.
2. **Unit economics second** — if LTV:CAC is below 2:1 or payback exceeds 24 months, the growth mechanic is broken at the customer level.
3. **Efficiency third** — given the unit economics, is the growth being purchased rationally?
4. **Growth fourth** — given efficiency and retention, is the business growing fast enough for its stage?

Reading them in reverse order (growth first) is how boards get surprised. Strong top-line growth that conceals deteriorating NRR and burn-multiple expansion is one of the most common pre-crisis patterns in SaaS.

### Dashboard order and the health matrix

The health matrix maps each dimension to a traffic-light read using stage-adjusted benchmarks (Bessemer, OpenView):

| Dimension | Early (<$10M ARR) | Growth ($10–50M) | Scale ($50M+) |
|---|---|---|---|
| ARR growth (YoY) | >100% healthy; >50% acceptable | >60% healthy; >30% acceptable | >35% healthy; >20% acceptable |
| NRR | >110% healthy; >100% acceptable | >115% healthy; >100% acceptable | >120% healthy; >110% acceptable |
| LTV:CAC | >3:1 acceptable | >3:1 acceptable; >5:1 healthy | >4:1 acceptable |
| Rule of 40 | n/a (optimise for growth) | >30 acceptable; >40 healthy | >40 required |
| Gross margin | >65% acceptable | >70% acceptable; >75% healthy | >75% required |
| Runway | >12 months | >12 months; >18 months preferred | >12 months |

The benchmarks are directional — they anchor the diagnosis but do not replace judgement about business model, competitive context, or market phase.

### The diagnostic-vs-prescription distinction

The health pass is a diagnosis. Its output is: *here is what is true, here is the binding constraint, here is what to watch.* It does not prescribe the fix. The fix belongs in a kernel (strategy-kernel), a bet (bet-portfolio), a metric design (success-metrics), or an orchestration (cross-functional-orchestration). Conflating diagnosis with prescription is how health passes turn into slide decks full of actions nobody owns.

A useful test: if someone asks "so what do we do?" and your health pass answers that question directly, it has overstepped. The right answer is: "The health pass names the binding constraint; what we do about it is a strategy question."

## Application

Six phases. Estimated PM time: 60–120 minutes for a full pass. Each phase builds on the previous; skipping retention (Phase 2) before reading efficiency (Phase 3) produces a systematically misleading read.

### Phase 1 — Scope the question (10 minutes)

Name the framing before touching any data. What decision or event is this health pass serving? Board prep, QBR, strategy off-site, new-PM orientation? The framing determines which dimensions to prioritise and what "healthy enough" means for this specific moment.

Record:
- **Company stage** — ARR band, months since last raise, months of runway at current burn.
- **The proximate question** — what is the specific decision or event this pass is feeding?
- **What is already known** — any dimensions where the answer is already settled (e.g., "runway is fine; we just closed a round"). Don't re-diagnose certainties.
- **Data access** — which metrics are available vs. estimated. Note gaps; a missing data point is information.

A health pass with no framing question is an audit. An audit is a different artifact.

### Phase 2 — Read retention (15–20 minutes)

Invoke `saas-revenue-growth-metrics` for the retention sub-pass. Read NRR, gross churn, and cohort-level retention in that order.

The diagnostic questions:
- Is NRR above 100%? If below, the base is contracting — every new-logo acquisition is partly defensive, not additive.
- Is monthly gross churn below 3% (early/growth) or 2% (scale)? Above those thresholds, the compounding engine is stressed.
- Are recent cohorts retaining better, worse, or the same as older cohorts? Degrading recent cohorts are the leading indicator of a product-market fit crack or an ICP drift in the sales motion. Stable-but-low NRR is a cost structure problem; degrading NRR is a product or fit problem.

Flag immediately if: NRR < 90%, or recent cohorts are degrading cohort-over-cohort for two or more quarters. These are the conditions under which growth spend produces asymmetric waste.

### Phase 3 — Read unit economics (15–20 minutes)

Invoke `saas-economics-efficiency-metrics` for the unit-economics sub-pass. Read LTV:CAC, payback period, and gross margin.

The diagnostic questions:
- Is LTV:CAC above 3:1? Below 2:1 is the structural failure threshold (Skok): the business is destroying value at the customer level regardless of top-line growth.
- Is payback period below 18 months? Above 24 months means two full years of cash before a customer pays back their acquisition cost — at high burn multiple, this is existential math.
- Is gross margin above 70%? Gross margin below 60% signals a COGS problem that worsens with scale unless deliberately addressed.
- Is CAC trending — improving, stable, or degrading quarter-over-quarter? Degrading CAC is the leading indicator that the highest-efficiency acquisition channels are saturating.

Gurley's unit-economics-first principle: if the unit economics are broken at the customer level, no efficiency or growth intervention fixes them. They must be addressed before growth spend is scaled.

### Phase 4 — Read growth and efficiency (15–20 minutes)

With retention and unit economics established, read growth and efficiency from `saas-revenue-growth-metrics` and `saas-economics-efficiency-metrics`.

**Growth signals:**
- ARR/MRR absolute and YoY growth rate.
- New logo velocity (MoM) — is the acquisition engine growing, stable, or contracting?
- Quick ratio (new MRR / churned MRR) — above 4 is strong; below 2 signals that new acquisition is mostly replacing churn, not compounding.
- Expansion revenue as a fraction of total MRR — above 20% indicates a land-and-expand motion is working.

**Efficiency signals:**
- Rule of 40 (growth % + EBITDA margin). Below 25 is a warning; below 15 is a problem (Bessemer). Note that Rule of 40 is stage-sensitive — below $20M ARR, optimising for Rule of 40 at the expense of growth rate is the wrong trade.
- Magic number. Below 0.5 means S&M is underperforming; above 1.0 means it is compounding strongly and is likely underinvested.
- Burn multiple (Sacks). Below 1.0 is exceptional; above 2.0 is a structural problem; above 3.0 in a growth-stage company is a board-meeting topic.
- S&M and R&D as a percentage of revenue — directional input to operating leverage.

### Phase 5 — Synthesise and name the binding constraint (10–15 minutes)

Read the four dimension results together. Use `finance-metrics-quickref` for any threshold lookups needed. The synthesis has one deliverable: name the binding constraint.

**The binding constraint is the dimension whose weakness makes the other three moot.** A company with 80% YoY growth, Rule of 40 of 50, and 4 months of runway is not healthy — runway is the binding constraint and the growth number is irrelevant until it is resolved. A company with 12:1 LTV:CAC, NRR of 95%, and 24 months of runway has a retention problem as its binding constraint — the unit economics are masking a fit crack that will surface in the cohort data.

The binding constraint determination follows the dependency chain: runway > retention > unit economics > efficiency > growth. The first broken link is the binding constraint.

Write the synthesis in this shape:
- **Overall read** — one word: Healthy / Acceptable / Stressed / Critical.
- **Dimension reads** — one line each (traffic-light + one-sentence diagnosis).
- **Binding constraint** — named explicitly: which dimension, what specific signal, why it is load-bearing.
- **What to watch** — 2–3 leading indicators that would confirm the constraint is worsening or improving.
- **Escalation triggers** — the specific signal values that would change the read from this category to a more critical one.

### Phase 6 — Produce the artifact (10–15 minutes)

Write the health pass artifact. Format:

```markdown
# Business health pass — <company / scope / date>

**Overall read:** <Healthy / Acceptable / Stressed / Critical>

## Dimension reads
- **Growth:** <traffic light> — <one-sentence diagnosis>
- **Retention:** <traffic light> — <one-sentence diagnosis>
- **Unit economics:** <traffic light> — <one-sentence diagnosis>
- **Efficiency:** <traffic light> — <one-sentence diagnosis>
- **Runway/cash:** <traffic light> — <one-sentence diagnosis>

## Binding constraint
<Named dimension, named signal, one paragraph on why it is load-bearing.>

## What to watch
- <Leading indicator 1>: <direction expected if improving / worsening>
- <Leading indicator 2>: <direction expected if improving / worsening>
- <Leading indicator 3>: <direction expected if improving / worsening>

## Escalation triggers
- <Signal>: if it reaches <threshold>, escalate to <action>.

## Data gaps
<Any metrics unavailable or estimated. Gaps are information — name them.>
```

The artifact should not contain recommendations. Recommendations belong downstream in strategy, OKR, or kernel artifacts. If your health pass artifact contains a roadmap, you have overstepped.

### Focused-dimension variant (20–30 minutes)

When a full four-dimension pass is unnecessary — because three dimensions are settled and one is contested — run a focused pass: scope the known dimensions briefly (one sentence per) and invest the full diagnostic time in the single uncertain dimension.

Triggers for a focused pass:
- Post-fundraise: runway is settled; the question is efficiency and growth.
- Pre-QBR retention review: the board has already seen growth and efficiency; the single contested question is whether retention is holding.
- New-PM orientation to a single product line: full company-level health is already documented; the PM needs the retention and unit economics for their surface only.

A focused pass produces the same Phase 6 artifact format, but three of the five dimension reads are one-line summaries with a link to the source data. Only the contested dimension gets a full diagnostic write-up.

## Examples

### Example 1 — Series C SaaS: Rule of 40 passes, unit economics fail (fully worked)

**Context.** A Series C infrastructure SaaS company. ARR: $80M. 18 months post-raise. The pre-board narrative: "We're Rule of 40 compliant at 43, growth is strong at 38% YoY, burn is under control."

**Phase 1 — Scope.** Board prep for Q3 investor update. The question the board will ask: are we on track for the Series D? Data access: full financial system access, customer-level cohort data available.

**Phase 2 — Retention read.**
- NRR: 103%. Above 100% — base is growing. Acceptable for scale stage; below the 110% healthy threshold (Bessemer Scale benchmark).
- Monthly gross churn: 2.1%. At the boundary of acceptable for scale stage.
- Cohort read: 2022 and 2023 cohorts retain at 105% NRR. 2024 cohorts retain at 91% NRR. **Red flag: 14pp degradation in recent cohort NRR.** The blended NRR of 103% is masking a product-market fit crack in the 2024 cohort, which represents 35% of current ARR.

*Retention dimension: Yellow, trending to Red. The blended NRR is acceptable; the cohort deterioration is not.*

**Phase 3 — Unit economics read.**
- LTV:CAC: 2.4:1. Below the 3:1 floor (Skok). The business is generating economic value at the customer level, but the margin of safety is thin.
- Payback period: 22 months. Below the 24-month critical threshold, but above the 18-month healthy target.
- Gross margin: 62%. Below the 70% acceptable floor for scale-stage SaaS (Bessemer). This is the structural source of the thin LTV:CAC — the product has non-trivial infrastructure costs that have not been engineered down.
- CAC trend: degrading 15% quarter-over-quarter for three quarters.

*Unit economics dimension: Red. LTV:CAC is marginal; gross margin is below stage floor; CAC is on a sustained deterioration trend.*

**Phase 4 — Growth and efficiency read.**
- ARR growth: 38% YoY. Acceptable for $80M scale stage (Bessemer benchmark: >35% healthy).
- Quick ratio: 3.2. Acceptable; not strong. New MRR is not overwhelmingly outrunning churn.
- Expansion revenue: 18% of MRR. Below the 25%+ level that signals a strong land-and-expand motion.
- Rule of 40: 43. Passes the threshold. But the math: growth at 38% + EBITDA margin at 5%. The 5% EBITDA margin is narrow and is not in the same direction as the gross-margin pressure in Phase 3.
- Burn multiple: 1.8 (Sacks). Below 2.0 — acceptable. But gross margin at 62% means efficiency is being purchased partly by underinvesting in infrastructure cost reduction.
- Magic number: 0.7. Acceptable range, not exceptional.

*Growth dimension: Green/Yellow. Acceptable at stage; expansion velocity is soft.*
*Efficiency dimension: Yellow. Rule of 40 passes but the composition is fragile — EBITDA margin depends on gross margin holding, which it isn't.*

**Phase 5 — Binding constraint.**

The Rule of 40 read passes. The growth headline passes. The board narrative is defensible — if you stop there.

The binding constraint is unit economics, specifically gross margin compression cascading into LTV:CAC. At 62% gross margin on an $80M ARR base, every dollar of new ARR carries a 38% direct cost burden. The CAC deterioration means acquisition is getting more expensive. The 2024 cohort NRR deterioration means recent customers are retaining worse — likely because the product experience for newer use cases (presumably what the 2024 sales motion targeted) is not matching the product's 2022 core. These are not independent facts; they are the same structural problem read from three angles.

**Overall read: Stressed.** Rule of 40 compliance is real but fragile. The binding constraint — gross margin / unit economics — will compress the EBITDA margin component of Rule of 40 over the next 2–3 quarters as the 2024 cohort matures and as CAC continues to rise. The board narrative is currently accurate; it will not be accurate at the next review unless the unit economics trend reverses.

**What to watch:**
- 2024 cohort NRR at Q4: if it stabilises above 95%, the crack may be recoverable; if it falls below 88%, it is accelerating.
- Gross margin QoQ: any further compression below 60% changes the EBITDA math materially.
- CAC by acquisition channel: if the deterioration is concentrated in one channel (e.g., outbound), the fix is channel reallocation; if it is spread, it is a market-saturation signal.

**Escalation triggers:**
- If 2024 cohort NRR falls below 88% in Q4: escalate to kernel-level strategy review — this is an ICP or product fit question, not an efficiency question.
- If gross margin drops below 58%: escalate to board-level — EBITDA margin goes negative in the Rule of 40 arithmetic, and the compliance story breaks.

---

### Example 2 — Counter-example: Rule of 40 passes, health pass calls it healthy (wrong)

A growth-stage SaaS, $22M ARR, 55% YoY growth, EBITDA breakeven. Rule of 40 = 55. The PM reads the health pass as "Healthy" and briefs the board accordingly.

**What was missed:**

NRR = 88%. The base is contracting. At 55% growth with 88% NRR, 12% of ARR is churning annually — the gross new ARR needed to sustain 55% growth is not 55% of $22M; it is 55% + 12% = 67% new ARR required annually just to post the headline growth rate. The S&M spend required to generate that gross new ARR is embedded in the Rule of 40 calculation but not surfaced by it.

LTV:CAC = 1.9:1. Below the Skok 3:1 floor. The unit economics are broken: for every $1 of customer lifetime value, you are paying $0.53 to acquire them. The Rule of 40 "passes" because the EBITDA near-breakeven conceals the unit-economics failure — EBITDA-near-zero means the company is spending almost everything it earns, including on acquisition that is economically irrational at the unit level.

**The correct health pass output would be:**

```markdown
**Overall read:** Stressed

## Dimension reads
- **Growth:** Yellow — 55% YoY is strong but 12% annual gross churn means 67% gross new ARR is required to post that rate.
- **Retention:** Red — NRR 88%; base is contracting; cohort data not reviewed.
- **Unit economics:** Red — LTV:CAC 1.9:1 (below Skok 3:1 floor); unit destruction at scale.
- **Efficiency:** Yellow — Rule of 40 = 55 passes, but the composition conceals the unit-economics failure.
- **Runway/cash:** Green — 16 months at current burn.

## Binding constraint
Unit economics. LTV:CAC at 1.9:1 means the business destroys value at the customer level before retention
or expansion has a chance to compound. The Rule of 40 passes because near-zero EBITDA masks the problem —
the company is spending almost everything it earns, including on acquisition that does not pay back. Fixing
growth spend or retention before fixing LTV:CAC treats symptoms, not the constraint.
```

**The diagnostic failure:** reading Rule of 40 first (or alone) as a summary health metric. Rule of 40 is an efficiency signal, not a health signal. A company can score Rule of 40 > 40 while having broken unit economics and contracting retention — as this example shows. The health pass must read retention and unit economics before efficiency; the dependency chain is not optional.

## Common Pitfalls

### Pitfall 1 — Rule of 40 as a health summary

**Symptom.** The health pass opens with "Rule of 40 is 45, so we're in good shape," and proceeds to slide into strategy before reading retention or unit economics.

**Consequence.** Skok's unit-economics-first principle is violated. Rule of 40 is a growth-efficiency trade-off signal; it does not encode retention or unit economics. A company can score Rule of 40 > 40 while destroying value at the customer level and contracting its base. See Example 2.

**Fix.** Run retention and unit economics before efficiency. The Rule of 40 read belongs in Phase 4, after Phase 2 and Phase 3 have established whether the growth being measured is structurally sound.

---

### Pitfall 2 — Blended NRR masks cohort deterioration

**Symptom.** NRR is reported as 104% and marked green. No cohort analysis is run. The PM declares retention "healthy."

**Consequence.** A blended NRR above 100% can mask a specific cohort that is deteriorating rapidly. In a growing business, older cohorts (with their expansions) can prop up the blended number while new cohorts signal a product or ICP problem. The Bessemer Cloud Index benchmarks NRR as a blended metric — it is the floor, not the ceiling of the retention diagnostic.

**Fix.** Run cohort-level NRR alongside blended NRR. Two or more quarters of degrading recent-cohort NRR is a red flag even when blended NRR is healthy. Flag this finding explicitly in the health pass.

---

### Pitfall 3 — Diagnosis becomes prescription

**Symptom.** The health pass artifact contains recommendations: "we should improve onboarding to fix NRR" or "we should reallocate S&M budget to content."

**Consequence.** The diagnostic function is conflated with the strategy function. Recommendations in the health pass bypass the strategy process — they arrive without a kernel (no diagnosis → guiding policy → coherent actions), without a bet portfolio (no prioritisation), without a success-metric design. They are intuitions dressed as conclusions.

**Fix.** The health pass artifact produces a named binding constraint and escalation triggers. Recommendations flow from `strategy-kernel` or `bet-portfolio` once the constraint is named. The rule: if someone asks "so what do we do?" and your health pass answers it directly, the pass has overstepped.

---

### Pitfall 4 — Skipping the stage-adjustment

**Symptom.** A $5M ARR company is assessed as "concerning" because its Rule of 40 is 12 and EBITDA is -30%. A $120M ARR company is assessed as "acceptable" because it has 90% YoY growth despite NRR of 91% and burn multiple of 3.1.

**Consequence.** Stage-agnostic benchmarks produce misleading reads in both directions. Early-stage companies should be optimising for growth and unit economics, not profitability. Scale-stage companies should be trending toward efficiency and profitability. Using scale-stage benchmarks on early-stage companies produces false alarms; using early-stage benchmarks on scale-stage companies produces false comfort.

**Fix.** Establish the company stage in Phase 1 before reading any dimension. Use the stage-adjusted benchmark table in Key Concepts. The Bessemer Cloud Index and OpenView SaaS benchmarks are segmented by ARR band for this reason.

---

### Pitfall 5 — Data gaps treated as zeroes

**Symptom.** LTV:CAC is unavailable, so it is assumed neutral or left blank. The health pass proceeds without flagging the gap.

**Consequence.** Unavailable data is treated as "no problem," which is the opposite of the correct inference. A company that cannot produce LTV:CAC, payback period, or cohort NRR has a measurement problem that is itself a health signal — it cannot track the dimensions that matter.

**Fix.** Name data gaps explicitly in the Phase 6 artifact under "Data gaps." A missing unit-economics number is not neutral; it means the company may be flying without instruments on a critical dimension. The absence of measurement is information.

---

### Pitfall 6 — Health pass disconnected from the decision it serves

**Symptom.** A full four-dimension health pass is run and documented. The board asks "are we ready for the Series D conversation?" The health pass does not address that question — it reads all dimensions but names no binding constraint relative to the Series D framing.

**Consequence.** The artifact is comprehensive but not actionable. The PM has produced an audit when a framed diagnostic was needed. The board meeting proceeds without the health pass being a useful input.

**Fix.** Phase 1 scoping is load-bearing. The proximate question — what decision or event does this pass serve? — determines what "binding constraint" means in context. For Series D prep, the binding constraint is whatever dimension is most likely to be the lead objection from growth investors (typically: Rule of 40 trajectory, NRR trend, and LTV:CAC vs. the median Bessemer benchmark for that ARR band). A health pass without a scoped question is an audit; an audit is a different artifact.

## References

- **David Skok** — "SaaS Metrics 2.0" (forEntrepreneurs blog). The canonical unit-economics framework for SaaS: LTV:CAC floor (3:1), payback period thresholds, CAC decomposition, and the growth × retention interaction. Used throughout this skill as the primary benchmark source for unit economics and retention thresholds.
- **Bessemer Venture Partners** — *State of the Cloud* (annual) and Bessemer Cloud Index benchmarks. Stage-adjusted benchmarks for growth rate, NRR, Rule of 40, and gross margin by ARR band. The benchmark table in Key Concepts is drawn from Bessemer's published cohort benchmarks. See [Bessemer Cloud Index](https://cloudindex.bvp.com).
- **OpenView Partners** — SaaS benchmarking reports (annual). Independent benchmarks on growth rate, NRR, magic number, and payback period segmented by ARR and go-to-market motion (PLG vs. sales-led). Used for cross-referencing Bessemer benchmarks on efficiency metrics.
- **David Sacks** — Burn multiple framing (Craft Ventures writing, 2020). Burn multiple (net burn / net new ARR) as the capital-efficiency signal. Thresholds: below 1.0 exceptional, 1.0–1.5 good, 1.5–2.0 acceptable, above 2.0 concerning, above 3.0 problematic. Used in Phase 4 efficiency read.
- **Bill Gurley** — "All Revenue is Not Created Equal" (Above the Crowd blog, 2011). Unit-economics-first framing: the quality of revenue (gross margin, retention, CAC payback) determines the value of growth. The dependency chain in Key Concepts (unit economics before efficiency before growth) is grounded in Gurley's revenue-quality argument.
- **Nir Eyal & Guthrie Weinschenk** (Doshi, *Measure What Matters*, indirectly via success-metrics framing) — the prioritisation overlay: health dimensions translate to metric ownership. Each dimension names a leading indicator; the leading indicator names a metric owner. Referenced lightly in Phase 6 artifact design.
- **Companion Hornero component skills** — this workflow skill consumes three component skills as its measurement layer. They must be available for the health pass to run at full fidelity:
  - [`saas-revenue-growth-metrics`](../saas-revenue-growth-metrics/SKILL.md) — growth and retention metrics: ARR/MRR, NRR, quick ratio, cohort analysis. Used in Phase 2 and Phase 4.
  - [`saas-economics-efficiency-metrics`](../saas-economics-efficiency-metrics/SKILL.md) — unit economics and capital efficiency: LTV:CAC, payback period, gross margin, Rule of 40, magic number, burn multiple. Used in Phase 3 and Phase 4.
  - [`finance-metrics-quickref`](../finance-metrics-quickref/SKILL.md) — fast-lookup reference for metric definitions, formulas, and benchmark thresholds. Used in Phase 5 synthesis for threshold cross-checks.
- **Related Hornero workflow and component skills:**
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the downstream artifact for binding-constraint findings. When the health pass names a binding constraint, strategy-kernel is where the guiding policy and coherent actions for addressing it belong.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — when the health pass surfaces multiple stressed dimensions, bet-portfolio is the prioritisation instrument for deciding which constraint to attack first.
  - [`success-metrics`](../success-metrics/SKILL.md) — the leading indicators named in the health pass artifact are inputs to a success-metrics design. The health pass names what to watch; success-metrics names how to instrument and own it.
  - [`cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — when the binding constraint requires a cross-functional response (e.g., unit economics problem that spans pricing, product, and S&M), orchestration is the execution layer.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/business-health-diagnostic) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
