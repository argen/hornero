# A week with Hornero

A five-day narrative of one PM using Hornero on a real initiative. Not a tutorial; not a feature list. The point is to show how the chronicle layer grows when someone uses it daily, and how the `/ingest`, `/prep`, and `/review` skills compose into a working rhythm.

The PM is fictional. The initiative — pushing activation for sub-50-seat teams — is a stock product situation. The artifacts, commands, and entries are real.

If you've never used Hornero before, [the README](../README.md) is the right starting point. This walkthrough assumes you've installed the plugin and run `/kickoff` once.

---

## Monday — first ingest, first stakeholder

Nour starts the week by opening Hornero in a fresh repo for the activation initiative. The chronicle is empty. The first artifact is a Q2 product-plan doc her predecessor wrote — it has the existing assumptions about activation, an old segment analysis, and a placeholder for the hypothesis the team was meant to test.

```
$ claude
↪ Hornero here. Tell me what you're working on and I'll find the right lens.
> I'm starting on team activation for sub-50-seat customers. Here's the
> existing plan doc: /tmp/q2-activation-plan.md. Bring me up to speed.
```

The dispatcher recognises the artifact and routes through `/ingest`:

> Right — artifact intake. Preserving the doc under `chronicle/source/`, drafting
> a synthesis under `chronicle/ingestion/`. I'll propose the chronicle entries
> the plan implies and pause before any commit.

```bash
scripts/chronicle.sh ingest \
  --path /tmp/q2-activation-plan.md \
  --source-role product-manager \
  --sourcing documented \
  --kind doc \
  --title "Q2 activation plan handoff"
```

