---
description: Append a dated row to a B2B customer's chronicle entry — Usage shape, Health signals, Decision drivers, or Stakeholders — without forcing a full supersede. Surface threshold crossings (renewal risk, churn flag) for the user's call. Usage- /customer-update <customer-id>.
---

# /customer-update

The user has a meaningful signal on a B2B account — metric shift, support escalation, SLA event, expansion path change, or a new contact discovered — that should land on the account's chronicle entry while it's fresh. The skill makes the append one command, one row, one section.

## What to do

1. **Load and follow [`skills/customer-update/SKILL.md`](../skills/customer-update/SKILL.md)** — it is the canonical procedure. Do not improvise the threshold check or the stakeholder-bridge step.

2. **Confirm the entry is type: customer.** Read `chronicle/entries/<id>.md`. If it's a stakeholder entry, redirect to `/stakeholder-update`. If it's something else (decision, hypothesis), say so and stop.

3. **Decide the section.** One section per signal:
   - **Metric / behavioural shift** → Usage shape
   - **Support / SLA / NPS / churn signal** → Health signals
   - **Expansion-path, stakeholder posture, contract-terms shift** → Decision drivers
   - **New person discovered inside the account** → Stakeholders

   All four sections append (no prepend). If one event hits two sections, do TWO appends.

4. **Build the row** — date (default today, override with `--date`), then a one-line signal, optional source. One claim per row.

5. **Append** via `scripts/chronicle.sh append <id> --section "<Section>" --content "<content>" [--date YYYY-MM-DD]`.

6. **Read Decision drivers — threshold check.** Did this new row cross a threshold the entry already names (renewal risk, churn flag, expansion gate)?
   - **Crossed** → surface for the user's call. Frame the question (e.g., "Acme has now hit the SLA-breach pattern the entry warned about. Escalate to Maya before the Friday QBR?"). Do NOT auto-propose a churn or renewal-risk decision — escalation is the user's call.
   - **Trending but not crossed** → note direction of travel so the user can decide whether to start treating it as a leading indicator.

7. **If the append was to Stakeholders, prompt for a follow-up.** A new person inside the account warrants a `type: stakeholder` entry of their own. The Stakeholders row is the placeholder; the per-person entry is the durable record. Surface the prompt — do not auto-open the stakeholder entry.

8. **Pair with `/prep`.** Account briefs read from this entry. The brief is only as fresh as the rows this skill appends — that's the whole point of keeping it current.

9. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /customer-update — appending to <Section> on <id>.
   ```
