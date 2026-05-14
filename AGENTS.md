# AGENTS.md — Hornero (Codex entry-point)

> Session-start file for Codex. The host-agnostic dispatcher protocol lives
> in [`DISPATCHER.md`](DISPATCHER.md) — read it on the first dispatch in any
> session. Its Claude sibling is [`CLAUDE.md`](CLAUDE.md); changes to the
> dispatcher belong in `DISPATCHER.md` and never need to be mirrored.
>
> If you are working in a project that *uses* Hornero rather than this repo
> itself, copy [`templates/AGENTS.md.template`](templates/AGENTS.md.template)
> into your project's `AGENTS.md`.

## Each session

1. Always have [`CATALOG.md`](CATALOG.md) available.
2. Follow the dispatcher in [`DISPATCHER.md`](DISPATCHER.md) — that's the
   protocol for picking a role/skill, declaring the choice, loading files,
   escalating multi-matches, and refusing no-matches.
3. For multi-role dispatch (Step 5 of the dispatcher), fan reviewer
   subagents out per the Codex-specific guidance below.

## Subagents in Codex

Claude Code has a first-class `Agent` tool that spawns reviewer subagents
from [`agents/<role>-reviewer.md`](agents/) by name. Codex CLI does not
expose an equivalent primitive, but its non-interactive `codex exec` mode is
close enough to fan reviewers out as subprocesses. Hornero ships a small
wrapper that does exactly this — pick the path that matches your context.

### Preferred — `scripts/codex-parallel-review.sh`

The script fans out one `codex exec` per role, each briefed with the
reviewer file + the artifact, run in parallel, with per-role outputs
collected for synthesis. This is the Codex-side equivalent of Claude's
parallel-Agent dispatch.

```sh
# Default mix (engineer + tester + security) on a PR diff:
./scripts/codex-parallel-review.sh tmp/pr-1247.diff

# Full sweep across all 7 reviewers:
./scripts/codex-parallel-review.sh tmp/launch-plan.md \
  product-manager designer software-engineer tester security-expert \
  marketing-expert data-scientist

# See what would run without invoking codex:
./scripts/codex-parallel-review.sh --dry-run tmp/pr-1247.diff tester security-expert
```

Each invocation runs with `--ephemeral` (no rollout state between roles),
`--sandbox read-only` (reviewers cannot write to the workspace), and
`--skip-git-repo-check` (artifacts may live outside a git repo). Outputs
land in `tmp/codex-reviews/<role>-review-<ts>.md` plus a per-run
`INDEX-<ts>.md`. Synthesis is left to the orchestrator — read the per-role
reviews and produce the cross-cutting recommendation.

**Constraints** (read before running large fan-outs):

- All subprocesses share the same OpenAI auth and rate-limit bucket.
  Heavy parallelism will hit standard API rate limits — 7-role sweeps on
  long artifacts may need pacing.
- Each subprocess is genuinely isolated (`--ephemeral`); no cross-reviewer
  context leakage.
- The artifact must be a single readable file. For diffs, pre-render with
  `git diff <base>..HEAD > tmp/pr.diff` and pass the file.

### Sequential simulation

For each role in the chosen mix, read its reviewer file, produce that
role's findings in an isolated section, then move to the next. Loses
parallelism; preserves the role's framing and output discipline. Useful
when `codex exec` isn't available (older Codex install, no API key in
scope, network-restricted environment).

### Manual parallelism

Open multiple Codex sessions (one per role), brief each with the reviewer
file content + the artifact, then synthesise their outputs by hand. Useful
for interactive exploration where you want to ask follow-up questions per
reviewer.

The reviewer files in [`agents/`](agents/) are self-contained system
prompts; they work whether you spawn them via the script, paste them into
a Codex session, or simulate sequentially.

## Contributor info

Skill anatomy, sources discipline, catalog regeneration, TDD, branch hygiene
→ see [`CONTRIBUTING.md`](CONTRIBUTING.md).
