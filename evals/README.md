# Evals

Hornero's eval suite runs under `claude plugin eval`. It loads the repo as a plugin and runs each case in an empty workspace, so only skill names and descriptions are in context. `CLAUDE.md` and `DISPATCHER.md` are not. That is the realistic test: do the descriptions route correctly, and does the skill that fires produce a useful PM critique.

## What it measures

| Kind | Cases | Graded on |
|---|---|---|
| Routing (`tags: [routing]`) | `cases/route-*`, one per natural-language row in [`tests/dispatcher/routes.tsv`](../tests/dispatcher/routes.tsv) | `tool_used: Skill` matches the expected skill. Ambiguous prompts (`route-escalate*`) must draw a question and invoke no skill. |
| Artifact (`tags: [artifact]`) | `cases/prd-*`, `launch-plan-ledgerstack`, `positioning-*`, `metric-definition-activation`, `strategic-narrative-startup` | The expected skill fired, plus an `llm` grader (`quality.md`) with PASS/FAIL conditions from [`rubric.md`](rubric.md): named sources, distinct findings, a stated trade-off, actionable next steps. The launch-plan case also checks that `product-manager-reviewer` was dispatched. |

The routing cases and `routes.tsv` stay in step: `scripts/validate-dispatcher.sh` (Check 4, also run by smoke-check) fails when a natural-language row has no `evals/cases/route-*` directory or a case is orphaned. Slash-command rows are static-checked only.

## Layout

```
evals/
  cases/<name>/prompt.md          prompt body plus frontmatter (runs, max_turns, allowed_tools, tags)
  cases/<name>/graders/<g>.md     one file per grader
  rubric.md                       source for the llm graders
  EVAL-REPORT.md                  historical, predates this suite
  results/                        written by each run, gitignored
```

## Run locally

Requires Claude Code 2.1.311 or later and an authenticated session (or `ANTHROPIC_API_KEY`).

```bash
# cheap pass: with-plugin arm only, one run per case, one case family
claude plugin eval . --trust-plugin --ablation none --runs 1 --max-cost-usd 3 --case 'route-prd*'

# all routing cases, one run each
claude plugin eval . --trust-plugin --ablation none --runs 1 --tag routing --max-cost-usd 5

# full two-arm run (with plugin and bare baseline) at each case's own run count
claude plugin eval . --trust-plugin --json results.json --threshold 0.8
```

Useful flags: `--model`, `--judge-model`, `--no-publish` (skip the claude.ai report upload), `--json <path>`. Exit codes: 0 pass, 1 below `--threshold` or load error, 2 partial (cost ceiling hit).

Under the default two-arm mode, `tool_used: Skill` graders count as a plugin-fired indicator and are left out of the score. Use `--ablation none` when you want them scored.

Cost: a routing case is a few turns on a small prompt (cents). An artifact case runs 2 times for up to 12 turns plus three judge votes (tens of cents each, more for the launch plan). The full two-arm suite is the expensive path; budget a few USD with `--ablation none`, roughly double with the baseline arm.

## Add a case

1. `claude plugin eval init --bare <name>` or copy an existing directory under `cases/`.
2. Put the whole prompt, artifact included, in `prompt.md`; each run starts empty. Artifact-intake routing prompts ("critique this PRD") carry the artifact inline for the same reason: an empty workspace gives the model nothing to read, so it asks for the file instead of invoking the skill.
3. Add `graders/skill-fired.md` (`tool_used` with an `input_match` on the skill name) and, for artifacts, a `quality.md` with concrete PASS/FAIL conditions.
4. For a routing case, add the row to `tests/dispatcher/routes.tsv` and name the directory `route-<skill>` (`-2`, `-3` for repeats of the same skill). Run `./scripts/validate-dispatcher.sh`.

## CI

[`.github/workflows/evals.yml`](../.github/workflows/evals.yml) runs the suite on `workflow_dispatch` and weekly (Monday 06:00 UTC), with `--ablation none`, `--threshold 0.8` and a 10 USD ceiling, and uploads `results.json` and `evals/results/` as artifacts. It needs an `ANTHROPIC_API_KEY` repository secret (Settings, Secrets and variables, Actions). The main `ci.yml` never runs evals.
