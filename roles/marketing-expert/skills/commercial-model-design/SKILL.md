---
name: commercial-model-design
description: Use when designing the whole commercial system for a B2B product or segment — pricing model + packaging + sales motion + expansion mechanics + unit economics, composed into a system that works end-to-end. Composes pricing-strategy with gtm-sequencing into the per-segment commercial machine.
intent: |
  Commercial model is bigger than pricing and smaller than revenue
  architecture. This skill is the per-segment composition: the five
  components must reinforce each other or the system breaks at
  scale. Ramanujam + Moore + Slootman + Aulet anchored.
type: component
theme: commercial
best_for:
  - Designing the commercial system for a new product or segment
  - Diagnosing why current unit economics aren't working (which of the five components is misaligned?)
  - Planning a commercial-model migration (e.g., per-seat → usage-based)
  - Aligning sales motion to pricing model when one has changed and the other hasn't
scenarios:
  - "Series B B2B observability tool designing the full commercial system for early-majority engineering teams"
  - "Vertical SaaS for legal firms choosing between subscription / usage / outcome-based pricing and the sales motion that fits"
  - "Mid-stage company NDR stuck at 95% — diagnose which commercial-model component is the bottleneck"
estimated_time: 4-8 hours (full skill including unit-economics modeling handoff to data-scientist)
---

# Commercial model design

> v0 draft. Anchored in Madhavan Ramanujam's *Monetizing Innovation* (2016), Geoffrey Moore's *Crossing the Chasm* (rev. 2014), Frank Slootman's *Amp It Up* (2022), Bill Aulet's *Disciplined Entrepreneurship* (2013), Mark Ritson's strategic-then-tactical discipline, and April Dunford's positioning-as-packaging framing.

## Purpose

Produce the commercial model for a specific segment: the composed system of
pricing model, packaging, sales motion, expansion mechanics, and the unit
economics that result.

Commercial model design is larger than pricing — pricing is one of five
components, and choosing right price points with a wrong sales motion or
undefined expansion produces a system that breaks at scale. Ramanujam's claim
in *Monetizing Innovation*: most "product failures" are commercial failures.

Smaller than revenue architecture: the PM's
[`revenue-architecture`](../../../product-manager/skills/revenue-architecture/SKILL.md)
maps the full cross-segment growth graph; commercial model design is the
per-segment input that feeds it.

The artifact answers: for this segment, which pricing archetype, packaging
logic, sales motion, expansion mechanic — and do the five components reinforce
each other, or does one break the others?

## Key Concepts

### The five components of a commercial model

Every commercial model for a B2B segment has five components. All five must be
specified; unspecified components default to whatever emerged from the last deal,
which is not a commercial model.

1. **Pricing model archetype.** The structural shape of how revenue is recognized
   — subscription, usage-based, outcome-based, freemium, transaction, or hybrid.
   Not the price points (that is [`pricing-strategy`](../pricing-strategy/SKILL.md));
   the shape.

2. **Packaging.** Which features belong in which tier, and why. Packaging makes
   the pricing model operational and communicates positioning — Dunford's insight
   that tier composition is positioning made concrete. A $500/mo tier that includes
   SSO says something about who the $500 buyer is; a $500/mo tier without SSO says
   something different.

3. **Sales motion.** How the product reaches the buyer and converts. Self-serve,
   product-led growth, inside-sales, field-sales, partner-led, community-led.
   The sales motion must be financially supported by the deal economics: if the
   ACV cannot absorb the cost of the motion, the system is broken.

4. **Expansion mechanics.** How revenue per customer grows over the contract
   lifecycle — seat expansion, usage expansion, module expansion, multi-product
   expansion. B2B SaaS unit economics at scale depend on net dollar retention
   above 110%; that rate is a function of which expansion mechanic is built in,
   not hoped for.

5. **Unit economics that result.** The financial output of the first four
   components: ACV, ARR trajectory, LTV, CAC, payback period, gross margin,
   net dollar retention. These are not inputs to the model; they are the test
   of whether the model works.

### Pricing model archetypes — when each fits

Ramanujam (*Monetizing Innovation*) frames archetype choice by how buyers
perceive value — cadence, predictability, distribution across the base:

- **Subscription (fixed recurring).** Flat rate per period, typically per-seat
  or per-account. Fits when value accrues continuously, WTP for predictability
  is high, and usage is uniform. Predictable ARR; expansion limited to seat
  adds unless a second mechanic is layered.

