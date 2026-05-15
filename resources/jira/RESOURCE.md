---
name: jira
description: Atlassian's issue tracker — Issues, Epics, Sprints, Projects, Boards. Used for triage and sprint planning by PMs and engineers.
type: data-source
status: stretch
mcp:
  server: "mcp-atlassian (community; Atlassian Remote MCP for OAuth path)"
  install: "claude mcp add atlassian -- npx -y @sooperset/mcp-atlassian"
  auth_env: [JIRA_HOST, JIRA_USERNAME, JIRA_API_TOKEN]
  capabilities: [issues, epics, sprints, projects, boards, jql_search, comments, transitions, users]
object_model: [Issue, Epic, Sprint, Project, Board, Status, Component, Version, Comment, User]
used_by: []
fallback: curl
---

## Purpose

Jira is the dominant issue tracker in enterprise product-engineering and service teams. Roles that touch it: PMs (sprint planning, epic tracking, release readiness), engineers (issue→commit linkage, blocker discovery, sub-task management), testers (test execution issues, bug filing), and support (service-management projects). Hornero has no Jira-consuming skill today — this card is scaffolded for future PM skills (sprint readout, cross-functional triage). If the MCP server is connected, those skills will query via JQL; without it, they fall back to REST v3 via `curl`.

## MCP Server

Two options exist. Pick the official Atlassian Remote MCP when you can; fall back to the community server for API-token auth.

**Option 1 — Atlassian Remote MCP (official, OAuth, recommended):**

Atlassian hosts an OAuth-based Remote MCP server for Jira and Confluence. Auth is managed through Claude Desktop's MCP connector UI — no token to manage manually. Register it as a remote server:

```sh
# In Claude Desktop: Settings → Integrations → Add → Atlassian
# URL: https://mcp.atlassian.com/v1/mcp  (verify at atlassian.com/platform/remote-mcp-server)
```

No `auth_env` vars required; OAuth flow handles credentials. Supports Jira Cloud only.

**Option 2 — community server (API token, scriptable):**

```sh
claude mcp add atlassian -- npx -y @sooperset/mcp-atlassian
```

**Auth (community server):** set three env vars before starting Claude:

```sh
export JIRA_HOST=https://your-org.atlassian.net
export JIRA_USERNAME=you@example.com
export JIRA_API_TOKEN=<token-from-id.atlassian.com/manage/api-tokens>
```

The token is a user-scoped API token, not a password. Permissions are whatever the token owner has — scope to a read-only account for agent workloads.

**Capabilities exposed (community server):**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `jira_search` (JQL) | Triage queues, sprint scoping | (future: `jira-sprint-readout`) |
| `jira_get_issue` | Issue drill-down, sub-task tree | (future) |
| `jira_get_project` | Project metadata, component list | (future) |
| `jira_get_sprint` | Active sprint scope and velocity | (future) |
| `jira_transition_issue` | Move issue through workflow | (future; write) |
| `jira_add_comment` | Triage notes back into issue | (future; write) |

## Object Model

Primary entities and key field shapes:

- **Issue** — identified by `PROJ-123` (project key + sequential number). Fields: summary, description, issuetype, status, priority, assignee (`accountId`), reporter, labels, components, fixVersions, customfield_* (opaque per-instance IDs for custom fields), parent (sub-task relationship in classic; Epic link in next-gen).
- **Epic** — classic projects: a special issue type; linked via `customfield_10014` (Epic Link). Next-gen (team-managed): parent-issue relationship, no custom field. The field name and semantics differ — always check project type.
- **Sprint** — Scrum-board feature only; not present on Kanban boards. Has `state` (future / active / closed), start/end dates, board ID. Lives in the Agile/board API namespace (`/rest/agile/1.0/sprint`), not the core issue API.
- **Project** — identified by a short KEY (e.g. `PROJ`). Has lead, project type (`software` / `service_desk` / `business`), project category, and classic vs. next-gen flag. API behavior diverges substantially between types.
- **Board** — Scrum or Kanban. Filter-backed (a saved JQL filter defines the board scope). Board ID is independent of project key.
- **Status / Workflow** — statuses are per-project, per-issue-type workflow. There is no global "In Progress" — each project defines transitions. Always resolve by status ID or category (To Do / In Progress / Done) rather than display name.
- **Component** — project-scoped grouping (e.g. "Frontend", "Auth"). Used in JQL: `component = Frontend`.
- **Version** — project-scoped release milestone (Fix Version, Affects Version). Has release date and `released` flag.
- **JQL (Jira Query Language)** — the primary query mechanism. More powerful than Linear's filter model: supports `ORDER BY`, `IN`, `WAS`, `CHANGED`, `during`, and history-aware predicates. The `jira_search` MCP tool typically exposes a `jql` string parameter directly.
- **User** — identified by `accountId` (stable UUID). `username` and `name` fields were removed in GDPR-era Cloud APIs. Old docs and SDKs that reference `name` or `key` will fail against modern Cloud endpoints.

