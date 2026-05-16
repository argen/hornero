---
name: finance-metrics-quickref
description: Use when a PM needs a one-page lookup of the ~30 SaaS finance metrics they are expected to read — definition, formula, healthy range, common misread — to bring to a board prep, a CFO review, or a strategy debate without embarrassing themselves or misreading the numbers.
intent: |
  A fast-lookup reference covering the ~30 SaaS finance metrics that appear in
  board decks, investor updates, and strategy reviews. Not a teaching tool — a
  cheat sheet with enough opinionation to catch common misreads on the spot.
  Paired with companion skills for deeper coverage of revenue-growth and
  unit-economics metric families.
type: component
theme: finance
best_for:
  - Board prep and CFO reviews where you need a formula or benchmark fast
  - Strategy docs where you need to make a defensible financial claim
  - Diagnosing a dashboard you haven't seen before under time pressure
scenarios:
  - "I'm in a board meeting and the CFO mentions burn multiple — what am I hearing?"
  - "I'm writing a strategy doc and need to claim our LTV/CAC is healthy — what should that look like?"
  - "The CEO just asked me what our NRR says about retention quality — what do I say?"
estimated_time: "5-10 minutes (lookup); 30-45 minutes (full read of an unfamiliar dashboard)"
---

# Finance metrics quickref

> v0 draft. Primary sources: David Skok (For Entrepreneurs / Matrix Partners), Bessemer Venture Partners Cloud Index (Mamoon Hamid, Byron Deeter), OpenView Partners SaaS Benchmarks, Jason Lemkin (SaaStr). Revenue recognition anchored to ASC 606.

## Purpose

When a CFO drops a term in a meeting, or when you need to anchor a strategy claim with a number, this reference gets you there in under two minutes. It covers the ~30 SaaS finance metrics that a PM is expected to be conversant with — organized by category, with the formula, the healthy range by company stage, and the misread that trips people up most often.

This is a lookup artifact. The Application section IS the table. Read it the way you'd read a dictionary: route by family, find the metric, extract the formula, check the benchmark, note the misread.

PMs are regularly in rooms where financial metrics are used to justify or challenge decisions — feature investments, pricing changes, channel bets, headcount. The cost of misreading NRR, conflating LTV with revenue, or citing a benchmark from the wrong company stage is credibility. This reference exists to prevent that.

Use this to look things up. For the reasoning behind the metrics — why CAC payback compounds the way it does, or how cohorted NRR exposes problems that blended NRR hides — see `saas-revenue-growth-metrics` and `saas-economics-efficiency-metrics`.

## Key Concepts

### Five metric families

SaaS finance metrics cluster into five questions. Route to the right family first, then find the metric.

| Family | The question it answers | Key metrics |
|---|---|---|
| **Revenue & Growth** | How much and how fast? | ARR/MRR, ARPU, ARPA, ACV, Revenue Growth Rate |
| **Retention** | How sticky is the base? | Logo Churn, NRR (Net Revenue Retention), Quick Ratio, Expansion Revenue |
| **Unit Economics** | Does each customer make money? | CAC, LTV, LTV:CAC, Payback Period, Gross Margin |
| **Efficiency** | How well does growth convert to value? | Rule of 40, Magic Number, Burn Multiple, Operating Leverage |
| **Capital & Survival** | How long can you operate? | Burn Rate, Runway, Working Capital |

### Picking the right metric for the question

- **Prioritizing a feature investment** → start with Gross Margin and Expansion Revenue to understand the margin and upsell context; LTV impact for retention-driving work.
- **Challenging or defending a pricing change** → ARPA, NRR, and Churn Rate; model the contraction risk before claiming the ARPA win.
- **Scaling or killing an acquisition channel** → CAC by channel, LTV:CAC, Payback Period, NRR by cohort. Magic Number for overall S&M efficiency.
- **Reading a board deck cold** → ARR growth rate, NRR, LTV:CAC, Rule of 40, Burn Rate. Those five expose the shape of the business in under five minutes.
- **Evaluating business health by stage** → the cut-offs shift. Skok ("SaaS Metrics 2.0") and the Bessemer Cloud Index both tier benchmarks by ARR scale; see the Application table.

### Stage matters: the same number means different things at different scales

