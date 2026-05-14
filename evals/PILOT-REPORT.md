# Eval pilot report — 5 tasks (out of 20)

> **Status:** Pilot complete. 5 of 20 tasks run end-to-end with synthesised outputs and fresh-context judging. **Mean: 0.913** (n=5; v1 target ≥0.8 across 20).
>
> **Date:** 2026-05-14
> **Harness:** hornero-eval-pilot-v0
> **Run/judge model:** Claude Sonnet 4.6
> **Methodology caveat:** see § "Why this isn't v1-grade evidence yet" at the bottom.

## What the pilot did

For each of 5 pilot tasks (1, 4, 12, 14, 17 — picked to span the eval surface: all 7 roles, 2/3/4/5 role mixes, single-orchestrator and workflow-composition cohorts, one seeded-failure task):

1. A run-phase sub-agent (Sonnet, fresh context, full repo read access) drafted a synthetic artifact, then walked each role's reviewer-mode procedure serially, then synthesised per `skills/multi-role-review/SKILL.md`. Outputs written to `evals/runs/<slug>/`.
2. A separate judge-phase sub-agent (Sonnet, fresh context, *no access* to per-role files, manifests, or task briefs — only the synthesis and the rubric) scored each synthesis against the 4 rubric dimensions.

The two phases are deliberately decoupled. The judge never sees the role-by-role outputs or the seeded failure list — it scores the synthesis cold, matching the rubric's instruction "read the synthesis end-to-end; don't peek at per-role artifacts yet."

## Results

| Task | Roles | Cohort | Cite | Distinct | Conflict | Action | Mean |
|---|---|---|---|---|---|---|---|
| 01 engineer-pr-payments-migration | 3 | single | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 04 launch-plan-ledgerstack-pm-orch | 5 (PM-orch) | workflow-comp | 0.0 | 1.0 | 1.0 | 1.0 | **0.750** |
| 12 metric-definition-activation | 3 | single | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 14 strategic-narrative-startup | 2 | single | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 17 rfc-multi-region-architecture | 5 | workflow-comp | 1.0 | 1.0 | 1.0 | 1.0 | **1.000** |
| **Pilot mean (n=5)** | | | **0.7** | **1.0** | **0.95** | **1.0** | **0.913** |

### Cohort breakdown

- **Single-orchestrator cohort (n=3):** mean **0.938**.
- **Workflow-composition cohort (n=2):** mean **0.875**.

Both above 0.8. The workflow-composition cohort is pulled down by task 04's citation failure, not by anything structural in the PM-orchestrator path otherwise — task 04 scored 1.0 on every other dimension.

### Per-dimension breakdown

| Dimension | Mean (n=5) | Min | Max | Note |
|---|---|---|---|---|
| Source-citation rate | 0.7 | 0.0 | 1.0 | The clear weak point. Task 04 dropped to 0.0; tasks 12 and 14 to 0.75. |
| Finding distinctness | 1.0 | 1.0 | 1.0 | Ceiling everywhere — including the 5-role upper-bound task. Encouraging. |
| Conflict surfacing | 0.95 | 0.75 | 1.0 | Task 01 dipped to 0.75; the synthesis named the conflict but framed it shallowly. |
| Actionability | 1.0 | 1.0 | 1.0 | Ceiling everywhere. Owners + deliverables consistently present. |

## The real finding — PM-orchestrator citation washout

The most useful signal in this pilot is **task 04's citation collapse to 0.0**. The judge noted:

> "No named author, work, or framework is cited anywhere in the synthesis. Findings like GDPR Article 44 reference a regulation (not a named expert source), and no role's sources.md is invoked. Every finding is asserted from domain knowledge with zero explicit citations."

This is structural, not accidental. When the PM acts as orchestrator-of-orchestrators (per `cross-functional-orchestration`), the synthesis prioritises decision-shape (Go / Fix-then-go / Hold + owner + deliverable + revisit) over framework citation. The four sibling readouts cite their respective sources internally; the *PM-orchestrated synthesis* compresses to decision-form and loses the citation trail.

**Two possible reads:**

1. **The cross-functional-orchestration synthesis SHOULD preserve citations from siblings.** The rubric scores the synthesis, and the synthesis is the decision artifact the user reads. If it has no citations, it loses grounding.
2. **The cross-functional-orchestration synthesis SHOULD compress to pure decision-shape, and citations belong in the sibling readouts.** The rubric (designed for plain multi-role-review) over-penalises the orchestrator-of-orchestrators path.

The right answer is probably (1) — citations in the synthesis are how decisions stay defensible after the meeting ends. But this should be debated and resolved before the campaign expands to the full 20 tasks.

Actionable suggestion: update `cross-functional-orchestration` SKILL.md to require the synthesis to carry forward each sibling's load-bearing citation (1-2 per sibling) when summarising their finding. This costs ~5 lines of synthesis output and would have lifted task 04 from 0.75 to plausibly 1.0.

## Other findings

