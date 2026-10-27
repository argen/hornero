---
name: linear
description: Issue tracker for product engineering — Issues, Projects, Cycles, Teams. Used for triage, sprint planning, and prioritisation work.
type: data-source
status: stable
mcp:
  server: "@modelcontextprotocol/server-linear"
  install: "claude mcp add linear -- npx -y @modelcontextprotocol/server-linear"
  auth_env: [LINEAR_API_KEY]
  capabilities: [issues, projects, cycles, comments, search, teams, labels]
object_model: [Issue, Project, Cycle, Team, Label, State, Milestone, Comment]
used_by:
  - product-manager/linear-triage
  - product-manager/prd
  - query-issue-tracker
fallback: curl
---

## Purpose

Linear is the issue tracker most product-engineering teams use day-to-day. Roles touching it: PMs (triage queues, sprint planning, prioritisation), engineers (issue→PR linkage, blocker discovery), designers (handoff threads), testers (regression tickets, release readiness). Hornero skills can read and write Linear directly when the MCP server is connected; without it, they fall back to GraphQL via `curl`.

## MCP Server

Two integration paths are available. Choose based on your deployment context.

### Option A — claude.ai integration (personal use, recommended)

`mcp__claude_ai_Linear__` is the native Linear integration in claude.ai. Enable it via **Settings → Integrations → Linear** and authenticate via Linear's OAuth. No API key or local server needed. The OAuth handshake (`authenticate` → `complete_authentication`) activates the integration per session.

Prefer this path for personal use and interactive Hornero sessions — auth is handled by claude.ai and token refresh is transparent.

### Option B — self-hosted server (team deployments, CI)

**Canonical server:** `@modelcontextprotocol/server-linear` (community-maintained reference; see References for the authoritative repo).

**Install:**

```sh
claude mcp add linear -- npx -y @modelcontextprotocol/server-linear
```

**Auth:** set `LINEAR_API_KEY` to a personal API key with at least `read` scope (write scopes if any skill creates issues / comments). Generate at *Settings → Account → API → Personal API keys*. Workspace-admin keys are unnecessary and over-broad for most skills.

**Capabilities exposed (verified against the MCP server's tools list):**

| Capability | Purpose | Hornero skills that use it |
|---|---|---|
| `list_issues`, `search_issues` | Triage queues, stale work | `linear-triage` |
| `get_issue`, `update_issue` | Drill-down, status change | `linear-triage` |
| `list_projects`, `get_project` | Project health, scope check | `linear-triage` (forward-ref) |
| `list_cycles`, `get_cycle` | Sprint readout | `linear-triage` |
| `create_comment` | Triage notes back into the issue | `linear-triage` (optional) |

## Object Model

Linear's primary entities and ID shapes:

- **Issue** — `IDE-123` style identifier (team-prefix + sequential). Fields: title, description (Markdown), state, priority (0=none, 1=urgent, 2=high, 3=medium, 4=low), assignee, project, cycle, labels, estimate, parent, due date.
- **Project** — long-lived initiative spanning cycles. Has lead, members, target date, status (planned / started / paused / completed / canceled).
- **Cycle** — time-boxed sprint (default 2 weeks). Has number, start/end dates, scope at start, completed at end.
- **Team** — workspace partition. Issues belong to exactly one team; the team prefix is part of every issue ID.
- **State** — workflow state within a team (Backlog / Todo / In Progress / In Review / Done / Canceled, plus team-custom).
- **Label** — free-form tag, team-scoped or workspace-scoped.

**Relationships that matter for skills:**
- Issue → 0..1 Project, 0..1 Cycle, 0..N Labels
- Project → 0..1 Lead, 0..N Members, 0..N Issues
- Cycle → exactly-1 Team, 0..N Issues

**Query shape:** the MCP server exposes filtered list queries (`list_issues({state, assignee, project, cycle, label, updated_after, ...})`). Most triage skills compose 2-3 filters; complex graph traversals fall back to GraphQL.

## Common Gotchas

- **Rate limit: 1,500 requests per hour per token.** Bulk reads of large workspaces will throttle; paginate and cache `updated_after` watermarks rather than re-listing the world. The MCP server doesn't surface remaining quota — track it yourself if you're scripting bulk reads.
- **Cursor pagination, not offset.** `endCursor` from `pageInfo` is the only forward pointer. `first: 250` is the max page size; defaults to 50.
- **Workspace vs. team scope.** A "personal API key" sees every team the user is a member of, not the whole workspace. Issues outside the user's team membership are silently invisible — surprising in audit-style skills.
- **State names are not stable IDs.** "In Progress" can be renamed per-team. Always resolve via the state's UUID, not its display name. The MCP server exposes UUIDs.
- **Priority `0` means "no priority"**, not "lowest." Confusing default when filtering "priority ≥ 2."
- **Archived projects/cycles still resolve by ID** but don't appear in default lists. Pass `includeArchived: true` if a stale link points at one.
- **No bulk-update primitive.** Updating N issues = N requests = N hits on the rate limit. Plan accordingly for skills that re-label / re-prioritise.

## Fallback Without MCP

If the MCP server isn't available, skills should drop to GraphQL via `curl`. Linear has a single GraphQL endpoint at `https://api.linear.app/graphql`.

```sh
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: ${LINEAR_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"query": "query { viewer { id name email } }"}'
```

Example: list issues updated in the last 7 days for a project:

```graphql
query StaleTriage($projectId: ID!) {
  issues(
    filter: {
      project: { id: { eq: $projectId } }
      state: { type: { in: ["unstarted", "started"] } }
      updatedAt: { gt: "P7D" }
    }
    first: 50
  ) {
    nodes { identifier title state { name } assignee { name } updatedAt }
  }
}
```

The fallback path is slower and more verbose; skills using it should batch GraphQL queries (Linear supports multiple roots per request) and cache.

## References

- Linear API docs — <https://developers.linear.app/docs>
- Linear GraphQL schema — <https://studio.apollographql.com/public/Linear-API/home>
- MCP server source — <https://github.com/jerhadf/linear-mcp-server> (community reference; check for an Atlassian/Linear-official server before adoption)
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: `skills/linear-triage/SKILL.md`
