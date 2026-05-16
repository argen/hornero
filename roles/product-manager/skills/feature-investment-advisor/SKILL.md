---
name: feature-investment-advisor
description: Use when a PM needs to evaluate a feature-investment decision through a finance lens — fully-loaded cost, opportunity cost, expected value, payback — not vibes or ICE-without-finance.
intent: |
  Guides a PM through a finance-first feature decision: scoping the
  fully-loaded cost (build + run + maintain), naming the counterfactual
  (what gets displaced), estimating expected value with explicit
  probability discipline, and computing payback against a real customer
  lifetime. The output is a build / defer / kill recommendation with
  the math exposed — not a spreadsheet dressing up a gut call.
type: interactive
theme: finance
best_for:
  - Evaluating any feature that costs more than one engineer-week
  - Pressure-testing a roadmap request before it consumes sprint capacity
  - Choosing between direct monetization and an indirect retention play
scenarios:
  - "Should we build SSO for mid-market customers this quarter?"
  - "Is an AI writing assistant worth the GPU cost and maintenance load?"
  - "We have capacity for one big feature — help me make the investment case"
estimated_time: "30–60 minutes"
---

# Feature investment advisor

> v0 draft. Finance framing anchored in Doshi (LNO), Gilad (*Evidence-Guided*), Cagan (*Inspired*, *Empowered*), Feld (capital-allocation discipline), and Cagan/Perri anti-roadmap framing. Editorial review recommended before production use.

## Purpose

Make the financial case for a feature decision explicit — before the sprint commitment, not after.

Most roadmap calls are dressed in finance language without the discipline finance requires. "High ROI" means nothing without a probability-weighted estimate, a fully-loaded cost, and a counterfactual. This skill replaces those phrases with numbers you can defend and assumptions you can invalidate.

It is not a replacement for discovery. If you haven't validated the problem, do that first — this skill evaluates a known opportunity, not an untested hypothesis. It also does not replace strategy alignment: use `strategy-kernel` or `bet-portfolio` if the question is which game to play, not how much this play costs.

Doshi's LNO overlay applies before you begin: if the feature is Overhead (compliance, parity, one-week fix), skip the math and just build it. The finance lens earns its cost on Leverage decisions — the ones that are hard to reverse and where the wrong call compounds.

## Key Concepts

### Fully-loaded engineering cost

The build estimate is the floor, not the cost. Fully-loaded cost includes:

- **One-time build cost** — engineering time × blended daily rate. (Rule of thumb: for US-based teams, $1–1.5K per engineer-day fully-loaded with benefits, tooling, overhead.)
- **Ongoing maintenance** — features don't ship and disappear. Budget 15–20% of build cost per year for bug fixes, compatibility work, and minor iteration.
- **COGS impact** — any feature that adds per-customer compute, API calls, or storage has an ongoing gross-margin effect. Model it monthly.
- **Support and CS load** — new surface area means new support tickets. If your CS cost is measurable, estimate the ticket volume.

Omitting maintenance and COGS is the most common way a feature looks better than it is.

### Opportunity cost and the counterfactual

The question is never "is this feature worth building?" It is "is this feature worth building *instead of the next-best alternative*?" A feature with a 2:1 ROI is a bad investment if the displaced alternative has a 10:1 ROI.

Naming the counterfactual is not optional. It should be a specific alternative — the second item on the roadmap, not "something else." When the counterfactual is named, the opportunity cost is calculable. When it is unnamed, you are optimizing locally.

### Expected-value framing

Revenue and retention estimates are distributions, not point values. An adoption estimate of "30%" without a probability range is not an estimate — it is a wish. Expected value requires:

- A base-case estimate with a stated confidence level
- A downside case (what does the outcome look like if assumptions are half-right?)
- A probability weight on each case

Gilad's Confidence Meter applies here directly: score your confidence in the key assumptions (adoption, churn reduction, conversion lift) on a 1–10 scale with evidence cited. A 10 is backed by A/B test data. A 3 is backed by five customer interviews. A 1 is backed by a stakeholder's conviction. The weighted EV changes significantly between a confidence-7 and a confidence-3 estimate.

Be honest: expected-value math is a discipline prompt, not a calculator. It forces you to surface the uncertainty you are already living with, rather than hiding it behind a single number.

### Payback period

Payback period = one-time investment / monthly return (contribution margin basis, not revenue).

Two failure modes:
1. Payback exceeds average customer lifetime. You never recover the investment because customers churn first.
2. Payback is calculated on revenue, not on margin. A feature generating $20K/month at 20% gross margin returns $4K/month — a $200K build takes 50 months to pay back, not 10.

