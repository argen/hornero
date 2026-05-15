# Eval report — v1 (20 tasks, mean 0.903)

> **Scope note (2026-05-15):** Hornero retracted to PM-only. The 13 non-PM
> eval tasks and runs have been deleted; only the 7 PM-led tasks remain
> reproducible (`02, 04, 08, 12, 13, 14, 18`). The full v1 campaign numbers
> below are retained as historical record of what the methodology produced
> when 7 roles shipped — they are not reproducible against the current tree.
> Re-expansion of the role set should re-run the affected tasks, not delete
> this report.

> **Status:** Full campaign complete. **Mean: 0.903 across n=20** (v1 target ≥ 0.8 met).
>
> **Date:** 2026-05-14
> **Harness:** hornero-eval-v1
> **Run model:** Claude Sonnet 4.6 (run sub-agents)
> **Judge model:** Claude Sonnet 4.6 (fresh-context judge sub-agents — see methodology caveats at the foot)

## Headline

20 representative cross-functional tasks were run end-to-end through Hornero's role-based methodology — `multi-role-review` for 16 tasks, the PM-led `cross-functional-orchestration` for 2 tasks, and the tester-led `pre-release-test-pass` for 1 task. Each synthesis was judged cold by a fresh-context sub-agent against the four rubric dimensions (citation rate, distinctness, conflict surfacing, actionability). **Pilot fix shipped mid-campaign** — `cross-functional-orchestration` updated to require citation carry-forward in synthesis (Step 4 req. 5 + "Grounding" line in the decision template + Pitfall 3b), validated by re-running task 04 (0.0 → 0.75 on citation rate; mean 0.75 → 0.875).

## Full results

| # | Task | Cite | Distinct | Conflict | Action | Mean |
|---|---|---|---|---|---|---|
| 01 | engineer-pr-payments-migration | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 02 | prd-cohort-duplicate | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 03 | rfc-cache-invalidation | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 04 | launch-plan-ledgerstack-pm-orch (v2) | 0.75 | 1.0 | 0.75 | 1.0 | **0.875** |
| 05 | threat-model-llm-feature | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 06 | dashboard-redesign-spec | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 07 | experiment-readout-pricing | 1.0 | 1.0 | 1.0 | 1.0 | **1.000** |
| 08 | positioning-canvas-draft | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 09 | test-plan-checkout-cart | 0.75 | 1.0 | 0.75 | 1.0 | **0.875** |
| 10 | accessibility-audit-onboarding | 0.5 | 1.0 | 0.75 | 1.0 | **0.812** |
| 11 | refactor-plan-payment-rails | 1.0 | 0.75 | 0.75 | 1.0 | **0.875** |
| 12 | metric-definition-activation | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 13 | prd-search-relevance | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 14 | strategic-narrative-startup | 0.75 | 1.0 | 1.0 | 1.0 | **0.938** |
| 15 | pre-release-test-pass-mobile | 0.25 | 0.75 | 0.5 | 1.0 | **0.625** |
| 16 | causal-claim-retention | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| 17 | rfc-multi-region-architecture | 1.0 | 1.0 | 1.0 | 1.0 | **1.000** |
| 18 | positioning-statement-platform-pivot | 0.75 | 0.75 | 0.75 | 1.0 | **0.812** |
| 19 | experiment-design-pricing | 0.75 | 1.0 | 0.75 | 1.0 | **0.875** |
| 20 | threat-model-third-party-integration | 1.0 | 1.0 | 0.75 | 1.0 | **0.938** |
| | **Mean (n=20)** | **0.825** | **0.963** | **0.825** | **1.000** | **0.903** |

## Per-dimension means

| Dimension | Mean | Note |
|---|---|---|
| Source-citation rate | **0.825** | Lifted from pilot (0.7) after the cross-functional-orchestration fix. Remaining weakness concentrated in workflow-composition syntheses (task 15) and one designer-led task (10). |
| Finding distinctness | **0.963** | Near-ceiling. The methodology produces non-overlapping role findings even at 5-role mixes (task 17: 1.0). |
| Conflict surfacing | **0.825** | The most-frequent dip. Run sub-agents tended to declare "no real conflicts" honestly but without examining latent trade-offs — a pattern across 8 of 20 tasks. |
| Actionability | **1.000** | Ceiling on every task. Owners, deliverables, and dates are consistently present. |

## Cohort breakdown

| Cohort | n | Mean |
|---|---|---|
| Single-orchestrator (plain `multi-role-review`) | 17 | **0.916** |
| Workflow-composition (`cross-functional-orchestration`, `pre-release-test-pass`, 5-role upper bound) | 3 | **0.833** |

Both above the 0.8 target. The workflow-composition cohort is pulled down by task 15 (0.625) — discussed below.

## Notable observations

