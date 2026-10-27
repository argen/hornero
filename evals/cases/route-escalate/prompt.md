---
name: route-escalate
description: "Ambiguous prompt should draw a clarifying question, not a guessed skill. matches problem-framing-canvas AND strategy-kernel AND chronicle-recall"
tags: [routing]
runs: 1
max_turns: 4
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The assistant asks a clarifying question and does not invoke a skill."
---
Help me think through the activation problem
