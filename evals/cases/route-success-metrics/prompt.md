---
name: route-success-metrics
description: "Natural-language prompt routes to the success-metrics skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The success-metrics skill is invoked."
---
Define a success metric for the onboarding flow
