---
name: snowflake
description: Snowflake's cloud data warehouse — databases, schemas, tables, warehouses. Used by PMs for activation, retention, cohort analysis when the team is on Snowflake instead of BigQuery.
type: data-source
status: stretch
mcp:
  server: "mcp-snowflake-server"
  install: "uvx mcp-snowflake-server --account <orgname>-<accountname> --user <user> --password <password> --warehouse <warehouse>"
  auth_env: [SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER, SNOWFLAKE_PASSWORD, SNOWFLAKE_WAREHOUSE]
  capabilities: [query, list_databases, list_schemas, list_tables, describe_table]
object_model: [Account, Warehouse, Database, Schema, Table, View, MaterializedView, Stage, Role, Query]
used_by: []
fallback: snowsql
---

## Purpose

Snowflake is a cloud-native data warehouse used by analytics-heavy teams as the alternative to BigQuery. PMs reach for it for activation funnels, retention cohorts, and ad-hoc metric validation; data engineers own schema; analysts own dbt models on top. Hornero skills can query Snowflake directly when the MCP server is connected; without it, they fall back to `snowsql` or the SQL API.

Snowflake differs from BigQuery in one critical way: **compute and storage are fully decoupled and billed separately.** A warehouse must be running to execute any query. Sizing it wrong or leaving it running burns credits fast.

## MCP Server

**Community server:** `mcp-snowflake-server` (Python, installable via `uvx` or `pip`). No official Snowflake-published MCP server exists as of mid-2025; Snowflake Cortex Analyst is the official path being built — treat it as the future canonical once generally available.

**Install (uvx, recommended):**

```sh
uvx mcp-snowflake-server \
  --account <orgname>-<accountname> \
  --user <user> \
  --password <password> \
  --warehouse <warehouse>
```

**Install (pip):**

```sh
pip install mcp-snowflake-server
python -m mcp_snowflake_server \
  --account <orgname>-<accountname> \
  --user <user> \
  --warehouse <warehouse>
```

**Register with Claude Code:**

```sh
claude mcp add snowflake -- uvx mcp-snowflake-server \
  --account "${SNOWFLAKE_ACCOUNT}" \
  --user "${SNOWFLAKE_USER}" \
  --password "${SNOWFLAKE_PASSWORD}" \
  --warehouse "${SNOWFLAKE_WAREHOUSE}"
```

**Auth:** account identifier in `<orgname>-<accountname>` format (not the legacy `<account>.<region>` form), user, and one of:

- **Password** — simplest; avoid for service accounts if MFA is enforced workspace-wide. Programmatic users need MFA exemption when MFA is on.
- **Key-pair (preferred for service accounts)** — generate RSA private key, register the public key against the user, pass the private key path. Not all community MCP servers support key-pair out of the box; check before choosing.

Set `SNOWFLAKE_WAREHOUSE` to the warehouse the MCP server will use for all queries. The server can override per-query with `USE WAREHOUSE` if the capability is exposed.

**Capabilities exposed:**

| Capability | Purpose | Hornero skills that use it |
|---|---|---|
| `query` / `execute_query` | Run SQL, return rows | (forward-ref: PM analytics skills) |
| `list_databases` | Enumerate accessible databases | schema introspection |
| `list_schemas` | List schemas within a database | schema introspection |
| `list_tables` | List tables/views in a schema | schema introspection |
| `describe_table` | Column names, types, nullability | metric definition |

## Object Model

Snowflake's hierarchy and key entities:

- **Account** — top-level tenant, bound to a cloud region. Identifier: `<orgname>-<accountname>`. All objects live within one account. Cross-account sharing is possible via Secure Data Sharing but requires explicit setup.
- **Warehouse** — compute cluster, sized XS through 6XL. **Billed by the second while running.** Auto-suspend (default 600 s) and auto-resume are enabled by default on new warehouses. Sizing up speeds query execution but costs proportionally more; it doesn't help small queries.
- **Database** — top-level namespace. A single account holds many databases.
- **Schema** — namespace within a database. The familiar three-part path: `database.schema.table`.
- **Table** — permanent or transient. Transient tables skip Fail-safe (cheaper, less recoverable).
- **View** — logical view over one or more tables; no materialization cost.
- **MaterializedView** — incrementally maintained, query results pre-computed. Costs background warehouse compute to keep fresh. Use sparingly.
- **Stage** — pointer to a file location: internal (Snowflake-managed) or external (S3/GCS/Azure). Entry point for `COPY INTO` bulk loads.
- **Role** — RBAC unit. **Every query runs under exactly one role.** `USE ROLE X` mid-session switches visibility. The default role on connection matters; service accounts often have a dedicated role.
- **Query** — every execution has a `query_id`. History is available for 14 days via `INFORMATION_SCHEMA.QUERY_HISTORY` (database-scoped) or `SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY` (account-wide, up to 45-min lag).

