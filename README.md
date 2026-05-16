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

> A shareable AI-augmented methodology for product managers, with expert-infused skills.
> Works with both **Claude Code** and **Codex**.

[*Hornero*](https://en.wikipedia.org/wiki/Rufous_hornero) is Argentina's national bird (*Furnarius rufus*) — known for building elaborate clay-oven nests in patient, methodical layers. The metaphor fits the project: each session adds a layer; the structure outlasts any single conversation.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role,
> `product-manager`, plus eight cross-role process skills. The role
> currently carries **37 PM skills** spanning discovery, strategy, OKRs,
> positioning, prioritisation, JTBD, the AI-PM competencies, finance
> literacy, outside-in scanning, workshops, delivery, and the
> PM-to-Director career arc. The multi-role dispatcher, orchestration
> rules, reviewer-subagent fan-out, and dual plugin paths are retained as
> **dormant scaffolding** so re-expansion (adding `software-engineer`,
> `designer`, `tester`, `security-expert`, `marketing-expert`,
> `data-scientist` back) is a drop-in change against the same harness, not
> a re-architecture. See [`ROADMAP.md`](ROADMAP.md) for the re-expansion
> plan.

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

Then just **describe what you're working on in plain English** — the dispatcher matches the prompt against the catalog, **declares its choice in one line**, and starts the work. For example:

> *You:* "Critique my PRD draft." → *Hornero:* *Adopting `product-manager` / `prd` — problem-driven spec, reviewer mode.*
>
> *You:* "How healthy is our Rule of 40?" → *Hornero:* *Adopting `product-manager` / `saas-economics-efficiency-metrics` — capital-efficiency literacy.*

Redirect any pick with one word (*"use okrs instead"*). No menu to navigate. Type `/kickoff` only if you want a guided first dispatch.

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
- ✅ **45 expert-grounded skills** — 37 product-management skills (across discovery, strategy, AI-PM, finance, outside-in, workshops, delivery, career-leadership) + 8 cross-role process skills; see *What's in the box*.
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

### Natural language is the front door

The dispatcher in [`CLAUDE.md`](CLAUDE.md) / [`AGENTS.md`](AGENTS.md) reads plain prompts against role triggers and skill descriptions, then **declares its choice in one line** before starting:

> "Write a PRD for the cohort-duplicate fix." → *Adopting `product-manager` / `prd` — problem-driven spec is the artifact.*

> "Sharpen the positioning for the launch." → *Adopting `product-manager` / `positioning-statement` — Moore + Dunford template.*

> "Define an activation metric for new signups." → *Adopting `product-manager` / `success-metrics` — name the OEC, unit of analysis, counter-metric.*

> "How do I read our Rule of 40?" → *Adopting `product-manager` / `saas-economics-efficiency-metrics` — capital-efficiency literacy.*

> "Build a story map for the next two releases." → *Adopting `product-manager` / `user-story-mapping` — Patton spine + walking skeleton.*

> "Size the TAM for this new vertical." → *Adopting `product-manager` / `tam-sam-som-calculator` — top-down × bottom-up triangulation.*

If the prompt is ambiguous, the dispatcher asks **one** clarifying question (not a menu of options). Redirect any choice with one word (*"use okrs instead"*).

### Cross-functional decisions with `/orchestrate`

For launches, contested decisions, or any question that crosses concerns, invoke the PM as orchestrator:

```
/orchestrate Plan the v2 launch — is it ready?
```

The PM frames the request as a customer job, runs the work through [`cross-functional-orchestration`](roles/product-manager/skills/cross-functional-orchestration/SKILL.md), and synthesises into a *product decision* — outcomes, success criteria, the alternative considered, the revisit condition — rather than a pile of opinions.

> **Today, single-lens.** With one role shipped, `/orchestrate` runs the PM end to end. The multi-role fan-out (engineering / design / testing / security / marketing / data-science reviewers in parallel, synthesised into one decision) is dormant scaffolding pending re-expansion — see [`ROADMAP.md`](ROADMAP.md).

### Process commands

| Command | When |
|---|---|
| `/kickoff` | Guided first dispatch — a 3-sentence intro and one open invitation. Use once. |
| `/catalog` | See everything Hornero ships (the PM role, its 37 skills, the 8 cross-role process skills, commands). |
| `/extract-lesson` | End of session — capture surprises as durable updates to roles, skills, or your project's `CLAUDE.md`/`AGENTS.md`. Run habitually or the harness doesn't compound. |
| `/audit` | Quarterly rot-review — surfaces unused skills, sources-anchor orphans, compensatory rules. Pairs with [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md). |

### Advanced

**Force the role explicitly:** `/role product-manager <task>` adopts PM for either reviewer or producer work — useful if natural-language routing picks the wrong skill or you want a specific behaviour. With one role today, this is mostly redundant with plain prompts; retained for re-expansion.

**Adversarial review against the PM:** `./scripts/play-against.sh product-manager docs/my-prd.md` opens an interactive `claude` session that primes the `product-manager-reviewer` subagent to be antagonistic — *do not rubber-stamp*. With `--check` it runs the seeded fixtures (one positive, one negative control) as a coarse regression net against catastrophic persona drift, driven by `expect` against the real interactive CLI — not `claude -p`. See [`tests/seeded/README.md`](tests/seeded/README.md).

---

## What's in the box

One role persona, grounded in canonical expert sources (not LLM-generated). Skills follow a shared anatomy (Purpose · Key Concepts · Application · Examples · Common Pitfalls · References) and cite from `sources.md` — `scripts/validate-skill.sh` enforces this.

The product-manager role currently carries **37 skills** organised by theme. The full one-line index lives in [`CATALOG.md`](CATALOG.md); the themed grouping below is the navigation aid.

| Theme | Skills |
|---|---|
| **Discovery** | `discovery-interview-prep`, `interview-synthesis`, `jobs-to-be-done`, `problem-framing-canvas`, `opportunity-solution-tree`, `proto-persona`, `customer-journey-map` |
| **Strategy** | `strategy-kernel`, `bet-portfolio`, `prd`, `okrs`, `prioritization-advisor`, `success-metrics`, `competitive-teardown`, `revenue-architecture` |
| **Positioning + GTM** | `positioning-statement`, `press-release` |
| **AI-PM** | `ai-shaped-readiness-advisor`, `context-engineering-advisor` |
| **Finance literacy** | `saas-revenue-growth-metrics`, `saas-economics-efficiency-metrics`, `finance-metrics-quickref`, `tam-sam-som-calculator`, `feature-investment-advisor`, `finance-based-pricing-advisor`, `business-health-diagnostic` |
| **Outside-in** | `pestel-analysis`, `company-research`, `acquisition-channel-advisor` |
| **Workshops + delivery** | `workshop-facilitation`, `user-story-mapping` |
| **Career / leadership** | `altitude-horizon-framework`, `director-readiness-advisor`, `executive-onboarding-playbook`, `product-sense-interview-answer` |
| **Operations** | `linear-triage` |
| **Cross-functional orchestration** *(workflow)* | `cross-functional-orchestration` — the PM-as-orchestrator pattern that powers `/orchestrate` |

Cross-role process skills (8): `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`, `chronicle-record`, `chronicle-recall`.

> A subset of skills (career-leadership cluster, AI-PM pair, several discovery + finance + outside-in components) was re-synthesised from [Dean Peters' Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) under Hornero's house style — citing the underlying authors directly, with a synthesis-cue line back to Dean's repo in each ported skill's References. See [`ATTRIBUTION.md`](ATTRIBUTION.md).

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
- [`playbooks/feedback-ritual.md`](playbooks/feedback-ritual.md) — weekly `/extract-lesson` cadence.
- [`playbooks/orchestration-heuristics.md`](playbooks/orchestration-heuristics.md) + [`playbooks/multi-role-review.md`](playbooks/multi-role-review.md) — *(dormant)* the multi-role design target; returns alongside the retired roles.
- [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md) — quarterly retirement cadence; the judgment turn that pairs with `/audit`.
- [`playbooks/claude-md-layering.md`](playbooks/claude-md-layering.md) — when to add a sub-`CLAUDE.md` and what belongs in root vs. sub.
- [`playbooks/memory-loop.md`](playbooks/memory-loop.md) — the project-local memory layer end-to-end.
- [`examples/sample-session.md`](examples/sample-session.md) — annotated PM session showing the dispatcher → role-adoption → synthesis flow.
- [`ROADMAP.md`](ROADMAP.md) — status, including the re-expansion plan for the retired roles.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) — the expert sources the methodology incorporates.

---

## License

[MIT](LICENSE). Hornero's synthesis, structure, and prose are MIT-licensed. Frameworks incorporated from named authors (see each role's `sources.md` and [`ATTRIBUTION.md`](ATTRIBUTION.md)) remain the intellectual property of their respective authors and publishers.