- **Usage-based.** Pay for consumption (API calls, compute, data volume).
  Fits when value scales with use, WTP distribution is wide, and the unit is
  clear and measurable. Strong for infrastructure, observability, data
  pipelines. High revenue variance; organic expansion; low new-customer
  friction. Needs a usage floor to protect margin.

- **Outcome-based.** Pay as a function of results — % of revenue generated,
  cost savings, successful transactions. Fits when outcomes are measurable,
  attributable, and large relative to fee. Highest WTP ceiling; hardest to
  sell (must agree on what counts); margin volatile. Growing in AI-native
  products where output value is legible.

- **Freemium.** Permanently free tier as PLG engine. Fits when WTP
  distribution is bimodal and free usage has near-zero marginal cost.
  Ramanujam's WTP-distribution test: most B2B freemium fails it — free costs
  real money, zero-WTP doesn't convert. Freemium because competitors have it
  is a pitfall.

- **Transaction / event-based.** Pay per discrete event (per document, per
  hire, per contract). Fits when value events are discrete, buyer volume is
  episodic, and subscription framing would feel unfair in low-usage periods.

- **Hybrid.** Platform subscription + usage, or per-seat + outcome uplift.
  Fits dual-shape value (predictable baseline + variable peak). More complex
  to sell; the buyer must understand two pricing shapes at once.

### Packaging logic — four gating strategies

Which features per tier; what triggers upgrade. Each strategy carries
positioning implications (Dunford):

- **Usage-volume gating.** Tiers by consumption (API calls, seats, storage).
  Upsell as natural expansion. Risk: limits can feel punitive; buyers plan
  around them.

- **Feature gating.** Tiers by capability (SSO, audit logs, advanced
  analytics). Upper tier serves early-majority whole-product needs (Moore).
  Risk: gating buyer-table-stakes features creates resentment.

- **Support-tier gating.** Tiers by SLA / response time / dedicated CSM /
  implementation. Common in enterprise. Risk: unmodeled support cost makes
  the enterprise tier subsidize cost rather than create margin.

- **Integration gating.** Tiers by ecosystem depth (data-warehouse connectors,
  HRIS, SFDC native). Strong in data infrastructure where integration depth
  is the whole product.

### Sales motion taxonomy and Moore's adoption-lifecycle mapping

Sales motion is segment-specific. Moore (*Crossing the Chasm*) maps buyer
adoption phase to how buyers evaluate risk:

- **Self-serve / PLG.** No sales contact. Fits <$5K ACV, technically
  sophisticated buyers, early-adopter segments. Margin-friendly; scales without
  headcount.

- **Inside-sales (inbound + outbound SDR + AE).** Phone/video, no in-person.
  Fits $10K–$200K ACV — the dominant motion for early-majority B2B SaaS.
  Moore: pragmatists need reference stories and risk reduction; inside-sales
  can deliver these without field economics.

- **Field-sales (enterprise AE + SE + sponsor).** In-person, multi-stakeholder,
  long-cycle. Fits $150K+ ACV, procurement committees, multi-year contracts.
  Required when the buyer demands executive assurance; deal economics must
  support the cost.

- **Partner-led / channel.** VARs, SIs, ISV marketplace. Fits when buyers
  already trust a channel partner, international expansion needs local
  relationships, or the product plugs into a partner's platform. Margin
  shared; notoriously hard to activate.

- **Community-led.** Practitioner-community word-of-mouth. A pipeline
  accelerant on top of a sales motion, not a substitute for one.

### Expansion mechanics — four types

Where B2B SaaS unit economics are made or broken. NDR >110% = base grows
without new acquisition; NDR <100% = churn exceeds expansion and the company
leaks at scale.

- **Seat expansion.** Revenue grows with users added. Predictable; ceiling is
  organization size. Aligns incentive (more users = more value delivered).

- **Usage expansion.** Revenue grows as the buyer does more. Organic in
  usage-based pricing; needs intentional triggers in subscription models. No
  ceiling in principle; volatile in downturns (buyers cut usage before seats).

- **Module expansion.** Adoption of additional product lines from the same
  vendor. Requires a portfolio; land product opens the door; cross-sell
  follows.

- **Multi-product expansion.** Platform model — third-party apps / partner
  add-ons expand value. Long lead time; high LTV ceiling; platform investment
  required.

### Unit economics primitives