### The cross-functional-orchestration citation fix worked

Pilot task 04 (v0) scored 0.0 on citation rate while scoring 1.0 elsewhere — the worst dimension/score outlier of any task in either run. The mid-campaign fix to `cross-functional-orchestration` SKILL.md (adding Step 4 requirement 5 "carry citations forward" + a "Grounding" line in the decision template + documenting Pitfall 3b "citation washout in synthesis") lifted the v2 run to 0.75 on citation rate. **Citation discipline carries across the PM-orchestrator path when the skill explicitly demands it; without the demand, the decision-shape compression washes citations out.**

### Task 15 (tester-orchestrated mobile pre-release) is the campaign's lowest score

Task 15 scored 0.625 — the only sub-0.8 result. The judge noted: *"Only the tester cites named sources; engineer, security, and designer have none."* This generalises the lesson from task 04: **workflow-composition syntheses lose citations from the input stages unless the orchestrating skill explicitly carries them forward.**

`pre-release-test-pass` SKILL.md should adopt the same fix as `cross-functional-orchestration`: require citation carry-forward in the synthesis (one named source per input stage), surfaced both inline in the recommendation and in a Grounding line at the foot. This applies to `pre-launch-marketing-audit`, `pre-launch-security-audit`, and `pre-launch-measurement-audit` by symmetry — they are all workflow-composition skills with the same structural pressure.

**Recommended follow-up:** propagate the citation-carry-forward discipline to all four `pre-launch-*` workflow skills + `pre-release-test-pass`. One PR, all five workflow-composition skills updated. Should lift workflow-composition cohort scores from 0.833 toward ~0.9 in a re-run.

### Conflict surfacing is the next dimension to polish

8 of 20 tasks scored 0.75 on conflict surfacing. The pattern from the judge rationales: run sub-agents honestly stated "no real conflicts" (a legitimate 1.0 per the rubric) but **didn't examine latent trade-offs that a careful reader would surface**. Examples:
- Task 11: "tension named (1 PR vs 4) with trade-off framing, but resolved one-sidedly rather than left open."
- Task 13: "'No conflicts' handled honestly with a meta-explanation; fractionally shallow on trade-off framing."
- Task 19: "synthesis correctly calls 'no material conflicts,' but leaves one latent tension (mechanism ambiguity vs. run-now framing) unexamined."

A future tightening pass on `multi-role-review` SKILL.md could add a "latent trade-off" probe to the synthesis discipline: even when no role explicitly conflicts with another, the synthesis should name 1-2 sequencing/scope/timing trade-offs implicit in the composite recommendation. This is the difference between a 0.75 and a 1.0 on this dimension. Not a v1 blocker; a v1.1 polish.

### Citation rate variance correlates with role-source-density

The lowest citation scores (task 10 at 0.5, task 15 at 0.25) are tasks where the per-role outputs themselves cite sparingly. The methodology can't carry forward citations that don't exist in the input. This points back at editorial discipline on the role files: some roles' source citations are denser than others (the security and data-scientist roles cite most consistently; the designer role often cites WCAG criterion numbers but less often the named authors in `sources.md`). Worth a future editorial sweep on the per-role sources discipline.

### Distinctness holds at the 5-role upper bound

Task 17 (5-role multi-region RFC) scored 1.0 on distinctness — refuting the worry that role overlap collapses at the upper bound. With detailed delegation and per-role briefing, even 5 roles surface non-overlapping findings. This is one of the campaign's most encouraging single-task results.

### Actionability is the most reliable dimension

Every single task scored 1.0 on actionability. Hornero consistently produces synthesis that ends with named owners, concrete deliverables, and explicit dates. **This is the dimension where the methodology has reached ceiling; further investment yields no measurable lift.**

## Methodology caveats — NOT yet v1-grade evidence

The 0.903 mean clears the v1 target but **the methodology behind the number has known limitations:**

1. **LLM-as-judge across the entire campaign.** All 20 judges were Claude Sonnet 4.6 sub-agents. The rubric explicitly calls for human judgement. The strongest mitigation applied: fresh-context judges with no access to per-role files, manifests, or task briefs — only the synthesis and the rubric. This controls for self-preference bias on the production path but not for general LLM-judge biases (surface-feature anchoring, citation-as-quality conflation, generic over-grading).

2. **Same-model class for runs and judges.** Both phases ran on Sonnet 4.6. Cross-model judging (e.g., Sonnet runs judged by Opus, or vice versa) is a stronger eval methodology that wasn't applied here. A future v1.1 eval pass should use a cross-model judge.

3. **Synthetic artifacts.** All 20 artifacts were generated by the same model that then critiqued them, even though the model never saw the artifacts during the eval phase. This is more circular than evals on real-world artifacts would be. The seeded-issues design ensures each task has known failure modes the methodology should catch — but real artifacts have failure modes nobody seeded, and the methodology's performance on those is not measured here.

