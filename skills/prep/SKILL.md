---
name: prep
description: "Use before a meeting, 1:1, design review, vendor call, or QBR — pulls the matching `type: stakeholder` entry, recent `type: decision` and open `type: hypothesis` entries in their scope, and recent ingestion notes, then renders a one-page brief with open asks, likely points of disagreement, and suggested questions."
intent: |
  Make a meeting brief mechanical rather than memory-bound. Without this
  skill, the PM walks into a stakeholder meeting carrying a partial
  recollection of "their last ask" and "what we decided about that area";
  the rest gets re-derived from Slack scrollback or fresh asking. With
  it, every meeting starts from a tight one-pager grounded in the
  durable chronicle layer.
type: workflow
theme: memory
best_for:
  - Before a stakeholder 1:1 or QBR (a sales VP, an engineering lead, a board member)
  - Before a vendor call where there is open contractual context
  - Before a design review where the participants have varied stakes
  - Before an analyst briefing or executive update
  - Whenever the user says "I have a meeting with X tomorrow, what do I need to know?"
scenarios:
  - "PM has a QBR with Maya (VP Sales) tomorrow. `/prep Maya` loads the Maya stakeholder entry (3 open asks, 1 concern, last contact 2 weeks ago), pulls the validated decisions in her affected_areas (export, billing, contracts) — and the open hypothesis about export latency driving enterprise churn. The brief leads with her top open ask and the one decision she is most likely to push back on."
  - "PM has a design review on the new pricing surface tomorrow. `/prep pricing` loads every stakeholder whose affected_areas include `pricing`, the validated pricing decisions, and the open hypotheses on the pricing-strategy scope. The brief surfaces the two stakeholders most likely to attend and the decision-bind they'll see in the surface."
  - "PM has a board call with a quarterly update on the SMB-vs-mid-market posture. `/prep strategy` loads the 2026-05-15 refuse-SMB-segment decision (validated, documented), the supersedes chain, and any open hypotheses about the posture. The brief frames what changed since last quarter and the next falsifier-trigger that would re-open the question."
estimated_time: 3-7 minutes
---

# Prep

## Purpose

Produce a one-page meeting brief grounded in the project's chronicle. The brief names: the person or topic, their open asks, the decisions in their scope they are most likely to engage with, the open hypotheses they could help resolve, and 3-5 suggested questions or talking points. The output is short on purpose — it fits a phone screen — because long briefs go unread.

This skill closes the gap between "we have a chronicle layer" and "the PM walks into the meeting with the chronicle loaded." Without it, the chronicle is a record consulted *after* meetings (during writeups) rather than *before* them (during prep).

## Key Concepts

### Two invocation modes: by person, by topic

`/prep <person-name>` builds a brief centred on a specific stakeholder — pulls the matching `type: stakeholder` entry, then expands into decisions and hypotheses in their `affected_areas`. Use before 1:1s, QBRs, and vendor calls.

`/prep <scope-tag>` builds a brief centred on a scope — pulls every stakeholder whose `affected_areas` include the tag, plus validated decisions and open hypotheses in that scope, **plus any `type: customer` accounts whose `scope` or `affected_areas` overlap**. The customer entries surface in a "Accounts in scope" section alongside stakeholders; use before design reviews, roadmap meetings, QBRs, and any B2B-shaped discussion where account context matters as much as person context.

The two modes share the same output shape; only the loading order differs.

For B2B teams, the person/account distinction is load-bearing — Hugo at Acme has different open asks than the Acme account has health signals, and a meeting about "Acme's renewal" is differently shaped from a meeting about "Hugo's per-seat invoicing ask." The prep brief surfaces both layers when both are relevant.

### What goes in the brief

Six sections, in fixed order:

1. **Who/what** — one line: the meeting subject and the scope tags it touches.
2. **Their open asks** (person mode) or **The stakeholders here** (topic mode) — bulleted, with dates and last-mentioned source.
3. **Decisions in scope** — recent `type: decision` entries with `status: validated` whose `affected_areas` or `scope` overlap. Most-recent first, ≤5.
4. **Open hypotheses in scope** — `type: hypothesis` with `status: open` or `status: weakening` / `strengthening`. These are the natural place to gather more evidence in the meeting.
5. **Likely point of disagreement** — one sentence. The single most probable friction point given the loaded entries. This is the load-bearing line; if you can't fill it, the brief isn't done.
6. **Suggested questions** — 3-5 bullets. Diagnostic, not advocacy. Each question should resolve an open hypothesis, surface a new ask, or test a stakeholder's continued alignment.

