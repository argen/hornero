# Changelog

All notable changes to Hornero are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Plugin version is anchored in `.claude-plugin/plugin.json` and the root `plugin.json`.

## [Unreleased]

### Changed

- `prd`, `positioning-statement`, `success-metrics`, `strategy-kernel`, `bet-portfolio` and `cross-functional-orchestration` carry an Output discipline block: each finding names its framework and author, at least one trade-off is stated, and the response ends with one to three concrete next actions. Artifact eval cases went from 0.40-0.60 to 0.86-1.00.

### Added

- `claude plugin eval` suite under `evals/cases/`: 25 routing cases (one per natural-language row of `tests/dispatcher/routes.tsv`, graded on the skill that fired) and 7 PM-lens artifact cases with an `llm` quality grader. `validate-dispatcher.sh` Check 4 keeps routes.tsv and the routing cases in sync.
- `EVAL_HORNERO_NO_AUTO_EXTRACT=1` opt-out in `hooks/auto-extract-lesson.sh`, set by every eval case so the Stop hook's extra lesson turn does not alter graded output.
- `.github/workflows/evals.yml`: opt-in (`workflow_dispatch` plus weekly) eval run; needs the `ANTHROPIC_API_KEY` secret. `ci.yml` does not run evals.

### Changed

- Artifact eval cases split the single `quality.md` grader into `q-sources`, `q-distinct`, `q-tradeoff` and `q-actionable` (plus `q-decision` for the launch plan), so a case passes at 0.8 with one criterion missing and shows which one.

### Removed

- `evals/judge.py`, `evals/score.sh`, `evals/tasks/` and `evals/runs/` (bespoke human and LLM dual-scoring flow that was never run); `evals/rubric.md` now feeds the llm graders and `evals/EVAL-REPORT.md` is kept as history.

### Fixed

- Eval fixtures: the chronicle routing cases now seed a `chronicle/` project and `scripts/chronicle.sh` via `seed-chronicle.sh` (run with `--scaffold`, which CI and the README commands now pass); the positioning-statement, saas-revenue-growth-metrics and saas-economics-efficiency-metrics routing cases carry their artifact or metrics inline; `success-metrics` description now covers critiquing an existing metric definition.
- Four skills (`prep`, `hypothesis-track`, `stakeholder-update`, `customer-update`), the `/hypothesis-track` command and the `github` resource card had unquoted `description:` values containing `: `, which is invalid YAML; Claude Code loaded them with empty metadata. Descriptions are now double-quoted.
- `repository` in both plugin manifests is a string, as `claude plugin validate` requires.
- Dead links to `skills/multi-role-review` and to roles that were never shipped (`software-engineer`, `data-scientist`, `tester`, `designer`, `security-expert`, `marketing-expert`) removed or reworded as plain "future role" prose; stale `../../` links in `commands/` and three renamed-file links corrected.
- `templates/settings.json` hooks use the real Claude Code shape (`matcher` plus `hooks[]`, `tool_input.file_path` read from stdin via `jq`); invented `CLAUDE_TOOL_FILE_PATH`, `effortLevel` and `skipAutoPermissionPrompt` keys removed.
- Generated Codex agent TOMLs no longer carry `sandbox_mode` (Codex ignores it in custom agents); they set `model_reasoning_effort = "medium"` instead. `AGENTS.md` uses `agents.max_concurrent_threads_per_session`.
- ROADMAP skill counts corrected to 38 product-manager and 16 cross-role skills.

### Changed

- Per-role skills moved from `roles/<role>/skills/<name>/` to `skills/<name>/`; every skill is now a real directory and role membership is the `role:` frontmatter key (38 skills carry `role: product-manager`). `roles/<role>/` keeps `ROLE.md` and `sources.md`. All path references and relative links across the docs are rewritten.
- `catalog.sh` groups skills by `role:` and lists `type: command` skills under a new "Slash commands" section; `smoke-check.sh` step 7 now fails on any symlink under `skills/` or a `role:` with no `roles/<role>/ROLE.md`.
- Slash commands are skills (`type: command`); the invocation syntax, argument handling, and route-declaration lines of the six commands that shadowed same-named skills (`review`, `prep`, `ingest`, `hypothesis-track`, `stakeholder-update`, `customer-update`) plus `extract-lesson` now live in each skill's Application section, with `argument-hint:` where they take arguments.
- `validate-skill.sh` exempts `type: command` skills from the six-section anatomy (they still need `name`, `description`, `type`).
- `install.sh` installs every file of each skill directory and uses flat skill names (no `<role>-` prefix); `--dry-run` counts and the DISPATCHER loading table follow the new layout.
- `skills/competitive-teardown/SKILL.md` split: the worked example moved to `examples.md`, bringing it under the 500-line warning.
- `evals/judge.py` and `evals/README.md` default judge models are now `claude-sonnet-5-5`, `gpt-5` (unverified) and `gemini-2.5-pro`; the README no longer claims 7 roles.
- `orchestrate` and `cross-functional-orchestration` state that only `product-manager-reviewer` exists today and that the orchestrator covers unshipped lenses itself.
- `catalog.sh` and `build-codex-agents.sh` strip surrounding double quotes from frontmatter values.
- ROADMAP "Releases" section replaced by a pointer to this file.
- `install.sh --codex` installs skills to the shared `~/.agents/skills/` path (agents and hooks stay under `~/.codex/`) and points to `npx skills add argen/hornero` as the lighter path.
- `smoke-check.sh` step 8 compares root `plugin.json` against `.claude-plugin/plugin.json` (name, version, `extensions["com.openai"]` present) and checks `mcp.json` server names against the Claude manifest (none declared today, so no `mcp.json` ships).
- README install sections lead with the marketplace flows; counts now read 59 skills (38 PM, 16 cross-role, 5 command skills; 12 slash-invocable) in the README and plugin descriptions.
- Descriptions of 15 skills in the finance, problem-framing, memory, discovery, and strategy clusters state what they produce, when to use them, and which sibling to use instead.
- ROADMAP Distribution: marketplace files ship; public Codex directory submission is blocked because plugins that ship hooks are ineligible.