4. **n=20 is the target floor, not a confident threshold.** The pilot mean (n=5) was 0.913; the full campaign mean (n=20) is 0.903. Both above 0.8. But the 95% CI on a binary "above 0.8" claim with n=20 and mean 0.903 is wide. Bootstrap re-sampling would give a more honest read on confidence; not done here.

**For genuine v1 confidence:** a human (the methodology author or an independent reviewer) should re-score at least 5 of the 20 syntheses independently, without seeing the LLM scores. If the human re-score is within ±0.1 of the LLM score on each, the LLM-judge signal is plausible and 0.903 is defensible. If they diverge further, the LLM-judged 0.903 should be treated as a baseline estimate and a stronger eval methodology should be invested in before v1.

## What this campaign proved

Within the methodology caveats above:

- **The Hornero methodology produces consistently high-quality multi-role synthesis** — mean 0.903 across 20 representative cross-functional artifacts spanning all 7 roles, 2/3/4/5 role mixes, and three orchestration shapes (plain `multi-role-review`, PM-led, tester-led).
- **Workflow-composition syntheses need explicit citation carry-forward discipline** in their orchestrating skill. Task 04 (PM-orch v0) caught this; the fix worked; task 15 (tester-orch) shows the lesson generalises.
- **Conflict surfacing is the next-most-tractable improvement** — the methodology honestly states "no conflicts" when none exist, but could probe latent trade-offs more aggressively.
- **Actionability is at ceiling.** Owners + deliverables + dates are consistently present.

## What this campaign did NOT prove

- **That synthesis is correct in the world.** The rubric measures synthesis *quality* (citations, distinctness, conflict, actionability), not synthesis *correctness*. A synthesis can cite Kohavi correctly while reaching the wrong conclusion. Correctness is a separate, more expensive check.
- **That Hornero performs the same on real artifacts.** Synthetic artifacts with seeded issues are easier to surface findings on than real-world artifacts with unknown failure modes.
- **That decisions made on Hornero synthesis lead to better outcomes.** Decision-quality vs. outcome-quality (Doshi) — measured here is the former; the latter requires multi-month longitudinal evidence.

## Recommended follow-ups (post-v1, not blockers)

1. **Propagate the citation-carry-forward fix** to `pre-release-test-pass` and the four `pre-launch-*` workflow skills. One PR; should lift the workflow-composition cohort from 0.833 toward 0.9.
2. **Tighten the conflict-surfacing discipline** in `multi-role-review` SKILL.md — add a "latent trade-off" probe.
3. **Run a cross-model judge pass** — re-judge these 20 syntheses with Opus and compare against the Sonnet judge scores. If the two correlate strongly (Pearson r > 0.8), the Sonnet-judge signal is calibrated; if not, expand the judge ensemble.
4. **Run a human spot-check** on 5 of the 20 syntheses (recommended: 04, 07, 15, 17, plus one randomly chosen) and compare to LLM scores. The pilot report named this as the v1 confidence step.
5. **Eval extension to real artifacts** — when a real PR or PRD goes through Hornero in production, score the synthesis with the same rubric. Real-artifact scores are the true validator.

## File layout

```
evals/
  EVAL-REPORT.md             # this file
  rubric.md                  # the 4-dimension scoring rubric
  score.sh                   # aggregator (jq-based, robust to nested JSON)
  README.md                  # eval methodology and task suite overview
  tasks/                     # 20 task briefs (each is a one-page description)
  runs/<task-slug>/          # per-task run outputs (workspace-only per .gitignore)
    artifact.md              # generated synthetic artifact
    <role>.md                # per-role review (one per role in mix)
    synthesis.md             # the synthesis (the artifact judged)
    manifest.json            # run metadata
    score.json               # judge's 4-dimension scores + rationales + mean
```

The 20 per-task run outputs are workspace-only by design (the README documents this — runs are workspace-specific, regenerable, large). The score.json files are also workspace-only; this report aggregates them. To force-commit any run for inspection: `git add -f evals/runs/<slug>/synthesis.md evals/runs/<slug>/score.json`.

## Sub-agent prompts (for reproducibility)

The 20 run-phase and 20 judge-phase sub-agent prompts used in this campaign are recorded in the commit messages of PR #14 (pilot tasks 01, 04, 12, 14, 17) and PR #15 (this PR — task 04-v2 + the remaining 15 tasks). Each prompt is self-contained and uses Claude Sonnet 4.6.

To re-run a specific task: dispatch a fresh Sonnet sub-agent with the matching prompt template (substitute the task slug). The methodology is deterministic given the same task brief, the same role files, and the same model — the seed for stochastic variation is the sub-agent's own context.
