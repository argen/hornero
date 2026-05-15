---
name: datadog
description: Datadog observability — metrics, logs, traces (APM), monitors, dashboards, SLOs. Used by PMs to validate launch impact (error rates, latency, adoption-by-cohort) and to ground claims about reliability.
type: data-source
status: stretch
mcp:
  server: "datadog-mcp-server"
  install: "claude mcp add datadog -- npx -y @winor30/mcp-server-datadog"
  auth_env: [DD_API_KEY, DD_APP_KEY, DD_SITE]
  capabilities: [metrics_query, logs_search, monitor_list, dashboard_list, slo_list, events]
object_model: [Metric, Log, Trace, Span, Monitor, Dashboard, SLO, Service, Host, Tag, Event]
used_by: []
fallback: curl
---

## Purpose

Datadog is the observability layer most product-engineering teams run in production. PMs need it to ground launch-impact claims — did error rates move? Did latency regress? Is the new cohort adopting at the expected rate? Hornero skills using Datadog will read metrics, query logs, inspect monitors, and list SLOs; they do not write production config. Without MCP, the same data is reachable via the REST API v1/v2.

## MCP Server

**Canonical server:** Datadog publishes an official MCP server at <https://github.com/DataDog/datadog-mcp-server>. If that package is unavailable in your install path, the community package `@winor30/mcp-server-datadog` (npm) covers most read capabilities.

**Install (official, recommended — verify current instructions at the repo):**

```sh
# Check https://github.com/DataDog/datadog-mcp-server for the latest install path
claude mcp add datadog -- /path/to/datadog-mcp-server
```

**Install (community / npm fallback):**

```sh
claude mcp add datadog -- npx -y @winor30/mcp-server-datadog
```

**Auth:** three env vars are required. Set them before registering the server.

| Var | Purpose |
|---|---|
| `DD_API_KEY` | Authenticates the organisation — identifies which Datadog account is being accessed. |
| `DD_APP_KEY` | Authenticates the *user* within the org — required for almost all read endpoints. Both keys together are how Datadog authorises API calls. |
| `DD_SITE` | Regional endpoint. Defaults to `datadoghq.com` (US1). Other values: `datadoghq.eu`, `us3.datadoghq.com`, `us5.datadoghq.com`, `ap1.datadoghq.com`, `ddog-gov.com`. |

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `metrics_query` | Timeseries data via metric query DSL | (forward-ref: `launch-metrics`) |
| `logs_search` | Structured log event search | (forward-ref: `launch-metrics`) |
| `monitor_list` | Alert state at a glance | (forward-ref: `reliability-check`) |
| `dashboard_list` | Enumerate dashboards for linking | (forward-ref: `reliability-check`) |
| `slo_list` | SLO status and burn rate | (forward-ref: `launch-metrics`) |
| `events` | Deploy markers, state-change timeline | (forward-ref: `launch-metrics`) |

## Object Model

- **Metric** — timeseries; has a name, tag set, and points. Query language is Datadog's metric query DSL: aggregator (`avg:`, `sum:`, `max:`, `min:`) → metric name → scope filter `{tag:value}` → optional time aggregation `.rollup(avg, 60)`. Example: `avg:trace.http.request.duration{service:api,env:prod}.rollup(avg, 60)`.

- **Log** — structured event with fields: service, host, source, tags, message, attributes (arbitrary JSON), status (info / warn / error / critical). Query language is log search syntax. Example: `service:api status:error @http.status_code:5*`. Attributes are prefixed with `@`.

- **Trace** — APM distributed trace, identified by a `trace_id`. A trace is a tree of **Spans**; the root span carries the entry-point metadata (service, resource, duration, error flag). Spans nest via `parent_id`.

- **Monitor** — alert definition. Has a query, a type (`metric`, `log`, `composite`, `apm`, `process`, etc.), notification rules (channels, message template), and a current state (`OK`, `Warn`, `Alert`, `No Data`).

- **Dashboard** — collection of widgets. Identified by a short `id`; has a `title` and a `layout_type` (ordered / free).

- **SLO** — service-level objective. Has a `type` (`metric` or `monitor`), a numeric `target` (e.g. 99.9), and a `timeframe` (7d / 30d / 90d). The current error budget and burn rate are derived fields.

- **Service** — APM service catalog entry. Appears only when the APM integration is configured and sending traces for that service name.