### Added

- `.claude-plugin/marketplace.json`: `/plugin marketplace add argen/hornero` then `/plugin install hornero@hornero`.
- Portable root `plugin.json` (Agent Plugins standard) with Codex settings under `extensions["com.openai"]` (display name, default prompts, `kickoff` as the onboarding skill), and `.agents/plugins/marketplace.json` for the Codex repo marketplace.
- skills.sh install path (`npx skills add argen/hornero`); a local `npx skills add` run discovered all 59 skills.
- `.claude/rules/skills.md`, a path-scoped rule (`skills/**`, `roles/**`, `resources/**`) with the validate-skill, catalog, and validate-resource reminders.
- `allowed-tools: Read, Grep, Glob, Bash(scripts/chronicle.sh *)` on `chronicle-recall`, `prep`, and `review`.
- Stop hook `timeout` (30s) and `statusMessage`; `_comment` notes Claude Code's cap of 8 consecutive Stop-hook continuations.
- `skills/{orchestrate,role,kickoff,catalog,audit}/SKILL.md` as `type: command` skills (`kickoff`, `catalog`, `audit`, `role` set `disable-model-invocation: true`; `orchestrate` stays model-invocable because the dispatcher routes to it).
- `.claude/skills -> ../skills` so a session opened at the repo root discovers every skill without the plugin or `install.sh`; `.gitignore` un-ignores it.
- `validate-skill.sh` fails on unquoted `name`/`description` values containing `: ` or starting with a YAML indicator, fails on descriptions over 1024 characters, and warns over 500 lines; covered by `scripts/test-validate-skill.sh`.
- `scripts/check-md-links.sh` (with `test-check-md-links.sh`) fails on broken relative Markdown links.
- `smoke-check.sh` runs `claude plugin validate` on a dereferenced copy of the repo (skipped when the CLI is absent) and the link check; CI installs the CLI and runs the new tests.
- This changelog.
- Hardening of the new checks: `validate-skill.sh` also rejects unquoted values with `:<TAB>`, a trailing `:`, a leading `-`/`?`/`,`/`]`/`}`, a ` #` comment start, or an unclosed quote; `check-md-links.sh` ignores inline code spans and `~~~` fences, skips any URI scheme and accepts `<angle>` targets; `smoke-check.sh` validates a tracked-files-only dereferenced copy and no longer aborts on missing validator output; CI pins the Claude Code CLI to 2.1.311 with the auto-updater disabled.

### Upgrading

- `install.sh` now prunes files the previous install recorded in `.hornero-manifest` that the new install does not write (old `~/.claude/commands/*.md`, `~/.codex/prompts/*.md`, `~/.claude/skills/<role>-<skill>/`), honouring `--dry-run`; run `./install.sh` again to clean up. Files that are not hidden (dotfiles under `skills/`) are no longer installed.

### Removed

- `.codex-plugin/plugin.json`, superseded by the root `plugin.json`.
- `commands/` and the `.claude/commands` symlink (superseded by skills), and `scripts/build-plugin-skills.sh` (no symlinks left to generate).
- `install.sh` no longer copies to `~/.claude/commands` or `~/.codex/prompts`; skills replace both. Claude Code users type `/<name>`. Codex has no `disable-model-invocation` and no prompts directory here, so a Codex user invokes a skill explicitly by typing `$` or using `/skills` to mention it (for example `$orchestrate`), or implicitly by describing the task in natural language.

## [0.3.0] - 2026-05

PM skill expansion, conversational kickoff, automatic lesson extraction, a voice for the companion, present-focused docs.

