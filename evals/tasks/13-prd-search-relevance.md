# Task 13 — PRD critique: search relevance improvement

**Shape:** PM-led PRD critique on a measurement-affecting feature.

**Artifact:** A 3-page PRD titled "Improve search relevance" for a B2B knowledge-base product. Problem statement names "users complain about bad search"; proposes a rewrite using semantic embeddings + LLM re-ranking; success metric is "search satisfaction NPS." Out-of-scope section is one line ("not adding new fields to the index"). Includes a 6-week timeline. The PRD reads polished but has three load-bearing issues: (1) problem statement is solution-shaped (the solution is in the framing); (2) success metric isn't tied to a behaviour change; (3) no counter-metric (latency, infra cost, or off-domain regression).

**Recommended role mix (3):**

- `product-manager` — load-bearing; problem-shape vs solution-shape, success-metric tie to outcome, four-big-risks pass (Cagan), counter-metric requirement.
- `data-scientist` — does "search satisfaction NPS" reflect what we want to move? What are the right primary + guardrail metrics? Is the experiment design implicit-or-explicit?
- `designer` — does the UX of search-result-display match the new ranking model? Is there a state for "we re-ranked and now the first result is unintuitive"?

**Why not other roles:** internal tool, no marketing surface; no LLM-risk surface beyond what the security role would surface in a later threat-model.

**What "good" looks like:**

- PM names the problem-shape issue explicitly and cites Cagan (or `spec-the-problem`) — proposes a problem-shaped restatement.
- DS proposes a specific OEC + ≥2 guardrails (latency tail, off-domain regression rate); cites Kohavi.
- Designer surfaces the result-list-display question as a state-audit concern (Norman / Nielsen).
- Synthesis names a single forcing decision: re-shape the problem before approving the timeline, OR approve with a hard counter-metric gate.
- The recommendation specifies a measurable counter-metric, not "monitor for regressions."

**Anti-patterns to watch for:**

- PM approves the solution-shaped framing.
- DS treats "NPS" as a valid OEC without challenge (Goodhart: NPS is gameable by survey timing).
- Synthesis ends with "iterate" / "the team should align" (Dimension 4 failure).

**How to run:**

1. Place the PRD at `evals/runs/13-prd-search-relevance/artifact.md` (the `roles/product-manager/skills/prd/SKILL.md` Examples section has a template).
2. Invoke `multi-role-review` with product-manager + data-scientist + designer.
3. Score with attention to whether the problem-shape issue made it through to the recommendation as a forcing decision.
