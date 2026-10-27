---
name: route-chronicle-record
description: "Natural-language prompt routes to the chronicle-record skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The chronicle-record skill is invoked."
---
Record the decision to defer bulk export to Q4
