# Research — data-scientist

Distilled notes from the data-scientist role's anchor bibliography. See [`../../roles/data-scientist/sources.md`](../../roles/data-scientist/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the data-scientist role on a non-trivial task and you've never read these, here's the priority order:

1. **[`kohavi-trustworthy-experiments.md`](kohavi-trustworthy-experiments.md)** — the canonical experimentation book; OEC + guardrails + MDE + SRM + Twyman; powers `experiment-design` and `pre-launch-measurement-audit`.
2. **[`pearl-book-of-why.md`](pearl-book-of-why.md)** — the Ladder of Causation, DAGs, do-calculus, backdoor / front-door criteria; powers `causal-dag` and the methodology's cross-role association-vs-intervention critique.
3. **Hernán & Robins — Causal Inference: What If** (note pending) — the rigorous follow-on to Pearl; sensitivity analysis (E-values), confounding adjustment.
4. **Kahneman — Thinking, Fast and Slow** (note pending) — the cognitive-bias canon every data scientist needs; Twyman's law has a sibling in System-1 thinking.
5. **Sculley et al. — Hidden Technical Debt in Machine Learning Systems** (note pending) — the NeurIPS paper that named the ML-systems problem.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| Ron Kohavi, Diane Tang, Ya Xu | ✓ [`kohavi-trustworthy-experiments.md`](kohavi-trustworthy-experiments.md) | `experiment-design`, `pre-launch-measurement-audit`, `metric-definition` |
| Judea Pearl | ✓ [`pearl-book-of-why.md`](pearl-book-of-why.md) | `causal-dag`, `metric-definition` |
| Miguel Hernán & James Robins | — | `causal-dag`, observational-claim critique |
| Hadley Wickham | — | data-tidiness in `metric-definition` |
| Daniel Kahneman | — | bias awareness across the role |
| D. Sculley et al. | — | ML-systems debt; model-evaluation framing |
| Westreich & Greenland | — | confounding-adjustment formal critique |
| VanderWeele & Ding | — | E-values / sensitivity analysis in `causal-dag` |
| Alex Deng et al. | — | CUPED variance reduction in `experiment-design` |
| Charles Goodhart / Donald Campbell | — | metric-gaming pitfalls in `metric-definition` |

## See also

- `../../roles/data-scientist/sources.md` — the full bibliography these notes summarise.
- `../../roles/data-scientist/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
