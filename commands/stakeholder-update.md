---
description: Append a dated row to a stakeholder's chronicle entry — Open asks, Concerns, Last contact (prepended), or Decision affinity — without forcing a full supersede. Usage- /stakeholder-update <stakeholder-id>.
---

# /stakeholder-update

The user just touched a stakeholder (1:1, Slack thread, meeting outcome, ad-hoc ask) and that touch should land on the stakeholder's chronicle entry while the detail is fresh. The skill makes the append one command, one row, one section.

## What to do

1. **Load and follow [`skills/stakeholder-update/SKILL.md`](../skills/stakeholder-update/SKILL.md)** — it is the canonical procedure. Do not improvise the section split.

2. **Confirm the entry is type: stakeholder.** Read `chronicle/entries/<id>.md`. If it's not a stakeholder, say which type it is and stop. If it's a `type: customer` entry, redirect to `/customer-update`.

3. **Decide the section.** One section per touchpoint:
   - **1:1, sync, meeting** → Last contact (always, prepended — newest first)
   - **A new ask surfaced** → Open asks
   - **A new concern surfaced** → Concerns
   - **A predictable yes/no/neutral revealed** → Decision affinity

   If one touch hit two sections (e.g., a 1:1 raised a new ask), do TWO appends — one per logical observation. Do not lump.

4. **Build the row** — date (default today, override with `--date`), then a one-line observation, optional source-of-observation in parens. Keep to one row per logical claim.

5. **Append** via `scripts/chronicle.sh append <id> --section "<Section>" --content "<content>" [--date YYYY-MM-DD]`.

6. **Report and flag.** Confirm the row landed. If the touch implied a foundational change (departure, promotion, scope shift), surface that as a supersedes proposal — do NOT auto-run. Foundational changes to Role & influence travel via supersedes, not append.

7. **Pair with `/review`.** If `/review` flagged this stakeholder as stale-contact (no Last contact update in 60+ days) and the user actually has pinged them, use `--date` to record the real date — never backfill a fake row.

8. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /stakeholder-update — appending to <Section> on <id>.
   ```
