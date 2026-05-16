---
name: tam-sam-som-calculator
description: Use when a PM needs to size a market — Total Addressable / Serviceable Available / Serviceable Obtainable — defensibly enough to defend a strategy, fund a bet, or shape a board claim, with top-down + bottom-up triangulation.
intent: |
  Produces a defensible TAM/SAM/SOM estimate anchored in explicit assumptions,
  dual methods (top-down and bottom-up), and honest triangulation. Forces the
  PM to distinguish between the market that theoretically exists and the market
  the company can actually reach and win — two different questions that most
  sizing exercises collapse into one. The output is a claim you can defend under
  investor or CFO scrutiny, not a number dressed in false precision.
type: component
theme: finance
best_for:
  - Sizing a market before committing to a strategy or funding request
  - Building the market-sizing slide for a board deck or Series A pitch
  - Stress-testing a roadmap bet by quantifying the revenue ceiling it implies
scenarios:
  - "PM preparing a go/no-go recommendation for entering a new vertical and needs a number the CFO won't dismiss"
  - "Founder building the TAM/SAM/SOM slide for a Series A deck and wants triangulated estimates, not a single analyst-report citation"
  - "Head of product evaluating two roadmap bets and needing to compare the SOM ceiling of each against team capacity"
estimated_time: "2–4 hours for a first defensible pass; 30–60 minutes for subsequent iterations once assumptions are locked"
---

# TAM / SAM / SOM calculator

> v0 draft. Anchored in Gurley (sizing skepticism), a16z (TAM framework), Tunguz (unit-economics discipline), Moore (*Crossing the Chasm*, SOM realism), and Christensen (JTBD as sizing input). Editorial review recommended before production use.

## Purpose

Produce a three-tier market estimate — Total Addressable Market (TAM), Serviceable Available Market (SAM), Serviceable Obtainable Market (SOM) — that can survive scrutiny from someone who wants to disprove it.

The skill exists because most market sizing is wish-fulfilment arithmetic. A team picks a large analyst report number, writes it on a slide, calls it the TAM, then claims 1% of it is the SOM. Bill Gurley has called this out directly: analysts and founders consistently anchor on total potential spend rather than on what customers will actually shift. The 1% of a huge number is not a market estimate; it is a hedge disguised as confidence.

This skill does something different. It forces two independent sizing paths — top-down and bottom-up — and requires the estimates to triangulate. When they don't, that gap is itself the signal: either the top-down data is wrong, the bottom-up assumptions are wrong, or the market definition is inconsistent across the two. Finding and resolving that gap is the work.

The output is not a single number. It is a number with stated assumptions, a stated method, and an honest account of what would need to be true for the estimate to hold.

## Key Concepts

### The three tiers

**Total Addressable Market (TAM)** is the revenue available if a product captured every customer who has the problem the product solves, across every geography and segment, with no competitive constraint. It is a theoretical ceiling, not a forecast. Its practical job is to establish that the category is large enough to warrant investment. A TAM too small disqualifies the bet; a TAM correctly sized scopes the ambition.

**Serviceable Available Market (SAM)** is the subset of the TAM that the company's go-to-market, product, and operational footprint can actually reach. Geography, language, regulatory regime, distribution channel, and product-fit constraints all narrow TAM to SAM. SAM is the market you could win if you were the only player — still not a forecast, but now a realistic ceiling.

**Serviceable Obtainable Market (SOM)** is the share of the SAM the company can realistically capture over a defined horizon (typically 1–3 years) given competition, GTM capacity, and adoption rate. SOM is the closest of the three to a revenue plan. Geoffrey Moore (*Crossing the Chasm*) frames SOM through target customer precision: you win SOM by owning a beachhead segment completely, not by spreading thin across SAM.

The three are not percentages of each other by convention. SAM is constrained by real operational limits; SOM is constrained by competitive density and GTM bandwidth. Arriving at SOM by applying a blanket "5% of SAM" multiplier — without grounding that percentage in GTM capacity and competitive share data — is the single most common flaw investors catch and dismiss.

### Top-down vs. bottom-up methods

**Top-down sizing** starts from existing market data — analyst reports, industry statistics, census counts — and narrows by segment. It answers "how big is the category?" It is fast and externally legible (investors recognise the sources), but it depends on how well existing research carves the category. When no good category report exists, top-down sizing forces an apples-to-oranges comparison.

