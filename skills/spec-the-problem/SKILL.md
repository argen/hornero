---
name: spec-the-problem
description: Use before any non-trivial implementation — forces a problem statement + constraints + success criteria pass before code is written.
intent: |
  Implements Chris MDP's "Spec problems, not solutions" principle.
  Forces the user (and the agent) to articulate the problem, the constraints,
  and the success criteria before any implementation begins. Produces a
  short specification artifact that downstream skills can reference.
type: interactive
theme: harness
best_for:
  - Before starting implementation of a new feature
  - When a user request is solution-shaped ("add a button that...")
  - When scope is unclear or success criteria are missing
  - At the start of a multi-role-review run
scenarios:
  - "User says 'add a retry mechanism to the upload flow' — skill surfaces the underlying problem (which failures? which users? what's the acceptable retry budget?)"
  - "Spec'ing a non-trivial refactor before touching code"
  - "Framing a bug fix as a problem before jumping to a patch"
estimated_time: 3-7 minutes
---

# Spec the problem

## Purpose

Force the conversation past "implement this solution" and back to "solve this problem." Produces a short specification — problem, constraints, success criteria, out-of-scope — that the implementation can be measured against. The skill exists because waterfall-style solution specs break the moment circumstances change, while problem specs survive iteration.

## Key Concepts

### Spec problems, not solutions

Chris MDP's principle ([Coding with AI](https://www.chrismdp.com/coding-with-ai/)): brief the agent on constraints and success criteria; leave implementation open. The agent has more degrees of freedom to find a good solution than a human dictating one in advance. The harness loses if it constrains too early.

### Four required fields

The skill produces a specification with exactly four fields:

1. **Problem** — what user, system, or business need is unmet, in one or two sentences.
2. **Constraints** — what the solution must respect (latency, compatibility, security boundary, budget, platform).
3. **Success criteria** — observable, falsifiable, measurable. "Users can do X within Y time" not "the experience is improved."
4. **Out of scope** — what this work is *not* trying to do, named explicitly.

Skipping any of the four is the most common failure mode.

### Problem-shape vs solution-shape

User requests typically arrive solution-shaped:

> "Add a retry button to the upload screen."

The skill restates them problem-shaped:

> "Users lose work when uploads fail; we don't know the failure rate or which failures are recoverable."

A solution-shaped request that survives translation to a problem-shaped statement (problem is well-understood, constraints clear, criterion testable) can proceed directly. A solution-shaped request that *doesn't* survive translation is a signal that more discovery is needed.

### "What would tell us we're wrong?"

For each success criterion, a counter-question: what would we observe if this is the wrong solution? If the answer is "nothing," the criterion is unfalsifiable — sharpen it.

## Application

### Step 1 — Diagnose the shape of the request

Read the user's request. Classify:

- **Solution-shaped** — names a specific implementation ("add X," "change Y to Z"). Most requests start here.
- **Problem-shaped** — names a need or pain ("users can't do X," "we're losing Y"). Already-good input.
- **Goal-shaped** — names an outcome without a path ("improve retention," "reduce errors"). Needs decomposition before spec.

### Step 2 — Ask up to four questions

Always ask only the questions you can't answer yourself. Each question must produce information that changes the spec. If a question is asked and the answer wouldn't change anything, skip it.

Default question set (adapt to context):

1. "What user or system problem is this solving — in one sentence?"
2. "What must the solution preserve or respect? (Existing behaviors, integrations, performance, security.)"
3. "How will we know it worked? Name something measurable."
4. "What is explicitly *not* part of this work?"

### Step 3 — Draft the spec

Produce the four-field specification. Keep it under 30 lines. Example output:

```markdown
# Spec — Upload retry mechanism

**Problem.** Roughly 8% of uploads fail on flaky connections; users currently
lose the file and must reselect. We don't know the recovery rate of failed
uploads if retried.

**Constraints.**
- Must not double-charge for usage-metered uploads
- Must not retry uploads the user explicitly cancelled
- Must work offline-to-online resumption (the most common failure pattern)

**Success criteria.**
- Of uploads that fail at the transport layer, ≥60% complete after retry
- Failed-upload user-reported "lost my file" complaints drop ≥50% over 30 days
- No increase in duplicate-upload incidents

**Out of scope.**
- Reuploading after server-side rejection (different problem)
- Background uploading from offline (different feature)
- UI redesign of the upload screen (defer)
```

