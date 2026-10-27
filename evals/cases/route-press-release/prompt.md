---
name: route-press-release
description: "Natural-language prompt routes to the press-release skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The press-release skill is invoked."
---
Write a working-backwards press release
