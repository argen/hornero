---
name: hypothesis-track
description: "Use when new evidence arrives on an open `type: hypothesis` entry — appends a dated row to its Evidence Log via `chronicle.sh append`, then either keeps the hypothesis open or surfaces a threshold crossing (falsifier triggered → propose refutation; prediction met → propose a resolving decision via supersedes)."
intent: |
  Make the hypothesis loop close. Without this skill, evidence
  accumulates in conversation transcripts and never lands on the
  hypothesis entry, so the chronicle's "what assumptions are we
  currently riding?" answer goes stale. With it, every observation that
  bears on a hypothesis hits the Evidence Log within minutes of being
  noticed, and the entry's `status` stays accurate.
type: workflow
theme: memory
best_for:
  - After a metric snapshot, A/B readout, or dashboard pull touches an open hypothesis's prediction
  - After a discovery interview surfaces an observation that bears on a hypothesis's falsifier
  - After a feature ships whose adoption resolves (or refutes) a hypothesis
  - During `/review` when a stale hypothesis needs evidence appended before its status is reconsidered
scenarios:
  - "Hypothesis `2026-05-18-invite-friction-blocks-team-activation` predicts a 30% time-to-activation drop after bulk-invite ships. Week 1 Mixpanel shows a 22% drop. PM runs hypothesis-track — appends a `documented` row to Evidence Log. The drop is on the right side of the falsifier but short of the prediction; status stays open, marker noted in conversation."
  - "Hypothesis `2026-04-10-self-serve-is-enough-for-50-seat-teams` had a falsifier 'discovery interview reveals SSO config blocks admin progression'. A 2026-05-19 interview surfaces exactly that. hypothesis-track appends the observation as a `verbal` row, then proposes a refutation entry: `chronicle.sh propose --type decision --supersedes 2026-04-10-self-serve-is-enough-for-50-seat-teams --decision 'Sub-50-seat teams need a guided SSO path; self-serve alone is not enough.' --status validated --sourcing verbal ...`"
  - "Hypothesis `2026-03-30-pricing-test-will-lift-arpu` shipped; 60-day window closes today. Three documented evidence rows accumulated; ARPU lift is 18% (prediction was 15%). hypothesis-track appends the closing observation, then proposes a validating decision entry that supersedes the hypothesis."
estimated_time: 2-5 minutes
---

# Hypothesis track

## Purpose

Close the loop on open hypotheses by appending evidence the moment it lands, and by recognising when an evidence row crosses a threshold the entry's own Falsifier or Prediction section names. The hypothesis is the unit of intellectual honesty in the chronicle — without an evidence loop, hypotheses calcify into beliefs.

The skill is deliberately narrow: it owns one section (`## Evidence Log`) on one type (`hypothesis`). It does not change the Assumption, Prediction, Falsifier, or Resolution sections — those are part of the original posture and change only via supersedes. If the new evidence implies a change to one of those, the skill proposes a new entry via `chronicle.sh propose --supersedes` rather than mutating the existing one.

## Key Concepts

### One row per observation, dated

Each Evidence Log row carries: ISO date, sourcing tag, observation. The skill writes them as:

```
- 2026-05-20 — documented — Mixpanel: time-to-activation dropped 22% in week 1 post-bulk-invite.
```

Sourcing tags inline (`documented`, `verbal`, `intuition`, `industry`) so the weakest-link discipline applies at the row level. The hypothesis's own `sourcing` frontmatter field is the floor across all rows — if a `documented` hypothesis accumulates only `verbal` rows, the entry's sourcing weakens and `/review` will flag it.

### The Evidence Log is the **only** appendable section

Per [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md), the append exception's whitelist for `hypothesis` contains exactly one section: `Evidence Log`. Attempts to append to Assumption, Prediction, Falsifier, Resolution, or Notes fail at the CLI layer. This is intentional — the entry's original framing is part of its audit trail. If the Prediction was wrong (too aggressive, wrong metric, wrong window), the answer is supersedes, not edit.

### Three threshold crossings the skill recognises

After appending the row, the skill reads the entry's Falsifier and Prediction sections and asks one question: did the new row cross a threshold? Three outcomes:

1. **Falsifier triggered** — propose a `type: decision` entry that `supersedes` the hypothesis and flips it to `refuted`. The decision's body names what the team now believes instead.
2. **Prediction met (or exceeded)** — propose a `type: decision` entry that `supersedes` the hypothesis with `status: validated`. The decision's body promotes the assumption from open to settled posture.
3. **Neither** — keep the hypothesis `open`. Note in the conversation what the row moved (toward / away from prediction; toward / away from falsifier) so the user knows where the entry stands.

The skill proposes; the user commits. Never auto-commits a supersede — the resolving decision is too consequential to land without human gate.

### Status fields the skill never touches

