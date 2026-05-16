---
name: acquisition-channel-advisor
description: Use when a team needs to decide which acquisition channel to invest in given the product's stage, market, and motion — paid / content / product-led / sales / community / partner — and wants a ranked recommendation with explicit tradeoffs rather than a generic list of options.
intent: |
  Guides a PM through choosing and sequencing acquisition channels by anchoring
  the decision in ICP fit, ACV, and sales motion — not instinct or imitation.
  Produces 3–5 ranked channel recommendations with explicit when-to-use
  rationale, CAC/LTV anchors, and a channel-concentration warning. Forces
  the team to name the growth loop before picking the channel.
type: interactive
theme: growth
best_for:
  - Deciding which one or two channels to invest in at a given product stage
  - Auditing a channel portfolio that has grown by accident rather than design
  - Choosing between content-led, product-led, outbound, and partner motions when all feel plausible
scenarios:
  - "Series A B2B SaaS deciding whether to hire a content lead or a BDR team first"
  - "PLG product wondering whether it still needs outbound for the enterprise tier"
  - "Consumer app that grew on paid trying to layer in a community or referral loop"
estimated_time: "30–45 minutes"
---

# Acquisition channel advisor

> v0 draft. Anchored in Weinberg & Mares (*Traction*, 2015) for the channel taxonomy; Balfour (Reforge 4-fits framework, growth loops) for channel-model fit; Ellis & Brown (*Hacking Growth*, 2017) for the 50% retention test and North Star framing. Editorial review recommended before production use.

## Purpose

Choose the right acquisition channel before scaling spend, not after.

The failure mode this skill is designed to prevent: a team picks a channel because a competitor is using it, or because someone on the exec team read a case study, and scales it before verifying that the channel fits the product's ICP, ACV, and sales motion. Weinberg and Mares documented 19 traction channels; having 19 options is only useful if you have a principled way to narrow to the two or three that could actually work for your specific situation.

This skill is not a unit-economics scorecard — that is `acquisition-channel-advisor`'s complement, the financial lens. This skill is upstream of the numbers: it answers *which channels are even worth measuring* before you run the CAC/LTV math.

Use this when the team is debating channel strategy, entering a new segment, or noticing that current channels are not producing the customer quality the business needs.

## Key Concepts

### The 19-channel taxonomy (Weinberg & Mares)

Weinberg and Mares (*Traction*, ch. 1–3) enumerate every known traction channel and make one central argument: most teams ignore the majority of channels by habit rather than evidence. The 19 channels collapse into five working families for B2B and B2C:

| Family | Channels included | When it leads |
|---|---|---|
| **Paid acquisition** | SEM, social ads, display, sponsorships | High ACV with validated conversion path; PLG products needing volume at the top of the funnel |
| **Content / SEO** | Blog, long-form, video, podcast, PR | Long sales cycles where buyers self-educate; category-creation plays; compounding economics over 12–24 months |
| **Product-led growth** | Viral loops, freemium, in-product referral, reverse trials | Low ACV or prosumer products; network-effects plays; self-serve sales motion where expansion > acquisition |
| **Outbound / sales-led** | Cold email, SDR/BDR, field sales, account-based | High ACV (>$15K ARR) with a defined ICP; short-list categories where buyers don't self-discover |
| **Community & partner** | User communities, integrations, resellers, co-marketing | Developer tools, platform products, or markets where trust transfers through peer networks |

No channel is universally best. The frame is not "which channel works" but "which channel fits."

### Channel-fit: the four-fits overlay (Balfour)

Brian Balfour's 4-fits framework (Reforge) argues that sustainable growth requires alignment across four dimensions simultaneously: Market-Product fit, Product-Channel fit, Channel-Model fit, and Model-Market fit. In practice, the two most commonly violated are:

- **Product-Channel fit** — does the product's core action and retention loop support this channel? A product with a 30-day activation window cannot be profitably driven by paid search unless the sales cycle is short enough to recover CAC before churn. A high-friction onboarding flow breaks viral loops before they form.
- **Channel-Model fit** — does the business model's ACV and margin support the channel's cost structure? Outbound sales with $2K ACV is structurally unprofitable at any scale. Content/SEO with a 3-day sales cycle leaves money on the table. The mismatch is the pitfall, not the channel.

