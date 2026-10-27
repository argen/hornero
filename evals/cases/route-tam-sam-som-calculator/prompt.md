---
name: route-tam-sam-som-calculator
description: "Natural-language prompt routes to the tam-sam-som-calculator skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The tam-sam-som-calculator skill is invoked."
---
How do I size the market for this vertical