The current `LEGAL_STATUSES` for chronicle entries: `validated | open | superseded | refuted`. The skill does not change the status field directly via append (append doesn't touch frontmatter). Status changes happen via supersedes, the same path as the original write. If a future schema extension adds `weakening` / `strengthening` mid-state values, the skill will use them; until then, "evidence is accumulating but not yet conclusive" is captured in the Evidence Log itself, not in the status.

## Application

### How to invoke

```
/hypothesis-track <hypothesis-id>
```

Optional args inline as conversation: which observation, what sourcing tag, optional date override (defaults to today). The skill:

1. Reads the hypothesis entry at `chronicle/entries/<id>.md`.
2. Confirms `type: hypothesis` and `status: open` (refuses on superseded / refuted / non-hypothesis; says why).
3. Walks the user through the new observation — what was observed, when, how strongly sourced.
4. Builds the row content: `<sourcing> — <observation>`.
5. Calls `scripts/chronicle.sh append <id> --section "Evidence Log" --content "<row>" [--date <date>]`.
6. Reads the entry's Falsifier and Prediction. Asks: did this row cross either threshold?
7. If yes — drafts a `chronicle.sh propose` command for the resolving decision; surfaces for human commit.
8. If no — reports row landed; notes direction (toward / away from threshold).

The skill does not run the propose command itself; it surfaces it for the user to inspect and run.

### Sourcing tag discipline

Always tag the row with the weakest source the observation actually rests on. A dashboard screenshot pasted into Slack is `documented`. A teammate's recollection of a customer call is `verbal`. The PM's hunch about why a number moved is `intuition`. A generic SaaS benchmark from a Substack is `industry`.

If the sourcing tag is unclear, default down (weaker), not up. Future-you reading the Evidence Log will treat `documented` as load-bearing; mis-labeling `verbal` as `documented` poisons that signal across the entire chronicle.

## Examples

### Evidence supporting the prediction (no threshold crossing)

```
User: /hypothesis-track 2026-05-18-invite-friction-blocks-team-activation
       Week-1 Mixpanel shows time-to-activation dropped 22% — short of the 30% prediction but on the right side.

Agent: Appending — `2026-05-20 — documented — Mixpanel: time-to-activation
       dropped 22% in week 1 post-bulk-invite (prediction was 30%; on-path
       but short of threshold)`.

       scripts/chronicle.sh append 2026-05-18-invite-friction-blocks-team-activation \
         --section "Evidence Log" \
         --content "documented — Mixpanel: time-to-activation dropped 22% in week 1 post-bulk-invite (prediction was 30%; on-path but short of threshold)"

       Threshold check: prediction was 30% drop within 60 days. Week 1 sits at
       22%. Neither falsifier nor prediction met. Status stays open; reassess
       at week 4.
```

### Falsifier triggered — propose refutation

```
User: /hypothesis-track 2026-04-10-self-serve-is-enough-for-50-seat-teams
       Discovery call this morning — admin explicitly said SSO config is why
       they stalled.

Agent: Appending — `2026-05-20 — verbal — Discovery: admin at <team> said SSO
       config blocked their team rollout; matches falsifier ("discovery reveals
       SSO blocks admin progression").`

       scripts/chronicle.sh append 2026-04-10-self-serve-is-enough-for-50-seat-teams \
         --section "Evidence Log" \
         --content "verbal — Discovery: admin at <team> said SSO config blocked their team rollout; matches falsifier ('discovery reveals SSO blocks admin progression')."

       Threshold crossed — falsifier triggered. Drafting a resolving decision
       entry for your review:

       scripts/chronicle.sh propose --type decision \
         --title "Sub-50-seat teams need a guided SSO path; self-serve is not enough" \
         --status validated --confidence 0.75 \
         --source-role product-manager --sourcing verbal \
         --scope activation,onboarding --affected-areas "onboarding/,src/sso/" \
         --decision "Sub-50-seat teams need a guided SSO path; the self-serve hypothesis is refuted." \
         --supersedes 2026-04-10-self-serve-is-enough-for-50-seat-teams

       Review the proposal, edit if needed, then `chronicle.sh commit <uuid>`.
       The supersede will flip the hypothesis to `superseded` automatically.
```

## Common Pitfalls

1. **Editing the Prediction or Falsifier after the fact.** They're immutable post-commit by design. If you find yourself wanting to "tighten the prediction" mid-test, the honest move is supersedes — open a new hypothesis with the refined prediction and let the old one resolve as inconclusive.
2. **Labeling intuition as documented.** The hypothesis's overall `sourcing` is the weakest row in the Evidence Log. One mis-labeled row corrupts the entry's trust signal. Default down when unsure.
3. **Letting the Evidence Log grow without re-reading Falsifier and Prediction.** The skill always runs the threshold check; never skip it just because the row "feels small". Several small rows can compound across a 60-day window.
4. **Proposing the resolving decision yourself instead of surfacing it.** The skill drafts the `propose` command; the user inspects and runs. Auto-running supersedes turns the chronicle into a journal — the human gate is the audit trail.
5. **Appending without a date** when the observation is from the past. Use `--date YYYY-MM-DD` to backfill — the row's date should be when the observation happened, not when you got around to recording it.
6. **Running this on `type: decision` entries.** Decisions have no appendable sections; the CLI will refuse. If a decision needs revision, that's supersedes.

## References

- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — `append` and `propose` subcommands.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — append exception, per-type whitelist, row shape.
- [`skills/chronicle-record/SKILL.md`](../chronicle-record/SKILL.md) — original write side; this skill is the post-commit growth path.
- [`skills/chronicle-recall/SKILL.md`](../chronicle-recall/SKILL.md) — read side; useful for surfacing related hypotheses or prior evidence before recording a new row.
- [`skills/review/SKILL.md`](../review/SKILL.md) — weekly sweep; flags hypotheses where this skill should be invoked.
- [`skills/bet-portfolio/SKILL.md`](../../skills/bet-portfolio/SKILL.md) — slated for refactor to aggregate over open hypothesis entries once this skill is in use.
- [PM Brain — `/hypothesis-track`](https://github.com/phuryn/pm-brain) — design influence.