Balfour's specific contribution: growth loops, not funnels. A funnel treats acquisition as a one-way pipe. A growth loop is a system where the output of one cycle feeds the input of the next — paid acquisition → trial → activation → expansion → referral → paid acquisition. The channel recommendation must fit the loop, not just the top-of-funnel step.

### The 50% retention test (Ellis & Brown)

Sean Ellis and Morgan Brown (*Hacking Growth*, ch. 2) define product-market fit operationally: if ≥50% of users would be "very disappointed" if your product disappeared, you have PMF. The same logic applies at channel level: if a channel is not consistently delivering customers who activate and retain at your baseline rate, the channel has channel-fit failure — not a CAC problem, not a copy problem, a fit problem.

The practical test: segment your retention cohorts by acquisition source. Channels that produce customers with below-baseline 90-day retention are disqualifying candidates for scale, regardless of their CAC. Ellis's language for this: find the channel that delivers the "must-have" customers, not just any customers.

### CAC/LTV channel anchoring

Channels are not free to mix and match; each has a structural CAC floor given the market and ACV:

- **Paid**: CAC is approximately 10–30% of ACV for efficient paid channels in competitive B2B markets. Below $5K ACV, paid acquisition rarely closes at sustainable LTV:CAC > 3:1.
- **Content/SEO**: Blended CAC of $100–$500 is achievable at scale, but requires 12–24 months of compounding before the cost structure normalises. Payback is long; LTV:CAC at maturity is exceptional.
- **PLG**: Near-zero marginal CAC on the free/trial tier, but conversion rates to paid are typically 2–8%. The channel pays if expansion revenue is high; it fails if customers plateau in the free tier.
- **Outbound**: CAC is proportional to rep cost and sales cycle length. Structurally works above $15–20K ACV; structurally loses money below $8K ACV in most markets.
- **Community/partner**: CAC is hard to measure precisely; deal quality and conversion rates are often the best signal. Partner channels tend to produce lower volume but higher ICP fit and faster sales cycles.

### Channel concentration risk

Weinberg and Mares observe that most successful traction at early stage comes from *one* dominant channel — and that the goal at seed/Series A is to find that channel, not to diversify. But Balfour adds the counter-pressure: a portfolio with >60% of acquisition from a single channel is fragile. Algorithm changes (SEO, paid), competitor bidding wars (SEM), or platform policy shifts (app stores) can collapse a channel-dependent business in a quarter. The recommendation in this skill always notes concentration risk when one channel is commanding > half the acquisition budget.

## Application

This interactive skill runs a four-question flow — ICP, ACV/motion, current channel data, and loop type — then produces 3–5 ranked channel recommendations with rationale. Offer enumerated options at each question; accept single selection, multi-selection, or free text.

---

### Step 0: Framing check

Before questioning begins, ask:

> "Quick context check before we run the channel analysis. Are you:
>
> 1. Choosing channels from scratch — pre-revenue or <$1M ARR, first deliberate channel decision
> 2. Optimising an existing mix — you have channels running but they're not producing at the rate you need
> 3. Entering a new segment — existing channels work for current customers, but not for this new ICP
> 4. Evaluating a specific channel — you have one candidate in mind and want to test whether it fits
>
> Pick the number that fits, or describe your situation."

Adapt subsequent question depth based on the mode. Mode 1 runs all four questions. Modes 2–4 can skip questions where context is already supplied.

---

### Step 1: ICP — who are you acquiring?

> "Who is the target customer for the channel decision?
>
> 1. **Individual / prosumer** — a person buying for personal use or small-team use, low friction purchase, likely self-serve
> 2. **SMB, founder-led purchase** — <50 employees, the buyer is often the user, deal value typically $1K–$15K ARR
> 3. **Mid-market** — 50–500 employees, multi-stakeholder purchase, procurement involved above $10K
> 4. **Enterprise** — 500+ employees, champion-plus-economic-buyer dynamic, long sales cycles, high ACV
> 5. **Developer / technical buyer** — an individual with high autonomy and high distrust of marketing; community and product-led signals dominate
>
> If your ICP spans more than one, pick the one that represents your next 50 deals."

Record the ICP tier. It is the first filter applied to channel ranking.

---

### Step 2: ACV and sales motion

