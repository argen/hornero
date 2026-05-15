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

*Hornero* is Argentina's national bird (*Furnarius rufus*) — known for building elaborate clay-oven nests in patient, methodical layers. The metaphor fits the project: each session adds a layer; the structure outlasts any single conversation.

---

## Quick Start

> **Not a developer?** [`playbooks/non-engineer-quickstart.md`](playbooks/non-engineer-quickstart.md) is a friendlier on-ramp for designers, PMs, marketers, and data scientists — same 30-minute window, with examples that match your work.

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

Then in the session: `/hornero:catalog`, `/hornero:kickoff`, `/hornero:orchestrate`, `/hornero:review`, `/hornero:role`.

**Alternative — copy into `~/.claude/`:**

```bash
./install.sh --claude
```

Slash commands available as bare `/orchestrate`, `/review`, etc. (no `hornero:` namespace).

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

- ✅ **7 reviewer subagents** — same `<role>-reviewer` names callable on either host. Claude uses the Agent tool; Codex parses natural-language ("have tester-reviewer pass over this commit").
- ✅ **~60 expert-grounded skills** — cross-role + per-role; see *What's in the box*.
- ✅ **7 slash commands** — `/orchestrate`, `/review`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit` (namespaced as `/hornero:<name>` under the Claude Code plugin).
- ✅ **Session hooks** — `SessionStart` primer and `Stop` lesson reminder via `hooks/hooks.json` (same JSON format both hosts read).

### Build-time scripts

If you add a new skill or edit an agent definition, two generators keep the plugin layouts in sync:

- `./scripts/build-plugin-skills.sh` — refreshes the top-level `skills/<name>/` symlinks Claude Code's plugin loader reads.
- `./scripts/build-codex-agents.sh` — regenerates the `.codex/agents/<name>.toml` files Codex reads from the canonical `agents/<name>.md` Markdown sources.

Both are idempotent. `scripts/smoke-check.sh` fails loudly if either gets out of sync.

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

### Run a multi-role review directly

When you already know the role mix, or when the integrating thread isn't a customer job:

```
/review this PR — use engineer + tester + security
```

Spawns the named reviewer subagents in parallel, surfaces non-overlapping findings, names conflicts, and gives a ranked recommendation. Max 7 roles per invocation; see [`skills/multi-role-review/SKILL.md`](skills/multi-role-review/SKILL.md).

### Invoke a single role

```
/role security-expert audit the new auth flow
/role tester write a regression test for BUG-1247
/role designer review the onboarding screens for accessibility
```

For reviewer tasks, this spawns the role's reviewer subagent. For producer tasks ("draft a PRD", "produce a threat model"), it adopts the role + the matching component skill.

### Process skills

| Command | When |
|---|---|
| `/kickoff` | First time using Hornero — guided dispatch in under 5 minutes. |
| `/catalog` | See everything Hornero ships (roles, skills, commands). |
| `/extract-lesson` | End of session — capture surprises as durable updates to roles, skills, or your project's `CLAUDE.md`/`AGENTS.md`. Run habitually or the harness doesn't compound. |

### Natural language always works

Slash commands are shortcuts, not the only way in. The dispatcher in [`CLAUDE.md`](CLAUDE.md) / [`AGENTS.md`](AGENTS.md) matches plain prompts against role triggers and skill descriptions, then **declares its choice in one line** before starting:

> "Critique my homepage hero — is the positioning sharp or generic?" → *Adopting `marketing-expert` / reviewer mode — artifact is copy with a positioning claim; broad pass first.*

> "Run a heuristic review on this checkout screen." → *Adopting `designer` / `heuristic-review` — Nielsen heuristics broad pass, then severity-rank the top three.*

> "Review my last commit. ≤200 lines." → *Adopting `software-engineer` / reviewer mode — broad pass then deepest concern.*

You can redirect with one word ("designer instead", "marketing instead").

---

## What's in the box

Seven role personas, each grounded in canonical expert sources (not LLM-generated). Each role's skills follow the same anatomy (Purpose · Key Concepts · Application · Examples · Common Pitfalls · References) and cite from `sources.md` — `scripts/validate-skill.sh` enforces this.

| Role | Component skills | Workflow skill |
|---|---|---|
| **software-engineer** | `adr`, `rfc`, `refactor-plan` | `tdd-discipline` |
| **product-manager** | `prd`, `jobs-to-be-done`, `positioning-statement`, `okrs`, `discovery-interview-prep` | `cross-functional-orchestration` |
| **designer** | `state-audit`, `accessibility-audit`, `heuristic-review` | `design-review` |
| **tester** | `test-plan`, `exploratory-charter`, `regression-test` | `pre-release-test-pass` |
| **security-expert** | `threat-model`, `security-review`, `llm-risk-assessment` | `pre-launch-security-audit` |
| **marketing-expert** | `positioning-canvas`, `strategic-narrative`, `launch-brief` | `pre-launch-marketing-audit` |
| **data-scientist** | `metric-definition`, `experiment-design`, `causal-dag` | `pre-launch-measurement-audit` |

Cross-role process skills: `spec-the-problem`, `multi-role-review`, `extract-lesson`, `harness-check`, `context-reset-check`.

Reviewer subagents (one per role) ship in [`agents/`](agents/) and are self-contained system prompts. Under Claude Code they're spawned by name via the Agent tool; under Codex they're read as system-prompt fragments.

Full one-liner index: [`CATALOG.md`](CATALOG.md).

---

## Use it in your own project

Drop these templates into a new repo and tailor:

- [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) — starter `CLAUDE.md` referencing Hornero roles, skills, and slash commands.
- [`templates/AGENTS.md.template`](templates/AGENTS.md.template) — same, for Codex projects.
- [`templates/settings.json`](templates/settings.json) — Claude Code settings starter with sensible permissions.

Values that need editing are marked `<like this>`.

---

## Going deeper

- [`methodology.md`](methodology.md) — the two-layer synthesis: harness compounding (Chris MDP) + multi-agent orchestration (Anthropic's research system).
- [`playbooks/onboarding.md`](playbooks/onboarding.md) — 30-minute hands-on walkthrough.
- [`playbooks/non-engineer-quickstart.md`](playbooks/non-engineer-quickstart.md) — same goal, friendlier on-ramp for designers, PMs, marketers, data scientists.
- [`playbooks/role-cheatsheet.md`](playbooks/role-cheatsheet.md) — 1-page quick reference: when to invoke each role.
- [`playbooks/orchestration-heuristics.md`](playbooks/orchestration-heuristics.md) — when to invoke 1 vs 4 vs 7 roles; parallel vs sequential dispatch.
- [`playbooks/multi-role-review.md`](playbooks/multi-role-review.md) — plain-language companion to the skill.
- [`playbooks/feedback-ritual.md`](playbooks/feedback-ritual.md) — weekly `/extract-lesson` cadence.
- [`examples/sample-session.md`](examples/sample-session.md) — two annotated sessions (4-role dispatcher review + PM-orchestrated launch).
- [`ROADMAP.md`](ROADMAP.md) — status and what's pending before v1.
- [`ATTRIBUTION.md`](ATTRIBUTION.md) — the expert sources the methodology incorporates.

---

## License

[MIT](LICENSE). Hornero's synthesis, structure, and prose are MIT-licensed. Frameworks incorporated from named authors (see each role's `sources.md` and [`ATTRIBUTION.md`](ATTRIBUTION.md)) remain the intellectual property of their respective authors and publishers.
