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

Codex CLI ships a native subagent primitive ([docs](https://developers.openai.com/codex/subagents)).
Hornero's 7 reviewer subagents are exposed to Codex via TOML files at
[`.codex/agents/`](.codex/agents/) — generated from the canonical Markdown
sources in [`agents/`](agents/) by [`scripts/build-codex-agents.sh`](scripts/build-codex-agents.sh).
Codex discovers them either project-locally (Hornero clone in cwd) or globally
after `./install.sh --codex`.

### Native path (preferred)

Spawn reviewers by name in plain English. Codex parses the request, finds the
matching `.codex/agents/<name>.toml`, and runs each subagent in parallel with
the read-only sandbox the TOML declares.

```
Review this PR. Have software-engineer-reviewer and tester-reviewer
both pass over the diff, then summarise their findings together.
```

The seven names callable this way:

- `software-engineer-reviewer`
- `product-manager-reviewer`
- `designer-reviewer`
- `tester-reviewer`
- `security-expert-reviewer`
- `marketing-expert-reviewer`
- `data-scientist-reviewer`

Codex's `agents.max_threads` default is 6; cap your fan-out accordingly or
raise the setting in `~/.codex/config.toml`.

### Legacy fallback — `scripts/codex-parallel-review.sh`

For Codex versions predating native subagents (or environments where `.codex/agents/`
discovery isn't available), the script-based fan-out still works. It spawns one
`codex exec` per role, each briefed with the reviewer file + the artifact:

```sh
# Default mix (engineer + tester + security) on a PR diff:
./scripts/codex-parallel-review.sh tmp/pr-1247.diff

# Full sweep across all 7 reviewers:
./scripts/codex-parallel-review.sh tmp/launch-plan.md \
  product-manager designer software-engineer tester security-expert \
  marketing-expert data-scientist
```

Each invocation runs with `--ephemeral`, `--sandbox read-only`, and
`--skip-git-repo-check`. Outputs land in `tmp/codex-reviews/<role>-review-<ts>.md`
plus a per-run `INDEX-<ts>.md`.

### Manual parallelism

Open multiple Codex sessions (one per role), brief each with the reviewer file
content + the artifact, then synthesise their outputs by hand. Useful for
interactive exploration with follow-up questions per reviewer.

The reviewer files in [`agents/`](agents/) and their TOML mirrors in
[`.codex/agents/`](.codex/agents/) are self-contained system prompts; they
work whether you spawn them natively, via the script, or by manual paste.

## Contributor info

Skill anatomy, sources discipline, catalog regeneration, TDD, branch hygiene
→ see [`CONTRIBUTING.md`](CONTRIBUTING.md).
