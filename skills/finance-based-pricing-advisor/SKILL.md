---
name: finance-based-pricing-advisor
description: Use when a PM needs to set or change pricing using finance levers — cost-plus, value-based, willingness-to-pay, margin floors, packaging — not just "what competitors charge"
role: product-manager
intent: |
  Guides a PM through the five core pricing methods (cost-plus, value-based,
  WTP-anchored, competitive, dynamic), applies gross margin as a hard floor,
  and surfaces the packaging architecture that maximises both conversion and
  expansion. The output is 3-5 ranked pricing-approach recommendations with
  named tradeoffs, not a single answer — pricing is a bet, and the skill makes
  the bet legible.
type: interactive
theme: finance
best_for:
  - Setting initial pricing for a new product or tier with no market anchor
  - Re-pricing an existing product when the current model is misaligned with value delivered
  - Designing packaging architecture (good/better/best vs. unbundled) to optimise CAC payback
scenarios:
  - "First-time pricing: we're launching a B2B SaaS product and have no idea what to charge"
  - "Re-pricing: we've been per-seat since day one but customers get value from outcomes, not seats"
  - "Packaging: we want to add a premium tier but need to know what goes in it without cannibalising the base"
estimated_time: "45-90 minutes"
---

# Finance-based pricing advisor

> v0 draft. Anchored in Ramanujam & Tacke (*Monetizing Innovation*, 2016) for WTP-first design;
> Nagle, Hogan & Zale (*The Strategy and Tactics of Pricing*, 6th ed.) for the canonical five-method
> framework; Hermann Simon (*Confessions of the Pricing Man*, 2015) for pricing-as-strategy framing;
> Patrick Campbell / ProfitWell research for SaaS benchmark data. Editorial review recommended.

## Purpose

Produce a pricing recommendation grounded in the financials of the business — not in gut feel,
not in what competitors are charging, and not in a single method applied without awareness of its
limits.

Pricing is one of the highest-leverage decisions a PM makes. A 1% improvement in price realisation
tends to produce 2-4x the net operating income of a 1% improvement in volume (Simon). Yet most
product teams either avoid the question entirely (deferring to sales or finance) or anchor
instinctively on the competitive middle — charging roughly what others charge with no analysis of
whether that price covers costs, captures value, or holds given the unit economics.

This skill applies five methods as a panel, uses gross margin as a non-negotiable floor, and maps
the pricing decision to packaging architecture and CAC payback. The output is a ranked set of
recommendations, not a single right answer, because pricing involves tradeoffs between conversion
risk, expansion upside, margin protection, and customer perception that must be named — not hidden.

Distinct from [`revenue-architecture`](../revenue-architecture/SKILL.md): that skill maps the
revenue system as a whole (funnel, activation, retention, expansion). This skill focuses on the
pricing decision specifically — the unit price, the metric, and the packaging structure.

Distinct from [`success-metrics`](../success-metrics/SKILL.md): that skill designs the measurement
stack for a feature or launch. This skill determines the price that the feature or launch should
carry, and how margin and expansion revenue interact with the measurement stack.

## Key Concepts

### The five pricing methods

These are not competing schools of thought. They are five lenses on the same question, each
surfacing different constraints. A defensible pricing decision runs all five and triangulates.

**Cost-plus pricing** — floor-setting from unit economics. Calculate the fully-loaded cost to serve
one customer (COGS, support allocation, infrastructure), then add the gross margin percentage the
business model requires. This produces the floor: you cannot price below this line sustainably.
Cost-plus is not a pricing strategy; it is a constraint on every other method. Teams that skip it
can set prices that look competitive but destroy margin quietly over time.

**Value-based pricing** — ceiling-setting from value delivered. Estimate the economic value your
product creates for the customer. For B2B this is typically measurable: hours saved × loaded labour
rate, deals won per period × average deal size, churn prevented × LTV. Price at a fraction of that
value — capturing enough to justify investment, leaving enough to make the customer's business case
easy. The fraction depends on competitive alternatives and switching cost. Nagle, Hogan & Zale
identify this as the only method that reliably justifies premium pricing over time.

