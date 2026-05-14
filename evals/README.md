# Evals — multi-role-review quality measurement

A repeatable way to measure whether `multi-role-review` is producing useful output, not just plausible output.

> **Status:** scaffold shipped (v0.5). Rubric, scoring script, and 8 starter tasks are present. Running the full 20-sample evaluation is a follow-up — needs human-judgement scoring on the four rubric dimensions.

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

The 8 starter tasks under [`tasks/`](tasks/) are seeds; expand toward 20 representative tasks before declaring v1.

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