- **A voice for the companion** — [`VOICE.md`](VOICE.md) codifies the personality (calm, terse, plain-spoken, no preening) grounded in the rufous hornero's traits (patient layers, duet, ground-level walk, comfortable around humans). Six touchpoints rewritten to land the voice: SessionStart banner, `/kickoff` opener, dispatcher's declared one-liner, Stop-hook "nothing to capture" line, `/catalog` footer, README microcopy. `CLAUDE.md` + `AGENTS.md` reference `VOICE.md` on first dispatch. Artefact outputs (PRDs, OKRs, etc.) stay voice-neutral so they travel cleanly to stakeholders.
- **Automatic lesson extraction** — `hooks/auto-extract-lesson.sh` wires the Stop hook to fire the extract-lesson skill at every session end without the user having to type `/extract-lesson`. The agent self-filters via Chris MDP's signal-vs-noise discipline (most sessions stop in one line; only ones with real signal produce proposals). Re-stop loop prevented via `stop_hook_active`. Opt-out: `HORNERO_NO_AUTO_EXTRACT=1`. Plugin hook, install.sh recommendation, and `templates/settings.json` all updated.
- **Docs reorientation** — canonical docs (README, ROADMAP, methodology, ATTRIBUTION, DISPATCHER, CLAUDE, AGENTS, CONTRIBUTING, roles/README, onboarding, role-cheatsheet, adoption, commands/role) now lead with present capabilities rather than the journey. README opens with a "What you get" section; ROADMAP adopts Now / Next / Later + Releases.
- **Conversational kickoff** — `/kickoff` no longer asks one question and offers a 7-item bulleted menu; it opens with a 3-sentence intro and a single open invitation, then routes via the dispatcher. `DISPATCHER.md` gains Step 6b (ambiguous-but-rich → one clarifying question, never a menu). SessionStart banner names natural language first; slash commands as alternatives.
- **PM skill expansion** — 22 new PM skills in four commits, re-synthesised from [Dean Peters' Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) (CC BY-NC-SA 4.0 source; Hornero's re-synthesis is MIT). New themes: career/leadership (4), AI-PM (2), discovery extensions (3), outside-in (3), workshops + delivery (3), finance (7). Total PM skills 15 → 37; total skills 21 → 45.

## [0.2.0]

- **Antagonistic role-reviewer E2E (PM)** — `scripts/play-against.sh --check` runs the PM positive case + PM negative control via `expect` against the real interactive `claude` CLI; transcripts persisted to `tests/seeded/last-run/` on every run for spot-checking. Coarse regression net for catastrophic persona drift.
- **CI self-breakage guard** — `.github/workflows/ci.yml` runs `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` on every PR. Opt-in local mirror via `scripts/install-git-hooks.sh`. Catches stale `CATALOG.md`, frontmatter contract violations, and skill↔resource cross-ref breaks before merge.
- **Resources layer (PR 1 — foundation)** — new top-level `resources/<system>/RESOURCE.md` cards describing external data sources (object model, MCP server, gotchas, fallback). Skills opt in via `resources: [<slug>]` frontmatter. Ships `resources/linear/` and the `linear-triage` consuming skill; `scripts/validate-resource.sh` enforces anatomy; `smoke-check.sh` gains bidirectional skill↔resource cross-ref. Hornero stays usable when no MCP server is configured (graceful degradation via documented fallback paths). PR #24.
- **Vendor-agnostic plugin parity** — Hornero loads at full fidelity on both Claude Code and Codex from a single source-of-truth. `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` sibling manifests; reviewer subagents available as `agents/<name>.md` (Claude) and auto-generated `.codex/agents/<name>.toml` (Codex) via `scripts/build-codex-agents.sh`; `install.sh --codex` installs skills + agents + hooks + commands. PR #23.
- **Plugin packaging (Claude Code)** — `.claude-plugin/plugin.json` manifest, top-level `skills/<name>/SKILL.md` symlinks (auto-built by `scripts/build-plugin-skills.sh`), plugin-loadable session hooks. PRs #20, #21.
- **Blog-alignment series** (PRs #18–#19) — guardrail hooks in `templates/settings.json`, `templates/sub-CLAUDE.md.template` + `playbooks/claude-md-layering.md`, explore/edit separation made explicit in `DISPATCHER.md`, `templates/MAP.md.template`, `/audit` slash command + `playbooks/skill-rot-review.md` (quarterly cadence), `playbooks/adoption.md` (DRI + cross-functional working group + approval process).
- **Memory layer v0** — project-local memory layer at `memory/decisions/` shipped as the third Hornero primitive. Two new cross-role skills: [`memory-query`](skills/memory-query/SKILL.md) and [`decision-record`](skills/decision-record/SKILL.md). [`playbooks/memory-loop.md`](playbooks/memory-loop.md) walks the read-decide-write cycle end-to-end. Distinct from `adr` (architecture-shaped) and `prd` (feature-shaped) — `decision-record` captures cross-role posture-shaping calls. Opt-in per project; absent `memory/decisions/` directory → no-op behaviour.
- **Chronicle layer** — machine-queryable record of decisions any future session or role can load as situational awareness. Influenced by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — same lifecycle, simpler substrate (Markdown-with-strict-frontmatter, deterministic harness, no embedder dependency). Two cross-role skills: `chronicle-record` (write side, calls `scripts/chronicle.sh propose` — LLM-free; human commits) and `chronicle-recall` (read side, byte-identical output for a given corpus). Deterministic harness at `tests/chronicle/` backs the layer.
