---
name: route-competitive-teardown
description: "Natural-language prompt routes to the competitive-teardown skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The competitive-teardown skill is invoked."
---
Run a competitive teardown on Stripe