Benchmarks are stage-dependent. A 60% YoY growth rate is disappointing for a $2M ARR business and exceptional for a $50M ARR business. Skok's "SaaS Metrics 2.0" and the Bessemer Cloud Index both tier their benchmarks explicitly by ARR band. The Application table carries stage context per metric. Two heuristics for navigating this:

- **Early stage (<$10M ARR):** growth rate and gross margin are the load-bearing metrics. Rule of 40, burn multiple, and Magic Number are directional signals, not gatekeepers.
- **Growth and scale (>$25M ARR):** retention quality (NRR, cohort curves) and capital efficiency (Rule of 40, burn multiple, Magic Number) become primary. Raw growth rate matters less; sustainable, efficient growth matters more.

OpenView's annual benchmarks publish NRR, CAC payback, and growth rate distributions broken down by ARR band — the cleanest source for stage-appropriate comparisons.

### How to read a board deck cold in five minutes

If you're dropped into an unfamiliar deck, pull these five in order:

1. **ARR and ARR growth rate** — absolute scale and trajectory.
2. **NRR** — is the base expanding or contracting? >100% means growth doesn't require as much new acquisition.
3. **LTV:CAC and payback period** — unit economics; does acquiring customers create or destroy value?
4. **Rule of 40** — efficiency posture; where does the business sit on the growth-vs-profitability spectrum?
5. **Burn rate and runway** — survival; how long can the business sustain current operations?

Those five give you the shape of the business. Everything else in the deck is context, segmentation, or detail.

### GAAP vs. non-GAAP: the background radiation problem

Most SaaS metrics are non-GAAP constructs — they live outside formal financial statements. ARR, NRR, CAC, LTV, and Rule of 40 are all company-defined. Two companies can report the same number with entirely different inclusion rules (fully-loaded CAC vs. marketing-only CAC; gross-margin-adjusted LTV vs. revenue-only LTV). Before citing a benchmark, check whether the benchmark's definition matches your company's definition. Skok flags this explicitly; OpenView's annual benchmarks include methodology notes for exactly this reason.

ASC 606 governs when revenue can be recognized (binding for public companies and any company using GAAP-compliant financials). The metric most often tripped up by ASC 606 is ARR: contracted but unearned revenue is not revenue. A PM citing ARR in a strategy doc should confirm whether the figure is contracted ARR or recognized ARR.

## Application

The table below is the reference artifact. Metrics are grouped by family. Formula notation uses plain algebra. "Stage benchmarks" reference Skok's SaaS Metrics 2.0, the Bessemer Cloud Index, and OpenView's annual SaaS benchmarks — cited at the end.

Before scanning the table, anchor on one question: what decision or claim does this lookup serve? The family routing in Key Concepts narrows from 30 metrics to 4–6. Then the table gives you the formula, the benchmark, and the most common misread for that specific metric.

### Stage-by-stage health snapshot

Use this to quickly assess whether the numbers you're looking at are appropriate for the company's scale. Metrics that are amber at one stage may be red at the next.

| Signal | Early (<$10M ARR) | Growth ($10–50M ARR) | Scale (>$50M ARR) |
|---|---|---|---|
| ARR growth rate | >80% is strong | >50% is strong | >30% is strong |
| NRR | >100% baseline; >110% excellent | >110% baseline; >120% excellent | >120% baseline; >130% top-quartile |
| Gross margin | >65% acceptable; >75% healthy | >70% acceptable; >80% healthy | >75% with path to 85%+ |
| CAC payback | <18 months acceptable | <15 months target | <12 months expected |
| Rule of 40 | Directional only | >40 target | >40 required |
| Runway | >12 months | >18 months | Self-funded or >24 months |

Sources: Bessemer Cloud Index (ARR growth, NRR), OpenView SaaS Benchmarks (CAC payback, Rule of 40), Skok "SaaS Metrics 2.0" (gross margin, payback).

---

---

### Revenue & Growth

