---
name: query-warehouse
description: Cross-system read primitive over the team's analytics warehouse — BigQuery or Snowflake. Three call shapes (schema discovery, dry-run cost estimate, exploratory SQL with a kill-cost guardrail) with stable result formats and a hard upper bound on bytes scanned per call.
intent: |
  Make warehouse queries skill-callable without each consumer learning
  BQ-flavoured SQL vs Snowflake-flavoured SQL, the dry-run mechanics, or
  the per-engine cost telemetry. The guardrail (max bytes per call,
  refuse without an estimate above the cap) is structural, not
  advisory — the primitive enforces it so a misbehaving caller cannot
  burn a quarter's compute budget in one session.
type: workflow
theme: measurement
resources:
  - bigquery
  - snowflake
best_for:
  - Schema discovery before writing analysis SQL ("what columns does fact_activations have?")
  - Cost-estimating a query before running it ("how many bytes will this scan?")
  - Exploratory SQL when a metric needs validation ("is this number what the dashboard says?")
  - Pre-experiment sample-size sanity checks (row counts on the cohort table)
scenarios:
  - "PM validating a metric definition before adding it to a PRD — needs the activation event count for the last 7 days. Runs schema discovery first, then a small aggregation. Both calls go through this skill; the kill-cost guardrail stops a typo'd cross-join before it scans 10TB."
  - "Data-eng review surfaces a join the PM didn't realise was incremental-stale. PM uses query-warehouse to dry-run the corrected query, confirms the byte cost, then runs it."
  - "Cohort sanity check: how many users hit the activation event in week N? The skill returns the row count from a small aggregation; the PM uses it to size the experiment for the next iteration."
estimated_time: 1-3 minutes per query
---

# Query warehouse

## Purpose

Other Hornero skills need to read from the team's analytics warehouse without each one re-deriving BigQuery vs Snowflake SQL dialects, per-engine cost-estimate mechanics, or the right tool calls on each MCP server. This skill is the single read primitive — it takes one of three call shapes (discover schema, estimate cost, run SQL) and maps it onto whichever warehouse is configured, returning a stable result.

**The guardrail is the whole point.** A warehouse can charge for a typo. BigQuery's SELECT * on a 50TB table is a $250 query; Snowflake on the wrong warehouse size is a $40/hour mistake. The skill refuses to run any SQL without a dry-run cost estimate first, and refuses to proceed if the estimate exceeds a per-call byte cap. The cap is structural; callers cannot override it inline.

If neither warehouse is configured, the skill surfaces the `bq` / `snowsql` fallback recipes in [`resources/bigquery/RESOURCE.md`](../../resources/bigquery/RESOURCE.md) and [`resources/snowflake/RESOURCE.md`](../../resources/snowflake/RESOURCE.md) and stops — graceful degradation, not failure.

## Key Concepts

### Three call shapes; nothing else

Most legitimate warehouse-read intents collapse into one of three shapes. Anything outside these is a sign the consumer should be writing analysis directly with the warehouse's own MCP tools, not via this primitive.

1. **Discover schema** — "what columns does table T have? what's the partition / cluster key? sample rows."
2. **Estimate cost** — "run a dry-run; tell me bytes scanned and the dollar estimate at the configured rate."
3. **Run SQL** — "run this query; return the result as a table." Always preceded by an estimate call. Refused if estimate exceeds the per-call byte cap.

There is no "join across tables", no "transform and pivot", no "create a temp table" — those are analyst workflows that belong in a notebook, not a chat skill.

### The kill-cost guardrail

Every `run` call MUST be preceded by an `estimate`. The skill enforces this internally — if the caller calls `run` directly, the skill runs `estimate` first and refuses if the estimate exceeds the per-call cap.

**Default cap: 100 GB scanned per call.** Override via `HORNERO_WAREHOUSE_MAX_GB` env var (project-local convention; not auto-imported). The cap exists to make accidents cheap, not to forbid legitimate large queries — a legitimate 5 TB query happens in a notebook with the appropriate human gate, not through an agent skill mid-session.

The cap is bytes-scanned, not bytes-returned. A query that scans 5 TB and returns 100 rows still counts as 5 TB for the cap — that's where the cost lives.

### Engine differences the skill hides