The payback check is a kill signal, not just a metric. If payback exceeds 24 months for a B2B SaaS product with a 30-month average LTV, the financial case is marginal at best.

### Operating-cost ROI versus feature-investment ROI

These are not the same calculation. Operating-cost ROI is evaluated over the useful life of an asset on a net-present-value basis (Feld). Feature-investment ROI is evaluated as a discrete bet: what does the incremental return look like relative to the incremental investment, over the horizon the PM can credibly forecast?

For feature investment, use a 12–24 month horizon. Anything beyond that is speculation for most B2B products. Discount long-horizon returns if payback extends past 18 months — $1 in month 30 is not worth $1 today.

### Doshi's LNO overlay

Before scoring: is this feature a Leverage, Neutral, or Overhead task?

- **Leverage** — if done well, disproportionate business impact. Run the full investment analysis.
- **Neutral** — worthwhile but doesn't compound. Quick sanity check suffices; skip the full EV model.
- **Overhead** — compliance, parity, one-week polish. Build it, don't score it.

The investment framework is calibrated for Leverage decisions. Applying it to Overhead creates analysis theatre.

## Application

Five-question interactive flow. Ask one question per turn. Offer numbered options at decision points.

---

### Step 0 — LNO pre-check

Before proceeding, classify the feature:

"Quick pre-check: is this feature Leverage (disproportionate business impact if done well), Neutral (worthwhile but not compounding), or Overhead (compliance, parity, one-week fix)?

1. Leverage — full investment analysis warranted
2. Neutral — abbreviated check
3. Overhead — skip the model; note the build cost and proceed

Choose a number."

If 3 (Overhead): acknowledge, provide a one-line cost note, and close. If 1 or 2: continue.

---

### Step 1 — Scope the feature and the cost

Gather:

"Describe the feature in 1–2 sentences and provide the cost inputs:

- Target segment (SMB / mid-market / enterprise / all)
- Engineering estimate: team size × weeks
- Estimated blended daily rate (or use default: $1,200/eng-day)
- Ongoing COGS or infrastructure cost, if any: $\_\_\_/month
- Maintenance estimate: (leave blank to use default 15% of build/year)

Estimates are fine — we'll flag where uncertainty matters."

Agent computes: fully-loaded build cost, annualized maintenance, monthly COGS, and a total 12-month and 24-month cost model.

---

### Step 2 — Revenue connection and value estimate

"How does this feature affect revenue? Choose the primary mechanism:

1. **Direct monetization** — new pricing tier, paid add-on, or usage charge
2. **Retention improvement** — addresses a known churn driver; keeps customers longer
3. **Conversion improvement** — moves trial or freemium users to paid
4. **Expansion enabler** — unlocks upsell, cross-sell, or usage-based growth
5. **No direct revenue path** — strategic, compliance, or platform enabler only

Choose a number."

Based on selection, ask the estimation questions:

- **If 1:** Proposed price point; expected adoption % (state your confidence, 1–10); customer base.
- **If 2:** % of churn attributable to this gap (cite the evidence: exit interviews, support tickets, NPS comments); expected churn reduction; current MRR and ARPA; average LTV.
- **If 3:** Current conversion rate; expected lift; trial volume; ARPA.
- **If 4:** Expansion opportunity type; % of base expected to expand; ARPA delta.
- **If 5:** Skip to Step 4 (strategic value).

Agent computes the EV: base-case monthly return × confidence score, plus a downside case at 50% of assumptions.

Flag if confidence score is ≤ 4: "Low-confidence estimate. The EV assumes [key assumption]. What evidence do you have for it?"

---

### Step 3 — Name the counterfactual

"What feature or initiative does this displace? Name the next-best alternative that would occupy this engineering capacity if this feature doesn't get built."

If the user can name it with an estimated return: compute opportunity cost directly.

If the user cannot name it: flag that opportunity cost is unquantified — the investment case is incomplete without it. Offer to proceed with a placeholder and revisit.

This step is deliberately uncomfortable. A feature investment case without a named alternative is a local-optimization argument, not a portfolio argument.

---

### Step 4 — Payback and decision threshold

Agent computes payback: one-time investment / monthly contribution margin return.

"Payback period: **\_\_\_ months** (on a margin basis, not revenue basis).

Threshold check:
- Is payback shorter than your average customer lifetime? [yes/no — agent infers from inputs or asks]
- Is the counterfactual's expected ROI higher or lower than this feature's?

Based on these, here are the recommendations:

1. **Build now** — payback is within lifetime, ROI exceeds counterfactual
2. **Build with scope reduction** — payback is marginal; identify which scope slice gets to break-even faster
3. **Defer pending validation** — key assumption has confidence ≤ 4; validate before committing build capacity
4. **Redirect to counterfactual** — counterfactual has materially higher ROI; this feature can wait
5. **Kill** — payback exceeds lifetime or margin case doesn't close; strategic override would need to be explicit

