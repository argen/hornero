---
name: route-stakeholder-update
description: "Natural-language prompt routes to the stakeholder-update skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The stakeholder-update skill is invoked."
---
Update Maya's stakeholder entry after today's 1:1
