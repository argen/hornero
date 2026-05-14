---
name: bet-portfolio
description: Use to make the implicit bets in a product strategy explicit — typically 3-7 bets, each with assumption, evidence weight, kill criterion, and revisit cadence.
intent: |
  Surfaces and stress-tests the strategic bets embedded in a product
  strategy or roadmap. For each bet: the wager itself, the assumption
  that must hold, the evidence currently weighing on it (Gilad Confidence
  Meter), the kill criterion, and the revisit cadence. Forces the team to
  own bets explicitly rather than discovering them retrospectively.
type: component
theme: strategy
best_for:
  - Translating a strategy kernel's coherent actions into explicit bets
  - Quarterly strategy reviews asking "what are we actually wagering?"
  - Pre-planning alignment so OKRs are backed by falsifiable hypotheses
  - Post-mortem diagnosis of why a strategic direction failed
scenarios:
  - "PM with a roadmap but no answer to 'what happens if this is wrong?'"
  - "Leadership asking which strategic bets the team is carrying right now"
  - "Strategy kernel complete but the coherent actions feel like a to-do list, not a theory"
  - "Quarterly planning where OKRs exist but nobody can say why those outcomes will move"
estimated_time: 90-150 minutes (first pass); 30-45 minutes (quarterly update)
---

# Bet portfolio

> v0 draft. Anchored in Cagan (*Inspired*, *Empowered*), Doshi (Type-1/Type-2), Gilad (*Evidence-Guided*), Wodtke (*Radical Focus*), and Rumelt (*Good Strategy / Bad Strategy*). Editorial review recommended.

## Purpose

Make the implicit bets in a product strategy explicit — and keep them honest over time.

A strategy always contains bets. The question is whether they are named or hidden. When bets are hidden, the team can't assign ownership, can't update confidence when evidence arrives, and can't kill a losing bet before it drains months of capacity. The bet portfolio is the artifact that surfaces them.

The portfolio operates at the bet level — typically 3-7 strategic wagers. This is distinct from:

- **Prioritization** (`prioritization-advisor`), which works at the work-item level (30-300 items). Bets are the layer above: each bet contains multiple candidate items.
- **PRDs** (`prd`), which document one solution to one problem. A bet usually contains multiple PRDs.
- **OKRs** (`okrs`), which are quarterly outcome commitments. OKRs measure progress against bets; bets are the hypotheses that explain *why* those outcomes will move.
- **Strategy kernel** (`strategy-kernel`), which names the diagnosis, guiding policy, and coherent actions. The bet portfolio is the explicit listing of the wagers implied by those coherent actions.

## Key Concepts

### What is a bet

A bet is a falsifiable hypothesis about the world that the team is willing to spend resources on. It is not a feature, a goal, or a directive.

- **A feature** is a deliverable: "ship the self-serve onboarding flow." A bet is the wager behind it: "we bet that mid-market customers will reach first value within 14 days without a human touch."
- **A goal** is a desired outcome: "increase net retention to 115%." A bet is the causal theory: "we bet that net retention will compound to 115% if we close the integration gap in the first 30 days of a customer's lifecycle."
- **A directive** is an instruction without consequence: "we are investing in the enterprise segment." A bet has a kill criterion: "we are investing in the enterprise segment and we will stop if average contract value does not exceed $40k ARR by Q3."

Bets must be falsifiable. If no observable would cause the team to stop, it is not a bet — it is a directive dressed up (Rumelt: strategy without consequence is not strategy).

### Cagan's four risks as bet dimensions

Cagan (*Inspired*, *Empowered*) identifies four risks every product team faces. A bet must name which risk it primarily wagers on — because the evidence that validates or kills it differs by risk type:

- **Value risk.** Will customers care? Will they use it? Pay for it? The bet is about demand.
- **Usability risk.** Can customers get to the outcome without struggling? The bet is about the delivery path.
- **Feasibility risk.** Can the team build and maintain it sustainably? The bet is about the capability to deliver.
- **Business viability risk.** Does it pay back — margin, competitive position, strategic coherence? The bet is about the return.

A portfolio that carries only value-risk bets is blind to the capability and economic risks underneath them. A well-formed portfolio has coverage across risk dimensions.

### Doshi's Type-1 vs Type-2 framing

Doshi distinguishes decisions by reversibility. Type-1 decisions are hard to reverse; the cost of a wrong call is high and asymmetric. Type-2 decisions are reversible; a wrong call can be unwound.

Bets are Type-1 commitments. Entering a market segment, re-platforming infrastructure, or making a pricing model change are hard to undo. The portfolio discipline forces the team to acknowledge which commitments are in play, rather than drifting into them through accumulated Type-2 decisions that collectively become irreversible. The kill criterion is the mechanism that makes a Type-1 commitment conditional rather than permanent.

