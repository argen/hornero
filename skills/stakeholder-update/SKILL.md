---
name: stakeholder-update
description: "Use after any meaningful touchpoint with a stakeholder (1:1, ad-hoc Slack, meeting outcome) — appends to the relevant section on their `type: stakeholder` chronicle entry (Open asks, Concerns, Last contact, Decision affinity) via `chronicle.sh append`, keeping the entry current without forcing a full supersede."
intent: |
  Make stakeholder tending mechanical. Without this skill, asks and
  concerns surface in conversation and never land on the person's
  chronicle entry; Last contact dates atrophy; the /review weekly check
  flags every stakeholder as stale. With it, each touch becomes a
  one-line append the moment it happens, and the entry stays a current
  picture of where this person sits.
type: workflow
theme: memory
best_for:
  - After a 1:1 (always append to Last contact)
  - After a stakeholder surfaces a new ask in any channel (append to Open asks)
  - After a stakeholder voices a new concern about a roadmap call (append to Concerns)
  - After a stakeholder's posture shifts on a scope tag (append to Decision affinity)
  - During `/review` when a stale-contact finding fires and you've actually pinged them since
scenarios:
  - "VP Sales (Maya) raises in QBR follow-up: 'we need SSO audit-log export by Q3 for two pending enterprise deals'. PM runs stakeholder-update on Maya's entry — appends `- 2026-05-20 — SSO audit-log export (raised in QBR follow-up)` to Open asks."
  - "PM had a 1:1 with the Head of Engineering (Devlin); discussion was a roadmap-resequencing sync. Stakeholder-update appends to Last contact (prepended, newest first): `- 2026-05-20 — 1:1 sync. Walked through Q3 roadmap; Devlin signed off on export-first sequencing.`"
  - "After a difficult product review, Devlin escalates concern about the migration risk on the export rewrite. Stakeholder-update appends to Concerns: `- 2026-05-20 — Migration risk on export rewrite — wants a parallel-run plan before the cutover.`"
estimated_time: 1-3 minutes
---

# Stakeholder update

## Purpose

Keep each stakeholder's chronicle entry a current picture of where they sit — open asks not yet resolved, concerns surfaced and not yet addressed, when we last touched them, what they're predictably for / against. The entry is only useful if it stays current; the cost of keeping it current must be near-zero or it doesn't happen.

The skill writes to four sections on `type: stakeholder` entries: Open asks, Concerns, Last contact, Decision affinity. It does not touch Role & influence (that's the entry's foundational framing — changes there are supersedes-shaped) or Notes (free-form, edited by hand when needed).

## Key Concepts

### One section per touchpoint

A typical touchpoint hits exactly one section:

- **1:1, sync, or meeting** → Last contact (always; prepended so newest is at top)
- **A new ask surfaced** → Open asks
- **A new concern surfaced** → Concerns
- **A predictable yes/no/neutral revealed** → Decision affinity

If a single touchpoint hits two sections (e.g., a 1:1 where a new ask was raised), run the skill twice — once per section. That keeps the audit trail clean: one row per logical observation.

### Last contact prepends; everything else appends

Per [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md), the append exception treats Last contact specially. The most recent touch belongs at the top of the section so the cold-read sees it first and the weekly `/review` staleness check finds the freshest date on its first scan. Open asks, Concerns, and Decision affinity grow chronologically — oldest at top, newest at bottom — because they represent accumulating context, not state.

### Row shape: dated, terse, one-claim-per-row

```
- 2026-05-20 — SSO audit-log export (raised in QBR follow-up)
- 2026-05-20 — 1:1 sync. Walked through Q3 export roadmap; Maya signed off on the sequencing.
- 2026-05-20 — Migration risk on export rewrite — wants a parallel-run plan before the cutover.
```

The row carries: date, then the observation, then optional source-of-observation in parens. Keep it to one line where possible. If the touchpoint produced rich material, the row should summarise; the detail goes in an ingestion synthesis (`/ingest`) and the row links to it.

### Asks that resolve → don't edit, prepend a resolution row OR open a decision

When an Open ask gets resolved, **do not edit the original row**. Two options:

1. Append a new row in Open asks: `- 2026-06-15 — RESOLVED: SSO audit-log export shipped (see decision 2026-06-15-sso-audit-export).` The original ask stays visible — the audit trail shows the ask was raised, sat for N weeks, then resolved.
2. If the resolution is itself a decision worth its own chronicle entry, `chronicle-record` writes the decision; the stakeholder entry links to it from the resolution row.

The same pattern applies to Concerns: a concern that gets addressed gets a new row noting the resolution, not an edit to the original.

### Decision affinity is the sub-format exception

The Decision affinity section typically uses sub-bullets like `- **Strong yes:** ...` rather than dated rows. The append skill writes `- 2026-05-20 — <content>` regardless. That sits alongside the sub-bullets cleanly — a date-stamped row that says "shifted from neutral to strong-yes on export" is legible without breaking the section's format. If the entry's Decision affinity needs a structural rewrite (e.g., re-categorising what they support), that's supersedes territory.

