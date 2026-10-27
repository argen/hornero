# Contributing to Hornero

Guidance for working **on** the Hornero repo itself — adding roles, editing
skills, regenerating the catalog. For using Hornero in your own project, see
[`README.md`](README.md).

For the determinism invariants the harness rests on — what each validator
checks, how the layers compose, and what is forbidden — see
[`playbooks/harness-guide.md`](playbooks/harness-guide.md).

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
./scripts/validate-skill.sh skills/<skill>/SKILL.md
```

The same reminders load automatically for Claude Code sessions via [`.claude/rules/skills.md`](.claude/rules/skills.md), a path-scoped rule that applies only when files under `skills/`, `roles/`, or `resources/` are read.

**Every skill is a real directory at `skills/<name>/`.** A skill that belongs to a role carries `role: <role>` in its frontmatter (it must name an existing `roles/<role>/ROLE.md`); a cross-role skill omits the key. `scripts/catalog.sh` groups the catalog by that key, and smoke-check fails on any symlink under `skills/`.

**When you edit a reviewer agent** (`agents/<role>-reviewer.md`), re-run `./scripts/build-codex-agents.sh` to regenerate the matching `.codex/agents/<name>.toml` mirror. The Markdown file is the canonical source; the TOML is the format Codex reads natively. `smoke-check.sh` fails loudly if the two drift.

## Sources discipline

Every framework named in a Key Concepts section must trace to a name in the
role's `sources.md`. Cite the author / book / concept, not "general industry
practice".

Soft cap: **~10 anchors per role**. Exceeding the cap is allowed when a new
load-bearing theme has no prior coverage (Rumelt on PM is the existing
precedent) — document the cap exception in `sources.md` itself rather than
ignoring it silently.

**Vendor docs do NOT enter `sources.md`.** Linear API docs, GitHub REST docs,
BigQuery SQL reference, etc. live in the relevant `resources/<system>/RESOURCE.md`
under its own `## References` section. The role-level `sources.md` stays for
*frameworks* (people, books, concepts) and preserves the ~10-anchor cap.

## Adding a new role

Hornero ships `product-manager` today. Adding another role
(`software-engineer`, `tester`, `designer`, `security-expert`,
`marketing-expert`, `data-scientist`, or anything else) is a content drop-in:

1. Author `roles/<role>/ROLE.md` and `roles/<role>/sources.md`, then the
   role's skills at `skills/<skill>/SKILL.md`, each carrying `role: <role>`
   in its frontmatter.
2. Author `agents/<role>-reviewer.md` as the reviewer subagent's
   self-contained system prompt.
3. Run, in this order:
   ```sh
   ./scripts/build-codex-agents.sh      # generates .codex/agents/<name>.toml
   ./scripts/catalog.sh                 # regenerates CATALOG.md
   ./scripts/smoke-check.sh             # confirms counts and frontmatter
   ```
4. When a **second** role lands, add a `multi-role-review` skill, `/review`
   slash command, and `playbooks/multi-role-review.md` — parallel critique
   becomes useful at ≥2 lenses.
5. Update `LEGAL_ROLES` in [`scripts/play-against.sh`](scripts/play-against.sh)
   and `VALID_ROLES` / `DEFAULT_ROLES` in
   [`scripts/codex-parallel-review.sh`](scripts/codex-parallel-review.sh) to
   include the new role.

## Resource anatomy

External data sources (Linear, JIRA, GitHub, BigQuery, …) are described by
[`scripts/validate-resource.sh`](scripts/validate-resource.sh)-enforced
`resources/<system>/RESOURCE.md` files. Anatomy:

- **YAML frontmatter** — `name`, `description`, `type: data-source`, `status`
  (`stable` / `stretch` / `experimental`) are required. Convention adds `mcp`
  (server / install / auth_env / capabilities), `object_model`, `used_by`
  (back-references to skill slugs), and `fallback` (`prose` / `curl` / `sql`
  / `none`).
- **Six `##` sections, in order**: Purpose · MCP Server · Object Model ·
  Common Gotchas · Fallback Without MCP · References. None may be empty.
- **`status: stable` requires a real `mcp.install`.** Stretch resources may
  use `install: tbd` while their MCP server matures.
- **Resources are always cross-role.** A system used by multiple roles
  shouldn't be duplicated per-role; per-role *workflows* live in skills.

Run the validator on any new or edited `RESOURCE.md` before committing:

```sh
./scripts/validate-resource.sh resources/<system>/RESOURCE.md
```

### Skills that depend on a resource

Skills opt in by listing the resource slug in their frontmatter:

```yaml
resources:
  - linear
```

A union list (`resources: [linear, jira]`) means the skill is satisfied
when *any one* of the listed resources is available — useful for
system-agnostic skills like `query-issue-tracker`. Single-system skills
list one entry.

`smoke-check.sh` enforces a bidirectional invariant: every `resources:`
slug in a skill resolves to a real `RESOURCE.md`, and every `used_by:`
back-reference in a `RESOURCE.md` resolves to a real `SKILL.md`. Keep
both sides in sync when adding or renaming.

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

## Dispatcher routing fixtures

Routing expectations for representative prompts are captured in
[`tests/dispatcher/routes.tsv`](tests/dispatcher/routes.tsv) — tab-separated
`prompt → expected_skill → expected_role` triples plus `ESCALATE` entries for
documented multi-match cases.
[`scripts/validate-dispatcher.sh`](scripts/validate-dispatcher.sh) runs three
deterministic checks against the fixtures (dead references, CATALOG.md
description completeness, scenarios frontmatter presence). When you rename or
remove a skill, update `routes.tsv` to match — CI will fail otherwise.

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
./scripts/validate-skill.sh        # if you touched any SKILL.md
./scripts/validate-resource.sh     # if you touched any RESOURCE.md
./scripts/build-codex-agents.sh    # if you touched any agents/*.md
./scripts/catalog.sh               # if you touched any frontmatter
./scripts/validate-dispatcher.sh   # if you renamed/removed a skill or edited tests/dispatcher/routes.tsv
./scripts/smoke-check.sh           # always — confirms counts, flat layout, sync, cross-refs, and dispatcher fixtures
```

These also run in CI on every PR — `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` as explicit steps; `validate-dispatcher` runs transitively as step 12 inside `smoke-check`. See [`.github/workflows/ci.yml`](.github/workflows/ci.yml). CI is the authoritative gate. To catch the same breakage **before** push, opt into the local pre-commit shim:

```sh
./scripts/install-git-hooks.sh     # symlinks scripts/hooks/pre-commit into .git/hooks/
./scripts/install-git-hooks.sh --remove   # undo
```

The shim is intentionally not auto-installed by `install.sh` — opt-in respects contributor surprise budget.

PR descriptions should name the user-facing change in one line, then list the
files touched in plain bullets. No need to recap diffs the reviewer can read.
