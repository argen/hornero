---
name: pricing-strategy
description: Use when a B2B product is setting or revising its pricing — produces a willingness-to-pay-anchored pricing strategy with tier structure, price points, and validation plan. Ramanujam-anchored, positioning-aware, distinct from cost-plus and competitor-anchored alternatives.
intent: |
  Implements Ramanujam's WTP-first methodology in the Hornero
  marketing role. Pricing is a product decision, not a launch
  afterthought — this skill forces that discipline.
type: component
theme: commercial
best_for:
  - Pre-launch pricing of a new product
  - Repricing an existing product (segment, model, or tier change)
  - Diagnosing why a current price isn't converting (feature shock / minivation / hidden gem / undead)
  - Validating a pricing intuition before committing
scenarios:
  - "B2B SaaS analytics tool moving from per-seat to usage-based pricing"
  - "Compliance product considering freemium — analyse whether the WTP curve supports it"
  - "Enterprise tool with three tiers where 90% of revenue is in the middle tier — diagnose and reprice"
estimated_time: 2-4 hours (full skill including 8-15 WTP interviews)
---

# Pricing strategy

> v0 draft. Anchored in Madhavan Ramanujam's *Monetizing Innovation* (2016, with Georg Tacke), April Dunford's *Obviously Awesome* (2019), Joanna Wiebe's conversion-copy methodology, Mark Ritson's strategic-then-tactical sequencing, and Bob Hoffman's skepticism of competitor-anchored benchmarks.

## Purpose

Produce a pricing strategy for a B2B SaaS product — or a pricing change — that is anchored in what a specific buyer segment will actually pay, not in cost-plus arithmetic or competitor observation.

The artifact the skill produces: a segment-specific WTP curve summary, a chosen monetization model, a tier structure with named price points, anchoring and bundling logic, a pricing-page narrative, and a validation plan ready to hand off to the data-scientist.

Ramanujam's load-bearing thesis (*Monetizing Innovation*, 2016): research willingness-to-pay before the product is fully specified, not after launch. Most B2B "innovation failures" are pricing failures dressed up as product failures — the product was built for the wrong segment, bundled the wrong features, or shipped at a price no research had validated. The sequencing error is strategic: when pricing is treated as a launch-week detail, it is already too late to change the product shape the price needs to justify.

Mark Ritson's strategic-then-tactical discipline applies directly here: positioning → segment → pricing strategy → price-point tactics. Running this skill presupposes a completed positioning canvas; if the canvas is absent or stale, complete it first.

## Key Concepts

### The four monetization failure modes (Ramanujam)

Ramanujam names four ways B2B products fail commercially — all rooted in WTP research being skipped or arriving too late:

- **Feature shock.** The product is over-engineered for the segment's WTP. Too many features bundled into a price the market won't pay. Symptom: buyers say the product is "impressive but too much" and either don't buy or buy and use 20% of it.
- **Minivation.** The product is under-priced relative to the value it delivers. The team set price by cost-plus or by fear; the market would have paid more. Symptom: fast adoption, low revenue, and customers surprised when prices eventually rise.
- **Hidden gem.** A high-WTP feature is buried in a lower tier or bundled invisibly. The market never sees its value; the seller leaves money on the table. Symptom: customers who discover the buried feature become fanatics; most customers never find it.
- **Undead.** A product or tier that should never have existed — WTP too low to justify the cost to build and support it — but that lingers because the team lacks data to kill it. Symptom: a tier that is operationally costly, converts poorly, and cannibalises the profitable tier.

Diagnosing which failure mode is present is the first step of any repricing exercise.

### WTP-first versus cost-plus versus competitor-anchored

Three pricing philosophies exist. Two are wrong.

**Cost-plus.** Add a margin to the cost of goods sold. The logic is accountant-correct and commercially naive: it starts with the seller's economics, not the buyer's value. Cost-plus systematically under-prices high-value products and over-prices low-value ones, because cost and value are uncorrelated.

