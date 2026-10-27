---
name: route-hypothesis-track
description: "Natural-language prompt routes to the hypothesis-track skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The hypothesis-track skill is invoked."
---
Track new evidence on the activation hypothesis
