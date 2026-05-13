---
name: experiment-design
description: Use when a team is designing an A/B test or controlled experiment — to fix the OEC, guardrails, MDE, sample size, randomization unit, SRM check, and stopping rule before traffic is allocated.
intent: |
  Produces or critiques an experiment design that resists four failure
  modes practitioners regularly walk into: under-powered tests
  (insufficient sample for the effect size that matters), optional-
  stopping bias (checking-and-stopping that inflates false positives),
  SRM-blindness (broken randomization mistaken for signal), and
  metric-shopping (running the test, then choosing which metric
  "won"). The design must be writable on one page and defensible by
  the data scientist when the result lands.
type: component
theme: experimentation-rigor
best_for:
  - A/B test of a product or pricing change before traffic is allocated
  - Holdout-design where the team is launching to all users but wants
    a counterfactual estimate
  - Feature-launch with a measurement plan that needs power analysis
  - Replication / re-run of an inconclusive previous experiment
scenarios:
  - "A/B test of a new checkout flow with conversion as OEC"
  - "Designing a 10% holdout for a fully-launched recommender system"
  - "Pricing experiment with revenue per visitor as OEC and refund rate as guardrail"
  - "Re-running an inconclusive onboarding test with a better-powered design"
estimated_time: 45-90 minutes (design); 15-30 minutes (critique of an existing design)
---

# Experiment design

> v0 draft. Grounded in Ron Kohavi, Diane Tang & Ya Xu's *Trustworthy Online Controlled Experiments* (2020) for the operational discipline, Andrew Gelman & Richard McElreath's Bayesian framing for honest uncertainty quantification, and Daniel Kahneman's *Noise* (2021) on detecting decision-noise that contaminates apparent treatment effects.

## Purpose

Produce an experiment design that:

1. **Names the OEC** — the single Overall Evaluation Criterion that will decide the experiment, defined per [`metric-definition`](../metric-definition/SKILL.md).
2. **Names the guardrails** — non-degradation constraints (latency, error rate, refund rate, abuse signals) that can veto a ship even if OEC wins.
3. **Has a power analysis** — the Minimum Detectable Effect (MDE) we care about, the sample size required, and the duration that implies given traffic.
4. **Specifies randomization** — the unit (user / session / device / account), the salt, the hash function, and the proportion split.
5. **Has an SRM check** — the threshold for declaring a sample-ratio mismatch, computed automatically.
6. **Names the stopping rule** — when we look, what we do if we look early, and what would invalidate the run.
7. **Is pre-registered** — the analysis plan is written before traffic is allocated; subsequent metric / segmentation / time-window choices are flagged as exploratory.

An experiment without these is a Rorschach test for the data scientist: any result can be cherry-picked into a story. With them, the result is decision-ready.

## Key Concepts

### OEC + guardrails (Kohavi)

The **OEC** is the single number the experiment decides on. Compose it carefully — it's the place where "what we want" becomes operational. **Guardrails** are independent metrics that protect against unhealthy improvement on the OEC; an OEC win that breaches a guardrail does not ship.

Don't conflate the two: an OEC is the *goal*; guardrails are the *constraints*. A guardrail is not "another OEC to also win on" — it's a constraint that must not regress beyond a stated tolerance.

### Minimum Detectable Effect (MDE)

The smallest effect size the experiment can reliably distinguish from no effect, given:

- The OEC's variance.
- The chosen statistical power (typically 80%).
- The chosen significance level (typically 5%).
- The randomization unit count.

If you don't know your MDE, you don't know your experiment's resolution. A 50K-user test with a 0.05% MDE will probably hide a meaningful 0.02% lift. The team will read the null result as "no effect"; it's actually "we couldn't see it."

### Sample Ratio Mismatch (SRM)

When the observed traffic split differs from the planned split (e.g., planned 50/50, observed 51.3/48.7). The standard test: chi-squared on observed vs. expected counts; alarm at p < 0.001.