Choose a number or describe your read."

---

### Step 5 — Follow-up options

"Want to:

1. See the full 12-month and 24-month P&L model
2. Run a sensitivity analysis (what if adoption is 2×? 0.5×?)
3. Compare this feature against a second alternative side-by-side
4. Identify the minimum viable scope that changes the payback threshold

Choose a number or ask a follow-up question."

---

## Examples

### Example 1 — Strong case: SSO for mid-market

**Context.** B2B SaaS, 600 customers, $3,800 ARPA, 4% monthly churn, 80% gross margin. Exit interview data: 22% of churned mid-market accounts named SSO absence as a contributing factor. One enterprise deal ($120K ARR) is blocked on SSO requirement. Build estimate: 2 engineers × 8 weeks.

**Fully-loaded cost.**
- Build: 2 engineers × 40 days × $1,200 = $96,000
- Maintenance (15%/year): $14,400/year = $1,200/month
- COGS: negligible (identity provider handles the compute)
- Total 12-month cost: $96,000 + $14,400 = $110,400

**Revenue connection: retention + enterprise unlock.**

Retention side:
- Monthly churn: 4% × 600 = 24 customers/month lost
- SSO-attributable: 22% of churn = ~5 customers/month
- Churn reduction target: stop 50% of SSO-driven churn = 2.5 customers/month retained
- MRR saved: 2.5 × $3,800 = $9,500/month
- Confidence: 7/10 (exit interview data, n=14)
- EV (base): $9,500/month; downside (50%): $4,750/month

Enterprise deal side:
- One known blocked deal: $120K ARR = $10,000/month
- Confidence: 9/10 (deal is in pipeline with explicit SSO requirement)
- EV: $10,000/month

**Combined monthly return:** $19,500/month (base) on a margin basis: $19,500 × 80% = $15,600/month contribution margin.

**Payback.** $96,000 / $15,600 = **6.2 months.** Average LTV at 4% monthly churn ≈ 25 months. Payback is well within lifetime.

**Opportunity cost.** Next alternative is a bulk-import feature estimated at $40K build with $6,000/month return — payback 6.7 months, lower total magnitude. SSO wins on both payback speed and total return.

**Recommendation: Build now.** The financial case is strong. Fast payback, high-confidence evidence, and the counterfactual is inferior. Risk: if the enterprise deal falls through, the case weakens to retention-only — still an 8-month payback. Flag: validate the churn-reduction assumption with 2 more exit interviews before committing.

---

### Example 2 — ICE-disguised-as-finance (counter-example)

**What it looks like.** A PM presents a feature proposal: "This will generate 10× ROI. We surveyed 50 users and they all said they'd use it. It scored highest on our prioritization matrix."

**What's missing.**

