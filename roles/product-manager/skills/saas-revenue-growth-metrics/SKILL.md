---
name: saas-revenue-growth-metrics
description: Use when a PM needs to read or critique SaaS top-of-funnel + retention metrics — ARR, NRR, GRR, CAC payback, magic number, expansion levers — without bluffing past finance.
intent: |
  Builds fluency in the SaaS revenue metric stack — from how ARR is composed
  to how NRR, GRR, and CAC payback interact at scale — so a PM can read a
  board-ready dashboard, spot which numbers are likely massaged, and know when
  to push back or escalate. This is a reading skill, not a computation skill:
  the PM does not build the model from scratch; they interrogate it.
type: component
theme: finance
best_for:
  - Reading a SaaS revenue dashboard before a board or investor review
  - Identifying which growth metrics are healthy and which mask structural problems
  - Knowing when a "good number" in one metric is actually a warning sign in another
scenarios:
  - "I'm sitting in a QBR and the CFO says NRR is 108% — what should I be asking?"
  - "Our ARR is growing 40% YoY but CAC payback just crossed 30 months — is that a problem?"
  - "Leadership is celebrating a magic number of 0.9 — do I push back?"
estimated_time: "45–75 minutes"
---

# SaaS revenue growth metrics

> v0 draft. Anchored in David Skok (*For Entrepreneurs*, "SaaS Metrics 2.0"), OpenView Partners SaaS Benchmarks, Tomasz Tunguz (Theory Ventures blog), and Jason Lemkin (SaaStr). Peer review recommended before production use in a finance-facing context.

## Purpose

Give a PM the vocabulary and reading instincts to work with a SaaS revenue dashboard — without pretending to be the CFO.

The skill covers the growth-facing metric stack: how ARR is built from its components, what NRR and GRR actually measure and how they diverge, what CAC payback and the magic number tell you about sales efficiency, and how the quick ratio shows whether growth is structurally sound or a leaky bucket dressed in good headline numbers.

Distinct from `saas-economics-efficiency-metrics` (margins, burn, LTV:CAC) and `finance-metrics-quickref` (lookup table): this skill is about the *growth* side of the dashboard — acquiring and expanding revenue — and the judgment calls a PM needs to make when reading it. It pairs with `business-health-diagnostic`, which synthesises both the growth stack and the efficiency stack into an overall signal.

The PM does not compute these metrics from first principles. Finance does. The PM's job is to read them critically: know what healthy looks like at different stages, spot the typical misreads, and know when a number deserves a harder question.

## Key Concepts

### Bookings vs. revenue vs. ARR

These three terms are used interchangeably in many startup reviews. They are not interchangeable.

- **Bookings** — the total contract value signed in a period. A customer signs a $120K two-year deal in January: that is $120K in bookings. It is not yet revenue.
- **Revenue** (GAAP) — the portion earned in a period. That same $120K deal earns $5K/month, so $60K in year one. Revenue recognition schedules depend on contract terms and accounting method.
- **ARR (Annual Recurring Revenue)** — a normalised snapshot of the recurring revenue run rate, not a GAAP figure. If that customer is on a $60K/year subscription, they contribute $60K to ARR on day one of their contract, regardless of billing schedule.

*The typical misread:* conflating bookings growth with ARR growth. A big Q4 enterprise close inflates bookings; if the deal is multi-year with back-loaded terms, ARR barely moves. Conversely, a large churn event destroys ARR without touching the bookings line.

At the PM's altitude, watch ARR — it is the recurring-revenue heartbeat. Bookings is a sales metric; revenue is a finance metric; ARR is the product-market signal.

---

### New ARR vs. expansion ARR vs. churned ARR

ARR is not monolithic. The cleaner read is the waterfall:

| Component | What it measures |
|---|---|
| New ARR | ARR from logos that did not exist at the start of the period |
| Expansion ARR | ARR added from existing logos (upsell, cross-sell, seat growth, usage) |
| Churned ARR | ARR lost from logos that cancelled |
| Contraction ARR | ARR lost from logos that downgraded but did not cancel |
| Net new ARR | New + Expansion − Churned − Contraction |

