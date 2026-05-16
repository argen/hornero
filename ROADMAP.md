# Roadmap

Where Hornero is, and what's next.

## What's available

Hornero ships **one role** — `product-manager` — carrying **37 expert-grounded skills** across:

- **Discovery** — interview prep + synthesis, JTBD, problem framing, opportunity-solution trees, proto-personas, journey maps.
- **Strategy** — strategy kernel, bet portfolio, PRDs, OKRs, prioritisation, success metrics, competitive teardown, revenue architecture.
- **Positioning + GTM** — positioning statement, Amazon-style press release.
- **AI-PM** — AI-shaped readiness self-diagnostic, context-engineering advisor.
- **Finance literacy** — SaaS revenue/growth + efficiency metrics, finance quick-ref, TAM/SAM/SOM, feature-investment advisor, finance-based pricing advisor, business-health diagnostic.
- **Outside-in** — PESTEL, structured company research, acquisition-channel advisor.
- **Workshops + delivery** — workshop facilitation, user story mapping.
- **Career + leadership** — altitude/horizon framework, director-readiness advisor, executive-onboarding playbook, product-sense interview answer.
- **Operations + orchestration** — Linear triage, cross-functional orchestration (the marquee `/orchestrate` skill).

Plus **8 cross-role process skills** for the harness itself: `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`, `chronicle-record`, `chronicle-recall`.

The **`product-manager-reviewer`** subagent ships in [`agents/`](agents/), callable by name on either host (Claude Code via the Agent tool; Codex via its native subagent path).

A **six-command slash surface** ships in [`.claude/commands/`](.claude/commands/): `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`.

The repo works as the project itself — clone, `cd`, run Claude Code or Codex. `install.sh` is optional, for users who want Hornero's skills and reviewer available globally across all projects. Plugin packaging is in place for both Claude Code and Codex.

## What's next

### Expanding role coverage

Hornero's harness — dispatcher protocol, reviewer-subagent fan-out, multi-host plugin packaging — is built to host multiple roles. Adding a role is a content drop-in (`roles/<role>/`, `agents/<role>-reviewer.md`, then run `scripts/build-plugin-skills.sh` + `scripts/build-codex-agents.sh` + `scripts/catalog.sh`).

The intended order, lightest first:

1. **software-engineer** — `adr`, `rfc`, `refactor-plan`, `tdd-discipline`. Re-enables `/orchestrate` fan-out against code-shaped decisions.
2. **tester** — `test-plan`, `regression-test`, `exploratory-charter`, `pre-release-test-pass`. Adds the seeded-flaw harness for a second persona.
3. **designer** — `state-audit`, `accessibility-audit`, `heuristic-review`, `design-review`. Adds the design-lens critique path.
4. **security-expert** — `threat-model`, `security-review`, `llm-risk-assessment`, `pre-launch-security-audit`. Adds pre-launch composition.
5. **marketing-expert** — `positioning-canvas`, `strategic-narrative`, `launch-brief`, `pre-launch-marketing-audit`. Adds GTM coverage.
6. **data-scientist** — `metric-definition`, `experiment-design`, `causal-dag`, `pre-launch-measurement-audit`. Closes the pre-launch quad.

When a second role lands, the parallel `multi-role-review` path reactivates (parallel critique needs ≥2 lenses to be meaningful).

### Resources layer — PR 2 (v1 expansion)

