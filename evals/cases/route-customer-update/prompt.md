---
name: route-customer-update
description: "Natural-language prompt routes to the customer-update skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The customer-update skill is invoked."
---
Update Acme account health signals
