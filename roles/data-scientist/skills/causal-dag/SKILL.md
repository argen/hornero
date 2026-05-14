---
name: causal-dag
description: Use when a team is making a causal claim from observational data — to draw the directed acyclic graph of assumed causes, surface confounders and backdoor paths, and decide which adjustment strategy (or experiment) the claim actually needs.
intent: |
  Produces or critiques a causal DAG that makes the team's assumed
  causal structure explicit. Resists three failure modes: "the data
  says X causes Y" without a model (asserted causation from
  correlation); over-adjustment (controlling for variables that block
  the very effect being estimated); under-adjustment (missing
  confounders that turn correlation into spurious causation). Forces
  the team to choose: experiment, adjust under a stated model, or
  weaken the claim from causal to descriptive.
type: component
theme: causal-rigor
best_for:
  - An observational study claiming X causes Y
  - An A/B test result generalised to a different population
  - A regression where the team is choosing which controls to include
  - A "we shipped X and the metric moved" post-hoc analysis
scenarios:
  - "Did the redesign increase retention, or did the segment we redesigned for already retain better?"
  - "Did the email campaign drive purchases, or did we email the most likely buyers?"
  - "Does training intensity cause performance gains, or do high-performers train more?"
  - "Does using feature X reduce churn, or does the kind of user who uses X churn less anyway?"
estimated_time: 30-60 minutes (DAG); 15-30 minutes (critique of an existing claim)
---

# Causal DAG

> v0 draft. Grounded in Judea Pearl's *Causality* (2000) and *The Book of Why* (2018, with Dana Mackenzie) for the formalism, Donald Rubin's potential-outcomes framework as the companion lens, Miguel Hernán & James Robins' *Causal Inference: What If* (2020) for working epidemiological practice, and Cassie Kozyrkov on when *not* to claim causation.

## Purpose

Draw a directed acyclic graph (DAG) that:

1. **Names the variables** the team believes are causally linked — including the unobserved ones.
2. **Names the directions** of causation between them — what the team is assuming.
3. **Surfaces confounders** — variables that cause both the proposed cause and the proposed effect.
4. **Surfaces backdoor paths** — non-causal routes through which correlation could flow.
5. **Identifies the adjustment set** that closes the backdoor without opening new bias (over-adjustment).
6. **Forces the team to choose** between three honest answers:
   - **Experiment** — randomise and measure the average treatment effect directly.
   - **Adjust under the DAG** — accept the DAG's assumptions, compute the adjusted estimate.
   - **Weaken the claim** — drop "X causes Y" for "X is associated with Y."

A causal claim without a DAG is correlation in costume. The DAG forces the costume off.

## Key Concepts

### The ladder of causation (Pearl)

Pearl & Mackenzie's three rungs:

1. **Association** — "what is?" Observing P(Y | X). Correlation.
2. **Intervention** — "what if I do X?" P(Y | do(X)). Experiments live here; so do well-specified counterfactual analyses.
3. **Counterfactuals** — "what would have happened?" Reasoning about specific units under alternative histories.

Most teams confuse rungs 1 and 2. A correlational study at rung 1 cannot answer a rung 2 question without additional assumptions — and those assumptions need to be visible.

### DAG basics

A **directed acyclic graph** has:

- **Nodes** — variables (observed or unobserved).
- **Directed edges** — causal direction (`X → Y` means "X causes Y").
- **No cycles** — at the granularity drawn, no variable causes itself.

A **path** is any sequence of edges (regardless of direction). A path is **causal** if all edges point forward from cause to effect; **non-causal** otherwise.

### Confounders, mediators, colliders

Three structures that determine when adjustment helps vs. hurts:

- **Confounder** — common cause of `X` and `Y`. `X ← Z → Y`. Adjusting for `Z` **closes** the spurious path.
- **Mediator** — `X → M → Y`. Adjusting for `M` **closes** the causal effect of `X` on `Y` through `M`; the residual estimate is the direct effect only.
- **Collider** — common effect of `X` and `Y`. `X → C ← Y`. Adjusting for `C` **opens** a non-causal path, introducing collider-conditioning bias.

The single most common applied-stats error: adjusting for a collider, believing it's a confounder.

### Backdoor paths and the backdoor criterion

A **backdoor path** from `X` to `Y` is any path that starts with an arrow *into* `X`. These carry non-causal correlation between `X` and `Y`.

Pearl's **backdoor criterion**: a set of variables `Z` is sufficient to estimate the causal effect of `X` on `Y` by adjustment iff `Z` blocks every backdoor path from `X` to `Y` *and* contains no descendants of `X`.