**Bottom-up sizing** starts from the customer unit: count the addressable customers, multiply by realistic revenue-per-customer, sum the result. It answers "how many customers exist and what will they pay?" It is slower to construct but more interrogable — every assumption is visible. Tomasz Tunguz emphasises that bottom-up sizing is what matters at growth stage because it ties directly to the ARR model and unit economics.

**Triangulation is not optional.** Running both methods and arriving at approximately the same number provides genuine confidence. Arriving at different numbers is a forcing function: find the gap, name the assumption that caused it, and resolve it. Skipping one method removes the check.

### Value theory vs. spend-share

There are two ways to anchor TAM: on existing spend in a category (share of wallet) or on the value the product creates for customers (value theory). Spend-share sizing is easier to source but understates markets where the product enables something customers couldn't previously do. Value-theory sizing requires willingness-to-pay research but is more defensible for new categories. Andreessen Horowitz's TAM-sizing framework explicitly calls for value-theory estimates when the product enables new behaviour — because spend-share sizing will always make the market look smaller than it is.

The choice of anchor is a strategic one: use spend-share when you are competing for an existing budget line; use value theory when your product creates a new budget line.

### How investors and CFOs actually read sizing claims

Investors are not reading TAM slides for the number. They are reading them for the quality of the thinking. A $10B TAM backed by a single Gartner citation signals one thing; a $10B TAM arrived at by two independent methods with stated assumptions signals another. Gurley's "All Revenue Is Not Created Equal" discipline applies here: the sizing is only as valuable as the quality of the underlying assumptions. A defensible SOM estimate derived from competitor share data, GTM capacity, and churn assumptions is more persuasive than a hopeful percentage.

CFOs read the SOM line and immediately ask: does the team's current or planned GTM capacity support this number? If SOM implies 500 enterprise customers in year 2 but the team has no enterprise sales motion, the estimate has no credibility. SOM must be grounded in the go-to-market plan, not just the market data.

### The "fudge factor" tell

Gurley and Tunguz both flag the same pattern: market-sizing estimates that arrive at suspiciously round numbers, or that use undocumented multipliers to bridge a gap between the data and the desired conclusion, signal that the analyst has worked backwards from a target. Common tells: "we conservatively assume we can reach X% of the market" (where X is chosen to produce a large SOM, not derived from GTM data); TAM estimates that are rounded to the nearest billion; SOM estimates that are a fixed percentage of SAM rather than a product of customer count × ARPU.

Sizing is judgement-shaped, not formula-shaped. The goal is not to produce a precise number but to produce an honest range with named assumptions — and to know which assumptions, if wrong, would most change the conclusion.

## Application

Eight steps. Steps 1–4 are definitional; steps 5–6 are computational; steps 7–8 are stress-test and presentation.

### Step 1 — Define the sizing question

Write the question the sizing must answer in one sentence: what decision does this estimate support, for whom, and over what horizon? "Is the US SMB workflow-automation market large enough to justify a $15M seed round?" is a sizing question. "What is the TAM?" is not. The question scopes the estimate and determines which data sources are load-bearing.

### Step 2 — Define the customer unit

Before computing anything, define the unit: who is the customer, what are their observable characteristics (firmographics or demographics), and what problem are they paying to solve? Clayton Christensen's JTBD framing is useful here: customers are "hiring" a product to make progress on a specific job. Defining the job precisely keeps the SAM honest — only customers with that specific job are in the addressable market, regardless of how large the broader category appears.

Document the customer unit definition explicitly. Inconsistent customer definitions between top-down and bottom-up passes are the most common cause of triangulation failure.

### Step 3 — Choose the TAM anchor (spend-share or value theory)

Decide whether to anchor on existing spend in the category or on the value the product creates. State the choice and the reason. If the product displaces an existing budget line, spend-share is appropriate. If it creates a new one, value theory is required. If unsure, run both and see where they diverge.

### Step 4 — Gather inputs for both methods

**Top-down inputs:** Industry analyst reports, census data, government statistics, public company filings in the category. Cite the source, the year, and the specific number used. Do not use a number you cannot link to a primary source.

**Bottom-up inputs:** Estimated count of target customers (from databases, census data, or competitive proxy), estimated revenue per customer (from ARPU data, willingness-to-pay research, or comparable pricing), and the conversion assumptions that link the two. Every input should be sourced or explicitly flagged as an assumption.