> "What's the typical ACV (annual contract value) for the customer type you named, and how does buying actually happen?
>
> 1. **<$2K ACV, fully self-serve** — no sales touch, credit card at signup, volume model
> 2. **$2K–$10K ACV, low-touch sales** — trial or demo, inside sales closes, <2 week cycle
> 3. **$10K–$50K ACV, product-led → sales assist** — self-serve trial, sales-assist to close, 4–8 week cycle
> 4. **$50K+ ACV, sales-led** — demo-first, multi-stakeholder, procurement, 3–6 month cycle
> 5. **Variable / usage-based** — ACV grows post-contract; land-and-expand is the core motion
>
> Pick the one that best describes your current deal structure — or tell me the actual ACV if you have it."

Record the ACV/motion tier. Together with ICP, this produces the primary channel filter.

---

### Step 3: Current channel data

> "What does your current acquisition picture look like?
>
> 1. **No channels yet** — no deliberate acquisition spend; customers came through personal networks or inbound luck
> 2. **One dominant channel, others untested** — you know what's working but haven't validated alternatives
> 3. **Multiple channels running, no clear winner** — spread thin, no channel is clearly better than blended
> 4. **Channel data available** — I can share channel-level CAC, volume, and retention; I want a data-grounded recommendation
> 5. **Channel plateau** — a previously strong channel is showing diminishing returns or rising CAC
>
> If you have channel-level retention data, share it now and I'll use it to apply the 50% retention test."

If the user provides channel data (Option 4), request: channel name, monthly spend, monthly new customers from that channel, and 90-day retention rate for customers from that channel vs. blended baseline.

---

### Step 4: Growth loop type

> "Last question. What's the primary growth mechanism you're designing around?
>
> 1. **Paid loop** — you spend to acquire, customers monetise, you reinvest margin into more spend
> 2. **Content / SEO loop** — you produce content that drives organic traffic, which converts to trials or demos
> 3. **Viral / product loop** — the product itself creates sharing, invitations, or network effects that grow the user base
> 4. **Sales loop** — outbound prospecting and relationship-building drive pipeline; closed deals fund more reps
> 5. **Community / ecosystem loop** — users generate content, integrations, or referrals that attract more users without direct spend
> 6. **Unclear / open** — I haven't committed to a loop; that's partly what I'm trying to figure out
>
> If you answered Option 6, I'll recommend a loop before recommending a channel — channel without loop is tactics without system."

---

### Step 5: Synthesise and deliver ranked recommendations

Using the four inputs (ICP, ACV/motion, channel data, loop type), produce 3–5 ranked channel recommendations in this format for each:

```
## [Rank]. [Channel name]

**Why it fits:** One sentence connecting the channel to the ICP, ACV, and loop inputs.

**When to move:** The signal that tells you this channel is ready to scale — a metric threshold, a conversion rate, a cohort retention benchmark.

**Structural tradeoff:** What this channel costs you in time, capital, or capability that an alternative would not.

**Concentration risk note:** Flag if recommending this channel would push > 60% of acquisition budget into one channel. Name the hedge.

**CAC/LTV check:** Rough CAC structure for this channel at this ACV tier. Flag if the unit economics are structurally unlikely to close.
```

End with a one-paragraph synthesis naming the recommended **primary channel** (the one to build the loop around), an optional **secondary channel** to layer in once the primary is validated, and what to ignore for now with a one-line reason.

## Examples

### Worked example: Series A B2B SaaS, $18K ACV, deciding between content-led and outbound

**Context:** Developer-tooling product, $18K ACV, 60-day sales cycle, ICP is engineering managers at 50–300 person companies. Currently: 80% of revenue came through founder network and inbound, no deliberate channel investment. Team is hiring a first GTM person and debating content lead vs. BDR.

**Step 1 output:** ICP = developer/technical buyer (Option 5), with mid-market buying behaviour (Option 3). Dual classification: technical buyer inside a mid-market org.

**Step 2 output:** $10K–$50K ACV, product-led → sales assist (Option 3). Trials exist; sales is closing them.

**Step 3 output:** No clear channel data (Option 1/2). Inbound is working but unmeasured.

**Step 4 output:** Content/SEO loop (Option 2) — the team's instinct is that technical buyers don't respond to cold outreach and do respond to quality engineering content.

---

**Recommendations delivered:**

**1. Content / SEO (primary)**

