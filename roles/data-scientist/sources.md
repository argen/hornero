# Data scientist — sources

The curated bibliography for the data-scientist role. Skills cite from this list. New frameworks introduced in skills must trace to a name here.

## Anchors

### Judea Pearl
- *Causality: Models, Reasoning, and Inference* (2000, rev. 2009)
- *The Book of Why: The New Science of Cause and Effect* (2018, with Dana Mackenzie)
- do-calculus, causal diagrams, the "ladder of causation"
- **Why he matters:** The canonical voice on causal inference; the distinction between correlation, intervention, and counterfactual reasoning underpins every honest claim about "why" something happens.
- Used in: causal-inference, dag-design, counterfactual-analysis skills.

### Ron Kohavi — ex-Microsoft Experimentation Platform
- *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing* (2020, with Diane Tang and Ya Xu)
- Long-running A/B testing methodology
- The "twyman's law" and SRM (sample ratio mismatch) diagnostics
- **Why he matters:** The canonical practitioner reference on online experimentation at scale; sharpest contemporary voice on what goes wrong with A/B tests and how to detect it.
- Used in: ab-test-design, srm-check, experiment-readout skills.

### Hadley Wickham — Posit (formerly RStudio)
- *R for Data Science* (2017, with Garrett Grolemund; 2nd ed. 2023, with Mine Çetinkaya-Rundel)
- Tidyverse (dplyr, ggplot2, tidyr) — vocabulary of tidy data
- "Tidy Data" paper (2014)
- **Why he matters:** Tidy data is the cleanest mental model for organizing analytical work; widely adopted vocabulary across Python (via pandas) and SQL practice.
- Used in: tidy-data, wrangling, viz-design skills.

### Andrew Gelman & Richard McElreath
- Gelman et al. — *Bayesian Data Analysis* (1995, rev. 2013)
- McElreath — *Statistical Rethinking: A Bayesian Course with Examples in R and Stan* (2015, rev. 2020)
- statmodeling.stat.columbia.edu — Gelman's ongoing blog
- **Why they matter:** Modern Bayesian methods made teachable. *Statistical Rethinking* is the most-recommended applied Bayesian textbook; Gelman's blog is the working-practitioner forum.
- Used in: bayesian-modeling, prior-elicitation, posterior-checks skills.

### Cassie Kozyrkov — ex-Google Chief Decision Scientist
- Decision intelligence framing
- "Statistics for People in a Hurry" (2018)
- The bias-variance-noise framing of decision making
- **Why she matters:** Translates statistical practice into decision-making; sharpest contemporary voice on when *not* to do statistics.
- Used in: decision-framing, threshold-setting skills.

### D. Sculley et al. — Google
- "Hidden Technical Debt in Machine Learning Systems" (NeurIPS 2015)
- The "ML system anti-patterns" taxonomy: glue code, pipeline jungles, dead experimental codepaths, configuration debt, monitoring debt
- **Why it matters:** Foundational reference for ML engineering as engineering. Names what goes wrong when ML code is written like research code in production.
- Used in: ml-system-review, technical-debt-audit skills.

### Daniel Kahneman
- *Thinking, Fast and Slow* (2011)
- *Noise* (2021, with Olivier Sibony and Cass Sunstein)
- Anchoring, framing, availability, representativeness, regression to the mean
- **Why he matters:** Defined the modern vocabulary for cognitive bias and decision noise. Required reading for anyone interpreting data with humans in the loop.
- Used in: bias-checklist, noise-audit skills.

### Cathy O'Neil
- *Weapons of Math Destruction: How Big Data Increases Inequality and Threatens Democracy* (2016)
- Algorithmic accountability auditing
- **Why she matters:** The canonical voice on harm from opaque, scaled, consequential models. Counterweight to the assumption that more data = better outcomes.
- Used in: model-impact-assessment, fairness-review skills.

### Andrej Karpathy — ex-OpenAI / ex-Tesla
- karpathy.github.io — applied deep learning blog
- "A Recipe for Training Neural Networks" (2019)
- "State of GPT" and adjacent talks
- **Why he matters:** Working-practitioner voice on what actually works in deep learning. Sharp on the difference between research demo and production system.
- Used in: nn-training-recipe, model-debugging skills.

### Wes McKinney — pandas creator; Voltron Data
- *Python for Data Analysis* (2012, rev. 2022)
- pandas, Apache Arrow
- **Why he matters:** Pandas is the working data scientist's default tool; the book is the canonical reference. Arrow is the emerging cross-language data interchange standard.
- Used in: pandas-idioms, arrow-interchange skills.

## See also

- **Hilary Mason** — applied data science voice; ex-Bitly Chief Scientist.
- **DJ Patil** — coined "data scientist"; *Data Driven*; ex-US Chief Data Scientist.
- **Andrew Ng** — *Machine Learning Yearning*; foundational MOOC; applied ML practice.
- **Sebastian Raschka** — *Machine Learning with PyTorch and Scikit-Learn*; teaching reference.
- **Allen Downey** — *Think Stats*, *Think Bayes* — accessible statistics textbooks.
- **Galit Shmueli** — "To Explain or to Predict?" (2010) — explanatory vs predictive modeling distinction.
- **Donald Rubin** — Rubin causal model (potential outcomes framework); complement to Pearl.
- **Google PAIR** — People + AI Research; human-AI interaction guidelines.
- **HELM / Stanford CRFM** — Holistic Evaluation of Language Models; LLM benchmarking methodology.

## Curation notes

Cap is ~10 anchors plus "see also." Adding a new anchor requires demoting an existing one.

The data-scientist role spans statistics, ML engineering, decision support, ethics, and (increasingly) LLM evaluation. The anchor selection covers each pillar: causal reasoning (Pearl), experimentation (Kohavi), data wrangling (Wickham, McKinney), Bayesian methods (Gelman/McElreath), decision framing (Kozyrkov), ML systems (Sculley), cognitive bias (Kahneman), ethics (O'Neil), deep learning practice (Karpathy).

Notably absent from anchors: specific algorithms or tools (XGBoost, BERT, etc.) — these are implementation choices that change quickly. The conceptual scaffolding above is more durable.

LLM-specific evaluation is currently covered via Karpathy (deep learning practice) plus the HELM / Google PAIR entries in "see also." Expect a dedicated AI-eval anchor as the field matures.
