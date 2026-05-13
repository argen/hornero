---
name: pre-launch-measurement-audit
description: Use when a launch is approaching cut and the team needs a disciplined data-science pass — metric stack audit, experiment-design check, causal-claim sanity check, instrumentation readiness — producing a Go / Fix-then-go / Hold recommendation.
intent: |
  A data-scientist-led workflow that consumes the launch's success
  criteria, audits the metric definitions, checks experimentation
  integrity (if a launch experiment exists), surfaces causal-claim
  risks, verifies instrumentation, and issues an explicit Go / Fix-
  then-go / Hold recommendation. Sibling to `pre-release-test-pass`
  (tester), `pre-launch-security-audit` (security), and
  `pre-launch-marketing-audit` (marketing) — same six-step shape so
  the orchestrator can compose all four in a major launch.
type: workflow
theme: launch-readiness
best_for:
  - A revenue-affecting product launch whose success criteria are quantitative
  - A launch including an A/B test or holdout whose readout will drive a ship decision
  - A pricing or measurement-platform change whose data layer must hold up
  - An ML or LLM feature launch where evaluation strategy is part of the launch
scenarios:
  - "Pre-cut data audit on the LedgerStack v2 launch"
  - "Pre-launch measurement audit on a new pricing tier with holdout"
  - "Pre-launch audit on an LLM feature where eval methodology drives the go/no-go"
  - "Quarterly readout audit on a regulated reporting subsystem"
estimated_time: 2-5 hours (single launch); scales to a day for major releases
---

# Pre-launch measurement audit

> v0 draft. A workflow skill that composes other data-scientist component skills. Grounded in Ron Kohavi's *Trustworthy Online Controlled Experiments* on release-readiness from the measurement side, Cassie Kozyrkov on decision-quality framing, D. Sculley et al.'s ML-system technical-debt taxonomy for instrumentation risks, and the same release-engineering discipline (Humble & Farley; Google SRE) that underlies the sibling launch-audit workflows.

## Purpose

Before a launch ships, run a structured audit that produces:

1. **A metric-stack readout** — every metric the launch's success depends on, audited per [`metric-definition`](../metric-definition/SKILL.md). Includes the OEC, guardrails, and operational metrics.
2. **An experiment-design audit (if applicable)** — if the launch is run as an A/B test or holdout, the design audited per [`experiment-design`](../experiment-design/SKILL.md).
3. **A causal-claim sanity check** — any claim the launch will support (this caused that) audited per [`causal-dag`](../causal-dag/SKILL.md). Distinguish causal from associational claims.
4. **An instrumentation-readiness check** — are the events / logs / dashboards in place to detect post-launch problems?
5. **A measurement-readiness recommendation** — Go / Fix-then-go / Hold with evidence.

This is **not** "did we set up the dashboard." It is "if this launch produces a problem the team needs to detect within 24 hours, will the measurement stack tell them?"

## Key Concepts

### Launch-time amnesia

The team designed metrics weeks earlier; defined an experiment days earlier; built instrumentation in parallel. By launch day, drift and gaps have accumulated. The audit's job is to close those gaps before the launch reveals them as production incidents.

### The four data-failure modes at launch

1. **Definition drift.** A metric definition has changed since the PRD's success criteria were written. The post-launch reading isn't comparable to the baseline.
2. **Instrumentation gaps.** Events the analysis depends on aren't firing, are firing inconsistently, or are arriving with malformed payloads.
3. **Experiment-design defects.** SRM-blindness, under-powering, optional stopping, no pre-registration. The launch's experiment will produce uninterpretable results.
4. **Causal-claim drift.** The PRD claims X *causes* Y; the post-launch evidence is correlational; the team will read the data more strongly than it deserves.

The audit's four substantive steps map to these four failure modes.

### Decision-quality framing (Kozyrkov)

The audit's output is the data-science contribution to a decision the launch is enabling. The recommendation is decision-shaped, not summary-shaped: Go / Fix-then-go / Hold, with a stated condition under which a HOLD flips to GO.

### Sibling-workflow compatibility

The shape — Frame / Audit-by-component / Synthesize / Recommend — matches `pre-release-test-pass`, `pre-launch-security-audit`, and `pre-launch-marketing-audit`. The orchestrator (often a PM running `cross-functional-orchestration`) can run all four siblings in parallel via `multi-role-review` and synthesise their recommendations into a unified launch decision.

## Application

Six steps; 2-4 hours for a small launch; scales with launch scope.