If a section is genuinely empty (no stakeholders found, no open hypotheses), say so in one line rather than padding. Empty signals are signal.

### Ingestion notes are second-class

`/prep` may also surface recent `chronicle/ingestion/*.md` files in the relevant scope — useful when an interview or QBR happened recently and the synthesis hasn't crystallised into chronicle entries yet. Include them as **References** at the bottom of the brief, not in the main body. The committed entries are the binding source; ingestion notes are the working layer feeding them.

### What this skill does NOT do

- It does not auto-write meeting notes. The output is *input* to the meeting, not output from it. After the meeting, use `/ingest` on the resulting notes if they're worth preserving.
- It does not modify any chronicle entry. Read-only by construction.
- It does not predict outcomes. "Likely point of disagreement" is the agent's best read of the loaded entries, not a forecast — flag uncertainty when the read is thin.

## Application

### How to invoke

```bash
/prep Maya              # person mode — case-insensitive match on stakeholder title/id
/prep export            # topic mode — case-insensitive match on scope tag
/prep billing           # topic mode
/prep "QBR with Maya"   # free-form — agent picks person or topic mode based on content
```

The agent then runs `chronicle-recall` queries to load the relevant entries:

```bash
# Person mode (example: /prep Maya)
scripts/chronicle.sh query --type stakeholder --keyword Maya
# Then for each affected_area in the stakeholder entry:
scripts/chronicle.sh query --type decision --status validated --scope <area>
scripts/chronicle.sh query --type hypothesis --status open --scope <area>
scripts/chronicle.sh query --type customer --scope <area>          # any accounts at stake?

# Topic mode (example: /prep export)
scripts/chronicle.sh query --type stakeholder --scope export    # who cares?
scripts/chronicle.sh query --type customer --scope export       # which accounts?
scripts/chronicle.sh query --type decision --status validated --scope export
scripts/chronicle.sh query --type hypothesis --status open --scope export

# Account-name mode (example: /prep Acme)
scripts/chronicle.sh query --type customer --keyword Acme
# Then pull the stakeholders that customer entry references in its body.

# In all modes, surface recent ingestion notes:
ls -t chronicle/ingestion/ | head -10
# (then read a couple if their slugs match the scope/person/account)
```

The agent synthesises the loaded entries into the six-section brief and stops. It does not commit anything, propose anything, or open follow-up loops — the brief is the deliverable.

### Length discipline

The brief is **one page**. If it doesn't fit on a phone screen, trim. Specifically:

- ≤5 decisions in scope. If more, surface the most recent and note the count.
- ≤5 open hypotheses. If more, group by sub-scope.
- ≤5 suggested questions. If you can't pick the top 5, the meeting goal isn't tight enough.
- No quotes longer than one line. Reference the source entry instead.

A 3-page brief is a sign the user should narrow the meeting topic before walking in, not that the brief should grow.

### When to use vs when not to

**Use** when:
- A meeting is in the next 24 hours.
- The participants have non-trivial open asks, concerns, or stakes that are recorded in chronicle.
- The meeting outcome will likely produce decisions or hypothesis updates.

**Don't use** when:
- The meeting is a standup or other ritual where no one has open chronicle context.
- The chronicle is empty for the relevant scope — the brief would be honest but useless; better to do discovery first.
- The user already has a tight brief — don't generate parallel ones.

## Examples

### `/prep Maya` — before a QBR