In practice: if you can identify a backdoor-blocking set among observed variables, you can compute the causal effect from observational data (under the DAG's assumptions). If you can't, you need an experiment or you need to weaken the claim.

### Over-adjustment and the "table 2 fallacy"

Including every variable that improves model fit is wrong. Adjusting for a mediator blocks the very effect you wanted to estimate. Adjusting for a collider opens bias. Reporting individual coefficients from a single multivariable regression as if each were a causal estimate of its variable is the "table 2 fallacy" (Westreich & Greenland, 2013).

Practical: every covariate's inclusion needs a DAG-justifying reason.

### Simpson's paradox

The direction of an association can reverse when a confounder is adjusted for vs. not. The classic Berkeley admissions example: men appeared favoured in aggregate, but within each department, women had equal or higher admission rates. Department was the confounder; aggregating masked it.

Simpson's isn't a paradox — it's a DAG warning. The right answer depends on which DAG is true.

### Unobserved confounders and sensitivity

Real-world DAGs almost always have unobserved nodes. Two approaches:

1. **Sensitivity analysis** — quantify how strong an unobserved confounder would need to be to overturn the conclusion (E-value; VanderWeele & Ding 2017).
2. **Instrumental variables, RDD, DiD** — quasi-experimental methods that exploit specific structural features (an instrument, a discontinuity, a parallel-trends assumption) to identify causal effects under their own DAG-encoded assumptions.

Either way: name the assumption, don't ignore it.

### Selection bias as collider conditioning

Selection bias — the sample you have is not the sample you'd want — almost always shows up as collider conditioning in a DAG. "We see only people who clicked the ad and converted" conditions on a collider downstream of multiple causes.

## Application

### Step 1 — State the causal claim in one sentence (5 minutes)

"`X` causes `Y`, on average, in population `P`, via mechanism `M` (if hypothesised)."

Examples:

- *"Using feature F increases 30-day retention, on average, among new B2B signups, via increased early-week activation."*
- *"Sending the discount email caused the purchase, on average, among the recipient cohort, via a price-anchoring mechanism."*
- *"Training intensity causes performance gains, on average, among the runners studied."*

If the claim is associational ("X is correlated with Y"), this skill is not needed — but make sure the team knows that's the claim.

### Step 2 — List the variables (10 minutes)

For the proposed cause `X` and the proposed effect `Y`, brainstorm:

- **Plausible common causes** — what could affect both `X` and `Y`?
- **Plausible mediators** — what mechanism does `X` work through?
- **Plausible effects of `X` and `Y`** — downstream variables that might be on the causal path or might be colliders.
- **Selection variables** — what determined who is in the data?

Include unobserved variables explicitly; mark them with `U_` prefix or a dashed circle in the diagram.

### Step 3 — Draw the DAG (10-20 minutes)

Use any DAG tool (DAGitty, Lucidchart, or ASCII). Each edge represents a non-trivial direct causal effect; absences of edges are claims, too.

Example (ASCII):

```
              U_org_quality
              /          \
             v            v
   user_role -> feature_use -> activation_week1 -> retention_30d
       ^             |
       |             v
   tenure ---------> NPS_at_3m
```

Each edge gets a brief justification ("feature_use → activation_week1: documented in product analytics"). If you can't justify an edge, weaken to dotted or remove.

### Step 4 — Enumerate backdoor paths from X to Y (10 minutes)

Find every path from `X` to `Y` that starts with an arrow *into* `X`. These are the spurious paths your analysis must close.

For each backdoor path, identify the variable(s) you could condition on to block it (without conditioning on a descendant of `X` or opening a collider).

If a backdoor path includes only unobserved variables, you cannot close it by adjustment. The DAG has told you: experiment, or weaken the claim.

### Step 5 — Identify the adjustment set (5-10 minutes)

The minimal **valid adjustment set** is the smallest set of observed variables that blocks every backdoor path without:

- Including a mediator (which would block the causal effect).
- Including a collider or its descendant (which would open new paths).

DAG tools (DAGitty) compute this automatically given the DAG. By hand, it requires care.

### Step 6 — Choose the honest path forward (10-15 minutes)

Three options:

**A. Run an experiment.** Randomise `X`; the DAG simplifies (all backdoor paths are severed by randomization). This is rung 2 directly.

**B. Adjust under the DAG.** Use the adjustment set, name the unobserved confounders, run a sensitivity analysis (E-value: how strong would an unobserved confounder need to be to overturn the conclusion?).

**C. Weaken the claim.** "X is associated with Y, with a stated effect size and confidence interval; we are not making a causal claim because [the backdoor isn't blockable / the assumptions are too strong / the unobserved confounders are too plausible]."

The orchestrator's output is the DAG, the adjustment set if any, the chosen path, and the analysis (or its plan) implied by the choice.

## Examples

### Example 1 — Feature → retention (good)

**Claim:** Using feature F increases 30-day retention, on average, among new B2B signups.

**Variables:**
- `feature_use` (proposed cause `X`).
- `retention_30d` (proposed effect `Y`).
- `org_quality` (`U_`, unobserved) — fit between the product and the customer's actual job.
- `user_role` — admin vs. end-user; admins are more likely to use F and to retain.
- `tenure` — how long the org has been a customer; older orgs use more features and retain better.
- `activation_week1` (mediator) — completing onboarding milestones.
- `NPS_at_3m` (downstream, collider risk if selected on).

**DAG:**

```
   U_org_quality
       |      \
       v       v
   user_role -> feature_use -> activation_week1 -> retention_30d
       |  ^             ^
       |  |             |
       |  tenure --------+
       +-------------------------> retention_30d
```

(`user_role → retention_30d` is the direct edge that opens backdoor path 3 below: admins are intrinsically more retentive regardless of feature use.)

**Backdoor paths from feature_use to retention_30d:**

1. `feature_use ← user_role ← U_org_quality → ... → retention_30d` — partially observed (user_role observed; U_org_quality not).
2. `feature_use ← tenure → retention_30d` — observable; adjust for `tenure`.
3. `feature_use ← user_role → retention_30d` — adjust for `user_role`.

**Adjustment set:** {tenure, user_role}. The unobserved `U_org_quality` remains uncloseable; sensitivity analysis required.

**Chosen path:** observational analysis with adjustment for {tenure, user_role} + E-value sensitivity for U_org_quality. If E-value > 2.5 (treatment-confounder and outcome-confounder associations would each need RR > 2.5 to overturn), report as evidence of likely causal effect. Otherwise, weaken claim to associational and propose an experiment (randomise feature exposure to a new-signup cohort).

What's good: confounders enumerated; mediator identified and explicitly excluded from adjustment; unobserved confounder named; sensitivity threshold pre-specified; experimental alternative kept on the table.

### Example 2 — Email campaign → purchase (failure mode caught)

**Claim:** Sending the discount email caused the purchase, on average, among recipients.

**Variables:**
- `email_sent` (proposed cause `X`).
- `purchase` (proposed effect `Y`).
- `predicted_buyer_score` — the targeting model's score that decided who got the email.

**DAG:**

```
   predicted_buyer_score -> email_sent
              |
              v
            purchase
```

**Backdoor:** `email_sent ← predicted_buyer_score → purchase`. The model targeted likely buyers; correlation between email and purchase reflects the model's selection, not the email's effect.

**Adjustment set:** {predicted_buyer_score} — but if the score is opaque or its components are unmeasured, the adjustment is unreliable.

**Chosen path:** the observational analysis is fundamentally compromised. To make a causal claim, the team needs an experiment — randomly hold out a portion of the high-score audience, send to the rest, compare. The cost of the holdout is the price of a causal claim.

What's good: the DAG made the targeting-confounder visible immediately; the team avoided shipping a "the email caused +15% lift" claim that was actually a "we successfully identified buyers" measurement.

### Example 3 — Failure mode (bad)

```markdown
We shipped feature F to the segment that asked for it. Retention in
that segment is 40% higher than the rest of the user base. Feature F
increases retention.
```

Failures: the cause and effect are correlated, but the segment that *asked* for the feature is the same one selected on a confounder ("vocal-power-user-ness"). No DAG drawn; no adjustment attempted; the causal claim is asserted from observational data with a confounder that's literally in the targeting criterion. The 40% lift is almost entirely selection, not treatment.

## Common Pitfalls

### Pitfall 1 — Correlation asserted as causation

**Symptom:** "We launched X and the metric moved. X caused the lift."

**Consequence:** Strategy built on a phantom effect. Resources allocated to scale "what worked"; the underlying driver was something else.

**Fix:** Either an experiment exists, or a DAG with backdoor analysis exists, or the claim is weakened to associational.

### Pitfall 2 — Adjusting for a mediator

**Symptom:** Regression includes "all the relevant variables," several of which are on the causal path from X to Y.

**Consequence:** The total effect of X on Y is blocked; the residual is only the *direct* effect (X → Y bypassing the mediator). The team reports this as "after controlling for everything, X has no effect" — which is true only of the direct path.

**Fix:** Each adjustment variable needs a DAG-justifying reason. Mediators are blocked deliberately, not as a side effect.

### Pitfall 3 — Adjusting for a collider

**Symptom:** Inclusion of a "kitchen sink" set of controls; the analysis includes downstream variables that are common effects of X and Y.

**Consequence:** Collider-conditioning bias opens a non-causal path. The estimate is biased in either direction.

**Fix:** Adjustment sets are computed from the DAG, not heuristically. DAGitty or manual analysis confirms each variable is a confounder, not a collider or descendant.

### Pitfall 4 — Ignoring unobserved confounders

**Symptom:** "We adjusted for everything we have." No sensitivity analysis.

**Consequence:** A plausible unmeasured confounder could overturn the conclusion entirely; the team has no way to assess robustness.

**Fix:** Run a sensitivity analysis (E-value, Rosenbaum bounds). Report what an unobserved confounder would need to look like to negate the finding. If that bar is low, the finding is fragile.

### Pitfall 5 — Treating the DAG as the answer instead of the question

**Symptom:** A DAG is drawn but its edges are not justified; assumptions are not documented; the team treats the DAG as if it were observed structure.

**Consequence:** Confident estimates under an unstated assumption set. The estimate's truth depends on the DAG's truth; the latter is invisible.

**Fix:** Every edge gets a justification. Every absent edge is also an assumption — justify the absence when it's non-obvious. The DAG is a model, not a fact.

### Pitfall 6 — The table 2 fallacy

**Symptom:** A regression's coefficients are all interpreted as causal estimates of their respective variables.

**Consequence:** Multiple causal claims supported by one regression that was designed to estimate only one. Most of those side-claims are biased.

**Fix:** One regression, one causal estimate. Other coefficients are statistical artefacts; don't read them causally.

### Pitfall 7 — Selection bias hidden in eligibility

**Symptom:** The sample is conditioned on a variable that's a collider in the DAG (e.g., "users who completed onboarding").

**Consequence:** The conditional analysis answers a different question — "among those who completed, ..." — and the team conflates it with the unconditional causal effect.

**Fix:** Selection variables go in the DAG as conditioned-on nodes. Their effect on identifiability is examined; if they're colliders, the analysis is restated for the conditional population, not the general one.

### Pitfall 8 — Simpson's reversal accepted, not examined

**Symptom:** Two analyses (aggregate vs. by-segment) give opposite directions; the team picks one and ships.

**Consequence:** The team has chosen between two plausible causal stories without examining which DAG is correct.

**Fix:** Simpson's reversal is a DAG signal. The right answer depends on whether the segmenting variable is a confounder, a mediator, or a collider — examine the DAG and decide deliberately.

## References

- **Judea Pearl** — *Causality: Models, Reasoning, and Inference* (2000, rev. 2009); the formalism. *The Book of Why* (2018, with Dana Mackenzie); the ladder of causation. See `roles/data-scientist/sources.md`.
- **Donald Rubin** — potential outcomes / Rubin causal model. Companion framework to Pearl's; same conclusions, different notation.
- **Miguel Hernán & James Robins** — *Causal Inference: What If* (2020). Working epidemiological practice; the practitioner's reference.
- **Daniel Westreich & Sander Greenland** — "The Table 2 Fallacy: Presenting and Interpreting Confounder and Modifier Coefficients" (2013).
- **Tyler VanderWeele & Peng Ding** — "Sensitivity analysis in observational research: introducing the E-value" (2017).
- **Cassie Kozyrkov** — Decision intelligence; when *not* to claim causation.
- **Andrew Gelman & Richard McElreath** — *Statistical Rethinking* (2020). Bayesian causal modelling chapters.
- **Related Hornero skills:**
  - [`metric-definition`](../metric-definition/SKILL.md) — the proposed cause and effect are metrics; their definitions must hold up under the DAG.
  - [`experiment-design`](../experiment-design/SKILL.md) — when the DAG analysis recommends "experiment," this is where the experiment goes.
  - [`pre-launch-measurement-audit`](../pre-launch-measurement-audit/SKILL.md) — the audit checks whether claimed launch effects are supported by DAG-validated causal analysis or by correlational shortcuts.
  - `roles/product-manager/skills/prd/SKILL.md` — PRD success criteria may imply causal claims; the DAG holds them honest.
