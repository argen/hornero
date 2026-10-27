---
name: route-strategy-kernel
description: "Natural-language prompt routes to the strategy-kernel skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The strategy-kernel skill is invoked."
---
Write a strategy kernel for our Q3 initiative
