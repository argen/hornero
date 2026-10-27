---
name: prd-cohort-duplicate
description: "Critique a PRD for the duplicate-cohort feature as a product manager."
tags: [artifact]
runs: 2
max_turns: 12
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "The prd skill is invoked in reviewer mode; the critique flags the missing counter-metric, the vague 'immediately edit' definition and the unbudgeted schema change, and ends with ranked actions."
---
Critique this PRD draft and tell me if it is ready to hand to engineering. Be antagonistic.

# PRD: Duplicate cohort

## Problem
Analysts rebuild near-identical cohorts by hand every week. Support tickets mention this about twice a week. We should add a "Duplicate" button.

## Goal
Let a user duplicate an existing cohort in 3 clicks or fewer.

## Success criteria
1. 40% of duplicated cohorts are edited immediately after duplication within 60 days of launch.
2. Median time to a new cohort drops.
3. Support tickets about cohort rebuilding go down.

## Constraints
- Ship in one sprint.
- No change to the permissions model.

## Out of scope
- Bulk duplication.
- Cross-workspace duplication.
- Audit-trail changes.

## Open questions
- Should a duplicate keep a link to its source cohort?