**Relationships that matter for skills:**
- Issue → 1 Project, 0..1 Sprint (via board), 0..1 Epic, 0..N Components, 0..N Versions, 0..N Comments
- Sprint → 1 Board → 1 Project (typically; boards can span projects via filter)
- Epic → 0..N Issues (classic: via Epic Link custom field; next-gen: via parent)

## Common Gotchas

- **Classic vs. next-gen projects have divergent APIs.** Epic linking, custom fields, and roadmap features behave differently. Check `project.style` (`classic` vs. `next-gen`) before assuming field semantics.
- **JQL is the only practical query path.** The `/issue/search` REST endpoint is JQL-only; there's no structured filter API equivalent. The MCP `jira_search` tool surfaces this directly. Learn JQL before writing any Jira skill.
- **Cloud vs. Server/Data Center APIs differ.** This card covers Jira Cloud (`*.atlassian.net`). Server/DC endpoints, auth (cookies instead of API tokens), and feature availability diverge. Don't cross-apply docs.
- **`accountId` replaced `username` and `key`.** GDPR compliance removed username-based lookups from Cloud APIs in 2019. Old docs showing `assignee: username` are wrong; use `assignee: accountId`.
- **Custom fields use opaque IDs.** Fields like Epic Link, Story Points, and anything your org added are accessed as `customfield_10014`, `customfield_10016`, etc. These IDs are per-instance — look them up via `GET /rest/api/3/field` before hardcoding. Never assume field IDs from examples in docs.
- **Rate limits are dynamic, not fixed.** Atlassian Cloud uses adaptive rate limiting — no published fixed request budget. Expect 429s under load; always implement exponential backoff. Bulk reads over large projects will routinely trigger throttling.
- **Pagination is `startAt` + `maxResults`.** Max page size is 100 for issue search (`/issue/search`), 50 for some agile endpoints. There's no cursor — paginate by incrementing `startAt` until `total` is reached.
- **Permissions are per-project.** A token with "Browse Projects" on `PROJ-A` may not see `PROJ-B`. Silent 404s or empty results are often a permission gap, not missing data. Scope the token owner's project access explicitly for agent workloads.
- **Sprint API lives under `/rest/agile/1.0/`**, not the core `/rest/api/3/` namespace. Sprint data on issues comes back as `sprint` in the Agile issue representation, not in the standard issue response unless you request the `sprint` field explicitly.

## Fallback Without MCP

Use Atlassian REST API v3 with `curl` and HTTP Basic auth (email + API token, Base64-encoded). The API token is never a password — generate one at <https://id.atlassian.com/manage/api-tokens>.

**Auth header:**
```sh
# Pre-encode once; reuse across calls
JIRA_AUTH=$(echo -n "${JIRA_USERNAME}:${JIRA_API_TOKEN}" | base64)
```

**JQL search — open issues in a project, ordered by priority:**
```sh
curl -s \
  -H "Authorization: Basic ${JIRA_AUTH}" \
  -H "Accept: application/json" \
  "https://${JIRA_HOST}/rest/api/3/issue/search?jql=project%3DPROJ%20AND%20status!%3DDone%20ORDER%20BY%20priority%20ASC&maxResults=50&startAt=0"
```

**Get a single issue:**
```sh
curl -s \
  -H "Authorization: Basic ${JIRA_AUTH}" \
  -H "Accept: application/json" \
  "https://${JIRA_HOST}/rest/api/3/issue/PROJ-123?fields=summary,status,priority,assignee,customfield_10014"
```

**Paginate:** increment `startAt` by `maxResults` until `startAt >= total` in the response envelope.

`acli` (Atlassian CLI) exists but is not widely preinstalled and requires separate licensing for some operations — treat `curl` as the universal fallback, not `acli`.

## References

- Jira Cloud REST API v3 docs — <https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/>
- JQL reference — <https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/>
- Atlassian Remote MCP server (official) — <https://www.atlassian.com/platform/remote-mcp-server>
- `mcp-atlassian` community server (sooperset) — <https://github.com/sooperset/mcp-atlassian>
- Atlassian API token management — <https://id.atlassian.com/manage/api-tokens>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. Jira is scaffolded for future PM skills (sprint readout, cross-functional triage).
