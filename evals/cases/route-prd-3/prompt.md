---
name: route-prd-3
description: "Natural-language prompt routes to the prd skill."
tags: [routing]
runs: 1
max_turns: 4
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The prd skill is invoked."
---
Write a PRD for the cohort-duplicate feature
