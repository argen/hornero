# chronicle/source/

Raw artifacts that fed an ingestion. Interview transcripts, meeting notes, doc exports, screenshots, dashboard pulls — the unedited input.

The contents of this directory are **gitignored** because raw artifacts often carry PII or other sensitive details. The synthesised observations live next door in `chronicle/ingestion/` and **are** committed; that is where the team's working knowledge lands.

Files are written here by `scripts/chronicle.sh ingest --path <file>` with UUID-based names so the synthesis can reference the source path without leaking the original filename.

If you need a teammate to see a raw artifact, share it directly — not through git.
