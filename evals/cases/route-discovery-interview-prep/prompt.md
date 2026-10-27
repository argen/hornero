---
name: route-discovery-interview-prep
description: "Natural-language prompt routes to the discovery-interview-prep skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The discovery-interview-prep skill is invoked."
---
Prep me for discovery interviews with enterprise users
