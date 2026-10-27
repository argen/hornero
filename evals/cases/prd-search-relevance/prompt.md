---
name: prd-search-relevance
description: "Critique a polished but solution-shaped PRD for search relevance."
tags: [artifact]
runs: 2
max_turns: 12
env:
  EVAL_HORNERO_NO_AUTO_EXTRACT: "1"
allowed_tools: [Read, Glob, Grep, Skill, Agent]
expected_outcome: "The prd skill is invoked; the critique names the solution-shaped problem statement, the success metric untied to behaviour, and the absent counter-metric."
---
Critique this PRD. It reads well to me but something feels off.

# PRD: Improve search relevance

## Problem
Users complain about bad search. We need to rewrite search using semantic embeddings and LLM re-ranking.

## Goal
Ship the new ranking stack for our B2B knowledge-base product.

## Success metric
Search satisfaction NPS improves.

## Out of scope
Not adding new fields to the index.

## Timeline
Week 1-2 embeddings pipeline. Week 3-4 re-ranker integration. Week 5 internal dogfood. Week 6 rollout to all customers.
