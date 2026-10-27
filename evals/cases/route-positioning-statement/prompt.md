---
name: route-positioning-statement
description: "Natural-language prompt routes to the positioning-statement skill."
tags: [routing]
runs: 1
max_turns: 4
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill]
expected_outcome: "The positioning-statement skill is invoked. The deck excerpt is inline so the routing test is fair, since runs start in an empty workspace."
---
Here's the positioning deck, review it

# Positioning: Beacon Reports (draft deck excerpt)

- Target customer: finance operations leads at B2B SaaS companies with 50-500 employees and a monthly close.
- Category: close-management software, not a general BI tool.
- Competitive alternative: spreadsheets plus a shared checklist, and in larger accounts a BI dashboard someone maintains by hand.
- Differentiated value: reconciles usage, billing and revenue in one view, so the close finishes in days rather than weeks.
- Proof: median close time fell from 9 days to 4 across 12 pilot customers.
- Proof: two enterprise references, one case study published.
- Tagline on slide 1: "The smarter way to report."
- Slide 4 claims "best-in-class analytics" with no supporting data.
- Slide 6 lists five audiences: finance, RevOps, IT, executives and auditors.
- Pricing slide is blank, to be filled after the pricing review.
- Next step on the last slide: "Align with sales on messaging."
