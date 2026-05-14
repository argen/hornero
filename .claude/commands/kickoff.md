---
description: Get started with Hornero in under 5 minutes. Walks a new user through their first dispatch — picking a small real task, choosing the right role/skill, running it.
---

# /kickoff

The user has just opened Hornero and wants to try it. Walk them through one real, useful dispatch in under 5 minutes. Do not lecture; do not summarise the methodology.

## What to do

1. **Read [`playbooks/onboarding.md`](../../playbooks/onboarding.md)** end to end. It is the canonical onboarding walkthrough. Follow its sequence.

2. **Ask one short question**: what's something they could use a second opinion on right now? Offer 2-3 examples — **pick the ones that match their likely role**, inferred from their cwd, recent files, or directly asked if ambiguous. Always include at least one non-engineering example unless the cwd is clearly a code project:
   - **Engineer** — "Review your last commit / current diff." or "Produce an ADR / RFC for X."
   - **Designer** — "Run a heuristic review on a screen — paste a screenshot, a Figma URL, or a written state list." or "Audit a surface for accessibility (WCAG 2.2)."
   - **PM** — "Critique a PRD draft / a problem statement / a draft OKR set." or "Plan a launch — `/orchestrate` will frame as customer job + dispatch the role mix."
   - **Marketer** — "Critique a positioning draft / launch brief / homepage hero." (Note: `positioning-canvas` reviewer mode works on drafts without customer evidence — invoke it for critique even before the evidence base is in.)
   - **Tester** — "Write a failing regression test for a bug." or "Produce a risk-driven test plan for a feature."
   - **Security** — "Threat-model a new auth flow / third-party integration / LLM-touching feature."
   - **Data scientist** — "Audit an A/B test design / metric definition / causal claim."
   - **Repo-level** — "Audit this repo's AI-coding harness (`/harness-check` or natural-language equivalent)."

3. **Don't expand beyond what they asked.** Pick the smallest matching role + skill, declare the choice in one line (per the dispatcher protocol in [`CLAUDE.md`](../../CLAUDE.md) / [`AGENTS.md`](../../AGENTS.md)), and do the work. Show them what good output looks like.

4. **At the end, point them at one next step**:
   - `/catalog` — see what else is available.
   - `/orchestrate` — when they have a cross-functional decision.
   - `/review` — when they have something needing multiple expert lenses.
   - [`playbooks/role-cheatsheet.md`](../../playbooks/role-cheatsheet.md) — 1-page reference.

Keep it terse and demonstrative. The goal is a working first dispatch, not a tour.