- **BigQuery** uses `dry_run` mode on the job config; cost is computed as `bytes_processed * $5 / TB` (on-demand pricing). Slot-reservation pricing is opaque from the API — the skill prints both numbers and notes "on-demand estimate; reservation pricing may differ".
- **Snowflake** doesn't expose dry-run cost as bytes; it returns the estimated compilation cost and warehouse credit consumption. The skill normalises: bytes estimate → "compilation analysis" (Snowflake reports `bytes_scanned` after the fact, not before). For the cap check on Snowflake, the skill uses `INFORMATION_SCHEMA.TABLE_STORAGE_METRICS` to compute the upper bound (table size × selectivity heuristic) — conservative, will sometimes refuse a query that would have been cheap. Better to refuse and ask the caller to confirm than to burn credits.

### Engine differences the skill does NOT hide

- **SQL dialect**: BigQuery is GoogleSQL (LATERAL FLATTEN, ARRAY syntax); Snowflake is mostly ANSI plus warehouse-scoping. The skill does not translate SQL between them. Callers write SQL for whichever engine is connected; the skill detects engine and routes accordingly.
- **Result types**: BigQuery TIMESTAMP differs from Snowflake TIMESTAMP_NTZ subtly. The skill returns raw values from the engine; callers handle type quirks downstream.

This is by design — generalising SQL produces a leaky abstraction that breaks under pressure. Engine routing is enough abstraction; dialect translation is too much.

### Result shape

| Call shape | Returns |
|---|---|
| `discover` | YAML block: table name, column list with types, partition/cluster info, sample 5 rows |
| `estimate` | YAML block: bytes_scanned (estimated), dollar_estimate (engine-specific), kill_cap_exceeded (true/false) |
| `run` | Markdown table; max 200 rows by default, max 1000 with explicit `--rows` flag |

All three include the engine in the response header so the caller knows which dialect they were operating in.

## Application

### Shape 1 — Discover schema

Input: fully-qualified table name (`project.dataset.table` for BigQuery; `database.schema.table` for Snowflake).

```
Call: query-warehouse --shape discover --table "analytics.events.fact_activations"

Result:
# engine: bigquery
# table: analytics.events.fact_activations
columns:
  - {name: user_id, type: STRING, mode: REQUIRED}
  - {name: account_id, type: STRING, mode: NULLABLE}
  - {name: activation_at, type: TIMESTAMP, mode: REQUIRED}
  - {name: source, type: STRING, mode: NULLABLE}
  - {name: properties, type: JSON, mode: NULLABLE}
partitioning:
  field: activation_at
  type: DAY
clustering: [account_id, source]
row_count_estimate: 18_400_213
sample_rows:
  - {user_id: u_8f3a..., account_id: acc_1042, activation_at: "2026-05-18T14:02:00Z", source: invite}
  - ...
```

### Shape 2 — Estimate cost

Input: SQL string.

```
Call: query-warehouse --shape estimate --sql "SELECT account_id, COUNT(*) AS activations FROM analytics.events.fact_activations WHERE activation_at >= '2026-05-01' GROUP BY account_id ORDER BY activations DESC LIMIT 50"

Result:
# engine: bigquery
bytes_scanned_estimate: 1_240_512_000
dollar_estimate_on_demand: 0.006
kill_cap_exceeded: false
notes: |
  Partition pruning is active; activation_at filter cuts scan to last 20 days.
  Adding a LIMIT does not reduce scan cost.
```

If `kill_cap_exceeded` is true, the skill recommends one of: tighten the date filter, add a partition predicate, or run from a notebook with explicit confirmation.

### Shape 3 — Run SQL

Input: SQL string. Estimate runs internally first; refused if cap exceeded.

```
Call: query-warehouse --shape run --sql "SELECT account_id, COUNT(*) AS activations FROM analytics.events.fact_activations WHERE activation_at >= '2026-05-01' GROUP BY account_id ORDER BY activations DESC LIMIT 50"

Result:
# engine: bigquery; bytes_scanned: 1_181_447_200 ($0.006)
| account_id | activations |
|------------|-------------|
| acc_1042   | 312         |
| acc_0917   | 287         |
| ...        | ...         |
(50 rows)
```

If the estimate exceeds the cap:

```
✗ Estimated 142 GB scan ($0.71) exceeds the 100 GB per-call cap.
  Either tighten the filter, or run from a notebook with explicit
  confirmation. See resources/bigquery/RESOURCE.md → Fallback for the
  `bq query --dry_run` command shape.
```

