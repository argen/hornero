---
name: strategic-narrative-startup
description: "Critique a startup strategy narrative against its roadmap as a product manager."
tags: [artifact]
runs: 2
max_turns: 12
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "strategy-kernel or bet-portfolio is invoked; the critique names the generic 'change in the world', the product-as-magic-gift gap, thin evidence, and the narrative-versus-roadmap mismatch."
---
Critique this strategy narrative for our Series-A compliance reporting startup. I want to know if the strategy is real and whether our roadmap can deliver what it promises.

# Narrative

1. The old way: mid-market finance teams assemble compliance reports in spreadsheets.
2. The change in the world: AI is changing everything.
3. The promised land: compliance reporting that runs itself.
4. Our magic gift: an AI-powered platform with dashboards, workflows and integrations.
5. Evidence: one customer said "this would save us weeks", and we have spoken to 50 prospects.

# Roadmap, next 4 quarters
Q1 SSO and audit logs. Q2 two ERP integrations. Q3 role-based approvals. Q4 report templates for one regulation.