**Willingness-to-pay (WTP) anchoring** — demand-shaping from customer research. Ramanujam & Tacke
(*Monetizing Innovation*) argue that WTP conversations should happen before product design, not
after. Four data-collection approaches in order of rigor: Van Westendorp price sensitivity survey
(acceptable/expensive/too cheap/too expensive thresholds), Gabor-Granger method (conversion at
explicit price points), conjoint analysis (feature-price tradeoffs across real buying scenarios),
and direct customer interviews ("what would you stop using us at?"). The output is a demand curve
segment, not a single number. WTP varies by ICP segment — treating it as uniform is the most
common mistake. Campbell / ProfitWell benchmark: median B2B SaaS WTP is captured at 15-25% below
the product's value-based ceiling; the gap is the customer's value surplus, not waste.

**Competitive-context pricing** — range-setting from market signals. What do customers already pay
for adjacent or substitute solutions? This sets a psychological anchor, not an economic one. Using
competitor prices as the primary input is the most tempting and least defensible approach: your
costs, ICP, and value prop differ from competitors'. Competitive pricing is a calibration step, not
a strategy. Simon: "the price a competitor charges tells you what the market expects, not what
you're worth."

**Dynamic and segment pricing** — value extraction from heterogeneous demand. Different customer
segments have different WTP. Enterprise buyers pay more than SMBs. Annual subscribers are less
price-sensitive than month-to-month customers. Power users extract more value than light users.
Dynamic pricing captures this through tiers, usage-based components, add-ons, or personalised
discounting. Nagle et al. identify price segmentation as one of the highest-ROI pricing moves for
mature products, because it expands revenue without requiring a single price increase.

### Gross margin as a constraint, not a target

Gross margin (revenue minus COGS, expressed as a percentage of revenue) is the floor below which no
pricing strategy can sustain the business. SaaS benchmark gross margins: 65-75% for early-stage,
75-85% for growth, 80%+ for scale. If value-based pricing produces a recommended price that implies
a margin below the business's required floor, one of three things must change: the cost structure,
the ICP, or the business model. Setting price without knowing the margin floor is pricing without
a budget constraint — the resulting recommendation cannot be acted on.

### Packaging architecture

Packaging is the structure that translates a pricing method into a buying decision. The three
canonical patterns:

**Good/better/best (tiered)** — three tiers anchored to distinct buyer personas. The middle tier
is the target; the lower tier creates a price anchor and a land entry point; the upper tier creates
an upsell path and makes the middle look reasonable. Campbell research: the most common error in
good/better/best is putting the same features in the wrong tier — value metrics (the features
customers care most about) belong in the middle tier, not locked behind the top.

**Unbundled (add-ons)** — a base product at a low entry price with feature or usage add-ons sold
separately. Works when customers have heterogeneous feature needs and would resist paying for a
bundle where they use only part. Risk: adds cognitive overhead to the buying decision; requires
clear framing of what "base" means.

**All-in-one** — single product, single price. Appropriate when the ICP is homogeneous (similar
needs, similar budgets) and where complexity of choice would hurt conversion. Commonly used in PLG
motions where sales-assist is unavailable to explain tiers.

### Pricing metric and the value lever

The pricing metric is what you charge for — seats, users, API calls, outcomes, revenue share,
flat-rate. The metric should scale with the value the customer receives. A per-seat metric for a
product where value comes from data volume (not seat count) creates misalignment: power customers
pay less than their value; light customers pay more. Metric misalignment produces both churn and
expansion cap. Ramanujam & Tacke: "find the value metric first, then set the price per unit of it."

### Pricing and CAC payback

Price level, packaging, and CAC payback interact directly. Higher entry price → faster payback per
customer acquired. But higher entry price can also compress conversion, raising effective CAC.
The metric that matters is **net CAC payback**: (CAC) / (gross margin contribution per month).
A pricing move that raises ARPU by 20% but reduces trial-to-paid conversion by 25% may extend
payback, not shorten it. Model both effects before committing.

## Application

Five interactive questions, one at a time. The session closes with 3-5 ranked pricing-approach
recommendations. Questions are adaptive: later questions use earlier answers to narrow scope.

---

### Q1 — Current pricing motion

