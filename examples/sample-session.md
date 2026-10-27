# Sample session — Hornero in real use

Annotated walkthrough of a single PM session. Synthesised from typical patterns, not from a specific recorded transcript. The goal: show what a productive Hornero session feels like in the current PM-only scope, not just what the methodology prescribes.

> **Setup assumption.** Session runs inside a project whose `CLAUDE.md` has the Hornero dispatcher protocol wired up, with `CATALOG.md` up to date and the `product-manager-reviewer` subagent available under `~/.claude/agents/`. Without that setup the agent can still do the work — it just costs more prompt explicitness.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role (`product-manager`) plus six cross-role process skills. The multi-role example sessions that previously lived here — a four-role dispatcher critique and a four-role PM-orchestrated launch — are preserved in git history and will return when the relevant non-PM roles are restored. See [`../ROADMAP.md`](../ROADMAP.md).

---

## Session — PRD critique on the cohort-duplicate fix

### Setup

**Project:** A B2B SaaS analytics tool. A senior engineer has surfaced a bug: about 0.4% of "cohort definitions" produced by the audience builder end up duplicated under different IDs. The Eng manager wants the team to ship a fix this sprint and has handed the PM a one-paragraph problem description.

**Today's task (user message #1):**

> *"Critique this PRD draft and tell me if it's ready to hand to engineering. It's the cohort-duplicate fix the eng manager mentioned on Monday — I drafted it in 20 minutes between meetings. Be antagonistic."*

(Attached: a 1-page PRD with sections "Problem", "Goal", "Out of scope", "Success criteria", "Open questions".)

### Turn 1 — dispatch

The dispatcher fires. The agent reads `CATALOG.md`, matches the prompt against role triggers, and declares its choice in one line:

> *"Adopting `product-manager` / `prd` (reviewer mode) — prompt is critique of an existing PRD draft. Broad pass first, then severity-rank the top concerns."*

The user can redirect with one word here. They don't — the choice is correct.

### Turn 2 — memory check

Per the reviewer agent's preamble, the first thing it does is run `memory-query` against `memory/decisions/`:

```
> Memory check: scanning memory/decisions/ for {cohort, duplicate, audience-builder, success-metric} ...

Found 1 matching record: 2026-02-12-activation-not-engagement
  (status: committed, revisit_after: 2026-08-12)
  scope: success metrics, activation-shape patterns, gaming/Goodhart risk
```

The record names a *committed posture* on what counts as a valid activation-shape success metric — and explicitly rejects activity-volume metrics (WAU, DAU, "edits per session") on Goodhart grounds. The reviewer flags this upstream of the review proper.

### Turn 3 — the antagonistic critique

The reviewer adopts producer-mode `prd`-anatomy as the lens (Problem · Goal · Out-of-scope · Success criteria · Open questions) and runs a broad pass first, then drills into the top concern.

**Top 3 problems with the draft, severity-ranked:**

**1. The success criterion is gameable, and a prior decision says so explicitly. (High severity.)**

The draft proposes "duplicate cohort count drops to <0.1% within 30 days". Two problems:

- **Goodhart.** The audience builder team owns both the metric *and* the surface that produces duplicates. A simple way to drop "duplicate count" is to relax the duplicate-detection criterion (e.g., normalise less aggressively before fingerprinting). The metric drops; the underlying bug persists. The prior decision (`2026-02-12-activation-not-engagement`) named exactly this gaming pattern.
- **No counter-metric.** The PRD has no instrumented signal that would catch the relaxed-detection failure mode. The committed posture from 2026-02 is: every activity-shape metric needs a counter-metric naming the failure mode it could mask. The PRD has none.

**Recommendation:** restate as a *behavioural outcome* — "users surface ≤1 cohort with identical event-sequence definition per workspace, measured by post-hoc dedupe against the user-named-cohort corpus, with a counter-metric of `cohort_creation_abandonment_rate` (catches over-aggressive dedupe driving users to give up on the builder)". Cite the prior decision in the References section.

**2. "Out of scope" hides the load-bearing call. (Medium severity.)**

The "Out of scope" line says *"This PRD does not cover the design of the in-app warning shown when a near-duplicate is detected."* That's not out of scope — it's the call. Either the fix is purely backend (no warning, dedupe silently before save) or it's a user-facing change (warn the user mid-creation and let them decide). The behavioural target in the success criterion only makes sense under one of these two postures.

**Recommendation:** name the posture in the Goal section. If silent backend dedupe: state it explicitly. If user-facing warning: name the UX surface (with a follow-up ticket for the designer, who will return on Hornero re-expansion). The PRD cannot stay ambiguous on this and still be hand-off-ready.

