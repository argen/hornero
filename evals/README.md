# Evals — multi-role-review quality measurement

A repeatable way to measure whether `multi-role-review` is producing useful output, not just plausible output.

> **Status:** scaffold complete (v0.7). Rubric, scoring script, and the full **20-task suite** are shipped. Running the campaign is the remaining work — needs human-judgement scoring on the four rubric dimensions per [`rubric.md`](rubric.md). The 20 tasks deliberately span all 7 roles, the 2-role through 5-role mixes, the PM-orchestrator path (task 04) and the tester-orchestrated workflow path (task 15), and the three threat-model shapes (LLM-feature, third-party integration, multi-region architecture).

## Why this exists

The Roadmap (plan §Verification) sets a target: **≥0.8 mean score across 20 representative tasks** before declaring v1. Without an eval harness, multi-role-review's quality is asserted from anecdote rather than evidence. The eval converts the assertion into a measurement.

## What gets scored

Four dimensions, each scored 0-1 by a human judge against the rubric in [`rubric.md`](rubric.md):

| Dimension | What it measures |
|---|---|
| **Source-citation rate** | What fraction of findings cite a named source from a role's `sources.md`? |
| **Finding distinctness** | Do the roles surface non-overlapping findings, or does each role return the same things wearing different hats? |
| **Conflict surfacing** | Does the synthesis name explicit conflicts between roles? Are they conflicts worth naming? |
| **Actionability** | Could a reader of the synthesis act on it without going back to the role-level artifacts? |

Each dimension scored 0 / 0.25 / 0.5 / 0.75 / 1.0 per the rubric. A run's score is the mean of the four. **Target: mean ≥ 0.8 across 20 tasks.**

## Method

Per task:

1. **Run** `multi-role-review` against the task artifact (PR diff / RFC / spec / launch plan). Specify role count, roles, and any orchestrator (PM-orchestrator vs. generic).
2. **Capture** the synthesis output to `evals/runs/<task-slug>/synthesis.md` and each role's per-artifact output to `evals/runs/<task-slug>/<role>.md`.
3. **Score** with [`score.sh`](score.sh) — interactive prompt that walks the four rubric dimensions and asks for a 0-1 reading per dimension, then writes `evals/runs/<task-slug>/score.json`.
4. **Aggregate** with `score.sh --aggregate` — reads every `score.json` under `evals/runs/`, reports per-task scores and the mean.

