---
name: bigquery
description: Google's serverless analytics warehouse — datasets, tables, views, SQL queries. Used by PMs for activation, retention, cohort analysis.
type: data-source
status: stretch
mcp:
  server: "mcp-server-bigquery"
  install: "uvx mcp-server-bigquery"
  auth_env: [GOOGLE_APPLICATION_CREDENTIALS, BIGQUERY_PROJECT_ID]
  capabilities: [query, list_datasets, list_tables, get_table_schema, dry_run]
object_model: [Project, Dataset, Table, View, MaterializedView, Routine, Schema, Job, QueryResult]
used_by: []
fallback: bq-cli
---

## Purpose

BigQuery is Google Cloud's serverless analytics warehouse. Product and data roles use it for activation funnels, retention cohorts, feature-usage breakdowns, and experiment readouts. No server to manage — you pay per byte scanned, not per slot-hour (unless you're on reservations). Hornero has no PM skill wired to BigQuery yet; this resource is scaffolded for future success-metrics and cohort-analysis skills. Until those skills land, treat this as a reference for MCP setup and the `bq` CLI fallback.

## MCP Server

**Canonical server (Google):** Google's MCP Toolbox for Databases (`genai-toolbox`) covers BigQuery among other Cloud databases. Repo: <https://github.com/googleapis/genai-toolbox>. The install path varies by platform — see the repo's README for the current binary or container approach.

**Community server (recommended for quick setup):** `mcp-server-bigquery` by LucasHild — Python, read-only, straightforward auth.

```sh
# Install and register (uv required)
uvx mcp-server-bigquery

# Or register it in claude directly:
claude mcp add bigquery -- uvx mcp-server-bigquery
```

**Auth:** BigQuery uses Google Cloud ADC (Application Default Credentials). Two paths:

- **Service account (production / CI):** set `GOOGLE_APPLICATION_CREDENTIALS=/path/to/sa-key.json`. The SA needs `bigquery.dataViewer` **and** `bigquery.jobUser` on the project — read-data and run-jobs are separate IAM roles; neither alone is sufficient.
- **User credentials (dev):** run `gcloud auth application-default login` once. No env var needed.

Set `BIGQUERY_PROJECT_ID` to avoid passing `--project` on every call. The MCP server picks it up as the default billing project.

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `list_datasets` | Enumerate datasets in a project | (future: cohort-analysis) |
| `list_tables` | Tables within a dataset | (future: cohort-analysis) |
| `get_table_schema` | Column names, types, partitioning | (future: cohort-analysis) |
| `query` | Execute Standard SQL, return rows | (future: cohort-analysis) |
| `dry_run` | Estimate bytes scanned before running | (future: cohort-analysis) |

**Always `dry_run` before executing an unfamiliar query on a large dataset.** A single `SELECT *` on a multi-TB table can cost dollars.

## Object Model

- **Project** — Google Cloud project. Billing boundary. Contains all datasets. Identified by `project_id` string (e.g. `my-company-prod`).
- **Dataset** — region-scoped namespace (e.g. `US`, `EU`, `us-central1`). ACLs live here — access granted at dataset level, not table level (unless using column-level security). Has a default table expiration.
- **Table** — rows + typed columns. Supports three partitioning strategies: date/timestamp column, integer-range column, and ingestion-time (pseudo-columns `_PARTITIONTIME` / `_PARTITIONDATE`). Clustering (physical sort on up to 4 columns) is orthogonal to partitioning and cuts scan costs further.
- **View** — logical view defined by a SQL query. No storage cost; computed at query time. Can reference tables across datasets in the same region.
- **MaterializedView** — precomputed view cached on disk. Auto-refreshes on a schedule or on base-table change. Billing for storage + refresh jobs, but query cost drops to the cached bytes only.
- **Routine** — stored procedure or user-defined function (UDF). SQL or JavaScript. UDFs can be called inside queries; stored procedures are called via `CALL`.
- **Schema** — column list with types. BigQuery has first-class `STRUCT` (record) and `ARRAY` (repeated) types. Nested + repeated fields are common in event tables and require `UNNEST` to flatten.
- **Job** — every query, load, extract, or copy is a Job with a unique ID, status (RUNNING / DONE / ERROR), statistics (bytes processed, slot-ms, cache hit), and billing info. Asynchronous; poll with job ID if you need the result.
- **QueryResult** — rows returned by a Job. The billing metric is `totalBytesProcessed`, not row count. Results > 10 MB are routed to an anonymous temporary result table; the inline response is a pointer, not the data.

