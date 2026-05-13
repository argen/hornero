---
name: pre-launch-marketing-audit
description: Use when a launch is approaching cut and a CMO needs a disciplined pass over positioning, narrative, the launch brief, channel readiness, and measurement design — producing a Go / Fix-then-go / Hold recommendation.
intent: |
  A workflow skill that orchestrates the marketing-expert role's
  component skills — positioning-canvas, strategic-narrative,
  launch-brief — and adds channel-readiness and measurement-design
  audits. Mirrors the tester role's pre-release-test-pass and the
  security-expert's pre-launch-security-audit so the three pre-
  launch workflows can run as siblings for cross-functional
  launches. Resists three launch-time failure modes: positioning-
  drift between artifacts, awareness-vs-activation confusion at
  measurement time, and "the date is fixed" overriding audit
  findings.
type: workflow
theme: launch-execution
best_for:
  - High-stakes launches (revenue-affecting, category-defining, board-visible)
  - First-time public launches where the brand has no track record
  - Re-launches after repositioning
  - Cross-functional launches where marketing, product, sales, and customer success all ship simultaneously
  - Annual strategic refreshes that double as launches
scenarios:
  - "Pre-launch audit of LedgerStack v2 GA (mid-market scale-up CFO segment)"
  - "Pre-launch audit of a developer-tool repositioning from individual to engineering-manager buyer"
  - "Pre-launch audit before a Series B announcement that includes a category-creation narrative"
  - "Annual pre-event audit before the company's user-conference keynote"
estimated_time: 1-2 days (small launch); 1-2 weeks (major launch)
---

# Pre-launch marketing audit (workflow)

> v0 draft. A workflow that composes [`positioning-canvas`](../positioning-canvas/SKILL.md), [`strategic-narrative`](../strategic-narrative/SKILL.md), and [`launch-brief`](../launch-brief/SKILL.md). Grounded in April Dunford's *Sales Pitch* on cascading positioning across surfaces, Byron Sharp's *How Brands Grow* on penetration and availability, Mark Ritson's diagnose-strategy-tactics sequencing, Bob Hoffman on attribution honesty, and the Google SRE release-engineering tradition for the audit-and-readiness discipline that this skill imports from the engineering side of Hornero.

## Purpose

Run a disciplined marketing pass before a launch goes live, producing:

1. **A re-confirmed positioning canvas** — anchored to current evidence; alignment with the launch brief verified.
2. **A re-confirmed strategic narrative** — current, audience-tested, deployed consistently across surfaces.
3. **A reviewed launch brief** — channels evidence-backed, KPIs honest, out-of-scope agreed.
4. **A channel-readiness check** — instrumentation, assets, sales-enablement, embargoed press all confirmed.
5. **A measurement-design audit** — data-scientist has confirmed validity; attribution biases stated; readout cadence in place.
6. **A launch recommendation** — Go / Fix-then-go / Hold with evidence.

The workflow is the marketing-side complement to the tester's [`pre-release-test-pass`](../../../tester/skills/pre-release-test-pass/SKILL.md) and the security-expert's [`pre-launch-security-audit`](../../../security-expert/skills/pre-launch-security-audit/SKILL.md). The three follow the same shape (frame → re-confirm upstream artifacts → execute → audit → synthesise → recommend) deliberately — different lenses, common discipline.

For cross-functional launches, the three workflows run in parallel; the lead agent (orchestrator) synthesises across the three recommendations.

## Key Concepts

### The launch is the cascade's stress test

The workflow's central insight: a launch is when positioning, narrative, channel strategy, and measurement collide with reality. Misalignments invisible at planning become visible at launch — but only if someone audits before launch rather than after.

The skill exists to surface misalignments while they are cheap to fix.

### Re-confirm, don't re-author

The audit re-confirms the upstream artifacts; it doesn't rewrite them. The questions:

- Has the positioning canvas's evidence basis aged out? (Customer interviews older than 12 months; win-loss data older than 6.)
- Does the strategic narrative still match where the company is, the market is, the audience is?
- Does the launch brief inherit cleanly from canvas + narrative, or has there been drift?
- Are downstream surfaces (homepage, sales deck, press kit, keynote, product copy) consistent with each other and with the narrative?

If a major drift surfaces, the audit pauses while upstream artifacts refresh — the launch doesn't ship on top of stale positioning.

