---
name: context-reset-check
description: Use when a session feels stuck — detects context drift, repeated rework, contradictory outputs, and recommends resetting with a fresh tight brief.
intent: |
  Implements Chris MDP's "context sweet spot" principle. Long sessions
  accumulate noise; the model drowns; quality degrades silently. This
  skill names the drift signals, diagnoses the cause, and recommends
  what to carry forward into a fresh session.
type: interactive
theme: harness
best_for:
  - Sessions running long (>60 messages or >1 hour)
  - Sessions where the same kind of error keeps recurring
  - Sessions where the agent contradicts earlier-in-session statements
  - When the user feels stuck but can't say why
scenarios:
  - "Session has gone 90 minutes; same TypeScript error keeps reappearing in different forms"
  - "Agent's third attempt at the same refactor introduces a regression the first attempt fixed"
  - "Trying to wrap up a feature but each new request derails into related cleanup"
estimated_time: 3-5 minutes
---

# Context reset check

## Purpose

Detect when a session has lost the context sweet spot and recommend resetting with a fresh, tight brief. Produces a summary the user can paste into a new session so progress isn't lost. The skill exists because models degrade silently as context fills with stale or contradictory information; humans rarely notice the inflection point.

## Key Concepts

### Context sweet spot

Chris MDP's third principle ([Coding with AI](https://www.chrismdp.com/coding-with-ai/)): output quality peaks with sufficient detail. Too little produces generic output. Too much causes the model to drown in noise. The peak is task-dependent and learnable. Knowing when to reset is a skill.

### Drift signals

The session has likely passed the sweet spot if any of these hold:

1. **Recurrence** — the same kind of error has appeared 3+ times across different attempts.
2. **Contradiction** — the agent makes statements that contradict its own earlier statements in this session.
3. **Drift** — the conversation has wandered from its initial goal into adjacent territory.
4. **Stale references** — the agent cites files, code, or decisions that have since changed.
5. **Length** — message count is high and no specific signal above, but quality feels off.
6. **Repetition of resolved issues** — the agent re-raises concerns the user already addressed.

Any *one* signal is not necessarily diagnostic; *two or more* together strongly suggest a reset is due.

### Reset vs continue trade-off

Resetting has a cost: the new session starts with less context. The decision matrix:

| Situation | Recommendation |
|---|---|
| 1 signal, near goal | Continue — finish the task. |
| 2+ signals, near goal | Push to finish but plan reset after. |
| 2+ signals, mid-task | Reset now with a carry-forward summary. |
| 3+ signals, drifting goal | Reset now and re-spec the problem. |

### Carry-forward summary

The output of the skill is not just "reset" — it's a paste-ready summary the user can drop into a fresh session. Without this, "reset" feels like losing work. With it, it feels like consolidating progress.

## Application

### Step 1 — Scan for drift signals

Without reading the full session, look for the six signals listed in Key Concepts. For each, mark Present / Absent / Unclear. Count Present signals.

### Step 2 — Diagnose

If 0-1 signals: probably no reset needed. Suggest the user can re-check in 30 minutes if quality feels off.

If 2 signals: explain which two, ask the user whether to reset or push to finish.

If 3+ signals: recommend reset; explain why.

### Step 3 — Produce a carry-forward summary

A tight summary the user pastes into the next session. Aim for ≤30 lines. Structure:

```markdown
## Continuing from a previous session

**Original goal.** <one sentence>

**Progress so far.**
- <2-4 bullets of what was accomplished>

**Open question / current blocker.**
<1-2 sentences, specific>

**Constraints to remember.**
- <only the constraints that surfaced in the prior session and aren't obvious from the code>

**What NOT to redo.**
- <specific paths or approaches already tried and ruled out>

**Files actively in scope.**
- <list>
```

The "what NOT to redo" section prevents the new session from re-treading paths.

### Step 4 — Hand off

Show the summary. Suggest: "open a new session and paste this as your first message." If working in a tool that supports session forks or new conversations, point to that path.

## Examples

### Example 1 — Clear reset (success)