These are the financial outputs the commercial model must produce. Definitions
are brief; rigorous computation belongs to the data-scientist's
[`metric-definition`](../../../../data-scientist/skills/metric-definition/SKILL.md)
skill.

- **ACV (Annual Contract Value).** Annual revenue per new customer commitment.
  Determines which sales motion is economically viable.
- **ARR (Annual Recurring Revenue).** Total committed recurring revenue across
  the base. North Star for subscription businesses.
- **LTV (Lifetime Value).** Net revenue per customer over the full relationship.
  LTV = (ACV × gross margin) ÷ gross revenue churn rate.
- **CAC (Customer Acquisition Cost).** Total sales and marketing spend to close
  one new customer, fully loaded. CAC = (total S&M spend) ÷ (new customers in period).
- **Payback period.** Months to recover CAC from gross margin. CAC ÷ (ACV × gross
  margin / 12). Industry benchmarks: <12 months (venture-stage), <18 months
  (growth-stage acceptable), >24 months (structural problem).
- **Gross margin.** Revenue minus cost of goods sold (hosting, support, implementation)
  as a percentage of revenue. SaaS median ~70-75%; product with professional-services
  component ~50-60%.
- **Net dollar retention (NDR).** ((beginning ARR + expansion - contraction - churn)
  ÷ beginning ARR) × 100, measured for a cohort over 12 months. NDR >110% is the
  flywheel; NDR <100% is a structural leak.

### Slootman's commercial-velocity equation

Frank Slootman (*Amp It Up*) distills enterprise commercial performance to:

**commercial velocity = (deal size × win rate × pipeline coverage) ÷ sales cycle**

Every variable in a commercial model trades against the others:

- Raising deal size (moving upmarket) lengthens the sales cycle and may lower
  win rate until the motion adapts.
- Improving win rate often requires higher sales investment, raising CAC.
- Shortening the sales cycle often requires self-serve or inside-sales, which
  caps deal size.
- Increasing pipeline coverage requires marketing spend or SDR headcount.

The discipline Slootman insists on: name the trade-off explicitly. Executives
who believe they can improve all four variables simultaneously without trade-offs
are wrong, and the commercial model needs to state which variables are being
optimized and at the cost of which others.

### The composability test

The five components must reinforce each other. The most common failure modes:

- The sales motion's cost structure is incompatible with the ACV the pricing
  model generates. Field-sales costs $80K-$200K to close a deal; a $50/mo
  product can never absorb that.
- The packaging's gated features do not match the upgrade drivers for the chosen
  segment. The early majority needs SSO and audit logs; packaging that gates
  these at the enterprise tier correctly reads the segment.
- The expansion mechanic assumes growth that the sales motion cannot deliver.
  Inside-sales that closes on seat count cannot drive usage expansion if usage
  is never discussed in the sales process.

Run the composability test after specifying all five components: are there
internal contradictions? Usually one component is wrong.

## Application

### Step 1 — Confirm the segment from gtm-sequencing

The commercial model is per-segment. Before designing, name the segment using
the output of [`gtm-sequencing`](../gtm-sequencing/SKILL.md): company stage,
size, buyer role, current pain, Moore adoption-lifecycle position, and why this
segment is the beachhead. If gtm-sequencing has not been run, run it first.
Commercial model design on an undefined segment produces a design for the
average buyer, which is a design for nobody in particular.

### Step 2 — Confirm the pricing model and tier structure from pricing-strategy

Retrieve the pricing model archetype and tier structure from
[`pricing-strategy`](../pricing-strategy/SKILL.md): which archetype was chosen
(subscription / usage / outcome / hybrid), what the tier boundaries are, and
the WTP evidence behind those boundaries (Ramanujam). If pricing-strategy is
a draft, note which assumptions are unvalidated. The commercial model design
inherits these inputs; it does not re-derive them. If the pricing-strategy
output is stale or missing, flag that before proceeding.

### Step 3 — Name the packaging logic

For each tier, state:
- Which features are included and which are gated to the next tier.
- The gating strategy (usage-volume / feature / support / integration — or a
  combination).
- Why this packaging serves the segment's whole-product requirements (Moore:
  the early majority's whole product is the reason feature gating must include
  SSO, audit logs, SLA — not because they are technically complex, but because
  the enterprise procurement process demands them).
- The Dunford check: does this packaging signal "this is built for you" to the
  target buyer? Could a buyer self-identify from the tier composition alone?

### Step 4 — Choose the sales motion

Apply two lenses in sequence:

**Moore's adoption-lifecycle lens.** Is the target segment early adopter, early
majority, late majority? Early adopters tolerate and prefer high-touch; they want
to be co-architects. Early majority demands proof, references, and a predictable
implementation path. Late majority wants standardization. The sales motion must
match.

**Aulet's beachhead economics lens.** Does the ACV support the cost structure of
the chosen motion? Use the rough benchmarks: self-serve supports <$5K ACV; inside-
sales supports $10K-$200K; field-sales requires $150K+. Where the target ACV sits
ambiguously (e.g., $50K-$80K), note the tension and decide which direction the
model optimizes toward.

State the motion clearly and state what it is not: "inside-sales, not field-sales"
or "product-led growth with inside-sales assist at the $20K+ tier, not pure self-serve."
Hybrid motions are valid and common; they must be specified, not assumed.

### Step 5 — Design the expansion mechanic

Name the primary expansion mechanic (seat / usage / module / multi-product) and
state:
- What triggers expansion in practice — what behavior or event causes the customer
  to spend more?
- Who owns the expansion motion — customer success, account management, product
  itself (PLG expansion)?
- What the target NDR is for this segment and how the expansion mechanic produces it.
- Whether the segment structurally supports expansion. Some segments are one-and-done
  (a small company that buys one seat forever); if the unit economics require NDR
  >110% and the segment cannot produce it, the commercial model is wrong for this segment.

### Step 6 — Sketch the unit economics structure

Produce a unit-economics sketch for the segment:
- **Target ACV** (from the pricing model and typical deal size).
- **Target LTV/CAC ratio.** Healthy B2B SaaS benchmarks: >3x at maturity.
- **Target payback period.** <18 months at growth stage.
- **Target gross margin.** >70% for pure SaaS; adjust for implementation-heavy
  products.
- **Target NDR.** >110% for the expansion mechanic to work as designed.

This is a sketch, not a model. Flag which numbers are validated against real
deal data and which are targets. The data-scientist's
[`metric-definition`](../../../../data-scientist/skills/metric-definition/SKILL.md)
skill handles the rigorous computation.

### Step 7 — Run the composability test

With all five components specified, check for internal contradictions:

1. **Sales motion ↔ ACV check.** Does the chosen motion's cost-to-acquire fit
   inside the unit economics target? If field-sales costs $120K to close a
   customer and the target ACV is $80K with a 14-month payback, the math
   doesn't work at field-sales cost levels. Either the motion must change or
   the target ACV must rise.

2. **Packaging ↔ segment check.** Do the gated features match the upgrade drivers
   for this specific segment? Run the Dunford self-identification test: a buyer
   from the target segment should be able to read the tier names and feature gates
   and immediately understand which tier is theirs.

3. **Expansion mechanic ↔ sales motion check.** Is expansion built into the sales
   motion, or is it an afterthought? Inside-sales deals that are structured as
   annual flat-rate contracts with no expansion trigger produce low NDR regardless
   of the expansion mechanic designed on paper.

4. **Unit economics ↔ whole model check.** Plug the numbers. Given target ACV,
   estimated CAC from the motion, estimated gross margin, and estimated NDR,
   does the LTV/CAC ratio hit the target? Where does it break?

Name the specific misalignment if one exists. Usually one component is the
problem. Slootman's discipline: state the trade-off explicitly rather than
hoping the model will resolve itself in the field.

### Step 8 — Name the named bets in the model

Every commercial model rests on assumptions that may be wrong. Name them:

- "This model assumes inside-sales can close $80K ACV in 60 days or fewer. If
  the cycle is 90+ days, CAC rises 30% and payback exceeds 18 months."
- "This model assumes seat expansion produces 120%+ NDR. If the segment doesn't
  add headcount in year 2, NDR falls to 105% and the LTV/CAC target is missed."
- "This model assumes the early-majority segment will pay for the SSO-gated
  enterprise tier. If procurement doesn't require SSO, the upgrade trigger is
  absent."

Flag these as named bets in the PM's
[`bet-portfolio`](../../../product-manager/skills/bet-portfolio/SKILL.md) format.
A commercial model with no named bets is not a model — it is a plan without a
risk register.

### Step 9 — Define the rollout or migration plan

If this commercial model is new (first entry into the segment), state the
rollout sequence: which early customers will be used to test the model,
what signals confirm the model is working, and when the first composability-test
revision should be run.

