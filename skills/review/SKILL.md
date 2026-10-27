---
name: review
description: Use weekly (typically Fridays) — runs six chronicle-health checks against the `chronicle/entries/` corpus, proposes fixes for the unambiguous findings, and surfaces the rest for a human call. Pairs with `/extract-lesson` (which tends the harness) the way `/review` tends the chronicle.
intent: |
  Make chronicle hygiene mechanical. Without this skill, hypotheses sit
  past their review date unattended, decisions drift past their
  revisit-by without re-examination, stakeholders go silent for months,
  and singleton scope tags accumulate. The chronicle's signal-to-noise
  decays without an explicit sweep.
type: workflow
theme: memory
best_for:
  - End-of-week (Friday) maintenance pass on the chronicle layer
  - Before a release cut, to confirm load-bearing decisions are still load-bearing
  - After a multi-week period of heavy ingest activity
  - When the SUMMARY starts to feel longer than the team's actual situational awareness
scenarios:
  - "Friday afternoon: PM runs `/review`. Three hypotheses are past their review_after with no status change — the agent reads each, proposes `chronicle.sh propose --supersedes <id>` to either resolve into a decision or refute. Two stakeholders haven't been touched in 60+ days — flagged as candidates for the next 1:1 cadence. Brief and done in 15 minutes."
  - "Before a release cut: agent runs `/review`, finds two decisions with thin sourcing (intuition) that are still status: validated. Proposes opening hypotheses to upgrade them — and pauses the release notes that lean on those decisions until the team makes an explicit call."
  - "After three weeks of QBR ingestion: agent runs `/review`, finds nine singleton scope tags from the QBR ingestion. Proposes a tag-merge pass — `enterprise-export` and `export-latency` consolidate into `export`; `acme-renewal` and `globalcorp-renewal` consolidate into `enterprise-renewals`."
estimated_time: 10-25 minutes
---

# Review

## Purpose

Run the chronicle-health sweep. The skill consumes the structured findings from `scripts/chronicle.sh review` (six checks) and walks them with the user. For each finding it either proposes a concrete fix (chronicle entry update) or surfaces the call for a human decision. The chronicle stays load-bearing only if someone is tending it; this skill is how that tending happens on a predictable cadence.

`/review` is paired with `/extract-lesson`:

- **`/extract-lesson`** runs on Stop (automatic). It tends the **harness** — roles, skills, CLAUDE.md, memory.
- **`/review`** runs manually, weekly. It tends the **chronicle** — entries, supersedes chains, sourcing discipline, scope-tag entropy.

The two skills cover the two long-lived layers Hornero compounds in. Neither replaces the other.

## Key Concepts

### The six checks

`scripts/chronicle.sh review` emits a Markdown report with one section per check:

1. **Stale hypotheses** — `type: hypothesis` with `review_after < today` and `status: open`. Either evidence accumulated and the hypothesis should resolve into a decision, or the falsifier triggered and it should flip to `refuted`, or the prediction was wrong and it should be killed.
2. **Decisions overdue for revisit** — `type: decision` with `status: validated` and `review_after < today`. The decision was set with an explicit revisit date for a reason; that reason is now load-bearing.
3. **Stale stakeholder contact** — `type: stakeholder` with the most recent date in `## Last contact` older than 60 days. Their position may have drifted; surface for the next 1:1 cadence.
4. **Thin sourcing on validated entries** — `status: validated` resting on `sourcing: intuition` or `sourcing: industry`. The team committed; the source layer is thin. Candidates for evidence upgrade (run a discovery interview, pull a dashboard, find a documented citation).
5. **Supersedes chain integrity** — broken supersedes/superseded_by links across the chain. Usually a sign of manual editing; correct by re-issuing a clean superseded_by or re-deriving the chain.
6. **Scope-tag entropy** — scope tags used by exactly one entry. Either the tag is a one-off (accept and move on) or it's a near-duplicate of another tag and should be merged for queryability.