The synthesis lands at `chronicle/ingestion/2026-05-18-q2-activation-plan-handoff.md`. Nour reads the doc and fills in the body — four observations tagged `[documented]`, two `[verbal]` (the predecessor's hallway comments), and a single `[intuition]` about which assumption looks weakest.

The synthesis's `## Implications` section proposes two chronicle entries:

1. A stakeholder profile for the predecessor (now in a different team), capturing what she said about activation in the handoff and what she expects this team to revisit.
2. A hypothesis: "Invite-link friction is the primary blocker for teams of <50 seats reaching the activation event." Sourcing: `verbal` (the predecessor's read, not documented data).

Both proposals land under `chronicle/proposals/` for Nour to review. She edits the hypothesis's Falsifier section to be sharper ("time-to-activation stays within ±10% after bulk-invite ships and at least 25% of admins use it"), then commits both.

```bash
scripts/chronicle.sh commit <stakeholder-proposal-uuid>
scripts/chronicle.sh commit <hypothesis-proposal-uuid>
```

`chronicle/SUMMARY.md` regenerates. The chronicle now has two entries. Day one took 25 minutes.

## Tuesday — the customer interview

Tuesday afternoon Nour has a 45-minute call with Hugo, a head of operations at a 32-seat customer. She records the call, runs it through a transcription tool, and ingests the transcript.

```bash
scripts/chronicle.sh ingest \
  --path /tmp/hugo-interview-2026-05-19.txt \
  --source-role product-manager \
  --sourcing documented \
  --kind interview \
  --title "Hugo (32-seat) — onboarding friction"
```

She fills in the synthesis. Six observations:

- "We invited everyone by name, one at a time. It took two days." `[documented]` — direct quote, transcript line 47.
- Three of the eight invitees joined the same week; the rest joined over six weeks or never. `[documented]` — pulled the team's join dates from the admin panel after the call.
- Hugo expected a CSV upload flow and was surprised it didn't exist. `[verbal]` — said in the call, not in the original feature request.
- The team's first activation event happened 27 days after Hugo signed up. `[documented]` — pulled from analytics during the call.
- A faster invite flow probably wouldn't have changed Hugo's adoption shape much; it was the post-invite onboarding that dragged. `[intuition]` — Nour's read; Hugo didn't say this.
- Hugo would pay for a CSV-upload onboarding service today. `[verbal]` — said in the call, no commitment beyond the call.

The frontmatter `sourcing:` is `intuition` — the weakest tag in the body. That label sticks because one of the observations is the author's read, not Hugo's words.

`## Implications` proposes:

1. **Append an evidence row to the open hypothesis** `2026-05-18-invite-link-friction-blocks-team-activation`. The observation that "the post-invite onboarding dragged" is *evidence against* the hypothesis as currently framed. The hypothesis isn't refuted yet — one interview doesn't kill it — but the falsifier is closer to triggering.
2. **A stakeholder entry for Hugo** — affected_areas `[onboarding, billing]`, decision affinity "Strong yes on CSV-upload onboarding; will buy if it ships."

Nour realises the hypothesis needs to be sharpened before the next ingest. She doesn't propose a supersede yet — the falsifier hasn't triggered, just weakened. She edits the hypothesis's Evidence Log directly (the only section where append is the documented mutation pattern) and commits the stakeholder entry.

The chronicle now has three entries — one decision, one hypothesis with one evidence row, one stakeholder — and one ingestion record per artifact.

## Wednesday — `/prep` before design review

Wednesday morning Nour has a design review with the team on the new onboarding flow. She runs `/prep` against the design's scope tag:

```
> /prep onboarding
```

The dispatcher loads:

- The two stakeholder entries (the predecessor, Hugo) — both have `onboarding` in `affected_areas`.
- The single hypothesis on the `activation` scope — `2026-05-18-invite-link-friction-blocks-team-activation`.
- The recent ingestion notes (Q2 plan handoff, Hugo interview) for context.

The brief lands:

```markdown
# Prep — Design review on the new onboarding flow

**Scope tag:** onboarding
**Stakeholders here:** predecessor (handed off Q2 plan), Hugo (32-seat customer; CSV-upload ask).

## Decisions in scope

_None currently in `onboarding` scope — the team is upstream of the binding decisions._

## Open hypotheses in scope

- `2026-05-18-invite-link-friction-blocks-team-activation` — status: open. One evidence row from Hugo interview *weakens* the framing: the post-invite onboarding dragged more than the invite flow itself.

## Likely point of disagreement

The design proposal centres on bulk invite UX. Hugo's evidence suggests that's not the primary blocker — the post-invite onboarding sequence is. The design review may need to widen scope before it narrows on bulk invite.

## Suggested questions

1. What's the data on time-from-invite-sent to first-activation-event? Is it admin-dragged or invitee-dragged?
2. If bulk invite ships and time-to-activation doesn't budge, what's the next hypothesis we'd open?
3. Does the new onboarding sequence address the post-invite drag Hugo described?

## References

- `chronicle/ingestion/2026-05-19-hugo-interview-onboarding-friction.md` — the source for the evidence row that reshaped the hypothesis.
```

Nour walks into the design review with this brief. The team had been about to commit a sprint to bulk-invite UX. The brief reframes the discussion: bulk invite is necessary but probably not sufficient. They scope a second workstream on post-invite onboarding before either ships.

She does not ingest the meeting notes immediately — they're not a self-contained artifact, and the chronicle entry updates will come in Thursday's followup.

## Thursday — decision lands, hypothesis evolves

Thursday is engineering 1:1s and prioritisation. The team agrees to ship bulk invite first (smaller scope, ships in three weeks) and follow with the post-invite onboarding redesign once bulk invite has 60 days of post-rollout data.

Nour ingests the follow-up notes from the engineering syncs:

```bash
scripts/chronicle.sh ingest \
  --path /tmp/eng-1on1-notes-2026-05-21.md \
  --source-role product-manager \
  --sourcing documented \
  --kind meeting \
  --title "Eng prioritisation — bulk invite first, onboarding sequence second"
```

The synthesis's `## Implications` proposes a **decision entry** that *supersedes* the open hypothesis:

```bash
scripts/chronicle.sh propose --type decision \
  --title "Ship bulk invite before redesigning post-invite onboarding" \
  --status validated \
  --confidence 0.75 \
  --source-role product-manager \
  --sourcing documented \
  --scope activation,onboarding,growth \
  --affected-areas "onboarding/,src/invite/" \
  --decision "Ship bulk invite as the canonical activation path for sub-50-seat teams; defer post-invite onboarding redesign until 60 days of post-rollout data." \
  --alternatives "Ship onboarding redesign first,Ship both in parallel" \
  --rejected-reason "Onboarding redesign is twice the scope and the evidence to size it is thin until bulk invite establishes the new baseline,Parallel scope would crowd out other Q3 priorities" \
  --validation "Time-to-activation drops measurably within 60 days of bulk-invite rollout; post-invite-onboarding hypothesis re-opens with fresh data." \
  --supersedes 2026-05-18-invite-link-friction-blocks-team-activation \
  --review-after 2026-08-21
```

Nour reviews the proposal, edits the Diagnosis section to add the team's reasoning about parallel scope, and commits. The hypothesis flips to `superseded`; the new decision is now load-bearing.

She does **not** also propose the post-invite-onboarding hypothesis yet — the new decision's Validation plan explicitly says "re-opens with fresh data." Opening a placeholder hypothesis now would clog the chronicle with low-signal entries. The hypothesis will arrive in 60 days when there's evidence to give it.

The chronicle now has four entries: three stakeholders and one validated decision. The first hypothesis is in the supersedes chain.

## Friday — `/review` weekly sweep

Friday afternoon Nour runs the weekly sweep:

```
> /review
```

The output:

```markdown
# Chronicle review — 2026-05-22

## 1. Stale hypotheses
OK — no stale hypotheses.

## 2. Decisions overdue for revisit
OK — no overdue decisions.

## 3. Stale stakeholder contact
- `2026-05-18-predecessor-pm-handoff` — last contact 2026-05-18 (4 days ago). [OK, within tolerance — surfaces only at 60+ days; nothing fires.]

## 4. Thin sourcing on validated entries
- `2026-05-21-ship-bulk-invite-before-onboarding-redesign` — `status: validated` rests on `sourcing: documented`. [No finding — this is the OK case.]

## 5. Supersedes chain integrity
OK — every supersedes chain links both directions.

## 6. Scope-tag entropy
- `growth` — used by exactly one entry (the Thursday decision). Either accept as singleton or merge into a broader tag like `activation`.
```

The skill drafts one proposal:

```markdown
## Drafted proposals

- Singleton tag `growth` is a near-duplicate of `activation`. Propose tag-merge edit on the decision entry — replace `growth` with `activation` in the scope list.

## Flagged for your call

- The chronicle has four entries from one week of work — healthy ramp. No structural issues to flag.
```

Nour accepts the tag-merge, commits the edit, and stops. The whole sweep took 12 minutes.

She runs `extract-lesson` to close out the harness side of the week and notes one lesson worth keeping: ingestion files with multiple sourcing tags should default the frontmatter to the weakest tag *automatically* — she got it right by hand twice this week, but a future PM might miss it. The proposed delta to `skills/ingest/SKILL.md` is small and ships.

## What changed across the week

| | Day 1 | Day 5 |
|---|---|---|
| Chronicle entries | 0 | 4 (3 stakeholders, 1 decision) |
| Ingestion files | 0 | 3 (plan handoff, customer interview, eng prioritisation) |
| Open hypotheses | 0 | 0 (one opened, one superseded into decision) |
| Stale items | n/a | 0 |

Five days, ten artifacts. None of it sits in Slack scrollback or in Nour's head. The next session — whether tomorrow or in six weeks, whether Nour or a teammate — loads `chronicle/SUMMARY.md` cold and picks up upstream of every decision she made.

This is the leverage Hornero is built for. Not "the AI takes the PM's job"; not "the AI writes the PRDs". Just: the durable record the team would have built by hand, kept up, every week, without anyone forgetting.

## When this rhythm breaks

The walkthrough assumes Nour did the work. Hornero can scaffold every step, but the chronicle compounds only if someone tends it. The failure modes the team should watch for:

- **Ingestion that never crystallises.** If artifacts pile up in `chronicle/ingestion/` without ever producing chronicle entry proposals, the working layer is fine but the durable layer isn't growing. The `/review` sweep doesn't catch this — it watches the entries layer. Watch your `ingestion/` to `entries/` ratio.
- **`/review` always returns OK.** Either the chronicle is genuinely healthy, or it's stale. Three consecutive OK runs is signal to drop the cadence; six is signal to ask whether anyone is actually using the chronicle.
- **Recurring corrections from `/extract-lesson` about the chronicle.** If `extract-lesson` keeps proposing chronicle-discipline updates, the discipline is leaking. Pause the rhythm; do a chronicle-discipline refresh; resume.

The harness measures itself. Trust the measurements over your intuition about whether things are going well.

## References

- [`chronicle/README.md`](../chronicle/README.md) — layer overview.
- [`chronicle/SCHEMA.md`](../chronicle/SCHEMA.md) — the entry shapes (decision, hypothesis, stakeholder).
- [`skills/ingest`](../skills/ingest/SKILL.md), [`skills/prep`](../skills/prep/SKILL.md), [`skills/review`](../skills/review/SKILL.md) — the three skills this walkthrough exercises end-to-end.
- [`skills/chronicle-record`](../skills/chronicle-record/SKILL.md), [`skills/chronicle-recall`](../skills/chronicle-recall/SKILL.md) — the write and read primitives the workflow rests on.
- [`playbooks/feedback-ritual.md`](../playbooks/feedback-ritual.md) — the weekly cadence the Friday sweep belongs to.
- [`examples/sample-session.md`](sample-session.md) — single-session example; complementary to this multi-day arc.
- [PM Brain — "Lena's first five days"](https://github.com/phuryn/pm-brain) — the design influence for this narrative shape.
