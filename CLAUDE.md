# CLAUDE.md — Hornero

> Read at the start of every session inside the Hornero repo. This file is
> also the canonical reference for the **role-and-skill dispatcher protocol**
> that downstream projects adopt via [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template).
>
> If you are working in a project that *uses* Hornero rather than this repo
> itself, copy the dispatcher section into your project's `CLAUDE.md`.

## The dispatcher protocol

Hornero ships seven roles and several cross-role skills. Users should not
need to memorise which one to invoke. When a prompt arrives:

### 1. Scan the catalog first

Read [`CATALOG.md`](CATALOG.md) at the repo root. It is a one-line-per-entry
index of every shipped role and skill. Do not load full ROLE.md or SKILL.md
files at this step — the catalog is designed so you don't have to.

### 2. Match the prompt against the catalog

In rough order of authority:

- **Explicit naming wins.** If the user names a role ("as the security
  expert…") or a skill ("draft an ADR for…", "run the design-review skill"),
  use it. No further matching.
- **Verb + artifact shape.** "Review X" → reviewer mode of the role whose
  artifacts include X. "Produce / draft / write X" → producer mode + the
  component skill that makes X. "Audit before launch" → the relevant
  `pre-launch-*` workflow skill.
- **Triggers in ROLE.md** and **`scenarios:` in SKILL.md frontmatter**
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

- `roles/<role>/ROLE.md` — for mindset, heuristics, anti-patterns
- `roles/<role>/skills/<skill>/SKILL.md` — for the actual procedure
- `roles/<role>/sources.md` — only if you need a citation or to defend a
  framework choice

Never load every skill up front. The catalog exists so you don't have to.

### 5. Multi-match → escalate, don't guess

If two or more roles' triggers fire strongly on the same prompt (e.g. "review
this payments PR" → engineer + tester + security; "plan the launch" → PM +
marketing + designer), do not pick one and silently drop the others.
Adopt [`skills/multi-role-review`](skills/multi-role-review/SKILL.md) and
spawn role subagents per its workflow. Synthesise their findings yourself.

### 6. No-match → ask, don't fabricate

If nothing in the catalog matches well, say so:

```
The catalog doesn't have a strong match for this. Closest are `<a>` and
`<b>`. Want me to use one of those, or just answer directly?
```

Do not invent a role or skill name that isn't in `CATALOG.md`. Do not
pretend a forward-reference skill (one named in `ROLE.md` but not yet
shipped) is available.

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
| `CLAUDE.md` (this file) | Yes | Session start |
| `CATALOG.md` | Yes | First dispatch scan per prompt |
| `roles/<role>/ROLE.md` | No | After role is chosen |
| `roles/<role>/skills/<skill>/SKILL.md` | No | After skill is chosen |
| `roles/<role>/sources.md` | No | Only if a citation is needed |
| `methodology.md` | No | Only if the user asks about Hornero itself |

## Regenerating the catalog

`scripts/catalog.sh` rebuilds `CATALOG.md` from frontmatter. Run it after:

- Adding, renaming, or removing a role or skill
- Editing a `description:` field (the dispatcher matches against those)
- Promoting a forward-reference skill to shipped

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
| "Review my last commit" | Score against engineer / tester / security / designer triggers; if one wins, adopt it; if multiple win, escalate to `multi-role-review`. |
| "Draft a PRD for X" | Adopt `product-manager` / `prd`. |
| "Write a failing test for BUG-1247" | Adopt `tester` / `regression-test`. |
| "Plan the launch" | Score PM, marketing, designer; usually escalates to `multi-role-review`. |
| "Is this safe to ship?" | Adopt the matching `pre-launch-*` workflow (or `multi-role-review` for cross-cutting releases). |
| "Help me write this function" | Default to a direct answer. The dispatcher doesn't fire for tactical implementation help unless TDD is explicitly invoked. |
