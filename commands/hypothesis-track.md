---
description: Append evidence to an open `type: hypothesis` chronicle entry; surface threshold crossings (falsifier triggered or prediction met) as supersedes proposals. Usage- /hypothesis-track <hypothesis-id>.
---

# /hypothesis-track

The user has a new observation that bears on an open hypothesis. The skill records it on the entry's Evidence Log without churning the supersedes chain, then checks whether the row crosses the threshold the entry's Falsifier or Prediction already names.

## What to do

1. **Load and follow [`skills/hypothesis-track/SKILL.md`](../../skills/hypothesis-track/SKILL.md)** — it is the canonical procedure. Do not improvise the threshold check.

2. **Confirm the entry is type: hypothesis and status: open.** Read `chronicle/entries/<id>.md`. If it's not a hypothesis, say which type it is and stop. If it's not open (superseded / refuted / validated), say so and ask whether the user wants to record evidence on a closed entry anyway (rare; usually means a new hypothesis is warranted).

3. **Walk the observation.** Get from the user: what was observed, when (default today), how strongly sourced (`documented` / `verbal` / `intuition` / `industry`). Default sourcing **down** when uncertain — overstating sourcing corrupts the chronicle's trust signal.

4. **Append the row** via `scripts/chronicle.sh append <id> --section "Evidence Log" --content "<sourcing> — <observation>" [--date YYYY-MM-DD]`.

5. **Read the entry's Falsifier and Prediction.** Ask one question: did this new row cross a named threshold?
   - **Falsifier triggered** → draft a `chronicle.sh propose --type decision --supersedes <id> --status validated ...` command that captures what the team now believes instead. Surface for human commit. Do NOT auto-run.
   - **Prediction met (or exceeded)** → draft a `chronicle.sh propose --type decision --supersedes <id> --status validated ...` command that promotes the assumption to settled posture. Surface; do not run.
   - **Neither crossed** → report the row landed; name the direction of travel (toward / away from each threshold) so the user knows where the entry now sits.

6. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /hypothesis-track — appending evidence and checking thresholds on <id>.
   ```
