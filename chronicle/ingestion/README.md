# chronicle/ingestion/

Synthesised observations from artifacts the team has ingested — one Markdown file per artifact, written by `scripts/chronicle.sh ingest` and filled in via the `/ingest` skill.

Each ingestion file has frontmatter (id, date, source_path, source_kind, source_role, sourcing) and four sections:

- **Summary** — 1-3 sentences distilling the artifact.
- **Observations** — bulleted, each tagged inline with a sourcing label (`[documented]`, `[verbal]`, `[intuition]`, `[industry]`).
- **Implications** — which chronicle entries (decisions, hypotheses, stakeholders) this updates, with `chronicle.sh propose` commands when appropriate.
- **Notes** — anything that doesn't fit above.

Distinct from `chronicle/entries/` — that's the strict-schema record of decisions, hypotheses, and stakeholders. Ingestion files are looser by design; they're the raw working layer that decisions get derived from.

The raw artifact each file synthesises lives at the `source_path` (under `chronicle/source/`, gitignored). The synthesis stays here and travels with the project.