### Step 5 — Compute: top-down pass

Start from the category-level number. Apply sequential filters to narrow from TAM → SAM → SOM:

- TAM: category revenue × segment share (e.g., US SMB share of global workflow-automation spend)
- SAM: TAM × product-fit filter × geography filter × channel-reach filter
- SOM: SAM × competitive share estimate × GTM-capacity constraint

Show the math at each step. Each filter should be sourced or stated as an explicit assumption. The result is a range, not a point estimate.

### Step 6 — Compute: bottom-up pass

Start from the customer unit:

- Count of addressable customers (target segment × geography × problem-fit filter)
- Revenue per customer (ARPU or ACV estimate, sourced or assumed)
- TAM = count × revenue per customer (no competitive constraint)
- SAM = count of reachable customers × revenue per customer
- SOM = count of winnable customers × revenue per customer, where "winnable" is bounded by GTM capacity and competitive win-rate assumptions

Show the math. State every assumption. The result is a range.

### Step 7 — Triangulate and resolve gaps

Compare the top-down and bottom-up results at each tier. Acceptable triangulation: the two estimates are within the same order of magnitude and the directional story is consistent. Unacceptable triangulation: the estimates differ by more than 3×, or one is high at TAM and low at SOM while the other reverses. When gaps exceed tolerance:

1. Name the assumption that most likely explains the gap.
2. Check that assumption against available data.
3. Revise the weaker assumption and recompute.
4. Document the gap and the resolution in the final output.

If the gap cannot be resolved, present both estimates as a range and state which assumption drives the spread.

### Step 8 — Sanity-check and present

Before presenting, apply three checks:

- **GTM capacity check.** Does the SOM number imply a sales volume or customer count the team's current or planned GTM motion can actually support? If not, SOM is overstated.
- **Competitive density check.** Does the SOM claim a share of SAM that exceeds what the leading incumbent holds? If so, the estimate needs an explicit argument for why the team will outcompete the incumbent.
- **Revenue model consistency check.** Does the SOM × ARPU reconcile with the financial model's Year 2–3 ARR projections? Divergence here signals one of the two documents is wrong.

Present the estimate as: a stated range at each tier, the method used, the three most influential assumptions, and a one-line statement of what would need to be true (and what would need to be false) for the estimate to hold.

## Examples

### Example 1 — B2B SaaS: project-management tooling for architecture firms (worked)

**Sizing question:** Is the US market for project-management SaaS targeted at architecture and engineering firms large enough to support a $5M ARR target by end of year 3, starting from zero?

**Customer unit (JTBD):** Architecture and engineering firms with 10–250 employees, hiring project-management software to track billable hours, project budgets, and subcontractor coordination on a per-project basis. (Not general-purpose PM tools; not enterprise ERP.) Firms outside this size band are excluded: smaller firms use spreadsheets and are below realistic ARPU; larger firms use enterprise platforms outside the competitive set.

**TAM anchor:** Spend-share. The US AEC software market has existing budget for purpose-built tools; this product competes for that existing line item.

**Top-down pass:**

- US AEC software market: $4.2B (IBISWorld, 2024 industry report, US only)
- Segment filter: project-management sub-category ≈ 18% of AEC software spend (Gartner estimate, 2023) → $756M
- TAM (top-down): ~$760M
- Firm-size filter: 10–250 employee firms represent ≈ 45% of firms but ≈ 30% of AEC software spend (US Census Bureau, County Business Patterns, 2023) → SAM ≈ $228M
- Channel filter: direct SaaS (no reseller/channel model in year 1) reaches ≈ 60% of SAM → reachable SAM ≈ $137M
- SOM: leading competitor (Deltek) holds ≈ 22% of the SMB sub-segment; realistic new-entrant share in year 1–3 is 2–4% → SOM = $2.7M–$5.5M

**Bottom-up pass:**

- US AEC firms with 10–250 employees: ≈ 72,000 (US Census Bureau, 2023)
- Estimated fraction with the target job (active project tracking, ≥5 concurrent projects): 35% → ≈ 25,000 firms
- ARPU estimate: $3,600/year (based on comparable SaaS pricing at $300/mo for 5–20 seat teams; validated against competitor pricing pages)
- TAM (bottom-up): 72,000 × $3,600 = $259M (narrower than top-down TAM because bottom-up counts only job-fit firms, not all AEC software spend)
- SAM: 25,000 firms × $3,600 = $90M
- SOM (year 3): GTM capacity supports ≈ 400–600 closed accounts by end of year 3 (2 AEs × 20 deals/month × 36 months, net of churn) → 500 × $3,600 = $1.8M ARR. With expansion revenue assumption (1.2× NRR): $2.2M ARR

