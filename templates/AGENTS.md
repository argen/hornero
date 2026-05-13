# AGENTS.md — <project name>

> **Template.** Drop this into the root of any new repo and tailor.
> AI agents working in this repo will read this file at the start of every
> session. Keep it tight (≤200 lines); add depth via skill files.

## What this project is

<One paragraph. What does this project do? Who is it for?>

## Stack and conventions

- **Languages:** <list>
- **Frameworks:** <list>
- **Style:** <link to a style guide, or state house rules>
- **Naming:** <repo-specific conventions>

## Local development

<Concrete commands that work on a fresh clone after `install.sh`.>

```bash
# Setup
./install.sh

# Run tests (fast subset)
<command>

# Run tests (full)
<command>

# Lint
<command>

# Type check
<command>

# Run dev server
<command>
```

If any of the above is slow or unreliable, say so explicitly — agents need to know what to trust.

## Git workflow

- Branch naming: `feat/<thing>`, `fix/<thing>`, `chore/<thing>`
- Never commit directly to `main`
- Squash on merge; delete branch after
- Never use `--no-verify`, `--force` (without explicit ask), or `reset --hard`
- See the team-wide methodology in [Hornero](https://github.com/<your-org>/hornero) `methodology.md`

## Testing discipline

<Project-specific testing rules. Default starter:>

- Every behavior change ships with a test (RED → GREEN → REFACTOR)
- Bug fixes start with a failing test that reproduces the bug
- E2E tests are reserved for critical-path slices; everything else lives lower in the pyramid
- Flaky tests are fixed, not retried

## Multi-role review

For non-trivial changes, invoke `multi-role-review` (from Hornero) before merging. Roles to consider for this project:

- <role 1> — for <when>
- <role 2> — for <when>
- <role 3> — for <when>

## What lives where

- `<dir 1>/` — <purpose>
- `<dir 2>/` — <purpose>
- `<dir 3>/` — <purpose>

## Memory and context

- Project-specific lessons live in `~/.claude/projects/<this-project>/memory/`
- Personal preferences live in `~/.claude/CLAUDE.md`, not here
- Secrets live in `.env` (gitignored); see `.env.example` for required keys

## Known traps

<Project-specific gotchas that have burned the team before. Each should be one line, specific.>

- <e.g., "CI uses a different node version than local; check `.nvmrc`">
- <e.g., "The migration script in `db/migrate.ts` is not idempotent; never re-run">

## When in doubt

1. Read the relevant skill: `~/.claude/skills/<skill>/SKILL.md`
2. Ask the user
3. Don't guess
