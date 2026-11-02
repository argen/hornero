---
name: route-prioritization-advisor
description: "Natural-language prompt routes to the prioritization-advisor skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The prioritization-advisor skill is invoked. The backlog is inline so the routing test is fair, since runs start in an empty workspace."
---
Prioritise these 12 backlog items for next sprint

1. SSO via Okta for enterprise accounts
2. Fix CSV export timing out above 50k rows
3. Dark mode
4. Usage-based billing meter
5. Onboarding checklist for new workspaces
6. Slack notifications for overdue tasks
7. Migrate search to the new index
8. Audit log retention setting
9. Bulk edit for task assignees
10. Reduce dashboard load time (p95 is 6s)
11. Public API rate-limit headers
12. Redesign the settings page