### Step 4 — Confirm and proceed

Show the spec to the user. Ask "ship it?" If they edit, re-draft. If they accept, the spec becomes the reference document for implementation.

### Step 5 — Reference downstream

When implementation begins, reference the spec by section. "This implements **Success criteria #1**" is more useful than "I added retry logic." The spec is the harness; downstream work hangs from it.

## Examples

### Example 1 — Solution-shaped → problem-shaped (success)

**User request:** "Add a confirmation dialog before the user deletes a project."

**Skill response:** "Before I implement: what user problem is this solving? Two possible answers shape the solution very differently:
- 'Users accidentally delete projects and lose work' → confirmation dialog is one option; undo-after-delete is another and might be better.
- 'Compliance requires explicit confirmation on destructive actions' → dialog is required, copy needs legal review.

Which is it?"

**Outcome:** user clarifies it's the first. Final spec describes "prevent accidental destructive action with ≤1 second recovery affordance" and the implementation chooses undo-after-delete instead of dialog. Better solution, surfaced by problem-spec'ing.

### Example 2 — Over-applied (failure)

**User request:** "Fix the typo in the README."

**Skill response (wrong):** "What is the user problem? What constraints? Success criteria?"

**Failure mode:** trivial requests don't need spec'ing. The four-field spec exists for non-trivial implementation, not for every change.

**Counter:** the skill should triage upstream. If the request is bounded to ≤10 lines and the change is local and reversible, skip the spec. The skill description's `best_for` list communicates this.

## Common Pitfalls

### Pitfall 1 — Spec'ing trivial work

**Symptom:** The skill is invoked for typo fixes, single-line tweaks, formatting changes. User experience: friction with no payoff.

**Consequence:** Skill is perceived as ceremony; user stops invoking it for real work too.

**Fix:** Triage in Step 1. The skill is for non-trivial implementation. The frontmatter `best_for` list governs invocation.

### Pitfall 2 — Constraints written as solutions

**Symptom:** Constraint reads "must use React Query" rather than "must respect existing client-side cache semantics." The constraint pre-commits the solution.

**Consequence:** The agent's freedom is constrained without reason; alternative implementations are blocked.

**Fix:** Constraints should describe properties (latency, compatibility, security), not technologies. If a specific technology is required by some external reason, state the reason.

### Pitfall 3 — Unfalsifiable success criteria

**Symptom:** Criteria read "user experience is improved," "the system is more robust," "users will be happier."

**Consequence:** No way to know if the work succeeded. The spec doesn't constrain the implementation.

**Fix:** Apply the "what would tell us we're wrong?" test to each criterion. If no observable, falsifiable answer exists, the criterion is too vague.

### Pitfall 4 — Out-of-scope omitted

**Symptom:** The "out of scope" field is blank or says "nothing."

**Consequence:** Scope creeps mid-implementation; related concerns get folded in; the spec becomes useless as a reference document.

**Fix:** Every spec names at least one thing it's NOT trying to do. If the user can't name something, ask: "what related concern is tempting to fold in here but should be deferred?"

### Pitfall 5 — Spec'ing in isolation from context

**Symptom:** A spec is written for one part of a system without surfacing how it interacts with adjacent code, data, or users.

**Consequence:** Implementation surprises the team because the spec didn't capture system-level constraints.

**Fix:** Constraints field should include "existing behaviors and integrations that must be preserved." If you don't know what those are, that's discovery work before spec.

## References

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the "Spec problems, not solutions" principle is the source for this skill.
- **Related Hornero skills:**
  - `skills/multi-role-review/SKILL.md` — the multi-role review skill's Step 2 (detailed delegation) implements the same principle one level down: each role subagent gets a problem-shaped brief, not a solution-shaped one.
  - `skills/extract-lesson/SKILL.md` — at session end, may propose updates to specs for future similar work.
- **Tangential discipline:** Marty Cagan's "four risks" framing (value/usability/feasibility/business viability) in `roles/product-manager/sources.md` — problem-shaped specs naturally surface unaddressed risks.
