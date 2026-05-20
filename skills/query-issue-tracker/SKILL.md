---
name: query-issue-tracker
description: Cross-system read primitive over the team's issue tracker — Linear or Jira. Resolves an intent ("active blockers on the export project", "issues changed in the last 7 days by the auth team", "open enterprise-tier bugs") to a structured result without forcing the caller to learn the underlying query language.
intent: |
  Make issue-tracker lookups skill-callable without coupling consumers to
  Linear's filter API or Jira's JQL. Other skills (PRDs, triage,
  release-readiness, prep) call this as the read primitive; the
  tracker-specific translation lives here.
type: workflow
theme: delivery
resources:
  - linear
  - jira
best_for:
  - Skills that need a small, current slice of the tracker as context (`prep`, `prd`, release-readiness)
  - Ad-hoc PM questions during a session ("what's open against project X right now?")
  - Cross-team blocker discovery before a roadmap call
scenarios:
  - "PM running `/prep` for a 1:1 with the eng lead; the brief needs the 5 highest-priority open issues in their project. The skill resolves it whether the team is on Linear or Jira; the brief author never touches the underlying API."
  - "A PRD references 'all issues currently blocking the export rewrite'. The skill returns a stable list with id, title, status, assignee, age."
  - "Release-readiness check needs every issue in the cut-version still in a non-Done state. The skill answers it from one call regardless of tracker."
estimated_time: 1-2 minutes per query
---

# Query issue tracker

## Purpose

Other Hornero skills need to read from the team's issue tracker without each one re-deriving how to query it. Linear's filter model and Jira's JQL are different surfaces; their MCP servers expose different tool names. This skill is the single read primitive — it takes an intent in plain words, maps it onto whichever tracker is configured, returns a stable result shape.

The skill is read-only on purpose. Writes (creating issues, moving status, adding comments) belong to tracker-specific skills like `linear-triage` because the social discipline around writes differs per team. Reads are universal.

If neither resource is configured, the skill surfaces the `curl` fallback recipes in [`resources/linear/RESOURCE.md`](../../resources/linear/RESOURCE.md) and [`resources/jira/RESOURCE.md`](../../resources/jira/RESOURCE.md) and stops — graceful degradation, not failure.

## Key Concepts

### Tracker detection is structural, not interactive

The skill does not ask "which tracker?". It detects by checking which MCP server is connected at the start of the call:

1. Linear MCP available → use Linear path.
2. Jira MCP available → use Jira path.
3. Both available → prefer the one the caller named in the intent (e.g. "Linear project X"); otherwise prefer Linear (more common in product-engineering teams).
4. Neither available → surface fallback recipes and stop.

This means consuming skills don't need to branch on tracker themselves.

### Three query shapes cover the common cases

Most legitimate read intents collapse into one of three shapes. Anything outside these is a sign the consumer should call the tracker directly via its own skill, not via this primitive.

1. **List by filter** — "issues matching X, sorted by Y". E.g. open + priority high + project=auth, sorted by created_at desc.
2. **Drill one** — "everything I need to know about issue Z" — description, status, assignee, comments, sub-task tree, recent activity.
3. **Active scope** — "what's in the current sprint/cycle for team T". Linear: active cycle; Jira: active sprint on the board.

The skill exposes these as three named call shapes. New shapes get added only when a real consumer needs them, not pre-emptively.

### Result shape is tracker-neutral

The skill returns a stable Markdown table or YAML block with the same column set regardless of tracker:

| Column | Linear source | Jira source |
|---|---|---|
| `id` | `IDE-123` | `PROJ-123` |
| `title` | issue title | summary |
| `status` | state name (mapped to category) | status category (To Do / In Progress / Done) |
| `priority` | 0–4 | 1–5 inverted (1=Highest → "high") |
| `assignee` | name or `unassigned` | display name or `unassigned` |
| `updated_at` | ISO timestamp | ISO timestamp |
| `url` | linear.app URL | atlassian.net URL |

Priority is normalised to `urgent / high / medium / low / none` so consumers don't carry the raw int. Status is normalised to category (`todo / in-progress / done`) for the same reason — the raw state name varies per team's workflow.

### What this skill is NOT

- **Not a triage skill.** `linear-triage` already exists for the weekly Linear pass; a future `jira-triage` will mirror it. This skill is a primitive; triage is a workflow.
- **Not a write path.** No status changes, no comments, no issue creation. If a consumer needs to write, it calls the tracker's MCP tools directly (with the right social discipline).
- **Not a cache.** Each call hits the live tracker. Don't accumulate stale results across a session.

### Engine routing vs divergent logic

The `## Application` section below names one MCP tool per tracker for each of the three call shapes — six branch points total. That sounds like "if Linear, X; if JIRA, Y" repeated, but the branches are **engine-routing only** (one tool name per shape), not divergent logic. The two trackers expose the same shape of read; only the tool names differ. Engine routing per shape is the right factoring for a cross-system primitive — splitting into `query-linear` + `query-jira` would force every consumer to detect-then-dispatch, which defeats the purpose. The anti-pattern this skill is *not* falling into is divergent behaviour by tracker (e.g., "on Linear we return cycle-relative dates, on Jira we return absolute dates") — that would belong in tracker-specific skills.

## Application

The skill is invoked by other skills or directly in conversation. It takes one of three named shapes:

### Shape 1 — List by filter

Inputs the caller provides:

- **project / team** — Linear: project name or id; Jira: project key.
- **filter expression** — plain English ("open, priority ≥ high, updated in last 7 days") — the skill translates.
- **sort** — `priority_desc` (default), `updated_desc`, `created_desc`, `age_desc` (computed: now - created_at).
- **limit** — default 20, max 100.