### Step 1 — Frame the audit (15-30 minutes)

The data-scientist lead gathers:

- **Launch scope** — what's shipping, to whom, when. The diff since the previous audit if one was run.
- **Decision context** — what decision does the launch's data inform? Ship/hold (binary)? Allocation (size of effect)? Replication (does the result re-prove a previous claim)?
- **Pre-reads** — PRD, success criteria, RFC, experiment plan if any, instrumentation tickets.
- **Time-box** — cut deadline; audit-day plan.

Output: a one-page audit charter — scope, decision context, time-box, pre-read links.

### Step 2 — Audit the metric stack (30-60 minutes)

For each metric the launch depends on (success criterion, OEC, each guardrail, each operational metric):

- Pull the canonical definition from the metric registry.
- Compare against the PRD / success-criteria language. Drift?
- Confirm the definition is computable today (events present, query runs, no upstream definition changed).
- Verify the counter-metric is named and computable.
- Verify there's an owner. Page-time confirmed.

Each metric gets a row: definition match / counter-metric / owner / instrumentation OK / risks. Flag any gap explicitly.

### Step 3 — Audit the experiment design, if any (30-60 minutes)

If the launch is an A/B test, holdout, or any randomised comparison:

- Pull the pre-registered design.
- Confirm OEC + guardrails match the PRD's success criteria.
- Confirm power analysis: MDE consistent with what would matter; sample size achievable in planned duration; CUPED or stratification configured if planned.
- Confirm SRM check automated, alpha=0.001, daily.
- Confirm stopping rule is single-look or sequential-with-alpha-spending (not optional-stopping).
- Confirm the analysis plan is locked before traffic allocation.
- Sanity-check unit-of-randomization vs. unit-of-analysis match.

If no experiment, document the alternative — what's the comparison? Pre-vs-post? Synthetic control? Just "we'll watch the dashboard"? The latter is not a comparison; flag.

### Step 4 — Causal-claim sanity check (15-45 minutes)

For each claim the launch will support:

- Restate the claim: associational ("X is associated with Y") or causal ("X causes Y")?
- For causal claims: is there an experiment, a DAG with adjustment, or a quasi-experimental method? If none, the claim should be weakened to associational, or the launch's evidence design should be revisited.
- For "we shipped X and Y improved" claims: is there a control? A historical baseline that controls for seasonality? A synthetic-control comparison?

Output: a one-page table of claims → evidence-design → causal-strength rating (high / medium / low / associational only).

### Step 5 — Instrumentation readiness (30-60 minutes)

Verify the events / logs / dashboards / alerts the launch's measurement depends on. Pull the instrumentation tickets and:

- Are events firing in staging? Volumes reasonable?
- Are event payloads validated against schema?
- Are downstream pipelines (ELT, dbt, feature store) up-to-date with the new events?
- Are dashboards built and tested? Owner named?
- Are alerts wired up with reasonable thresholds and routing? On-call knows what to do?

For ML / LLM launches, additionally:

- Is the eval set frozen? Adversarial-eval set present?
- Is production monitoring (drift detection, abuse-signal, output-quality sampling) ready?
- Is rollback-by-eval-failure tested?

### Step 6 — Synthesise and recommend (30-45 minutes)

Categorise findings:

- **Blockers** — defects severe enough to delay launch. Each cites the failing component (metric / experiment / claim / instrumentation).
- **Warnings** — issues that don't block but should be tracked through launch + post-launch monitoring.
- **Follow-ups** — work for after launch (metric re-validation cadence, additional causal evidence, eval-set refresh).

Issue the recommendation:

```markdown
# Measurement-readiness recommendation — <launch / RC ID>

- **Lead data scientist:** <name>
- **Date:** <YYYY-MM-DD>
- **Launch candidate:** <SHA / version>
- **Recommendation:** GO | FIX-THEN-GO | HOLD

## Summary

<3-5 sentences. The recommendation, the headline finding, and the
condition under which a FIX-THEN-GO becomes GO.>

## Metric-stack readout

| Metric | Definition match | Counter-metric | Owner | Instrumentation | Risks |
|---|---|---|---|---|---|

## Experiment-design audit (if applicable)

<Power, SRM, pre-registration, stopping rule. Findings.>

## Causal-claim audit

| Claim | Evidence design | Causal strength | Note |
|---|---|---|---|

## Instrumentation readout

<Events, dashboards, alerts. Status by component.>

## Blockers

| ID | Description | Evidence | Owner |
|---|---|---|---|

## Warnings

<Issues to track through launch + post-launch.>

## Follow-ups

<Post-launch work — re-validation cadence, additional causal evidence,
eval-set refresh, etc.>

## Acceptance

<Sign-off, if required.>
```