```markdown
# Prep — QBR with Maya (VP Sales)

**Scope tags:** stakeholders, enterprise, export, billing, contracts
**Last contact:** 2026-05-15 (QBR sync)

## Open asks

- 2026-05-15 — Bulk export of customer activity logs in CSV (QBR doc)
- 2026-04-22 — Per-seat invoice line items for >100-seat accounts (finance 1:1)
- 2026-03-30 — Self-serve contract renewal portal (roadmap review)

## Decisions in scope

- `2026-05-15-refuse-smb-segment-for-fy26` — refused SMB to focus on mid-market; aligns with her enterprise focus.

## Open hypotheses in scope

_None currently open in `export` or `billing` scope. Worth opening one in this meeting if her export-latency concern strengthens._

## Likely point of disagreement

She will push for export latency work to land in Q3, and we have not yet opened a hypothesis or decision on whether to commit. The QBR is the natural place to either commit publicly or scope the hypothesis.

## Suggested questions

1. Which two renewals specifically cited export latency, and what was the threshold that lost the deal?
2. If we ship a 10x faster export path, how many enterprise renewals would she expect to save in the next 12 months?
3. Is per-seat invoicing a hard ask or a "nice to have" — i.e. would a smaller fix (CSV invoice export) satisfy finance?
4. Are there other enterprise renewals in Q3 that we should de-risk preemptively?

## References

- `chronicle/entries/2026-05-19-maya-vp-sales.md` — her stakeholder entry.
- `chronicle/ingestion/2026-05-15-maya-qbr-export.md` — synthesis of her last QBR.
```

### `/prep pricing` — before a design review

```markdown
# Prep — Pricing surface design review

**Scope tag:** pricing

## Stakeholders here

- **Maya (VP Sales)** — affected_areas include `billing,contracts`. Will care about per-seat-invoice line items showing up in any new invoice UI. Last contact 2026-05-15.
- **Devon (CFO)** — affected_areas include `pricing,billing`. Will care about margin transparency in the surface. Last contact 2026-04-30.

## Decisions in scope

- `2026-04-12-value-based-pricing-for-mid-market` — chose value-based over per-seat for the mid-market tier (validated, documented). The new surface should not contradict this.

## Open hypotheses in scope

- `2026-05-18-bundled-pricing-strengthens-conversion` — open; the surface change is the experiment that resolves it.

## Likely point of disagreement

Devon will want margin reveal that Maya considers internal-only. The surface needs an explicit decision about what's visible to which audience.

## Suggested questions

1. Does the surface differentiate the customer-facing view from the internal margin view?
2. If `2026-05-18-bundled-pricing-strengthens-conversion` strengthens after this ships, what's the next decision?
3. Does the surface expose enough to let Maya answer her enterprise customers' "what would a 200-seat contract cost?" question without escalating to engineering?

## References

- `chronicle/ingestion/2026-05-12-devon-margin-call.md` — Devon's last unrecorded ask.
```

## Common Pitfalls

1. **Padding the brief to look thorough.** Empty sections are signal — they tell the user where the chronicle is thin and where the meeting should do discovery. Don't fabricate.
2. **Including verbatim quotes from `chronicle/source/`.** The source files are gitignored for a reason; don't surface their contents in a brief that could end up in a Slack DM or doc.
3. **Predicting outcomes.** "Likely point of disagreement" is a read of the loaded entries, not a forecast. If the read is thin, say so ("no strong signal — go in with discovery posture").
4. **Building a brief for a meeting that doesn't need one.** Standups, all-hands, casual coffees — these don't have load-bearing chronicle context. Briefs for them are theatre.
5. **Mixing brief and notes.** This skill produces the *input* to a meeting. After the meeting, use `/ingest` on the resulting notes, then propose chronicle entry updates via `chronicle-record`. Don't blur the two.
6. **Stale stakeholder entries.** If the matched stakeholder's `Last contact` is >90 days old, the brief should flag this: their position may have drifted. Include a "Last contact age" note in the **Who/what** section when relevant.
7. **Forgetting the topic mode for design reviews.** Person mode is the obvious case, but design reviews and roadmap meetings are where topic mode shines — pulling every stakeholder in the scope, not just one.

## References

- [`chronicle/README.md`](../../chronicle/README.md) — the source layer this skill reads from.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — the entry types (`decision`, `hypothesis`, `stakeholder`) the brief composes from.
- [`skills/chronicle-recall`](../chronicle-recall/SKILL.md) — the read-side primitive; `/prep` is a curated multi-query wrapper around it.
- [`skills/ingest`](../ingest/SKILL.md) — paired skill; ingest captures meeting *output*, prep produces meeting *input*. The two skills bracket every meeting that's worth chronicling.
- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — the query subcommand is the entry point for the loads this skill performs.
- [PM Brain — `/prep <stakeholder>`](https://github.com/phuryn/pm-brain) — the design influence. PM Brain's variant pulls from a dedicated stakeholders folder; Hornero's variant queries the unified chronicle entries layer via the `type: stakeholder` filter.
