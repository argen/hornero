# D. Sculley et al. — distilled

> "Hidden Technical Debt in Machine Learning Systems" (Sculley, Holt, Golovin, Davydov, Phillips, Ebner, Chaudhary, Young, Crespo, Dennison — Google; NeurIPS 2015). The paper that named the ML-systems problem: the code that trains a model is typically a small fraction of the system surface; the majority is hidden infrastructure, data dependencies, configuration, and monitoring — each a debt category.

## Why it matters for AI-coding

AI/ML projects accumulate hidden debt the moment they exit the notebook. Sculley et al. named the debt categories before the field treated them as inevitable: glue code, pipeline jungles, dead experimental codepaths, undeclared consumers, configuration debt, monitoring debt, feedback loops. AI-generated ML code exacerbates every category: it generates the model code and ignores the surrounding system; it produces pipeline configurations without version discipline; it creates features without auditing their dependencies; it adds monitoring as an afterthought. Sculley's taxonomy is the checklist for what an AI-generated ML system has probably not handled — and what a responsible data scientist must audit before calling the work done.

The paper predates much of the current MLOps vocabulary but anticipated it entirely. Every MLOps framework (MLflow, Vertex AI Pipelines, Kubeflow, SageMaker Pipelines) is building the same infrastructure Sculley's debt categories describe as missing. Knowing the taxonomy is knowing what the infrastructure must eventually provide and what the data scientist must manually verify in the interim.

## Key concepts the role pulls from

- **Glue code.** The wrapping code that ingests data from system A, transforms it into the shape system B expects, and feeds it to a model training framework. Sculley's finding: glue code is often the majority of the system by line count, is rarely tested, and encodes implicit assumptions about data shape, schema version, and upstream behaviour that break silently when the upstream changes. Powers the role's code-review lens: ML system review starts with the data pipeline, not the model.
- **Pipeline jungles.** As feature-engineering pipelines evolve through experimental iterations, they accumulate branches, dead paths, and undocumented transforms that are kept because removing them might break something. The jungle is not wrong; it just has no map. Powers the `pre-launch-measurement-audit`'s pipeline-readiness check: can the pipeline be traced from raw data to model input without undocumented steps?
- **Undeclared consumers.** Other teams or systems that depend on a model's output, a feature, or a pipeline stage — without being declared as dependencies. When the model is retrained or the feature is changed, undeclared consumers break silently. Powers the `causal-dag` application to ML systems: the DAG of a production ML system must include downstream consumers as nodes, not just training inputs.
- **Configuration debt.** ML systems have many hyperparameters, feature flags, data-path specifications, and model-architecture choices stored in configuration. When configuration is undocumented, unversioned, or duplicated across environments (training vs. serving), it becomes a source of unreproducible results. The "training-serving skew" failure mode is partly configuration debt. Powers the role's reproducibility requirement: every production model must trace from configuration to output.
- **Feedback loops.** When a model's outputs influence the data that will train the next version of the model, the training distribution shifts over time in ways that are hard to detect and hard to attribute. The canonical example: a recommendation model trains on clicks, but what gets clicked is determined by what was recommended, so the training distribution is a function of the model's own prior recommendations. Sculley calls this "hidden feedback loops." Powers the `experiment-design` requirement to specify what the counterfactual world looks like for a model-driven intervention.
- **Monitoring debt.** Production ML systems need monitoring at three levels: input data (is the distribution shifting?), model behaviour (are predictions drifting?), and outcome (is the real-world result changing?). Sculley's finding: most systems are monitored at only one level or not at all. Powers the `pre-launch-measurement-audit`'s monitoring-readiness check.

## What to actually read (1-hour budget)

- **The paper, full text.** It is 9 pages. Read in full; every section is load-bearing. Sections 2-5 cover the main debt categories; Section 6 (anti-patterns in ML system design) is the most immediately actionable.
- **Martin Fowler and Rebecca Parsons' "Thoughtworks Technology Radar" entry on "ML technical debt"** — a 2-page digest that situates Sculley's taxonomy in contemporary MLOps practice.
- **Chip Huyen, *Designing Machine Learning Systems* (2022), Chapters 7-9** — the contemporary practitioner follow-on; where Sculley named the categories, Huyen provides the remediation patterns.

## What to skip

- The paper's formal CACE (Changing Anything Changes Everything) analysis is conceptually important but is absorbed better through the examples than through the formal definitions on first read.
- The appendix on specific Google-internal systems — historically interesting, but the taxonomy is the portable content.

## How this anchors role skills

- [`causal-dag`](../../roles/data-scientist/skills/causal-dag/SKILL.md) — a production ML system's causal graph (what feeds what, which nodes have feedback loops, which consumers are downstream) is a DAG problem. Sculley's undeclared-consumers and hidden-feedback-loop categories are causal-structure problems that the DAG makes visible.
- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the instrumentation and monitoring readiness check draws directly from Sculley's monitoring-debt taxonomy. The audit's pipeline-readiness gate is the glue-code and configuration-debt check operationalised.

## Cross-role connection

ML technical debt is a refactor target category — which is the engineer's domain. The engineer role's `refactor-plan` skill (sequence, safety net, rollback path) applied to a pipeline jungle is exactly the Sculley-debt remediation pattern. When the methodology's `multi-role-review` includes an engineer and a data scientist on an ML system review, Sculley is the shared vocabulary: the data scientist names the debt category; the engineer designs the remediation sequence. The security expert also has an interest: Sculley's undeclared consumers are an attack surface (a system depending on a model output in an undeclared way may also be receiving adversarial model outputs in an undeclared way).