### Auth and fallback

If the MCP server is not connected, the skill stops and prints the `bq` (BigQuery) or `snowsql` (Snowflake) recipe from the resource card. The fallback path is a documented shell command the user runs themselves, not a synthetic primitive — running `bq` or `snowsql` from inside an agent skill makes cost-attribution unclear and complicates auth.

## Examples

### Validating a metric definition before adding it to a PRD

```
User: I want to add "weekly activations" to the success-metrics section of
      the PRD. The dashboard says 4,200 for last week — can we confirm
      against the warehouse?

Agent: Running a small aggregation. First, discovering the schema for the
       activations table (cached if seen recently).

       [discover analytics.events.fact_activations — partition on activation_at, daily]

       [estimate SELECT COUNT(*) ... WHERE activation_at BETWEEN ...
        — bytes_scanned: 410 MB, $0.002, well under cap]

       [run — result: 4,218 activations between 2026-05-13 and 2026-05-19]

       Confirmed: 4,218 vs dashboard 4,200 — within the rounding the
       dashboard does. PRD section can cite either; flag the rounding
       convention in the metric definition so the team isn't surprised
       later.
```

### Refused: typo'd query that would scan 10TB

```
User: select * from analytics.events.raw_events e join
      analytics.users.dim_users u on e.user_id = u.id where u.account = 'acme'

Agent: ✗ Estimated 10,247 GB scan ($51.24) exceeds the 100 GB per-call cap.

       The unfiltered raw_events scan is the culprit — the table is
       partitioned by event_at, but no date predicate is in the query.
       Either:
       1. Add a date range filter on event_at (will use partition pruning).
       2. Run from a notebook with explicit confirmation if the full scan
          is genuinely needed for this analysis.

       See resources/bigquery/RESOURCE.md → Common Gotchas for the
       partition-pruning pattern.
```

## Common Pitfalls

1. **Skipping the estimate before run.** Don't. The skill instructs the model to enforce this internally — but a SKILL.md is instructions to an agent, not executable code. Honest read: the kill-cap is the only thing standing between a typo and the monthly compute budget, and the enforcement is the agent reading and obeying the skill. If the team needs hard structural enforcement (CI gates, billing alerts, IAM-level scan caps), wire those at the warehouse layer; this skill is the friction-reducing wrapper, not the safety net of last resort.
2. **Translating SQL between dialects.** GoogleSQL vs Snowflake SQL is more than syntactic — semantic differences in date arithmetic, NULL handling, and JSON access make naive translation actively dangerous. The skill detects engine and routes; it does not translate.
3. **Caching schema across sessions.** Schemas change. A `discover` call at the start of a session can be referenced for the rest of that session, but don't carry the schema across sessions — re-discover when it matters.
4. **Running large analysis from a chat skill.** This primitive is for sub-100GB exploratory work. Anything larger belongs in a notebook with human-confirmed cost. The cap is doing its job when it refuses.
5. **Reporting bytes_returned instead of bytes_scanned.** Cost lives in the scan. A query that returns 100 rows after scanning 5 TB cost 5 TB. The skill always reports scanned.
6. **Trying to use this for writes.** No INSERT, UPDATE, DELETE, CREATE, DROP, MERGE. The skill rejects any DML/DDL statement. Writes belong to dedicated workflows with their own discipline.
7. **Falling back to `bq` / `snowsql` silently.** If neither MCP is available, surface the recipe from the resource card and stop. The user runs the CLI themselves.

## References

- [`resources/bigquery/RESOURCE.md`](../../resources/bigquery/RESOURCE.md) — BigQuery MCP capabilities, dry-run mechanics, partition / clustering guidance, `bq` fallback.
- [`resources/snowflake/RESOURCE.md`](../../resources/snowflake/RESOURCE.md) — Snowflake MCP capabilities, warehouse-cost gotchas, `snowsql` fallback.
- [`skills/query-issue-tracker/SKILL.md`](../query-issue-tracker/SKILL.md) — sibling cross-system primitive over Linear / Jira.
- [`roles/product-manager/skills/prd/SKILL.md`](../../roles/product-manager/skills/prd/SKILL.md) — PRDs that reference live metric counts pull through this skill.
- [`roles/product-manager/skills/success-metrics/SKILL.md`](../../roles/product-manager/skills/success-metrics/SKILL.md) — metric definitions that need warehouse-backed validation.