Why it fits: Technical buyers self-educate; engineering managers search for solutions before they admit budget. Content that solves real engineering problems (not marketing copy) builds the trust required to convert a 60-day cycle. At $18K ACV with a 60-day cycle, CAC from content compounds: early articles are expensive per customer; at 18 months the blended CAC typically falls to $300–$800 per closed deal.

When to move: Invest in content at scale when you have three articles that each generate ≥50 qualified trial signups per month. Before that, produce content to learn what terms and problems your ICP searches for — not to scale.

Structural tradeoff: Content takes 12–18 months to compound. If the business needs ≥10 new logos in the next quarter, content will not produce them in that window. Content is a 2026 channel being seeded in 2025.

Concentration risk: None at this stage — content is underdeveloped. Flag when organic accounts for >60% of new trials.

CAC/LTV check: At $18K ACV and 3-year average contract, LTV ≈ $54K. Content CAC of $500–$1,500 at maturity gives LTV:CAC of 36:1–108:1. Strong structural fit.

---

**2. Product-led trial with sales assist (secondary, layer in now)**

Why it fits: The product already has trials; closing them systematically with sales assist is a near-term revenue play that does not require a new channel investment. The growth loop is already running — it is just uncaptured.

When to move: Instrument trial-to-paid conversion immediately. If <15% of trials convert without a sales touch, add a single rep doing outbound to active trials. If >25% convert self-serve, reduce sales-assist spend and invest in onboarding instead.

Structural tradeoff: Sales-assist adds headcount cost before the content loop is mature. Cap it at one rep until CAC is confirmed.

---

**3. Community / developer ecosystem (optional, 12-month horizon)**

Why it fits: Developer tooling has historically compounded through community word-of-mouth — GitHub stars, Hacker News, internal Slack referrals. This is a low-cost, long-lead channel that fits the technical buyer profile and does not compete with content SEO.

When to move: Once you have ≥50 active power users, invest in community infrastructure (Discord, Slack group, office hours). Do not invest before you have power users — community without density is a ghost town.

---

**Ignore for now — outbound BDR:** At $18K ACV with a 60-day cycle and technical buyers who distrust cold outreach, BDR-sourced pipeline will have poor conversion rates and high CAC until the brand has enough recognition to open doors. The opportunity cost: a BDR hire costs $80–120K fully loaded per year and will produce 15–25 qualified opportunities in year one at typical tech company conversion rates — a channel CAC of $4K–$8K per opportunity before close rate is applied. Content compounds; BDR costs are linear. Revisit BDR at $3M ARR when brand awareness supports the cold open.

---

**Synthesis:** Build the content/SEO loop as the primary channel — it fits the technical buyer ICP, the $18K ACV unit economics, and the sales cycle length. Capture the trial population already in the funnel with a disciplined sales-assist motion. Seed community as a 12-month hedge. Hold the BDR hire until content is producing qualified pipeline that justifies a sales-led layer.

## Common Pitfalls

### Pitfall 1 — Copying the competitor's channel

**Symptom.** "Company X is doing outbound. We should too." No analysis of why it fits Company X's ICP, ACV, or motion.

**Consequence.** Channel imitation without channel fit produces high CAC and low ICP-match customers. Balfour's 4-fits framework is violated: the competitor may have a different Product-Channel fit that makes outbound viable for them at a unit economics that don't apply to your product.

**Fix.** Before copying a channel, articulate specifically which component of their 4-fits alignment makes it work for them and whether that component applies to you. Usually it does not.

---

### Pitfall 2 — Launching channels before PMF on existing customers

**Symptom.** Scaling a second channel while the first is producing customers who churn at above-baseline rates.

**Consequence.** Weinberg and Mares: traction and product development must run in parallel, but channel scale before the Ellis 50% retention threshold is met produces a leaky bucket. More acquisition spend fills the bucket faster while the churn hole grows.

**Fix.** Run the 50% retention test on your current acquisition cohorts before investing in a new channel. If retention is below baseline, the problem is product-channel fit or ICP selection — not channel volume.

---

### Pitfall 3 — Optimising for CAC without checking ICP fit

**Symptom.** Shifting budget to whichever channel has the lowest CAC this quarter, regardless of the customer profile it delivers.

**Consequence.** Low-CAC channels frequently reach audiences outside the ICP. These customers churn faster, expand less, and generate more support load. The channel looks efficient until 90-day retention data arrives.