- **Citation rate is the only dimension where Hornero has real room.** Distinctness, conflict surfacing, and actionability hit ceiling repeatedly. The methodology is producing the *shape* of multi-role review correctly; the gap is in citation discipline at synthesis time.
- **The 5-role upper-bound mix (task 17) scored 1.0 across all dimensions.** This is the strongest single-task result, and contradicts the prior worry that role distinctness collapses at the upper bound. With proper detailed delegation, the 5-role mix can produce non-overlapping findings with full citation discipline.
- **Each pilot task surfaced its seeded issue.** Task 01: all 5 seeded defects. Task 04: all 5 seeded issues (refund-email bug, NPS-measurement gap, marketing copy overreach, GDPR data-residency, Growth/Scale tier collision). Task 12: Goodhart cited by name. Task 14: all 3 narrative weaknesses with framework citations. Task 17: both seeded gaps (Schrems-II named by case citation; SRM and region-as-co-variate). This is encouraging but doesn't show up in the rubric directly — seeded-issue surfacing is implicitly a Dimension 2 (distinctness) and Dimension 1 (citation) test, and both already scored well.

## Score.sh parser bug fixed

The pilot surfaced a bug in `evals/score.sh --aggregate`: the parser used a grep+sed pattern that assumed each dimension's score was on the same line as the dimension name, and mis-parsed multi-line nested JSON (task 01's score.json). Fix shipped in this PR: jq-based parser with a grep fallback for environments without jq. The fix is documented in `evals/score.sh` itself.

## Why this isn't v1-grade evidence yet

Three caveats stack:

1. **n=5, not n=20.** The README target is "≥0.8 across 20." Five samples is encouraging but underpowered. The 0.913 pilot mean has wide confidence intervals; the true mean across 20 could plausibly be anywhere in [0.75, 1.0].

2. **LLM-as-judge, not human judge.** The rubric explicitly calls for human judgement. The judges in this pilot were Claude Sonnet 4.6 sub-agents with fresh context. The strongest mitigation applied: judges had no access to per-role files, manifests, or task briefs — only the synthesis and the rubric. This controls for self-preference bias on the *production* path but not for general LLM-judge biases (surface-feature anchoring, citation-as-quality conflation, generic over-grading).

3. **The runs were produced by the same model class as the judges (Sonnet 4.6).** Production sessions in the wild will use various Claude models. Same-model run/judge configuration is a known weak point in eval methodology.

For v1: a human (the methodology author or an external reviewer) should re-score at least these 5 syntheses (independently, not after seeing the LLM scores) and compare. If the human re-score is within ±0.1 of the LLM score, the LLM-judge signal is plausible. If it diverges further, the LLM-judge results should be treated as a baseline estimate and the methodology re-thought.

## What to do next

Three options, ordered by my recommendation:

1. **Fix the PM-orchestrator citation gap, then expand the campaign.** Update `cross-functional-orchestration` to require citation carry-forward in synthesis; re-run task 04 to confirm the fix; then run the remaining 15 tasks. The pilot's most useful output was the citation-washout finding; fix it before scaling.

2. **Run the full 20 with the methodology as-is.** Accept the citation-rate cohort gap; ship the v1 mean at whatever it lands at; surface the gap in the v1 launch notes as a known limitation.

3. **Stop here.** The pilot demonstrated the workflow is sound and that the methodology produces ≥0.8-class output on a representative sample. Declare evals "validated by pilot" and move on.

My recommendation: **Option 1**. The PM-orchestrator citation gap is real and small to fix. The pilot has done its job — surfacing a high-leverage methodology improvement before the full campaign locks in the v1 number.

## Files in this pilot

```
evals/runs/
  01-engineer-pr-payments-migration/
    artifact.md  software-engineer.md  security-expert.md  tester.md
    synthesis.md  manifest.json  score.json
  04-launch-plan-ledgerstack-pm-orch/
    artifact.md  marketing-expert.md  tester.md  security-expert.md  data-scientist.md
    synthesis.md  manifest.json  score.json
  12-metric-definition-activation/
    artifact.md  data-scientist.md  product-manager.md  software-engineer.md
    synthesis.md  manifest.json  score.json
  14-strategic-narrative-startup/
    artifact.md  marketing-expert.md  product-manager.md
    synthesis.md  manifest.json  score.json
  17-rfc-multi-region-architecture/
    artifact.md  software-engineer.md  product-manager.md  security-expert.md  data-scientist.md  tester.md
    synthesis.md  manifest.json  score.json
```

This PILOT-REPORT.md lives at `evals/PILOT-REPORT.md` (not `evals/runs/`) so it ships in the repo. The per-run outputs under `evals/runs/<slug>/` are workspace-only by design — the `.gitignore` rule `evals/runs/*` keeps the corpus from being committed (workspace-specific, regenerable, large). To inspect or re-judge a synthesis from this pilot, either (a) regenerate locally using the sub-agent prompts from this PR's commit message, or (b) selectively force-add the files you want: `git add -f evals/runs/<slug>/synthesis.md evals/runs/<slug>/score.json`.
