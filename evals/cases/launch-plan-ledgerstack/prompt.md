---
name: launch-plan-ledgerstack
description: "Run a cross-functional review of a launch plan with a hold-or-go decision."
tags: [artifact]
runs: 2
max_turns: 12
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "cross-functional-orchestration is invoked, the product-manager-reviewer agent is dispatched, and the synthesis names one forcing decision (cut Tuesday or hold)."
---
We cut LedgerStack v2 on Tuesday and I need a go or hold call. Orchestrate a cross-functional review of this launch plan and give me one decision.

# LedgerStack v2 launch plan

Public launch, Tuesday 09:00 UTC. Three changes ship together:
1. Payments provider migration. All 2,400 paying accounts move from Provider A to Provider B over a 6-hour window. Cards are re-tokenised in bulk.
2. New dashboard replacing the current home screen for everyone, no opt-out.
3. Pricing: the Team tier goes from $29 to $39 per seat; existing customers are grandfathered for 3 months.

Claims in the launch brief: "99% of accounts migrate with no action", "trust NPS up 10 points", "ARPU up 15% in a quarter".

Known issues: the refund confirmation email still renders the old provider's name; the pricing page copy says "unlimited seats" but the tier caps at 50; support has had no training on the migration FAQ.

Rollback: re-point to Provider A within 2 hours; tokens already migrated cannot be unmigrated.