"What does your pricing look like today? If you have no product live yet, describe what you've been
assuming.

1. No pricing yet — designing from scratch
2. Flat-rate (single price, all features)
3. Per-seat / per-user
4. Usage-based (consumption metric)
5. Tiered (good/better/best or equivalent)
6. Freemium or free trial leading to paid conversion
7. Custom / negotiated (no published pricing)

If you're redesigning, what's the evidence that the current model is broken? (e.g., enterprise
customers capped at plan ceiling, expansion revenue flat despite usage growth, sales team discounting
heavily to close.)"

---

### Q2 — ICP and value evidence

"Describe the primary buyer you're pricing for and the most concrete evidence you have of the value
your product delivers.

- **Buyer:** role, company size, industry, purchasing authority
- **Value evidence:** what do they get? Hours saved, revenue generated, cost avoided, risk reduced —
  with rough numbers if available
- **Switching context:** what are they using instead — spreadsheets, a competitor, nothing? What
  does that alternative cost them?"

---

### Q3 — WTP signal

"What do you know about what this buyer will pay?

1. No direct evidence — we haven't asked
2. Qualitative: customers have said prices feel high/low/about right in interviews
3. Survey data: we've run price sensitivity research (Van Westendorp, Gabor-Granger, or similar)
4. Behavioural: we have conversion or discount data that shows a price sensitivity point
5. Market proxy: we know what they pay for comparable tools

If you have data, share the key finding. If you don't, we'll note the evidence gap and factor it
into confidence scores."

---

### Q4 — Competitive context

"What are the closest alternatives, and what do they charge?

List 2-3 competitors or substitutes and their approximate pricing if known. Flag whether your
product is positioned as cheaper, comparable, or more expensive — and what justifies the
positioning difference (if any)."

---

### Q5 — Margin and unit economics

"Two numbers to set the financial floor:

- **Estimated gross margin target:** what percentage gross margin does your business model require?
  (If unsure, use 70% as a SaaS benchmark floor.)
- **CAC:** what does it currently cost to acquire one customer? (Or what do you expect it to cost?)

From these we'll calculate the minimum viable price — the floor below which this pricing approach
cannot sustain the business."

---

### Synthesis — 3-5 ranked pricing recommendations

Based on the five inputs, the advisor produces ranked recommendations in this shape:

```
Recommendation N: [pricing method name]
Approach: [what this looks like in practice — the metric, the tier structure, the price point range]
Rationale: [why this method fits the ICP, value evidence, and WTP signal provided]
Margin check: [does it clear the gross margin floor at the stated CAC?]
CAC payback: [estimated payback at this price, given stated CAC and conversion assumptions]
Named tradeoff: [what this approach costs — conversion risk, expansion cap, competitive exposure]
Confidence: [High / Medium / Low] — based on evidence quality provided
Open risk: [the assumption that, if wrong, would break this recommendation]
```

Recommendations are ranked by expected net revenue impact at stated confidence levels.
The lowest-ranked options are not discards — they are bets for different stages of evidence.

## Examples

### Worked example: B2B SaaS moving from per-seat to value-metric pricing

**Context.** A workflow automation tool for mid-market operations teams. Current pricing: $25/seat/
month. Median deployment: 5 seats. ARPA: $125/month. Gross margin: 72%. CAC: $1,800. Payback: 14.4
months. Finance wants payback under 10 months. The evidence: power customers use 3-5x more
automations than light customers at the same seat count. Large customers (8+ seats) are growing
usage 40% YoY. Sales is discounting 20% to close deals because $125/month feels too high for
SMB buyers but too low for enterprise.

**The problem with per-seat.** The pricing metric (seats) doesn't scale with value (automations
run). Enterprise customers paying $200/month get vastly more economic value than SMBs paying $75.
The metric misalignment caps expansion revenue and suppresses pricing power with enterprise.

**Recommendation 1 (highest confidence): Hybrid metric — base fee + automation volume tiers.**
Introduce a base platform fee ($49/month, all team sizes) plus a tiered automation-run component:
up to 1,000 runs/month included; $0.04/run beyond that. Sets a floor that covers margin on small
accounts; creates natural expansion as large customers scale. Estimated ARPA uplift from current
base: 35-45% within two renewal cycles. Margin check: passes at 72% at median usage. CAC payback:
improves to 9-10 months at base tier. Named tradeoff: requires billing infrastructure for usage
metering; adds complexity to the SMB buying conversation.

