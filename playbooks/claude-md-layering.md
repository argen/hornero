# CLAUDE.md layering — root + subdirectories

Claude Code loads `CLAUDE.md` files **additively**, walking up the directory tree from the current working directory to the repo root. Every level's file stacks onto the next. This is the blog-recommended pattern for large codebases — one root file for big-picture context, smaller files in subdirectories for local conventions.

Most Hornero adopters ship only a root `CLAUDE.md` and that's correct for single-package repos. The moment you have a monorepo, multi-service repo, or a single repo with meaningfully different conventions per directory (e.g. a `frontend/` and `backend/` with different test runners), add subdirectory files.

Source: Anthropic, ["How Claude Code Works in Large Codebases"](https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start) — "initialize in subdirectories, not repo root" is one of their two top navigability recommendations.

## When to add a sub-CLAUDE.md

Add one when the module has at least one of:

- A different **test or lint command** than the rest of the repo
- A different **language / runtime** than the root (e.g. Rust service inside a TS monorepo)
- A **public API surface** other modules depend on (worth documenting what's exported)
- **Domain quirks** that would crowd the root file if hoisted there (incident-driven gotchas)
- A different **owner team** with their own conventions

Don't add one for cosmetics. If the root file already covers a module adequately, leave it.

## What belongs in root vs. sub

**Root `CLAUDE.md` carries:**
- Project purpose, model selection, branch hygiene, commit policy
- Dispatcher pointer (`DISPATCHER.md` if Hornero is wired in)
- Subagent spawning conventions
- Stack-spanning reminders (anything that applies repo-wide)

**Sub-CLAUDE.md carries:**
- Only what **differs** from root
- Test/lint/dev commands scoped to that directory
- Local conventions and domain glossary
- Incident-driven gotchas specific to this module

Rule of thumb: if a line in your sub-file applies repo-wide, it belongs in root. If a line in root applies only to one module, it belongs in that module's sub-file.

## How the additive load works in practice

If you run `claude` inside `repo/frontend/`, Claude Code loads (in order):
1. `repo/CLAUDE.md` (root big-picture)
2. `repo/frontend/CLAUDE.md` (frontend-specific)

Sub-file additions extend root context; they don't replace it. So a sub-file can omit anything root already covers — repeating it is noise, not safety. Conflicts (sub says one thing, root says another) are resolved by the **deepest** file winning for its scope, but write sub-files to *override specific keys* (test command, lint command) rather than to wholesale contradict root.

## Scaffolding a sub-CLAUDE.md

Copy [`<path-to-hornero>/templates/sub-CLAUDE.md.template`](../templates/sub-CLAUDE.md.template) into the module directory. The template is intentionally slim (≤60 lines) — fill in the local commands, conventions, and reminders; delete sections that don't apply.

## Skill: when to invoke `harness-check`

When you add a second or third sub-CLAUDE.md, run the [`harness-check`](../skills/harness-check) skill against the repo. It catches drift between root and sub files, redundant lines, and missing-but-implied scoping (e.g. a sub-file that names a test command without scoping it to the module).

## Anti-patterns

### Sub-CLAUDE.md as a copy of root with one line different
**Symptom:** The sub-file repeats 80% of root's content.
**Fix:** Delete the repeated content. Sub-files only override what differs.

### Putting reusable expertise in a sub-CLAUDE.md
**Symptom:** A sub-CLAUDE.md teaches "how to write a good API endpoint" — six paragraphs of pattern guidance.
**Fix:** That belongs in a skill, not a CLAUDE.md. CLAUDE.md is for *standing instructions*; skills are for *reusable expertise*.

### Every directory gets a CLAUDE.md
**Symptom:** Sub-files at every level, most adding no real signal.
**Fix:** Only add a sub-file when a module genuinely diverges from root. Empty or near-empty sub-files are noise.

### Root carries module-specific commands
**Symptom:** Root CLAUDE.md lists `cd backend && pytest` as the test command.
**Fix:** Move scoped commands into the relevant sub-file. Root stays repo-wide.

## Maintenance cadence

Re-read every sub-CLAUDE.md every 3-6 months and retire compensatory lines once they're no longer load-bearing. The blog's specific guidance: "rules optimized for older models may constrain newer ones."