**Session state:** 80 messages, working on a Tauri/SwiftUI iOS feature. Three signals present: same animation glitch appeared four times, agent referenced a file that was renamed mid-session, conversation drifted into a side discussion about icon sets.

**Diagnosis:** "Three signals present. Recommend reset."

**Carry-forward summary:**
```markdown
## Continuing from a previous session

**Original goal.** Add a "swipe to dismiss" gesture to the InboxView card stack.

**Progress so far.**
- Implemented swipe detection in InboxCardStack.swift
- Added animation curve that matches platform Liquid Glass defaults
- Identified that the prior glitch comes from re-entrant @State updates,
  not the animation itself

**Open question / current blocker.**
SwiftUI re-renders the entire card stack when one card animates out; need
to scope the animation to the single dismissing card.

**Constraints to remember.**
- iOS 18+ only target
- Must respect prefers-reduced-motion
- Animation duration must be ≤300ms (product decision, not negotiable)

**What NOT to redo.**
- onChange-based dismiss (causes re-entrant updates)
- Wrapping in GeometryReader (introduced a separate layout bug)

**Files actively in scope.**
- InboxView.swift
- InboxCardStack.swift
- InboxCard.swift
```

**Outcome:** user opens new session, pastes, immediately starts at the right level of abstraction. The animation lands in 20 minutes; the prior session had been spinning for an hour.

### Example 2 — Premature reset (failure)

**Session state:** 25 messages, working on a typo fix that turned out to require a small refactor.

**Drift signals:** 0 — the agent caught a missing edge case once, which the user then expanded scope to handle. No recurrence, no contradiction, no drift.

**Skill recommends reset.** User rejects: "we're 10 minutes from done."

**Failure mode:** Skill over-applied. The expanded scope wasn't drift; it was healthy iteration.

**Counter:** require ≥2 signals before recommending reset. Length alone is not sufficient.

## Common Pitfalls

### Pitfall 1 — Reset for length alone

**Symptom:** The skill recommends a reset because the session has 100 messages.

**Consequence:** Useful long sessions get interrupted; users learn to ignore the skill.

**Fix:** Length is one signal; require at least one more. Some long sessions are productive and tight.

### Pitfall 2 — Vague carry-forward summary

**Symptom:** Summary reads "we were working on the inbox feature. Continue."

**Consequence:** New session starts cold; reset loses work.

**Fix:** The summary must include: progress (specific items), blocker (specific question), constraints (only the non-obvious ones), and "what NOT to redo" (paths already ruled out). The "what NOT to redo" section is the most-skipped and most-load-bearing.

### Pitfall 3 — Ignoring the "near goal" exception

**Symptom:** Reset recommended when the user is 5 minutes from completing the task.

**Consequence:** Worse outcome than just pushing through.

**Fix:** The recommendation matrix in Key Concepts includes "near goal" as a modifier. Distance-to-completion matters.

### Pitfall 4 — Carry-forward in the wrong format

**Symptom:** The summary is 200 lines of conversation transcript instead of a structured handoff.

**Consequence:** The new session starts with the same drowning-in-context problem the reset was supposed to solve.

**Fix:** Tight format. ≤30 lines. The discipline is the point.

### Pitfall 5 — Failing to name the *why* of the reset

**Symptom:** Skill says "reset" without explaining which signals fired.

**Consequence:** User can't tell whether to trust the recommendation; learns to over-rely on the skill.

**Fix:** Always name 2-3 specific signals with evidence ("the same animation glitch appeared on messages 17, 38, and 64"). Diagnosis is the skill's value, not the verdict.

## References

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — context sweet spot is the third principle.
- **Anthropic Engineering** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — discusses context-window management and the artifact-passing pattern that this skill complements (carry-forward summary is a manual artifact-passing handoff).
- **Related Hornero skills:**
  - `skills/spec-the-problem/SKILL.md` — for the post-reset session, this is often the next skill invoked: re-spec from the carry-forward summary.
  - `skills/extract-lesson/SKILL.md` — if context-reset-check is invoked frequently in similar situations, the pattern itself is a lesson.
