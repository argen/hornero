---
name: ingest
description: Use to feed an artifact (interview transcript, meeting notes, doc export, dashboard screenshot, support ticket, paste) into the project's `chronicle/` layer — preserves the raw input, drafts a structured synthesis, and proposes updates to the chronicle entries the artifact informs.
intent: |
  The front door to the Chronicle layer for unstructured input. Without
  this skill, raw artifacts either get pasted into chats (no audit trail)
  or manually re-keyed into chronicle entries (lossy and slow). With it,
  every artifact has a durable source copy, a synthesised observation
  set, and a clear path to which decisions, hypotheses, or stakeholders
  it should update.
type: workflow
theme: memory
best_for:
  - Right after a customer / user / stakeholder interview
  - After a team meeting where decisions or asks surfaced
  - When a teammate pastes "look at this" — a Notion doc, a Slack thread, a Jira ticket
  - After a dashboard or metric snapshot worth preserving with date stamps
  - When a support ticket or incident report changes the team's read of a hypothesis
scenarios:
  - "PM finishes a 60-minute customer interview. `/ingest <transcript-path>` copies the raw transcript to `chronicle/source/<uuid>.txt` (gitignored), creates a synthesis stub under `chronicle/ingestion/<date>-<slug>.md`, the agent fills in Summary + Observations (each tagged inline with sourcing), and the Implications section proposes a `chronicle.sh propose` for an open hypothesis the interview informs."
  - "Engineer pastes a postmortem doc. `/ingest <paste>` saves the paste to `chronicle/source/`, the agent synthesises the failure mode + scope, and the Implications section proposes updating a refuted decision entry with the post-incident evidence."
  - "Designer pastes a usability-test recording transcript. `/ingest` preserves the source, synthesises observations against the open hypothesis the test was designed to refute, and either appends evidence-log rows to the hypothesis or proposes a new decision superseding it."
estimated_time: 5-15 minutes
---

# Ingest

## Purpose

Convert an unstructured artifact into a durable, queryable contribution to the Chronicle layer. The skill enforces two splits that matter:

1. **Source vs synthesis.** The raw input lives at `chronicle/source/<uuid>.<ext>` (gitignored, often carries PII). The synthesis lives at `chronicle/ingestion/<date>-<slug>.md` (committed, derived from the raw input with sourcing tags inline).
2. **Working layer vs durable layer.** The ingestion file is the **working layer** — looser, free-form prose, observation-shaped. The chronicle entries (`chronicle/entries/`) are the **durable layer** — strict-schema records of decisions, hypotheses, and stakeholders. Ingestion proposes updates to entries; the proposals go through the standard human-gated commit path.

Without this split, the same Slack-thread anti-pattern that motivated Chronicle returns: artifacts get pasted into chats, decisions reference them by memory, and the audit trail evaporates.

## Key Concepts

### The two-step write

`/ingest` runs `scripts/chronicle.sh ingest --path <file> --source-role <role> --sourcing <enum> [--kind <kind>]`. The script:

1. Copies `<file>` to `chronicle/source/<uuid>.<ext>`. The UUID name decouples the synthesis from the original filename — useful when the original carries names, account IDs, or other identifiers you don't want to leak via filenames.
2. Creates `chronicle/ingestion/<date>-<slug>.md` with frontmatter and four body sections. **The script does no LLM work**; same discipline as `chronicle.sh propose`. The agent fills in the body.

The agent then:

3. Reads the source file and fills in `## Summary`, `## Observations`, `## Implications`, and (optionally) `## Notes`.
4. For each entry under `## Implications`, proposes a `chronicle.sh propose` command. The human commits.

### Sourcing tags inline

Every claim in `## Observations` carries an inline sourcing tag in square brackets: `[documented]`, `[verbal]`, `[intuition]`, or `[industry]`. Example:

