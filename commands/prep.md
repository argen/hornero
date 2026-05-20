---
description: Produce a one-page meeting brief grounded in the chronicle layer. Pulls a stakeholder entry, decisions and open hypotheses in their scope, and recent ingestion notes. Usage- /prep <person-or-topic>.
argument-hint: <stakeholder-name-or-scope-tag-or-meeting-description>
---

# /prep

The user has a meeting coming up — a 1:1, a QBR, a design review, a vendor call — and wants a one-page brief grounded in what the chronicle already knows.

## What to do

1. **Load and follow [`skills/prep/SKILL.md`](../../skills/prep/SKILL.md)** — it is the canonical procedure. Do not improvise.

2. **Pick the mode** from `$ARGUMENTS`:
   - **Person mode** — argument matches a name or stakeholder slug. Load the `type: stakeholder` entry first, then decisions and hypotheses in their `affected_areas`.
   - **Topic mode** — argument matches a scope tag (e.g. `pricing`, `export`, `strategy`). Load every stakeholder whose `affected_areas` include the tag, plus decisions and hypotheses in that scope.
   - **Free-form** — pick the mode that fits the description; declare which.

3. **Run the chronicle queries** documented in the SKILL. Read the matched entries directly when their summaries aren't enough.

4. **Surface recent ingestion notes** — `ls -t chronicle/ingestion/ | head -10`, read the ones whose slugs match the person or scope. Include them as **References** at the bottom of the brief.

5. **Render the brief** in the fixed six-section shape (Who/what · Open asks or Stakeholders here · Decisions in scope · Open hypotheses · Likely point of disagreement · Suggested questions · References). One page max; empty sections stay empty rather than getting padded.

6. **Stop**. The brief is the deliverable. Do not propose, commit, or open follow-up loops. After the meeting, the user will run `/ingest` on the resulting notes.

7. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /prep — <person|topic> mode on <X>; loading <N> entries from chronicle.
   ```

## Task

$ARGUMENTS
