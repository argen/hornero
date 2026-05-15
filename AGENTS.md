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
Hornero's reviewer subagent is exposed to Codex via a TOML file at
[`.codex/agents/`](.codex/agents/) — generated from the canonical Markdown
source in [`agents/`](agents/) by [`scripts/build-codex-agents.sh`](scripts/build-codex-agents.sh).
Codex discovers it either project-locally (Hornero clone in cwd) or globally
after `./install.sh --codex`.

Hornero currently ships **one** reviewer subagent
(`product-manager-reviewer`). The fan-out / multi-thread paths below are
preserved for re-expansion; today they resolve to a single PM call.

### Native path (preferred)

Spawn the reviewer by name in plain English. Codex parses the request, finds
the matching `.codex/agents/<name>.toml`, and runs the subagent in the
read-only sandbox the TOML declares.

```
Have product-manager-reviewer pass over this PRD draft.
```

The name callable this way:

- `product-manager-reviewer`

Codex's `agents.max_threads` default is 6; the cap matters once additional
reviewers are restored.

### Legacy fallback — `scripts/codex-parallel-review.sh`

For Codex versions predating native subagents (or environments where `.codex/agents/`
discovery isn't available), the script-based fan-out still works. It spawns one
`codex exec` per role, each briefed with the reviewer file + the artifact. With
only one role shipped the fan-out is a single subprocess; the script's parallel
indexed-PIDs structure is retained so re-expansion is a one-line edit.

```sh
# Review a PRD with the only role currently shipped:
./scripts/codex-parallel-review.sh tmp/prd-search.md product-manager
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
