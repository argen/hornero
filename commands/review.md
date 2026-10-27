---
description: Weekly chronicle-health sweep. Runs six checks, drafts proposals for unambiguous fixes, surfaces the rest for a human call. Usage- /review (no arguments).
---

# /review

The user is doing the weekly chronicle maintenance pass — typically Friday afternoon. The chronicle stays load-bearing only if someone tends it; this is how that tending happens.

## What to do

1. **Load and follow [`skills/review/SKILL.md`](../skills/review/SKILL.md)** — it is the canonical procedure. Do not improvise the checks.

2. **Run `scripts/chronicle.sh review`** and read the report. Six sections, one per check:
   - Stale hypotheses (review_after passed, status still open)
   - Decisions overdue for revisit
   - Stale stakeholder contact (60+ days)
   - Thin sourcing on validated entries (intuition / industry)
   - Supersedes chain integrity
   - Scope-tag entropy (singletons)

3. **For each non-OK section, split findings into act vs flag** per the SKILL's discipline:
   - Act → draft a `scripts/chronicle.sh propose ...` command (do not commit).
   - Flag → bullet under "Flagged for your call" with the context the user needs to make the call.

4. **Triage if the report is heavy** (>15 findings): walk top 5 by impact; defer the rest; surface the volume as a structural issue.

5. **Render the three-part output**:
   - One-line summary (`Reviewed N entries; M findings; K proposals drafted, L flagged.`)
   - Drafted proposals (each as a ready-to-run `chronicle.sh propose` command).
   - Flagged for your call (bullets, no decisions attached).

6. **Stop.** The user reviews proposals and commits the accepted ones via `chronicle.sh commit <uuid>`. The skill does not auto-commit; the human-gated commit path is structural.

7. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /review — six chronicle-health checks; reading the report now.
   ```