If this commercial model replaces an existing one (per-seat → usage-based, or
inside-sales → product-led growth), state the migration plan:
- How existing customers transition — whether they are grandfathered, migrated on
  renewal, or migrated on a fixed date.
- Which existing customers are most at risk from the change (those whose economics
  get worse under the new model).
- What the communication plan is and who owns it (commercial-model changes are
  among the highest-trust-risk events in a customer relationship; handled badly,
  they produce churn among the best customers first).

## Examples

### Example A — B2B observability tool, early-majority engineering teams

**Segment (from gtm-sequencing):** Engineering teams at companies with 200-2,000
engineers. Moore: early majority — they want reference customers, documented
implementation paths, and enterprise procurement readiness (SSO, audit logs, SLA).
Buyer is VP Engineering or Platform Engineering Lead. Economic decision-maker is
VP Engineering or CTO for deals above $100K.

**Pricing model (from pricing-strategy):** Usage-based. Billing is per-host-per-month
with three volume tiers — up to 100 hosts, 101-500 hosts, 501+ hosts. Volume tiers
provide predictability at scale; the usage shape aligns with how the segment
perceives value (observability cost scales with infrastructure size, which is legible
to the buyer). WTP research confirmed that per-host billing is familiar and expected
in this category; seat-based billing was tested and rejected by buyers as misaligned
with how they think about the product.

**Packaging:**
- *Starter* (up to 100 hosts): 7-day data retention, standard alerting, community
  support, standard integrations. Designed as a land tier for small teams or
  proof-of-concept — not the segment's whole product, but enough to demonstrate
  value.
- *Team* (up to 500 hosts): 30-day retention, advanced alerting + anomaly detection,
  SLA, standard SSO. The early-majority whole product starts here — 30-day retention
  is a compliance requirement in many engineering procurement checklists; SSO is
  gated here because the early majority's IT security review demands it.
- *Enterprise* (500+ hosts): 90-day retention, full audit logs, dedicated CSM,
  custom data retention agreements, advanced RBAC, priority support. Procurement-
  grade packaging for the buyers with legal and security review requirements.

Dunford check: a VP Engineering at a 500-engineer company reads "Team: SSO, 30-day
retention, SLA" and self-identifies correctly. The tier composition communicates
"built for infrastructure-scale engineering orgs."

**Sales motion:** Inside-sales. Field-sales does not fit the deal economics: the
target ACV range is $50K-$150K and field-sales cost-to-close exceeds $100K,
which works only at the high end. Pure self-serve does not fit the procurement
requirements of the early majority: legal review, security questionnaire, SLA
negotiation, and custom MSA require human handling. The inside-sales motion
with a product-led onramp is the correct composition:
- Starter tier available self-serve (no AE required; serves as a pipeline-builder
  for small teams that may grow into Team or Enterprise).
- Team and Enterprise require an AE + SE; deal cycle typically 30-60 days;
  SE handles security questionnaire and proof-of-concept support.

**Expansion mechanic:** Primary: host-growth expansion (usage expansion — as the
customer's infrastructure grows, host count grows, ARR grows automatically within
the tier). Secondary: product-line cross-sell (the vendor has a separate incident
management module; expansion to that module is the module-expansion mechanic).
Customer success owns renewal and expansion. Target NDR: 130%.

**Unit economics sketch:**
- Target ACV: $80K (blended across the $50K-$150K range; median deal landing
  in Team tier).
- Estimated CAC: $35K (inside-sales fully loaded: SDR + AE + SE allocation + marketing).
- Target LTV/CAC: 3.5x.
- Target payback period: 14 months.
- Target gross margin: 72%.
- Target NDR: 130%.

**Composability test:** The model is largely coherent, with one tension. The inside-
sales motion is tight at the low end of the ACV range: a $50K deal with $35K CAC
produces a payback of 18 months, which is at the edge of acceptable. The composability
test surfaces a recommendation: add a self-serve onramp tier at $500-$2,000/month
(Team Starter) to build pipeline from small teams that the inside-sales motion
would otherwise ignore. Some of these will grow into $80K+ deals; the self-serve
tier functions as a lower-CAC acquisition path for the segment's smaller end.

**Named bets:** (1) The inside-sales cycle assumption (30-60 days) is based on
comparable category vendors; if the security review process lengthens cycles
past 90 days, CAC rises materially. (2) NDR 130% assumes host-count growth
tracks customer revenue growth; if customers optimize infrastructure in a
downturn, NDR falls. (3) The self-serve onramp-to-paid conversion is an
assumption with no historical data; validate in the first two quarters.