A business showing 20% ARR growth can be doing it very differently: one is printing new logos with 15% logo churn; another is barely acquiring new logos but expanding its base at 130% NRR. The second business is worth more. Decomposing the waterfall is how you tell which story you are in.

*The typical misread:* celebrating net new ARR without checking the composition. If expansion is propping up net new ARR while new logo acquisition is stalling, the growth is downstream of a product decision made two years ago — and there is a cliff when that cohort saturates.

---

### GRR vs. NRR

These are the two most important retention metrics for a PM to distinguish:

- **GRR (Gross Revenue Retention)** — what percentage of last period's ARR you kept, counting only downgrades and churns, *not* expansions. GRR has a ceiling of 100%.
- **NRR (Net Revenue Retention)** — same cohort, but you also count expansions. NRR can exceed 100%.

A company with 85% GRR and 110% NRR is losing 15% of its base annually through churn and contraction, but upselling the survivors enough to net 10% growth from the cohort. That is a fragile business: if expansion slows (product saturates, market softens), the 15% structural churn is suddenly visible.

Benchmarks, per Skok and the OpenView SaaS Benchmarks:
- **GRR:** >85% acceptable at scale; >90% strong; enterprise SaaS routinely exceeds 93%.
- **NRR:** >100% required for efficient growth; >110% healthy; >125% exceptional. Below 100% means the existing base is shrinking — acquisition is running to stand still.

*The typical misread:* citing NRR as retention health without checking GRR. High NRR with mediocre GRR is a warning sign, not a green light — it means expansion is papering over churn. Tunguz has documented that GRR is a more durable predictor of long-run company health than NRR precisely because it removes the masking effect of upsell.

---

### CAC and CAC payback

- **CAC (Customer Acquisition Cost)** — the fully-loaded cost to close one new customer. Fully-loaded means: sales salaries, commissions, quota-carrying SE time, marketing spend attributed to the cohort, and any SDR/BDR overhead allocated to the deal.

*The typical misread:* using only marketing spend as CAC. That undercounts by 2–4x for most B2B SaaS businesses with a direct sales motion.

- **CAC payback** — the number of months until the gross margin from a new customer recovers the CAC. Formula: `CAC / (ARPA × gross margin %)`. For a $30K CAC customer at $1,500/month ARPA and 75% gross margin: payback = 30,000 / (1,500 × 0.75) = 26.7 months.

Benchmarks, per Skok and OpenView:
- <12 months: exceptional — typical of efficient PLG or high-velocity SMB.
- 12–24 months: healthy for mid-market B2B SaaS.
- 24–36 months: acceptable if NRR >120% (the customer will eventually pay it back many times over); otherwise a warning sign.
- \>36 months: structural problem unless you have exceptional NRR and long contract durations.

At the PM's altitude, CAC payback is a read on whether the acquisition motion is capital-efficient. If CAC payback is rising quarter over quarter, the sales motion is getting more expensive relative to what the product commands. That is a pricing and packaging signal as much as a sales signal.

---

### Magic number (sales efficiency)

Magic number = `Net new ARR in the quarter / (Sales and marketing spend in the prior quarter)`.

A magic number of 1.0 means: for every dollar spent on sales and marketing last quarter, one dollar of net new ARR was added this quarter. Above 0.75 is generally considered worth investing; above 1.0 is efficient; below 0.5 signals the acquisition model has a problem.

Lemkin (SaaStr) frames it practically: if the magic number is above 0.75, accelerate S&M spend. If it is between 0.5 and 0.75, optimise before adding headcount. If it is below 0.5, do not scale — you are burning capital on a motion that does not compound.

*The typical misread:* applying magic number to a company that is not yet post-product-market-fit, or using it to compare across very different go-to-market motions (PLG vs. field sales have structurally different lag times between spend and ARR).

---

### Quick ratio

Quick ratio = `(New ARR + Expansion ARR) / (Churned ARR + Contraction ARR)`.

This is a single number that expresses the ratio of ARR being added to ARR being lost in a period. A quick ratio of 4 means: for every dollar of ARR lost, four dollars of ARR are being added.