| Metric | One-line definition | Formula | Stage benchmark | Common misread | Related |
|---|---|---|---|---|---|
| **ARR** (Annual Recurring Revenue) | The annualized run-rate of contracted, recurring subscription revenue | MRR × 12 | Growth rate: >100% at <$5M; >50% at $5-25M; >30% at $25-100M (Bessemer) | Treating one-time or professional-services revenue as ARR inflates the figure; ASC 606 recognized vs. contracted confusion | MRR, ACV |
| **MRR** (Monthly Recurring Revenue) | The monthly slice of ARR; the base unit for tracking revenue changes in real time | Σ active subscription MRR | Track components: new, expansion, contraction, churned | Using cash receipts instead of subscription value; annual contracts divided by 12 is correct | ARR |
| **Revenue Growth Rate** | How fast ARR is compounding | (ARR_end − ARR_start) / ARR_start × 100 | Bessemer T2D3 benchmark: triple-triple-double-double-double from $2M ARR onward | YoY vs. QoQ comparisons are not equivalent; pick one and hold it | ARR |
| **ARPU** (Average Revenue Per User) | Average monthly or annual revenue per individual user | Total Revenue / Total Users | Varies by model; track the trend, not the absolute | Confusing users with accounts; ARPU understates account-level value for multi-seat products | ARPA |
| **ARPA** (Average Revenue Per Account) | Average revenue per paying customer account — the right unit for B2B | MRR / Active Accounts | SMB: $100–$1K/mo; Mid-market: $1K–$10K/mo; Enterprise: $10K+/mo | Using ARPU when the product is seat-based; underrepresents revenue per buying relationship | ARPU, ACV |
| **ACV** (Annual Contract Value) | Annualized value of a single contract — standard unit for enterprise sales | Total Contract Value / Contract Duration in Years | SMB: $5K–$25K; Mid-market: $25K–$100K; Enterprise: $100K+ | Including one-time setup fees; ACV should reflect recurring commitment only | ARR, ARPA |
| **Expansion Revenue** | Additional revenue from existing customers via upsells, cross-sells, or usage growth | Sum of MRR uplift from existing accounts in period | Healthy SaaS: expansion is 20–30% of new bookings (Skok) | Counting re-activations as expansion; counting seat renewals at flat rate | NRR |

---

### Retention

| Metric | One-line definition | Formula | Stage benchmark | Common misread | Related |
|---|---|---|---|---|---|
| **Logo Churn Rate** | Share of customers lost in a period — counts departures, not dollars | (Customers lost in period / Customers at period start) × 100 | Monthly: <2% excellent, <5% acceptable; Annual: <10% excellent | Masking customer losses behind dollar expansion; NRR can be >100% while logo churn is catastrophic for SMB books | NRR, Quick Ratio |
| **NRR** (Net Revenue Retention) | Whether the existing customer base is growing or shrinking in revenue — the single most important retention metric | (Starting ARR + Expansion − Contraction − Churn) / Starting ARR × 100 | >120% excellent (Bessemer top-quartile); 100–120% healthy; 90–100% acceptable; <100% base is eroding | Using gross retention (no expansion) and calling it NRR; the gross vs. net distinction is material at board level | Logo Churn, Quick Ratio |
| **Gross Revenue Retention (GRR)** | NRR with expansion removed — shows pure retention floor, no expansion offset | (Starting ARR − Contraction − Churn) / Starting ARR × 100 | >90% excellent; 80–90% acceptable | Conflating GRR and NRR; GRR can never exceed 100%, NRR can. When they diverge sharply, expansion is masking a retention problem | NRR |
| **Quick Ratio** | How efficiently the business is growing — new and expansion MRR gained per unit of MRR lost | (New MRR + Expansion MRR) / (Churned MRR + Contraction MRR) | >4: excellent; 2–4: healthy; <2: leaky bucket (Mamoon Hamid, Bessemer) | Treating a high Quick Ratio as proof of health when the denominator is small; a 5:1 ratio on $10K of churn is not the same as 5:1 on $500K | NRR, Logo Churn |
| **Cohort Retention** | Retention tracked within the group of customers who started in the same period — exposes improvement or degradation over time | Revenue retained at month N / Revenue at cohort start × 100 | Newer cohorts should perform equal to or better than older ones | Reporting blended averages instead of cohort curves; aggregate NRR hides declining newer cohorts | NRR, LTV |

---

### Unit Economics

