# Judea Pearl — distilled

> *The Book of Why: The New Science of Cause and Effect* (with Dana Mackenzie, Basic Books, 2018) and *Causality: Models, Reasoning and Inference* (Cambridge, 2nd ed. 2009). The founding work of structural causal modelling.

## Why it matters for AI-coding

AI-driven analytics defaults to *predictive* claims — "X is correlated with Y, model fits, ship." Pearl's framework is the line between correlation and causation, and it is exactly the line AI tools blur most aggressively. Every "we found that users who do X retain better" claim from an AI-generated dashboard is a causal claim dressed as correlation; the `causal-dag` skill exists to make the underlying assumptions explicit and testable. Without Pearl's vocabulary — DAGs, do-calculus, the ladder of causation — there is no principled way to push back on an AI that has learned to sound causal while reasoning associationally.

## Key concepts the role pulls from

- **Ladder of Causation.** Three rungs: Association ("what is?" — P(Y|X)), Intervention ("what if I do X?" — P(Y|do(X))), Counterfactuals ("what would have happened?"). Most "data-driven" product claims live on rung 1 and are *spoken* as rung 2 or 3. The ladder is the single sharpest diagnostic for detecting that category error. Powers the `causal-dag` critique of any observational study promoted to a causal claim.
- **DAGs as causal models.** Directed acyclic graphs are the visual artifact encoding causal assumptions: nodes are variables (observed and unobserved), directed edges are causal directions, and absent edges are also claims. The structure of the graph — not the data — determines what can be estimated and how. DAGs are the load-bearing artifact in `causal-dag`; every confound, mediator, and collider diagnosis flows from the graph.
- **Do-calculus.** The formal procedure for moving from observational distributions P(Y|X) to interventional distributions P(Y|do(X)). Most practitioners never apply the full calculus directly, but the underlying intuition — that "conditioning on X" and "intervening on X" are structurally different operations — is what powers backdoor adjustment, front-door adjustment, and instrumental-variable reasoning. The citable foundation behind every adjustment strategy in `causal-dag`.
- **Backdoor criterion.** The practical identification rule: a set of variables Z is sufficient for adjustment iff Z blocks every backdoor path from X to Y and contains no descendants of X. This is the working-practitioner procedure the `causal-dag` application steps operationalise. Knowing the criterion is knowing what to adjust for — and knowing what not to.
- **Front-door criterion.** The identification strategy when backdoor adjustment is unavailable — typically because the direct confounder is unobserved but a fully-mediated path exists. Less common than backdoor adjustment, but structurally important: it demonstrates that causal identification does not require randomisation and is not always blocked by unmeasured confounders.
- **Causal vs. statistical.** Pearl's central claim: the distinction between association and causation is not a matter of degree or sample size — it is a categorical difference that standard statistical machinery (regression, correlation, even Bayesian inference) cannot bridge without additional causal assumptions made explicit. This is the most under-taught idea in undergrad statistics, and it is the gap AI-generated analyses exploit by omission.

## What to actually read (1-hour budget)

- **The Book of Why, Chapters 1, 4, 7** — the Ladder of Causation (Ch. 1), confounding and the do-operator (Ch. 4), paradoxes including Simpson's and the collider (Ch. 7). Approximately 100 pages. This is enough for nearly all `causal-dag` work.
- **Skim The Book of Why, Chapter 9** (mediation and direct vs. indirect effects) — relevant when the question is not just "does X cause Y" but "through what mechanism."
- The technical depth lives in *Causality* (2009); the working-statistician framing is in *The Book of Why*, and that is enough for the role's day-to-day causal critique work.

## What to skip

- *The Book of Why*'s long historical sections on Fisher, Pearson, and Wright — entertaining intellectual history, but not load-bearing for using the framework. Skim for context; do not read for procedure.
- *Causality*, Chapter 11 (philosophical foundations of causal reasoning) — relevant only if you are already comfortable with the rest of the book. The working practitioner does not need it.
- *Causality*'s measure-theoretic appendices unless you are working on the formal theory, not applying it.

## How this anchors role skills

- [`causal-dag`](../../roles/data-scientist/skills/causal-dag/SKILL.md) — load-bearing. DAGs are the skill's primary artifact; the backdoor criterion is its identification procedure; do-calculus is the citable framework beneath every adjustment strategy. Pearl is the source the skill's References section cites first.
- [`metric-definition`](../../roles/data-scientist/skills/metric-definition/SKILL.md) — Pearl's association/intervention distinction directly informs the "what causal claim is this metric implicitly making" critique. A metric definition that confounds rung-1 evidence with a rung-2 claim fails the metric-definition skill's counter-metric and gaming-surface checks.

Hernán & Robins (*Causal Inference: What If*, 2020) and VanderWeele & Ding (E-value, 2017) are the practical-application follow-ups for working with real data and unobserved confounders. Pearl is the foundation they build on.

## Cross-role connection

Pearl's Ladder of Causation is a cross-role critique frame, not only a data-science one. PMs claiming "this feature drove retention" (rung 2/3) from observational data (rung 1) is the same structural error as a marketer claiming "this campaign caused awareness lift" from a brand survey, or an engineer claiming "this refactor caused the performance improvement" from a before/after deploy comparison. The Ladder names the category error in each case. When the methodology's review workflow asks *what kind of claim is this artifact actually making*, the Ladder is the vocabulary that makes the question answerable — and the answer auditable.