Tracker-specific translation:

- **Linear** → filter object passed to `list_issues` / `search_issues`.
- **Jira** → JQL string passed to `jira_search`.

### Shape 2 — Drill one

Input: a single id. Output: a structured block with description, status, assignee, priority, sub-tasks or child issues, last 3 comments, recent activity.

Tracker-specific:

- **Linear** → `get_issue` + `get_issue_comments`.
- **Jira** → `jira_get_issue` (with `fields=*all`) + sub-task expansion.

### Shape 3 — Active scope

Input: team / project + (optional) cycle/sprint id.

- **Linear** → `list_cycles` filtered to `state: started`, then `list_issues --cycle=<id>`.
- **Jira** → board lookup → `jira_get_sprint --state=active` → issues in sprint.

If the team is on Kanban (no sprints/cycles), the skill returns "no active scope; the team is on a continuous-flow board" and surfaces the open-WIP list as a substitute.

### Auth and fallback

If the MCP server is not connected, the skill stops and prints the relevant `curl` recipe from the resource card. Don't try to wrap `curl` in a synthetic primitive — the resource card's fallback section is the source of truth.

## Examples

### List the top open issues blocking a project (Linear)

```
Call: query-issue-tracker --shape list \
        --project "Export rewrite" \
        --filter "open, priority >= high, has label 'blocker'" \
        --sort priority_desc --limit 10

Result:
| id      | title                                      | status      | priority | assignee | updated_at           |
|---------|--------------------------------------------|-------------|----------|----------|----------------------|
| ENG-412 | p99 export latency regression on v3.2      | in-progress | urgent   | jordan   | 2026-05-20T14:02:00Z |
| ENG-388 | CSV export breaks on rows > 50k            | in-progress | high     | maya     | 2026-05-19T09:31:00Z |
| ENG-376 | Webhook retries cause duplicate exports    | todo        | high     | (unassigned) | 2026-05-15T11:22:00Z |
```

### Drill one (Jira)

```
Call: query-issue-tracker --shape drill --id PROJ-1042

Result:
## PROJ-1042 — Customer cannot generate invoice for split-pay deals

- status: in-progress (category: in-progress)
- priority: high
- assignee: devlin
- created: 2026-05-12; updated: 2026-05-20
- url: https://acme.atlassian.net/browse/PROJ-1042

### Description
Customer on the Acme account hit a 500 when generating the May invoice for
deals using the split-pay terms introduced in 2026-04. ...

### Sub-tasks (2)
- PROJ-1043 — Repro on staging (status: done)
- PROJ-1044 — Fix InvoiceGenerator pathway (status: in-progress)

### Last 3 comments
- 2026-05-20, jordan: "Repro confirmed on staging; investigating null-deref in invoice line builder."
- 2026-05-19, maya: "Customer escalation from CSM; SLA breach risk."
- 2026-05-12, support: "Original ticket from Acme CS."
```

### Active scope on a Kanban board (Jira)

```
Call: query-issue-tracker --shape active --project PROJ

Result: No active scope; team is on a continuous-flow board.
Open WIP (in-progress) instead — 7 issues, top 5 by age:
| id        | title                            | priority | assignee | age (days) |
|-----------|----------------------------------|----------|----------|------------|
| PROJ-1042 | Customer cannot generate invoice | high     | devlin   | 8          |
| ...
```

## Common Pitfalls

1. **Reaching past the three shapes.** If a caller needs a query that doesn't fit list / drill / active, the answer is usually "call the tracker's own MCP tools directly", not "extend this skill". The whole point of the three-shape constraint is to keep the primitive narrow.
2. **Asking the user which tracker to use.** The skill detects from MCP availability. Asking is a UX bug — consumers chained downstream see an unnecessary prompt.
3. **Returning raw priority ints or raw status names.** Always normalise — `urgent / high / medium / low / none` for priority; `todo / in-progress / done` for status category. Consumers branching on raw values become brittle to per-team workflow changes.
4. **Caching across calls.** Each invocation is a fresh read. The tracker is the source of truth; a stale cached result that says "ENG-412 is todo" while the live state is "in-progress" poisons downstream reasoning.
5. **Falling back to `curl` silently.** If neither MCP is available, surface the fallback recipes from the resource card and stop. Don't run `curl` from inside the skill — the resource card already documents the right shell pattern.
6. **Mixing tracker dialects in the result.** A Jira call returns Jira ids and atlassian.net URLs; a Linear call returns Linear ids and linear.app URLs. Don't try to "harmonise" beyond what the column normalisation does — the id and URL columns are the tracker fingerprint, and that's legitimate.

## References

- [`resources/linear/RESOURCE.md`](../../resources/linear/RESOURCE.md) — Linear MCP capabilities, auth, object model, fallback recipes.
- [`resources/jira/RESOURCE.md`](../../resources/jira/RESOURCE.md) — Jira MCP capabilities, JQL guidance, fallback recipes.
- [`roles/product-manager/skills/linear-triage/SKILL.md`](../../roles/product-manager/skills/linear-triage/SKILL.md) — Linear-specific weekly triage workflow that uses this primitive as input.
- [`roles/product-manager/skills/prd/SKILL.md`](../../roles/product-manager/skills/prd/SKILL.md) — PRDs that reference live tracker state pull through this skill.
- [`skills/prep/SKILL.md`](../prep/SKILL.md) — meeting briefs that include "what's currently open for this person/project".