**Triangulation:**

Top-down SOM: $2.7M–$5.5M. Bottom-up SOM: $2.2M ARR year 3. These are directionally consistent. The gap (bottom-up is lower) is explained by GTM capacity: the top-down estimate is market share × SAM, while the bottom-up estimate is bounded by what the team can actually close. The bottom-up number is more conservative and more credible for planning; the top-down range establishes that more share is available if GTM scales.

**Conclusion:** $5M ARR by year 3 is in range but requires either faster sales hiring or higher ARPU. The market supports the ambition; the constraint is execution capacity, not market size.

---

### Counter-example — "Total population × hopeful spend" (failure)

> "There are 500 million knowledge workers globally. If even 0.1% adopt our tool at $10/month, that's $6M ARR."

**What's wrong:**

- TAM is the entire global knowledge-worker population, with no JTBD filter. The product solves a specific problem for a specific segment; conflating the two inflates TAM by orders of magnitude.
- The 0.1% figure is not derived from GTM capacity, competitive share data, or conversion assumptions. It is chosen to produce a large-enough number. This is the fudge-factor pattern Gurley flags.
- No top-down method is run. There is no triangulation. The estimate is a single path from an inflated TAM to a convenient SOM.
- "Knowledge workers" is not a customer unit. There is no JTBD, no firmographic or demographic filter, no defined competitive alternative.

An investor or CFO who has read Gurley's work will identify this pattern in seconds. The fix is to run both methods from a defined customer unit and show the triangulation.

## Common Pitfalls

### Pitfall 1 — Fudge-factor SOM

**Symptom.** SOM is a round percentage of SAM — "we're conservatively targeting 2% of the market" — with no derivation from GTM capacity, competitive win-rate, or customer count.

**Consequence.** The estimate has no predictive value and signals to investors that the team has not modelled its own go-to-market. A 2% number is unfalsifiable; a "500 customers × $3,600 ARPU" number is testable.

**Fix.** Derive SOM from customer count × ARPU × GTM capacity, not from SAM × percentage. The percentage can be reported as a result ("that implies 2.3% of SAM") but must not be the input.

### Pitfall 2 — TAM conflated with revenue opportunity

**Symptom.** The sizing equates a large TAM with a large revenue opportunity for the company. "The market is $10B, so there's plenty of room." Competitive density, share distribution, and the company's actual reachable segment are not examined.

**Consequence.** Gurley's core critique: total market size and individual company revenue opportunity are different quantities. A $10B market dominated by two players at 60% combined share and five mid-tier players at 30% leaves 10% for entrants — $1B. At a realistic new-entrant share, the revenue opportunity may be $50M–$150M, not $10B. Presenting $10B as the opportunity is misleading.

**Fix.** Always step from TAM → SAM → SOM explicitly, with competitive density accounted for in the SOM step. Report the SOM, not the TAM, as the revenue opportunity.

### Pitfall 3 — Ignoring competitive density inside SOM

**Symptom.** SOM is calculated as SAM × assumed share without examining what the existing competitive set holds and why customers would switch.

**Consequence.** Moore's SOM realism: you cannot assume share without a beachhead thesis. If the top two incumbents hold 65% of the SAM, the remaining 35% is split among many players; a new entrant doesn't capture 5% of SAM by default — it captures 5% of the uncontested portion, or it displaces an incumbent with a specific argument.

**Fix.** Research the competitive share distribution inside the SAM. State explicitly who you are displacing, why customers switch, and what your beachhead segment is. The SOM claim should reference specific customer segments being won, not aggregate market percentages.

### Pitfall 4 — Single-method sizing with no triangulation

**Symptom.** Only top-down or only bottom-up sizing is run. The estimate is presented as a single number without a method check.

**Consequence.** A single path from a large analyst number to a convenient SOM is unfalsifiable. Tunguz emphasises that growth-stage investors specifically probe bottom-up assumptions because top-down numbers are easy to source and easy to manipulate. An estimate without triangulation has no internal validity check.