**Competitor-anchored.** Set prices relative to named competitors. Bob Hoffman's criticism is precise here: competitors anchored their pricing on their own (broken) assumptions. Benchmarking against them imports their errors. It is especially dangerous in categories where incumbents have systematically under-priced because they fear segment disruption.

**WTP-first.** Research what the target segment will pay before committing to a model or price point. The research surfaces the segment's value perception and the price range where conversion maximises. The price is then set at a point on the WTP curve that balances revenue, conversion rate, and competitive defensibility. WTP-first is Ramanujam's methodology; this skill implements it.

### Pricing model archetypes

The model choice precedes the price-point choice. The five archetypes, with when-to-use guidance:

- **Subscription (per-seat or flat-rate).** Choose when value is continuous and the buyer perceives value regularly (daily or weekly use). Predictable revenue; high activation cost to justify. At risk of churn when usage falls below perceived value threshold.
- **Usage-based.** Choose when value is transactional and the buyer pays proportionally to consumption. Aligns pricing with delivered value. Requires instrumented usage data; may produce volatile revenue. Strong fit for API-first products and infrastructure.
- **Outcome-based.** Choose when the buyer's outcome is measurable and attributable. Highest alignment with buyer value; hardest to operationalise. Requires contractual agreement on measurement. Appropriate for high-trust, high-ACV relationships.
- **Freemium.** Choose when there is a large volume of potential users, the marginal cost of a free user is near zero, and the WTP curve for paid features is steep and clearly segmented from the free use case. Not a default for B2B — most B2B buyer WTP curves do not support freemium without subsidising non-converting users.
- **Tiered.** The meta-model. Most B2B products use a tiered structure regardless of the underlying archetype. Tiers segment by WTP band; each tier is priced at a different percentile of the WTP distribution. The tier model assumes the distribution is multi-modal (distinct buyer types); if it is unimodal, a single price point may dominate.

### Value perception cadence

A buyer perceives value in the cadence that their usage produces value. If a CFO checks the consolidated dashboard daily, the product's value cadence is daily. If a compliance officer runs a quarterly audit report, the cadence is quarterly. The billing cadence should match — or compress toward — the value perception cadence. Billing quarterly for a daily-value product feels like pre-payment; billing monthly for a quarterly-value product feels frequent and unjustified. Misaligned billing cadence is a churn driver that surfaces as "the product is too expensive" when the real issue is billing timing.

### Anchoring: the decoy tier and the premium-tier anchor

