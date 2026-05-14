# Ron Kohavi, Diane Tang, Ya Xu — distilled

> *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing* (2020). The canonical book on running and interpreting controlled experiments at scale, written by the people who built and ran experimentation at Microsoft, LinkedIn, and Airbnb. Plus the "Top Challenges from the First Practical Online Controlled Experiments Summit" papers (Kohavi et al., across years) as continuous-updates context.

## Why it matters for AI-coding

AI-suggested A/B tests systematically skip the discipline that makes experiment results *trustworthy*: SRM checks, pre-registered OEC vs. guardrails, MDE / sample-size calculation done *before* allocation, stopping-rule pre-commitment, and the long list of pitfalls Kohavi et al. catalogue. The book's stance — "any figure that looks interesting or different is usually wrong" (Twyman's law) — is the antidote to the AI default of confidently reporting whatever the data appears to say.

The methodology's `experiment-design` skill is, structurally, the book's Chapter 2 checklist operationalised into a one-page design artifact. The `pre-launch-measurement-audit` workflow uses Kohavi's "did you do the boring questions before allocation" discipline as its primary critique frame. The `metric-definition` skill draws Kohavi's strict separation of *driver* metrics (what experiments target) from *guardrail* metrics (what must not break) — a separation AI-generated metric proposals routinely conflate.

## Key concepts the role pulls from

- **OEC (Overall Evaluation Criterion).** The single primary metric the experiment is designed to move. Must be measurable in the experiment time window, must trade off long-term value against short-term volatility, must be agreed before allocation. AI-generated test designs default to "we'll look at several metrics" — Kohavi forbids it; pick *one*. Powers `experiment-design`'s OEC field.
- **Guardrails (counter-metrics).** The things that must not break while OEC moves. Without guardrails, optimising OEC produces "we made the metric go up by breaking everything else" — the canonical Goodhart pattern. Every OEC in `experiment-design` requires a guardrail set.
- **MDE (Minimum Detectable Effect) + sample size.** Compute these before allocation, not after the test fails to be significant. AI-suggested tests usually have undersized samples and detect-able-effect sizes the team would not actually find meaningful. Powers `experiment-design`'s sample-size calculation step.
- **SRM (Sample Ratio Mismatch).** The canary for broken randomisation. If your A/B split is supposed to be 50/50 and you see 52/48, something is wrong — and "something is wrong" usually means the whole experiment is invalid, not "use the data with a caveat." Powers `experiment-design`'s SRM check and the methodology's stance that *every* experiment readout must include the SRM result.
- **Twyman's law.** "Any figure that looks interesting or different is usually wrong." The book's most-quoted heuristic. When a result is suspiciously good, the first hypothesis is *measurement error*, not *real effect*. Powers the methodology's "did we replicate? did we instrument correctly? did we check SRM?" pre-celebration discipline.
- **Pre-registration vs. exploratory analysis.** The confirmatory questions are stated *before* the test runs; the exploratory questions are flagged as such and never reported as confirmed findings. AI-generated analyses routinely conflate the two; the discipline is to keep them separate. Powers `pre-launch-measurement-audit`'s "what is pre-registered vs. exploratory" check.
- **CUPED (variance reduction).** Pre-period data used as a covariate to reduce variance and shrink sample-size requirements. (Deng, Xu, Kohavi & Walker, 2013.) Cited by `experiment-design` as the standard variance-reduction technique when pre-period data exists.

## What to actually read (1-hour budget)

- **Chapters 1-3** (introduction; running and analysing experiments; Twyman's law and experimentation trustworthiness). ~80 pages. The foundational discipline lives here.
- **Chapters 13-14** (SRM and other diagnostics; common pitfalls). ~50 pages. The operational checklist that catches the bugs.
- If you have a second hour: **Chapter 7** (metrics for experimentation; OEC formulation; guardrails) and **Chapter 22** (variance reduction including CUPED). These two chapters are the working-practitioner content.

## What to skip

- The late chapters on building experimentation platforms (chapters 18-21, broadly) — engineering-flavoured, not science-flavoured. Useful if you're building the platform; tangential if you're using one.
- The book's appendices on specific statistical tests — the reference material is fine, but Wickham/standard stats texts cover the same ground more accessibly.
- Most of the cross-references to internal-Microsoft systems — historically interesting, operationally tangential.

## How this anchors role skills

- [`experiment-design`](../../roles/data-scientist/skills/experiment-design/SKILL.md) — the skill's structure (OEC, guardrails, MDE, sample size, randomisation unit, SRM check, stopping rule, pre-registration) maps 1:1 to Kohavi's Chapter 2 checklist. The skill *is* an operationalised version of the book's pre-allocation discipline.
- [`metric-definition`](../../roles/data-scientist/skills/metric-definition/SKILL.md) — the driver-vs-guardrail separation, the counter-metric requirement, and the "every metric has a gaming surface" critique all descend from Kohavi's metric-discipline chapters.
- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the workflow composes experiment-design + metric-definition + causal-dag passes; its "Go / Fix-then-go / Hold" recommendation shape is Kohavi's "is this experiment trustworthy enough to act on" question operationalised.
- General review heuristic: when the data-scientist role flags an experiment as "untrustworthy" (no SRM check, undersized, post-hoc OEC), the citation is Kohavi.

## Cross-role connection

Kohavi's Twyman's law sibling is the security-expert's adversary-realism — both refuse to take a surprising result at face value without investigation. The OEC vs. guardrails split parallels the engineer's `tdd-discipline` red-vs-green — both name what *must* happen and what *must not* break. When `/orchestrate` composes a launch with measurement-readiness as one phase, the data-scientist reviewer applies Kohavi; the marketing-expert and PM reviewers concur on the metric-gaming critique with their own citations (Dunford's evidence-discipline; Goodhart's law) — same stance, different anchors.
