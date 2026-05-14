# Research — data-scientist

Distilled notes from the data-scientist role's anchor bibliography. See [`../../roles/data-scientist/sources.md`](../../roles/data-scientist/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the data-scientist role on a non-trivial task and you've never read these, here's the priority order:

1. **[`kohavi-trustworthy-experiments.md`](kohavi-trustworthy-experiments.md)** — the canonical experimentation book; OEC + guardrails + MDE + SRM + Twyman; powers `experiment-design` and `pre-launch-measurement-audit`.
2. **[`pearl-book-of-why.md`](pearl-book-of-why.md)** — the Ladder of Causation, DAGs, do-calculus, backdoor / front-door criteria; powers `causal-dag` and the methodology's cross-role association-vs-intervention critique.
3. **[`kahneman-fast-and-slow.md`](kahneman-fast-and-slow.md)** — cognitive bias and decision noise; anchoring, availability, planning fallacy, regression to the mean, and Noise; powers `pre-launch-measurement-audit`'s bias-awareness and label-quality checks.
4. **[`sculley-ml-tech-debt.md`](sculley-ml-tech-debt.md)** — the NeurIPS paper that named the ML-systems debt categories; glue code, pipeline jungles, feedback loops, monitoring debt; powers `pre-launch-measurement-audit` and `causal-dag` applied to ML systems.
5. **[`kozyrkov-decision-intelligence.md`](kozyrkov-decision-intelligence.md)** — the decision-first discipline; when not to do statistics; decision before metric; powers `metric-definition` Step 1 and the audit's decision-scoping gate.
6. **[`gelman-mcelreath-statistical-rethinking.md`](gelman-mcelreath-statistical-rethinking.md)** — Bayesian methods for working practitioners; posterior predictive checks, multilevel models, garden of forking paths; powers `experiment-design` prior-elicitation and estimation steps.
7. **[`oneil-weapons-of-math-destruction.md`](oneil-weapons-of-math-destruction.md)** — the WMD three-part harm test (opaque + scaled + consequential); proxy variables, feedback loops, and the harm-audit discipline; powers `pre-launch-measurement-audit`'s harm-audit gate.
8. **[`wickham-tidy-data.md`](wickham-tidy-data.md)** — tidy data as a shape contract; grammar of data manipulation; pipeline-first style; powers `metric-definition`'s unit-of-analysis discipline.
9. **[`karpathy-deep-learning-practice.md`](karpathy-deep-learning-practice.md)** — training-loop verification; overfit-a-batch; visualise everything; calibration; powers the ML-model readiness gate in `pre-launch-measurement-audit`.
10. **[`mckinney-pandas-arrow.md`](mckinney-pandas-arrow.md)** — pandas data model; Arrow as interchange; when to use pandas vs. polars vs. DuckDB; powers the pipeline-readiness and tooling-appropriateness checks.

Note: **Hernán & Robins — *Causal Inference: What If*** (the rigorous observational follow-on to Pearl; sensitivity analysis and E-values) is referenced in `causal-dag` and listed in `sources.md` as a "see also." It is not a main anchor and does not have a note in this batch; see Pearl's note for the citation context.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| Ron Kohavi, Diane Tang, Ya Xu | ✓ [`kohavi-trustworthy-experiments.md`](kohavi-trustworthy-experiments.md) | `experiment-design`, `pre-launch-measurement-audit`, `metric-definition` |
| Judea Pearl | ✓ [`pearl-book-of-why.md`](pearl-book-of-why.md) | `causal-dag`, `metric-definition` |
| Hadley Wickham | ✓ [`wickham-tidy-data.md`](wickham-tidy-data.md) | `metric-definition`, `pre-launch-measurement-audit` |
| Andrew Gelman & Richard McElreath | ✓ [`gelman-mcelreath-statistical-rethinking.md`](gelman-mcelreath-statistical-rethinking.md) | `experiment-design`, `causal-dag`, `pre-launch-measurement-audit` |
| Cassie Kozyrkov | ✓ [`kozyrkov-decision-intelligence.md`](kozyrkov-decision-intelligence.md) | `metric-definition`, `pre-launch-measurement-audit`, `experiment-design` |
| D. Sculley et al. | ✓ [`sculley-ml-tech-debt.md`](sculley-ml-tech-debt.md) | `causal-dag`, `pre-launch-measurement-audit` |
| Daniel Kahneman | ✓ [`kahneman-fast-and-slow.md`](kahneman-fast-and-slow.md) | `pre-launch-measurement-audit`, `metric-definition`, `experiment-design` |
| Cathy O'Neil | ✓ [`oneil-weapons-of-math-destruction.md`](oneil-weapons-of-math-destruction.md) | `pre-launch-measurement-audit`, `metric-definition` |
| Andrej Karpathy | ✓ [`karpathy-deep-learning-practice.md`](karpathy-deep-learning-practice.md) | `pre-launch-measurement-audit`, `experiment-design` |
| Wes McKinney | ✓ [`mckinney-pandas-arrow.md`](mckinney-pandas-arrow.md) | `metric-definition`, `pre-launch-measurement-audit` |
| Miguel Hernán & James Robins | — (see also; not a main anchor) | `causal-dag`, observational-claim critique |
| Westreich & Greenland | — (see also) | confounding-adjustment formal critique |
| VanderWeele & Ding | — (see also) | E-values / sensitivity analysis in `causal-dag` |
| Alex Deng et al. | — (see also) | CUPED variance reduction in `experiment-design` |
| Charles Goodhart / Donald Campbell | — (see also) | metric-gaming pitfalls in `metric-definition` |

## See also

- `../../roles/data-scientist/sources.md` — the full bibliography these notes summarise.
- `../../roles/data-scientist/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