| Metric | One-line definition | Formula | Stage benchmark | Common misread | Related |
|---|---|---|---|---|---|
| **Gross Margin** | Share of revenue remaining after direct delivery costs (hosting, support, third-party services) | (Revenue − COGS) / Revenue × 100 | SaaS: 70–85% healthy; 60–70% acceptable; <60% investigate COGS structure | Including R&D or S&M in COGS; COGS is delivery cost only, not development cost | Contribution Margin, LTV |
| **CAC** (Customer Acquisition Cost) | What it costs to acquire one new customer — the number that has the most definitions | Total Sales & Marketing spend in period / New customers acquired in same period | Varies by segment; the benchmark is LTV:CAC, not CAC alone | Using marketing-only spend (lean CAC) vs. fully-loaded CAC including sales salaries, tools, commissions; the two can differ by 2–4×. Always state which one you're using | LTV, Payback Period |
| **LTV** (Customer Lifetime Value) | Total gross profit expected from a customer over their lifetime — the revenue the CAC must be measured against | ARPA × Gross Margin % / Monthly Churn Rate | Must be ≥3× CAC (Skok); track by segment, not blended | Using revenue-only LTV (no margin adjustment); overstating LTV by using too-low a churn rate for the denominator | CAC, LTV:CAC |
| **LTV:CAC** | The ratio that captures whether the unit economics work — the lens through which investors read a growth business | LTV / CAC | 3:1 healthy; 5:1+ may indicate underinvestment in growth; <1.5:1 unsustainable | Treating any positive ratio as sufficient without checking the payback period; a 4:1 ratio with a 36-month payback still creates a cash problem | LTV, CAC, Payback |
| **CAC Payback Period** | How many months of gross profit it takes to recover the cost of acquiring a customer | CAC / (Monthly ARPA × Gross Margin %) | <12 months: excellent; 12–18 months: acceptable; >24 months: cash trap (Skok, OpenView) | Using revenue (not gross profit) in the denominator; this inflates apparent payback speed. Also: ignoring that long payback strains runway even at healthy LTV:CAC | LTV:CAC, Runway |
| **Contribution Margin** | Revenue minus all variable costs — the floor of per-customer profitability | (Revenue − Variable Costs) / Revenue × 100 | 60–80% healthy for SaaS; <40% investigate variable cost structure | Confusing with gross margin; contribution margin includes variable S&M and support costs that gross margin excludes | Gross Margin |

---

### Efficiency

| Metric | One-line definition | Formula | Stage benchmark | Common misread | Related |
|---|---|---|---|---|---|
| **Rule of 40** | A single number combining growth rate and profitability margin — the efficiency yardstick for growth-stage and later companies | Revenue Growth Rate % + Profit Margin % | >40: healthy; 25–40: acceptable; <25: investigate. More meaningful at >$25M ARR (OpenView) | Defining profit margin inconsistently (EBITDA vs. FCF vs. net income); the denominator changes the number materially. Below $10M ARR, prioritize growth over Rule of 40 | Magic Number, Operating Leverage |
| **Magic Number** | How much incremental ARR a dollar of S&M spend generates — the efficiency test for the go-to-market engine | (Q Revenue − Q-1 Revenue) × 4 / Q-1 S&M Spend | >0.75: efficient, consider increasing spend; 0.5–0.75: acceptable; <0.5: GTM is broken, do not scale | Using non-recurring revenue in the numerator; using total OpEx instead of S&M in the denominator | Rule of 40, CAC |
| **Burn Multiple** | How much cash the business burns per dollar of net new ARR — the capital-efficiency lens for early-stage companies | Net Cash Burned / Net New ARR Added | <1×: excellent; 1–1.5×: good; 1.5–2×: acceptable; >2×: concerning (David Sacks / SaaStr context) | Conflating with burn rate (burn multiple is a ratio; burn rate is an absolute); burn multiple is most useful pre-Rule-of-40 | Burn Rate, ARR |
| **Operating Leverage** | Whether revenue is growing faster than operating expense — the test that growth is producing efficiency, not just cost | Revenue Growth Rate vs. OpEx Growth Rate (compare the two; positive when revenue grows faster) | Revenue should grow faster than OpEx at any stage past early product-market fit | Treating cost additions as investment without requiring a measurable return; operating leverage is a ratio test, not a justification for headcount | Rule of 40 |
| **Revenue Concentration** | How dependent total revenue is on the largest customers | Top-N customer revenue / Total Revenue × 100 | Top customer: <10%; Top 10 customers: <40% | Ignoring concentration when NRR looks healthy; high NRR driven by one large customer creates existential risk | ARR, NRR |

