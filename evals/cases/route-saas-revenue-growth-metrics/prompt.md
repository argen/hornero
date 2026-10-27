---
name: route-saas-revenue-growth-metrics
description: "Natural-language prompt routes to the saas-revenue-growth-metrics skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The saas-revenue-growth-metrics skill is invoked."
---
Walk me through our NRR and ARR story
