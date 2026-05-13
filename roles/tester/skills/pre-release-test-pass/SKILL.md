---
name: pre-release-test-pass
description: Use when a release candidate is approaching cut and the team needs a disciplined multi-step pass — risk re-assessment, targeted exploration, automated-suite review, and a release-readiness recommendation.
intent: |
  A tester-led workflow that consumes the test plan, runs targeted
  exploratory charters against the highest-risk surfaces, audits what
  the automated suite did and did not tell us, and produces an
  explicit go / hold / no-go recommendation with evidence. The
  workflow exists to resist three release-time failure modes:
  green-pipeline-is-enough, exploratory-as-afterthought, and gut-feel
  sign-off.
type: workflow
theme: release-readiness
best_for:
  - High-stakes releases (revenue-affecting, customer-facing, regulatory)
  - Releases of areas with a recent incident history
  - Migrations, re-platformings, or significant integration swaps
  - Releases following a deliberate test-coverage gap (e.g., a tight
    schedule where the plan was knowingly thinned)
scenarios:
  - "Pre-Black-Friday pass on the checkout + payments stack"
  - "Pre-launch pass on the new admin permissions model"
  - "Pre-cutover pass on the Stripe → Adyen billing migration"
  - "Quarterly pass on a regulated reporting subsystem"
estimated_time: 2-6 hours (single release); scales to days for major releases
---

# Pre-release test pass

> v0 draft. A workflow skill that orchestrates other tester skills. Grounded in James Bach & Michael Bolton's Session-Based Test Management (SBTM), Jez Humble & David Farley's *Continuous Delivery*, Lisa Crispin & Janet Gregory's release-readiness writing, and Google SRE's release-engineering practice.

## Purpose

Run a structured pass before a release candidate ships, producing:

1. **A re-assessed risk inventory** — what we now believe to be true about the release's risk surface, updated from the test plan.
2. **Exploratory evidence** — one or more charters against the highest-risk surfaces, with notes and bugs.
3. **An automated-suite readout** — what the suite told us, what it didn't, what's flaky.
4. **A release-readiness recommendation** — Go / Hold / No-Go with evidence.

A pre-release test pass is not "run the suite and look for red." Suites pass for the wrong reasons; suites miss the bug nobody knew to look for. The pass is the structured human investigation that complements automation at the moment when stakes are highest.

This is a **workflow** skill — it composes other tester component skills ([`test-plan`](../test-plan/SKILL.md), [`exploratory-charter`](../exploratory-charter/SKILL.md), [`regression-test`](../regression-test/SKILL.md)) and other roles' work (the engineer's diff, the PM's success criteria, the security expert's threat surface for relevant releases).

## Key Concepts

### Session-Based Test Management (SBTM)

Bach & Bolton: testing is organised into chartered sessions; each session is a unit of work; sessions roll up into a readout. The pre-release pass is SBTM applied at release granularity — multiple sessions, structured around the release-candidate scope, producing a defensible recommendation.

### Continuous Delivery's release-readiness frame

Humble & Farley: the deployment pipeline is the source of truth about release readiness. A "go for release" decision is supported by *evidence from the pipeline* (test runs, deployment-config validations, performance baselines), not by ceremony.

The pre-release pass does not replace the pipeline; it complements it. The pipeline answers "did the things we knew to check pass?"; the pass answers "what did we forget to check?"

### Time-boxed risk re-assessment

The pass opens with re-reading the test plan's risks list against what has actually shipped in this candidate. Three buckets emerge:

- **Risks we tested** — pipeline / planned tests covered.
- **Risks we deferred** — known gaps; explicit choice or new since plan.
- **Risks we missed** — surfaced by exploration during this pass.

The pass's value is mostly in the third bucket.

### Targeted exploration, not blanket exploration

A pre-release pass spawns one or more exploratory charters against the highest-risk surfaces, *not* "let's poke around." Charter selection is the most cognitively important step of the pass.

### Suite-readout discipline

A "green CI run" is necessary, not sufficient. The pass reviews:

- **What failed and recovered.** Flakes hidden by retries are signal.
- **What was skipped.** Skipped tests are admissions; each one needs justification.
- **What's slow.** Slow tests are likely to get deleted or weakened; track them.
- **What's covered vs uncovered.** Per the test plan's HTSM dimensions.

### Recommendation, with evidence

The output of the pass is a single recommendation — Go / Hold / No-Go — supported by the artifacts produced. The tester defends the recommendation, the team can override it (with their reasoning recorded), but the recommendation is the tester's professional output, not a vote-counting exercise.

### Blameless

Adopting Google SRE's blameless framing: the pass surfaces problems; problems are facts, not accusations. The recommendation is about the release candidate, not about the team's competence.

## Application

The workflow has six steps; in a small release one tester runs them in 2-4 hours. In a large release multiple testers run them in parallel and the lead tester synthesises.

### Step 1 — Frame the pass (10-20 minutes)

The pass's lead tester gathers:

- **Release scope.** What is in this candidate (RC) that wasn't in the previous one? The diff is the spotlight.
- **Time available.** When is the cut? When is the release? The pass time-boxes against the cut, not the release.
- **Stakeholder context.** Who needs to receive the recommendation? When? In what shape?
- **Test plan.** Pull the area's [`test-plan`](../test-plan/SKILL.md). It anchors the risk re-assessment.

Output: a one-page pass charter — scope, time-box, stakeholders, link to plan.

### Step 2 — Re-assess risks against this RC (20-40 minutes)

Open the test plan's risk table. For each row:

- **Has this risk changed in this RC?** New code that touches the risk surface? Newly relevant due to environment change?
- **Did our tests for this risk actually run?** Check the pipeline for the relevant tests.
- **What's our confidence?** H/M/L, with reasoning.

Add new risk rows for anything in scope of this RC that the plan doesn't cover. Mark gaps explicitly.

Output: an updated risk table for this RC.

### Step 3 — Run targeted exploratory charters (60-180 minutes)

Pick 1-3 surfaces with highest risk and lowest confidence. For each, write an [`exploratory-charter`](../exploratory-charter/SKILL.md) (Mission, Tour, Areas, time-box) and execute.

Heuristics for charter selection:

- **Recent-change risk** → History tour on the diff since last release.
- **Money-adjacent risk** → Money tour.
- **Concurrency / time-sensitive risk** → Stress tour, Time-dimensional sessions.
- **Config-sensitive risk** → Configuration tour.
- **Regression-prone risk** → Feature tour on the affected area with a deliberate look at recently-fixed bug paths.

Charters run during the pass should be 30-90 minutes each. If a charter overruns, that's a finding ("more exploration needed than time allowed") — file the leftover as a follow-up charter and continue.

Output: completed charters, with notes and bugs filed.

### Step 4 — Audit the automated suite readout (30-60 minutes)

Pull the CI run(s) for this RC. Examine:

- **Failures with retries.** Any test that needed a retry is suspect.
- **Skipped tests.** Each skip should have a known reason; surface unknowns.
- **Slow tests.** Top N slowest; do their costs match their value?
- **Coverage by HTSM dimension.** Map the suite's tests to the plan's HTSM rows. Highlight thin areas.
- **Recently-added or recently-changed tests.** Were they reviewed properly? Have they actually exercised the new code?

Output: a one-page suite-readout — what the pipeline did and did not tell us about this RC.

### Step 5 — Synthesise findings (20-40 minutes)

Combine the updated risk table, the charter notes, the suite readout. Three categories of finding:

- **Blockers** — defects severe enough to block release. Cite the evidence (bug ID, charter note, suite failure).
- **Warnings** — issues that don't block but should be tracked through release.
- **Follow-ups** — work for after release (test additions, plan updates, follow-up charters).

Output: a findings inventory, each item categorised.

### Step 6 — Issue the recommendation

The lead tester writes a single-page release-readiness recommendation:

```markdown
# Release-readiness recommendation — <release name / RC ID>

- **Lead tester:** <name>
- **Date:** <YYYY-MM-DD>
- **Release candidate:** <SHA / version>
- **Recommendation:** GO | HOLD | NO-GO

## Summary

<3-5 sentences. The recommendation, the headline reasoning, the
condition for change (e.g., "GO once BUG-1302 and BUG-1305 are merged
and the suite re-runs green").>

## Updated risk table

<This-RC version of the plan's risks; H/M/L confidence per row.>

## Exploratory evidence

<Charters run, with link to the committed charter files. One-line
summary of each.>

## Suite readout

<Highlights: what we covered well, what we didn't.>

## Blockers

| ID | Description | Evidence | Owner |
|---|---|---|---|

## Warnings

<Issues to track through release.>

## Follow-ups

<Plan updates, new charters, regression tests to be authored.>

## Acceptance

<Sign-off, if required, from named recipients.>
```

The recommendation is circulated; stakeholders can override with their own reasoning recorded. The pass's artifacts (charters, suite readout, this recommendation) are committed to the repo.

## Examples

### Example 1 — Pre-Black-Friday checkout pass (sketch, good shape)

**Step 1 — Frame.** RC includes the Adyen migration, a new gift-card promo flow, and a routine library upgrade for the cart service. Cut Tuesday; release Wednesday; pass-on-Monday morning, 4-hour box. Stakeholders: head of payments, head of CX.

**Step 2 — Re-assess.** Plan had 7 risks; this RC touches 5 of them and introduces 2 more (new promo flow). Two risks are now H (Adyen + new promo); three are M (cart, refund, receipts); two are L. Suite confidence H on cart math, L on receipts (no automated coverage of receipt copy / format).

**Step 3 — Charters.**
- 90-min Money tour on Adyen migration + receipts → 5 bugs filed (1 revenue, 4 post-purchase comms; see Example 1 in `exploratory-charter`).
- 60-min Stress tour on new promo flow (rate-limit, concurrent application) → 2 bugs filed (1 minor concurrency, 1 cosmetic).
- 30-min History tour on cart-service diff → no new findings.

**Step 4 — Suite readout.** 4,127 tests; 0 failures after 2 retries; 23 skips (12 known-flaky tracked; 11 reviewed and explained). Top 5 slow tests are E2E payment flows; pyramid is still healthy. Coverage thin on receipt formatting (already known).

**Step 5 — Findings.**
- Blockers: BUG-1302 (refund email "refunded in full" when partial), BUG-1305 (order detail loses provider/last-4 — visible regression).
- Warnings: BUG-1301 (KWD rounding direction — wrong, but small audience), BUG-1303/1304 (receipt comms — embarrassing, not revenue).
- Follow-ups: receipt copy needs automated regression coverage (file as test-plan update); KWD rounding rule needs finance sign-off; promo-flow concurrency needs a property test.

**Step 6 — Recommendation: HOLD.** GO once BUG-1302 + BUG-1305 fix and the suite re-runs green; warnings tracked but not blocking; follow-ups owned by the payments team. Circulated 10:42; head of payments accepts. Re-run cleared at 16:20; release went out Wednesday morning as planned.

Note what this looks like to a stakeholder: a specific recommendation, specific blockers, a clear condition under which the recommendation flips. The tester is not pleading; they are reporting.

### Example 2 — Failure mode (bad)

```markdown
# Pre-release pass — Black Friday

We ran the suite. It's green. Did some manual testing — looked OK.
A couple of minor issues filed.

Recommend: GO.
```

Failures: no risk re-assessment; no targeted exploration; no suite readout discipline; "minor issues" un-itemised; no condition under which the recommendation would change. The release may go fine — and if it doesn't, the team has no artifact to learn from.

## Common Pitfalls

### Pitfall 1 — Green CI is enough

**Symptom:** The pass collapses into "did CI pass?" + thumbs up.

**Consequence:** Suites pass for the wrong reasons; bugs ship that the suite was never going to catch. The team learns the wrong lesson when an incident hits ("the tests said green!").

**Fix:** Humble/Farley — CI is necessary, not sufficient. The pass adds the human investigation the pipeline can't do.

### Pitfall 2 — Exploration as afterthought