---

### Capital & Survival

| Metric | One-line definition | Formula | Stage benchmark | Common misread | Related |
|---|---|---|---|---|---|
| **Burn Rate** | Net cash consumed per month | Monthly Cash Out − Monthly Cash In (operating basis) | Early: <$200K/mo manageable; growth: context-dependent; any stage: net burn accelerating without revenue acceleration is a warning | Gross burn vs. net burn; gross burn ignores revenue entirely. Net burn is the operational figure | Runway, Burn Multiple |
| **Runway** | How many months until cash runs out at current burn | Cash Balance / Monthly Net Burn | >18 months: comfortable; 12–18: watch; 6–12: plan a raise or cuts; <6: survival mode | Using trailing average burn in a month when burn is accelerating; static runway calculation overstates time available | Burn Rate |
| **Working Capital** | Whether the business collects revenue before or after it pays its bills — the cash-timing dimension | Current Assets − Current Liabilities; in SaaS, specifically: annual prepay vs. monthly billing | Annual upfront billing converts deferred revenue into a working capital advantage; monthly billing creates a persistent gap | Assuming positive NRR solves cash timing; a fast-growing SaaS on monthly billing can run out of cash while profitable on paper | Burn Rate, Runway |

---

### Supporting metrics

| Metric | One-line definition | Formula | Note |
|---|---|---|---|
| **CAC by Channel** | Per-channel acquisition cost — reveals which channels are efficient and which destroy unit economics | Channel S&M Spend / Channel New Customers | Always compare to channel-specific LTV and NRR; blended CAC hides broken channels |
| **Revenue Mix** | Share of total revenue from each product, segment, or channel | Segment Revenue / Total Revenue × 100 | Flag when any single segment exceeds 60%; diversification is a portfolio risk concern |
| **Gross vs. Net Revenue** | Net revenue removes discounts, refunds, and credits | Gross Revenue − Discounts − Refunds − Credits | Relevant when comparing to public comps; most SaaS internal metrics use net |

---

## Examples

### Worked lookup 1 — "I'm in a board meeting and the CFO mentions burn multiple"

You hear: "Our burn multiple last quarter was 1.8×."

**What you're hearing.** For every dollar of net new ARR the company added, it burned $1.80 in cash. The burn multiple is a capital-efficiency ratio — it measures the cost of growth in cash terms. A 1.8× figure sits in the "acceptable" zone by common benchmarks (Sacks/SaaStr framing: below 2× is manageable, below 1× is excellent).

**The follow-up question that matters.** Is net new ARR accelerating or decelerating? A 1.8× burn multiple in a quarter where ARR growth is compounding is very different from 1.8× in a quarter where growth is slowing — in the second case, the next quarter's burn multiple will be worse. Also worth asking: is this gross-burn-only or net? Presenters sometimes quote gross burn multiple, which ignores revenue and looks worse.

**The misread to avoid.** Don't conflate burn multiple with burn rate. Burn rate is absolute monthly cash consumption. Burn multiple is a ratio. A company with a $2M/mo burn rate and fast ARR growth can have a better burn multiple than a company burning $200K/mo with stagnant ARR.

---

### Worked lookup 2 — "I'm writing a strategy doc and need to claim LTV/CAC is healthy"

You want to write: "Our LTV:CAC of 4.2:1 demonstrates healthy unit economics."

**What the claim requires.** A defensible LTV:CAC claim needs three things to hold up in a CFO review:

1. **LTV is gross-margin-adjusted.** LTV = ARPA × Gross Margin % / Monthly Churn Rate. If you've used revenue-only LTV (no margin), the ratio is overstated and a CFO will catch it.
2. **CAC is fully loaded.** Fully-loaded CAC includes sales salaries, commissions, marketing spend, and S&M tooling. If you've used marketing-only spend, your CAC is understated — potentially by 2–4× — and the ratio collapses under scrutiny.
3. **Payback period is not a problem.** A 4.2:1 ratio with a 30-month payback is not healthy from a cash perspective. State the payback period alongside the ratio, or expect the question.