**Recommendation 2 (medium confidence): Three-tier packaging anchored to automations, not seats.**
Starter ($79/month, up to 500 runs, 3 seats), Growth ($199/month, up to 2,500 runs, 10 seats),
Enterprise (custom). Removes seats as a growth ceiling. Positions Growth as the target tier for
the core ICP. Margin check: passes at Growth tier. Payback: ~11 months at Growth tier average.
Named tradeoff: requires clear feature differentiation between tiers; risk of downgrade pressure
from current customers on the $125 plan.

**Counter-example: "we'll charge what the market charges."**

A different product team benchmarks three direct competitors and sets price at the category median
— $30/seat/month — without running cost-plus or value-based analysis. Six months later: gross
margin is 58% (below the 65% floor for their stage), because infrastructure costs are 40% higher
than the competitor used as the benchmark. Sales is discounting further to close because the
product has no clear value differentiation from the market leader. Expansion revenue is flat because
the pricing metric (seats) doesn't scale with value. The team has competitively priced themselves
into a structurally unsustainable position with no easy exit.

What the counter-example violated: cost-plus analysis would have surfaced the margin problem on day
one. Value-based analysis would have revealed that WTP among their ICP was 40% higher than the
market median because they serve a higher-value workflow. Copying competitor pricing is not a
strategy — it's the absence of one.

## Common Pitfalls

### Pitfall 1 — Pricing without a margin floor

**Symptom.** The team sets price by anchoring to a competitor or to customer feedback without
calculating what the price must be to hit target gross margin at current or projected cost structure.

**Consequence.** The product grows and burns simultaneously: revenue expands while unit economics
deteriorate. Early-stage companies discover this at Series A or B diligence when a clean breakdown
of COGS-per-customer shows unsustainable margins baked into the pricing.

**Fix.** Run cost-plus first, every time. It takes 30 minutes and a spreadsheet. The output is not
a price recommendation — it's a floor. No other method can override it.

---

### Pitfall 2 — Treating WTP as a single number

**Symptom.** The team surveys customers, gets a median WTP of $X, and uses that as the price for
all segments.

**Consequence.** Enterprise buyers — who often have WTP 3-5x higher than SMB — are undercharged.
SMB buyers who fall below the median WTP become a churn cohort. The product is simultaneously
under-monetising its best customers and over-charging its worst fit.

**Fix.** Segment WTP analysis by ICP tier. Enterprise WTP and SMB WTP are different distributions.
Price architecture should reflect this — not uniform pricing with optional discounts, but a tier
structure that captures enterprise value without excluding SMB.

---

### Pitfall 3 — Metric misalignment (charging for what you build, not what customers value)

**Symptom.** The product charges per seat for a tool whose value is throughput, outcomes, or
volume. Customers who get the most value pay the same as customers who barely use the product.

**Consequence.** Natural expansion revenue is capped at the seat count ceiling. Power customers
feel undercharged and never advocate for price increases. Light customers feel overcharged and
churn. NRR is flat despite product-market fit.

**Fix.** Identify the value metric — the thing that scales proportionally with the economic value
a customer receives — and restructure the pricing metric around it. Ramanujam & Tacke: "charge
for the thing that matters to the customer."

---

### Pitfall 4 — Packaging complexity that hurts conversion

**Symptom.** Five or more tiers, each with 15+ feature differentiators, no clear line between them.
Prospect asks "which plan is right for me?" and the answer requires a sales call to decode.

**Consequence.** PLG conversion drops. Sales cycles lengthen. Sales team creates custom packages
per deal, destroying pricing discipline. ARPU varies wildly and becomes impossible to forecast.

**Fix.** Three tiers maximum. Each tier is defined by one buyer persona and one primary value
metric threshold, not a feature checklist. Packaging that requires explanation is packaging that
needs simplification.

---

### Pitfall 5 — The discount spiral