Kohavi's industry data: ~6% of experiments at Microsoft showed SRM. Almost all SRM cases are **broken randomization, not real signal** — caching, bot filtering applied unevenly, redirects, cookie-recovery logic. An SRM finding invalidates the experiment; investigate the cause before any decision.

### Randomization unit

The unit of analysis must match the unit of randomization. Common choices:

- **User** (logged-in) — clean, consistent across sessions, requires authentication.
- **Anonymous user** (cookie / device ID) — covers logged-out, but lossy across browsers and incognito.
- **Session** — coarsest; problematic when behaviour spans sessions (e.g., onboarding).
- **Account** (B2B SaaS) — randomize at the org level when users within an org interact.
- **Geography / interleaved** — for network effects or supply-side experiments.

Mismatching unit-of-randomization and unit-of-analysis (e.g., randomize by user, analyse by session) produces correlated observations and underestimates variance. Standard errors are wrong; p-values are wrong.

### Pre-registration

Write the analysis plan before traffic is allocated. The plan specifies:

- The OEC and guardrails.
- The exact statistical test that will decide the experiment.
- The segmentations that count as confirmatory vs. exploratory.
- The pre-specified covariates if using CUPED or any variance-reduction technique.

Any analysis choice made after looking at the data is **exploratory**, not confirmatory. Treat exploratory findings as hypotheses for the next experiment, not as evidence for a ship decision.

### Optional-stopping bias

Frequentist p-values assume you peek once at the end. Peeking-and-stopping inflates the false positive rate dramatically (the more peeks, the worse).

Mitigations:

