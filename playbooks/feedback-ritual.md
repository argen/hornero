# Feedback ritual — weekly cadence

The harness compounds only if lessons land somewhere durable. This playbook formalizes that as a 20-minute weekly ritual.

## The principle

Chris MDP's fourth principle: feedback-loop discipline. Without a ritual, lessons stay locked in conversations. With one, the methodology improves visibly week over week.

## The cadence

**Once per week.** Same day, same time, ≤20 minutes. Put it on your calendar.

Suggested: Friday afternoon (review the week before context shifts) or Monday morning (review before this week's work begins).

## Two layers, two skills

Hornero compounds in two long-lived layers, and each has its own weekly sweep:

| Layer | Skill | What it tends |
|---|---|---|
| **Harness** | `extract-lesson` | Role files, skill files, CLAUDE.md / AGENTS.md, project memory. Captures what the agent should do differently next session. |
| **Chronicle** | `/review` | Chronicle entries — stale hypotheses, overdue decisions, stale stakeholders, thin sourcing, supersedes integrity, scope-tag entropy. Captures what the project's durable record should look like to stay load-bearing. |

The two are **complementary, not interchangeable**. `extract-lesson` runs automatically on session Stop; `/review` is invoked manually as part of this ritual. Both belong to the weekly feedback cadence; neither replaces the other.

If the chronicle layer is in light use (few or no entries), skip the `/review` step until it has content worth tending.

## The ritual

### Step 1 — Run `extract-lesson` against the week's notable sessions (10 min)

Pick the 3-5 sessions from the past week that produced surprises, corrections, or notable success. For each, run:

> "Use the extract-lesson skill on the session from <date>. Cap proposals at 3."

The skill scans for signal and produces concrete deltas to role files, skills, CLAUDE.md, or project memory.

If you don't remember which sessions were notable, that's a signal: notable sessions should leave a trace. Consider adding a "marked" flag (a `.marked` file, a tag in your notes, a slack reaction) at session-end when something felt worth capturing.

### Step 2 — Triage proposals (5 min)

For each proposed delta:

- **Accept** — apply now.
- **Edit** — refine wording or scope; apply.
- **Reject** — drop. Note why briefly to spot patterns over time.
- **Defer** — push to next week.

Don't accept everything; the extract-lesson skill produces candidate lessons, not final ones. Your judgment is the filter.

### Step 3 — Apply and commit (3 min)

For accepted proposals:

- Apply the change to the relevant file (`roles/`, `skills/`, `~/.claude/CLAUDE.md`, or project memory).
- Run `validate-skill.sh` on any modified `SKILL.md`.
- Commit on a feedback-loop branch: `feat/feedback-<date>`.

Keep the commits small. One commit per logical lesson.

### Step 3b — Run `/review` on the chronicle (5-15 min)

If the chronicle layer is in active use, run `/review` after the harness ritual completes. The skill walks the six chronicle-health checks and produces:

- Drafted proposals for unambiguous fixes (resolved hypotheses, broken supersedes, near-duplicate scope tags).
- Flagged calls for findings that need user judgement (overdue decisions, thin sourcing, stale stakeholder contact).

Commit the accepted proposals via `scripts/chronicle.sh commit <uuid>`. The skill does not auto-commit; the human gate on `chronicle/entries/` is structural.

If the report says "all OK" for three consecutive runs, drop frequency. Overrunning the chronicle check produces more drift than it prevents.

### Step 4 — Note recurring themes (2 min)

Look at the rejected and applied proposals together. Are themes recurring?

- "Three weeks in a row I've been correcting the agent on git workflow." → CLAUDE.md needs sharpening, not another lesson.
- "Two weeks of `product-manager` role producing generic PRDs." → Role's `sources.md` may need an additional anchor; or the role's broad pass is mis-prioritized.

Recurring themes are the signal that a *structural* change is needed, not just an incremental lesson.

## When to skip a week

Skip if:

- You had no sessions of substance (vacation, time off, blocked on others).
- Last week's proposals are still pending — finish those first.

Don't skip just because nothing felt remarkable. Negative signal — "the methodology worked as designed" — is itself valuable data. Note it.

## When to extend the ritual

Extend (do a deeper monthly review on top of the weekly) when:

- The repo has grown by >10 roles or >50 skills (governance burden rises).
- Multiple teammates are contributing (drift across contributors needs editorial reconciliation).
- A role's findings are no longer trusted (might be a `sources.md` curation issue).

The monthly review reads the past four weeks' commits to the feedback-loop branch and asks: are we drifting? Are we consolidating? Is anything redundant?

## Anti-patterns

### Treating every session as a lesson source

**Symptom:** 30 proposals per week; nothing settles.

**Fix:** Cap at 3 proposals per session. If extract-lesson surfaces more, take the top 3 and discard the rest.

### Applying without validation

**Symptom:** Skills modified; nobody runs `validate-skill.sh`; broken skills accumulate.

**Fix:** Step 3 always ends with validation. The script catches subtle anatomy violations.

### Hoarding proposals

**Symptom:** "Defer" gets used on most proposals; the defer pile grows; nothing lands.

**Fix:** Defer is a tool for "this needs more thought," not a euphemism for "I don't want to decide." Cap deferrals at 3; if more accumulate, force a decision.

### Personal preferences leaking into shared methodology

**Symptom:** Team-shared CLAUDE.md gains entries like "user prefers 2-space indentation."

**Fix:** Step 2 includes a "is this transferable?" check. Personal taste goes to personal CLAUDE.md (or project memory), never to the team methodology.

## What good looks like

After 4 weeks of the ritual, you should observe:

- A visible commit cadence on the methodology repo (≥1 commit per week from this ritual).
- A shrinking set of "recurring corrections" — patterns that used to repeat now persist in roles/skills/CLAUDE.md.
- The methodology files growing more specific over time (concrete examples added, anti-patterns sharpened).
- Confidence that the harness now reflects what the team has actually learned.

If after a quarter the ritual has produced few or no commits, the methodology isn't actually being used in real work — that's the bug to fix, not the ritual.
