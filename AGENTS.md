# AGENTS.md — Hornero

> Read at the start of every Codex session inside the Hornero repo. This file
> is the **Codex-side dispatcher protocol**. Its sibling, [`CLAUDE.md`](CLAUDE.md),
> ships the same protocol for Claude Code. Keep them in sync — when you edit
> one, edit the other.
>
> If you are working in a project that *uses* Hornero rather than this repo
> itself, copy [`templates/AGENTS.md.template`](templates/AGENTS.md.template)
> (or the dispatcher section of this file) into your project's `AGENTS.md`.

## The dispatcher protocol

Hornero ships seven roles, several cross-role skills, and a small set of slash
commands. The user should not need to memorise which one to invoke. When a
prompt arrives:

### 1. Scan the catalog first

Read [`CATALOG.md`](CATALOG.md). It is a one-line-per-entry index of every
shipped role and skill. Do not load full `ROLE.md` or `SKILL.md` files at this
step — the catalog is designed so you don't have to.

### 2. Match the prompt against the catalog

In rough order of authority:

- **Slash commands win** if the user typed one. The available commands are
  defined in [`.claude/commands/`](.claude/commands/) — read the matching file
  and follow it. (Codex picks up these same command files; if your Codex
  install loads commands from a different directory, mirror the files there
  or invoke them by reading the file content directly.)
- **Explicit naming wins.** If the user names a role ("as the security
  expert…") or a skill ("draft an ADR for…", "run the design-review skill"),
  use it. No further matching.
- **Verb + artifact shape.** "Review X" → reviewer mode of the role whose
  artifacts include X. "Produce / draft / write X" → producer mode + the
  component skill that makes X. "Audit before launch" → the relevant
  `pre-launch-*` workflow skill.
- **Triggers in `ROLE.md`** and **`scenarios:` in `SKILL.md` frontmatter**
  describe real invocation contexts. Match against those, not against your
  prior intuitions about role boundaries.

### 3. Declare the choice in one line

Before reading the full files or doing the work, state which role and skill
you are adopting, and why — in a single line:

```
Adopting `tester` / `regression-test` — prompt names a shipped bug, so a
reproducing failing test is the artifact.
```

This is the user's correction point. They can redirect with one word
("designer instead", "skip the role thing"). Honour it without argument.

### 4. Then load the full files

Only after the declaration:

- `roles/<role>/ROLE.md` — for mindset, heuristics, anti-patterns.
- `roles/<role>/skills/<skill>/SKILL.md` — for the actual procedure.
- `roles/<role>/sources.md` — only if you need a citation or to defend a
  framework choice.

Never load every skill up front. The catalog exists so you don't have to.

### 5. Multi-match → escalate, don't guess

If two or more roles' triggers fire strongly on the same prompt (e.g. "review
this payments PR" → engineer + tester + security; "plan the launch" → PM +
marketing + designer), do not pick one and silently drop the others.

- If the integrating thread is a **customer job / product decision**, route to
  [`/orchestrate`](.claude/commands/orchestrate.md) — the PM as
  cross-functional orchestrator.
- Otherwise, route to [`/review`](.claude/commands/review.md) — direct
  multi-role-review without PM framing. The skill is at
  [`skills/multi-role-review/SKILL.md`](skills/multi-role-review/SKILL.md).

### 6. No-match → ask, don't fabricate

If nothing in the catalog matches well, say so:

```
The catalog doesn't have a strong match for this. Closest are `<a>` and
`<b>`. Want me to use one of those, or just answer directly?
```

Do not invent a role or skill name that isn't in `CATALOG.md`. Do not pretend
a forward-reference skill (one named in `ROLE.md` but not yet shipped) is
available.

## Subagents in Codex

Claude Code has a first-class `Agent` tool that spawns reviewer subagents from
[`agents/<role>-reviewer.md`](agents/) by name. Codex does not have the
equivalent primitive at parity. Two workable paths:

- **Sequential simulation.** For each role in the chosen mix, read its
  reviewer file, produce that role's findings in an isolated section, then
  move to the next. Loses parallelism; preserves the role's framing and
  output discipline.
- **Manual parallelism.** Open multiple Codex sessions (one per role), brief
  each with the reviewer file content + the artifact, then synthesise their
  outputs by hand.

