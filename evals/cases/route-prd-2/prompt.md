---
name: route-prd-2
description: "Natural-language prompt routes to the prd skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The prd skill is invoked."
---
Write a PRD for the cohort-duplicate feature
