# Evals — orchestrated review quality measurement

A repeatable way to measure whether Hornero's orchestrated review (the PM orchestrator fanning out to reviewers) is producing useful output, not just plausible output.

> **Status:** scaffold complete. Rubric, scoring script, and the full **20-task suite** are shipped. Running the campaign is the remaining work — needs human-judgement scoring on the four rubric dimensions per [`rubric.md`](rubric.md). Hornero ships one role today (`product-manager`); the 20 tasks were designed for a multi-role future (2-role through 5-role mixes, a tester-orchestrated workflow path, three threat-model shapes) and currently exercise the PM orchestrator path, which covers unshipped roles itself rather than spawning their reviewers.

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

Two scoring paths — human and LLM judge — complement each other:

- **Human** (`score_human.json`) — the authority. Slow but calibrated.
- **LLM judge** (`score_llm.json`) — throughput tool. Fast but may be systematically biased on specific dimensions.
- **Aggregate** shows both side-by-side and flags runs where `|human − llm| ≥ 0.25` for human review.

The LLM judge is **provider-agnostic** — Anthropic, OpenAI, or Gemini. Each provider's SDK is lazy-imported, so you only install the one you'll use. The `judge_provider` and `judge_model` fields in `score_llm.json` record which model produced each score, so you can compare providers and detect provider-specific bias.

| Provider | Default model | API key env | Install |
|---|---|---|---|
| `anthropic` (default) | `claude-sonnet-5-5` | `ANTHROPIC_API_KEY` | `pip install anthropic` |
| `openai` | `gpt-5` (unverified; confirm the current OpenAI id) | `OPENAI_API_KEY` | `pip install openai` |
| `gemini` | `gemini-2.5-pro` | `GEMINI_API_KEY` | `pip install google-genai` |

Override the default provider with `--provider` (or `EVAL_JUDGE_PROVIDER` env var); override the model with `--model` (or `EVAL_JUDGE_MODEL` env var).

### Recommended workflow

1. **Run** `multi-role-review` against the task artifact. Capture synthesis to `evals/runs/<task-slug>/synthesis.md`.
2. **LLM-judge all tasks first** (fast, no human time required):
   ```bash
   for dir in evals/runs/*/; do ./evals/score.sh --judge "$dir"; done

   # Or with a non-default provider:
   for dir in evals/runs/*/; do ./evals/score.sh --judge "$dir" --provider openai; done
   ```
3. **Aggregate** to surface which runs have high human-LLM delta:
   ```bash
   ./evals/score.sh --aggregate
   ```
4. **Human-score the flagged runs** (those with `← review` in the aggregate output):
   ```bash
   ./evals/score.sh evals/runs/<flagged-task-slug>
   ```
5. **Re-aggregate** — human scores take precedence over LLM scores in the mean.

### Cross-provider judging (advanced)

Running the judge across two or more providers on the same runs is a useful precision technique: if Anthropic and OpenAI both score a run at 0.5 while Gemini scores it at 1.0, the provider is the variable and the human score breaks the tie. Each provider's score overwrites the previous `score_llm.json` for that run, so capture cross-provider runs to separate files or different run directories if you want to compare them.

### Score file locations

| File | Written by | Meaning |
|---|---|---|
| `score_human.json` | `score.sh <run-dir>` (interactive) | Human-judged score; authoritative |
| `score_llm.json` | `score.sh --judge <run-dir>` or `judge.py <run-dir>` | LLM-judged score; records `judge_provider` + `judge_model` |
| `score.json` | Legacy (old `score.sh`) | Read as human score for backward compatibility |

### Pre-registration discipline (per the data-scientist role's discipline)

- Score immediately after the run, before reading other runs' scores.
- Don't re-score a run after seeing the aggregate mean.
- A failing dimension is informative — don't round up because the run "felt good."

### LLM judge calibration

**Calibration target:** mean `|human − LLM|` delta < 0.1 across calibration runs.

If the delta is consistently > 0.1 on a specific dimension:
1. Re-read the rubric for that dimension
2. Add a concrete one-sentence example for the 0.25 and 0.75 levels (the boundary cases where LLMs tend to drift)
3. Re-judge a few runs with the updated prompt and compare again

Document systematic offsets below. Recalibrate quarterly or after any rubric change.

**Current calibration notes:** *(no runs scored yet — populate after first campaign)*

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

# LLM-judge first (fast)
./evals/score.sh --judge evals/runs/<task-slug>

# Human score if flagged (|delta| >= 0.25 in aggregate report)
./evals/score.sh evals/runs/<task-slug>

# See the running mean
./evals/score.sh --aggregate
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
