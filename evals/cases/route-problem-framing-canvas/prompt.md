---
name: route-problem-framing-canvas
description: "Natural-language prompt routes to the problem-framing-canvas skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The problem-framing-canvas skill is invoked."
---
Help me frame this problem before we write the spec