## Application

### How to invoke

```
/stakeholder-update <stakeholder-id>
```

Followed by, in conversation: which section, the content, optionally a date override. The skill:

1. Reads the stakeholder entry at `chronicle/entries/<id>.md`.
2. Confirms `type: stakeholder` (refuses on other types; says which type the entry is).
3. Asks which section if not stated.
4. Builds the row content (one line, dated automatically unless `--date` given).
5. Calls `scripts/chronicle.sh append <id> --section "<Section>" --content "<content>"`.
6. Reports the row landed.
7. If the touch was a 1:1 / meeting and asks / concerns were raised, prompts the user to run the skill again for each.

The skill never auto-runs supersedes. If the stakeholder's foundational role changed (e.g., promotion, departure, scope shift), that's a new entry that supersedes the old one — surface that prompt, don't do it silently.

### Pairing with /review

When `/review` flags a stakeholder as stale (no Last contact update in 60+ days), the appropriate response is usually one of:

- You actually have pinged them since but didn't record it → run stakeholder-update with the actual date (`--date YYYY-MM-DD`).
- You haven't pinged them → flag for the next 1:1 cadence; don't record a fake row.
- They've left the org / scope → propose a supersedes (new entry, `status: superseded`, role marked closed).

## Examples

### New ask raised in QBR follow-up

```
User: /stakeholder-update 2026-05-19-maya-vp-sales
       Maya raised SSO audit-log export in the QBR follow-up — needed by Q3
       for two pending enterprise deals.

Agent: Appending to Open asks:

       scripts/chronicle.sh append 2026-05-19-maya-vp-sales \
         --section "Open asks" \
         --content "SSO audit-log export (raised in QBR follow-up; needed by Q3 for two pending enterprise deals)"

       ✓ Row added. Maya's Open asks now carries the new line at the bottom.
       Last contact was 2026-05-15 (5 days ago); no Last contact update
       needed.
```

### 1:1 with a new concern surfaced

```
User: /stakeholder-update 2026-05-19-devlin-head-of-eng
       Just had a 1:1 with Devlin. Walked the Q3 roadmap; he signed off on
       export-first sequencing, but raised a concern about migration risk on
       the export rewrite — wants a parallel-run plan before any cutover.

Agent: This touch hits two sections. I'll append to both.

       1. Last contact (prepended):
          scripts/chronicle.sh append 2026-05-19-devlin-head-of-eng \
            --section "Last contact" \
            --content "1:1 sync. Walked Q3 roadmap; Devlin signed off on export-first sequencing."

       2. Concerns:
          scripts/chronicle.sh append 2026-05-19-devlin-head-of-eng \
            --section "Concerns" \
            --content "Migration risk on export rewrite — wants a parallel-run plan before the cutover."

       Both rows landed. The migration-risk concern is the one most likely to
       affect roadmap calls; worth surfacing in the next product review.
```

## Common Pitfalls

1. **Editing old rows when state changes.** Open asks and Concerns are append-only by design. Resolution gets a new row that references the old one; the audit trail is the asset.
2. **Lumping multiple observations into one row.** One ask per row. One concern per row. If a 1:1 surfaced three asks, that's three calls to the skill — the rows are the queryable atoms.
3. **Skipping Last contact when there was no "real outcome".** Even a 15-minute Slack thread counts as a touch. Last contact's purpose is staleness detection, not outcome documentation — the row can simply read `- 2026-05-20 — Slack thread on Q3 export sequencing; no asks or concerns raised.`
4. **Recording stakeholder departures via append.** A stakeholder leaving the org or scope is a fundamental change to the entry's framing. That's supersedes — open a new entry with `status: superseded` and link, don't try to capture it in Notes.
5. **Editing Role & influence to reflect a promotion.** Same as departure — supersedes. Role & influence is part of the entry's foundational shape; changes there are entry-level, not row-level.
6. **Running this on `type: customer` entries.** Customer entries have their own update skill (`customer-update`). The two are siblings; this one is for individual people, that one is for accounts.

## References

- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — `append` subcommand.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — append exception, per-type whitelist, Last contact prepend semantics.
- [`skills/chronicle-record/SKILL.md`](../chronicle-record/SKILL.md) — original write side; this skill is the post-commit growth path for stakeholder entries.
- [`skills/customer-update/SKILL.md`](../customer-update/SKILL.md) — sibling skill for `type: customer` entries.
- [`skills/review/SKILL.md`](../review/SKILL.md) — weekly sweep; flags stale-contact stakeholders this skill should update.
- [`skills/prep/SKILL.md`](../prep/SKILL.md) — read side; the brief it produces is only as fresh as the rows this skill appends.
- [PM Brain — `/stakeholder-update`](https://github.com/phuryn/pm-brain) — design influence.
