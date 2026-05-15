---
name: github
description: Code host — PRs, issues, Actions, code search, releases, CODEOWNERS. Cross-role: engineers (PR review), PMs (issue triage), testers (CI health), security (dependabot, secret scanning).
type: data-source
status: stable
mcp:
  server: "github-mcp-server"
  install: "claude mcp add github -- npx -y @modelcontextprotocol/server-github"
  auth_env: [GITHUB_PERSONAL_ACCESS_TOKEN]
  capabilities: [pulls, issues, actions, code_search, releases, codeowners, dependabot]
object_model: [Repository, PullRequest, Issue, Commit, Workflow, WorkflowRun, Release, Review, Comment, CheckRun]
used_by: []
fallback: curl
---

## Purpose

GitHub is the substrate every Hornero role touches at least obliquely: engineers ship via PRs, PMs file and groom issues, testers monitor CI health, security audits dependabot alerts and secret scanning, designers track design-system PRs, marketing reads release notes. Hornero skills using GitHub need to read structured PR / issue / Actions data without slurping unbounded text — the MCP server gives them filtered, paginated access; the `gh` CLI is the fallback.

## MCP Server

**Canonical server:** GitHub's official `github-mcp-server` (preferred over the older community npm package). Both are listed below; pick the official one when it's available in your install path.

**Install (official server, recommended):**

```sh
# See https://github.com/github/github-mcp-server for current install instructions —
# the project ships a Go binary; download for your platform and register it:
claude mcp add github -- /path/to/github-mcp-server
```

**Install (community / npm fallback):**

```sh
claude mcp add github -- npx -y @modelcontextprotocol/server-github
```

**Auth:** set `GITHUB_PERSONAL_ACCESS_TOKEN` to a **fine-grained PAT** scoped to the repos the skill needs (least-privilege). Classic PATs work but grant org-wide blast radius — prefer fine-grained. Required scopes per capability:

- Read PRs / issues / Actions: `repo:read`, `actions:read`
- Comment on PRs / issues: `pull_requests:write`, `issues:write`
- Read dependabot / secret scanning: `security_events:read`

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `list_pull_requests`, `get_pull_request` | PR triage, review queue | `github-pr-survey` |
| `get_pull_request_files`, `get_pull_request_reviews` | Diff shape, CODEOWNERS coverage | `github-pr-survey` |
| `list_issues`, `search_issues` | Related issues for a PR, project triage | `github-pr-survey` |
| `list_workflow_runs`, `get_workflow_run` | CI health, flaky-test detection | (forward-ref: `ci-health`) |
| `search_code` | Code archaeology, "who else calls X" | (forward-ref: `code-archaeology`) |

## Object Model

Primary entities and ID shapes:

- **Repository** — `owner/repo` slug. Has default branch, language, topics, visibility.
- **PullRequest** — repo-scoped sequential number. Fields: title, body, base, head, state (open/closed/merged), author, reviewers, requested-reviewers, labels, milestone, draft, mergeable, mergeable_state, files-changed, additions, deletions.
- **Issue** — repo-scoped sequential number (shares namespace with PRs). Fields overlap with PR but no base/head/merge.
- **Commit** — SHA. Author, committer, message, parents, stats, files, verification.
- **Workflow** / **WorkflowRun** — Actions surface. Run has status (queued / in_progress / completed) and conclusion (success / failure / cancelled / skipped / timed_out).
- **Review** — PR-scoped. State: APPROVED / CHANGES_REQUESTED / COMMENTED / DISMISSED.
- **CheckRun** — finer-grained than WorkflowRun; each job within a run is a check.

**Relationships that matter:**
- PR → 1 Repository, 1 head Commit, 1 base ref, 0..N Reviews, 0..N CheckRuns
- Issue ↔ PR via "closes #N" prose (resolve via `timelineItems` if you need linkage)
- Commit → 0..N PRs (a commit can be in multiple PRs)

**CODEOWNERS:** read from `.github/CODEOWNERS` (or `docs/CODEOWNERS` / repo-root); the MCP server doesn't parse it directly — `github-pr-survey` parses it inline.

## Common Gotchas

- **Rate limits depend on auth.** Unauthenticated: 60 req/hour. Authenticated PAT: 5,000 req/hour. GitHub App: 15,000 req/hour. The MCP server doesn't proactively surface `X-RateLimit-Remaining`; budget for it in bulk skills.
- **Search API is separately rate-limited** — 30 req/min for authenticated, 10/min unauthenticated. `search_code` and `search_issues` will throttle hard before the main quota does.
- **`mergeable` and `mergeable_state` are eventually-consistent.** Right after a push, both can be `null` for ~5 seconds. Retry or skip if you need a definitive answer.
- **PRs and Issues share numeric namespace.** `#42` could be either; the API has separate endpoints. `list_issues` returns *both* unless filtered with `pulls=false` (or use search with `is:issue`).
- **Draft PRs hide from default `list_pull_requests`** unless you pass `state=all` and filter on `draft` yourself.
- **CODEOWNERS is text, not API-structured.** The MCP server returns the raw file; skills parse the glob syntax themselves. Watch for inheritance, team handles (`@org/team`), and order-matters semantics.
- **Default branch is not always `main`.** Some legacy repos still use `master`, some use `develop`. Read `repository.default_branch` rather than assuming.
- **Fine-grained PATs expire by default (max 1 year).** Skills running in CI need a token-rotation story; document in the consuming skill.

## Fallback Without MCP

If the MCP server isn't available, use the `gh` CLI (preinstalled on most dev machines, sandbox-friendly, respects `GITHUB_TOKEN` and `gh auth login`):

```sh
# Authenticated as the user
gh auth status

# List open PRs
gh pr list --state open --json number,title,author,labels,reviewDecision,createdAt

# Single PR detail + files
gh pr view 123 --json title,body,baseRefName,headRefName,files,reviews
gh api repos/{owner}/{repo}/pulls/123/files --paginate

# Workflow runs for a branch
gh run list --branch main --json status,conclusion,workflowName,createdAt
```

For complex queries, drop to the REST or GraphQL API directly:

```sh
gh api graphql -f query='
  query($owner: String!, $name: String!) {
    repository(owner: $owner, name: $name) {
      pullRequests(first: 20, states: OPEN) {
        nodes { number title author { login } reviewDecision }
      }
    }
  }
' -f owner=argen -f name=hornero
```

The fallback path matches MCP capabilities feature-for-feature for read-heavy skills; write-heavy skills (`gh pr comment`, `gh issue create`) are also covered. The main loss vs. MCP is structured tool-calling — the agent has to parse JSON output.

## References

- GitHub REST API — <https://docs.github.com/en/rest>
- GitHub GraphQL API — <https://docs.github.com/en/graphql>
- `gh` CLI manual — <https://cli.github.com/manual/>
- CODEOWNERS syntax — <https://docs.github.com/en/repositories/managing-your-repositories-settings-and-features/customizing-your-repository/about-code-owners>
- `github-mcp-server` (official) — <https://github.com/github/github-mcp-server>
- `@modelcontextprotocol/server-github` (community npm) — <https://github.com/modelcontextprotocol/servers/tree/main/src/github>
- Rate-limit primer — <https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting>
- Related Hornero skills: none currently. The previous consumer (`roles/software-engineer/skills/github-pr-survey`) was retired with the software-engineer role and returns on re-expansion.