**What the claim should look like.** "Our LTV:CAC is 4.2:1 on a fully-loaded CAC basis and gross-margin-adjusted LTV, with an 18-month payback period — within the 12–18 month acceptable range at our stage." That claim is defensible. "Our LTV:CAC is 4.2:1" without those qualifications is an invitation to be questioned.

### Worked lookup 3 — "The CEO just asked what our NRR says about retention quality"

You hear: "Our NRR is 108% — is our retention healthy?"

**What 108% NRR tells you.** The existing customer base grew 8% in revenue over the measurement period, net of churn and contraction. That means expansion (upsells, cross-sells, usage growth) is more than offsetting the revenue leaving. This is generally healthy — above 100% means the base is self-compounding without new acquisition.

**What 108% NRR does NOT tell you.** It does not tell you about logo health. A 108% NRR can coexist with 25% annual logo churn if the surviving customers expand aggressively. In an SMB-heavy book, losing 25% of your customers annually is a structural problem even if the dollars net out. It also does not tell you whether NRR is improving or deteriorating — you need the cohort view.

**The two questions to ask immediately.** First: what is the gross revenue retention (GRR)? If GRR is 85% and NRR is 108%, expansion is masking significant base erosion. Second: what does the cohort curve look like? If the most recent cohorts are at 95% NRR and older cohorts are at 115% NRR, the blended 108% is hiding a deteriorating product-market fit.

**Retention is healthy when:** NRR is above 100%, GRR is above 90%, logo churn is below the stage benchmark, and newer cohorts are performing at or above older ones. 108% NRR alone is a partial answer.

---

## Common Pitfalls

### Pitfall 1 — Gross vs. net revenue retention conflation

**Symptom.** A board deck or strategy doc claims "115% retention" without specifying gross or net.

**Consequence.** NRR (net) includes expansion; GRR (gross) excludes it. A business can report 115% NRR while losing 20% of its customer logos per year — if the surviving customers expand enough to offset the losses. In an SMB business where lost logos are hard to replace, that hides a structural problem. In an enterprise business where logos rarely churn, NRR is the right primary metric. The confusion leads to the wrong diagnosis.

**Fix.** Always qualify: net or gross. GRR can never exceed 100%; NRR can. When a presenter claims "115% retention" without qualification, ask which one they mean before drawing any conclusion.

---

### Pitfall 2 — Lean CAC vs. fully-loaded CAC

**Symptom.** LTV:CAC looks healthy on paper. In due diligence, the ratio collapses.

**Consequence.** Marketing-only CAC excludes sales headcount, commissions, and tooling — and can understate the true acquisition cost by 2–4×. A product with $600 marketing CAC can have $2,000 fully-loaded CAC once a sales rep is involved. Strategy claims built on lean CAC produce unit-economics ratios that experienced investors or CFOs will immediately probe.

**Fix.** State the CAC definition you're using every time you cite it. For strategy docs, default to fully-loaded. For channel comparisons, keep the definition consistent across channels.

---

### Pitfall 3 — Aggregate vs. cohorted metrics

**Symptom.** Blended NRR, blended churn rate, and blended CAC payback all look stable. Yet the business is deteriorating.

**Consequence.** Aggregates mix older cohorts — whose retention has stabilized — with newer cohorts that may be churning faster. A company at 110% blended NRR where the last two quarters' cohorts are at 88% has a serious product-fit problem that aggregate numbers actively hide. Skok's guidance on cohort analysis is explicit: deteriorating cohort curves signal PMF degradation long before aggregate metrics show it.

**Fix.** Track cohorts. At minimum, break NRR and churn into "last 12 months' cohorts" vs. "prior cohorts." If newer cohorts are performing worse, that's the story — not the blended number.

---

### Pitfall 4 — Rule of 40 applied too early

**Symptom.** A <$10M ARR team is optimizing for Rule of 40, cutting spend to improve the profitability component.

**Consequence.** The Rule of 40 is a growth-efficiency yardstick that is meaningful at scale — OpenView's benchmarks suggest it becomes the primary efficiency lens at $25M+ ARR. Below that, growth rate dominates. Cutting growth spend to hit Rule of 40 at Series A trades long-term positioning for a metric that doesn't apply yet.

**Fix.** Use Rule of 40 as a directional sanity check pre-scale, not as a target. Below $10M ARR, prioritize growth rate, gross margin, and LTV:CAC. Rule of 40 becomes a primary KPI at the growth stage.

