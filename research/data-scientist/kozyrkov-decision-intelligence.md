# Cassie Kozyrkov — distilled

> "Statistics for People in a Hurry" (2018); "Making Friends with Machine Learning" (video course, 2022); "When not to do statistics" and decision intelligence framing across her writing at kozyrkov.medium.com and Google Cloud blog posts. Ex-Google Chief Decision Scientist. The sharpest contemporary voice on the decision-first discipline for data work.

## Why it matters for AI-coding

AI generates statistical analyses on demand. The discipline it lacks is Kozyrkov's "when not to do statistics" — the judgment about whether analysis is the right tool for the decision at all, and whether statistics specifically is the right kind of analysis. An AI given a dataset will model it. Kozyrkov asks first: what decision are you trying to make? what would change your mind? If the answer is "we already know what we're going to do," statistics is theatre. If the answer names a real decision threshold, statistics can be scoped to serve it. The discipline is upstream of any analytical tool — it is the question that determines whether to open the laptop.

For the methodology: the `metric-definition` skill's "Step 1 — State the decision" is Kozyrkov's discipline operationalised. The `pre-launch-measurement-audit` workflow's opening gate — "what decision does this measurement support?" — is the same. Without this upstream discipline, AI-generated analyses produce confident-looking answers to questions nobody was actually asking.

## Key concepts the role pulls from

- **Decision-first.** Choose the decision before choosing the metric. A metric without a decision it informs is a vanity number. The decision determines what kind of data, what kind of analysis, and what level of certainty is required — not the other way around. Powers `metric-definition` Step 1 and the `pre-launch-measurement-audit` decision-scoping gate.
- **The pre-mortem for analysis.** Before running any analysis, state: "the analysis will tell us X; if X is above threshold T, we do A; if below, we do B." If you can't fill in T, A, and B, you don't know what the analysis is for. AI-generated analysis skips this frame entirely; Kozyrkov makes it mandatory.
- **When not to do statistics.** Three conditions where statistics is the wrong tool: (1) you've already decided — analysis confirms, doesn't decide; (2) the data won't change because of the answer — no feedback loop; (3) the decision doesn't require calibrated uncertainty — a gut call is fine for low-stakes reversible decisions. Knowing when *not* to do statistics is as important as knowing how. Powers the role's "is statistics actually necessary here?" critique of AI-generated analyses.
- **Sampling as decision-support.** Kozyrkov distinguishes analytics (summarise what happened), statistics (infer from a sample to a population), and machine learning (make predictions for new cases). These are different tools serving different decision types. Conflating them — using a statistical test when you have the full population, using ML when you need a causal estimate — is a category error. Powers the role's tooling-choice critique: "what kind of decision is this, and what tool does that kind of decision require?"
- **The AI readiness question.** Before deploying a model, ask: "what is the worst-case outcome if the model is wrong?" If the answer is catastrophic and irreversible, the model isn't ready regardless of accuracy metrics. This is the practitioner's version of O'Neil's harm audit — simpler, faster, and applicable before any model ships. Powers the `pre-launch-measurement-audit`'s worst-case-outcome check.
- **Bias-variance as decision cost.** The bias-variance tradeoff is not a technical curiosity — it maps directly to the cost of two kinds of decision error: biased models make consistently wrong decisions; high-variance models make unpredictably wrong decisions. Which kind of error costs more is a decision question, not a modelling question.

## What to actually read (1-hour budget)

- **"Statistics for People in a Hurry" (2018), full text.** It is approximately 15 minutes to read. The clearest short statement of the decision-first discipline and when statistics is and isn't the right tool.
- **"Making Friends with Machine Learning" (2022), opening four lectures.** Kozyrkov at her best: the distinction between analytics, statistics, and ML; the readiness criteria for deploying a model; the decision-framing before any modelling begins.
- **Her Medium / Google Cloud posts on decision intelligence** (search "Kozyrkov decision intelligence") — the 10 most-cited posts are each under 10 minutes and each contain one precisely scoped argument. Read for vocabulary, not for depth.

## What to skip

- The later lectures of "Making Friends with Machine Learning" on specific ML algorithm families — useful for practitioners, but not load-bearing for the conceptual discipline the role uses.
- The Google Cloud tooling integrations in some posts — promotional context, not methodology.

## How this anchors role skills

- [`metric-definition`](../../roles/data-scientist/skills/metric-definition/SKILL.md) — the entire "Step 1 — State the decision" section is Kozyrkov's discipline. A metric that no decision author can name is a finding: archive it. The skill cites Kozyrkov explicitly in its Decision-first design section.
- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the opening gate of the audit is the decision-scoping question. If the measurement stack can't be traced to decisions that will change based on the results, the measurement is ornamental and the audit's "Hold" recommendation fires.
- [`experiment-design`](../../roles/data-scientist/skills/experiment-design/SKILL.md) — the pre-registration step ("what would change based on this experiment?") is the experimental concretisation of the decision-first discipline.

## Cross-role connection

Decision intelligence is the PM-DS overlap zone. A PM's job is to make good decisions under uncertainty; a data scientist's job is to reduce uncertainty in service of decisions. Kozyrkov names that overlap explicitly. When the methodology's `cross-functional-orchestration` skill (PM) and data-scientist role interact, the shared vocabulary is decision-first: the PM owns the decision; the data scientist scopes the analysis to serve it. Without this framing, data scientists generate analysis for its own sake and PMs make decisions without knowing what analysis would have changed them.