When parallel dispatch is structurally required (e.g. four pre-launch
audits), the sequential path still produces a correct synthesis — it just
takes longer. The reviewer files in [`agents/`](agents/) are self-contained
system prompts; they work whether you spawn them as subagents or paste them
as context.

## When the dispatcher does NOT apply

- The user is editing a specific file and wants direct help, not structured
  critique. Default to a plain answer. Mention "we have a `<skill>` skill if
  you want the structured pass" only if it genuinely matches.
- The user explicitly disables dispatch ("just answer", "don't adopt a role",
  "skip the methodology"). Honour it for the rest of the session unless they
  re-enable.
- Trivial edits (typos, renames, formatting) — no role adoption needed.

## Loading hierarchy (cheat sheet)

| File | Always loaded? | When |
|---|---|---|
| `AGENTS.md` (this file) | Yes | Session start |
| `CATALOG.md` | Yes | First dispatch scan per prompt |
| `.claude/commands/<name>.md` | No | When the user types `/<name>` |
| `roles/<role>/ROLE.md` | No | After role is chosen |
| `roles/<role>/skills/<skill>/SKILL.md` | No | After skill is chosen |
| `roles/<role>/sources.md` | No | Only if a citation is needed |
| `methodology.md` | No | Only if the user asks about Hornero itself |

## Slash commands (quick reference)

| Command | What it does |
|---|---|
| `/orchestrate <task>` | PM as cross-functional orchestrator (frame as customer job → pick role mix → dispatch → synthesise decision). **Marquee command** for launches and cross-functional decisions. |
| `/review <target>` | Direct multi-role-review without PM framing. Any role mix. |
| `/role <name> <task>` | Single named role for a focused critique or artifact. |
| `/kickoff` | New-user walkthrough — first useful dispatch in <5 min. |
| `/catalog` | Show what Hornero ships (roles, skills, commands). |
| `/extract-lesson` | End-of-session: capture surprises as deltas to roles/skills/CLAUDE.md/AGENTS.md. |

Command files live in [`.claude/commands/`](.claude/commands/). They are the
source of truth — if your Codex install reads commands from a different
directory, mirror the files or read them on demand.

## Regenerating the catalog

`scripts/catalog.sh` rebuilds `CATALOG.md` from frontmatter. Run it after:

- Adding, renaming, or removing a role or skill.
- Editing a `description:` field (the dispatcher matches against those).
- Promoting a forward-reference skill to shipped.

```sh
./scripts/catalog.sh
```

The committed `CATALOG.md` is the source of truth for downstream consumers,
so don't forget to commit the regen.

## Project conventions (for working ON Hornero)

- **Skill anatomy** is enforced by `scripts/validate-skill.sh` — YAML
  frontmatter (name, description, type) plus six sections (Purpose, Key
  Concepts, Application, Examples, Common Pitfalls, References). Run it on
  any new or edited SKILL.md before committing.
- **Sources discipline** — every framework named in a Key Concepts section
  must trace to a name in the role's `sources.md`. Cap each role at ~10
  anchors; demote when adding.
- **TDD** for any code change (scripts, validators): failing test first,
  minimum code to green, refactor with tests green throughout.
- **Feature branches** — never commit to `main`. One concern per branch.

## Quick reference — what to do when

| User says | Dispatcher does |
|---|---|
| `/orchestrate plan the launch` | Adopt PM + `cross-functional-orchestration`; frame as customer job; dispatch role mix; synthesise. |
| `/review this PR` | Adopt `multi-role-review`; pick role mix from artifact; parallel dispatch; synthesise. |
| `/role tester write a regression test` | Spawn (or simulate) `tester-reviewer`; the artifact is a failing test. |
| "Review my last commit" | Score against engineer / tester / security / designer triggers; if one wins, adopt it; if multiple win, escalate per step 5. |
| "Draft a PRD for X" | Adopt `product-manager` / `prd`. |
| "Plan the launch" | Score PM, marketing, designer; usually escalates to `/orchestrate`. |
| "Is this safe to ship?" | Adopt the matching `pre-launch-*` workflow (or `/orchestrate` for cross-cutting releases). |
| "Help me write this function" | Default to a direct answer. The dispatcher doesn't fire for tactical implementation help unless TDD is explicitly invoked. |