**Hierarchy that matters for skills:**

```
Account
└── Database
    └── Schema
        ├── Table / View / MaterializedView
        └── Stage
Warehouse  (orthogonal to data hierarchy — just compute)
Role       (orthogonal — governs visibility at query time)
```

## Common Gotchas

- **Compute and storage are billed separately.** A warehouse must be RUNNING to execute any query. A small (XS) warehouse left idle auto-suspends after 600 s and costs nothing; a large (2XL+) warehouse forgotten overnight burns significant credits. Confirm `auto_suspend` and `auto_resume` are set on any warehouse a skill uses.
- **Warehouse sizing is not free scaling.** Doubling warehouse size doubles per-second cost. It only helps if the query is CPU/memory-bound across many micro-partitions — small point-lookups are unchanged.
- **Account identifier format changed.** Old format: `<account>.<region>` (e.g., `xy12345.us-east-1`). New canonical: `<orgname>-<accountname>` (e.g., `myorg-myaccount`). Both still connect, but the new form is required for Snowflake CLI and some drivers. Connection string mismatches are a common setup failure.
- **Roles are mandatory; visibility is role-scoped.** If a query returns no rows or `Object does not exist`, check what role the session is running under before assuming the table is missing. `SELECT CURRENT_ROLE()` is your first debug call.
- **Case sensitivity is a silent footgun.** Unquoted identifiers are UPPER-CASED internally. `SELECT * FROM users` looks up `USERS`. Quoted identifiers preserve case: `SELECT * FROM "users"` looks up `users`. If a table was created with quotes, it's case-sensitive forever — `USERS` and `users` are different tables.
- **`INFORMATION_SCHEMA` is database-scoped.** To enumerate tables across all databases, use `SNOWFLAKE.ACCOUNT_USAGE.TABLES` — but it has up to a 45-minute lag. `INFORMATION_SCHEMA` is real-time but covers only the current database.
- **Time Travel window defaults to 1 day** (TRANSIENT tables: 0 days). Can be extended up to 90 days on permanent tables at extra storage cost. Skills referencing historical snapshots via `AT(TIMESTAMP => ...)` should verify the table's `DATA_RETENTION_TIME_IN_DAYS` first.
- **Network policies bite silently.** An account-level or user-level network policy that rejects the agent's IP will produce auth errors that look like credential failures. Check with your Snowflake admin if connections refuse unexpectedly.
- **MFA on accounts with programmatic users.** If the org enforces MFA workspace-wide, service-account users need either an MFA exemption policy or key-pair auth. Password-only programmatic access will be blocked.

## Fallback Without MCP

If the MCP server isn't available, use `snowsql` (canonical CLI) or the SQL API.

**snowsql:**

```sh
snowsql \
  -a <orgname>-<accountname> \
  -u <user> \
  -d <database> \
  -s <schema> \
  -w <warehouse> \
  -q "SELECT CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE()"
```

Install: `brew install --cask snowflake-snowsql` or download from <https://docs.snowflake.com/en/user-guide/snowsql>.

**snowflake-cli (newer, `snow` command):**

```sh
pip install snowflake-cli-labs
snow connection test
snow sql -q "SELECT 1" --connection my-conn
```

Supports key-pair auth natively; config stored in `~/.snowflake/config.toml`.

**SQL API (HTTP, no client required):**

```sh
curl -X POST "https://<orgname>-<accountname>.snowflakecomputing.com/api/v2/statements" \
  -H "Authorization: Bearer ${SNOWFLAKE_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "statement": "SELECT COUNT(*) FROM my_db.my_schema.my_table",
    "warehouse": "MY_WAREHOUSE",
    "database": "MY_DB",
    "schema": "MY_SCHEMA"
  }'
```

The SQL API uses JWT or OAuth bearer tokens (not basic auth). Key-pair JWT generation is documented in the Snowflake SQL API guide.

For skills where interactive auth is acceptable, `snowsql` is the fastest fallback. For scripts and CI, the SQL API with key-pair JWT is the right path.

## References

- Snowflake documentation — <https://docs.snowflake.com/>
- SQL command reference — <https://docs.snowflake.com/en/sql-reference-commands>
- snowsql guide — <https://docs.snowflake.com/en/user-guide/snowsql>
- Snowflake CLI (`snow`) — <https://docs.snowflake.com/en/developer-guide/snowflake-cli/index>
- SQL API guide — <https://docs.snowflake.com/en/developer-guide/sql-api/index>
- Community MCP server — <https://github.com/isaacwasserman/mcp-snowflake-server>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. Snowflake is scaffolded for future PM skills around success-metrics validation and cohort analysis.
