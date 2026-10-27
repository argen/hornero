---
name: route-prd
description: "Natural-language prompt routes to the prd skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The prd skill is invoked. The artifact is inline so the routing test is fair, since runs start in an empty workspace."
---
Here is my PRD, please critique it

# PRD: Scheduled report exports

## Problem
Finance admins at our B2B customers export the same usage report by hand every month and email it to their controllers. Three enterprise accounts raised this in QBRs this quarter. We should let admins schedule recurring exports.

## Success criteria
1. 30% of workspaces with 10+ seats create at least one schedule within 90 days of launch.
2. Manual export clicks per active admin fall by 25% in the same window.
3. Support tickets tagged "report export" drop by half.

## Constraints
- Ship in one quarter with two engineers.
- Delivery is email only; no change to the permissions model.

## Out of scope
- Slack or webhook delivery.
- Custom report builder.
- Per-recipient access controls.

## Open questions
- Who owns a schedule when its creator leaves the workspace?
