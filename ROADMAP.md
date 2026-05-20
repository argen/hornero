# Roadmap

Where Hornero is, what's queued, and what's on the horizon — plus a record of shipped releases.

## Now

What's available and stable today.

### The product-manager role

One role, `product-manager`, carrying **37 expert-grounded skills**:

- **Discovery** — interview prep + synthesis, JTBD, problem framing, opportunity-solution trees, proto-personas, journey maps.
- **Strategy** — strategy kernel, bet portfolio, PRDs, OKRs, prioritisation, success metrics, competitive teardown, revenue architecture.
- **Positioning + GTM** — positioning statement, Amazon-style press release.
- **AI-PM** — AI-shaped readiness self-diagnostic, context-engineering advisor.
- **Finance literacy** — SaaS revenue/growth + efficiency metrics, finance quick-ref, TAM/SAM/SOM, feature-investment advisor, finance-based pricing advisor, business-health diagnostic.
- **Outside-in** — PESTEL, structured company research, acquisition-channel advisor.
- **Workshops + delivery** — workshop facilitation, user story mapping.
- **Career + leadership** — altitude/horizon framework, director-readiness advisor, executive-onboarding playbook, product-sense interview answer.
- **Operations + orchestration** — Linear triage, cross-functional orchestration (the marquee `/orchestrate` skill).

### Harness primitives

- **11 cross-role process skills** for the harness itself: `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`, `chronicle-record`, `chronicle-recall`, `hypothesis-track`, `stakeholder-update`, `customer-update`. `extract-lesson` runs automatically on the Stop hook (`hooks/auto-extract-lesson.sh`) — proposes durable harness updates at session end without the user invoking it. The three append-shaped skills (hypothesis-track, stakeholder-update, customer-update) drive the chronicle layer's [append exception](chronicle/SCHEMA.md#append-exception): they grow whitelisted body sections row-by-row without forcing a full supersede.
- **`product-manager-reviewer`** subagent in [`agents/`](agents/), callable by name on either host (Claude Code via the Agent tool; Codex via its native subagent path).
- **12 slash commands** in [`.claude/commands/`](.claude/commands/): `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`, `/ingest`, `/prep`, `/review`, `/hypothesis-track`, `/stakeholder-update`, `/customer-update`.
- **Chronicle layer** — machine-queryable record of decisions (`scripts/chronicle.sh`, deterministic harness at `tests/chronicle/`).
- **Voice** — [`VOICE.md`](VOICE.md) codifies the companion's voice (calm, terse, plain-spoken; bird metaphor → patient layers + duet). Applies to lifecycle touchpoints only (banner, kickoff, declared route, lesson-extraction). Artefact outputs (PRDs, OKRs, strategy kernels) stay voice-neutral.
- **Memory layer (v0)** — project-local `memory/decisions/`, paired with `memory-query` + `decision-record`. Opt-in; absent directory → no-op.
- **Resources layer** — `resources/<system>/RESOURCE.md` cards describing external data sources. Six stable: `linear`, `github`, `jira`, `bigquery`, `snowflake`, `hubspot`. Plus claude.ai-native integrations stable: `canva`, `gmail`, `google-calendar`, `google-drive`, `intercom`. Stretch: `datadog`, `notion`, `slack`. Skills opt in via `resources:` frontmatter; the `mcpServers` block in `.claude-plugin/plugin.json` lists each entry as `optional: true` so Hornero stays usable when nothing is configured. Cross-system read primitives ship as cross-role skills: `query-issue-tracker` (Linear / Jira) and `query-warehouse` (BigQuery / Snowflake, with kill-cost guardrail).

### Plumbing

