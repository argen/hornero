---
name: positioning-draft-generic
description: "Critique a positioning draft whose slots are all filled with generic placeholders."
tags: [artifact]
runs: 2
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "The positioning-statement skill is invoked; the critique names the generic slots (status quo alternative, adjective claims, unscoped segment) and proposes a tighter segment."
---
Here's the positioning draft for our new B2B product. The team thinks it is done. Review it.

- Competitive alternatives: Excel, the status quo
- Unique attributes: AI-powered, fast, easy to use
- Value: saves time
- Best-for segment: growing teams
- Market category: the AI productivity platform
