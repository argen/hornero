# Hornero

```
                            .--.
                          .'    \__
                         (  o      >
                          \       /
                           '.___,'
                             ||
                             ||
                         ===========

              patient layers · durable structure
```

> A shareable AI-coding methodology with expert-infused, role-based skills.
> Works with both **Claude Code** and **Codex**.

[*Hornero*](https://en.wikipedia.org/wiki/Rufous_hornero) is Argentina's national bird (*Furnarius rufus*) — known for building elaborate clay-oven nests in patient, methodical layers. The metaphor fits the project: each session adds a layer; the structure outlasts any single conversation.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role,
> `product-manager`, plus six cross-role process skills. The multi-role
> dispatcher, orchestration rules, reviewer-subagent fan-out, and dual
> plugin paths are retained as **dormant scaffolding** so re-expansion
> (adding `software-engineer`, `designer`, `tester`, `security-expert`,
> `marketing-expert`, `data-scientist` back) is a drop-in change against
> the same harness, not a re-architecture. See [`ROADMAP.md`](ROADMAP.md)
> for the re-expansion plan.

---

## Quick Start

Clone the repo and open it with your AI coding tool of choice. No installer required.

```bash
git clone git@github.com:argen/hornero.git && cd hornero

# Claude Code:
claude

# OpenAI Codex:
codex
```

Then either type `/kickoff` for a guided first dispatch, or describe a task in plain English — the dispatcher will pick the right role/skill and **declare its choice in one line** before doing the work.

> **No install step?** Right. Hornero works as the project itself — `CLAUDE.md` (for Claude Code) and `AGENTS.md` (for Codex) live at the repo root. To make Hornero available globally across all projects, see *Install for global availability* below.

---

## Install for global availability

Hornero ships sibling plugin manifests for both AI coding hosts. Same skills, same agents, same dispatcher protocol — discovered natively by whichever runtime you use. The plugin path is preferred where the host supports it; `install.sh` is the file-copy alternative.

### Claude Code

**Preferred — plugin install:**

```bash
git clone git@github.com:argen/hornero.git
claude --plugin-dir ./hornero
```

Then in the session: `/hornero:catalog`, `/hornero:kickoff`, `/hornero:orchestrate`, `/hornero:role`.

**Alternative — copy into `~/.claude/`:**

```bash
./install.sh --claude
```

Slash commands available as bare `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit` (no `hornero:` namespace).

### Codex

**Preferred — plugin install** (via Codex's marketplace, see [docs](https://developers.openai.com/codex/plugins/build)):

```bash
codex plugin marketplace add argen/hornero   # once Hornero is published
```

Then enable the `hornero` plugin in `~/.codex/config.toml`.

**Alternative — copy into `~/.codex/` from a clone:**

```bash
./install.sh --codex
```

Installs skills → `~/.codex/skills/`, reviewer agents → `~/.codex/agents/` (TOML), session hooks → `~/.codex/hooks.json`, slash command prompts → `~/.codex/prompts/`.

### What you get either way (both hosts)

- ✅ **1 reviewer subagent** — `product-manager-reviewer`, callable by name on either host (Claude via the Agent tool; Codex via the natural-language native path).
- ✅ **21 expert-grounded skills** — 15 product-management skills + 6 cross-role process skills; see *What's in the box*.
- ✅ **6 slash commands** — `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit` (namespaced as `/hornero:<name>` under the Claude Code plugin). The previous `/review` command was retired with the multi-role-review skill; the path is dormant pending re-expansion.
- ✅ **Session hooks** — `SessionStart` primer and `Stop` lesson reminder via `hooks/hooks.json` (same JSON format both hosts read).

### Build-time scripts

If you add a new skill or edit an agent definition, two generators keep the plugin layouts in sync:

- `./scripts/build-plugin-skills.sh` — refreshes the top-level `skills/<name>/` symlinks Claude Code's plugin loader reads.
- `./scripts/build-codex-agents.sh` — regenerates the `.codex/agents/<name>.toml` files Codex reads from the canonical `agents/<name>.md` Markdown sources.

Both are idempotent. `scripts/smoke-check.sh` fails loudly if either gets out of sync.

### CI + local guards

Every PR runs `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` in GitHub Actions — see [`.github/workflows/ci.yml`](.github/workflows/ci.yml). No secrets, no API credits, no network.

To catch the same breakage locally before push, opt into the pre-commit shim:

```sh
./scripts/install-git-hooks.sh
```

It symlinks `scripts/hooks/pre-commit` into `.git/hooks/`. Run with `--remove` to undo. Not auto-installed.

### Plugin namespace caveat (Claude Code)

Plugin-loaded slash commands are namespaced — `/hornero:orchestrate`, not `/orchestrate`. If you also have `.claude/commands/` in your project, the bare `/orchestrate` continues to work there. Both can coexist; the bare form takes precedence in project-local scope. Codex doesn't namespace.

---

## How to use

### Let the PM orchestrate (the headline pattern)

For launches, contested decisions, and any cross-functional work — invoke the **product manager** as orchestrator. The PM frames the request as a customer job, picks the right role mix (2–5 roles), dispatches them in parallel, and synthesises into a decision recommendation.

```
/orchestrate Plan the LedgerStack v2 launch — is it ready?
```

What you get back is a *product decision* — outcomes, success criteria, the alternative the PM considered, the revisit condition — not a pile of role reports. The PM picks the expert lenses the work actually needs, runs them in parallel, and synthesises into a single launch-readiness recommendation. ([Inside view of how that works.](roles/product-manager/skills/cross-functional-orchestration/SKILL.md))

### Run a multi-role review directly *(dormant)*

> The `/review` command and its `multi-role-review` skill were retired
> alongside the non-PM roles. With one role shipped today the path
> degenerates to `/role product-manager` — restore the path by adding
> roles back under `roles/`, agents back under `agents/`, and reinstating
> `.claude/commands/review.md`. The orchestration playbook still documents
> the design target.

### Invoke a single role

```
/role product-manager draft a PRD for the cohort-duplicate fix
```

For reviewer tasks, this spawns the role's reviewer subagent. For producer tasks ("draft a PRD", "produce a positioning canvas"), it adopts the role + the matching component skill. PM is the only role currently available; the command will accept additional roles automatically once they're restored.

### Play against the PM role from the shell

```sh
./scripts/play-against.sh product-manager docs/my-prd.md
```

Opens an interactive `claude` session with a pre-seeded prompt that asks the `product-manager-reviewer` subagent to be antagonistic — *do not rubber-stamp*. Same script with `--check` runs the seeded PM fixtures (one positive, one negative control) as a coarse regression net for catastrophic persona drift, driven by `expect` against the real interactive CLI — not `claude -p`. See [`tests/seeded/README.md`](tests/seeded/README.md) for the planted flaw and signature design.

### Process skills

| Command | When |
|---|---|
| `/kickoff` | First time using Hornero — guided dispatch in under 5 minutes. |
| `/catalog` | See everything Hornero ships (roles, skills, commands). |
| `/extract-lesson` | End of session — capture surprises as durable updates to roles, skills, or your project's `CLAUDE.md`/`AGENTS.md`. Run habitually or the harness doesn't compound. |
| `/audit` | Quarterly rot-review — surfaces skills not invoked recently, sources-anchor orphans, and compensatory rules. Pairs with [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md). |

### Natural language always works

Slash commands are shortcuts, not the only way in. The dispatcher in [`CLAUDE.md`](CLAUDE.md) / [`AGENTS.md`](AGENTS.md) matches plain prompts against role triggers and skill descriptions, then **declares its choice in one line** before starting:

> "Write a PRD for the cohort-duplicate fix." → *Adopting `product-manager` / `prd` — problem-driven spec is the artifact.*

> "Sharpen the positioning for the launch." → *Adopting `product-manager` / `positioning-statement` — Moore + Dunford template, sharpened.*

> "Define an activation metric for new signups." → *Adopting `product-manager` / `success-metrics` — name the OEC, the unit of analysis, and a counter-metric.*

You can redirect with one word ("use okrs instead").

---

## What's in the box

One role persona, grounded in canonical expert sources (not LLM-generated). Skills follow a shared anatomy (Purpose · Key Concepts · Application · Examples · Common Pitfalls · References) and cite from `sources.md` — `scripts/validate-skill.sh` enforces this.

| Role | Component skills | Workflow skill |
|---|---|---|
| **product-manager** | `prd`, `jobs-to-be-done`, `positioning-statement`, `okrs`, `discovery-interview-prep`, `success-metrics`, `problem-framing-canvas`, `strategy-kernel`, `prioritization-advisor`, `bet-portfolio`, `revenue-architecture`, `interview-synthesis`, `competitive-teardown`, `linear-triage` | `cross-functional-orchestration` |

Cross-role process skills: `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`.

The `product-manager-reviewer` subagent ships in [`agents/`](agents/) as a self-contained system prompt. Under Claude Code it's spawned by name via the Agent tool; under Codex it's read as a system-prompt fragment.

> The retired roles (`software-engineer`, `designer`, `tester`, `security-expert`, `marketing-expert`, `data-scientist`) live in git history. Re-adding any of them is a content drop-in: `roles/<role>/`, `agents/<role>-reviewer.md`, run `scripts/build-plugin-skills.sh` + `scripts/build-codex-agents.sh` + `scripts/catalog.sh`.

### Resources — external data sources (MCP)

Roles can read and write external systems via MCP. Each system has a `resources/<name>/RESOURCE.md` card that describes the object model, the canonical MCP server, common gotchas, and a fallback path for when MCP isn't connected. Skills opt in via `resources: [...]` frontmatter; Hornero stays usable when none are configured (graceful degradation).

| Resource | Status | What it covers |
|---|---|---|
| [`linear`](resources/linear/RESOURCE.md) | stable | Issue tracker — Issues, Projects, Cycles. Used by `linear-triage`. |
| [`jira`](resources/jira/RESOURCE.md) | stretch | Atlassian issue tracker — Issues, Epics, Sprints, JQL. Scaffolded for future PM skills (sprint readout, cross-functional triage). |
| [`bigquery`](resources/bigquery/RESOURCE.md) | stretch | Google's serverless analytics warehouse. Scaffolded for future PM skills around success-metrics validation and cohort analysis. |
| [`snowflake`](resources/snowflake/RESOURCE.md) | stretch | Snowflake's cloud data warehouse. Scaffolded for the same PM skills as BigQuery, on the Snowflake side. |
| [`hubspot`](resources/hubspot/RESOURCE.md) | stretch | HubSpot CRM — Contacts, Companies, Deals. Scaffolded for future PM skills around customer-signal triage and revenue-architecture validation. |
| [`datadog`](resources/datadog/RESOURCE.md) | stretch | Datadog observability — metrics, logs, traces, monitors, SLOs. Scaffolded for future PM skills around launch-impact validation. |
| [`slack`](resources/slack/RESOURCE.md) | stretch | Slack team comms — channels, messages, threads, search. Scaffolded for future PM skills around customer-signal triage and async-feedback synthesis. |
| [`notion`](resources/notion/RESOURCE.md) | stretch | Notion docs + databases — pages, properties, queries. Scaffolded for future PM skills around PRD drafting and roadmap-database triage. |
| [`github`](resources/github/RESOURCE.md) | dormant | PRs, issues, Actions, code search, CODEOWNERS. The consuming skill (`github-pr-survey`) was retired with the software-engineer role; the resource card is kept for re-expansion. |

More resources (Sentry, Grafana, Amplitude, Mixpanel, Stripe) land in follow-up PRs — see [`ROADMAP.md`](ROADMAP.md).

### Chronicle — project-local memory of decisions

Hornero ships a [`chronicle/`](chronicle/) layer: a machine-queryable record of decisions any future session or role can load as situational awareness. It is influenced by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — same lifecycle (proposals → human-gated commit → byte-stable query), simpler substrate (Markdown-with-strict-frontmatter, deterministic harness, no embedder dependency).

Two new cross-role skills wrap it:
- [`chronicle-record`](skills/chronicle-record/SKILL.md) — write side. Calls `scripts/chronicle.sh propose` (LLM-free; human commits).
- [`chronicle-recall`](skills/chronicle-recall/SKILL.md) — read side. Calls `scripts/chronicle.sh query`; output is byte-identical for a given corpus.

A deterministic harness at [`tests/chronicle/`](tests/chronicle/) backs the layer: every schema rule has a planted-flaw fixture, every query has a frozen expected output. `scripts/test-chronicle.sh` runs in `smoke-check.sh` and in the pre-commit hook.

Full one-liner index: [`CATALOG.md`](CATALOG.md).

---

## Use it in your own project

Drop these templates into a new repo and tailor:

- [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) — starter `CLAUDE.md` referencing Hornero roles, skills, and slash commands.
- [`templates/AGENTS.md.template`](templates/AGENTS.md.template) — same, for Codex projects.
- [`templates/sub-CLAUDE.md.template`](templates/sub-CLAUDE.md.template) — slim ~50-line scaffold for module-level `CLAUDE.md` files in monorepos / multi-service repos. See [`playbooks/claude-md-layering.md`](playbooks/claude-md-layering.md).
- [`templates/MAP.md.template`](templates/MAP.md.template) — one-screen codebase orientation map (top-level folders, entry points, stack at a glance). Recommended for any non-trivial repo.
- [`templates/settings.json`](templates/settings.json) — Claude Code settings starter with sensible permissions, session-lifecycle hooks, and opt-in guardrail hooks (validate-skill, catalog-regen, smoke-check).

Values that need editing are marked `<like this>`.

---

## Going deeper

- [`methodology.md`](methodology.md) — the two-layer synthesis: harness compounding (Chris MDP) + multi-agent orchestration (Anthropic's research system, dormant until re-expansion).
- [`playbooks/onboarding.md`](playbooks/onboarding.md) — 30-minute hands-on walkthrough.
- [`playbooks/adoption.md`](playbooks/adoption.md) — adopting Hornero in a team: DRI, working group, approval bar, infrastructure-before-rollout, cadence setup.
- [`playbooks/orchestration-heuristics.md`](playbooks/orchestration-heuristics.md) — *(dormant)* when to invoke 1 vs 4 vs 7 roles; parallel vs sequential dispatch. Applies once additional roles are restored.
- [`playbooks/multi-role-review.md`](playbooks/multi-role-review.md) — *(dormant)* plain-language companion to the retired skill.
- [`playbooks/feedback-ritual.md`](playbooks/feedback-ritual.md) — weekly `/extract-lesson` cadence.
- [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md) — quarterly retirement cadence; the judgment turn that pairs with `/audit`.
- [`playbooks/claude-md-layering.md`](playbooks/claude-md-layering.md) — when to add a sub-`CLAUDE.md` and what belongs in root vs. sub.
- [`playbooks/memory-loop.md`](playbooks/memory-loop.md) — the project-local memory layer end-to-end.
- [`examples/sample-session.md`](examples/sample-session.md) — annotated PM session showing the dispatcher → role-adoption → synthesis flow.
- [`ROADMAP.md`](ROADMAP.md) — status, including the re-expansion plan for the retired roles.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) — the expert sources the methodology incorporates.

---

## License

[MIT](LICENSE). Hornero's synthesis, structure, and prose are MIT-licensed. Frameworks incorporated from named authors (see each role's `sources.md` and [`ATTRIBUTION.md`](ATTRIBUTION.md)) remain the intellectual property of their respective authors and publishers.