Anchoring (Sutherland's behavioral-economics application) shapes willingness to pay through context. In a three-tier structure, the highest tier is not primarily a revenue tier — it is an anchor that makes the middle tier feel like value. The "decoy" or "anchor" tier should be priced high enough that the middle tier reads as the rational choice for the target buyer. If the top tier is not purchased at any meaningful volume, that is expected; it is doing its anchoring job. A missing top tier causes the middle tier to read as the premium, which compresses pricing power.

### Bundling logic

Two types of bundling, with distinct rationales:

**Value-cohesive bundling.** Features used together by the same buyer in the same workflow are bundled. The bundle is logical because the buyer experiences the features as a single job. This bundling increases WTP because the buyer values the workflow, not the individual features.

**Price-obscuring bundling.** Features with different WTP profiles are bundled to make the unit price harder to compare. This is Hoffman's warning: when a sales rep is asked to justify why the bundle costs what it does, they cannot — because the rationale was internal pricing arithmetic, not buyer value. Price-obscuring bundling erodes trust and increases churn when buyers eventually perceive the mismatch.

Applying the test: if a buyer would purchase both features independently, bundle them. If the bundle requires one feature to carry another that the buyer would not purchase alone, the bundling is obscuring, not cohesive.

### WTP research toolkit

Four methods, in increasing research sophistication:

- **Customer interviews (8-15).** The minimum. Direct WTP questions ("What would you pay for this?") produce anchored answers, not true WTP. Better approach: ask about current spend on the problem, alternative costs, and value delivered in the buyer's terms. The output is a qualitative WTP range and vocabulary — the language buyers use to justify spend.
- **Van Westendorp price-sensitivity meter.** Four price-point questions: too cheap (quality concern), cheap-but-acceptable, expensive-but-acceptable, too expensive (won't buy). Produces an acceptable price range and an optimal price point for the segment. Runs in a survey; requires 50+ responses for reliability.
- **Conjoint analysis.** Present buyers with configurable product profiles (features + price) and measure preference trade-offs. Produces WTP per feature, not just per product. Appropriate when designing tier structure (which features belong where). Resource-intensive; justified for ACV above $5k or strategic repricing.
- **Segmented WTP curves.** Plot WTP against company size, industry, or buyer role. The curve's shape tells you whether a single price optimises revenue (unimodal distribution) or whether tiering adds value (multi-modal distribution). A steep curve (large spread between P10 and P90 WTP) indicates strong tier-pricing opportunity. A flat curve indicates a commodity dynamic.

## Application

### Step 1 — Name the segment

Retrieve the positioning canvas (`roles/marketing-expert/skills/positioning-canvas/SKILL.md`). The "who-cares-most" component names the segment whose WTP matters. If the canvas is absent, produce it first — pricing without positioning is a price floating in space, unanchored to the buyer's value perception.

State the segment explicitly: job title, company size, current tooling, and the specific job they are hiring the product to do. The job defines the value metric that pricing should reflect.

### Step 2 — Research WTP

Run 8-15 customer interviews with buyers in the named segment. Focus questions:

- What are you currently spending on this problem (tools, time, headcount)?
- What would it cost you not to solve this problem?
- At what price would you consider this too cheap to trust? Too expensive to consider?
- How do you evaluate spend like this internally — who approves, what's the threshold?

If the ACV justifies it (above $5k), follow with a van Westendorp survey (50+ responses). For strategic repricing or tier redesign, commission conjoint analysis.

Plot results as a segmented WTP curve: price on the x-axis, % of segment willing to pay on the y-axis. Note the P25, P50, and P75 points — these are your tier price-point candidates.

### Step 3 — Name the value perception cadence

State explicitly: how often does the target buyer perceive delivered value? Daily (active product use), weekly (workflow output), monthly (reporting), quarterly (business review), or event-driven (compliance, audit)?

The billing cadence should match or compress toward this cadence. Daily-value products should bill monthly at most; quarterly-value products can bill annually. Mismatches drive churn before the product does.

### Step 4 — Choose the pricing model archetype

Using the WTP curve shape and the value perception cadence, select one archetype (or a tiered combination). Document the reasoning:

- Is value transactional (usage-based) or continuous (subscription)?
- Is the WTP curve multi-modal (tiered) or unimodal (single price)?
- Is the marginal-cost structure compatible with freemium?
- Is outcome measurability contractually achievable (outcome-based)?

Name the archetype and the specific objection to each discarded alternative.

### Step 5 — Design the tier structure

Default to three tiers unless the WTP data strongly implies two or four. Three tiers produce the anchoring dynamic; two tiers collapse the anchor; four tiers create decision paralysis for most B2B buyers.

Name each tier in the buyer's language (Wiebe: voice-of-customer tier names). The tier name should reflect the buyer's job at that tier, not the seller's internal segmentation logic. "Standard / Pro / Enterprise" is seller language. "Teams / Scale / Enterprise" is generic. "Analyst / Operations / Finance Leader" (named for the buyer at each tier) is buyer language.

For each tier, specify:
- The buyer this tier is for (job, company stage, use-case trigger).
- The three to five features that define this tier's value proposition.
- The price point (derived from WTP curve — see Step 6).
- The upgrade trigger: what event causes a buyer on this tier to need the next one?

### Step 6 — Set price points using the WTP curve

Set each tier's price at a specific percentile of the WTP distribution for that tier's buyer type:

- **Entry tier:** P25 of the lowest-WTP segment. The price where 75% of that segment is willing to pay. Maximises trial volume and expansion surface.
- **Mid tier:** P50 of the core segment. The median WTP — where most conversion optimises. This is the primary revenue tier.
- **Top tier:** P75-P85 of the highest-WTP segment. High enough to anchor the mid tier; real enough that some buyers select it without sales pressure.

Do not set price at P90 or above without a sales-led motion — self-serve conversion collapses at extreme WTP percentiles.

Document the crossing point: which percentile of which segment's WTP curve is each price point set at. This makes the assumption explicit and reviewable.

### Step 7 — Draft the pricing-page narrative

The pricing page communicates four things, in order:

1. **Who each tier is for** — stated in the buyer's language (not "features included").
2. **What each tier does** — the one-line job each tier solves.
3. **What is included** — the three to five features, stated as outcomes, not as feature names.
4. **What the upgrade signal is** — why a buyer on tier one eventually needs tier two.

Tier names are positioning. Dunford: the names and price points communicate segment fit before a buyer reads a word of copy. A tier called "Enterprise" signals that smaller buyers should look at lower tiers; a tier called "Growth" signals scale rather than size. Names are not cosmetic.

Hand this narrative to the designer to own the visual hierarchy of the pricing page. The content and order are fixed here; the layout is the designer's call.

### Step 8 — Validation plan

Propose a pricing test before the price is committed. The test design is handed to the data-scientist for validation (`roles/data-scientist/skills/experiment-design/SKILL.md`) — this step produces the brief, not the final design.

The brief states:
- **What is being tested:** price point, tier structure, or both?
- **Test cohort:** new sign-ups only (avoids pricing-change resentment in current customers); segment-gated if possible.
- **Duration:** long enough to observe at least one full billing cycle post-conversion.
- **Primary metric:** conversion rate at the tested price point.
- **Counter-metric:** churn rate at 30 and 60 days (a price that converts but churns fast is not a pricing win).
- **Decision threshold:** what outcome causes the team to commit, revert, or run a follow-up test?

If running a live price test is not feasible (small volume, regulated market), propose a stated-preference study (van Westendorp, conjoint) as the validation proxy, with explicit acknowledgment of its limits.

## Examples

### Example A — B2B SaaS analytics tool repricing (per-seat to usage-based)

**Segment:** Head of Data at a Series B–C SaaS company, 50-300 employees, currently using a per-seat analytics tool that charges for every analyst regardless of query volume.

**WTP research summary (12 interviews + van Westendorp, n=68).** Buyers express frustration with per-seat pricing because their value perception is per-insight, not per-analyst. At $X/seat/month, low-volume months feel overpriced. Acceptable range: $200-$900/month for a team of 3-5 analysts; P50 WTP is $480/month. But the range has a long tail — data-intensive companies express WTP up to $3,000/month if priced on query volume rather than headcount.

**Failure mode spotted:** Feature shock. The current mid-tier bundles advanced anomaly detection, custom ML pipelines, and audit logging — features used by fewer than 15% of buyers at that tier. Buyers say "it feels like I'm paying for things I'll never touch." The bundle suppresses conversion by raising perceived cost without raising perceived value.

**Chosen model:** Usage-based (per-1,000 queries), with a monthly cap for predictability. This maps billing to the buyer's value perception cadence (per-analysis-run). It also eliminates the per-seat friction that causes teams to "share logins" or undercount analyst seats.

**Tier structure:**

| Tier | Name | Target buyer | Price point | Included |
|------|------|-------------|-------------|----------|
| 1 | Starter | Solo analyst or small team, <5k queries/month | $199/month | Up to 5k queries; core dashboards; CSV export |
| 2 | Growth | Data team of 3-8, 5k-50k queries/month | $599/month | Up to 50k queries; anomaly detection; API access; Slack alerts |
| 3 | Scale | Analytics-heavy orgs, >50k queries/month | $1,800/month | Unlimited queries; custom ML pipelines; SSO; audit log; dedicated CSM |

Scale tier is the anchor. Most buyers will convert to Growth; Scale's presence makes Growth feel like the rational mid-point, not the premium tier.

**Validation plan brief:** A/B test new pricing vs current per-seat pricing on new sign-ups for 60 days. Primary metric: 30-day conversion rate. Counter-metric: 60-day churn rate. Decision threshold: if conversion is within 10% of current and churn does not increase, commit to usage-based; if conversion drops more than 15%, test a hybrid (per-seat floor + query overage) before full commitment.

---

### Example B — B2B compliance tool considering freemium

**Segment:** Compliance Officer at a financial-services firm, 200-2,000 employees, currently managing regulatory reporting workflows in a mix of spreadsheets and a legacy compliance platform.

**The question:** Should the compliance tool introduce a freemium tier to drive top-of-funnel volume?

**WTP analysis.** Interviews (10) and van Westendorp (n=54) produce a steep WTP curve: the compliance buyer's P25 is $800/month; their P50 is $2,200/month; their P75 is $4,500/month. The acceptable-price floor (below which quality is doubted) is $500/month. There is no meaningful cluster of potential users below $500/month — compliance buyers interpret low price as a signal of inadequate audit trail and regulatory coverage.

**Freemium verdict: no.** Ramanujam's WTP-distribution test for freemium requires two conditions: (1) a large-volume segment of users whose WTP is near zero or negative (they need to be subsidised to onboard), and (2) a clear, steep step function to a paid tier where WTP is high. This product fails condition (1). The WTP distribution does not have a zero-WTP tail — buyers who cannot pay $500/month for a compliance tool are not buyers who would ever convert to a paid tier. They are non-buyers. Freemium would not seed paid conversion; it would dilute the support capacity, inflate the user base with non-buyers, and send a low-price signal to the segment that interprets price as a proxy for regulatory robustness.

The additional risk: compliance buyers select vendors partly on the vendor's apparent commercial stability and seriousness. A freemium compliance tool reads as a startup experiment, not an enterprise-grade audit system. The positioning damage outweighs the acquisition benefit.

**Alternative recommendation:** A 14-day free trial with full feature access and a sales-assist trigger at day 7 for accounts with >$1M AUM or >50 employees. This addresses the top-of-funnel volume concern without the WTP-dilution risk.

## Common Pitfalls

### Pitfall 1 — Pricing by competitor

**Symptom:** The pricing deck has a competitive matrix and the price is set to be "slightly below Competitor A."

**Consequence:** Competitor A anchored their pricing on their own broken assumptions. Importing their price imports their error, plus a discount that further erodes the margin. Hoffman: competitors' pricing tells you about their cost structure and their mistakes, not about what your segment will pay.

**Fix:** Run WTP research on your segment. Use competitor pricing only as a cross-check after setting the WTP-anchored price, not as the primary input.

### Pitfall 2 — Cost-plus as default

**Symptom:** The price is calculated as CAC + COGS + target margin.

**Consequence:** Cost-plus starts from the seller's economics, which are uncorrelated with buyer value. High-value products are systematically under-priced; commodity products are over-priced. The resulting pricing is coherent internally and wrong externally.

**Fix:** Start with WTP research. Cost and margin are constraints to check against the WTP-anchored price, not inputs to the price calculation.

### Pitfall 3 — "We'll figure pricing out at launch"

**Symptom:** The product is being built without WTP research; pricing is deferred to the launch sprint.

**Consequence:** This is Ramanujam's named failure mode. By launch, the product's feature set has been specified, the engineering investment is sunk, and the team has no negotiating room to repackage. The price is set under time pressure against a fixed artifact. The four failure modes — feature shock, minivation, hidden gem, undead — all trace here.

**Fix:** WTP research runs during product specification, before features are locked. At minimum, the pricing model should be chosen before the feature set is finalised.

### Pitfall 4 — Discount as default in sales

**Symptom:** Sales reps discount routinely to close. Buyers learn to wait. Average selling price drifts below the list price within two quarters.

**Consequence:** Discounting trains the market. Buyers who paid list price feel penalised; new buyers budget for the discounted price; the tier structure's price signals erode.

**Fix:** Design the tier structure so the entry tier is the correct product for price-sensitive buyers — not a discounted version of the mid-tier. Discounting is a symptom of wrong tier structure, not a negotiating tool.

### Pitfall 5 — Skipping WTP research

**Symptom:** The team says "we already know what they'll pay" before running a single structured interview.

**Consequence:** Founder intuition on WTP is systematically biased toward the price points they are comfortable discussing, the buyers they know best, and the value they perceive from inside the product. None of these is the buyer's WTP. Ramanujam's empirical finding: teams that skip WTP research are wrong about price direction (too high vs too low) roughly half the time, and wrong about model (which archetype) more than that.

**Fix:** Run 8-15 interviews with buyers in the specific segment. The interviews take one to two weeks. The cost of being wrong about pricing is multiple quarters of suboptimal revenue.

### Pitfall 6 — Tier names that reflect the seller's logic

**Symptom:** Tiers are named "Standard / Pro / Enterprise" or "Basic / Advanced / Premium."

**Consequence:** These names describe the seller's internal segmentation. A buyer reading them asks: "Which one am I?" rather than immediately self-identifying. Wiebe: copy that uses the customer's own language converts faster and produces less buyer uncertainty.

**Fix:** Name tiers after the buyer's job, role, or company stage at that tier. The name should answer "who is this tier for?" in one word.

### Pitfall 7 — Bundling to obscure unit price

**Symptom:** Features with different WTP profiles are bundled into tiers, and the rationale is "it makes the price look better value for money."

**Consequence:** When a sales rep is asked why the bundle includes Feature X (low WTP), they cannot give a buyer-value answer. The bundle erodes trust in the seller's pricing rationale. Churned customers often cite "we were paying for things we never used" — this is the post-hoc recognition of price-obscuring bundling.

**Fix:** Bundle only features used together in the same workflow by the same buyer. If the test is failed — "would this buyer purchase this feature independently?" — unbundle it or move it to a lower tier.

### Pitfall 8 — Freemium as default for B2B

**Symptom:** The team proposes freemium because "all the best B2B products have a free tier."

**Consequence:** Most B2B buyer WTP curves do not have a zero-WTP tail that would convert to paid. Freemium in this shape produces a large base of non-converting users who consume support, inflate reported user numbers, and send a low-price positioning signal to buyers who use price as a quality proxy.

**Fix:** Apply Ramanujam's two-condition test (zero-WTP tail exists in volume; clear steep step function to paid WTP). If both conditions are not met, propose a free trial with time or feature limits instead.

## References

- **Madhavan Ramanujam** — *Monetizing Innovation: How Smart Companies Design the Product Around the Price* (2016, with Georg Tacke). WTP-first thesis; four failure modes; pricing model archetypes. See `roles/marketing-expert/sources.md`.
- **April Dunford** — *Obviously Awesome* (2019). Tier names and price points as positioning signals; "best-for" segment dictates which WTP curve matters. See `roles/marketing-expert/sources.md`.
- **Joanna Wiebe** — Copy Hackers. Voice-of-customer language for tier names and pricing-page copy. See `roles/marketing-expert/sources.md`.
- **Mark Ritson** — strategic-then-tactical sequencing; positioning precedes pricing strategy, which precedes price-point tactics. See `roles/marketing-expert/sources.md`.
- **Bob Hoffman** — skepticism of competitor-anchored pricing benchmarks. See `roles/marketing-expert/sources.md`.
- **Related Hornero skills:**
  - [`positioning-canvas`](../positioning-canvas/SKILL.md) — required input; the "who-cares-most" segment dictates which WTP curve the pricing strategy anchors on.
  - `roles/product-manager/skills/bet-portfolio/SKILL.md` — a pricing model change is a strategic bet; route through the PM's bet-portfolio skill to assess whether it warrants a decision record.
  - `roles/product-manager/skills/revenue-architecture/SKILL.md` — the systems view of the whole revenue funnel; pricing-strategy produces the tier and price-point decision within that system. They compose: run revenue-architecture to identify which funnel stage a pricing change is intended to move; run pricing-strategy to design the change.
  - `roles/data-scientist/skills/experiment-design/SKILL.md` — Step 8 of this skill produces a test brief; the data-scientist validates the experiment design before the test runs.