Benchmarks:
- \>4: excellent
- 2–4: healthy growth
- <2: leaky bucket — retention is dragging on growth at a rate that will compound

Tunguz notes that quick ratio is more useful as a trend metric than an absolute — a falling quick ratio over four consecutive quarters, even if still above 2, is a structural warning. A rising quick ratio signals that retention improvements or expansion motion are working.

---

### Sales efficiency overlay

These metrics do not live in isolation. A healthy SaaS revenue signal looks like:

- NRR >110%, GRR >88%
- Quick ratio >3
- CAC payback <24 months
- Magic number >0.75 (if post-PMF with a direct motion)

When they move in opposite directions — NRR rising while magic number falls, or quick ratio healthy while CAC payback extends — the system is telling you something is out of balance. Most often: the product is retaining and expanding well, but the acquisition motion is getting expensive. Or: acquisition looks efficient but the base is churning, and the magic number is high only because churn is slow to show up in the denominator.

## Application

A step-wise read of a SaaS revenue dashboard, in the order that reveals the most signal fastest.

### Step 1 — Anchor on ARR and its waterfall (first 5 minutes)

Start with ending ARR and the waterfall: new, expansion, churned, contraction. Do not read ARR as a single number — read the composition. Ask:
- What is the ratio of expansion to new ARR? (Expansion >30% of net new ARR is a mature, healthy motion; expansion carrying >70% of net new ARR means new logo acquisition is stalling.)
- Is churned ARR stable, rising, or falling as a percentage of starting ARR?

### Step 2 — Read GRR before NRR

GRR first, then NRR. If GRR is below 85%, NRR above 100% is a warning, not a celebration. Note the gap between GRR and NRR — a gap larger than 20 points means expansion is doing significant heavy lifting.

### Step 3 — Check CAC payback and trend

Is CAC payback in the acceptable range for the company's stage and motion? More importantly: has it moved more than 10% in either direction quarter-over-quarter? Rapid CAC payback extension is a go-to-market health signal that often precedes a plateau in growth six to nine months out.

### Step 4 — Read the quick ratio for structural health

Quick ratio tells you whether the bucket is leaking faster than it is filling. Below 2 is a problem regardless of what headline ARR growth looks like. Falling quick ratio over consecutive quarters is the most important early warning in this cluster.

### Step 5 — Magic number as a capital-efficiency sanity check

Magic number contextualises the investment decision: is accelerating sales and marketing spend likely to compound, or is the unit economics insufficient to justify it? At a PM's altitude, this is relevant when leadership is debating whether to hire more AEs or invest in product-led growth motions.

### What "healthy" looks like at scale

Per Bessemer Cloud Index and OpenView Benchmarks, a $50M+ ARR SaaS company showing sustainable growth typically has: 20–30% ARR YoY growth, NRR >115%, GRR >88%, CAC payback <24 months, quick ratio 3–5, magic number 0.8–1.2. Numbers dramatically outside these ranges — in either direction — warrant a question, not just a celebration.

### When to escalate vs. when to note and move on

Escalate (bring to the CEO or CFO immediately):
- GRR falling quarter-over-quarter for two or more quarters
- CAC payback exceeding 36 months and trending worse
- Quick ratio falling below 2
- Magic number below 0.5

Note and monitor (watch closely, raise in the next planning cycle):
- NRR >100% but driven entirely by one expansion cohort
- GRR–NRR gap widening (expansion covering increasing churn)
- Magic number between 0.5 and 0.75

Ignore at the PM's altitude (let finance own it):
- GAAP revenue vs. ARR reconciliation details
- Deferred revenue accounting treatments
- Precise CAC allocation methodology between segments

## Examples

### Example 1 — Reading an annotated revenue table

A growth-stage B2B SaaS company presents the following at a QBR:

| Metric | Q2 | Q3 | Change |
|---|---|---|---|
| ARR | $38M | $44M | +$6M |
| New ARR | $4.2M | $3.8M | −$400K |
| Expansion ARR | $3.1M | $4.0M | +$900K |
| Churned ARR | $1.2M | $1.7M | +$500K |
| Contraction ARR | $0.1M | $0.1M | flat |
| NRR | 118% | 114% | −4 pts |
| GRR | 91% | 88% | −3 pts |
| Quick ratio | 4.1 | 3.5 | −0.6 |
| CAC payback | 19 mo | 22 mo | +3 mo |
| Magic number | 1.1 | 0.9 | −0.2 |