**Fix.** Track 90-day retention by acquisition source. Ellis's test: do customers from this channel treat the product as must-have? If not, the low CAC is a false economy — it is producing customers the product cannot retain.

---

### Pitfall 4 — Treating channels as independent instead of as a loop

**Symptom.** Running paid, content, and community as separate budget lines with separate owners, no shared attribution logic, no model of how they reinforce each other.

**Consequence.** Balfour's loop framing: channels that are not designed to feed each other produce diminishing returns faster than channels that are. Paid drives trial; trial activates users; activated users generate word-of-mouth that improves paid conversion. Optimising each channel independently misses the compound loop.

**Fix.** Before allocating channel budget, draw the growth loop explicitly. Identify which channel is the input step, which is the amplification step, and which is the referral/viral step. Budget against the loop, not against individual channels.

---

### Pitfall 5 — Scaling before the "when to move" signal

**Symptom.** Doubling a channel budget because the first month showed positive results, before retention data or conversion rates have validated the channel at scale.

**Consequence.** Early positive signals in a channel are often noise — the best early customers, the founder's network, the product-market-fit cohort who would have converted through any channel. Scaling on a thin signal burns budget at an unrepresentative CAC.

**Fix.** Name the "when to move" condition before you invest (Step 5 of the Application flow). The condition should be a metric, not a calendar date. A channel is ready to scale when it has delivered ≥50 customers with above-baseline 90-day retention, not when it has been running for 30 days.

---

### Pitfall 6 — Single-channel concentration without a hedge

**Symptom.** One channel grows to >60% of acquisition budget and no secondary channel is in development.

**Consequence.** Weinberg and Mares note that most products find one dominant channel early — and that this is correct strategy for early stage. The failure mode arrives at Series B and later: SEO algorithm changes, paid auction inflation, platform policy shifts, or a well-funded competitor can collapse a single-channel business in one quarter.

**Fix.** Once the primary channel is validated and scaling, immediately seed the secondary channel at low budget (5–10% of total). The goal is not diversification for its own sake — it is optionality. A secondary channel with 12 months of data is a real hedge; a secondary channel started the month the primary channel collapses is not.

## References

- **Gabriel Weinberg & Justin Mares** — *Traction: How Any Startup Can Achieve Explosive Customer Growth* (2015, Portfolio/Penguin). The 19-channel taxonomy is the foundational source for the channel families in Key Concepts. Weinberg and Mares' central argument — that most teams ignore most channels by habit — is the frame for Step 0 of the Application flow. The 50% domination test (one channel typically drives the majority of early traction) underpins the primary/secondary/ignore structure of the recommendations.
- **Brian Balfour** — Reforge growth essays: "The Four Fits Framework" and "Why Products Get Stuck at Scale" (2017–2018, reforge.com). Balfour's 4-fits model (Market-Product, Product-Channel, Channel-Model, Model-Market) is the structural check in Step 2 (ACV/motion). The growth loops framing — loops, not funnels — drives Step 4 and the Synthesis paragraph in the worked example. Balfour's specific test for Channel-Model fit at different ACV tiers is the basis for the CAC/LTV anchor table in Key Concepts.
- **Sean Ellis & Morgan Brown** — *Hacking Growth: How Today's Fastest-Growing Companies Drive Breakaway Success* (2017, Crown Business). The 50% "very disappointed" test is re-applied at channel level in Key Concepts and in Pitfall 2. Ellis's North Star framing — find the channel that delivers must-have customers, not any customers — is the governing principle behind the retention check in Step 3.
- **Related Hornero skills:**
  - [`success-metrics`](../success-metrics/SKILL.md) — the North Star metric and retention cohort design needed to run the 50% retention test at channel level.
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — when the channel decision is one item in a larger resource allocation contest, run prioritization-advisor to scope what capacity exists for channel investment.
  - [`revenue-architecture`](../revenue-architecture/SKILL.md) — ACV, expansion motion, and LTV model inputs for the CAC/LTV channel anchors in Key Concepts.
  - [`positioning-statement`](../positioning-statement/SKILL.md) — positioning determines which channel messages can land; a channel recommendation that requires a messaging capability the product does not have is not yet actionable.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/acquisition-channel-advisor) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