- **Host** — infrastructure host, tagged. Tags are the primary scoping mechanism across every object type.

- **Tag** — `key:value` pair. Tags are foundational: every metric query, log search, and monitor scope is expressed through tags. Designing tag strategy early matters for cardinality (see Gotchas).

- **Event** — timeline event with a title, text, timestamp, and tags. Used for deploy markers, alert state transitions, and custom annotations. Useful for correlating metric changes to deploys.

## Common Gotchas

- **API key vs App key — both required.** The most common setup mistake: `DD_API_KEY` is set but `DD_APP_KEY` is not. Nearly every read endpoint needs both. Errors are generic 403s that don't mention the missing key.

- **DD_SITE is not optional.** A US1 key cannot query the EU endpoint. The error is a 403 or 404, not "wrong region." If queries silently return no data, suspect a site mismatch before debugging the query.

- **Metric query DSL is its own language.** The aggregator prefix (`avg:`, `sum:`, etc.) is mandatory. Scope filters are `{key:value}` after the metric name. Time rollup is a trailing function. Get the query wrong and you get a `400` with an unhelpful message. Build and validate queries in Datadog's Metrics Explorer before wiring them into a skill.

- **Tag cardinality kills metric quotas.** High-cardinality tags (`user_id`, `request_id`) on *custom* metrics blow through the custom-metrics quota fast; each unique tag combination is a separate metric series. Logs are fine. If a skill emits custom metrics, enforce low-cardinality tag sets.

- **Log retention defaults to 15 days.** Longer windows require log indexing configuration or the Flex Logs tier. Skills querying older data will silently get nothing.

- **Live tail vs. historical search.** Live tail is real-time but rate-limited and returns a sampled stream — not suitable for exact counts. Historical search (`/api/v2/logs/events/search`) has ~30 s eventual-consistency lag for the most recent logs.

- **Time values in the REST API are seconds-since-epoch.** The metric query `from`/`to` and the events `start`/`end` parameters expect integer seconds, not milliseconds. Sending milliseconds produces a `400` or silently returns no data.

- **Per-endpoint rate limits.** Log search defaults to ~600 req/hour. Check `X-RateLimit-Remaining` in responses. Metric query is more generous. Skills doing bulk log analysis should paginate with cursors and back off on `429`.

- **APM traces are sampled.** Head-based sampling is on by default; "I can't find the trace" usually means it wasn't kept. Retention filters can preserve specific traces (by service, resource, status). Skills making statements about trace data must account for sampling bias.

- **Service catalog requires integration config.** A service won't appear in the APM service catalog just because traces with that service name exist — the integration must be explicitly configured in Datadog.

## Fallback Without MCP

Datadog REST API v1/v2 via `curl`. Set `DD_API_KEY`, `DD_APP_KEY`, and `DD_SITE` in the environment before running.

**Metric query (last 1 hour):**

```sh
curl -G "https://api.${DD_SITE}/api/v1/query" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  --data-urlencode "from=$(date -u -d '1 hour ago' +%s)" \
  --data-urlencode "to=$(date -u +%s)" \
  --data-urlencode "query=avg:trace.http.request.duration{service:api,env:prod}"
```

**Log search (errors in the last hour, 50 results):**

```sh
curl -X POST "https://api.${DD_SITE}/api/v2/logs/events/search" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "query": "service:api status:error",
      "from": "now-1h",
      "to": "now"
    },
    "page": { "limit": 50 }
  }'
```

For monitors, dashboards, or SLOs, the v1 list endpoints (`/api/v1/monitor`, `/api/v1/dashboard`, `/api/v1/slo`) follow the same auth pattern with a GET.

## References

- Datadog API docs — <https://docs.datadoghq.com/api/latest/>
- Metric query DSL — <https://docs.datadoghq.com/dashboards/querying/>
- Log search syntax — <https://docs.datadoghq.com/logs/explorer/search_syntax/>
- API and Application keys — <https://docs.datadoghq.com/account_management/api-app-keys/>
- Datadog sites and regional endpoints — <https://docs.datadoghq.com/getting_started/site/>
- Datadog MCP server (official) — <https://github.com/DataDog/datadog-mcp-server> (verify; if unavailable, see <https://docs.datadoghq.com/>)
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. Datadog is scaffolded for future PM skills around launch-impact validation and success-metrics grounding.