**What a competent PM reads here:**

Net new ARR grew ($6M), so headline growth looks fine. But the waterfall tells a more specific story: new logo acquisition fell while churn rose. Expansion ARR is picking up the slack — expansion went from carrying 42% of gross new ARR to carrying 51%. This is structurally acceptable today, but if new logo acquisition continues to fall and churn continues to rise, expansion will not be able to hold NRR above 100% for long.

GRR at 88% and falling is the metric to watch. It is still in an acceptable range, but the trend over two quarters is −3 points — that is not noise. Churned ARR grew 42% quarter over quarter while ARR grew only 16%.

CAC payback extension (+3 months) and magic number compression (−0.2) together suggest the acquisition motion is getting less efficient — either market penetration is requiring more expensive deals, or the sales motion is being pushed into less-qualified segments.

**The right escalation:** Flag GRR trend to the CEO/CFO. Do not panic on a single quarter, but a third consecutive quarter of GRR compression warrants a churn diagnosis workstream. Ask: who churned in Q3, what was their ACV and cohort age, and is there a segment or use-case pattern?

---

### Example 2 — A PM bluffing past a vanity metric

A PM presents at a roadmap review: "We're at 108% NRR, which means we're growing without even needing new logos. Expansion is working."

The CFO asks: "What's GRR?"

The PM: "I'm not sure exactly — but NRR is above 100%, so retention is strong."

**What the PM missed:** NRR of 108% is compatible with GRR of 80% — a business losing 20% of its base annually but upselling the survivors enough to net 8% growth from the cohort. If expansion slows (pricing ceiling is hit, product surface saturates), the underlying 20% annual churn is fully exposed. A PM who presents NRR without GRR is citing the number that looks best, not the one that tells the truth.

**The fix:** Before citing NRR in any review, decompose it into GRR (what you kept) and the expansion delta (what you added on top). If you cannot decompose it, do not present it as a health signal.

## Common Pitfalls

### Pitfall 1 — GRR and NRR treated as synonyms

**Symptom.** A PM says "our retention is 110%" without specifying gross or net. Finance interprets GRR; product interprets NRR. They are having different conversations.

**Consequence.** NRR above 100% with GRR below 85% is not "strong retention" — it is expansion masking churn. Presenting NRR as the single retention number obscures whether the base is actually healthy.

**Fix.** Always cite both. If GRR is unavailable, say so explicitly and note that NRR alone is insufficient to characterise retention health. Skok ("SaaS Metrics 2.0") names this decomposition as foundational.

---

### Pitfall 2 — Logo churn vs. net dollar churn conflated

**Symptom.** "We only churned 12 logos this quarter — that's a 2% logo churn rate, very healthy."

**Consequence.** If those 12 logos were your 12 largest accounts, you may have lost 15% of ARR. Logo churn counts heads; net dollar churn counts dollars. They diverge sharply when your customer base is heterogeneous in size.

**Fix.** Track both. If net dollar churn is higher than logo churn, you are losing disproportionately large customers — a product fit or service coverage problem at the top of the ACV distribution.

---

### Pitfall 3 — CAC calculated on marketing spend only, ignoring fully-loaded sales costs

**Symptom.** CAC payback looks short (8 months!) because the company is computing CAC as digital marketing spend only.

**Consequence.** When fully-loaded sales costs are included — quota-carrying AE time, SE support, SDR allocation, commissions — CAC is typically 2–4x the marketing-only figure. Decisions about sales hiring, pricing, and packaging made on understated CAC are systematically optimistic.

**Fix.** Skok is explicit on this: CAC must include all costs required to close the deal. Pressure-test the CAC figure by asking: "Does this include commissions, SE time, and SDR allocation?" If the answer is no or unclear, the payback period is longer than stated.

---

### Pitfall 4 — Magic number applied before product-market fit

