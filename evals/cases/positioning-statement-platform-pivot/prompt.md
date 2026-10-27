---
name: positioning-statement-platform-pivot
description: "Critique a Moore-template positioning statement for a platform pivot."
tags: [artifact]
runs: 2
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "The positioning-statement skill is invoked; the critique flags unscoped 'mid-market', 'AI-powered' as adjective marketing, and the weak competitive-alternative framing."
---
Critique this positioning statement before we use it externally.

For mid-market finance teams who need to manage spend across multiple vendors, our product is an AI-powered spend platform that gives them visibility, control, and savings. Unlike traditional procurement tools, we focus on the operator's workflow, not the buyer's process.