The script is the source of truth for the heuristics — the skill consumes the report; the prose does not re-implement the checks. If a check's logic needs to change, edit the shell.

### What to act on directly vs surface for the user

- **Act directly** (propose chronicle entry updates, do not commit):
  - Stale hypotheses where the Evidence Log clearly resolves the prediction — propose a new `type: decision` entry that supersedes.
  - Stale hypotheses where the Falsifier explicitly triggered — propose flipping to `status: refuted`.
  - Broken supersedes/superseded_by — propose the integrity fix.
  - Singleton scope tags with an obvious near-duplicate — propose a tag-merge edit.

- **Surface for the user** (don't propose; ask the call):
  - Overdue decisions — the revisit is the user's judgement call. Summarise the original diagnosis and what changed.
  - Thin sourcing on validated entries — name what evidence upgrade would look like (interview, dashboard, citation) and ask which to pursue.
  - Stale stakeholder contact — flag candidates for the next 1:1 cadence; the user picks who to reach out to.
  - Singleton scope tags with no obvious merge — ask if the tag should stay or be retired.

The split matters. If the agent proposes a fix where a human call is needed, the chronicle ends up with auto-applied drift. If the agent surfaces a finding where a fix is obvious, the user wades through noise.

### Output discipline

The skill produces three things:

1. A **one-line summary** at the top: `Reviewed N entries; M findings across 6 checks; K proposals drafted, L flagged for your call.`
2. The **drafted proposals** as `scripts/chronicle.sh propose ...` commands, ready to run. Human commits each via `chronicle.sh commit`.
3. The **flagged calls** as bullets under each check, no decision attached.

No prose synthesis beyond the per-check section. The chronicle is the synthesis layer; `/review` is the maintenance pass.

### Cadence

Manual on purpose. Don't add a cron. The check is most valuable when the user is paying attention to the findings; an auto-running sweep that produces output no one reads is theatre.

If the chronicle is in active use, the typical cadence is once a week (Friday afternoon, 15-25 minutes). If the chronicle is in light use, monthly. If the report has been "all OK" for three consecutive runs, drop frequency — overrunning produces more drift than it prevents.

## Application

### How to invoke

```bash
/review
```

No arguments. The skill:

1. Runs `scripts/chronicle.sh review` and reads the report.
2. Walks each non-OK section.
3. For each finding, decides act vs flag per the split above.
4. Drafts proposals as `chronicle.sh propose` commands (does not commit).
5. Renders the three-part output (summary, drafted proposals, flagged calls).
6. Stops.

The user commits accepted proposals individually via `chronicle.sh commit <uuid>`. The skill does not auto-commit; the human-gated commit path on `chronicle/entries/` is structural.

### What if everything is OK

If all six checks return OK, the skill says so in one line and stops. Empty signal is signal. Don't pad with "the chronicle is in great shape" preening.

### What if the report is huge

If the report has more than ~15 findings, the chronicle has accumulated maintenance debt. Two options:

1. **Triage on this run**: walk the top 5 findings (highest-impact first — supersedes integrity > stale hypotheses > overdue decisions > thin sourcing > stakeholder contact > scope-tag entropy), defer the rest, schedule a second pass within a week.
2. **Surface as a structural issue**: name the volume in the summary; ask whether the cadence needs to tighten or whether the chronicle has been accepting noise (over-recording, weak entries).

Don't try to walk 30 findings in one pass — quality drops, and the user disengages.

### Invocation notes

Declare the route in one line before starting (per `VOICE.md`):

```
/review — six chronicle-health checks; reading the report now.
```

## Examples

### A typical Friday run on a healthy chronicle

```markdown
Reviewed 23 entries; 3 findings across 6 checks; 1 proposal drafted, 2 flagged for your call.

## Drafted proposals

- `2026-04-10-invite-friction-hypothesis` (stale hypothesis) — Evidence Log shows bulk-invite shipped 2026-05-01, time-to-activation dropped 38% (prediction was 30%). Propose:
  ```bash
  scripts/chronicle.sh propose --type decision \
    --title "Bulk invite resolved team-activation friction for sub-50-seat teams" \
    --status validated --confidence 0.85 \
    --source-role product-manager --sourcing documented \
    --scope activation,growth --affected-areas onboarding/ \
    --decision "Bulk invite ships as the canonical activation path for sub-50-seat teams; per-person invite stays as fallback." \
    --supersedes 2026-04-10-invite-friction-hypothesis
  ```

## Flagged for your call

- `2026-02-15-value-based-pricing-mid-market` (overdue decision) — review_after was 2026-04-15. Original diagnosis cited mid-market deal velocity; pipeline data since shows mixed signal. Worth a fresh look before Q3.
- `2026-03-30-acme-renewal-strategy` (thin sourcing) — `status: validated` rests on `sourcing: intuition`. Evidence upgrade options: pull the QBR notes from 2026-05-15 ingestion, or run a 30-min sync with Maya. Which?
```

### A heavy-debt run

```markdown
Reviewed 89 entries; 18 findings across 6 checks. Triaging top 5 this pass; scheduling a second pass for 2026-05-27.

## Drafted proposals (top 5)

[... 5 proposals ...]

## Deferred to next pass

13 findings: 4 stale hypotheses (low-confidence, recent activity), 6 stale-contact stakeholders, 3 singleton scope tags. Will tackle in the 2026-05-27 review.

## Structural note

The volume suggests the chronicle is accepting too many low-confidence entries — half the stale hypotheses started at confidence ≤0.50 with no validation plan. Worth a chronicle-record discipline refresh in next week's team sync.
```

## Common Pitfalls

1. **Auto-committing the drafted proposals.** The human-gated commit path on `chronicle/entries/` is structural. The skill proposes; the human commits. Same discipline as every other chronicle write path.
2. **Re-implementing the heuristics in prose.** The six checks live in `scripts/chronicle.sh review`. If the logic needs to change, edit the shell — not the SKILL. The SKILL consumes the report; it does not re-derive it.
3. **Padding when everything is OK.** Six "OK" lines is the right output for a healthy chronicle. Don't add "the chronicle is in great shape" or "no action needed at this time."
4. **Walking 30 findings in one pass.** Quality drops, user disengages. Triage to top 5 by impact; defer the rest; surface the volume as a structural issue.
5. **Acting on findings where the call is the user's.** Overdue decisions and thin sourcing are not auto-fixable — the diagnosis depends on context the agent doesn't have. Surface, don't propose.
6. **Skipping the integrity check when it fires.** Broken supersedes chains are silent corruption — every recall query that follows the chain reads stale state. Fix integrity findings first, even if they look minor.
7. **Mixing /review with /extract-lesson.** They serve different layers. Don't fold them into one skill; the cadences and signal sources are distinct.

## References

- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — the `review` subcommand is the source of truth for the six checks; this skill consumes its output.
- [`chronicle/README.md`](../../chronicle/README.md) — layer overview and lifecycle.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — entry shapes the review reasons over (`type`, `status`, `sourcing`, `review_after`, `supersedes`, `superseded_by`, `scope`).
- [`skills/chronicle-record`](../chronicle-record/SKILL.md) — write-side; the proposals drafted by `/review` are `chronicle.sh propose` commands.
- [`skills/chronicle-recall`](../chronicle-recall/SKILL.md) — read-side; useful when surfacing context for "flagged for your call" findings.
- [`skills/extract-lesson`](../extract-lesson/SKILL.md) — sibling weekly skill, distinct layer (harness, not chronicle).
- [`playbooks/feedback-ritual.md`](../../playbooks/feedback-ritual.md) — extended in this commit to note the `/review` companion cadence.
- [PM Brain — `/review`](https://github.com/phuryn/pm-brain) — the design influence; PM Brain's variant runs six checks and "fixes small things directly", while Hornero's variant always proposes and never commits.
