# Roadmap

Where Hornero is, and what's remaining before v1.

## Status

**v0 — under construction.** All seven roles (**software-engineer**, **tester**, **designer**, **security-expert**, **marketing-expert**, **product-manager**, **data-scientist**) ship `ROLE.md` + `sources.md` + first-draft skills. Cross-role process skills (`spec-the-problem`, `multi-role-review`, `extract-lesson`, `harness-check`, `context-reset-check`) are shipped. Seven reviewer subagent definitions (one per role) ship in [`agents/`](agents/). A small slash-command surface (`/orchestrate`, `/review`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`) ships in [`.claude/commands/`](.claude/commands/).

The repo works as the project itself — clone, `cd`, run Claude Code or Codex. `install.sh` is optional, for users who want Hornero's skills and agents available globally across all projects.

## Remaining before v1

### Content

- [x] **data-scientist role** — shipped: `metric-definition`, `experiment-design`, `causal-dag` (component) + `pre-launch-measurement-audit` (workflow, sibling to tester/security/marketing pre-launch audits). Four roles now ship a `pre-launch-*` workflow that `/orchestrate` (PM-led `cross-functional-orchestration`) can compose in parallel for a launch.
- [x] **product-manager workflow skill** — shipped as [`cross-functional-orchestration`](roles/product-manager/skills/cross-functional-orchestration/SKILL.md). Composes `multi-role-review` with PM framing (customer-job triage in front, outcomes-shaped decision synthesis behind). Surfaced as the marquee slash command `/orchestrate`.
- [x] **Dual-host (Claude + Codex) setup** — `AGENTS.md` ships alongside `CLAUDE.md`; both point at the same `CATALOG.md`, roles, skills, agents, and slash commands. `install.sh` supports `--claude` / `--codex` / `--both`.
- [~] **First editorial pass** — first sweep done on the 8 highest-traffic skills (`spec-the-problem`, `multi-role-review`, `tdd-discipline`, `cross-functional-orchestration`, and the four pre-launch siblings). Found surprisingly few issues — most are already cleanly cited and have concrete examples. The two real fixes: (1) tester's `pre-release-test-pass` recommendation shape aligned with the three other pre-launch siblings (`Go / Fix-then-go / Hold`) so the PM-orchestrator can compose all four with one mental model; (2) stale `(phase 3)` tags on shipped skills in `multi-role-review`'s References removed. Broader editorial pass on the remaining 21 skills still pending — the audit shape (one Explore agent surfaces issues, surgical edits follow) generalises cheaply.

### Templates and onboarding

- [x] **`templates/CLAUDE.md.template`** — TDD-skill path made concrete; PM-orchestrator pattern referenced for cross-functional decisions; named reviewer subagents listed for downstream teams to know what's callable by name.
- [x] **`templates/AGENTS.md.template`** — Hornero-vs-project `install.sh` clarified; full role roster + descriptions added to the multi-role-review section; "When in doubt" updated with `CATALOG.md` and named-subagent paths. (Renamed from `templates/AGENTS.md` when the root-level `AGENTS.md` Codex entry point was added.)
- [x] **`examples/sample-session.md`** refresh — two annotated sessions: a dispatcher-led 4-role review on a small feature (engineer + tester + designer + PM + data-scientist), and a PM-orchestrated launch composing the four pre-launch sibling workflows in parallel.
- [~] **`research/` folder** — seeded with software-engineer's 5 top-priority notes (Beck on TDD, Fowler on Refactoring, Ousterhout on Philosophy of Software Design, Metz on the Wrong Abstraction, Google SRE on production reliability) as proof-of-concept. Each note: ~100-150 lines following a consistent format (why-it-matters / key concepts / what-to-read-in-an-hour / what-to-skip / how-it-anchors-role-skills). Other 6 roles' notes follow the same pattern when needed.

### Verification

- [~] **20-sample eval** of `multi-role-review` — scaffolding shipped in `evals/`: rubric, interactive `score.sh` with aggregation, 8 starter tasks (engineer PR, PRD, RFC, PM-orchestrated launch, LLM threat-model, dashboard redesign, observational-causal-claim experiment readout, positioning canvas). The 8 tasks deliberately span all 7 roles, single-orchestrator and PM-orchestrator paths, and the four pre-launch sibling workflow composition. Running the 20 samples is the remaining half — needs human-judged scoring per [`evals/rubric.md`](evals/rubric.md).
- [~] **Clean-install test** — `scripts/smoke-check.sh` ships as the scripting half (validates 35 SKILL.md anatomy + 7 ROLE.md + 7 agent definitions + CATALOG drift + install dry-run count + full reinstall against `~/.claude`). 8 checks; runs in ~5s. The fresh-machine human-timing test (clone → first useful dispatch in <15 min, via either Claude or Codex) still needs running once on a clean machine.
- [~] **Non-engineer reach** — a designer or marketer reaches productive use in <30 min following the documented path. **Audit + fixes shipped**: designer-reviewer and marketing-expert-reviewer subagent critiques of the on-ramp (terminal wall unacknowledged, Step 4 anchored on "Review my last commit", `/kickoff` prompt list 3/4 engineering artifacts, no "what to bring on Day 1" callout, stale `data-scientist` line) converted into surgical edits — [`playbooks/onboarding.md`](playbooks/onboarding.md) restructured with a non-developer front door + role-parallel examples in Step 2 + slash-command intro; [`.claude/commands/kickoff.md`](.claude/commands/kickoff.md) example prompts now span all 7 roles with explicit non-engineer entries; [`README.md`](README.md) natural-language examples rotated across marketing/design/engineering; `/orchestrate` paragraph translated out of engineer vocabulary. New [`playbooks/non-engineer-quickstart.md`](playbooks/non-engineer-quickstart.md) is the friendlier on-ramp linked from README Quick Start. **Test protocol shipped** in [`playbooks/test-protocol-non-engineer-reach.md`](playbooks/test-protocol-non-engineer-reach.md) — a runnable, hand-off-able script for putting a real designer or marketer on the path. Real-tester run pending — graduates `[~]` → `[x]` after one designer and one marketer pass the three-criterion bar (reach / recognition / continuation).

### Polish

- [x] **License** — MIT, with explicit carve-out noting that incorporated frameworks remain the IP of their named authors.
- [x] **`ATTRIBUTION.md` completeness** — swept against the 29 shipped skills + all 7 `sources.md` files; phase tags removed; anchors and see-also split; missing names added (Mironov, Heath brothers, Humble & Farley, Nygard, Feathers, Pettichord, Halvar Flake, Hernán & Robins, Westreich & Greenland, VanderWeele & Ding, Deng et al., Goodhart, Campbell). The corresponding `sources.md` files updated where the cited author wasn't already present.
- [x] **`scripts/catalog.sh`** — generates `CATALOG.md` from role + skill frontmatter; powers the dispatcher protocol in `CLAUDE.md` / `AGENTS.md`.

## Open for post-v1

- Forward-reference skills inside each role (interactive flows like `tour-selector` for tester, `inclusion-walkthrough` for designer, `auth-flow-review` for security). 13 forward-references named across the shipped roles.
- A Claude Code marketplace plugin distribution path.
- Publish as `npx hornero init` for one-step setup in any repo.
- First-class parallel subagents in Codex once the primitive lands — currently `/review` and `/orchestrate` degrade to sequential dispatch under Codex (see [`AGENTS.md`](AGENTS.md) § Subagents in Codex).