---

### Pitfall 5 — Burn multiple and burn rate conflated

**Symptom.** "We have a low burn rate, so our capital efficiency is good."

**Consequence.** Burn rate is absolute ($X/mo cash consumed). Burn multiple is a ratio ($X burned per dollar of net new ARR). A company burning $100K/mo with no ARR growth has a worse burn multiple than a company burning $2M/mo with aggressive ARR compounding. The two answer entirely different questions: burn rate answers "how long until we run out of money"; burn multiple answers "are we spending efficiently to grow."

**Fix.** Report both separately. If a CFO cites one, ask about the other. A low burn rate is not a proxy for capital efficiency.

---

### Pitfall 6 — LTV:CAC without the payback period

**Symptom.** A strategy doc cites LTV:CAC of 4:1 to claim healthy unit economics.

**Consequence.** An acceptable LTV:CAC can mask a cash trap. A 4:1 ratio with a 36-month payback means the business is cash-constrained for three years per cohort. Even if the economics eventually close, the runway and cash implications are severe. Lemkin (SaaStr) has noted that many early-stage SaaS businesses with good LTV:CAC struggle operationally because payback is so long that growth consumes cash faster than retention replenishes it.

**Fix.** Always pair LTV:CAC with payback period. The target combination is LTV:CAC ≥3:1 AND payback ≤18 months. Either metric alone is incomplete.

---

## References

- **David Skok** (For Entrepreneurs / Matrix Partners) — "SaaS Metrics 2.0" is the canonical treatment of CAC, LTV, payback period, and cohort analysis for SaaS businesses. The LTV:CAC thresholds (3:1 floor, 5:1+ signals underinvestment), payback benchmarks (<12 months excellent, >24 months cash trap), and fully-loaded CAC discipline in this skill trace directly to Skok's work. See: [forentrepreneurs.com/saas-metrics-2](https://www.forentrepreneurs.com/saas-metrics-2/).
- **Mamoon Hamid & Byron Deeter** (Bessemer Venture Partners) — Bessemer Cloud Index and annual "State of the Cloud" reports. Source for NRR benchmarks (>120% top-quartile), the Quick Ratio (Hamid's popularisation of the >4 threshold), and T2D3 growth benchmarks. See: [bvp.com/atlas/state-of-the-cloud](https://www.bvp.com/atlas/state-of-the-cloud).
- **OpenView Partners** — Annual SaaS Benchmarks report. Source for Rule of 40 stage-gate (>$25M ARR), CAC payback benchmarks by stage, and NRR by ARR band. Methodology notes for each metric are a useful check against your company's definitions. See: [openviewpartners.com/saas-benchmarks](https://openviewpartners.com/saas-benchmarks/).
- **Jason Lemkin** (SaaStr) — SaaStr Annual SaaS benchmarking surveys and blog. Source for logo churn benchmarks, expansion revenue share targets, and the practical PM-level interpretation of what "healthy" looks like at different stages. See: [saastr.com](https://www.saastr.com).
- **ASC 606** (FASB / IASB) — Revenue from Contracts with Customers. The accounting standard governing when SaaS revenue can be recognized. Relevant when distinguishing contracted ARR from recognized revenue, and when ensuring GAAP-compliant financials match non-GAAP ARR reporting.
- **Related Hornero skills:**
  - [`saas-revenue-growth-metrics`](../saas-revenue-growth-metrics/SKILL.md) — deep coverage of the revenue and retention family (MRR/ARR components, NRR mechanics, expansion analysis).
  - [`saas-economics-efficiency-metrics`](../saas-economics-efficiency-metrics/SKILL.md) — deep coverage of unit economics and capital efficiency (CAC build-up, LTV modeling, burn analysis).
  - [`business-health-diagnostic`](../business-health-diagnostic/SKILL.md) — uses the metrics in this skill to diagnose overall business health stage by stage.
  - [`feature-investment-advisor`](../feature-investment-advisor/SKILL.md) — applies gross margin, LTV, and contribution margin to evaluate feature ROI.
  - [`finance-based-pricing-advisor`](../finance-based-pricing-advisor/SKILL.md) — applies ARPA, NRR, and churn to price change decisions.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/finance-metrics-quickref) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
