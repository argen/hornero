# CLAUDE.md — Hornero (Claude Code entry-point)

> Session-start file for Claude Code. The host-agnostic dispatcher protocol
> lives in [`DISPATCHER.md`](DISPATCHER.md) — read it on the first dispatch
> in any session. Its Codex sibling is [`AGENTS.md`](AGENTS.md); changes to
> the dispatcher belong in `DISPATCHER.md` and never need to be mirrored.
>
> If you are working in a project that *uses* Hornero rather than this repo
> itself, copy [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template)
> into your project's `CLAUDE.md`.

## Each session

1. Always have [`CATALOG.md`](CATALOG.md) available.
2. Follow the dispatcher in [`DISPATCHER.md`](DISPATCHER.md) — that's the
   protocol for picking a role/skill, declaring the choice, loading files,
   escalating multi-matches, and refusing no-matches.
3. For multi-role dispatch (Step 5 of the dispatcher), spawn reviewer
   subagents per the Claude-specific guidance below.

## Spawning reviewer subagents under Claude Code

Claude Code exposes a first-class `Agent` tool. Reviewer subagents are
defined in [`agents/<role>-reviewer.md`](agents/) and are callable by name
via the Agent tool's `subagent_type`.

Hornero currently ships **one** reviewer subagent:

- `product-manager-reviewer`

The multi-role dispatcher mechanics below are preserved for re-expansion;
today every "fan out" step resolves to a single PM call.

**Always spawn in parallel** when the chosen dispatcher path is multi-role —
one message, multiple Agent tool calls. Synthesise the per-agent reports in
the orchestrator turn yourself; do not chain reviewers sequentially unless
one role's output is genuine input to another.

Max 7 role subagents per invocation. No nested spawning. Synthesis within
one turn of the last finding.

## Contributor info

Skill anatomy, sources discipline, catalog regeneration, TDD, branch hygiene
→ see [`CONTRIBUTING.md`](CONTRIBUTING.md).
