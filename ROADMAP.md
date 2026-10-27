# Roadmap

Where Hornero is, what's queued, and what's on the horizon — plus a record of shipped releases.

## Now

What's available and stable today.

### The product-manager role

One role, `product-manager`, carrying **38 expert-grounded skills**:

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

- **16 cross-role process skills** for the harness itself: `spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `decision-record`, `memory-query`, `chronicle-record`, `chronicle-recall`, `ingest`, `prep`, `review`, `hypothesis-track`, `stakeholder-update`, `customer-update`, `query-issue-tracker`, `query-warehouse`. `extract-lesson` runs automatically on the Stop hook (`hooks/auto-extract-lesson.sh`) — proposes durable harness updates at session end without the user invoking it. The three append-shaped skills (hypothesis-track, stakeholder-update, customer-update) drive the chronicle layer's [append exception](chronicle/SCHEMA.md#append-exception): they grow whitelisted body sections row-by-row without forcing a full supersede.
- **`product-manager-reviewer`** subagent in [`agents/`](agents/), callable by name on either host (Claude Code via the Agent tool; Codex via its native subagent path).
- **12 slash commands**, all skills under [`skills/`](skills/) (`type: command` for the first five): `/orchestrate`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`, `/ingest`, `/prep`, `/review`, `/hypothesis-track`, `/stakeholder-update`, `/customer-update`.
- **Chronicle layer** — machine-queryable record of decisions (`scripts/chronicle.sh`, deterministic harness at `tests/chronicle/`).
- **Voice** — [`VOICE.md`](VOICE.md) codifies the companion's voice (calm, terse, plain-spoken; bird metaphor → patient layers + duet). Applies to lifecycle touchpoints only (banner, kickoff, declared route, lesson-extraction). Artefact outputs (PRDs, OKRs, strategy kernels) stay voice-neutral.
- **Memory layer (v0)** — project-local `memory/decisions/`, paired with `memory-query` + `decision-record`. Opt-in; absent directory → no-op.
- **Resources layer** — `resources/<system>/RESOURCE.md` cards describing external data sources. Six stable: `linear`, `github`, `jira`, `bigquery`, `snowflake`, `hubspot`. Plus claude.ai-native integrations stable: `canva`, `gmail`, `google-calendar`, `google-drive`, `intercom`. Stretch: `datadog`, `notion`, `slack`. Skills opt in via `resources:` frontmatter; the `mcpServers` block in `.claude-plugin/plugin.json` lists each entry as `optional: true` so Hornero stays usable when nothing is configured. Cross-system read primitives ship as cross-role skills: `query-issue-tracker` (Linear / Jira) and `query-warehouse` (BigQuery / Snowflake, with kill-cost guardrail).

### Plumbing

- **Flat skills layout** — every skill is a real directory at `skills/<name>/` (role membership is a `role:` frontmatter key; slash commands are `type: command` skills). No symlink generator; `.claude/skills` points at `skills/` for project-level discovery.
- **Vendor-agnostic plugin parity** — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` sibling manifests; reviewer subagents available as `agents/<name>.md` (Claude) and auto-generated `.codex/agents/<name>.toml` (Codex). `install.sh --claude / --codex / --both` for global installs.
- **CI self-breakage guard** — `validate-skill`, `validate-resource`, `test-validate-resource`, `smoke-check` on every PR; opt-in local pre-commit mirror via `scripts/install-git-hooks.sh`.
- **Antagonistic reviewer harness** — `scripts/play-against.sh --check` for catastrophic-persona-drift regression on the PM reviewer.

## Next

Queued for active work — measured in weeks, not quarters.

### First non-PM role (software-engineer)

Land `roles/software-engineer/` with the seed skills `adr`, `rfc`, `refactor-plan`, `tdd-discipline`, plus `agents/software-engineer-reviewer.md`. This is the smallest meaningful expansion and re-activates `/orchestrate` fan-out across two reviewers.

### Non-engineer reach validation

Graduate `[~]` → `[x]` after one designer and one marketer pass the three-criterion bar (reach / recognition / continuation) following a test protocol (not yet written).

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

Follow-on now that `hypothesis-track` is shipped: `skills/bet-portfolio/SKILL.md` becomes an aggregator over open `type: hypothesis` chronicle entries instead of a standalone artifact. Waits on enough real-chronicle hypothesis content to design the aggregation against.

### Distribution

- **Marketplace submission** for both Claude Code and Codex (manifests already ship — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`).
- **Publish as `npx hornero init`** for one-step setup in any repo.

### Infrastructure

- Consolidate awk-based YAML parsing into a shared `scripts/lib/yaml.{sh,py}` or shell out to `python3 -c "import yaml"` (the TOML side already uses Python `tomllib`).
- Tighten `used_by:` role-prefix validation beyond file existence.

## Releases

See [`CHANGELOG.md`](CHANGELOG.md).
