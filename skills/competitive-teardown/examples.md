# Competitive teardown: worked example

Reference file for [`SKILL.md`](SKILL.md). The full worked example the Examples section points to.

### Worked example — vertical SaaS bookkeeping teardown

**Scope.** Competitor: Ledgerly (fictional), a bookkeeping platform for e-commerce SMBs.
Trigger: Ledgerly closed a $30M Series B and announced a new "analytics" tier.
Segment focus: e-commerce SMBs ($1M-$10M GMV, 1-3 FTEs in finance).
Job focus: "close the books in 2 days."

---

**Product surface map (abbreviated)**

| Capability | Starter ($49/mo) | Pro ($149/mo) | Analytics ($349/mo) |
|---|---|---|---|
| Automated bank feeds | Yes | Yes | Yes |
| Multi-channel revenue reconciliation | Shopify only | Shopify + Amazon + Etsy | All + custom |
| Month-end close workflow | Manual checklist | Guided workflow | Guided + review flags |
| COGS tracking | No | Yes | Yes |
| Analytics dashboard | No | No | Yes |
| Dedicated bookkeeper | No | No | Yes |

Activation flow: sign up → connect Shopify (mandatory first step) → automated categorization
demo → push to Pro trial. First-session job assumption: "see your revenue reconciled without
touching a spreadsheet."

---

**Positioning map**

Category claim: "bookkeeping built for e-commerce."
Target buyer: "Shopify store owners who are done with spreadsheets."
Promised land: "know your numbers without a finance degree."
Competitive alternative implied: spreadsheets + manual bookkeeping + generic tools like
QuickBooks (named in their FAQ).

---

**Segment classification**

**Moore:** Pragmatist segment. Pricing structure, guided workflow, and dedicated-bookkeeper
tier all signal a buyer who wants a solution that works without configuration. Not innovators
(no API, no white-glove onboarding for custom setups) and not early adopters (no power
features, no community-of-practice signals).

**Christensen:** Sustaining innovation relative to QuickBooks (better on e-commerce
reconciliation). Potentially disruptive relative to traditional bookkeeping services (same
job at lower cost via automation). Neither disrupts our current product.

---

**JTBD comparison**

Ledgerly job: *When I need to close the month for my Shopify store, I want to reconcile
revenue across channels without manually exporting CSVs, so I can have accurate numbers by
the 3rd without paying a bookkeeper $2,000/month.*

Our product's job (hypothesized): *When I need to close the month for my multi-channel
e-commerce business, I want to see COGS, contribution margin, and cash position in one
view, so I can make buying decisions for the next quarter without waiting for my accountant.*

**Overlap analysis:** Both hired for "close the books in 2 days." However, Ledgerly's job
is hired by Shopify-first SMBs focused on revenue reconciliation; our job is hired by
multi-channel operators who need margin visibility for buying decisions. **Same functional
job; different sub-segment and different depth of financial analysis required.** This is
adjacent competition, not direct competition — unless Ledgerly's Analytics tier is an
attempt to shift toward our sub-segment.

**Four forces for a Ledgerly customer switching to us:**
- Push: Ledgerly doesn't cover Amazon + Etsy natively in lower tiers; multi-channel
  operators hit limits fast.
- Pull: Our margin analysis and buying-decision support is the promised land they can't
  get from Ledgerly.
- Anxiety: Switching means re-mapping 12 months of historical data and retraining the
  person who does reconciliation.
- Habit: Ledgerly's automation is genuinely good; the status quo is not painful enough
  for single-channel operators.

---

**Switching-cost asymmetry**

| Direction | Structural friction | Experiential friction |
|---|---|---|
| Ledgerly → Us | Annual contracts (Pro, Analytics); Shopify data in their format | Historical categorization remapping; team retraining |
| Us → Ledgerly | Monthly contracts (us); data export is clean CSV | Lower — their activation flow is fast |

**Asymmetry:** Ledgerly's annual contracts are higher exit friction for their customers;
our monthly contracts are lower exit friction for ours. They have higher installed-base
stickiness per customer; we have lower acquisition friction but must re-win each month.
This is a retention-vs-acquisition tradeoff, not a product quality difference.

---

**Strategic Implications**

**Implication 1 — The Analytics tier is a segment-crossing signal.**
Ledgerly's $30M raise funded a new Analytics tier with a dedicated bookkeeper. This is
a direct move toward the margin-and-decision-support job our product is hired for. They
are sustaining innovators moving upmarket toward our sub-segment. The implication for our
diagnosis: the window in which margin analysis is our differentiator is narrowing.
Recommendation: **Build** — accelerate margin analysis depth (COGS automation, contribution
margin by SKU) before Ledgerly's Analytics tier matures in their user base. Define a
timeline: 18 months before their tier reaches product maturity based on typical Series B
roadmap velocity.

**Implication 2 — Monthly contracts are an acquisition asset and a retention liability.**
Our month-to-month pricing is a lower entry barrier than Ledgerly's annual contracts, but
it means we re-compete retention every month. Our diagnosis should name "monthly churn risk
from better-capitalized competitors" as an explicit challenge rather than treating pricing
flexibility as an uncomplicated advantage.
Recommendation: **Build** — develop a retention moat that does not require annual contracts:
switching-cost depth via integrations (Amazon Seller Central, Faire, Faire Wholesale) that
Ledgerly doesn't cover, plus a data export tool that makes switching away from us a
deliberate decision rather than a frictionless one.

**Implication 3 — Single-channel Shopify operators are not our segment.**
Ledgerly wins Shopify-first SMBs. Our activation flow and pricing should not try to
compete here — we will lose on price and simplicity. Our sub-segment is multi-channel
operators ($3M+ GMV, 3+ channels, buying decisions requiring margin data).
Recommendation: **Refuse** — do not build Shopify-only activation flow or simplify
onboarding to compete for Ledgerly's segment. This is a known strategic choice, not a gap.
Document it explicitly so future product proposals aimed at "Shopify SMBs" are rejected
with rationale rather than relitigated.

**Implication 4 — Their ecosystem moat is Shopify-first; ours must be multi-channel.**
Ledgerly's integration depth is Shopify. Their ecosystem lock-in is strong for Shopify
operators and weak for everyone else. The diagnosis implication: our moat is multi-channel
breadth, and we must continue to deepen it or risk being outflanked by Ledgerly expanding
channel coverage with their new capital.
Recommendation: **Watch** — monitor Ledgerly's integration directory quarterly. If they
announce Amazon or Etsy integration at the Pro tier (currently Analytics-only), escalate
this to an active Build recommendation for integration depth.

---

**Marketing handoff note**

> **For the marketing-expert:** This teardown surfaces four positioning-relevant facts for
> the canvas and positioning statement. (1) Ledgerly claims "bookkeeping for e-commerce"
> and targets Shopify-first operators — we should ensure our positioning explicitly names
> multi-channel operators and margin visibility, making the sub-segment distinction legible.
> (2) Their "done with spreadsheets" promised land is the same as ours at the surface; our
> differentiation is the depth of analysis, not the elimination of manual work. (3) Annual
> contracts vs monthly is a buyer-decision framing issue — the canvas should address the
> switching-cost anxiety explicitly for multi-channel operators evaluating both. (4) The
> Analytics tier's dedicated-bookkeeper feature is a service-hybrid that our product doesn't
> offer — the positioning should be clear about the trade (software depth vs human judgment)
> rather than silent on it.