Pre-registration discipline (per the data-scientist role's discipline):

- Score immediately after the run, before reading other runs' scores.
- Don't re-score a run after seeing the aggregate mean.
- A failing dimension is informative — don't round up because the run "felt good."

## What's in scope for the eval

| In scope | Out of scope |
|---|---|
| `multi-role-review` synthesis quality | Individual role-review quality (covered by per-skill editorial pass) |
| `cross-functional-orchestration` as a composing skill (compose-call) | The PM-side framing in isolation |
| 2-5 role mixes | 6-7 role mixes (rarely useful; only sample if testing the upper bound) |
| Concrete, plausible artifacts | Synthetic "perfect" artifacts — they tell us nothing about real-world performance |

## What "≥0.8 mean" really tells us

The 0.8 target is calibrated against the four rubric dimensions described in [`rubric.md`](rubric.md). It does **not** guarantee:

- That every individual role review is high-quality (only the synthesis is scored)
- That the synthesis is correct in the world (correctness is a separate, often expensive check)
- That the recommendation would have been correct in hindsight (decision-quality vs. outcome-quality — see PM `cross-functional-orchestration`)

What it does say: across 20 representative cross-functional artifacts, the orchestration consistently produces synthesis that cites sources, surfaces distinct findings, names conflicts, and is actionable. That's the bar.

## How to run a task

Once an artifact and the role list are chosen:

```bash
# Set up the run directory
mkdir -p evals/runs/<task-slug>
cp <artifact-source> evals/runs/<task-slug>/artifact.md  # or link

# In Claude Code, ask:
# "Run multi-role-review on evals/runs/<task-slug>/artifact.md.
#  Roles: <role-1>, <role-2>, <role-3>. Save the synthesis to
#  evals/runs/<task-slug>/synthesis.md and each role's output to
#  evals/runs/<task-slug>/<role>.md."

# Then score
./evals/score.sh evals/runs/<task-slug>
```

## How to add a new task

1. Pick a representative cross-functional artifact (PR diff, RFC, PRD, launch plan, etc.) — anonymise if needed.
2. Create `evals/tasks/<task-slug>.md` describing:
   - The artifact (or where to obtain it)
   - The recommended role mix (2-5 roles, with one-line justification per)
   - What "good" looks like for *this* task (1-3 sentences — the things a real reviewer would want to see surfaced)
3. Run and score as above.

The 20 tasks under [`tasks/`](tasks/) are the v1 suite. They are not closed for additions — when a real artifact shape isn't represented (a new role-mix pattern, a different artifact type), add it. But the suite as shipped is intended to be sufficient to declare ≥0.8 across 20 runs.

### Task suite coverage (20 tasks)

| # | Slug | Shape | Roles | Notes |
|---|---|---|---|---|
| 01 | `engineer-pr-payments-migration` | Engineering PR | engineer + security + tester | webhook migration |
| 02 | `prd-cohort-duplicate` | PRD critique | PM + DS + engineer | |
| 03 | `rfc-cache-invalidation` | RFC | engineer + security + PM | |
| 04 | `launch-plan-ledgerstack` | Launch readiness | PM-orchestrator (4 siblings) | exercises `cross-functional-orchestration` |
| 05 | `threat-model-llm-feature` | Threat model | security + engineer | LLM-specific |
| 06 | `dashboard-redesign-spec` | Dashboard redesign | designer + PM + DS | |
| 07 | `experiment-readout-pricing` | A/B readout | DS + PM | post-run |
| 08 | `positioning-canvas-draft` | Positioning canvas | marketing + PM | early-stage SaaS |
| 09 | `test-plan-checkout-cart` | Test plan critique | tester + engineer + PM | HTSM gaps seeded |
| 10 | `accessibility-audit-onboarding` | A11y audit | designer + tester + engineer | WCAG 2.2 |
| 11 | `refactor-plan-payment-rails` | Refactor plan | engineer + tester + security | Fowler/Metz lens |
| 12 | `metric-definition-activation` | Metric definition | DS + PM + engineer | Goodhart seeded |
| 13 | `prd-search-relevance` | PRD (solution-shaped) | PM + DS + designer | spec-the-problem test |
| 14 | `strategic-narrative-startup` | Strategic narrative | marketing + PM | Raskin 5-part |
| 15 | `pre-release-test-pass-mobile` | Pre-release workflow | tester-orchestrated (4 inputs) | exercises `pre-release-test-pass` |
| 16 | `causal-claim-retention` | Causal claim | DS + PM | observational vs experiment |
| 17 | `rfc-multi-region-architecture` | RFC (upper-bound mix) | engineer + PM + security + DS + tester | 5-role |
| 18 | `positioning-statement-platform-pivot` | Positioning statement | PM + marketing | Moore template + Dunford |
| 19 | `experiment-design-pricing` | Experiment design | DS + PM + engineer | Kohavi pre-allocation |
| 20 | `threat-model-third-party-integration` | Threat model | security + engineer + PM | non-LLM, OAuth + write |

When aggregating: distinguish the **single-orchestrator cohort** (most tasks, default invocation) from the **workflow-composition cohort** (tasks 04 and 15, plus the 5-role task 17 as a separate-but-related case). Each cohort gives a different signal — workflow composition tests whether the orchestrator-of-orchestrators path works; single-orchestrator tests the base case. The v1 ≥0.8 target applies across the full 20, but the cohorts should be reported separately so any cohort-specific weakness is visible.

## Files

```
evals/
  README.md         # this file
  rubric.md         # the four dimensions with 0-1 scoring criteria
  score.sh          # interactive scoring + aggregation
  tasks/            # task descriptions (starter set of 8)
  runs/             # per-task run outputs + scores (mostly gitignored)
```

## Related Hornero skills

- [`skills/multi-role-review`](../skills/multi-role-review/SKILL.md) — the skill being evaluated.
- [`roles/product-manager/skills/cross-functional-orchestration`](../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — the PM-orchestrator composition tested in launch-shaped tasks.
- [`roles/data-scientist/skills/experiment-design`](../roles/data-scientist/skills/experiment-design/SKILL.md) — pre-registration discipline applied here.
- [`roles/data-scientist/skills/metric-definition`](../roles/data-scientist/skills/metric-definition/SKILL.md) — the rubric dimensions are themselves metrics; the same definitional discipline applies (counter-metric, owner, gaming surface).