Build on the foundation (PR #24) by adding the remaining v1 resource cards and first cross-system skills:

- New `resources/{jira,bigquery,snowflake,hubspot}/RESOURCE.md` (`status: stable`).
- New cross-role skills: `skills/query-issue-tracker/SKILL.md` with `resources: [linear, jira]`; `skills/query-warehouse/SKILL.md` with `resources: [bigquery, snowflake]` (schema discovery, dry-run cost estimate, exploratory SQL with a kill-cost guardrail).
- New per-role skills: `roles/product-manager/skills/hubspot-pipeline-readout` (pipeline-stage health, deal velocity, ICP fit).
- Frontmatter opt-in on existing skills: `prd → [linear, jira]`, `decision-record → [github]`.
- `.claude-plugin/plugin.json` gains an `mcpServers` block with every v1 resource marked `optional: true`.
- `install.sh` learns to copy `resources/` to `~/.claude/hornero-resources/` + `--list-resources` flag.
- Risk to mitigate: don't over-genericise the cross-system skills — if `## Application` says "if Linear, X; if JIRA, Y" more than twice, split.

### Resources layer — PR 3 (stretch + dispatcher wiring)

Close the loop so reviewer subagents know what's available:

- Stretch resource cards (`status: stretch`): `resources/{sentry,datadog,grafana,slack,notion}/RESOURCE.md`.
- `interview-synthesis` frontmatter opt-in: `resources: [notion]`.
- New `scripts/probe-mcp.sh`: reads configured MCP servers and cross-references against `resources/*/RESOURCE.md` slugs.
- `hooks/hooks.json` SessionStart wired to the probe.
- `DISPATCHER.md` amendment: orchestrator passes the resources line to each fan-out subagent.
- `templates/{CLAUDE,AGENTS,MAP,sub-CLAUDE}.md.template` gain a `data-sources` convention.
- `smoke-check.sh`: every stretch resource has a non-empty `## Fallback Without MCP` section.

### Other tracks

- **Resources layer infrastructure** — consolidate awk-based YAML parsing into a shared `scripts/lib/yaml.{sh,py}`; tighten `used_by:` role-prefix validation beyond file existence.
- **Marketplace submission** for both vendors (manifests already ship — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`).
- **Publish as `npx hornero init`** for one-step setup in any repo.
- **Non-engineer reach** — graduate `[~]` → `[x]` after one designer and one marketer pass the three-criterion bar (reach / recognition / continuation). Test protocol shipped in [`playbooks/test-protocol-non-engineer-reach.md`](playbooks/test-protocol-non-engineer-reach.md); real-tester runs pending.

## Recently shipped

- **Conversational kickoff + PM skill expansion (2026-05)** — `/kickoff` no longer asks one question and offers a 7-item bulleted menu; it opens with a 3-sentence intro and a single open invitation, then routes via the dispatcher. `DISPATCHER.md` gained Step 6b (ambiguous-but-rich → one clarifying question, never a menu). 22 new PM skills landed: career/leadership (4), AI-PM (2), discovery extensions (3), outside-in (3), workshops + delivery (3), finance (7). Total PM skills 15 → 37; total skills 21 → 45.
- **Antagonistic role-reviewer E2E (PM)** — `scripts/play-against.sh --check` runs the PM positive case + PM negative control via `expect` against the real interactive `claude` CLI; transcripts persisted to `tests/seeded/last-run/` on every run for spot-checking. Coarse regression net for catastrophic persona drift.
- **CI self-breakage guard** — `.github/workflows/ci.yml` runs `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` on every PR. Opt-in local mirror via `scripts/install-git-hooks.sh`. Catches stale `CATALOG.md`, frontmatter contract violations, and skill↔resource cross-ref breaks before merge.
- **Resources layer (PR 1 — foundation)** — new top-level `resources/<system>/RESOURCE.md` cards describing external data sources (object model, MCP server, gotchas, fallback). Skills opt in via `resources: [<slug>]` frontmatter. Ships `resources/linear/` and the `linear-triage` consuming skill; `scripts/validate-resource.sh` enforces anatomy; `smoke-check.sh` gains bidirectional skill↔resource cross-ref. Hornero stays usable when no MCP server is configured (graceful degradation via documented fallback paths). PR #24.
- **Vendor-agnostic plugin parity** — Hornero loads at full fidelity on both Claude Code and Codex from a single source-of-truth. `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` sibling manifests; reviewer subagents available as `agents/<name>.md` (Claude) and auto-generated `.codex/agents/<name>.toml` (Codex) via `scripts/build-codex-agents.sh`; `install.sh --codex` installs skills + agents + hooks + commands. PR #23.
- **Plugin packaging (Claude Code)** — `.claude-plugin/plugin.json` manifest, top-level `skills/<name>/SKILL.md` symlinks (auto-built by `scripts/build-plugin-skills.sh`), plugin-loadable session hooks. PRs #20, #21.
- **Blog-alignment series** (PRs #18–#19) — guardrail hooks in `templates/settings.json`, `templates/sub-CLAUDE.md.template` + `playbooks/claude-md-layering.md`, explore/edit separation made explicit in `DISPATCHER.md`, `templates/MAP.md.template`, `/audit` slash command + `playbooks/skill-rot-review.md` (quarterly cadence), `playbooks/adoption.md` (DRI + cross-functional working group + approval process).
- **Memory layer v0** — project-local memory layer at `memory/decisions/` shipped as the third Hornero primitive (alongside per-session orchestration and across-session harness). Two new cross-role skills: [`memory-query`](skills/memory-query/SKILL.md) and [`decision-record`](skills/decision-record/SKILL.md). [`playbooks/memory-loop.md`](playbooks/memory-loop.md) walks the read-decide-write cycle end-to-end. [`methodology.md`](methodology.md) names memory as the third primitive. Distinct from `adr` (architecture-shaped) and `prd` (feature-shaped) — `decision-record` captures cross-role posture-shaping calls. Opt-in per project; absent `memory/decisions/` directory → no-op behaviour.
- **Chronicle layer** — machine-queryable record of decisions any future session or role can load as situational awareness. Influenced by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — same lifecycle, simpler substrate (Markdown-with-strict-frontmatter, deterministic harness, no embedder dependency). Two cross-role skills: `chronicle-record` (write side, calls `scripts/chronicle.sh propose` — LLM-free; human commits) and `chronicle-recall` (read side, byte-identical output for a given corpus). Deterministic harness at `tests/chronicle/` backs the layer.
