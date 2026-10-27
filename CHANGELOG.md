# Changelog

All notable changes to Hornero are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Plugin version is anchored in `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`.

## [Unreleased]

### Fixed

- Four skills (`prep`, `hypothesis-track`, `stakeholder-update`, `customer-update`), the `/hypothesis-track` command and the `github` resource card had unquoted `description:` values containing `: `, which is invalid YAML; Claude Code loaded them with empty metadata. Descriptions are now double-quoted.
- `repository` in both plugin manifests is a string, as `claude plugin validate` requires.
- Dead links to `skills/multi-role-review` and to roles that were never shipped (`software-engineer`, `data-scientist`, `tester`, `designer`, `security-expert`, `marketing-expert`) removed or reworded as plain "future role" prose; stale `../../` links in `commands/` and three renamed-file links corrected.
- `templates/settings.json` hooks use the real Claude Code shape (`matcher` plus `hooks[]`, `tool_input.file_path` read from stdin via `jq`); invented `CLAUDE_TOOL_FILE_PATH`, `effortLevel` and `skipAutoPermissionPrompt` keys removed.
- Generated Codex agent TOMLs no longer carry `sandbox_mode` (Codex ignores it in custom agents); they set `model_reasoning_effort = "medium"` instead. `AGENTS.md` uses `agents.max_concurrent_threads_per_session`.
- ROADMAP skill counts corrected to 38 product-manager and 16 cross-role skills.

### Changed

- `evals/judge.py` and `evals/README.md` default judge models are now `claude-sonnet-5-5`, `gpt-5` (unverified) and `gemini-2.5-pro`; the README no longer claims 7 roles.
- `orchestrate` and `cross-functional-orchestration` state that only `product-manager-reviewer` exists today and that the orchestrator covers unshipped lenses itself.
- `catalog.sh` and `build-codex-agents.sh` strip surrounding double quotes from frontmatter values.
- ROADMAP "Releases" section replaced by a pointer to this file.

### Added

- `validate-skill.sh` fails on unquoted `name`/`description` values containing `: ` or starting with a YAML indicator, fails on descriptions over 1024 characters, and warns over 500 lines; covered by `scripts/test-validate-skill.sh`.
- `scripts/check-md-links.sh` (with `test-check-md-links.sh`) fails on broken relative Markdown links.
- `smoke-check.sh` runs `claude plugin validate` on a dereferenced copy of the repo (skipped when the CLI is absent) and the link check; CI installs the CLI and runs the new tests.
- This changelog.

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