### Channel-readiness is operational, not strategic

The audit's channel-readiness check is the boring half: is instrumentation tested? Are assets produced? Is the sales team enabled? Are embargoed press cycles confirmed?

Skipping channel-readiness is the most common path to a launch that's strategically sound but operationally botched — the homepage flips at T but the sales team hasn't been briefed, or the campaign tracking is broken, or the embargoed press story drops on the wrong day.

### Measurement-design audit

Hoffman's attribution honesty applied operationally: data-scientist reviews the launch brief's KPI table before launch. Common issues:

- **Last-click attribution under-counts awareness work.** The brief states this; the audit confirms.
- **Survey-based recall depends on sample size and recency.** The audit checks the n.
- **Multi-touch attribution is model-dependent.** The audit names which model and what's known about its biases.
- **Brand-search lift requires baseline + control.** The audit checks they're in place.

If measurement design has gaps the audit can't close, those become Warnings the readout will reflect (not silent gaps).

### Recommendation discipline

Same as the security and tester workflows: a single Go / Fix-then-go / Hold recommendation, supported by findings, defensible. The team can override (recorded with reasoning), but the recommendation is the CMO's professional output, not a vote-counting exercise.

### Cross-functional launches: three audits, one synthesis

For launches that ship across functions, the marketing audit runs in parallel with the security audit and the testing pre-release pass. Each function's lead produces a recommendation; the orchestrator (CMO + CRO + CTO, or a single launch-lead) synthesises:

- Are the three recommendations compatible? (Three GO's is easy; mixed recommendations require explicit reconciliation.)
- Where do the audits surface contradictions? (Marketing wants to position around a feature security flagged for late patching.)
- What's the unified Go-condition for the launch?

The orchestrator does the synthesis; subagents (lead from each function) produce inputs.

## Application

The workflow has six steps. Small launch: 6-10 hours, single CMO. Major launch: 1-2 weeks, with parallel work from designer (assets), data-scientist (measurement), and sales (enablement).

### Step 1 — Frame the audit (30-60 minutes)

State:

- **Launch scope.** What's launching, when, to whom.
- **Primary mode.** Awareness, activation, or mixed split.
- **Stakeholders.** Who receives the recommendation; who can override.
- **Time-box.** When is the cut; when is the audit due; what's the rework window if Fix-then-go.
- **Pre-reads.** Positioning canvas, strategic narrative, launch brief, prior post-launch readouts.

Output: a one-page audit charter.

### Step 2 — Re-confirm positioning canvas (45-90 minutes)

Using [`positioning-canvas`](../positioning-canvas/SKILL.md):

- Re-read the canvas. Mark each of the five components with: current / aged-out / contested.
- Check evidence basis. Are customer interviews <12 months? Win-loss data <6 months? If aged, refresh before launch.
- Re-walk the anti-positioning self-check (could a competitor swap names?).
- Check downstream surfaces (homepage, sales deck) against the canvas. Drift = finding.

Output: confirmation or refresh notes; if refresh needed, schedule it and pause the audit.

### Step 3 — Re-confirm strategic narrative (45-90 minutes)

Using [`strategic-narrative`](../strategic-narrative/SKILL.md):

- Re-read the narrative. Does it still match where the company / market / audience is?
- Check evidence (named customers): still reachable? Still current?
- Audit downstream surfaces — homepage, keynote, investor deck, sales deck — for narrative consistency. Drift = finding.
- Run the retell-check on a fresh listener: can they recall the five beats?

Output: confirmation or refresh notes.

### Step 4 — Audit the launch brief (60-120 minutes)

Using [`launch-brief`](../launch-brief/SKILL.md):

- Walk the brief end-to-end. Are all sections present and substantive?
- Channel evidence: each channel cites evidence? Trend-flavoured channels right-sized?
- Attribution honesty: KPIs as ranges, methods stated, biases acknowledged?
- Out-of-scope: explicit? Agreed with founders / CRO / CEO?
- Sequence: pre-launch / launch moment / sustain / iteration phases stated, with owners?

Output: brief-level findings; gaps named.

### Step 5 — Channel-readiness + measurement-design (90-180 minutes)

A targeted checklist walk. For each launch component:

```markdown
## Channel readiness

| Item | Required? | Ready? | Tested? | Evidence | Notes |
|---|---|---|---|---|---|
| Positioning canvas approved | Y | Y | n/a | <link, date> | |
| Strategic narrative approved | Y | Y | n/a | <link, date> | |
| Distinctive-asset continuity verified | Y | Y | n/a | designer sign-off <date> | |
| Sales team enabled with narrative-shaped pitch | Y | Y | Y | workshop <date>; pitch deck v2.3 | |
| Customer references confirmed (N=…) | Y | Y | Y | 4 case studies + 3 reference-call agreements | |
| Analyst briefings booked | Y | Y | n/a | Gartner T-21; Forrester T-18 | |
| Embargoed press cycle confirmed | Y | Y | n/a | TechCrunch, The Information | |
| Distinctive-asset rollout schedule | Y | Y | n/a | designer-owned; calendar in /launch-assets | |
| Homepage flip prepared + reviewed by designer + a11y | Y | Y | Y | staging URL; design-review approved <date> | F-007 noted: alt-text gap on hero image |
| Sales-deck v2 distributed to all reps | Y | Y | Y | deck v2.3 in /sales-decks; reps acknowledged | |
| In-product launch announcement copy approved | Y | Y | n/a | <link> | |
| Customer-success outbound email approved | Y | Y | n/a | <link> | |
| Founder podcast tour episodes recorded | Y | Y | n/a | 3 episodes; release calendar | |
| Community partnership / sponsorship confirmed (CFO Connect) | Y | Y | n/a | sponsorship doc; AMA scheduled T+3 | |
| Outbound campaign targeting list (200 named accounts) | Y | Y | Y | list reviewed by CRO; ICP-fit verified | |
| Email-list segmentation reviewed | Y | Y | Y | data-scientist <date>; UTM scheme tested | |

## Measurement design

| KPI | Mode | Baseline confirmed? | Instrumentation tested? | Attribution method documented? | Data-scientist approved? | Notes |
|-----|------|---------------------|-------------------------|-------------------------------|--------------------------|-------|
| Brand recall (target CFO segment) | Awareness | Y (Sep 2025 survey n=200) | n/a (next survey scheduled) | Survey-based, top-of-mind bias | Y | OK |
| Inbound demo requests | Activation | Y (CRM 8-week trailing avg) | Y | CRM first-touch + UTM | Y | F-011 noted: LinkedIn-attribution lag of 48-72h; readout schedule adjusted |
| G2 review count | Awareness/activation | Y | Y | G2 platform native | Y | OK |
| Pipeline-weighted ARR from launch | Activation | Y | Partial | Multi-touch (4-touchpoint model) | Partial | F-012 noted: multi-touch model under-counts awareness; data-scientist proposes parallel last-click view |
| Acquisition-segment conversion rate | Activation | N (new segment) | Y | CRM cohort | Y | F-013: no baseline; first 90 days are calibration, not measurement |
| Brand-search lift | Awareness | Y (4-week baseline) | Y | Google Search Console with control | Y | OK |
```

Output: a readiness + measurement table with gaps named as findings.

### Step 6 — Synthesise and recommend (30-60 minutes)

Combine the canvas confirmation, narrative confirmation, brief audit, and readiness check. Three categories:

- **Blockers** — positioning drift, narrative inconsistencies across surfaces, measurement-design gaps that would make the launch unreadable, missing required channel-readiness items. Launch held.
- **Warnings** — findings that don't block but should be tracked through launch (small drift; some attribution lag; minor sales-enablement follow-ups).
- **Follow-ups** — post-launch work (T+30 / T+90 readout artifacts; lessons-extract).

Issue the recommendation:

```markdown
# Pre-launch marketing audit — <launch name>

- **Lead:** <CMO / Head of Marketing>
- **Date:** <YYYY-MM-DD>
- **Launch:** <YYYY-MM-DD>
- **Primary mode:** Awareness | Activation | Mixed
- **Recommendation:** GO | FIX-THEN-GO | HOLD

## Summary

<3-5 sentences. The recommendation, the headline reasoning, the
condition for change. Cross-functional flag if joining
security-expert or tester audits.>

## Positioning canvas confirmation

<Status; refresh notes; surfaces audited for consistency.>

## Strategic narrative confirmation

<Status; retell-check result; downstream-surface audit.>

## Launch brief audit

<Brief-level findings; channel evidence summary; attribution honesty
status.>

## Channel readiness

<The readiness table; gaps cross-referenced to findings.>

## Measurement design

<The measurement table; data-scientist sign-off status.>

## Blockers

| F# | Description | Reference | Owner | Target |
|---|---|---|---|---|

## Warnings

<Tracked through launch; not blocking.>

## Follow-ups

<Post-launch readout artifacts; lessons-extract triggers.>

## Cross-functional coordination

<If running in parallel with security-expert or tester pre-launch
workflows, the synthesis notes from the orchestrator.>

## Acceptance

<Sign-off from named recipients.>
```

The recommendation is circulated; stakeholders can override with reasoning recorded. Artifacts are committed to the marketing-docs repo.

## Examples

### Example 1 — A disciplined launch audit (sketch)

**Launch:** LedgerStack v2 GA, 2026-02-04. Audit: 2026-01-25 to 2026-01-29 (5-day box).

**Step 2 — Positioning canvas re-confirm.** Canvas approved 2025-09-15; evidence basis at 22 interviews + 18-month win-loss; surfaces audited (homepage, sales deck, press kit, keynote draft) and one drift found — the press kit headline read "the modern accounting platform" rather than "accounting for multi-entity B2B." Press kit revised T-9.

**Step 3 — Narrative re-confirm.** Narrative approved 2025-10-22; retell-check with a Pavilion CFO-Connect member confirmed all 5 beats recall correctly. Homepage hero copy ages back to v0.9; refreshed to current narrative wording. Investor-deck opening 3 slides confirmed to match.

**Step 4 — Launch brief audit.** Brief approved; channel evidence solid except for the TikTok exploratory experiment (acknowledged, small budget, learning goal stated — OK). One attribution gap surfaced — pipeline-weighted ARR uses multi-touch; data-scientist flagged that the model under-counts awareness work. Resolved: parallel last-click view for transparency.

**Step 5 — Channel readiness + measurement design.**
- Most items green. Five findings:
  - F-007: homepage hero image alt-text gap (a11y — flagged to designer; not blocking but should land T-3).
  - F-011: LinkedIn attribution lag 48-72h; readout T+14 adjusted accordingly.
  - F-012: multi-touch model under-counts awareness; data-scientist provides parallel view.
  - F-013: acquisition-segment conversion rate has no baseline; first 90 days are calibration, not measurement (state in the readout plan).
  - F-018: sales-deck v2.3 distributed but one rep (Aisha) hasn't acknowledged; CRO follow-up.

**Step 6 — Recommendation: GO with warnings.** Press kit revised; remaining findings tracked through launch but not blocking. T+30 readout will close F-013 as "calibration period complete" and shift to measurement. Cross-functional coordination: tester role's pre-release pass is also GO with warnings (a separate small a11y gap that designer is fixing the same week); security-expert's pre-launch audit was GO at T-21. All three sign off T-3.

Circulated 2026-01-29 11:00; CEO + CRO accept; launch proceeds 2026-02-04.

### Example 2 — Failure mode (bad)

```markdown
# Pre-launch audit
- Positioning: looks good.
- Narrative: looks good.
- Brief: looks good.
- Recommend: GO.
```

Failures: no scope statement; no canvas / narrative re-confirmation against evidence; no channel readiness check; no measurement design audit; no findings; recommendation without evidence. The launch will run; the team will not learn from it.

## Common Pitfalls

### Pitfall 1 — Skipping positioning / narrative re-confirmation

**Symptom:** Audit jumps straight to channel readiness; assumes canvas + narrative are current.

**Consequence:** Drift between artifacts and downstream surfaces ships at launch. Sales tells one story, marketing tells another, the homepage tells a third.

**Fix:** Re-confirm both upstream artifacts. Even 30 minutes catches the most common drift (press kit, homepage, sales deck wandering from canon).

### Pitfall 2 — Channel-readiness as inventory

**Symptom:** Channel-readiness table is filled with "Y / Y / Y" without evidence.

**Consequence:** Controls listed as "ready" turn out to be broken at launch (instrumentation untested, sales team unbriefed, embargoed press wrong date).

**Fix:** Each readiness item cites evidence — date of sign-off, link to artifact, name of person who verified. "Ready" without evidence is "not ready."

### Pitfall 3 — Measurement audit skipped

**Symptom:** Measurement design is part of the brief; data-scientist hasn't reviewed it; audit treats it as in scope.

**Consequence:** Launch goes live; data is unreadable, attribution is contested, the readout is "we think it worked but the numbers are noisy."

**Fix:** Data-scientist sign-off is mandatory before audit Approval. If data-scientist surfaces issues, they become Warnings or Blockers; not glossed.

### Pitfall 4 — Trend-chasing channel pass-through

**Symptom:** Brief includes a fashionable channel with weak evidence; audit doesn't flag it.

**Consequence:** Budget allocated to channel that doesn't fit; spend reports as "investment" but performance is poor; next launch repeats.

**Fix:** Audit re-checks each channel's evidence basis. Trend-flavoured channels right-sized to exploratory budgets with learning goals; if budgets are out of proportion, audit flags.

### Pitfall 5 — Out-of-scope ignored

**Symptom:** Brief has clear out-of-scope; audit doesn't verify alignment with CEO / CRO; mid-launch scope creep happens.

**Consequence:** Sales pursues out-of-scope segments because nobody re-confirmed the agreement; pipeline quality degrades; lessons get blurred.

**Fix:** Audit confirms out-of-scope is *recently* agreed with named stakeholders. "Agreed in October" doesn't count for a February launch unless re-acknowledged.

### Pitfall 6 — Recommendation by political will

**Symptom:** Audit found Critical issues; recommendation is GO because the launch date is fixed.

**Consequence:** Audit authority erodes. Team learns the audit doesn't actually block. Real risk ships.

**Fix:** Recommendation by evidence. If political override happens, it's logged as explicit override with reasoning — the CMO's recommendation stands as the professional output.

### Pitfall 7 — No post-launch readout planned

**Symptom:** Audit ends at launch moment; no T+30 / T+90 / T+180 readouts scheduled.

**Consequence:** Lessons never compound. Next launch repeats the same misjudgements.

**Fix:** Readout schedule and ownership stated in the audit recommendation itself.

### Pitfall 8 — Three audits in isolation

**Symptom:** Marketing, security, tester each run their pre-launch audit; no orchestrator synthesises across them; contradictions surface mid-launch.

**Consequence:** Marketing positions around a feature security flagged for delayed patch. Tester held the release for a bug marketing's launch references. Synchronisation fails at the worst moment.

**Fix:** For cross-functional launches, an orchestrator (CMO + CRO + CTO, or single launch lead) synthesises the three audits and produces one unified Go-condition. The three workflows run in parallel; the synthesis is centralised.

## References

- **April Dunford** — *Obviously Awesome* (2019); *Sales Pitch* (2023). The positioning + sales-pitch cascade. See `roles/marketing-expert/sources.md`.
- **Andy Raskin** — strategic-narrative methodology; ensures the audit's narrative re-confirmation has substance.
- **Byron Sharp** — *How Brands Grow* (2010); the awareness-vs-activation distinction governing measurement audit.
- **Mark Ritson** — strategic-then-tactical sequencing; the audit's order (canvas → narrative → brief → readiness → measurement).
- **Bob Hoffman** — attribution honesty discipline; the measurement-audit's central spine.
- **Google SRE** — *Site Reliability Engineering* (2016), ch. 8 (Release Engineering); the audit-and-readiness model imported across the three Hornero pre-launch workflows.
- **Related Hornero skills:**
  - [`positioning-canvas`](../positioning-canvas/SKILL.md) — re-confirmed at step 2.
  - [`strategic-narrative`](../strategic-narrative/SKILL.md) — re-confirmed at step 3.
  - [`launch-brief`](../launch-brief/SKILL.md) — audited at step 4.
  - `roles/security-expert/skills/pre-launch-security-audit/SKILL.md` — sibling workflow for cross-functional launches; same shape.
  - `roles/tester/skills/pre-release-test-pass/SKILL.md` — sibling workflow for cross-functional launches; same shape.
  - `skills/multi-role-review/SKILL.md` — orchestrates this audit with engineer / tester / security-expert perspectives for the highest-stakes launches.
  - `skills/extract-lesson/SKILL.md` — post-launch readouts feed lessons back into the canvas and the next launch's brief.