**Symptom.** Sales closes 70% of deals with a discount. The average discount is 25%. Management
treats discounting as a necessary sales motion rather than a pricing problem.

**Consequence.** Realised ARPA is 25% below list price permanently. The discount becomes the
market's expectation. Raising list price feels risky because it will be discounted back down
anyway. CAC payback degrades because discount depth isn't factored into the payback model.

**Fix.** Systematic discounting is a pricing signal, not a sales-execution problem. It means
either the value proposition isn't validated at list price, or the ICP is wrong, or the tier
structure is wrong. Diagnose the cause before treating the symptom with discount policy.

---

### Pitfall 6 — Ignoring CAC payback in the pricing model

**Symptom.** The team celebrates an ARPA increase from a packaging redesign without modelling
whether the new packaging changes the conversion rate, and therefore the effective CAC.

**Consequence.** ARPA is up 20%, conversion is down 22%, effective CAC is up 28%, and payback
is longer than before the redesign. The pricing move looked like a win on one metric and was a
loss on the unit economics that actually drive the business.

**Fix.** Every pricing change must model the full unit-economics effect: (ARPA × gross margin
rate) / CAC = months-to-payback. Run the model at current conversion, conservative conversion
(−20%), and optimistic conversion (+15%) to see the range of outcomes.

## References

- **Madhavan Ramanujam & Georg Tacke** — *Monetizing Innovation: How Smart Companies Design the
  Product Around the Price* (2016, Wiley). The foundational argument that WTP conversations should
  precede product design, not follow it. The concept of "feature shock" (overloading a product
  because pricing was never constrained by willingness-to-pay) traces directly to this work.
  The four monetisation failure modes (feature shock, minivation, hidden gem, undifferentiated)
  are useful diagnostic categories for pricing redesign work.

- **Patrick Campbell / ProfitWell** — Ongoing SaaS pricing research (ProfitWell research library).
  Primary empirical source for WTP benchmarks, discount-depth norms, and the relationship between
  pricing metric alignment and NRR. The finding that companies review pricing once every 2-3 years
  (vs. the recommended 6-12 months cadence) comes from this research. See also Campbell's
  foundational work on value-metric identification and its effect on expansion revenue.

- **Thomas Nagle, John Hogan & Joseph Zale** — *The Strategy and Tactics of Pricing: A Guide to
  Growing More Profitably* (6th ed., Routledge). The canonical five-method framework (cost-plus,
  value-based, competition-based, customer-value, dynamic) and the economic foundations of price
  segmentation used in this skill trace to this work. Nagle et al.'s treatment of "customer
  economics" as the load-bearing input to value-based pricing is the most rigorous treatment
  available in the practitioner literature.

- **Hermann Simon** — *Confessions of the Pricing Man: How Price Affects Everything* (2015,
  Springer). The framing that pricing is a strategic lever, not a tactical decision, and the
  empirical data on the profit leverage of price improvement relative to volume improvement.
  Simon's careers-spanning work on price optimisation makes the case that most companies leave
  significant value on the table by not treating pricing as a first-class strategic discipline.

- **Related Hornero skills:**
  - [`positioning-statement`](../positioning-statement/SKILL.md) — value differentiation from
    competitors is the prerequisite for value-based pricing; price anchored to positioning survives
    competitive pressure that cost-plus pricing cannot.
  - [`revenue-architecture`](../revenue-architecture/SKILL.md) — the system map that shows where
    pricing fits in the expansion loop; necessary context before restructuring a pricing metric.
  - [`success-metrics`](../success-metrics/SKILL.md) — defines the metric stack that a pricing
    change will be measured against; ARPA, NRR, and CAC payback are the primary pricing metrics.
  - [`acquisition-channel-advisor`](../acquisition-channel-advisor/SKILL.md) — companion skill;
    pricing and channel strategy are coupled: PLG pricing differs structurally from sales-led
    pricing, and the channel choice constrains the tier architecture.
  - [`business-health-diagnostic`](../saas-revenue-growth-metrics/SKILL.md) — provides the
    baseline unit economics (ARPA, churn, NRR, CAC) needed to run the margin-floor and payback
    calculations in Q5.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/finance-based-pricing-advisor) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