### Gilad's Confidence Meter

Gilad (*Evidence-Guided*) distinguishes evidence by type:

- **Data.** Quantitative signal: usage analytics, A/B results, sales conversion rates, retention cohorts. Hard to argue with; easy to misread.
- **Insight.** Qualitative signal: customer interviews, support patterns, sales-call recordings, ethnographic observation. Rich context; small-N; generalizability requires care.
- **Belief.** Internal assertion: executive intuition, market analogies, team assumption. Not worthless — experience matters — but the weakest form of evidence.

Confidence on a bet is scored per evidence type. A bet with strong data but no insight has a specific blind spot (the numbers say yes but nobody has talked to a customer). A bet with strong insight but no data has a different blind spot (customers say they will; the funnel hasn't confirmed they do).

Confidence is not a one-time score. It is an attribute that must update as evidence arrives. A bet that carries the same confidence score for three quarters has not been re-examined; it has been forgotten.

### Kill criteria (Rumelt's coherence test in the time dimension)

Rumelt (*Good Strategy / Bad Strategy*): coherence is the test of strategy — the actions must reinforce each other and fit the diagnosis. The kill criterion applies this test in the time dimension: if the bet's underlying assumption proves false, continuing to act on it destroys coherence.

A kill criterion is not a performance target. It is the specific observable that would cause the team to stop the investment. If the kill criterion never fires, the bet is not being managed as a bet — it is being executed as a directive.

Practical form: "We will stop investing in [X] if [observable Y] reaches [threshold Z] by [date]." Observable, threshold, and date are all required. A kill criterion missing any of the three is not operational.

### Wodtke's forcing-choice

Wodtke (*Radical Focus*): the point of forced prioritization is not efficiency — it is clarity about what the team is *not* doing. The same principle applies to bets. A portfolio of 3-7 bets is a forced choice: naming these bets means refusing the alternatives. A portfolio of 20 "bets" is a hedge, not a strategy. If every direction is a bet, no direction is favored.

The number matters. Three to seven bets can be held in the team's working memory, reviewed quarterly, and owned individually. Twenty cannot.

## Application

Seven steps; allow 90-150 minutes for a first-pass portfolio.

### Step 1 — Surface the implicit bets (20-30 minutes)

Read the strategy kernel (or current roadmap if no kernel exists). For each coherent action or major initiative, ask: "What must be true about the world for this to pay off?" The answer is the implicit bet.

This step is archaeological. Most bets already exist in the strategy — they are just not named. Naming them is not creative work; it is disclosure work.

Output: a raw list of candidate bets, in one sentence each. Expect 8-15 before culling.

### Step 2 — Write each bet in full (30-40 minutes)

For each candidate bet, complete the five-field template:

| Field | Description |
|-------|-------------|
| **The bet** | One sentence: what the team is wagering will be true. |
| **Assumption** | The specific condition that must hold for the bet to pay off. |
| **Evidence weight** | Confidence per evidence type (data / insight / belief), with source. |
| **Kill criterion** | Observable + threshold + date. If the observable is reached, the investment stops. |
| **Revisit cadence** | When the team looks at this bet regardless of whether the kill criterion fires. |

The evidence weight field should cite actual evidence, not assert confidence. "High confidence — we have retention data from the March cohort showing X" is a valid evidence entry. "High confidence — we believe this is true" is a belief assertion, not evidence.

### Step 3 — Rank bets by confidence × leverage (15-20 minutes)

Apply Doshi's LNO framing crossed with Gilad's Confidence Meter:

- **Leverage** — if this bet pays off, does it compound? Does winning here make the next bets easier or more likely to pay off?
- **Confidence** — what is the aggregate evidence weight across all three evidence types?

Rank bets from highest (high leverage + high confidence) to lowest (low leverage + low confidence). The ranking is not a commitment to invest proportionally — it is a diagnostic. Bets with high leverage but low confidence are the most important to investigate. Bets with low leverage and high confidence may warrant less executive attention than their confidence implies.

### Step 4 — Assign explicit owners (5-10 minutes)

Every bet needs a single accountable owner — the person responsible for tracking evidence, updating confidence, and calling the kill criterion when it fires. Ownership-by-committee means no one watches the bet.

Flag bets with no clear owner. These are the highest-risk items in the portfolio, not because the bets are wrong, but because no one is accountable for knowing whether they are wrong.

### Step 5 — Apply the coherence test (10-15 minutes)

Rumelt: coherent actions reinforce each other. The same test applies to bets. For each pair of bets, ask: do they reinforce each other, or do they pull in opposite directions?

Two common incoherence patterns:

- **Resource conflict.** Bet A requires deep investment in self-serve motion; Bet B requires high-touch enterprise sales. Both may be valid bets individually; together they compete for the same engineering and GTM capacity.
- **Assumption conflict.** Bet A assumes customers will expand without human intervention; Bet B assumes net retention requires success manager coverage of every account. Both can't be right at the same scale.

Incoherent bets do not invalidate each other automatically — but they require explicit acknowledgment. Either the team resolves the conflict, or it documents the tension and decides to carry it intentionally.

### Step 6 — Document the portfolio artifact (10-15 minutes)

Produce a single document: one row per bet in a summary table, one bet in full detail (all five fields) as the worked example, and a short coherence note. Target length: one to two pages.

The artifact is not a strategy presentation. It is a working document that the team returns to quarterly. Clarity over polish.

### Step 7 — Schedule the next review (5 minutes)

The portfolio is not a point-in-time artifact. Commit to a review cadence before leaving the session — typically quarterly, aligned with OKR reviews. The review question is: has any kill criterion fired? Has confidence on any bet updated materially? Does the portfolio still reflect the strategy kernel?

A bet portfolio that is not reviewed is a bet portfolio that is not being managed.

## Examples

### Worked example — B2B SaaS, mid-market expansion

**Context.** A project-management SaaS with strong SMB traction expanding into mid-market (50-500 seat accounts). Strategy kernel's guiding policy: win mid-market through self-serve expansion, not field sales. The following portfolio is the bets that policy implies.

---

**Full detail — Bet 1 (value + usability risk)**

**The bet.** Mid-market buyers will adopt the product across a team of 20+ without a dedicated onboarding manager if the in-app guidance reaches them within the first 3 days.

**Assumption.** The primary barrier to mid-market adoption is time-to-value in the first week, not feature depth or price. If we get a team to a shared project within 72 hours, expansion from the initial seat license follows.

**Evidence weight.**

| Type | Score (1-10) | Source |
|------|-------------|--------|
| Data | 7 | Cohort analysis (March 2026): accounts that reach a shared project in ≤72h have 2.3× 90-day expansion rate vs. those that don't. n=210 accounts. |
| Insight | 6 | 8 customer interviews with mid-market champions: 6/8 cited "getting the team set up" as the point of friction, not feature gaps. |
| Belief | 8 | Sales team believes time-to-value is the lever; corroborated by lost-deal analysis (Q1 2026: 40% of mid-market losses cited slow onboarding). |

Aggregate confidence: **medium-high**. Data is the strongest signal; insight directionally confirms; belief is aligned. Blind spot: no usability-testing of the in-app guidance with actual mid-market users (only SMB cohorts).

**Kill criterion.** Stop investing in self-serve mid-market onboarding if: accounts that complete the new in-app guidance do not show ≥1.8× 90-day expansion rate vs. the control cohort by October 31, 2026 (90 days post-launch, minimum n=100 accounts).

**Owner.** Head of Product Growth.

**Revisit cadence.** Monthly data review; full portfolio review at Q3 planning (July 2026).

---

**Portfolio summary table**

| # | Bet | Risk dimension | Confidence | Owner | Kill criterion fires if… | Revisit |
|---|-----|---------------|------------|-------|--------------------------|---------|
| 1 | Mid-market teams adopt self-serve within 72h | Value + usability | Medium-high | Head of Product Growth | Expansion rate <1.8× vs. control by Oct 31 | Monthly |
| 2 | Infrastructure scales to 10× current peak without re-architecture | Feasibility | Medium | VP Engineering | P99 latency exceeds 800ms under 5× load in staging test by Aug 15 | Pre-launch load test |
| 3 | Net retention >115% compounds to ARR target by Q4 | Business viability | Medium-low | Chief Revenue Officer | NRR falls below 105% for two consecutive quarters | Quarterly |
| 4 | Integration marketplace drives top-of-funnel from partner ecosystem | Value | Low | Head of Partnerships | Zero qualified trials attributable to integrations after 90 days of marketplace launch | 90 days post-launch |

**Coherence note.** Bets 1 and 3 reinforce each other: self-serve onboarding that drives expansion is the mechanism through which net retention compounds. Bet 4 is independent but additive — integration-sourced trials are a separate acquisition channel that does not compete with Bets 1-3 for product investment. Bet 2 is a capability prerequisite for all others; if it fires, it escalates above the portfolio level.

**What this portfolio excludes.** The team is explicitly not betting on: field sales for mid-market (chosen against in favor of self-serve); geographic expansion (deferred to H2); a freemium tier (requires separate infrastructure investment that conflicts with Bet 2 capacity).

## Common Pitfalls

### Pitfall 1 — Bet-as-feature

**Symptom.** The portfolio contains entries like "ship the new dashboard" or "launch the API v2."

**Consequence.** Features are outputs; bets are hypotheses. A feature cannot be killed when evidence changes — it is either shipped or not. A portfolio of features is a roadmap with a different name (Cagan: feature-shaped output disguised as strategy).

**Fix.** For each candidate bet, ask: "What must be true about the world for this to pay off?" The answer is the bet. The feature is at most the coherent action that expresses the bet.

### Pitfall 2 — Confidence as a one-time score

**Symptom.** The portfolio is documented in Q1; confidence scores are never updated; by Q3, the team is still citing Q1 evidence that has since been contradicted.

**Consequence.** The portfolio becomes a snapshot rather than a living instrument. Bets that should have been killed continue drawing investment because nobody re-examined the confidence score.

**Fix.** Gilad's Confidence Meter requires an update cadence. At each revisit, ask: has any evidence arrived since the last review that changes the score on any dimension (data / insight / belief)? The update is the discipline, not the original score.

### Pitfall 3 — No kill criterion

**Symptom.** Bets are written with a bet, an assumption, and evidence — but no observable that would cause the team to stop.

**Consequence.** The bet is functionally a directive. No evidence will ever be sufficient to kill it because no threshold was named. Teams continue investing past the point of disconfirmation because the exit condition was never articulated (Rumelt: strategy without consequence is not strategy).

**Fix.** The kill criterion requires three components: observable, threshold, and date. Any bet missing one of the three is incomplete. If the team cannot agree on a kill criterion, the disagreement is the most important conversation to surface — it usually means the team does not share the same underlying assumption.

### Pitfall 4 — Portfolio of 20+ bets

**Symptom.** The portfolio surfaces 20 bets from the roadmap; the team treats all of them as active strategic commitments.

**Consequence.** No forced choice is made. The portfolio is a hedge. Ownership spreads across the organization with no individual carrying more than a fragment (Wodtke: if everything is a bet, nothing is a forced wager).

**Fix.** Cull to 3-7. The culling process is itself strategic work: which bets, if wrong, would invalidate the strategy? Those are the portfolio bets. The rest belong in the backlog as candidate items under the bets they serve.

### Pitfall 5 — Owner-by-committee

**Symptom.** Multiple teams or functions are listed as co-owners of a bet.

**Consequence.** When evidence changes, nobody calls it. When the kill criterion approaches, diffusion of responsibility produces silence. The bet continues by inertia.

**Fix.** Cagan's empowered-team principle: one named individual is accountable for monitoring the bet, updating confidence, and surfacing a kill call if the criterion fires. Cross-functional input is welcome; single accountability is required.

### Pitfall 6 — Bets misaligned with the kernel

**Symptom.** The portfolio contains bets that do not ladder to any coherent action in the strategy kernel, or coherent actions in the kernel that are not represented by any bet.

**Consequence.** Orphan bets indicate either a kernel that doesn't reflect real investment, or portfolio drift — bets that were added opportunistically without grounding in the guiding policy. Unbet coherent actions are strategy on paper that nobody is actually wagering on.

**Fix.** Map each bet to the coherent action in the kernel that expresses it. Flag orphans in both directions. Either update the kernel, update the portfolio, or document intentionally why the mismatch is acceptable.

## References

- **Marty Cagan** — *Inspired* (2008, rev. 2017); *Empowered* (2020, with Chris Jones). Four risks as the stress-test dimensions for each bet. Empowered-team model as the basis for single-owner accountability.
- **Itamar Gilad** — *Evidence-Guided* (2024). Confidence Meter (data / insight / belief); the discipline of evidence-weighting that prevents bet confidence from hardening into untested belief.
- **Richard Rumelt** — *Good Strategy / Bad Strategy* (2011). Coherence as the test of strategy; the requirement that strategy have consequence. Kill criteria are Rumelt's coherence test made operational in time.
- **Christina Wodtke** — *Radical Focus* (2016, rev. 2021). Forcing-choice: 3-7 bets, not 15. Naming bets means refusing alternatives. The distinction between OKRs (outcome commitments) and bets (hypotheses about why outcomes will move).
- **Shreyas Doshi** — Type-1 vs Type-2 decision framing; decision-quality methodology. Bets are Type-1 commitments; the portfolio discipline forces their explicitness.
- **Related Hornero skills:**
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the kernel's coherent actions are the source material for surfacing bets in Step 1. Portfolio and kernel should be in sync.
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — work items ladder up to bets. LNO and ICE operate at the item level; the portfolio operates at the bet level above.
  - [`success-metrics`](../success-metrics/SKILL.md) — each bet's kill criterion is a measurement-design problem. Route to success-metrics for definitional rigor on the observable and threshold.
  - [`okrs`](../okrs/SKILL.md) — OKRs measure progress against bets. OKRs without an underlying bet are output-shaped. The portfolio is the "why these KRs will move" layer beneath OKRs.
