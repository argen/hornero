---
name: linear-triage
description: Use when a PM runs the weekly triage pass on a Linear project — re-confirm strategy alignment first, then surface stale work, then trim the cycle scope, so the team's next cycle reflects current strategy with no hidden blockers.
role: product-manager
intent: |
  After this skill runs, the team's next-cycle scope reflects current
  strategy, the queue is an honest representation of reality (no
  rubber-stamped "in progress" issues that haven't moved in weeks), and
  cross-team blockers are surfaced rather than absorbed.
  The readout is the trace; the changed queue + sharper cycle plan are
  the outcome.
type: workflow
theme: discovery-delivery
resources:
  - linear
best_for:
  - Weekly PM triage on a single project
  - Sprint kickoff prep — pruning the cycle scope before commitment
  - Inheriting a project (new PM walking into an unfamiliar queue)
scenarios:
  - "PM running Monday triage on the Onboarding project"
  - "New PM auditing inherited project queues for stale or duplicate work"
  - "Pre-cycle planning — what's actually ready vs. what's wishful"
estimated_time: 20-30 minutes per project
---

# linear-triage — weekly Linear project triage

> v0 draft. Opinionated workflow over the [`linear`](../../resources/linear/RESOURCE.md) resource. Cites Cagan's four-risks, Rumelt's strategy kernel, Torres on continuous discovery, Perri on build-trap-avoidance.

## Purpose

**The problem this addresses.** PMs running weekly triage without a structure default to recency bias — they work the loudest issue, the most-recently-commented thread, the one a senior engineer pinged about in DM. The queue becomes an artefact of attention, not of strategy. After enough weeks, the team is delivering against a queue nobody re-grounded in the project's actual outcome.

This skill is a 20-30 minute structured pass that forces the PM to **re-confirm strategy alignment first**, then triage queue mechanics, in that order. The readout is a trace of what changed; the *outcome* — what the skill is judged against — is whether the team's next cycle ships against the project's stated outcome with fewer hidden blockers.

## Key Concepts

### Strategy alignment is the gating risk (Cagan + Rumelt)

Cagan's first risk is *value*: is this still the right problem? Rumelt's strategy kernel asks whether the diagnosis, guiding policy, and coherent actions still hold. Triage that starts with queue mechanics (stale work, priority distribution) before re-asking the value question optimises a queue that may itself be off-strategy. Gating risk goes first.

### Triage as a recurring discovery touchpoint (Torres)

Torres (*Continuous Discovery Habits*): discovery is a habit, not an event. Weekly triage is when the PM tests whether issues in the queue still match the user problem; issues that no longer match get re-scoped or closed — not in a Q-boundary review, but every week.

### Outcomes over outputs (Perri)

Perri's build-trap: shipped issues are not wins; moved outcomes are. Triage's success criterion is *what changes in the team's behaviour next cycle*, not *what readout exists at the end of the pass*. A readout produced with no queue changes and no cycle scope change is a sign the pass was performative.

### Counter-metric without judgement escape

Goodhart applies: "every issue triaged weekly" optimises for queue surface activity. The counter-metric must be **independently computable from Linear data** — no PM-classification step at measurement time. The metric used here: *median age of issues that have been in a "started" state without a state change*. The number rises when triage misses stale work; it cannot be gamed by re-classifying which issues "should" have moved.

## Application

The pass runs in four numbered steps. Step 1 is the gating risk; if it changes the project's stated outcome, Steps 2-4 happen against the new outcome.

### Step 1 — Strategy alignment (5 minutes, first)

Re-read the project's stated outcome (in its Linear description, or the linked PRD). Pick three active issues at random from the top 20 by priority. For each, ask:

- Does this issue trace to the project's outcome? If you wrote the linkage in one sentence, would it be obvious to someone reading both?
- Is the outcome itself still right, or has the diagnosis shifted (Rumelt: has the *kernel* moved since this project was scoped)?

**Output:** either a one-line confirmation ("outcome still holds, sampled issues all trace") or an *Open question* for the readout ("strategy may have drifted — 2 of 3 sampled issues don't trace; raise in next sync"). If the kernel itself has moved, stop the triage and escalate — the project needs re-scoping, not weekly grooming.

### Step 2 — Stale-work pass (5-10 minutes)

Pull: state.type = started AND updated_at < now - 14d in this project.

For each stale issue, apply the four-risks lens (Cagan):

- **Value risk re-check.** Does this still address the project's outcome? If not, de-scope (move to backlog with reason) or close (with comment).
- **Feasibility risk surfaced as blocker.** Comment thread suggests a blocker? Add `blocked` label, name the blocker + owner, promote to readout.
- **Usability / viability** rarely surface here — these are PRD-stage risks, not weekly triage.

**Never close unilaterally.** "Looks finished — closing if no objection by Friday" is a 10-second comment that buys huge social trust.

### Step 3 — Cycle scope honesty (5 minutes)

Issues already in the current cycle: are they actually being worked, or is the cycle a wishlist? Pull issues in cycle with state.type = unstarted at this point in the cycle window. If > 30% of cycle scope is unstarted past the halfway point, the cycle was over-committed. Surface in the readout.

For top-priority issues *not yet in cycle*: at the current capacity, will any of these enter the next cycle? If not, the project's effective velocity against its outcome is slower than the queue implies. Surface.

### Step 4 — Write the readout (5 minutes)

Pinned comment on the project (or a fresh issue tagged `triage-readout` with date). Template:

```markdown
# Triage readout — <project> — <YYYY-MM-DD>

## Strategy alignment
<One line: still aligned / drift suspected / kernel moved.>

## What moved
- <issue>: <status change + 1-line context>

## What's blocked
- <issue>: blocker is <X>; owner to unblock: <name>; expected: <date>

## Stale and de-scoped
- <issue>: moved to backlog because <reason>
- <issue>: closed because <reason>

## Cycle scope honesty
<One line: cycle on track / over-committed by N issues / under-loaded.>

## Open question
<One question for the team this week.>
```

A readout longer than two minutes to read indicates rubber-stamping, not triage. If you wrote eight bullets under *What moved*, you ran out of time before prioritising — note that explicitly and tighten next week.

## Examples

### Example 1 — Strategy drift caught at Step 1

**Sampled issues against the *Conversion* project's stated outcome ("activation rate 22% → 30%"):**

1. Activation funnel A/B test — traces.
2. Admin dashboard polish — does not trace.
3. Retention email cadence experiment — does not trace.

Two of three off-strategy. The readout's *Open question* leads: *"Either we cut (2) and (3) from this project, or the project's outcome has expanded and the PRD needs updating. Raise in Wednesday sync."* The remaining triage steps run, but the lead finding from this triage is structural, not queue-mechanical.

### Example 2 — Stale-work as a people problem

**Step 2 returns 6 stale issues. Pattern:** 4 of 6 are assigned to the same engineer; latest comment on each is 3-5 weeks old.

The readout names this as a *question for the team lead*, not four separate stale-work entries. The actual finding is "engineer X is overloaded or blocked," not "queue hygiene is bad." Treating the four stale issues as independent items would have surfaced a queue problem; treating them as one signal surfaces a delivery problem.

### Example 3 — Cycle over-commit revealed at Step 3

**Step 3 pull:** current cycle has 11 issues; at day 7 of 14, 6 are still `unstarted`.

That's 55% unstarted past the halfway mark. Either capacity was over-estimated at cycle start, or scope changed mid-cycle. The readout's *Cycle scope honesty* line: *"Over-committed by ~5 issues this cycle. For next cycle commitment, propose 6 issues, not 11. If that's not enough scope to ship the milestone, the milestone date itself needs to move."*

## Common Pitfalls

### Pitfall 1 — Skipping Step 1 because "we know the strategy"

**Symptom:** PM jumps to stale-work pass because the strategy hasn't been discussed in a while.

**Consequence:** Queue mechanics get optimised against a stale strategy. The team ships against a queue that no longer reflects the project's actual outcome.

**Fix:** Step 1 is non-negotiable, and is 5 minutes — not 30 seconds. If the sampled issues all trace cleanly, you've done minimal work *and* confirmed alignment. If they don't, you've caught a structural problem in week one rather than month three.

### Pitfall 2 — Triage as queue maintenance

**Symptom:** Triage devolves into "every issue touched once a week."

**Consequence:** Optimises for surface activity over actual progress. The counter-metric (median age of "started" issues without state change) gets worse, not better, because attention is spread thin.

**Fix:** Cap the triage at 30 minutes. Force prioritisation of what to look at. If you can't get through the whole queue, the cap is doing its job — note what was deferred and address next week.

### Pitfall 3 — Counter-metric drift via re-classification

**Symptom:** When the counter-metric (median stale age) is bad, the PM re-classifies issues as "not supposed to move" to bring it down.

**Consequence:** The metric becomes unfalsifiable. The team can't tell if triage is working.

**Fix:** The counter-metric is *median age of "started" issues without a state change in N days* — computed directly from Linear, no PM-classification step. The metric is the metric.

### Pitfall 4 — Cagan citation without Cagan application

**Symptom:** Skill cites the four-risks framework but Step 2 never actually applies it — value/feasibility/usability/viability are named in the docs but the stale-work pass treats every issue as a generic "stale or not" call.

**Consequence:** Citation becomes credentialing. The lens isn't actually doing work.

**Fix:** Step 2 names value re-check and feasibility-as-blocker explicitly. Usability and viability rarely surface in weekly triage (they're PRD-stage risks) — that asymmetry is honest, not a gap.

### Pitfall 5 — Readout produced but queue unchanged

**Symptom:** Triage runs, readout posted, no issues moved or de-scoped or labelled. The outcome statement (`intent`) is unmet.

**Consequence:** Triage becomes a status ritual rather than a prioritisation tool. The team learns to ignore the readout because it never changes what they do next.

**Fix:** If a triage produces a readout without at least one queue change (state moved, label added, scope de-/re-scoped, comment added that resolves an ambiguity), that's the signal — triage was either premature (everything was already in order — possible but rare) or performative (more likely). Note it and tighten next week.

## References

- **Marty Cagan** — *Inspired*; the four-risks lens applied in Step 2. See `roles/product-manager/sources.md`.
- **Richard Rumelt** — *Good Strategy / Bad Strategy*; the kernel test (diagnosis, guiding policy, coherent actions) underwrites Step 1's strategy alignment pass.
- **Teresa Torres** — *Continuous Discovery Habits*; triage as a recurring discovery touchpoint, not a Q-boundary event.
- **Melissa Perri** — *Escaping the Build Trap*; outcomes over outputs — the *intent* statement is outcome-shaped, not artifact-shaped.
- **Goodhart's law** — for the counter-metric framing; counter-metric must be independently computable, not PM-classified at measurement time.
- **Resources used:** [`resources/linear/RESOURCE.md`](../../resources/linear/RESOURCE.md).
- **Related Hornero skills:**
  - `skills/prd/SKILL.md` — the artifact a triage outcome often updates (when Step 1 surfaces drift).
  - `skills/strategy-kernel/SKILL.md` — when Step 1's kernel test fails, escalate here.
  - `skills/prioritization-advisor/SKILL.md` — when Step 2's value-risk re-check needs a deeper lens.
  - `skills/memory-query/SKILL.md` — check prior triage decisions before re-litigating.