Circulate to launch decision-owner and sibling-workflow leads (tester, security, marketing if running in parallel). Stakeholders can override the recommendation; the override is recorded.

## Examples

### Example 1 — Pre-launch audit on LedgerStack v2 (good shape)

**Step 1 — Frame.** Launch scope: payments-provider migration + new dashboard + pricing tier change. Decision: ship vs. hold the Tuesday cut. Pre-reads: PRD, RFC, migration runbook, marketing brief. 4-hour box; cut on Tuesday.

**Step 2 — Metric stack.** 7 metrics across PRD success criteria + OEC + 3 guardrails + 2 operational. 5 clean, 1 definition drift (migration_completion_rate's denominator quietly changed from "customers in migration cohort" to "customers prompted to migrate" — different number). 1 counter-metric missing (trust_NPS_delta has no companion). 7 owners present, all paged-tested.

**Step 3 — Experiment audit.** No experiment; the launch is a phased rollout (10% → 50% → 100% by region). Alternative comparison: pre-vs-post + region-staggered DiD against unaffected regions. Plan reviewed: DiD is sound, parallel-trends assumption defensible from prior data. SRM not applicable.

**Step 4 — Causal claims.** Three claims:
- "v2 reduces support-ticket rate" — quasi-experimental via region-stagger DiD; causal-strength medium.
- "v2 lifts NPS" — associational only; one region's NPS will be confounded with the migration's communications. Weaken to associational.
- "pricing change increases ARPU" — observational with confounded selection (mid-tier customers self-select); causal-strength low. Recommend post-launch experiment on subsequent cohorts before generalising.

**Step 5 — Instrumentation.** Events firing in staging, schema-validated. Two dashboards built; one alert (refund-rate spike) has overly tight threshold (0.5% absolute will fire weekly from normal variance) — recommend +/- 1pp.

**Step 6 — Recommendation: FIX-THEN-GO.**

```markdown
Recommendation: FIX-THEN-GO. Three fixes required pre-cut:
- BUG-M1: re-baseline migration_completion_rate with the new
  denominator; communicate the change to the launch readout.
- BUG-M2: add trust_NPS_delta counter-metric (concurrent-CS-volume),
  define and instrument before launch.
- BUG-M3: relax refund-rate alert threshold to +1pp.

After fixes, GO. Two warnings tracked:
- WARN-1: NPS-lift claim weakened to associational in launch
  communications.
- WARN-2: pricing-change-causes-ARPU claim requires post-launch
  experiment before generalising; flagged in the launch readout
  template.

Follow-ups:
- Metric re-validation (proxy → outcome) at 90 days post-launch.
- Designed experiment for the pricing claim on next signups cohort.
```

What makes this good: each substep produced specific findings; blockers are addressable in hours; warnings have follow-up commitments; the causal-claim audit prevented a launch readout from over-claiming.

### Example 2 — Failure mode (bad)

```markdown
# Pre-launch audit

Dashboards built; metrics look reasonable. We'll see how the launch
goes and adjust if needed.

Recommend: GO.
```

Failures: no metric-stack audit (definition drift undetected); no experiment-design audit (if there's an experiment, defects ship; if there isn't, alternative comparison undefended); no causal-claim audit (the launch readout will assert correlation as causation); instrumentation untested. "We'll adjust if needed" is not a plan.

## Common Pitfalls

### Pitfall 1 — "Dashboards built" as readiness

**Symptom:** The audit reduces to confirming dashboards exist; metric definitions, experiment integrity, and causal claims are not audited.

**Consequence:** The dashboards display numbers that are silently wrong; the launch reads success or failure from compromised signal; the team learns post-mortem that the "win" was a definition drift.

**Fix:** Each of the four substantive checks (metric / experiment / causal / instrumentation) is non-negotiable. Dashboards-built is one fifth of one check.

### Pitfall 2 — Skipping the causal-claim audit

**Symptom:** The audit verifies the experiment / dashboards but does not examine which claims the launch's evidence supports.

**Consequence:** Post-launch communications assert causation when only association is supported; the team and stakeholders learn the wrong lesson; subsequent strategy is built on phantom causes.

**Fix:** Every launch claim gets a causal-strength rating. Communications language is constrained accordingly.

### Pitfall 3 — Audit theatre

**Symptom:** Audit is run, recommendation produced, follow-ups listed — and no follow-ups are tracked or completed.

**Consequence:** The same gaps recur launch after launch; the audit becomes ceremony.

**Fix:** Follow-ups have named owners and tracker entries. The next audit starts by reading the previous one's follow-ups.

### Pitfall 4 — Recommendation as vote

**Symptom:** "The team is comfortable; data-science says GO."

**Consequence:** Data-science authority erodes; the recommendation has no independent weight.

**Fix:** The data scientist issues a professional recommendation supported by evidence. The launch decision can override; the override is recorded with reasoning. Votes don't enter the audit.

### Pitfall 5 — Optional-stopping ignored

**Symptom:** The launch's experiment is run with daily looks and an "we'll call it when it's clear" stopping policy.

**Consequence:** Kohavi's empirical finding: optional-stopping inflates false positives dramatically. The "win" reading is statistical noise. The launch ships, the lift doesn't persist post-launch, and there's no obvious diagnosis.

**Fix:** Pre-registered stopping rule. Either run to planned duration with one look, or use alpha-spending sequential analysis, or use Bayesian methods with honest priors.

### Pitfall 6 — Instrumentation OK in staging, broken in prod

**Symptom:** Events fire correctly in staging; nobody verifies the production deployment hasn't introduced a routing or sampling difference.

**Consequence:** Post-launch metrics are silently wrong; the team chases phantom trends or misses real ones.

**Fix:** Instrumentation audit includes a production smoke test before launch (or, for launches that *create* the production volume, a fast follow-up check within the first hour).

### Pitfall 7 — Single-launch focus

**Symptom:** The audit covers the immediate launch's measurement but does not consider what longer-term re-validation needs to happen.

**Consequence:** Proxy relationships drift; the metric that drove the decision degrades; nobody is paged to check.

**Fix:** Follow-ups always include a proxy re-validation cadence (per `metric-definition`), even for launches that ship clean.

### Pitfall 8 — Mistaking the launch experiment for the post-launch question

**Symptom:** The team conflates "did the launch experiment win" with "is the long-term metric in the desired direction."

**Consequence:** A short-run experimental win is read as long-run validation; novelty / primacy / Hawthorne effects are not separated from steady-state behaviour.

**Fix:** Follow-ups include post-launch (30 / 60 / 90 day) checks against the steady-state metric. The launch experiment opens the question; it does not close it.

## References

- **Ron Kohavi, Diane Tang & Ya Xu** — *Trustworthy Online Controlled Experiments* (2020); launch-time experimentation discipline. See `roles/data-scientist/sources.md`.
- **D. Sculley et al.** — "Hidden Technical Debt in Machine Learning Systems" (2015); the ML-launch instrumentation-debt taxonomy.
- **Cassie Kozyrkov** — Decision intelligence; decision-shaped recommendations.
- **Andrew Gelman & Richard McElreath** — *Bayesian Data Analysis*; *Statistical Rethinking*. Sequential analysis and honest uncertainty.
- **Judea Pearl** — *Causality*; *The Book of Why*. Causal-claim audit foundation.
- **Cathy O'Neil** — *Weapons of Math Destruction* (2016). Consequence audit for launches whose models drive consequential decisions.
- **Daniel Kahneman, Olivier Sibony & Cass Sunstein** — *Noise* (2021). Decision-noise the audit's recommendation guards against.
- **Jez Humble & David Farley** — *Continuous Delivery* (2010). Sibling-workflow discipline shared with `pre-release-test-pass`.
- **Related Hornero skills:**
  - [`metric-definition`](../metric-definition/SKILL.md) — applied per metric at step 2.
  - [`experiment-design`](../experiment-design/SKILL.md) — applied at step 3 when an experiment exists.
  - [`causal-dag`](../causal-dag/SKILL.md) — applied at step 4 for causal claims.
  - `roles/tester/skills/pre-release-test-pass/SKILL.md` — sibling pre-launch workflow; same shape, different lens (test coverage vs. measurement coverage).
  - `roles/security-expert/skills/pre-launch-security-audit/SKILL.md` — sibling pre-launch workflow.
  - `roles/marketing-expert/skills/pre-launch-marketing-audit/SKILL.md` — sibling pre-launch workflow.
  - `roles/product-manager/skills/cross-functional-orchestration/SKILL.md` — the PM-orchestrator can compose all four sibling audits via `multi-role-review`.
  - `skills/multi-role-review/SKILL.md` — orchestration mechanism for parallel-running the four siblings.