- **Sequential analysis** — pre-planned multiple looks with adjusted alpha (e.g., Pocock, O'Brien-Fleming spending functions).
- **Bayesian methods** — credible intervals can be examined sequentially without alpha inflation (the price is honest prior elicitation).
- **Strict no-peek** — run to pre-planned duration; check only then.

Pretending none of these are needed and "we'll just look daily" produces the worst of all worlds.

### Variance reduction (CUPED, stratification)

CUPED (Controlled-experiment Using Pre-Experiment Data; Deng, Xu, Kohavi 2013) and stratification reduce variance by adjusting for pre-experiment covariates correlated with the OEC. Result: smaller MDE for the same sample size. Pre-register the covariates; don't pick them post-hoc.

### Novelty and primacy effects

A change that looks great in week 1 (novelty: users explore the new thing) can underperform by week 6. A change that looks bad in week 1 (primacy: users disrupted by unfamiliarity) can outperform by week 6. The experiment's duration must extend past these short-run effects when they're plausible.

### Network effects and interference

When treatment users' behaviour affects control users (social products, marketplaces, communications), SUTVA (Stable Unit Treatment Value Assumption) is violated. Standard A/B tests under-estimate or over-estimate the treatment effect.

Mitigations: cluster-randomization (randomize at the network-cluster level), switchback designs (alternating treatment over time), or accept-and-document the bias direction.

## Application

### Step 1 — State the decision (5-10 minutes)

What ship decision will this experiment support? Like in `metric-definition`, be specific:

- **Decision:** "Ship the new checkout flow to 100% if OEC lifts ≥ 1% (relative) with no guardrail breach; iterate if 0-1%; roll back if negative."
- **Decision-owner:** A named role / person.
- **Decision-deadline:** When does the decision need to land?

If you can't answer these, the experiment may be premature. Run discovery or define the success bar first.

### Step 2 — Define OEC + guardrails (10-15 minutes)

Per [`metric-definition`](../metric-definition/SKILL.md):

```markdown
**OEC:** revenue per visitor (7-day attribution), defined as ...
**Guardrails:**
- 99th percentile checkout latency ≤ +50ms vs. control
- Refund rate (30-day, per customer) ≤ +0.5pp vs. control
- Abuse-signal rate (CS-flagged orders / total) ≤ +20% relative vs. control
```

Each guardrail has its tolerance and its threshold for alarm. If a guardrail breaches, the experiment is paused and investigated regardless of OEC.

### Step 3 — Power analysis (10-20 minutes)

Compute MDE given:

- **Baseline OEC value and variance** — from the last 28 days of pre-experiment data.
- **Desired statistical power** — typically 80%.
- **Significance level** — typically 5% (two-sided).
- **Expected sample size** — derived from traffic projection and the randomization unit.

Output:

```markdown
**MDE:** 1.0% relative lift in revenue per visitor.
**Power:** 80%.
**Significance:** alpha = 0.05, two-sided.
**Sample size required:** 240,000 visitors per variant.
**Traffic available:** ~340,000 visitors/week across both variants
                       (50/50 split, eligible population).
**Estimated duration:** 10 days minimum, 14 days planned for two
                        weekend cycles + novelty buffer.
```

If the MDE you can detect is larger than the effect size that would matter (e.g., MDE 2% when you only care about a 1% lift), the experiment is under-powered. Choose between: longer duration, larger split, variance-reduction (CUPED), or accepting that you may not detect the effect that matters.

### Step 4 — Specify randomization (5-10 minutes)

```markdown
**Unit of randomization:** logged-in user_id; logged-out visitors
  routed to a fall-through bucket excluded from analysis.
**Allocation:** 50/50 between control and treatment.
**Eligibility:** authenticated visitors whose locale is in {US, GB, AU}
  and who have not been exposed to the previous version of this
  experiment.
**Hash salt:** "checkout_v3_2026Q2" (unique per experiment).
**Hash function:** SipHash-2-4 over user_id || salt.
**Exposure trigger:** first visit to /checkout (cart non-empty);
  pre-trigger sessions excluded.
```

The exposure trigger matters: counting users from signup rather than from when they actually see the treatment dilutes the effect.

### Step 5 — Pre-register the analysis plan (10-15 minutes)

```markdown
**Confirmatory analysis:**
- OEC: Welch's t-test, two-sided, alpha=0.05, on revenue per visitor.
  CUPED-adjusted using prior-28-day revenue per visitor as covariate.
- Guardrails: each tested independently against its tolerance threshold.

**Pre-specified segmentations (confirmatory):**
- New vs. returning visitor.
- Mobile vs. desktop.

**Exploratory:**
- Anything not listed above. Findings will be flagged 'exploratory'
  and used only as hypotheses for the next experiment.

**SRM check:** chi-squared on observed vs. planned allocation, alpha
  = 0.001. SRM finding pauses the experiment until investigated.

**Stopping rule:** run to 14 days of post-trigger exposure; no early-
  stop look; SRM and guardrails are exceptions that pause the test.

**Adjustments:** Bonferroni correction for guardrail family; segments
  reported with confidence intervals, not p-values, to discourage
  multiple-testing inflation.
```

### Step 6 — Specify rollout / shutdown plan (5-10 minutes)

- **If OEC wins, guardrails clean:** ramp 50% → 100% over 7 days; post-launch monitoring as usual.
- **If OEC inconclusive:** decide between re-run (with better power / longer duration) and ship-anyway based on qualitative evidence.
- **If OEC loses:** roll back; post-experiment learning review.
- **If guardrail breach:** pause immediately; investigate cause; resume only if guardrail-relevant root cause is fixed.

### Step 7 — Circulate and lock

Share with the decision-owner, eng-lead, PM, and (for revenue-touching tests) finance. Lock the plan in the experimentation platform / metric registry before traffic allocation. Subsequent changes are visible in the version history.

## Examples

### Example 1 — A defensible checkout-flow A/B test (good)

```markdown
# Experiment — Checkout v3 vs. v2

**Decision supported:** ship checkout_v3 to 100% if revenue-per-visitor
≥ 1% relative lift with no guardrail breach; iterate if 0-1%; roll
back if negative.

**Decision-owner:** Checkout PM (@hadley); deadline: 2026-06-30.

**OEC:** revenue_per_visitor (per `metrics/revenue_per_visitor`),
7-day attribution window.

**Guardrails:**
- 99p checkout-API latency: ≤ +50ms.
- 30-day refund rate (per customer): ≤ +0.5pp.
- Abuse-signal rate: ≤ +20% relative.
- Customer-support ticket rate (checkout-tagged): ≤ +15% relative.

**Power analysis:**
- Baseline RPV: $4.12 (28-day rolling); variance ~$8.30^2 per visitor.
- MDE: 1.0% relative (= $0.041).
- Power: 80%; alpha: 0.05; two-sided.
- Sample required: 240K visitors per arm; CUPED reduces to 165K with
  prior-28-day RPV as covariate.
- Traffic available: ~340K/week eligible; 50/50 split.
- Duration: 14 days planned (covers 2 weekend cycles + novelty buffer).

**Randomization:**
- Unit: logged-in user_id (anonymous routed to fall-through bucket).
- Split: 50/50.
- Eligibility: locale in {US, GB, AU}; not exposed to checkout_v3_alpha.
- Hash salt: "checkout_v3_2026Q2".
- Exposure trigger: first GET /checkout with non-empty cart.

**Pre-registered analysis:**
- Confirmatory: Welch's t-test on CUPED-adjusted RPV; segments by
  new-vs-returning and mobile-vs-desktop with reported CIs (no
  p-values for segments to discourage cherry-picking).
- Exploratory: anything not listed.
- SRM check: chi-squared, alpha=0.001, daily automated.
- Stopping: 14 days post-trigger; no early stop; SRM + guardrail
  breach pause the test.

**Rollout plan:**
- Win + clean: 50% → 100% over 7 days.
- Inconclusive: 1-week extension if MDE-margin is < 0.3pp; otherwise
  ship-anyway decision goes to PM with qualitative + variance evidence.
- Lose: rollback.
- Breach: pause + investigate.

**Risks documented:**
- SUTVA likely holds: checkout is per-user, no network effects.
- Novelty: users may engage more with v3 in week 1 — that's why 14 days.
- Returning-customer effect: the 7-day attribution may understate
  longer-term shifts; we'll re-check at 30 days post-ramp.
```

What makes this good: the decision and decision-owner are explicit; OEC and guardrails are independent and specified; MDE is computed, not declared; SRM check is automated; the analysis is pre-registered; rollout / failure paths are named.

### Example 2 — Failure mode (bad)

```markdown
# Experiment — Checkout improvements

Running an A/B test on the new checkout flow. We'll measure conversion
and see what happens. Going to monitor daily and call it when we see
something significant.
```

Failures: no OEC definition; no guardrails; no power analysis (so the experiment will be under-powered for any plausible effect size); randomization unit unstated; optional-stopping ("call it when we see something significant"); no pre-registration; no rollout / failure plan. A "significant" reading from this design is statistical noise dressed in a story.

## Common Pitfalls

### Pitfall 1 — Under-powered tests

**Symptom:** Sample size is "what we have," not what's required to detect the effect that matters. MDE is unmentioned or computed post-hoc.

**Consequence:** Null result is read as "no effect"; the effect that mattered was below the noise floor.

**Fix:** Power analysis comes before the test. If you can't get the required sample, either accept that you can't detect what matters (and design a different study) or use variance reduction (CUPED, stratification) to lower MDE.

### Pitfall 2 — Optional stopping

**Symptom:** "We'll check daily and stop when significant."

**Consequence:** False positive rate inflates rapidly with each look; a test that should run 14 days gets called on day 4 with a noise-driven p < 0.05.

**Fix:** Either run to pre-planned duration with one look at the end, or use a sequential design with alpha-spending, or use Bayesian methods with honest priors. Pick one; document it.

### Pitfall 3 — SRM-blindness

**Symptom:** No chi-squared check for sample-ratio mismatch in the experiment plan or automated monitoring.

**Consequence:** Kohavi's empirical rate: ~6% of experiments have SRM, almost all from broken randomization. These "wins" ship and produce phantom lifts that don't replicate.

**Fix:** SRM check is mandatory, automated, alpha=0.001. Failing the check pauses the experiment; the cause is investigated before any decision.

### Pitfall 4 — Metric-shopping

**Symptom:** After seeing the data, the team picks the metric or segment that "won" and treats that as confirmatory evidence.

**Consequence:** Multiple-testing inflation; an "interesting" finding emerges by chance from any large dataset; the team ships changes that don't replicate.

**Fix:** Pre-register the analysis. Confirmatory and exploratory are different epistemic categories; exploratory findings are hypotheses for the next study, not evidence for this one.

### Pitfall 5 — Mismatched unit-of-analysis and unit-of-randomization

**Symptom:** Randomize by user, analyse by session (or vice versa).

**Consequence:** Standard errors are wrong; p-values are wrong; significance is reported where there is none.

**Fix:** Match the units. If the analysis is at the session level, randomize at the session level — or use cluster-robust standard errors that account for within-user correlation.

### Pitfall 6 — Ignoring network effects

**Symptom:** Social, marketplace, or messaging experiments use simple user-level randomization without considering interference.

**Consequence:** SUTVA fails. The treatment effect is biased by the spillover between treated and control users. The bias direction can be either way.

**Fix:** Cluster randomization at the relevant network level, or switchback design, or document the bias and the estimated direction.

### Pitfall 7 — Novelty / primacy unexamined

**Symptom:** Test runs 5 days; result is read as the long-term effect.

**Consequence:** A novelty-driven win or primacy-driven loss is treated as steady state; the post-ramp metric reverts.

**Fix:** Duration covers at least two weekend cycles, and longer when novelty / primacy effects are plausible. Post-ship monitoring for 30+ days verifies the effect persists.

### Pitfall 8 — Guardrails-as-OECs

**Symptom:** The experiment is treated as winning only if every guardrail also improves.

**Consequence:** The team rejects improvements that hold guardrails within tolerance, accumulating an unwarranted "do nothing" bias. Conversely, framing every metric as a guardrail dilutes the OEC's role.

**Fix:** OEC decides the ship; guardrails veto only if they regress *beyond their tolerance*. Document the tolerances. A guardrail held flat is a guardrail succeeded, not a guardrail to be optimised.

## References

- **Ron Kohavi, Diane Tang & Ya Xu** — *Trustworthy Online Controlled Experiments* (2020); OEC, guardrails, SRM, optional-stopping, Twyman's law. The operational backbone of this skill. See `roles/data-scientist/sources.md`.
- **Andrew Gelman & Richard McElreath** — *Bayesian Data Analysis*; *Statistical Rethinking*. Honest uncertainty; sequential analysis without alpha inflation.
- **Alex Deng, Ya Xu, Ron Kohavi & Toby Walker** — "Improving the sensitivity of online controlled experiments by utilizing pre-experiment data" (CUPED) (2013).
- **Daniel Kahneman, Olivier Sibony & Cass Sunstein** — *Noise* (2021); the noise audit underpins the variance-reduction discussion.
- **Cassie Kozyrkov** — Decision intelligence; deciding the decision before the test.
- **D. Sculley et al.** — "Hidden Technical Debt in Machine Learning Systems" (2015); experimental infrastructure as a technical-debt surface.
- **Donald Rubin** — Rubin causal model, SUTVA. Foundational; cited where network effects are at stake.
- **Related Hornero skills:**
  - [`metric-definition`](../metric-definition/SKILL.md) — the OEC and guardrails are produced through this skill.
  - [`causal-dag`](../causal-dag/SKILL.md) — when treatment plausibly affects guardrails through downstream causal paths, the DAG makes that explicit.
  - [`pre-launch-measurement-audit`](../pre-launch-measurement-audit/SKILL.md) — uses this skill for launches that include controlled experiments.
  - `roles/tester/skills/pre-release-test-pass/SKILL.md` — adjacent: the tester's release-readiness review may surface measurement risks worth raising here.
  - `roles/product-manager/skills/prd/SKILL.md` — PRD success criteria seed the OEC and decision threshold.
