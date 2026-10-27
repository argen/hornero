---
name: route-saas-economics-efficiency-metrics
description: "Natural-language prompt routes to the saas-economics-efficiency-metrics skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The saas-economics-efficiency-metrics skill is invoked. The metrics snapshot is inline so the routing test is fair, since runs start in an empty workspace."
---
How healthy is our Rule of 40

Snapshot (last twelve months, B2B SaaS):

- Revenue: $18.2M, up 24% year over year
- Free cash flow margin: 6%
- Gross margin: 74%
- Net burn: $0.6M per month
- Net new ARR: $3.1M
- Cash on hand: $9.5M
