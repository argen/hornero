# Task 16 — Causal claim critique: "feature X drives retention"

**Shape:** Data-scientist-led critique of an observational causal claim.

**Artifact:** A 1-page "insight" deck slide from a Growth-team analyst: "Users of feature X retain at 2× the rate of non-users; therefore, getting more users to adopt feature X will move retention significantly. Recommend roadmap investment to drive adoption." Includes a chart, a univariate split-by-cohort breakdown, and a "we'll see compounding gains" projection. No DAG, no adjustment, no E-value, no experiment proposal.

**Recommended role mix (2):**

- `data-scientist` — load-bearing; Pearl/Hernán DAG construction, backdoor-path enumeration, confounder identification (especially the *power user* confound — users who try feature X are likely already higher-retaining), E-value sensitivity, experiment-vs-observational decision.
- `product-manager` — decision-implications; if the analyst's claim is wrong, what does the team do instead? Does the roadmap-investment recommendation need to be paused or re-framed?

**Why not other roles:** measurement / claim artifact, no code / UI / security / marketing surface.

**What "good" looks like:**

- DS draws an explicit DAG (or names what the DAG would include): treatment (feature use) → outcome (retention), with confounders (org_quality, user_role, tenure, engagement_baseline) named. Cites Pearl or Hernán & Robins.
- DS enumerates ≥2 specific backdoor paths and proposes adjustment sets (Westreich & Greenland-style).
- DS proposes an E-value or sensitivity-analysis threshold (VanderWeele & Ding) — what would the unobserved-confounder strength need to be to overturn the claim?
- DS proposes either (a) the observational claim with adjustment + sensitivity-analysis-passes-threshold, OR (b) an A/B test design that would settle the question. Both are acceptable; the choice between them is the decision.
- PM frames the decision-implication: roadmap-investment recommendation is *not* supported by current evidence; what would need to be true to support it, and what's the cheapest path to that evidence.
- Synthesis names a single forcing decision: hold the roadmap recommendation; commission either the adjusted-analysis or the experiment.

**Anti-patterns to watch for:**

- DS approves the claim with hedging ("correlation is suggestive of causation").
- DS proposes only the experiment path, never the observational-with-adjustment option (sometimes the right answer is "you can't ethically/feasibly experiment; do the adjusted analysis properly").
- PM defers to the analyst's framing entirely (out-of-lens — PM should adjudicate the decision-implication independently).

**How to run:**

1. Place the insight slide / analysis at `evals/runs/16-causal-claim-retention/artifact.md` (the `roles/data-scientist/skills/causal-dag/SKILL.md` Example 2 has a similar failure-mode shape — useful as reference).
2. Invoke `multi-role-review` with data-scientist + product-manager.
3. Score with attention to whether Pearl or Hernán & Robins were cited by name (Dimension 1) and whether the synthesis recommended a specific next-step (Dimension 4) rather than "investigate further."
