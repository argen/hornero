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

Think of [*Hornero*](https://en.wikipedia.org/wiki/Rufous_hornero) as a patient companion — calm, plain-spoken, industrious. The rufous hornero (Argentina's national bird) builds clay-oven nests in methodical layers over weeks, lives close to humans on fenceposts and lampposts, and sings in duets with its mate. That's the working metaphor: a steady partner, not a kiosk; the work compounds layer by layer and outlasts any single session. The companion's voice is codified in [`VOICE.md`](VOICE.md).

## What you get

A `product-manager` role with **38 expert-grounded skills** that turn plain-English prompts into focused PM work:

- **Discovery** — interview prep + synthesis, JTBD, problem framing, opportunity-solution trees, proto-personas, journey maps.
- **Strategy** — strategy kernel, bet portfolio, PRDs, OKRs, prioritisation, success metrics, competitive teardowns, revenue architecture.
- **Positioning + GTM** — positioning statement, Amazon-style press release.
- **AI-PM** — AI-shaped readiness, context engineering.
- **Finance literacy** — SaaS revenue + efficiency metrics, TAM/SAM/SOM, feature-investment, pricing, business-health diagnostic.
- **Outside-in** — PESTEL, company research, acquisition-channel decisions.
- **Workshops + delivery** — workshop facilitation, user story mapping.
- **Career + leadership** — altitude/horizon diagnostic, director-readiness coaching, executive onboarding, product-sense interview prep.
- **Operations + orchestration** — Linear triage, HubSpot pipeline readout, cross-functional decision orchestration.

Plus **16 cross-role process skills** for the harness itself: problem-spec, lesson-extract, harness-check, context-reset, decision records, memory query, chronicle record + recall, the three chronicle-append-shaped skills (hypothesis-track, stakeholder-update, customer-update), the chronicle workflow trio (ingest, prep, review), and two cross-system read primitives (query-issue-tracker for Linear/Jira, query-warehouse for BigQuery/Snowflake with a kill-cost guardrail). A `product-manager-reviewer` subagent critiques artefacts to the same bar, and a 12-command slash surface (five `type: command` skills plus seven invocable workflow skills) covers kickoff, orchestration, catalog, rot-review, and the chronicle workflow.

**Lessons extract themselves.** The `extract-lesson` skill fires on the Stop hook at the end of every session — the agent scans for corrections, surprises, and validated approaches, and surfaces concrete proposals when there's real signal (otherwise it stays quiet). Proposals are reviewed before any harness file changes. Opt out per-session with `HORNERO_NO_AUTO_EXTRACT=1`.

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

Slash commands (skills, so installed to `~/.claude/skills/` with everything else) are available as bare `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`, `/ingest`, `/prep`, `/review`, `/hypothesis-track`, `/stakeholder-update`, `/customer-update` (no `hornero:` namespace).

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

Installs skills → `~/.codex/skills/`, reviewer agents → `~/.codex/agents/` (TOML), session hooks → `~/.codex/hooks.json`. Slash commands ship as skills, so there is no separate prompts directory.

### What you get either way (both hosts)

- ✅ **1 reviewer subagent** — `product-manager-reviewer`, callable by name on either host (Claude via the Agent tool; Codex via the natural-language native path).
- ✅ **54 expert-grounded skills** — 38 product-management skills (across discovery, strategy, AI-PM, finance, outside-in, workshops, delivery, career-leadership, operations) + 16 cross-role process skills (including the chronicle write/read/append trio, the chronicle workflow trio of `ingest`/`prep`/`review`, and the cross-system `query-issue-tracker` / `query-warehouse` primitives); see *What's in the box*.
- ✅ **12 slash commands** — `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`, `/ingest`, `/prep`, `/review`, `/hypothesis-track`, `/stakeholder-update`, `/customer-update` (skills; namespaced as `/hornero:<name>` under the Claude Code plugin).
- ✅ **Session hooks** — `SessionStart` primer and `Stop` lesson reminder via `hooks/hooks.json` (same JSON format both hosts read).

### Build-time scripts

If you edit an agent definition, one generator keeps the Codex layout in sync (skills need no generator: every skill is a real directory at `skills/<name>/`):

- `./scripts/build-codex-agents.sh` — regenerates the `.codex/agents/<name>.toml` files Codex reads from the canonical `agents/<name>.md` Markdown sources.

It is idempotent. `scripts/smoke-check.sh` fails loudly if it gets out of sync.

### CI + local guards

Every PR runs `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` in GitHub Actions — see [`.github/workflows/ci.yml`](.github/workflows/ci.yml). `validate-dispatcher` runs transitively as step 12 inside `smoke-check`. No secrets, no API credits, no network.

To catch the same breakage locally before push, opt into the pre-commit shim:

```sh
./scripts/install-git-hooks.sh
```

It symlinks `scripts/hooks/pre-commit` into `.git/hooks/`. Run with `--remove` to undo. Not auto-installed.

See [`playbooks/harness-guide.md`](playbooks/harness-guide.md) for the full inventory of determinism invariants, what each check validates, and how to extend the harness without breaking it.

### Plugin namespace caveat (Claude Code)

Plugin-loaded slash commands are namespaced — `/hornero:orchestrate`, not `/orchestrate`. Opened from the repo root (or after `./install.sh`), the same skills load unnamespaced as bare `/orchestrate`. Codex doesn't namespace.

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

The PM frames the request as a customer job, runs the work through [`cross-functional-orchestration`](skills/cross-functional-orchestration/SKILL.md), and synthesises into a *product decision* — outcomes, success criteria, the alternative considered, the revisit condition — rather than a pile of opinions.

### Process commands

| Command | When |
|---|---|
| `/kickoff` | Guided first dispatch — a 3-sentence intro and one open invitation. Use once. |
| `/catalog` | See everything Hornero ships (the PM role, its 38 skills, the 16 cross-role process skills, commands). |
| `/ingest` | Wrap an artifact (transcript, meeting notes, doc, dashboard pull) into the chronicle layer — preserves the raw input, drafts a synthesis, proposes chronicle entries. |
| `/prep` | One-page meeting brief — pulls a stakeholder entry, decisions and open hypotheses in their scope, recent ingestion notes. |
| `/review` | Weekly chronicle-health sweep — six checks; drafts proposals for unambiguous fixes, surfaces the rest for a human call. |
| `/hypothesis-track`, `/stakeholder-update`, `/customer-update` | Append a dated row to the corresponding chronicle entry type without forcing a full supersede. See [`chronicle/SCHEMA.md`](chronicle/SCHEMA.md) → Append exception. |
| `/extract-lesson` | End of session — capture surprises as durable updates to roles, skills, or your project's `CLAUDE.md`/`AGENTS.md`. Run habitually or the harness doesn't compound. |
| `/audit` | Quarterly rot-review — surfaces unused skills, sources-anchor orphans, compensatory rules. Pairs with [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md). |

### Advanced

**Force the role explicitly:** `/role product-manager <task>` adopts PM for either reviewer or producer work — useful if natural-language routing picks the wrong skill or you want a specific behaviour.

**Adversarial review against the PM:** `./scripts/play-against.sh product-manager docs/my-prd.md` opens an interactive `claude` session that primes the `product-manager-reviewer` subagent to be antagonistic — *do not rubber-stamp*. With `--check` it runs the seeded fixtures (one positive, one negative control) as a coarse regression net against catastrophic persona drift, driven by `expect` against the real interactive CLI — not `claude -p`. See [`tests/seeded/README.md`](tests/seeded/README.md).

---

## What's in the box

One role persona, grounded in canonical expert sources (not LLM-generated). Skills follow a shared anatomy (Purpose · Key Concepts · Application · Examples · Common Pitfalls · References) and cite from `sources.md` — `scripts/validate-skill.sh` enforces this.

The product-manager role currently carries **38 skills** organised by theme. The full one-line index lives in [`CATALOG.md`](CATALOG.md); the themed grouping below is the navigation aid.

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
| **Operations** | `linear-triage`, `hubspot-pipeline-readout` |
| **Cross-functional orchestration** *(workflow)* | `cross-functional-orchestration` — the PM-as-orchestrator pattern that powers `/orchestrate` |

Cross-role process skills (16):

- **Harness primitives** — `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`.
- **Chronicle write / read** — `chronicle-record`, `chronicle-recall`.
- **Chronicle append-shaped** — `hypothesis-track`, `stakeholder-update`, `customer-update` (each grows a whitelisted section on its respective entry type via `chronicle.sh append`; see [`chronicle/SCHEMA.md`](chronicle/SCHEMA.md) → Append exception).
- **Chronicle workflow** — `ingest` (artifact → chronicle proposal), `prep` (one-page meeting brief), `review` (weekly health sweep).
- **Cross-system read primitives** — `query-issue-tracker` (Linear / Jira), `query-warehouse` (BigQuery / Snowflake, with a kill-cost guardrail).

> A subset of skills (career-leadership cluster, AI-PM pair, several discovery + finance + outside-in components) was re-synthesised from [Dean Peters' Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) under Hornero's house style — citing the underlying authors directly, with a synthesis-cue line back to Dean's repo in each ported skill's References. See [`ATTRIBUTION.md`](ATTRIBUTION.md).

The `product-manager-reviewer` subagent ships in [`agents/`](agents/) as a self-contained system prompt. Under Claude Code it's spawned by name via the Agent tool; under Codex it's read as a system-prompt fragment.

### Resources — external data sources (MCP)

Roles can read and write external systems via MCP. Each system has a `resources/<name>/RESOURCE.md` card that describes the object model, the canonical MCP server, common gotchas, and a fallback path for when MCP isn't connected. Skills opt in via `resources: [...]` frontmatter; Hornero stays usable when none are configured (graceful degradation).

| Resource | Status | What it covers |
|---|---|---|
| [`linear`](resources/linear/RESOURCE.md) | stable | Issue tracker — Issues, Projects, Cycles. Used by `linear-triage`, `prd`, `query-issue-tracker`. |
| [`jira`](resources/jira/RESOURCE.md) | stable | Atlassian issue tracker — Issues, Epics, Sprints, JQL. Used by `prd`, `query-issue-tracker`. |
| [`github`](resources/github/RESOURCE.md) | stable | Code host — PRs, issues, Actions, releases, CODEOWNERS. Used by `decision-record`. |
| [`bigquery`](resources/bigquery/RESOURCE.md) | stable | Google's serverless analytics warehouse. Used by `query-warehouse` (with native dry-run cost estimate). |
| [`snowflake`](resources/snowflake/RESOURCE.md) | stable | Snowflake's cloud data warehouse. Used by `query-warehouse` (with conservative pre-run estimate). |
| [`hubspot`](resources/hubspot/RESOURCE.md) | stable | HubSpot CRM — Contacts, Companies, Deals, Tickets, Pipelines. Used by `hubspot-pipeline-readout`. |
| [`canva`](resources/canva/RESOURCE.md), [`gmail`](resources/gmail/RESOURCE.md), [`google-calendar`](resources/google-calendar/RESOURCE.md), [`google-drive`](resources/google-drive/RESOURCE.md), [`intercom`](resources/intercom/RESOURCE.md) | stable | claude.ai-native integrations — OAuth via the Claude Code Integrations UI. No skills consume them today; cards are ready for the next wave. |
| [`datadog`](resources/datadog/RESOURCE.md) | stretch | Datadog observability — metrics, logs, traces, monitors, SLOs. Scaffolded for future PM skills around launch-impact validation. |
| [`slack`](resources/slack/RESOURCE.md) | stretch | Slack team comms — channels, messages, threads, search. Scaffolded for customer-signal triage and async-feedback synthesis. |
| [`notion`](resources/notion/RESOURCE.md) | stretch | Notion docs + databases — pages, properties, queries. Scaffolded for PRD drafting and roadmap-database triage. |

`bash install.sh --list-resources` prints the current catalog with status and consumer count. More resources (Sentry, Grafana, Amplitude, Mixpanel, Stripe) land in follow-up PRs — see [`ROADMAP.md`](ROADMAP.md).

### Chronicle — project-local memory of decisions, hypotheses, stakeholders, customers

Hornero ships a [`chronicle/`](chronicle/) layer: a machine-queryable record any future session or role can load as situational awareness. It is influenced by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — same lifecycle (proposals → human-gated commit → byte-stable query), simpler substrate (Markdown-with-strict-frontmatter, deterministic harness, no embedder dependency). Influenced too by [PM Brain](https://github.com/phuryn/pm-brain) on the multi-type entry shape and sourcing hierarchy.

**Four entry types** (per [`chronicle/SCHEMA.md`](chronicle/SCHEMA.md)):

- `decision` — Rumelt's strategy kernel + validation plan. The original shape.
- `hypothesis` — assumption under test (Assumption → Prediction → Falsifier → Evidence Log → Resolution); resolves into a decision when evidence accumulates or the assumption is refuted.
- `stakeholder` — per-person profile (Role & influence → Open asks → Concerns → Last contact → Decision affinity) for the people the team coordinates with.
- `customer` — per-B2B-account profile (Account profile → Usage shape → Health signals → Decision drivers → Stakeholders) for accounts where the company is the unit of revenue.

Every entry carries a `sourcing` field — `documented > verbal > intuition > industry` (ordered strongest → weakest). The value is the weakest source the entry rests on, so a `validated` entry resting on `intuition` is visibly thin and `/review` will flag it.

**Three write paths:**

- [`chronicle-record`](skills/chronicle-record/SKILL.md) → `chronicle.sh propose` → human commit. The original create path; LLM-free.
- [`chronicle-recall`](skills/chronicle-recall/SKILL.md) → `chronicle.sh query`. Byte-identical output for a given corpus.
- **Append exception** — `chronicle.sh append` grows whitelisted sections (Evidence Log on hypotheses; Open asks / Concerns / Last contact / Decision affinity on stakeholders; Usage shape / Health signals / Decision drivers / Stakeholders on customers) row-by-row, without forcing a full supersede. Decisions stay fully immutable. Driven by the three append-shaped skills: [`hypothesis-track`](skills/hypothesis-track/SKILL.md), [`stakeholder-update`](skills/stakeholder-update/SKILL.md), [`customer-update`](skills/customer-update/SKILL.md).

**Three workflow skills** wrap the layer end-to-end:

- [`ingest`](skills/ingest/SKILL.md) — artifact → synthesis → chronicle entry proposals. Source artifact preserved under `chronicle/source/` (gitignored), synthesis under `chronicle/ingestion/`.
- [`prep`](skills/prep/SKILL.md) — one-page meeting brief grounded in stakeholder entries, decisions, open hypotheses, and recent ingestion notes.
- [`review`](skills/review/SKILL.md) — weekly chronicle-health sweep (six checks: stale hypotheses, overdue decisions, stale stakeholder contact, thin sourcing on validated entries, supersedes chain integrity, scope-tag entropy). Drafts proposals for unambiguous fixes; surfaces the rest for a human call.

A deterministic harness at [`tests/chronicle/`](tests/chronicle/) backs the layer: every schema rule has a planted-flaw fixture, every query has a frozen expected output, every append case (positive + negative) has byte-diff and diagnostic-substring tests. `scripts/test-chronicle.sh` runs 33 checks in `smoke-check.sh` and in the pre-commit hook.

**Multi-role-review evals** at [`evals/`](evals/) measure output quality on 20 representative cross-functional tasks using a human + LLM dual-score approach: `evals/judge.py` scores a synthesis automatically via the Claude API (writes `score_llm.json`); `evals/score.sh` handles human scoring (writes `score_human.json`) and aggregation with delta flagging. See [`evals/README.md`](evals/README.md).

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

- [`methodology.md`](methodology.md) — the two-layer synthesis: harness compounding (Chris MDP) + multi-agent orchestration (Anthropic's research system).
- [`playbooks/onboarding.md`](playbooks/onboarding.md) — 30-minute hands-on walkthrough.
- [`playbooks/adoption.md`](playbooks/adoption.md) — adopting Hornero in a team: DRI, working group, approval bar, infrastructure-before-rollout, cadence setup.
- [`playbooks/feedback-ritual.md`](playbooks/feedback-ritual.md) — weekly `/extract-lesson` cadence.
- [`playbooks/skill-rot-review.md`](playbooks/skill-rot-review.md) — quarterly retirement cadence; the judgment turn that pairs with `/audit`.
- [`playbooks/claude-md-layering.md`](playbooks/claude-md-layering.md) — when to add a sub-`CLAUDE.md` and what belongs in root vs. sub.
- [`playbooks/memory-loop.md`](playbooks/memory-loop.md) — the project-local memory layer end-to-end.
- [`examples/use-cases.md`](examples/use-cases.md) — six PM workflow sequences (discovery cycle, strategy kernel, launch readiness, finance review, weekly rhythm, stakeholder prep) — the multi-skill patterns that compound.
- [`examples/sample-session.md`](examples/sample-session.md) — annotated PM session showing the dispatcher → role-adoption → synthesis flow.
- [`examples/week-with-hornero.md`](examples/week-with-hornero.md) — five-day narrative of one PM using `/ingest`, `/prep`, `/review`, and chronicle-record across a real initiative; shows how the chronicle layer grows.
- [`ROADMAP.md`](ROADMAP.md) — current status and what's next.
- [`CHANGELOG.md`](CHANGELOG.md) — what shipped in each release.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) — the expert sources the methodology incorporates.

---

## License

[MIT](LICENSE). Hornero's synthesis, structure, and prose are MIT-licensed. Frameworks incorporated from named authors (see each role's `sources.md` and [`ATTRIBUTION.md`](ATTRIBUTION.md)) remain the intellectual property of their respective authors and publishers.
