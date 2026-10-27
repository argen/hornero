---
name: route-interview-synthesis
description: "Natural-language prompt routes to the interview-synthesis skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The interview-synthesis skill is invoked."
---
Synthesise the three interviews I ran this week
