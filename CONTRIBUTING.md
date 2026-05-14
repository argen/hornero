# Contributing to Hornero

Guidance for working **on** the Hornero repo itself — adding roles, editing
skills, regenerating the catalog. For using Hornero in your own project, see
[`README.md`](README.md).

## Skill anatomy

Every `SKILL.md` is enforced by [`scripts/validate-skill.sh`](scripts/validate-skill.sh):

- **YAML frontmatter** — `name`, `description`, `type` are required. Convention
  adds `intent`, `theme`, `best_for`, `scenarios`, `estimated_time`.
- **Six `##` sections, in order**: Purpose · Key Concepts · Application ·
  Examples · Common Pitfalls · References. None may be empty.
- The `description:` field is what the dispatcher matches against — make it
  vivid and concrete (named outcome, recognisable shape), not generic.

Run the validator on any new or edited `SKILL.md` before committing:

```sh
./scripts/validate-skill.sh roles/<role>/skills/<skill>/SKILL.md
```

## Sources discipline

Every framework named in a Key Concepts section must trace to a name in the
role's `sources.md`. Cite the author / book / concept, not "general industry
practice".

Soft cap: **~10 anchors per role**. Exceeding the cap is allowed when a new
load-bearing theme has no prior coverage (Rumelt on PM, Ramanujam on
marketing-expert are the existing precedents) — document the cap exception in
`sources.md` itself rather than ignoring it silently.

## Regenerating the catalog

[`scripts/catalog.sh`](scripts/catalog.sh) rebuilds `CATALOG.md` from
frontmatter. Run it after:

- Adding, renaming, or removing a role or skill.
- Editing a `description:` field (the dispatcher matches against those).
- Promoting a forward-reference skill to shipped.

```sh
./scripts/catalog.sh
```

The committed `CATALOG.md` is the source of truth for downstream consumers,
so commit the regen alongside the change that triggered it.

## TDD for scripts and validators

Code changes (anything under `scripts/`, validators, eval tooling) follow
strict Red/Green TDD:

1. **Red** — write a failing test that pins down the desired behaviour. Run
   it. Confirm it fails for the *right* reason.
2. **Green** — write the minimum code to make the test pass.
3. **Refactor** — only after green. Tests stay green throughout.

Doc-only or skill-only changes don't need a test. Anything that runs as code
does.

## Branch hygiene

- Branch from a clean `main` (`git status` clean, `git pull --ff-only`
  applied).
- Feature-branch names: `feat/<thing>`, `fix/<thing>`, `chore/<thing>`.
- One concern per branch. One commit per logical unit; commit messages
  explain *why*, not *what*.
- **Never** commit directly to `main` / `master`.
- **Never** skip hooks (`--no-verify`) — fix the underlying issue.
- **Never** run destructive git ops (`reset --hard`, `push --force`,
  `branch -D`) without explicit confirmation.

## Before opening a PR

```sh
./scripts/validate-skill.sh    # if you touched any SKILL.md
./scripts/catalog.sh           # if you touched any frontmatter
./scripts/smoke-check.sh       # always — confirms counts add up
```

PR descriptions should name the user-facing change in one line, then list the
files touched in plain bullets. No need to recap diffs the reviewer can read.