**Fix.** Run both methods. Show both results. Document the gap and how it was resolved. If the methods cannot be reconciled, present a range and name the assumption that drives the spread.

### Pitfall 5 — Customer unit too broad

**Symptom.** The TAM is defined at category level ("all businesses that buy software"), making the SAM and SOM filters feel arbitrary rather than principled. The sizing is not anchored to a specific JTBD.

**Consequence.** Christensen's JTBD frame exposes this: if you can't name the specific job customers are hiring the product to do, the addressable market is undefined. A broad customer unit inflates TAM and makes every filter downstream feel like top-down rationalization.

**Fix.** Define the customer unit by job, not by category. "Firms hiring project-management software to track billable hours and subcontractor budgets on AEC projects" is a customer unit. "Businesses that buy software" is not.

### Pitfall 6 — No assumption audit before presenting

**Symptom.** The sizing is presented with numbers but the three or four load-bearing assumptions are not named explicitly. Reviewers probe assumptions and the PM cannot defend them.

**Consequence.** The estimate collapses under questioning. The numbers are no more credible than the least-defensible assumption, and if the PM cannot name which assumption that is, the whole estimate becomes suspect.

**Fix.** Before presenting, write down the three assumptions that most change the SOM estimate if wrong. Be prepared to defend each one or state its uncertainty explicitly. Presenting an honest range ("SOM is $2M–$5M depending on whether ARPU assumption holds") is more credible than false precision.

## References

- **Bill Gurley** — "All Revenue Is Not Created Equal" (*Above the Crowd*, 2012). Gurley's central point: quality and sustainability of the revenue stream matters more than the headline number. Applied here: a TAM/SAM/SOM estimate is only as credible as the quality of its underlying assumptions. Gurley's sizing skepticism — the insistence that founders anchor on realistic obtainable revenue rather than theoretical total spend — underpins the triangulation requirement and the pitfalls in this skill. See also his general commentary on VC pitch dynamics and market-size inflation.
- **Andreessen Horowitz** — TAM-sizing framework (a16z blog, multiple posts on market sizing and category creation). The a16z framework distinguishes spend-share sizing from value-theory sizing and names when each is appropriate. Referenced in Key Concepts, Step 3, and the spend-share vs. value-theory distinction.
- **Tomasz Tunguz** — *Theory Ventures* blog, posts on SaaS unit economics and bottom-up market sizing. Tunguz's emphasis on bottom-up sizing as a discipline — because it ties directly to the ARR model and reveals GTM capacity constraints — informs Steps 5–6 and Pitfall 4 of this skill.
- **Geoffrey Moore** — *Crossing the Chasm* (1991, HarperBusiness). Moore's beachhead and target-customer framing is the foundation for SOM realism: you win SOM by owning a specific segment completely before expanding. The competitive density check in Step 8 and Pitfall 3 both trace to Moore's argument that diffuse coverage of SAM produces no wins, while concentrated ownership of a beachhead produces a defensible SOM.
- **Clayton Christensen** — Jobs-to-be-Done theory (developed across *The Innovator's Dilemma*, 1997; *Competing Against Luck*, 2016). JTBD is the input to customer unit definition in Step 2: the addressable market is not "everyone in a category" but "everyone with the specific job the product is hired to do." Christensen's framing prevents TAM inflation by anchoring market definition to a specific customer progress problem.
- **Related Hornero skills:**
  - [`positioning-statement`](../positioning-statement/SKILL.md) — the "for [target customer]" slot in positioning requires a defined SAM segment. TAM/SAM/SOM sizing provides the quantified version of that segment.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD is the input to customer unit definition in Step 2. Run JTBD before TAM/SAM/SOM when the target customer is unclear.
  - [`revenue-architecture`](../revenue-architecture/SKILL.md) — the SOM estimate feeds directly into the revenue architecture. SOM × ARPU is the ceiling for the ARR model; the two must reconcile.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — TAM/SAM/SOM sizing is the market-side input to bet evaluation. A bet's SOM ceiling relative to team capacity is one criterion for portfolio allocation.
  - [`finance-metrics-quickref`](../finance-metrics-quickref/SKILL.md) and companion `business-health-diagnostic` — unit economics (LTV, CAC, payback period) should be checked for internal consistency against the SOM estimate before presenting.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/tam-sam-som-calculator) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
