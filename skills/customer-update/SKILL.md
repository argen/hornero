---
name: customer-update
description: "Use after a meaningful event on a B2B customer account — new metric snapshot, support escalation, SLA event, expansion signal, or a new contact discovered. Appends to the relevant section on the `type: customer` chronicle entry (Usage shape, Health signals, Decision drivers, Stakeholders) via `chronicle.sh append`, keeping the account picture current without forcing a full supersede."
intent: |
  Make B2B account tending mechanical. Without this skill, account
  signals surface in dashboards, support tickets, and CSM Slack threads
  and never land on the customer's chronicle entry; expansion gates and
  churn risks go un-tracked across renewal windows. With it, each
  meaningful event becomes a one-line append the moment it happens, and
  the entry stays a current picture of the account.
argument-hint: <customer-id>
type: workflow
theme: memory
best_for:
  - After a metric snapshot reveals a behavioural shift (append to Usage shape)
  - After a support escalation, NPS movement, SLA breach, or churn signal (append to Health signals)
  - After a stakeholder posture shift on the account (append to Decision drivers)
  - After meeting a new person inside the account (append to Stakeholders, with a link to open a new stakeholder entry)
  - During `/review` when an account approaches renewal and its entry is stale
scenarios:
  - "Acme had its second export SLA breach in 30 days; CSM flags it in the account channel. PM runs customer-update — appends `- 2026-05-20 — Export SLA breach reported on 2026-05-19 (second breach in 30 days).` to Health signals. Acme's renewal is 2026-09-30; the entry already cites export latency as a renewal risk."
  - "Quarterly usage check: Acme's DAU/MAU dropped from 0.62 to 0.55. customer-update appends to Usage shape: `- 2026-05-20 — DAU/MAU = 0.55 (down from 0.62 last quarter); decline now sustained over two quarters.`"
  - "PM met Devlin (CFO at Acme) for the first time; he owns the per-seat invoicing ask. customer-update appends to Stakeholders: `- 2026-05-20 — Devlin (CFO at Acme) — owner of per-seat invoicing ask. Stakeholder entry to be opened next session.`"
estimated_time: 1-3 minutes
---

# Customer update

## Purpose

Keep each B2B account's chronicle entry a current picture of the account — what usage looks like, what's threatening renewal, what would unlock expansion, who's inside it. The entry is the account's row in the team's mental CRM; the cost of updating it must be near-zero or the entry rots and renewal conversations re-derive context that was already paid for.

The skill writes to four sections on `type: customer` entries: Usage shape, Health signals, Decision drivers, Stakeholders. It does not touch Account profile (foundational framing — contract terms, seats, plan; changes there are supersedes-shaped) or Notes.

## Key Concepts

### One section per event

A typical account event hits exactly one section:

- **A metric or behavioural shift** → Usage shape (e.g., DAU/MAU change, feature adoption drop, activation rate)
- **A support / SLA / NPS / churn signal** → Health signals (e.g., escalation, breach, score movement)
- **A stakeholder shift, expansion path change, contract-terms posture** → Decision drivers
- **A new person discovered inside the account** → Stakeholders (with a follow-up to open a stakeholder entry for them)

If one event hits two sections (e.g., a metric drop AND a support escalation referencing that metric), run the skill twice — one row per logical signal.

### All four sections append (none prepend)

Per [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md), the append exception's prepend rule applies only to `Last contact` on stakeholder entries. Customer sections all grow chronologically — oldest at top, newest at bottom. That's the right shape for trending signals: the eye reads down the section to see the trajectory.

### Row shape: dated, terse, one-signal-per-row

```
- 2026-05-20 — DAU/MAU = 0.55 (down from 0.62 last quarter); decline now sustained over two quarters.
- 2026-05-20 — Export SLA breach reported on 2026-05-19 (second breach in 30 days).
- 2026-05-20 — Devlin (CFO at Acme) — owner of per-seat invoicing ask. Stakeholder entry to be opened next session.
```

Date, then the signal, then optional source-of-signal. One claim per row; if a signal is rich (e.g., a full quarterly readout), the row should summarise; the detail belongs in an ingestion synthesis (`/ingest`) and the row links to it.

### The Stakeholders section is the bridge to per-person entries

When a new contact surfaces inside the account, the row in Stakeholders is the bridge: it captures *who they are* and *that an entry will follow*. The customer entry's Stakeholders section is a roster; per-person entries (`type: stakeholder`) live separately. The two are linked by id reference, not by foreign key.

After appending to Stakeholders, prompt the user to also open a `type: stakeholder` entry for the new person via `chronicle-record` — the customer-update row is the placeholder; the stakeholder entry is the durable record.

### Trending vs threshold-crossing signals

Like hypothesis-track, customer-update reads the entry's Decision drivers after the append to ask: did this signal cross a threshold the entry already names? Two outcomes:

1. **Threshold crossed** (e.g., a renewal-risk flag the entry says was contingent on a certain SLA breach pattern, now triggered): surface a proposal for a decision entry — e.g., "renewal at risk; recommend escalation". The skill drafts; the user commits.
2. **Trending but not crossed**: keep the entry as-is; note in conversation the direction of travel so the user can decide whether to start treating it as a leading indicator.

Never auto-propose a churn flag or renewal-risk decision. The escalation is the user's call; the skill surfaces, doesn't fire.

## Application

### How to invoke

```
/customer-update <customer-id>
```

Followed by, in conversation: which section, the content, optionally a date override. The skill:

1. Reads the customer entry at `chronicle/entries/<id>.md`.
2. Confirms `type: customer` (refuses on other types; says which type the entry is).
3. Asks which section if not stated.
4. Builds the row content (one line, dated automatically unless `--date` given).
5. Calls `scripts/chronicle.sh append <id> --section "<Section>" --content "<content>"`.
6. Reports the row landed.
7. Reads Decision drivers; if the new row crosses a named threshold, surfaces a proposal.
8. If the new row was in Stakeholders, prompts the user to open a `type: stakeholder` entry for the new person.

### Pairing with `/review` and `/prep`

`/review` surfaces stale customer entries (no updates in 60+ days on an active account); `customer-update` is how those get refreshed.

`/prep` reads from customer entries when building briefs for account-touching meetings (e.g., a QBR with Acme). The brief is only as fresh as the rows this skill appends — keep them current and the brief is grounded in reality, not in last quarter's snapshot.

### Invocation notes

Pick the section per signal: a metric or behavioural shift goes to Usage shape; a support, SLA, NPS, or churn signal to Health signals; an expansion-path, posture, or contract-terms shift to Decision drivers; a newly discovered person to Stakeholders. All four append at the bottom. If one event hits two sections, do two appends. If the entry is `type: stakeholder`, redirect to `/stakeholder-update`. A crossed threshold (renewal risk, churn flag) is surfaced for the user's call; never auto-propose a churn or renewal-risk decision.

Declare the route in one line before starting (per `VOICE.md`):

```
/customer-update — appending to <Section> on <id>.
```

## Examples

### Metric snapshot showing decline

```
User: /customer-update 2026-05-20-acme-corp
       Quarterly usage check — Acme's DAU/MAU dropped from 0.62 to 0.55. Decline
       now sustained over two quarters.

Agent: Appending to Usage shape:

       scripts/chronicle.sh append 2026-05-20-acme-corp \
         --section "Usage shape" \
         --content "DAU/MAU = 0.55 (down from 0.62 last quarter); decline now sustained over two quarters."

       ✓ Row added.

       Decision drivers note: Acme's entry already cites export performance as
       a renewal driver and DAU/MAU as a leading indicator. Two consecutive
       quarters of decline crosses the threshold the entry names. Surface for
       your call — should we treat Acme renewal as 'at-risk' in the Q3 pipeline?
       (Not auto-proposing; this is a judgement call.)
```

### SLA breach (recurring pattern)

```
User: /customer-update 2026-05-20-acme-corp
       Export SLA breach reported on 2026-05-19 — second breach in 30 days.

Agent: Appending to Health signals:

       scripts/chronicle.sh append 2026-05-20-acme-corp \
         --section "Health signals" \
         --content "Export SLA breach reported on 2026-05-19 (second breach in 30 days)."

       ✓ Row added.

       Decision drivers note: Acme's entry names export latency as the primary
       deal-breaker risk. Two breaches in 30 days is the pattern the entry
       warned about. Surface for your call — escalate to Maya (VP Sales)
       before the Friday QBR?
```

### New stakeholder discovered

```
User: /customer-update 2026-05-20-acme-corp
       Met Devlin today — he's the CFO at Acme, and the owner of the per-seat
       invoicing ask.

Agent: Appending to Stakeholders:

       scripts/chronicle.sh append 2026-05-20-acme-corp \
         --section "Stakeholders" \
         --content "Devlin (CFO at Acme) — owner of per-seat invoicing ask. Stakeholder entry to be opened next session."

       ✓ Row added.

       Follow-up: open a `type: stakeholder` entry for Devlin via
       `chronicle-record`. The row in Acme's Stakeholders is the placeholder;
       Devlin's own entry is where his asks, concerns, and last-contact will
       live.
```

## Common Pitfalls

1. **Recording a contract change via append.** A renewal, plan upgrade, or seat-count shift is a fundamental change to the account profile. That's supersedes — open a new customer entry with the updated Account profile and link.
2. **Letting Stakeholders become a CRM substitute.** The customer entry's Stakeholders section is a roster, not the per-person record. Open separate `type: stakeholder` entries for anyone who'll be touched more than once.
3. **Auto-flagging renewal-at-risk.** The skill never drafts a churn or renewal-risk decision. The escalation is the user's call; the skill surfaces signals, doesn't fire alarms.
4. **Editing prior rows when a signal resolves.** A resolved support escalation gets a new row noting the resolution, not an edit to the original. The trajectory is the asset.
5. **Recording sub-signal noise.** One row per *meaningful* signal. A single support ticket in isolation usually doesn't warrant a Health signals row; a pattern across tickets does. Use judgement; if every router-flap creates a row, the section becomes noise.
6. **Running this on `type: stakeholder` entries.** That's `stakeholder-update`. The two are siblings — customer is the account, stakeholder is the person.

## References

- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — `append` subcommand.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — append exception, per-type whitelist.
- [`skills/chronicle-record/SKILL.md`](../chronicle-record/SKILL.md) — original write side; this skill is the post-commit growth path for customer entries.
- [`skills/stakeholder-update/SKILL.md`](../stakeholder-update/SKILL.md) — sibling skill for `type: stakeholder` entries.
- [`skills/review/SKILL.md`](../review/SKILL.md) — weekly sweep; flags stale customer entries this skill should refresh.
- [`skills/prep/SKILL.md`](../prep/SKILL.md) — read side; account briefs are only as fresh as the rows this skill appends.
- [`skills/ingest/SKILL.md`](../ingest/SKILL.md) — for rich account signals (QBR transcript, support thread): ingest first, then append a one-line summary row that links to the synthesis.