- **Vendor-agnostic plugin parity** — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` sibling manifests; reviewer subagents available as `agents/<name>.md` (Claude) and auto-generated `.codex/agents/<name>.toml` (Codex). `install.sh --claude / --codex / --both` for global installs.
- **CI self-breakage guard** — `validate-skill`, `validate-resource`, `test-validate-resource`, `smoke-check` on every PR; opt-in local pre-commit mirror via `scripts/install-git-hooks.sh`.
- **Antagonistic reviewer harness** — `scripts/play-against.sh --check` for catastrophic-persona-drift regression on the PM reviewer.

## Next

Queued for active work — measured in weeks, not quarters.

### First non-PM role (software-engineer)

Land `roles/software-engineer/` with the seed skills `adr`, `rfc`, `refactor-plan`, `tdd-discipline`, plus `agents/software-engineer-reviewer.md`. This is the smallest meaningful expansion and re-activates `/orchestrate` fan-out across two reviewers.

### Non-engineer reach validation

Graduate `[~]` → `[x]` after one designer and one marketer pass the three-criterion bar (reach / recognition / continuation) following [`playbooks/test-protocol-non-engineer-reach.md`](playbooks/test-protocol-non-engineer-reach.md).

## Later

Speculative or sequenced behind Next.

### Additional roles

After `software-engineer`, the intended order, lightest first:

1. **tester** — `test-plan`, `regression-test`, `exploratory-charter`, `pre-release-test-pass`.
2. **designer** — `state-audit`, `accessibility-audit`, `heuristic-review`, `design-review`.
3. **security-expert** — `threat-model`, `security-review`, `llm-risk-assessment`, `pre-launch-security-audit`.
4. **marketing-expert** — `positioning-canvas`, `strategic-narrative`, `launch-brief`, `pre-launch-marketing-audit`.
5. **data-scientist** — `metric-definition`, `experiment-design`, `causal-dag`, `pre-launch-measurement-audit`.

When a second role lands, the parallel `multi-role-review` path activates (parallel critique needs ≥2 lenses to be meaningful).

### Resources layer — PR 3 (stretch + dispatcher wiring)

- Stretch resource cards (`status: stretch`): `resources/{sentry,datadog,grafana,slack,notion}/RESOURCE.md`.
- `interview-synthesis` frontmatter opt-in: `resources: [notion]`.
- New `scripts/probe-mcp.sh`: reads configured MCP servers and cross-references against `resources/*/RESOURCE.md` slugs.
- `hooks/hooks.json` SessionStart wired to the probe.
- `DISPATCHER.md` amendment: orchestrator passes the resources line to each fan-out subagent.
- `templates/{CLAUDE,AGENTS,MAP,sub-CLAUDE}.md.template` gain a `data-sources` convention.
- `smoke-check.sh`: every stretch resource has a non-empty `## Fallback Without MCP` section.

### Bet-portfolio refactor (PM)

Follow-on now that `hypothesis-track` is shipped: `roles/product-manager/skills/bet-portfolio/SKILL.md` becomes an aggregator over open `type: hypothesis` chronicle entries instead of a standalone artifact. Waits on enough real-chronicle hypothesis content to design the aggregation against.

### Distribution

- **Marketplace submission** for both Claude Code and Codex (manifests already ship — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`).
- **Publish as `npx hornero init`** for one-step setup in any repo.

### Infrastructure

- Consolidate awk-based YAML parsing into a shared `scripts/lib/yaml.{sh,py}` or shell out to `python3 -c "import yaml"` (the TOML side already uses Python `tomllib`).
- Tighten `used_by:` role-prefix validation beyond file existence.

## Releases

Plugin version anchored in `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`. Newest first.

### v0.3.0 — 2026-05

PM skill expansion, conversational kickoff, automatic lesson extraction, a voice for the companion, present-focused docs.

- **A voice for the companion** — [`VOICE.md`](VOICE.md) codifies the personality (calm, terse, plain-spoken, no preening) grounded in the rufous hornero's traits (patient layers, duet, ground-level walk, comfortable around humans). Six touchpoints rewritten to land the voice: SessionStart banner, `/kickoff` opener, dispatcher's declared one-liner, Stop-hook "nothing to capture" line, `/catalog` footer, README microcopy. `CLAUDE.md` + `AGENTS.md` reference `VOICE.md` on first dispatch. Artefact outputs (PRDs, OKRs, etc.) stay voice-neutral so they travel cleanly to stakeholders.
- **Automatic lesson extraction** — `hooks/auto-extract-lesson.sh` wires the Stop hook to fire the extract-lesson skill at every session end without the user having to type `/extract-lesson`. The agent self-filters via Chris MDP's signal-vs-noise discipline (most sessions stop in one line; only ones with real signal produce proposals). Re-stop loop prevented via `stop_hook_active`. Opt-out: `HORNERO_NO_AUTO_EXTRACT=1`. Plugin hook, install.sh recommendation, and `templates/settings.json` all updated.
- **Docs reorientation** — canonical docs (README, ROADMAP, methodology, ATTRIBUTION, DISPATCHER, CLAUDE, AGENTS, CONTRIBUTING, roles/README, onboarding, role-cheatsheet, adoption, commands/role) now lead with present capabilities rather than the journey. README opens with a "What you get" section; ROADMAP adopts Now / Next / Later + Releases.
- **Conversational kickoff** — `/kickoff` no longer asks one question and offers a 7-item bulleted menu; it opens with a 3-sentence intro and a single open invitation, then routes via the dispatcher. `DISPATCHER.md` gains Step 6b (ambiguous-but-rich → one clarifying question, never a menu). SessionStart banner names natural language first; slash commands as alternatives.
- **PM skill expansion** — 22 new PM skills in four commits, re-synthesised from [Dean Peters' Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) (CC BY-NC-SA 4.0 source; Hornero's re-synthesis is MIT). New themes: career/leadership (4), AI-PM (2), discovery extensions (3), outside-in (3), workshops + delivery (3), finance (7). Total PM skills 15 → 37; total skills 21 → 45.

### v0.2.0 — foundation

- **Antagonistic role-reviewer E2E (PM)** — `scripts/play-against.sh --check` runs the PM positive case + PM negative control via `expect` against the real interactive `claude` CLI; transcripts persisted to `tests/seeded/last-run/` on every run for spot-checking. Coarse regression net for catastrophic persona drift.
- **CI self-breakage guard** — `.github/workflows/ci.yml` runs `validate-skill`, `validate-resource`, `test-validate-resource`, and `smoke-check` on every PR. Opt-in local mirror via `scripts/install-git-hooks.sh`. Catches stale `CATALOG.md`, frontmatter contract violations, and skill↔resource cross-ref breaks before merge.
- **Resources layer (PR 1 — foundation)** — new top-level `resources/<system>/RESOURCE.md` cards describing external data sources (object model, MCP server, gotchas, fallback). Skills opt in via `resources: [<slug>]` frontmatter. Ships `resources/linear/` and the `linear-triage` consuming skill; `scripts/validate-resource.sh` enforces anatomy; `smoke-check.sh` gains bidirectional skill↔resource cross-ref. Hornero stays usable when no MCP server is configured (graceful degradation via documented fallback paths). PR #24.
- **Vendor-agnostic plugin parity** — Hornero loads at full fidelity on both Claude Code and Codex from a single source-of-truth. `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` sibling manifests; reviewer subagents available as `agents/<name>.md` (Claude) and auto-generated `.codex/agents/<name>.toml` (Codex) via `scripts/build-codex-agents.sh`; `install.sh --codex` installs skills + agents + hooks + commands. PR #23.
- **Plugin packaging (Claude Code)** — `.claude-plugin/plugin.json` manifest, top-level `skills/<name>/SKILL.md` symlinks (auto-built by `scripts/build-plugin-skills.sh`), plugin-loadable session hooks. PRs #20, #21.
- **Blog-alignment series** (PRs #18–#19) — guardrail hooks in `templates/settings.json`, `templates/sub-CLAUDE.md.template` + `playbooks/claude-md-layering.md`, explore/edit separation made explicit in `DISPATCHER.md`, `templates/MAP.md.template`, `/audit` slash command + `playbooks/skill-rot-review.md` (quarterly cadence), `playbooks/adoption.md` (DRI + cross-functional working group + approval process).
- **Memory layer v0** — project-local memory layer at `memory/decisions/` shipped as the third Hornero primitive. Two new cross-role skills: [`memory-query`](skills/memory-query/SKILL.md) and [`decision-record`](skills/decision-record/SKILL.md). [`playbooks/memory-loop.md`](playbooks/memory-loop.md) walks the read-decide-write cycle end-to-end. Distinct from `adr` (architecture-shaped) and `prd` (feature-shaped) — `decision-record` captures cross-role posture-shaping calls. Opt-in per project; absent `memory/decisions/` directory → no-op behaviour.
- **Chronicle layer** — machine-queryable record of decisions any future session or role can load as situational awareness. Influenced by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — same lifecycle, simpler substrate (Markdown-with-strict-frontmatter, deterministic harness, no embedder dependency). Two cross-role skills: `chronicle-record` (write side, calls `scripts/chronicle.sh propose` — LLM-free; human commits) and `chronicle-recall` (read side, byte-identical output for a given corpus). Deterministic harness at `tests/chronicle/` backs the layer.