> - Two recent renewals cited export latency as the deciding factor [documented — Maya's QBR notes, 2026-05-15].
> - Admins under 50 seats find the per-person invite flow "tedious" [verbal — 4 of 6 discovery sessions in May].
> - Dropping out at the invite step probably correlates with team size [intuition — pattern from the last two interview cohorts but not formally tested].

The frontmatter's `sourcing:` field is the **weakest** label that appears in `## Observations`. If any claim is `[intuition]`, the frontmatter is `intuition`. This makes "what's this resting on?" answerable at a glance, and matches the discipline of the `sourcing` field on chronicle entries.

### What goes in source vs ingestion

- **`chronicle/source/`** — the raw thing. Interview audio transcripts, screenshots, exported Notion pages, copy-pasted Slack threads, dashboard CSVs. Gitignored because these often carry PII or proprietary signal.
- **`chronicle/ingestion/`** — the team's read of the raw thing. Distilled, tagged, linked to chronicle entries. Committed because this is the working knowledge that future sessions and roles need.

If a teammate asks "where did we hear that?" the answer points to the ingestion file (committed) which points to the source path (local-only). Don't paste source content into ingestion files — that defeats the gitignore.

### Distinct from /extract-lesson and chronicle-record

- **`/extract-lesson`** scans a *conversation* for harness improvements. It writes to roles, skills, CLAUDE.md, memory — not to the chronicle layer. Use it for "what did this session teach us about Hornero?"
- **`chronicle-record`** captures a *decision* into `chronicle/entries/`. Use it when a decision has been reached.
- **`/ingest`** captures an *artifact* into `chronicle/ingestion/`. Use it when a transcript, doc, screenshot, or paste arrives that the team should remember.

Often the sequence is: `/ingest <artifact>` → fill synthesis → `chronicle-record` on the decisions/hypotheses the synthesis implies. The three skills are a pipeline.

## Application

### How to invoke

```bash
scripts/chronicle.sh ingest \
  --path ./tmp/maya-interview-2026-05-19.txt \
  --source-role product-manager \
  --sourcing documented \
  --kind interview \
  --title "Maya QBR — export and per-seat invoicing asks"
```

Flags:

- `--path` (required) — the file to ingest. Must exist on disk. For pastes, save to a temp file first (e.g. `pbpaste > /tmp/notes.txt`) and pass the temp path.
- `--source-role` (required) — which role is doing the ingestion (`product-manager`, `cross-role`, etc.).
- `--sourcing` (required) — best initial guess; refine after filling in observations.
- `--kind` (optional) — one of `interview`, `meeting`, `doc`, `screenshot`, `dashboard`, `chat`, `other`. Defaults to `other`.
- `--title` (optional) — defaults to the filename sans extension. Override when the filename is cryptic.

The script prints two paths and stops:

```
↪ ingested: ./tmp/maya-interview-2026-05-19.txt
  source preserved: chronicle/source/<uuid>.txt (gitignored)
  synthesis stub:   chronicle/ingestion/2026-05-20-maya-qbr-export-and-per-seat-invoicing-asks.md
  next: open the stub, fill in the body, then propose any chronicle entries it implies.
```

Open the stub and fill in:

1. **`## Summary`** — 1-3 sentences. What is this artifact and what does it cover?
2. **`## Observations`** — bullets, each tagged inline. Quote where helpful. Aim for 5-15 observations on a 60-min interview; fewer on smaller artifacts. Don't summarise — name specific things that were said, shown, or measured.
3. **`## Implications`** — which chronicle entries (decisions / hypotheses / stakeholders) does this update? For each, draft the `chronicle.sh propose` command. The proposals go through the standard human-gated commit path.
4. **`## Notes`** — optional. Anything that doesn't fit above.

### When to ingest vs when not to

**Ingest** when:
- The artifact carries observations the team will reference in future decisions.
- A hypothesis was tested and the artifact contains the result.
- A stakeholder's asks or concerns shifted in a way the team should remember.
- A meeting produced commitments worth tracking.

**Don't ingest**:
- Routine status updates (Slack standups, status emails).
- Artifacts that are already committed elsewhere (an RFC in the repo, a PRD already in `docs/`).
- Things the team will look at once and forget — chronicle drift is a real cost.
- Anything that should stay private to one person (personal notes, draft thoughts).

### Privacy hygiene

- Don't quote names or identifiers verbatim in observations if a generic role label suffices. ("Customer in the e-commerce segment" beats "Acme Corp's CTO".)
- Don't paste source content into the ingestion file — link via `source_path` and let the reader open the source locally.
- If a source is *especially* sensitive, write the synthesis without ingesting the source at all, and note its absence in `## Notes`.

### Sequence after ingestion

After the synthesis is filled in, the typical follow-up:

```bash
# For each entry under ## Implications:
scripts/chronicle.sh propose --type hypothesis ... # or --type decision / --type stakeholder

# Human reviews the proposal under chronicle/proposals/, then:
scripts/chronicle.sh commit <proposal-uuid>
```

The ingestion file references the chronicle entry IDs that resulted from it (in `## Implications` or `## Notes`); the chronicle entries' `evidence:` field can reference back — though that's optional and depends on whether the synthesis crystallises into a decision worth citing.

## Examples

### A customer interview

A PM has just finished a 60-minute call with Maya (VP Sales). Their notes are in `/tmp/maya-qbr-2026-05-19.txt`.

```bash
scripts/chronicle.sh ingest \
  --path /tmp/maya-qbr-2026-05-19.txt \
  --source-role product-manager \
  --sourcing documented \
  --kind interview \
  --title "Maya QBR — export and per-seat invoicing"
```

The agent opens the stub and writes:

```markdown
## Summary

Maya raised three asks (bulk export, per-seat invoicing, self-serve contract
renewal) and one concern (export latency on >100-seat accounts cited as the
deciding factor in two recent lost renewals).

## Observations

- Bulk export of customer activity logs in CSV is on her ask list for Q3
  [documented — QBR doc, section 3].
- Two enterprise renewals (Acme, Global Corp) cited export latency as the
  deciding factor [documented — pipeline notes, attached to source].
- Per-seat invoicing for >100-seat accounts came up unprompted; she said
  "Finance is asking us about this every month" [verbal — direct quote].
- The pattern from the last three QBRs is that export latency is the single
  most common deal-breaker for renewal [intuition — author's read of the
  QBR cadence; not formally tabulated].

## Implications

- The Maya stakeholder entry (`2026-05-19-maya-vp-sales`) gains a new open
  ask (bulk export) and the export-latency concern strengthens. Propose:
  `scripts/chronicle.sh propose --type stakeholder --supersedes 2026-05-19-maya-vp-sales ...`
- A new hypothesis is worth opening: "Export latency on >100-seat accounts
  is the dominant churn driver for enterprise renewals." Propose:
  `scripts/chronicle.sh propose --type hypothesis --title "Export latency drives enterprise renewal churn" --sourcing documented ...`
```

### A pasted Slack thread

A teammate pastes a Slack thread into the chat. The agent saves it first, then ingests:

```bash
# Save the paste to a temp file (agent does this via Write tool)
# /tmp/slack-paste-2026-05-20.txt

scripts/chronicle.sh ingest \
  --path /tmp/slack-paste-2026-05-20.txt \
  --source-role cross-role \
  --sourcing verbal \
  --kind chat \
  --title "Slack thread — billing migration concerns"
```

The agent fills in the synthesis with `[verbal]` tags on the observations, then proposes whatever chronicle entries it implies.

## Common Pitfalls

1. **Pasting source content into the ingestion file.** Defeats the gitignore on `chronicle/source/`. The ingestion file should reference `source_path` and describe — not embed — the source.
2. **Ingesting things that are already chronicled elsewhere.** A PRD already in `docs/` doesn't need to be ingested. Chronicle drift is real; only ingest things that would otherwise be lost.
3. **Anchoring the `sourcing` frontmatter at `documented` by default.** Same failure mode as on chronicle entries — the field is informative only if it varies. Set it to the *weakest* sourcing tag that appears in `## Observations`.
4. **Forgetting the inline sourcing tags in `## Observations`.** Without them, future readers can't tell which bullets are quotes and which are inferences. The tags are how the entry's overall sourcing is derived and defensible.
5. **Skipping `## Implications`.** An ingestion without implications is a record that adds no leverage — no chronicle entry updates, no clarified hypotheses, no superseded postures. If after filling in observations there are no implications, either the artifact wasn't worth ingesting or the team isn't ready to act on it; flag in `## Notes` and move on.
6. **Auto-committing chronicle proposals from ingest.** The human-gated commit path on `chronicle/entries/` is structural. Ingest proposes; human commits. Same discipline as `chronicle-record`.
7. **Sensitive content in source/ on a shared machine.** Gitignore protects against git leakage, not local filesystem snooping. If the artifact is highly sensitive, write the synthesis without persisting the source.

## References

- [`chronicle/README.md`](../../chronicle/README.md) — layer overview, lifecycle, determinism guarantees.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — the entries-layer frontmatter contract that ingest's `## Implications` section drives toward.
- [`chronicle/ingestion/README.md`](../../chronicle/ingestion/README.md) — the working-layer overview.
- [`chronicle/source/README.md`](../../chronicle/source/README.md) — the raw-artifact layer (gitignored) and why.
- [`skills/chronicle-record`](../chronicle-record/SKILL.md) — the strict-schema entries skill that ingest's implications flow into.
- [`skills/chronicle-recall`](../chronicle-recall/SKILL.md) — query side; can filter by `--type` to see which decisions, hypotheses, or stakeholders an ingestion should update.
- [`skills/extract-lesson`](../extract-lesson/SKILL.md) — distinct: scans the *conversation* for harness updates, not artifacts for chronicle updates.
- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — the `ingest` subcommand is the script-side surface of this skill.
- [PM Brain — `/ingest`](https://github.com/phuryn/pm-brain) — the design influence. PM Brain's variant routes through a richer synthesis pass; Hornero's variant defers the synthesis to the agent and keeps the script LLM-free.
