---
name: route-okrs
description: "Natural-language prompt routes to the okrs skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The okrs skill is invoked."
---
Draft OKRs for the activation initiative