**Symptom:** Charters are run if there's time. Most of the box is consumed re-running the suite and reading logs.

**Consequence:** The pass surfaces nothing that wasn't already going to be surfaced by automation. The pass's value-add is lost.

**Fix:** Time-box exploration *first*. Suite-readout work uses the leftover. If the budget is so tight that only one is possible, exploration is the higher-value choice (because automation is already running in the pipeline).

### Pitfall 3 — Blanket exploration

**Symptom:** "Let's just poke around the whole release." No charters; no tours.

**Consequence:** The exploration drifts; nobody can tell what was investigated; the same bug is found three times across testers.

**Fix:** Targeted charters — 1-3 surfaces, one tour each. Use the updated risk table to choose. Use [`exploratory-charter`](../exploratory-charter/SKILL.md) discipline.

### Pitfall 4 — Recommendation as vote

**Symptom:** The pass concludes "the team voted 4-2 to release."

**Consequence:** Releases become political. Engineers and PMs outvote testers because there are more of them. The tester role becomes ceremonial.

**Fix:** The tester issues a single professional recommendation, supported by evidence. The release decision can override it; that override is recorded with reasoning. Votes don't enter the pass.

### Pitfall 5 — No condition for change

**Symptom:** Recommendation is HOLD; no specific condition under which it flips to GO.

**Consequence:** The pass becomes a blocker without an exit ramp. The team escalates politically rather than fixing.

**Fix:** HOLD recommendations name specific blockers and a flip condition ("GO once BUG-1302 + BUG-1305 are fixed and the suite re-runs green").

### Pitfall 6 — Pass theatre

**Symptom:** Pass artifacts are produced but no follow-ups are tracked; the same gaps recur release after release.

**Consequence:** The pass becomes ceremony. The team loses confidence in the practice.

**Fix:** Every pass produces a follow-ups inventory; each item has an owner and an issue tracker entry. Next pass starts by reading the previous pass's follow-ups.

### Pitfall 7 — Skipping the post-mortem connection

**Symptom:** A release goes out; an incident happens; the post-mortem doesn't reference the pass.

**Consequence:** The pass is treated as detached from incident learning. The harness fails to compound.

**Fix:** Post-mortems for incidents on released code start by reading the pass. If the pass missed it, what charter would have caught it? That charter goes into the next pass.

### Pitfall 8 — One-tester god mode

**Symptom:** The lead tester runs the pass solo on every high-stakes release. Burnout follows; bus factor of one.

**Consequence:** When the lead tester is unavailable, the pass degrades. Knowledge concentrates.

**Fix:** Pair on charters where it makes sense (Pyhäjärvi); rotate the lead role; treat the pass as a team practice with one named lead per release.

## References

- **James Bach & Michael Bolton** — Session-Based Test Management; the RST methodology that frames release-readiness as evidence-based investigation. See `roles/tester/sources.md`.
- **Jez Humble & David Farley** — *Continuous Delivery* (2010); pipeline as evidence; release-readiness as a property of the pipeline + complementary human work.
- **Lisa Crispin & Janet Gregory** — *Agile Testing* (2009); *More Agile Testing* (2014); release-readiness as a whole-team concern.
- **Google SRE** — *Site Reliability Engineering* (2016, eds. Beyer, Jones, Petoff, Murphy), ch. 8 (Release Engineering) and ch. 15 (Postmortem Culture).
- **Maaret Pyhäjärvi** — *Exploratory Testing* (2017); ensemble exploration as antidote to single-tester god mode.
- **Related Hornero skills:**
  - [`test-plan`](../test-plan/SKILL.md) — pulled into the pass at step 2; updated at step 5.
  - [`exploratory-charter`](../exploratory-charter/SKILL.md) — produced at step 3.
  - [`regression-test`](../regression-test/SKILL.md) — produced from bugs filed during the pass.
  - `skills/multi-role-review/SKILL.md` — for releases that warrant cross-role review (security-expert + tester + product-manager); the pass is the tester's contribution.
  - `skills/extract-lesson/SKILL.md` — the pass's follow-ups feed lessons back into the harness.
