---
name: route-cross-functional-orchestration
description: "Natural-language prompt routes to the cross-functional-orchestration skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The cross-functional-orchestration skill is invoked: a launch plan is a cross-functional readiness question, not a spec. The artifact is inline so the routing test is fair, since runs start in an empty workspace."
---
Critique this launch plan

# Launch plan: Scheduled report exports

## Goal
Announce scheduled exports to existing admins and get 30% of 10+ seat workspaces to create a schedule within 90 days.

## Audience
Finance and workspace admins on Team and Enterprise plans (about 1,200 accounts).

## Dates
- Sep 8: internal dogfood begins
- Sep 22: beta to 20 design-partner accounts
- Oct 6: general availability
- Oct 13: follow-up email to non-adopters

## Channels
- In-app banner on the export screen
- Email to admins
- Changelog post and help-center article
- CSM talking points for the top 50 accounts

## Readiness checklist
- [x] Feature flag and rollout plan
- [x] Help-center article drafted
- [ ] Support macros written
- [ ] Pricing and plan-gating decision
- [ ] Adoption dashboard built
- [ ] Rollback plan agreed with engineering