- No fully-loaded cost. The "development estimate" is engineering time only; no maintenance, no COGS, no support load.
- No probability discipline. "All 50 users said they'd use it" is a stated-preference survey — stated preference overstates real adoption by 3–5× on average (Gilad's Confidence Meter would score this a 4, not a 9).
- No counterfactual. The feature "scored highest on the matrix" — but compared to what, on which dimension, with what capacity constraint?
- No payback check. "10× ROI" is computed on revenue, not margin, over an unspecified horizon.

**What the math actually looks like.** If adoption is 3× overstated (confidence 4), fully-loaded cost is 1.4× the build estimate, and the return is calculated on margin rather than revenue, the "10× ROI" resolves to approximately 2.4:1 — and payback is 22 months against an 18-month average LTV.

**The lesson.** ICE frameworks are not finance. They rank options on relative intuition. Finance requires absolute numbers with probability discipline, a fully-loaded cost, and a named counterfactual. ICE tells you which item feels most valuable; expected-value framing tells you whether it's worth building at all.

---

## Common Pitfalls

### Pitfall 1 — Fully-loaded cost ignoring downstream maintenance

**Symptom.** The investment case uses the build estimate as the total cost. No maintenance budget, no COGS, no support impact.

**Consequence.** The feature looks profitable at launch and margin-dilutive 18 months later. By then the team is committed to supporting it.

**Fix.** Default to 15% of build cost per year for maintenance, plus any measurable COGS. If either number is uncertain, model both a zero-maintenance case and a 20% case — the spread reveals how sensitive the payback is.

---

### Pitfall 2 — Expected value with no probability discipline

**Symptom.** The revenue estimate is a single point: "We'll get 25% adoption." No confidence score, no downside case, no evidence citation.

**Consequence.** The model looks rigorous but is a single optimistic assumption dressed in arithmetic. When adoption lands at 10%, the payback case collapses and nobody can explain why.

**Fix.** Apply Gilad's Confidence Meter to the key driver. State the evidence behind the confidence score. Run the model at 50% of the base case. If the payback still works, the case is robust. If it doesn't, that's the real story.

---

### Pitfall 3 — No counterfactual named

**Symptom.** The investment case argues for a feature in isolation: "This has a 4:1 ROI, so we should build it."

**Consequence.** A 4:1 ROI is a bad investment if the next alternative is 12:1. Without the counterfactual, the PM is optimizing locally and not allocating capital (engineering capacity) at the portfolio level.

**Fix.** Name the second-best alternative and its estimated return before finalizing the recommendation. If you genuinely don't know, say so — and flag that the case is incomplete. The discomfort of naming the alternative is the point.

---

### Pitfall 4 — Payback calculated on revenue, not contribution margin

**Symptom.** "We'll generate $20K/month in new revenue. Build cost is $200K. That's a 10-month payback."

**Consequence.** At 50% gross margin, the monthly contribution is $10K — payback is 20 months. At a 3% monthly churn rate, average LTV is ~33 months. The case is borderline, not strong.

**Fix.** Always calculate payback on contribution margin (revenue × gross margin %). Revenue-basis payback overstates the case by a factor of 1 / gross margin.

---

### Pitfall 5 — Treating "strategic" as a finance bypass

**Symptom.** A feature with a poor financial case is approved because it's "strategic." The strategy is not defined. The tradeoff is not named.

**Consequence.** "Strategic" becomes a label that shuts down financial scrutiny. Over time, the roadmap fills with strategic features that don't move metrics.

**Fix.** Strategic override is legitimate — but it must name what it is overriding. State the financial case explicitly (e.g., "payback is 28 months, which is borderline"), then name the specific strategic rationale (e.g., "required for enterprise segment entry; blocks $2M pipeline"). If the strategic rationale can't be stated concretely, it is not a strategy — it is a preference.

---

### Pitfall 6 — Operating-cost ROI conflated with feature-investment ROI

**Symptom.** The PM calculates ROI over 5 years to make a 30-month payback look acceptable.

**Consequence.** A 5-year model for a B2B SaaS feature is speculation. Customer bases churn, markets shift, the product pivots. Discounting at any reasonable rate (8–12%) makes year 4 and 5 returns worth 60–70 cents on the dollar at best.

**Fix.** Limit the forecast horizon to 12–24 months for feature investments. If payback requires a longer horizon to close, the feature is Defer or Kill unless the strategic case is explicit. Feld's capital-allocation discipline applies: shorter payback cycles preserve optionality.

---

## References

- **Shreyas Doshi** — LNO framework (Leverage / Neutral / Overhead); the pre-sort discipline applied in Step 0. "The Real Reason Your Product Roadmap is Wrong" for the roadmap-as-commitment anti-pattern that makes individual investment cases load-bearing.
- **Itamar Gilad** — *Evidence-Guided* (2024); ICE-with-confidence; the Confidence Meter. The probability-discipline requirement in Step 2 and Pitfall 2 trace directly to Gilad's evidence-weighting methodology.
- **Marty Cagan** — *Inspired* (2017); *Empowered* (2020). The anti-roadmap framing: a roadmap of features is not a strategy; each feature deserves an investment case. The four-risks lens (value, usability, feasibility, business viability) as a pre-condition for any investment claim.
- **Brad Feld** — capital-allocation discipline applied to engineering capacity as the scarce resource; shorter payback cycles preserve optionality; operating-cost ROI versus discrete-investment ROI distinction. Referenced in Key Concepts and Pitfall 6.
- **John Cutler** — "Beautiful North Star" and related writing on systems-level product thinking; the insight that local-optimization features look good in isolation and destroy portfolio coherence — the counterfactual discipline in Step 3 is a direct application.
- **Related Hornero skills:**
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — run before this skill when the question is which features to evaluate; this skill deepens the financial analysis on candidates already ranked Do-Now.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — the portfolio frame for multiple concurrent investments; this skill handles single-feature depth, bet-portfolio handles the allocation across features.
  - [`success-metrics`](../success-metrics/SKILL.md) — the return estimates in Step 2 should be grounded in the metrics stack defined here; an impact claim without a named metric is unscoreable.
  - [`finance-metrics-quickref`](../finance-metrics-quickref/SKILL.md) — quick lookup for contribution margin, LTV, payback, and COGS formulas referenced throughout this skill.
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — if the feature decision keeps producing "it depends on the strategy," pause and write the kernel first; investment cases are legible only inside a guiding policy.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/feature-investment-advisor) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