---

### Example B — Vertical SaaS for legal firms

**Segment:** Law firms in two sub-segments — large firms (50+ partners) and
mid-market firms (10-49 partners). Two distinct commercial models are under
consideration; this example shows how the design process surfaces the refusal.

**Pricing model debate:** Three options on the table — per-seat subscription,
usage-based per document, outcome-based as % of matter revenue. Ramanujam WTP-
distribution test against the managing-partner buyer profile:

- *Per-seat subscription.* WTP for cost predictability is high — legal firms
  budget annually; variable costs complicate partner compensation. Subscription
  matches the buyer's financial operating model.
- *Usage-based.* Creates variance the buyer explicitly rejects ("I need to know
  what this costs at the start of the year"). Fails the WTP test. The team was
  attracted because usage-based is the current SaaS-architecture default —
  pricing's version of "freemium because everyone has freemium."
- *Outcome-based.* Attributing matter revenue to software is contested; partners
  don't accept external attribution of their origination. Rules out.

**Decision: per-seat subscription** — not as the default, but because WTP
evidence rules out the alternatives. The refusal is load-bearing.

**Packaging (feature gating by firm tier):**
- *Solo / small* (<10 partners): Core matter management + document automation.
  No SSO, no API. Lead-gen funnel for mid-market; not the primary commercial tier.
- *Professional* (10-49 partners): Full matter management + document automation +
  client portal + conflict-check automation + SSO + standard integrations (Outlook,
  NetDocuments). The early-majority whole product for mid-market firms: SSO is
  required by IT; client portal is required by competitive comparison set; conflict-
  check is a compliance requirement.
- *Enterprise* (50+ partners): All Professional + custom RBAC + multi-office support
  + dedicated implementation + SLA + compliance pack (SOC 2 documentation, BAA).
  Large-firm procurement requires the compliance pack; without it, the deal stalls
  in security review.

**Sales motion:** Segmented by firm size:
- Solo/small: self-serve via website. ACV too low ($5K-$15K) to support AE involvement.
- Professional (10-49 partners): Inside-sales. ACV $25K-$80K; procurement requires
  a demonstration and contract review but not in-person engagement.
- Enterprise (50+ partners): Field-sales. ACV $100K-$400K; procurement involves
  managing partner, IT, general counsel's office, and sometimes an external
  procurement consultant. Moore: large-firm buyers are late-early-majority with
  high assurance requirements; field-sales is the only motion with credibility
  in this buyer environment.

Moore's adoption-lifecycle mapping is explicit here: the same product, in the same
category, requires different motions for different buyer risk profiles. Defaulting
to one motion across all firm sizes would either over-invest in the small end
(field-sales to close $10K deals) or under-invest in the large end (inside-sales
stalling in enterprise procurement).

**Expansion mechanic:** Primary: seat expansion (headcount growth at the firm).
Secondary: office expansion (multi-office deployments from firms that acquired
another practice). Target NDR: 115% for Professional tier; 125% for Enterprise.
Note: the solo tier has effectively zero expansion potential — single-person firms
don't grow into multi-seat Professional customers. This is not a flaw; the solo
tier exists as a lead-gen funnel, not an expansion segment.

**Composability test:** Coherent. Per-seat subscription + feature gating + segmented
sales motion + seat expansion is a well-matched composition for a traditional
professional-services buyer with predictability requirements. The one composability
flag: the solo tier's self-serve motion produces leads that require inside-sales
conversion — the handoff must be designed (when does a self-serve solo user get an
SDR touch? What's the signal?). Undesigned, this produces an SDR who cold-calls
everyone, or one who calls nobody.

**Named bets:** (1) Seat expansion assumes firm headcount grows — this is the
sector norm but not guaranteed in a downturn. (2) Enterprise field-sales ACV
assumption ($100K-$400K) is based on competitive benchmarks; validated by four
pilot deals; sample too small to be definitive. (3) The solo-to-Professional
conversion funnel is unproven; the first cohort will calibrate expected conversion
rates.

## Common Pitfalls

### Pitfall 1 — Mismatched sales motion and pricing model

**Symptom:** The team designs a usage-based product at $50/month base + consumption
and assigns a field-sales team to close deals.

**Consequence:** Field-sales costs $80K-$150K per closed deal fully loaded. A $50/mo
base never produces an ACV that supports field-sales economics. The sales team
doesn't make quota; the model is changed mid-cycle; existing deals are confusing.

**Fix:** The composability test (Step 7) surfaces this before any sales hires are made.
ACV must support the chosen motion; if it doesn't, either the ACV target rises
(move upmarket) or the motion changes (move to inside-sales or self-serve).

### Pitfall 2 — Pricing without packaging

**Symptom:** The team decides on a three-tier subscription model but does not
specify which features go in which tier. Tiers are named Starter / Pro / Enterprise
with prices; feature composition is deferred to the product roadmap.

**Consequence:** Dunford: tier composition is positioning made operational. Deferred
packaging means deferred positioning. Buyers cannot self-identify; sales is forced
to explain what Pro includes on every call; the enterprise tier doesn't close because
it isn't clear what makes it enterprise.

**Fix:** Packaging is specified alongside pricing, not after. Step 3 is not optional.
The Dunford self-identification test must pass before the commercial model is approved.

### Pitfall 3 — Expansion mechanics as afterthought

**Symptom:** The commercial model specifies pricing, packaging, and sales motion.
Expansion is noted as "account management will upsell" with no trigger, no mechanic,
no NDR target.

**Consequence:** Most B2B SaaS unit economics at scale depend on NDR >110%. Without
a designed expansion mechanic, NDR drifts to 95-105% — the installed base leaks
faster than it grows. The company needs more and more new-customer acquisition
just to maintain ARR.

**Fix:** The expansion mechanic is a designed component, not a hoped-for behavior.
Step 5 specifies the trigger, the owner, and the NDR target.

### Pitfall 4 — Land-and-expand assumed for every segment

**Symptom:** The model assumes seat expansion or usage expansion because every
other B2B SaaS product has a land-and-expand model.

**Consequence:** Some segments are structurally non-expanding. A one-location
retail business that buys a POS product has five users forever. If the unit
economics require NDR >110% and the segment cannot produce it, the model fails
on a target it could never have hit. The company under-acquires because it
expected expansion that never came.

**Fix:** Step 5 includes a segment-expansion-capacity check. Not every segment
expands; that is not a flaw if the entry ACV is high enough and the payback
period is short enough that first-year economics work without expansion.

### Pitfall 5 — Conflating commercial model with pricing strategy

**Symptom:** The team completes a pricing strategy exercise (price points, tier
names, WTP research) and considers the commercial model done.

**Consequence:** Pricing is one of five components. The sales motion, packaging
logic, and expansion mechanic are unspecified. Deals are closed inconsistently;
different AEs develop different sales motions independently; expansion happens
on whoever happens to make a renewal call.

**Fix:** Pricing strategy is an input to Step 2. The commercial model is not
complete until all five components are specified and the composability test passes.

### Pitfall 6 — Skipping the composability test

**Symptom:** The team designs each component independently — product team designs
packaging, sales leader designs the motion, finance sets the unit economics targets —
and no one checks whether the components are mutually consistent.

**Consequence:** Usually one component is broken. The most common: the unit economics
target requires an LTV/CAC of 3x, but the sales motion's cost structure can only
achieve 1.8x at the target ACV. The model ships; the sales team works hard; the
unit economics never close.

**Fix:** Step 7 is mandatory. Run the composability test with all five components
specified before any resource commitments.

### Pitfall 7 — Freemium by default

**Symptom:** The product team proposes a freemium tier because the most visible
PLG competitors have freemium.

**Consequence:** Ramanujam's WTP-distribution test applied to most B2B products:
the free-tier user population does not convert at rates that justify the cost of
serving them. Free users cost real money — support load, infrastructure, compliance
surface. The conversion to paid is 1-3% in most B2B freemium products; the math
often doesn't work.

**Fix:** Run the WTP-distribution test before approving freemium. Is the WTP
distribution genuinely bimodal (large zero-WTP segment that generates referral
value, clear upgrade path for the paying segment)? If the distribution is unimodal
— everyone who uses the product would pay something — freemium is giving away
margin without a conversion mechanism. A free trial with a time or feature limit
is a better default.

### Pitfall 8 — Migration plan unaddressed

**Symptom:** The team designs a new commercial model (per-seat → usage-based, or
inside-sales → PLG) and focuses entirely on the new-customer experience. Existing
customer transition is a "later" problem.

**Consequence:** Commercial-model migrations are high-trust-risk events. Existing
customers who are financially advantaged under the old model will churn before
the migration completes. Customers who feel surprised by a commercial change lose
trust faster than customers who are told a change is coming and given a transition
path.

**Fix:** Step 9 is not optional for migration scenarios. The migration plan names
the at-risk customers, states the grandfathering or transition timeline, and assigns
communication ownership before the new model launches.

### Pitfall 9 — Treating commercial model as a marketing artifact

**Symptom:** The CMO or head of marketing owns the commercial model design. Sales,
finance, and customer success are informed after the fact.

**Consequence:** The commercial model is a cross-functional commitment. Finance
plans headcount and gross-margin assumptions against it. Customer success is staffed
against the expected NDR. Sales builds its compensation structure against the deal
economics. A commercial model designed by marketing without these inputs is missing
constraints that will surface as plan misses.

**Fix:** Commercial model design is a cross-functional exercise. Marketing owns
the process; sales, finance, and customer success are required reviewers before
the model is approved. Disagreements logged as named bets or escalated, not silently
deferred.

## References

- **Madhavan Ramanujam** — *Monetizing Innovation: How Smart Companies Design the
  Product Around the Price* (2016, with Georg Tacke). WTP-distribution test; pricing
  model archetypes; four monetization failure modes. See `roles/marketing-expert/sources.md`.
- **April Dunford** — *Obviously Awesome* (2019). Packaging as positioning made
  operational; tier composition as buyer self-identification. See
  `roles/marketing-expert/sources.md`.
- **Mark Ritson** — strategic-then-tactical marketing planning; the commercial model
  is a strategic commitment, not a campaign artifact. See
  `roles/marketing-expert/sources.md`.
- **Geoffrey Moore** — *Crossing the Chasm* (rev. 2014). Sales motion mapping to
  adoption-lifecycle position; whole-product requirements for the early majority.
  Anchored in `roles/product-manager/sources.md`; cross-role pointer in
  `roles/marketing-expert/sources.md`.
- **Frank Slootman** — *Amp It Up* (2022). Commercial-velocity equation; the
  discipline of naming trade-offs explicitly. See `roles/marketing-expert/sources.md`
  (see-also).
- **Bill Aulet** — *Disciplined Entrepreneurship* (2013, rev. 2024). Business model
  archetype selection; beachhead economics as a constraint on sales motion choice.
  See `roles/marketing-expert/sources.md` (see-also).

**Sibling marketing skills:**
- [`pricing-strategy`](../pricing-strategy/SKILL.md) — price points, tier structure,
  and WTP evidence. Input to Step 2.
- [`gtm-sequencing`](../gtm-sequencing/SKILL.md) — segment selection and
  beachhead logic. Input to Step 1.
- [`positioning-canvas`](../positioning-canvas/SKILL.md) — the positioning anchor
  that packaging must reflect.
- [`launch-brief`](../launch-brief/SKILL.md) — downstream: once the commercial model
  is designed, launch-brief is how you go to market with it.

**Cross-role:**
- [`roles/product-manager/skills/revenue-architecture/SKILL.md`](../../../product-manager/skills/revenue-architecture/SKILL.md)
  — the systems-view across all segments. Commercial model design produces the
  per-segment inputs that revenue-architecture integrates.
- [`roles/product-manager/skills/bet-portfolio/SKILL.md`](../../../product-manager/skills/bet-portfolio/SKILL.md)
  — named bets from Step 8 belong in the bet portfolio. A commercial-model shift
  may itself be a named bet.

**Data-scientist handoff:**
- [`roles/data-scientist/skills/metric-definition/SKILL.md`](../../../../data-scientist/skills/metric-definition/SKILL.md)
  — unit economics sketched in Step 6 require rigorous metric definitions (LTV, CAC,
  NDR, payback) before they become planning inputs. Route to data-scientist for
  the hardened computation.

**External:**
- Ramanujam, Madhavan and Georg Tacke. *Monetizing Innovation: How Smart Companies
  Design the Product Around the Price*. Wiley, 2016.
- Aulet, Bill. *Disciplined Entrepreneurship: 24 Steps to a Successful Startup*.
  Wiley, 2013 (rev. 2024).
- Slootman, Frank. *Amp It Up: Leading for Hypergrowth by Raising Expectations,
  Increasing Urgency, and Elevating Intensity*. Wiley, 2022.
- Moore, Geoffrey A. *Crossing the Chasm: Marketing and Selling Disruptive Products
  to Mainstream Customers*. HarperBusiness, rev. 2014.
