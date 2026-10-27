---
name: route-escalate-2
description: "Ambiguous prompt should draw a clarifying question, not a guessed skill. no artifact type specified — too ambiguous to route"
tags: [routing]
runs: 1
max_turns: 4
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The assistant asks a clarifying question and does not invoke a skill."
---
Review this
