# Andrew Gelman & Richard McElreath — distilled

> McElreath, *Statistical Rethinking: A Bayesian Course with Examples in R and Stan* (2nd ed., 2020). Gelman et al., *Bayesian Data Analysis* (3rd ed., 2013). Gelman's blog: statmodeling.stat.columbia.edu. The canonical bridge between the formal Bayesian framework and the working practitioner. McElreath is the accessible entry point; Gelman is the deeper reference and the ongoing critical voice.

## Why it matters for AI-coding

AI tools optimise for "statistically significant" — the NHST (null-hypothesis significance testing) vocabulary is so dominant in training data that it has become the default output mode for any AI-generated statistical analysis. Bayesian thinking forces something NHST cannot: uncertainty must remain explicit through every stage of the analysis, from prior specification to posterior interpretation. You cannot "reject the null and move on" in a Bayesian frame; you update a distribution, and that distribution's shape and width carry the epistemic state forward. When an AI reports "p = 0.03, significant," a Bayesian-informed reviewer asks: what was the prior? how wide is the posterior? is this effect size meaningful given the model assumptions? Those are questions NHST structurally suppresses and Bayesian methods structurally require.

For the methodology: the `experiment-design` skill's OEC + MDE pre-registration discipline is NHST-grounded (Kohavi), but the prior-elicitation and effect-size interpretation steps benefit from Bayesian vocabulary. The `causal-dag` skill's identification approach (Pearl) is causal, not statistical — but the estimation step once identification is achieved is often Bayesian. Gelman/McElreath is the source for the estimation side.

## Key concepts the role pulls from

- **The Bayesian update loop.** Prior → likelihood → posterior. The prior is not a nuisance to be eliminated; it is an explicit statement of what the analyst believed before seeing the data. Forcing prior specification forces the analyst to name their assumptions — something AI-generated analyses routinely skip. Powers the methodology's "what are the assumptions this analysis is making?" critique prompt.
- **Posterior predictive checks.** After fitting a model, simulate data from the posterior and compare to the actual observed data. If the model can't generate data that looks like yours, the model is wrong — not the data. Gelman calls this "posterior predictive checking." It is the Bayesian complement to the experiment-design skill's SRM check: both ask "is my model of the data-generating process consistent with what I actually observed?"
- **Multi-level (hierarchical) models.** Groups share information through a common prior. The key insight: complete pooling (treat all groups as one) and no pooling (treat each group independently) are both wrong; partial pooling through a hierarchical prior is almost always more appropriate. This is load-bearing when data is sparse per group — which is almost always true in product analytics. Powers the role's pushback on "we don't have enough data for subgroup analysis" (you can borrow strength) and "we have plenty of data" (you should still regularise).
- **Regularisation as a Bayesian tool.** Ridge regression, LASSO, and dropout are Bayesian priors in frequentist clothing. The Bayesian lens makes explicit what regularisation is doing: imposing a prior that pulls estimates toward zero (or toward some structure). AI-generated model code routinely adds regularisation without stating what prior belief it encodes; this vocabulary surfaces that choice as a modelling decision, not a hyperparameter to tune.
- **Garden of forking paths (Gelman).** The number of analyses a researcher could have run on a dataset but didn't is part of the multiple-testing problem — even if only one analysis was run, the choice of which one to run was made post-data. Gelman's critique of significance-hunting is the Bayesian complement to Kohavi's pre-registration requirement: both say "the analysis was chosen before the data arrived, or you're overstating your certainty."
- **Effect size over binary significance.** Bayesian posteriors naturally return effect-size distributions, not yes/no significance decisions. The posterior for an effect is a distribution over plausible magnitudes, conditional on the model and prior. This is more useful than a p-value for the practitioner question "should we act on this?"

## What to actually read (1-hour budget)

- **McElreath, *Statistical Rethinking*, Chapters 1-4.** The conceptual core: the Bayesian model as a learning machine, the grid-approximation intuition for posteriors, and the introduction to multiple regression in the Bayesian frame. These chapters are the best one-hour introduction to applied Bayesian thinking available.
- **McElreath, Chapter 11** (generalised linear models) and **Chapter 13** (multi-level models). These two chapters are where the everyday data-scientist practitioner lives; they cover the workhorse models in a Bayesian frame.
- **Gelman's blog archives**, specifically posts tagged "multiple comparisons" and "garden of forking paths" — Gelman is at his sharpest in short-form posts, and these posts carry the core critique of significance testing. Faster than reading BDA.

## What to skip

- *Bayesian Data Analysis* Chapters 1-3 on the first pass — BDA is a graduate-level textbook and is better as a reference after *Statistical Rethinking* has established the vocabulary.
- McElreath's Stan code blocks on the first conceptual read — the structure of the models is the point; the code is a way to run them, not the conceptual content.
- BDA's appendices on computation (Metropolis-Hastings, Gibbs) — relevant for implementation, not for the conceptual framework the role's skills use.

## How this anchors role skills

- [`experiment-design`](../../roles/data-scientist/skills/experiment-design/SKILL.md) — the prior-elicitation step (what effect size would be meaningful? what's our prior belief before running?) is Gelman/McElreath's Bayesian vocabulary applied to the design phase. The skill's MDE calculation is frequentist; the "is this MDE decision a good one?" critique is Bayesian.
- [`causal-dag`](../../roles/data-scientist/skills/causal-dag/SKILL.md) — once a causal structure is identified (Pearl's job), estimation is often Bayesian. The DAG determines what to adjust for; the Bayesian model does the adjusting.
- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the experiment-design check asks "were effect sizes estimated with appropriate uncertainty?" — a Bayesian posterior is the right answer; a p-value is not.

## Cross-role connection

Bayesian thinking translates directly to evidence-weighing under uncertainty in PM decision-making — the PM's job is to update their belief about what will work as evidence arrives, exactly the Bayesian update loop. When the methodology's `multi-role-review` includes a PM and a data-scientist, the PM's "what does the evidence say?" and the data-scientist's "what does the posterior say?" are the same question in different vocabularies. The Gelman/McElreath vocabulary makes them interoperable. O'Neil's harm-audit and Gelman's garden-of-forking-paths critique are also in dialogue: both are about the gap between the analysis that was run and the analysis that would have been honest.
