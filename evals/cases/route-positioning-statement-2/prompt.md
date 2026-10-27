---
name: route-positioning-statement-2
description: "Natural-language prompt routes to the positioning-statement skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The positioning-statement skill is invoked."
---
Draft a positioning statement for the new checkout