**Symptom.** A pre-PMF team uses a weak magic number (0.4) to argue against increasing sales investment.

**Consequence.** Magic number measures sales efficiency, not product-market fit. A low magic number pre-PMF often means the product is not ready for a repeatable sales motion — not that sales should be starved. The fix is product work, not sales cost reduction.

**Fix.** Lemkin (SaaStr) draws this line clearly: magic number is a post-PMF capital-efficiency tool. Before repeatable sales motion exists, the signal is noise. Use it to scale; do not use it to diagnose.

---

### Pitfall 5 — Celebrating ARR growth without reading the waterfall

**Symptom.** "+40% ARR YoY! Great quarter." The deck shows no ARR waterfall.

**Consequence.** 40% ARR growth driven by a single large enterprise logo added in Q4 with a 3-year contract looks identical to 40% growth from 200 new mid-market logos — until the enterprise churns or the 3-year contract expires. The waterfall exposes concentration risk, acquisition sustainability, and whether expansion is compounding or stalling.

**Fix.** Insist on the ARR waterfall as the unit of analysis, not just ending ARR. OpenView Benchmarks break out new vs. expansion as a benchmark input for a reason: the composition of growth predicts whether it will compound.

---

### Pitfall 6 — Quick ratio read as a point-in-time snapshot rather than a trend

**Symptom.** Quick ratio is 3.2 — reported as healthy and moved on.

**Consequence.** If quick ratio was 4.8 six months ago and 3.8 three months ago, the trend is the signal. A falling quick ratio across multiple quarters indicates churn is accelerating, expansion is decelerating, or both — even when the absolute number still looks "acceptable."

**Fix.** Plot quick ratio over 4–6 quarters. A steady or rising trend at 2.5 is more investable than a falling trend at 3.5. Tunguz documents this in his empirical analysis of SaaS cohort dynamics: trend matters more than the instantaneous reading for this metric.

## References

- **David Skok** — "SaaS Metrics 2.0," *For Entrepreneurs* blog (forEntrepreneurs.com). The canonical PM-accessible taxonomy of SaaS metrics: ARR waterfall, NRR/GRR decomposition, CAC payback, and magic number. This skill's metric definitions and most benchmark ranges trace directly to Skok's framework.
- **OpenView Partners** — *SaaS Benchmarks Report* (annual; openviewpartners.com). The primary source for stage-appropriate benchmark ranges (NRR, GRR, CAC payback, magic number). Referenced throughout Application and Key Concepts for "what healthy looks like at scale."
- **Tomasz Tunguz** — Theory Ventures blog (tomtunguz.com; formerly Redpoint). Empirical analysis of SaaS cohort dynamics, GRR as a predictor of long-run health vs. NRR, and quick ratio trend interpretation. Used in the GRR vs. NRR concept and the quick ratio pitfall.
- **Jason Lemkin** — SaaStr blog and podcast (saastr.com). Practitioner framing of magic number as a post-PMF capital-efficiency signal and the 0.75/1.0 thresholds for investment decisions. Used in the magic number concept and pitfall.
- **Bessemer Cloud Index** — Benchmark reference for growth-stage SaaS multiples and metric profiles. Used in Application Step 5 ("what healthy looks like at scale").
- **Related Hornero skills:**
  - [`success-metrics`](../success-metrics/SKILL.md) — defines the metric stack for a feature or launch; this skill provides the business-level context that makes feature metrics legible.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — portfolio-level investment decisions that use NRR, quick ratio, and magic number to allocate bets across growth levers.
  - [`saas-economics-efficiency-metrics`](../saas-economics-efficiency-metrics/SKILL.md) — the companion skill covering margins, burn rate, LTV:CAC, and efficiency ratios. Use alongside this skill for a complete health read.
  - [`finance-metrics-quickref`](../finance-metrics-quickref/SKILL.md) — fast lookup table for definitions and formulas when the PM needs a quick sanity check on a specific number.
  - [`business-health-diagnostic`](../business-health-diagnostic/SKILL.md) — downstream skill that synthesises both the growth stack (this skill) and the efficiency stack into an overall business health signal.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/saas-revenue-growth-metrics) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
