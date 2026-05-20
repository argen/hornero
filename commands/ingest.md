---
description: Ingest an artifact (transcript, meeting notes, doc, screenshot, paste) into the chronicle layer — preserves the raw input, drafts a synthesis, proposes chronicle entries the artifact implies. Usage- /ingest <path-or-description>.
argument-hint: <file-path-or-description-of-what-to-ingest>
---

# /ingest

The user has an artifact worth preserving in the chronicle layer — a customer interview transcript, meeting notes, a doc export, a dashboard snapshot, a pasted Slack thread, a support ticket. They want it routed through the ingest workflow so the raw input is preserved, a structured synthesis lands under `chronicle/ingestion/`, and any chronicle entries the artifact updates get proposed.

## What to do

1. **Load and follow [`skills/ingest/SKILL.md`](../../skills/ingest/SKILL.md)** — it is the canonical procedure. Do not improvise.

2. **Resolve the artifact** from `$ARGUMENTS`:
   - If the argument is a file path, use it directly.
   - If the argument is a paste, write it to a temp file first (e.g. via the Write tool to `/tmp/ingest-<short-slug>.txt`), then use the temp path.
   - If the argument is a URL or external reference, ask the user to provide the artifact contents (Hornero stays usable without external network access).

3. **Classify the source kind** — `interview`, `meeting`, `doc`, `screenshot`, `dashboard`, `chat`, or `other`. If unclear, ask once; don't guess silently.

4. **Pick an initial sourcing** for the frontmatter — best guess; the agent refines it after filling in observations. The final value is the **weakest** sourcing tag that ends up appearing in `## Observations`.

5. **Run the ingest CLI**:
   ```bash
   scripts/chronicle.sh ingest \
     --path <file> \
     --source-role <role> \
     --sourcing <documented|verbal|intuition|industry> \
     --kind <kind> \
     [--title "..."]
   ```
   The script preserves the raw under `chronicle/source/<uuid>.<ext>` (gitignored) and creates a synthesis stub under `chronicle/ingestion/<date>-<slug>.md`. The script does no LLM work.

6. **Fill in the synthesis stub** — Summary (1-3 sentences), Observations (bullets, each tagged inline with `[documented]` / `[verbal]` / `[intuition]` / `[industry]`), Implications (which chronicle entries this updates, with proposed `chronicle.sh propose` commands), Notes (optional).

7. **Propose chronicle entries** the synthesis implies. **Do not commit** — the human gate on `chronicle/entries/` is structural. Stop after `chronicle.sh propose` and announce the proposal IDs.

8. **Declare the route in one line** before starting (per `VOICE.md`):
   ```
   /ingest — preserving <kind> artifact, synthesis stub at <path>; will propose <N> chronicle entries.
   ```

## Task

$ARGUMENTS
