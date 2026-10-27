---
name: route-chronicle-recall
description: "Natural-language prompt routes to the chronicle-recall skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "With the chronicle seeded by seed-chronicle.sh (run with --scaffold), the chronicle-recall skill is invoked."
---
What decisions are relevant for the pricing initiative
