# Andrej Karpathy — distilled

> "A Recipe for Training Neural Networks" (karpathy.github.io, 2019); "The Unreasonable Effectiveness of Recurrent Neural Networks" (2015); "State of GPT" (Microsoft Build, 2023); neural network explainers (minGPT, nanoGPT, makemore) on GitHub. Ex-OpenAI Director of AI, ex-Tesla AI Director. The working-practitioner voice on what actually trains and what just sort-of trains.

## Why it matters for AI-coding

AI training-loop fragility is rarely surfaced in tutorial code. A tutorial shows a model converging on a clean dataset with a single GPU; it does not show the gradient explosion on step 3,000, the silent NaN that corrupts half the training run, the dataset that looked balanced but wasn't, or the evaluation metric that measured memorisation rather than generalisation. Karpathy's "Recipe" is the empirical voice on these failure modes — not from theory but from years of debugging training runs at OpenAI and Tesla. The Recipe is structured as a sequence of checks that a practitioner should execute before trusting any training result, and each check corresponds to a class of failures that AI-generated training code almost universally skips.

For the methodology: the `pre-launch-measurement-audit` for ML models includes a training-loop verification pass. Karpathy's Recipe is the vocabulary for that pass. The tester role's exploratory-testing discipline (investigating unknown unknowns) maps directly onto Karpathy's "overfit a single batch before anything else" heuristic — both are about finding real failure modes before they reach production.

## Key concepts the role pulls from

- **Overfit a single batch first.** Before training on any real dataset, train the model to perfect loss on a single batch. If the model can't overfit one batch, the architecture or loss function is broken. This is Karpathy's first diagnostic gate — it isolates model correctness from data and regularisation concerns. Powers the role's training-loop review: "has this model been verified to be capable of overfitting a single batch?"
- **Visualise everything.** Before training begins, plot the raw data (not summary statistics — actual examples); plot the loss curve; plot gradient norms per layer; plot the distribution of predictions vs. labels. Most training bugs are visible in the visualisations before they manifest as training failures. Powers the role's monitoring-readiness check: is the training infrastructure producing the visualisations needed to debug a run?
- **Data is the model.** Karpathy's repeated observation: the most reliable way to improve a model is to improve the data — more data, cleaner data, better labelling, more representative sampling. Model architecture changes are expensive and uncertain; data improvements are often faster and more reliable. Powers the role's evaluation-first discipline: before changing the architecture, audit the dataset.
- **The neural net as a leaky abstraction.** Neural networks abstract away many modelling decisions, but those decisions leak: the choice of activation function, initialisation scheme, learning-rate schedule, and batch size all interact in ways that are not fully theorised. Karpathy's heuristic: when something breaks, assume you don't understand the abstraction well enough before assuming the framework has a bug. Powers the role's reproducibility requirement: every training run must log all configuration choices explicitly.
- **Calibration and evaluation.** A model's confidence score (logit / probability) should reflect its actual accuracy — a model that says "90% confidence" should be right 90% of the time. Most training procedures produce overconfident models. Calibration check (reliability diagram, expected calibration error) is a required evaluation step. Powers the role's model-evaluation standard: accuracy alone is not sufficient; calibration must be reported.
- **The gradient norm is a vital sign.** Exploding gradients (gradient norm spikes) and vanishing gradients (gradient norm approaches zero) are the two failure modes that abort training. Gradient clipping is the intervention for explosion; architecture choices (residual connections, layer normalisation) are the intervention for vanishing. Powers the monitoring-readiness check: gradient norms must be logged throughout training, not just at the end.

## What to actually read (1-hour budget)

- **"A Recipe for Training Neural Networks" (2019), full text.** It is approximately 6,000 words. Every paragraph is load-bearing. The Recipe's six steps (become one with the data; set up end-to-end training/evaluation; overfit; regularise; tune; squeeze out squeezes) are the working practitioner's pre-launch checklist for ML model development.
- **"The Unreasonable Effectiveness of Recurrent Neural Networks" (2015), introduction and the "characters" section.** Not for the RNN content specifically — LSTMs are less central than they were — but for the methodology of empirical investigation: Karpathy shows how to probe a model's behaviour by inspecting its representations, not just its outputs.
- **nanoGPT (GitHub)** — the implementation is short enough to read in an hour and embodies every principle in the Recipe in a working codebase. The comments are load-bearing.

## What to skip

- "State of GPT" (2023) is an excellent orientation to the GPT training pipeline but is partially dated by subsequent scaling developments; read for the RLHF and instruction-tuning sections, skip the benchmarking portions.
- The makemore series on YouTube — valuable for learning; slow for reference.

## How this anchors role skills

- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the training-loop verification pass draws directly from the Recipe: overfit-a-batch check, visualisation readiness, gradient-norm logging, calibration evaluation. A model that hasn't been through these checks doesn't pass the audit's ML-readiness gate.
- [`experiment-design`](../../roles/data-scientist/skills/experiment-design/SKILL.md) — Karpathy's "evaluate before you iterate" discipline pairs with the skill's pre-registration requirement: define the evaluation criteria before the training run, or the results will be interpreted post-hoc.

## Cross-role connection

Training-loop verification is the testing-of-ML-systems analog. The tester role's `exploratory-charter` skill (time-boxed, mission-driven investigation to surface unknown unknowns) maps onto Karpathy's "become one with the data" phase: both are about discovering what's actually in the artifact before claiming it's ready. When the methodology's `multi-role-review` pairs a tester and a data scientist on an ML model review, the tester's exploratory discipline and Karpathy's empirical diagnosis are the same instinct in different vocabularies — investigate the actual thing, not the theoretical thing. The engineer role's `simplify` discipline also applies: the shortest training loop that overfits is more trustworthy than the most elaborate one.
