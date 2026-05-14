# Task 19 — Experiment design critique: pricing A/B test

**Shape:** Data-scientist-led experiment-design critique pre-allocation.

**Artifact:** A 1-page experiment design proposal: "A/B test new pricing page — variant B shows annual pricing first; control shows monthly first. Hypothesis: variant B will increase ARR/visitor. Sample size: 2 weeks of traffic. Stopping rule: when significant at p < 0.05. Owner: Growth team." Seeded issues: (1) no OEC vs guardrails split (ARR is OEC, but no counter-metrics); (2) no MDE / power analysis — "2 weeks" is the allocation, not the calculation; (3) no SRM-check provision; (4) the stopping rule is the canonical "peeking" anti-pattern (early-stop on significance inflates false-positive rate); (5) randomisation unit not specified (per-visit? per-session? per-user-bot-filtered?).

**Recommended role mix (3):**

- `data-scientist` — load-bearing; Kohavi pre-allocation discipline, OEC + guardrails, MDE + power, randomisation unit, SRM check, stopping-rule pre-commitment, exploratory-vs-confirmatory split.
- `product-manager` — does ARR/visitor actually reflect the customer-job outcome? Is "annual pricing first" expected to increase ARR via *upgrades* or via *purchase-conversion*? Different mechanisms = different experiment.
- `software-engineer` — instrumentation feasibility; is the assignment-to-variant deterministic and idempotent? Will the variant-shown event fire before the page load completes (or only on certain conditions)?

**Why not other roles:** pricing-page A/B test, no security / tester / marketing surface that load-bears at the design stage (marketing review of the *content* of the variants is a separate, prior question).

**What "good" looks like:**

- DS catches all 5 seeded issues and cites Kohavi/Tang/Xu by name for ≥3 of them (the OEC-guardrails split, the early-stopping issue, and SRM).
- DS proposes a specific OEC (ARR/visitor with attribution window) and ≥2 guardrails (free-trial-start rate as a behavioural counter-metric, refund rate as a downstream guardrail).
- DS computes (or names how to compute) the MDE — "what effect size is worth detecting" — and the implied sample size, distinguishing it from the allocation-window.
- DS proposes a specific SRM check (chi-square on observed allocation vs intended; threshold to invalidate the run).
- PM connects the experiment to the customer-job hypothesis — is annual-first a presentation experiment or a value-proposition experiment?
- Engineer adjudicates instrumentation correctness honestly — if the variant fires on render but the conversion fires on form-submit, there's a session-binding question.

**Anti-patterns to watch for:**

- DS approves the "p < 0.05" stopping rule (the most-common error in industry experiment design; flagging it is the test).
- DS doesn't enumerate counter-metrics (Goodhart pattern: optimise ARR, break trial-start, no one notices because trial-start isn't being measured).
- PM treats this as a measurement-only question (out-of-lens — the mechanism question is a PM concern).

**How to run:**

1. Place the experiment design at `evals/runs/19-experiment-design-pricing/artifact.md` (the `roles/data-scientist/skills/experiment-design/SKILL.md` Examples section has a complete template).
2. Invoke `multi-role-review` with data-scientist + product-manager + software-engineer.
3. Score with attention to whether Kohavi was cited by name (Dimension 1) on the early-stopping issue specifically — that's the canonical case in *Trustworthy Online Controlled Experiments*.
