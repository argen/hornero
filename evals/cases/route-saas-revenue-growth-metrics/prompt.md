---
name: route-saas-revenue-growth-metrics
description: "Natural-language prompt routes to the saas-revenue-growth-metrics skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The saas-revenue-growth-metrics skill is invoked. The metrics snapshot is inline so the routing test is fair, since runs start in an empty workspace."
---
Walk me through our NRR and ARR story

Snapshot (trailing twelve months, B2B SaaS):

- ARR now: $12.4M; ARR a year ago: $9.1M
- New-logo ARR added: $2.6M
- Expansion ARR: $1.9M
- Churned ARR: $0.8M; contraction ARR: $0.4M
- NRR: 112%
- GRR: 87%
- Customers: 310 now, 270 a year ago
