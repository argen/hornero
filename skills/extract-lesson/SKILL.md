---
name: extract-lesson
description: Runs automatically at session end via the Stop hook (or invoke explicitly mid-session after a notable success/failure) — scans the conversation for surprises and corrections, proposes durable updates to roles, skills, CLAUDE.md / AGENTS.md, or per-project memory.
intent: |
  Implements Chris MDP's feedback-loop discipline. Closes the gap between
  "we learned something" and "the harness now reflects what we learned."
  Without this, every session starts from scratch. With it, the repo
  compounds week over week.
type: interactive
theme: harness
best_for:
  - At the end of a working session
  - After an orchestrated review surfaces a recurring delegation mistake
  - After a bug fix where the root cause reveals a missing guardrail
  - When the user corrects the agent's approach in a way that would apply to future tasks
scenarios:
  - "Session wrap: agent and user worked through three iterations of a CSS bug before finding the cause was a stale CDN cache — propose adding 'check CDN cache state' to the relevant troubleshooting skill"
  - "User repeatedly corrected the agent to use feature branches; lesson belongs in a role or in CLAUDE.md"
  - "Multi-role-review surfaced that the security-expert role keeps over-applying STRIDE to UI changes; propose narrowing the role's invocation triggers"
estimated_time: 5-10 minutes
---

# Extract lesson

## Purpose

Convert ephemeral session learning into durable harness improvements. The skill scans the conversation for signal — surprises, corrections, near-misses, repeated patterns — and proposes specific deltas to role files, skills, CLAUDE.md, or per-project memory. The user reviews and accepts/edits/rejects each proposal. Accepted proposals get applied, closing the feedback loop.

### When it runs

- **Automatically at session end** via Hornero's Stop hook (`hooks/auto-extract-lesson.sh`). The agent self-filters: if the session was routine task completion, it says "No lessons to extract" in one line and the session ends. Only sessions with real signal produce proposals.
- **Manually mid-session** via `/extract-lesson`, after a notable success/failure or when you want to capture a lesson while it's fresh rather than waiting for end-of-session.
- **Opt-out** for a single session by setting `HORNERO_NO_AUTO_EXTRACT=1` in the shell environment before launching Claude Code, or by removing the Stop hook entry from your `.claude/settings.json` to disable globally.

## Key Concepts

### Feedback-loop discipline

Chris MDP's fourth principle ([Coding with AI](https://www.chrismdp.com/coding-with-ai/)): lessons from agent failures must feed back into the harness, not stay locked in conversations. Without this, every session begins with the same misunderstandings.

### Signal vs noise

Most session content is noise from a feedback perspective: routine tool calls, normal back-and-forth, content specific to one task. The skill scans for *signal*:

- **Corrections** — moments where the user pushed back on the agent's approach.
- **Surprises** — moments where something the agent assumed turned out to be wrong.
- **Repeated patterns** — issues that have come up across multiple sessions (these are the highest-value lessons).
- **Validated approaches** — when the user said "yes, exactly" to a non-obvious choice. Confirmations are quieter signal than corrections, but equally important; they prevent drift toward overcautious defaults.

### Update target taxonomy

A lesson can land in one of six places. Choosing correctly is most of the work:

| Target | When |
|---|---|
| **Role file** (`roles/<role>/ROLE.md`) | The lesson is about how a role should think, what it should look for, or its anti-patterns |
| **Role sources** (`roles/<role>/sources.md`) | The lesson surfaces a missing expert / framework anchor |
| **Skill file** (`skills/.../SKILL.md`) | The lesson is about how a process should run (delegation, dispatch, synthesis) |
| **CLAUDE.md** | The lesson is harness-wide for Claude Code sessions, transcending any one role or skill |
| **AGENTS.md** | The lesson is harness-wide for Codex sessions. Mirror to CLAUDE.md when the lesson is dispatcher-wide — the two files stay in sync. |
| **Project memory** (`~/.claude/projects/*/memory/`) | The lesson is specific to one project and shouldn't pollute the shared methodology |

### Confirmation before apply

The skill never edits files autonomously. It produces proposals — concrete diffs — that the user accepts, edits, or rejects. The reason: lessons are sometimes wrong, sometimes overspecific, sometimes contradicted by other lessons. Human judgment is the final filter.

## Application

### Step 1 — Scan the conversation

Re-read the session with these prompts in mind:

- Did the user correct the agent? Where, and what was the underlying issue?
- Did the agent's first guess turn out wrong? Why?
- Was there a moment of "we should have known X earlier"?
- Did a tool, skill, or role behave in a way the agent didn't expect?
- Did the user explicitly approve a non-obvious approach? ("yes, exactly," "good call.")
- Are there patterns that have appeared in previous sessions too?

### Step 2 — Distill candidates

For each signal, draft a one-sentence candidate lesson. Discard:

- Lessons specific to one bug in one file (those are project memories at best).
- Lessons that restate existing role/skill/CLAUDE.md content.
- Lessons that are personal preference rather than transferable practice (unless explicitly user-personal and aimed at memory).

Keep:

- Lessons that would have changed the agent's behavior if known up front.
- Lessons that have appeared before, even loosely.
- Lessons that name a class of mistake, not a single instance.

