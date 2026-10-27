---
name: metric-definition-activation
description: "Critique a metric definition for weekly activation rate."
tags: [artifact]
runs: 2
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "The success-metrics skill is invoked; the critique flags the missing counter-metric as a Goodhart risk, the unscoped population and the gaming surface."
---
Critique this metric definition before we put it on the growth dashboard.

# Weekly activation rate

- Definition: % of signups that complete onboarding in their first week.
- Population: all signups.
- Counter-metric: none, activation only goes up.
- Owner: Growth team.
- Target: 60% by end of quarter.