**Relationships that matter:**
- Project → 1..N Datasets (region-scoped)
- Dataset → 0..N Tables, Views, MaterializedViews, Routines
- Table → 1 Schema (possibly nested), 0..1 Partitioning config, 0..1 Clustering config
- Query → 1 Job → 1 QueryResult

## Common Gotchas

- **Cost is bytes scanned, not rows returned.** `SELECT *` on a 1 TB table costs ~$5. Column pruning (`SELECT col1, col2` instead of `*`) is the primary lever. Partition filters and clustering both reduce scan. Always `dry_run` on an unfamiliar table before running live.
- **Partitioned tables without a partition filter scan everything.** If a table is partitioned on `event_date`, a query without `WHERE event_date BETWEEN …` reads all partitions. Ingestion-time partitioned tables use `_PARTITIONTIME` or `_PARTITIONDATE` pseudo-columns — easy to forget they exist.
- **1,500-partition limit per DML operation.** A single `UPDATE`/`INSERT`/`DELETE` can touch at most 1,500 partitions. Bulk backfills must be batched.
- **Streaming inserts are eventually-consistent.** Rows inserted via the streaming API (not load jobs) may not be visible in queries for up to 90 minutes in rare cases. Don't assert row counts immediately after a streaming write.
- **Standard SQL only — never Legacy SQL.** Always pass `--use_legacy_sql=false` with `bq query`. Some older tooling and dashboards silently default to Legacy SQL; queries that work there may not parse in Standard SQL (and vice versa).
- **Cross-region joins are forbidden.** A query can only reference tables in the same location. `US` and `EU` are separate — you cannot join them without copying data. Multi-region (`US`) and single-region (`us-central1`) are also distinct locations.
- **Slot-based vs. on-demand pricing changes everything.** On-demand: you pay per byte scanned. Reservations (slots): fixed monthly cost, bytes-scanned irrelevant. Cost analysis of a query is meaningless without knowing which pricing model is active.
- **IAM is split.** `bigquery.dataViewer` lets you read rows; `bigquery.jobUser` lets you run jobs. You need both. A service account missing either will fail with a permission error, but the error message doesn't always say which role is missing.
- **Results > 10 MB aren't returned inline.** The API routes them to an anonymous result table. The MCP server and `bq query` handle this transparently, but raw REST callers need to paginate via `pageToken`.
- **`UNNEST` is required for nested/repeated fields.** A column of type `ARRAY<STRUCT<…>>` looks like a single column but must be unnested to query individual elements. Forgetting `UNNEST` is the most common first-query failure on event-schema tables.

## Fallback Without MCP

Use the `bq` CLI (part of the Google Cloud SDK). Authenticate first:

```sh
# User credentials (dev)
gcloud auth application-default login

# Or point at a service account key
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/sa-key.json
```

**Run a query:**

```sh
bq query --use_legacy_sql=false \
  --project_id="${BIGQUERY_PROJECT_ID}" \
  'SELECT event_name, COUNT(*) AS n
   FROM `my-project.analytics.events`
   WHERE DATE(event_timestamp) = CURRENT_DATE()
   GROUP BY 1
   ORDER BY n DESC
   LIMIT 20'
```

**List tables in a dataset:**

```sh
bq ls --project_id="${BIGQUERY_PROJECT_ID}" analytics
```

**Inspect a table's schema:**

```sh
bq show --schema --format=prettyjson \
  "${BIGQUERY_PROJECT_ID}:analytics.events"
```

**Dry-run (cost estimate before execution):**

```sh
bq query --use_legacy_sql=false --dry_run \
  'SELECT * FROM `my-project.analytics.events` LIMIT 1000'
# Prints: Query successfully validated. Assuming the tables are not modified,
# running this query will process X bytes.
```

For scripted access, the BigQuery REST API (`https://bigquery.googleapis.com/bigquery/v2/`) accepts OAuth2 bearer tokens from `gcloud auth print-access-token`. The `bq` CLI is the practical fallback for Hornero skills; raw REST is a last resort.

## References

- BigQuery documentation — <https://cloud.google.com/bigquery/docs>
- Standard SQL query syntax — <https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax>
- `bq` CLI reference — <https://cloud.google.com/bigquery/docs/bq-command-line-tool>
- MCP Toolbox for Databases (Google) — <https://github.com/googleapis/genai-toolbox>
- Community MCP server (`mcp-server-bigquery`) — <https://github.com/LucasHild/mcp-server-bigquery>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. BigQuery is scaffolded for future PM skills around success-metrics validation and cohort analysis.