### Step 3 — Pick the right target

For each surviving candidate, decide which target file should receive it (using the taxonomy above).

If the candidate could land in multiple targets, prefer the most local one — a skill change beats a role change beats a `CLAUDE.md` / `AGENTS.md` change (and when a lesson does land at the dispatcher layer, edit both `CLAUDE.md` and `AGENTS.md` together). The harness compounds best when lessons are placed where they're consulted.

### Step 4 — Draft the proposal

For each lesson, produce a concrete diff proposal:

```markdown
**Proposal 1.**

Target: `roles/product-manager/ROLE.md`, section "Anti-patterns"

Change: add a new anti-pattern:

> **8. Over-applying STRIDE to UI changes.** A pure visual or copy
> change rarely changes the threat surface. Symptom: STRIDE passes
> on UI PRs that produce no findings; user fatigue. Counter: scope
> the role's invocation triggers to changes that modify auth,
> data flow, or input handling — not pure visual changes.

Rationale: surfaced in three sessions over the past two weeks
(2026-04-08, 2026-04-22, 2026-05-12).
```

### Step 5 — Present and apply

Show all proposals to the user. For each:

- **Accept** — apply the change.
- **Edit** — adjust wording / scope, then apply.
- **Reject** — drop. Optionally note why in conversation (not in any file).
- **Defer** — note in a personal scratchpad for re-review later.

After applying, suggest a follow-up: run `validate-skill.sh` on any modified SKILL.md files; commit the deltas to a feedback-loop branch.

## Examples

### Example 1 — Recurring correction → skill change (success)

**Signal:** Three sessions in a row, the user reminded the agent to use `tmp/` for subagent output files. The pattern of "agent writes to chat, user redirects" repeated.

**Distilled:** "Lead agent in cross-functional-orchestration is not enforcing Rule 4 (artifact passing)."

**Target:** `roles/product-manager/skills/cross-functional-orchestration/SKILL.md`

**Proposal:** Add to "Step 3 — Parallel dispatch": "Each subagent prompt must include `Write your findings to tmp/<role>-review-<slug>.md.` literally — do not paraphrase, do not move the instruction to the middle of the prompt."

**Outcome:** lesson lands. Next sessions, the agent enforces it. The harness compounds.

### Example 2 — Validation captured → no change needed

**Signal:** User said "yes, exactly the right framing" when the agent proposed a problem-shaped restatement of a feature request that was solution-shaped.

**Distilled:** "spec-the-problem is working as designed — the user validates problem-shape translations."

**Target:** None. The lesson is "the existing skill works." No file change needed.

**Outcome:** confirm internally; don't propose noise. (This kind of negative-result extraction matters — it prevents drift toward "every session must produce a change.")

### Example 3 — Over-extraction (failure)

**Signal:** A bug fix went through three rounds because the test environment had stale data.

**Failure mode:** Agent proposed adding "always check for stale test data" to the tester role's anti-patterns. User rejected: the issue was project-specific.

**Counter:** The lesson belonged in project memory, not in a methodology role file. Re-targeting from "role" to "project memory" would have been correct.

## Common Pitfalls

### Pitfall 1 — Over-extracting

**Symptom:** Every session produces 5+ proposals; the harness churns; nothing settles.

**Consequence:** The accumulated noise drowns the signal; users stop trusting proposals.

**Fix:** Hard cap of 3 proposals per session. If more signal exists, surface the top 3 and note the rest for a future session.

### Pitfall 2 — Editing autonomously

**Symptom:** The skill applies changes without explicit user approval.

**Consequence:** The methodology drifts in ways the user didn't sanction; trust erodes.

**Fix:** Step 5 is non-negotiable. Always confirm before applying. The skill produces proposals; the user is the final filter.

### Pitfall 3 — Wrong target

**Symptom:** Lessons land in CLAUDE.md when they belong in a single role, or vice versa.

**Consequence:** Lessons aren't consulted at the right moment; the harness doesn't actually compound.

**Fix:** Step 3 is the most important decision. Default to the most local target; escalate to broader scope only when the lesson genuinely transcends one role/skill.

### Pitfall 4 — Lessons as personal preference

**Symptom:** "User prefers 4-space indentation" lands in CLAUDE.md.

**Consequence:** Methodology pollutes with personal taste; non-transferable noise.

**Fix:** Personal preferences go to project memory or local settings, never to the team methodology. The test: would this lesson improve outcomes for someone other than you?

### Pitfall 5 — Skipping validation

**Symptom:** Proposals land; nobody runs `validate-skill.sh`; broken skills accumulate.

**Consequence:** Subtle anatomy violations break the harness without anyone noticing.

**Fix:** Step 5 should always end with "run validate-skill.sh on the changed files." Make it part of the proposal-acceptance flow.

## References

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — feedback-loop discipline is the fourth principle.
- **Related Hornero skills:**
  - `skills/spec-the-problem/SKILL.md` — extract-lesson may propose updates to default question sets when specific question patterns prove valuable.
  - `skills/harness-check/SKILL.md` — extract-lesson is consulted as part of harness-check's audit.
- **Related playbooks:**
  - `playbooks/feedback-ritual.md` — weekly cadence for batch extract-lesson runs across multiple recent sessions.