**3. The Problem section starts from the solution. (Low severity, but corrosive.)**

The draft's Problem section reads: *"The audience builder produces duplicate cohort definitions because the fingerprinting normalisation differs between creation and save."* That's a hypothesis, not a problem statement. The problem is that users see two cohorts they think are different, end up running redundant analyses, and lose trust in the tool. The fingerprinting normalisation is one possible root cause; there may be others (e.g., a race in the save endpoint).

**Recommendation:** rewrite the Problem section in jobs-to-be-done shape (use the [`jobs-to-be-done`](../skills/jobs-to-be-done/SKILL.md) skill for the rewrite). Move the fingerprinting-normalisation hypothesis to a separate "Working hypothesis" section that the implementing engineer is free to falsify.

### Turn 4 — synthesis

The reviewer ends with a ranked recommendation:

> *Hand-off readiness: **not yet**. Three changes before this PRD ships to engineering — (1) restate the success criterion with a counter-metric, citing the 2026-02 prior decision; (2) name the silent-vs-warning posture in the Goal section; (3) rewrite the Problem section as a user-facing problem with the fingerprinting hypothesis split out. (1) is the unblock; (2) and (3) are quality. The 2026-02 record's posture still holds — this session reaffirms it. Updated the record's `validated-by` line with a pointer back to this PRD.*

### Turn 5 — extract-lesson

The user accepts the critique, makes the three changes, and ends the session. Before they go, they invoke `/extract-lesson`:

> *"Surprises and corrections in this session worth capturing as durable updates?"*

The agent scans the transcript and proposes one update:

> *"The PRD draft started with a hypothesis-shaped Problem section ('the fingerprinting normalisation differs…'). This is the second time in two months a PRD has done this — the previous instance was the `weak-prd.md` seeded fixture in `tests/seeded/`. Worth strengthening the `prd` skill's Common Pitfalls section: explicitly call out 'Problem-as-hypothesis' as a failure mode, with the JTBD-rewrite as the corrective."*

The user accepts. The agent makes the edit, runs `scripts/validate-skill.sh skills/prd/SKILL.md` (passes), and stops. The lesson is now durable — the next PRD draft in any project will get critiqued against this pitfall.

---

## What this session demonstrated

- **Dispatcher → declare → load.** The agent matched the prompt against `CATALOG.md`, declared `product-manager` / `prd` in one line, then loaded the skill file. User could have redirected with one word.
- **Memory check before reviewing.** The reviewer agent's first move was `memory-query`. The prior 2026-02 decision was load-bearing — without it, the top-severity finding would have been weaker and the session would have re-derived the Goodhart argument from scratch.
- **Reviewer-mode discipline.** Broad pass first ("top 3 problems"), then severity-rank, then drill into the top one. Not an exhaustive line-by-line.
- **Synthesis as decision recommendation.** "Hand-off readiness: not yet. Three changes…" — the synthesis is a *decision*, not a recap of findings.
- **Lesson-extraction at session end.** The recurring pitfall ("Problem-as-hypothesis") became a durable update to the `prd` skill. Without `/extract-lesson`, the harness doesn't compound.

## What this session did *not* demonstrate

- **Multi-role fan-out.** With Hornero currently PM-only, every "fan out" path resolves to a single PM lens. When non-PM roles are restored (see [`../ROADMAP.md`](../ROADMAP.md)), `/orchestrate` re-engages multiple reviewers in parallel, names conflicts, and synthesises a cross-functional decision. The multi-role example sessions previously documented here will return at that point.
- **Producer mode end-to-end.** The session above is reviewer mode (critique an existing PRD). For producer mode (draft a PRD from a problem statement), the agent adopts `product-manager` / `prd` in producer-mode and walks the same anatomy from a blank file — no critique, no severity rank, just the artifact.
- **Cross-functional-orchestration with multiple lenses.** The `cross-functional-orchestration` skill is shipped today, but with only one lens to fan out to, it degenerates to a single PM call. The skill structure is preserved for re-expansion.

## Reading by section

- [`skills/prd/SKILL.md`](../skills/prd/SKILL.md) — the PRD skill the session adopted.
- [`agents/product-manager-reviewer.md`](../agents/product-manager-reviewer.md) — the reviewer subagent's system prompt.
- [`playbooks/memory-loop.md`](../playbooks/memory-loop.md) — the read-decide-write cycle, including the 2026-02 activation-metric example referenced above.
- [`skills/extract-lesson/SKILL.md`](../skills/extract-lesson/SKILL.md) — the lesson-extraction skill invoked at session end.
