# Hornero

> A shareable AI-coding methodology with expert-infused, role-based skills.

*Hornero* is Argentina's national bird (*Furnarius rufus*) — known for building elaborate clay-oven nests in patient, methodical layers. The metaphor fits the project: each session adds a layer; the structure outlasts any single conversation.

## What this is

Hornero is a self-contained repo that gives any team — across functions, not just engineering — a shared methodology for working with AI coding assistants. It provides:

- **Role personas** for software engineer, product manager, designer, tester, security expert, data scientist, and marketing expert — each grounded in canonical expert sources, not LLM platitudes.
- **Skills** that those roles invoke: artifacts they produce, audits they run, workflows they orchestrate.
- **Multi-agent orchestration** — a protocol for invoking multiple roles in parallel and synthesising their findings.
- **Templates and playbooks** so a teammate can apply the methodology to any new repo.

## Who this is for

Teams adopting AI-assisted work who want:

- A shared vocabulary across functions
- Standing instructions that compound week-over-week instead of starting fresh each session
- Expert-anchored frameworks rather than LLM-generated generic advice
- A repeatable way to invoke multiple expert lenses on important decisions

---

## Install

```bash
git clone <this-repo>
cd hornero
./install.sh --dry-run    # see what would be installed
./install.sh              # actually install (interactive — confirms each overwrite)
```

What gets installed:

- All cross-role skills (`spec-the-problem`, `extract-lesson`, `harness-check`, `context-reset-check`, `multi-role-review`) → `~/.claude/skills/`
- All role-based skills under `roles/<role>/skills/` → `~/.claude/skills/`
- Any agent definitions → `~/.claude/agents/`

Verify:

```bash
ls ~/.claude/skills/
```

To remove: `./install.sh --uninstall`.

> **Note:** the role personas themselves (`roles/<role>/ROLE.md`) are not installed into `~/.claude` — they live in this repo and you reference them by path when invoking a role. This is deliberate: ROLE.md is *context*, skills are *operations*.

---

## The dispatcher

You should not have to memorise which role or skill to invoke. Hornero ships a **dispatcher protocol** that matches your prompt against a one-line catalog and adopts the right role + skill for you.

How it works:

1. **`CLAUDE.md` at the repo root** tells Claude to scan **`CATALOG.md`** before responding.
2. The agent matches your prompt against role triggers and skill descriptions.
3. **It declares its choice in one line** — your correction point — *before* doing the work.
4. If two or more roles match strongly, it escalates to `multi-role-review` instead of guessing.

To use it from your own project, copy [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) (or the dispatcher section of [`CLAUDE.md`](CLAUDE.md)) into your project's `CLAUDE.md`. To use it inside Hornero itself, the dispatcher is already wired up.

You can still invoke roles or skills explicitly when you want to — explicit naming always wins over auto-dispatch.

Regenerate `CATALOG.md` after adding or renaming any role or skill:

```bash
./scripts/catalog.sh
```

---

## How to use

Six concrete patterns. With the dispatcher in place, most prompts are short — you describe the task, the agent adopts the role.

### 1. Invoke a single role to review something

Use when you want one expert lens on a piece of work — a diff, a draft, a plan.

> "Review my last commit as a tester."

or just:

> "Review my last commit."

(The dispatcher will score against engineer / tester / security / designer triggers and either pick the strongest or escalate to `multi-role-review`. It declares its choice in one line before starting, so you can redirect with one word.)

To force a specific role:

> "Review my last commit. Use the `software-engineer` role; broad pass then drill into the highest-severity concern; ≤200 lines."

Other roles available: `product-manager`, `designer`, `tester`, `security-expert`, `marketing-expert`, `data-scientist` (forthcoming).

### 2. Invoke a role to produce an artifact

Use when you need a specific deliverable: a PRD, an ADR, a threat model, a positioning canvas, a launch brief, a test plan, etc.

> "Produce a threat model for the new permissions service. Pre-reads: `<RFC link>`, `<DFD link>`."

The dispatcher matches "threat model" to the `security-expert` / `threat-model` skill and walks its production sequence (for `threat-model`: scope → DFD → adversaries → STRIDE walk → controls → Shostack's Q4).

If the artifact name is ambiguous ("write a plan"), the agent will ask which kind. If you want to force the choice:

> "Use the `security-expert` / `threat-model` skill to produce a threat model for ..."

Component and workflow skills currently shipped (29 across all seven roles): see the [What's in the box](#whats-in-the-box) section below, or the live one-liner index in [`CATALOG.md`](CATALOG.md).

### 3. Run a cross-role process skill

These work on any task, regardless of which role(s) are involved.

| Skill | When to run |
|---|---|
| **`spec-the-problem`** | Before non-trivial implementation, when the task arrived solution-shaped ("add a retry button") and you want to translate it to problem-shape first. |
| **`harness-check`** | Periodically (weekly / on joining a new repo) to audit how well your `CLAUDE.md` / skills / settings cooperate. |
| **`context-reset-check`** | When the agent's behaviour feels off and you suspect the context is fighting itself. |
| **`extract-lesson`** | At the end of a session that produced a surprise (good or bad) — proposes durable deltas to roles, skills, or your project memory. **Run this habitually or the harness doesn't compound.** |
| **`multi-role-review`** | For decisions that warrant multiple expert lenses — see pattern 4. |

Invoke:

> "Run **harness-check** on this repo."

> "Run **spec-the-problem** on the task: 'add a quick-checkout button to the cart page.'"

### 4. Run a multi-role review on a contested or cross-functional artifact

Use for PRs touching multiple domains, RFCs, launch briefs, security-sensitive changes, anything where one lens isn't enough.

> "Run **multi-role-review** on this PR. Use roles: **software-engineer**, **security-expert**, **tester**. The artifact is at `<path or link>`."

The orchestrator will:
1. Triage your role choice (one question, declines or accepts).
2. Dispatch the named roles in parallel, each with a detailed brief (scope, output format, sources, success criteria, out-of-scope).
3. Receive their condensed findings.
4. Synthesise — surface non-overlapping findings, name conflicts, produce a ranked recommendation.

Rules the orchestrator follows: maximum 7 roles per invocation; one layer of nesting; artifacts passed via `tmp/<role>-review-<task>.md` to keep the lead's context lean. Full protocol in [`skills/multi-role-review/SKILL.md`](skills/multi-role-review/SKILL.md).

Sensible role combinations:

| Situation | Role combination |
|---|---|
| Engineering PR review | engineer + tester |
| Feature spec review | product-manager + designer + engineer |
| Pre-launch readiness | engineer + tester + security-expert + marketing-expert |
| AI/LLM feature design | engineer + security-expert + product-manager |
| Major launch readout | All seven |

See `playbooks/orchestration-heuristics.md` for when to use 1 vs 4 vs 7 roles.

### 5. Run a pre-launch workflow

Three roles ship sibling pre-launch workflow skills with the same shape — frame → re-confirm → execute → audit → synthesise → recommend Go/Hold/No-Go.

| Role | Workflow skill |
|---|---|
| Tester | `pre-release-test-pass` — risk re-assessment + targeted exploratory charters + suite readout |
| Security-expert | `pre-launch-security-audit` — threat-model refresh + focused review + LLM risk + control-readiness |
| Marketing-expert | `pre-launch-marketing-audit` — positioning + narrative + brief audit + channel readiness + measurement design |

For cross-functional launches, run all three in parallel via multi-role-review and have the orchestrator synthesise across them.

> "Run **multi-role-review** on the LedgerStack v2 launch. Run `pre-release-test-pass`, `pre-launch-security-audit`, and `pre-launch-marketing-audit` in parallel; synthesise into a unified launch recommendation."

### 6. Adapt Hornero to your own project

Templates in `templates/` give you starting points to drop into any repo:

- `templates/CLAUDE.md.template` — a starter `CLAUDE.md` referencing Hornero roles and skills.
- `templates/AGENTS.md` — a starter agent definitions file.
- `templates/settings.json` — a starter Claude Code settings file with sensible permissions.

Adapt them to your project; the values that need editing are marked `<like this>`.

---

## What's in the box

All seven role personas have full first-draft skills. Each role's skills follow the same anatomy (Purpose, Key Concepts, Application, Examples, Common Pitfalls, References) and cite from `sources.md` (no LLM-confabulated frameworks — `scripts/validate-skill.sh` enforces this).

| Role | Component skills | Workflow skill |
|---|---|---|
| **software-engineer** | `adr`, `rfc`, `refactor-plan` | `tdd-discipline` |
| **tester** | `test-plan`, `exploratory-charter`, `regression-test` | `pre-release-test-pass` |
| **designer** | `state-audit`, `accessibility-audit`, `heuristic-review` | `design-review` |
| **security-expert** | `threat-model`, `security-review`, `llm-risk-assessment` | `pre-launch-security-audit` |
| **marketing-expert** | `positioning-canvas`, `strategic-narrative`, `launch-brief` | `pre-launch-marketing-audit` |
| **product-manager** | `prd`, `jobs-to-be-done`, `positioning-statement`, `okrs`, `discovery-interview-prep` | `cross-functional-orchestration` |
| **data-scientist** | `metric-definition`, `experiment-design`, `causal-dag` | `pre-launch-measurement-audit` |

Cross-role skills:

- `spec-the-problem` — translate solution-shaped tasks to problem-shape before implementing.
- `multi-role-review` — the orchestrator-worker protocol.
- `extract-lesson` — turn session surprises into harness deltas.
- `harness-check` — audit your repo's AI-coding scaffolding.
- `context-reset-check` — diagnose context fighting itself.

Each role's `ROLE.md` defines the role's mindset, broad-pass + deep-dive heuristics, what it does *not* review, anti-patterns, and handoffs to other roles. Each `sources.md` caps the bibliography at ~10 anchors plus a "see also" — the cap is deliberate; long bibliographies drift toward LLM synthesis.

### Subagent definitions

`agents/` ships seven Claude Code reviewer subagent definitions — one per role (`software-engineer-reviewer`, `product-manager-reviewer`, `designer-reviewer`, `tester-reviewer`, `security-expert-reviewer`, `marketing-expert-reviewer`, `data-scientist-reviewer`). Each is a self-contained system prompt (the role's mindset, heuristics, anti-patterns, output discipline, sources) — they don't need to read `ROLE.md` at runtime.

`install.sh` copies them to `~/.claude/agents/`. Once installed, the orchestrator (or `multi-role-review`) can spawn them by name via the Agent tool (`subagent_type: "tester-reviewer"`) — no need to brief them on the role from scratch each time. They're read-only (Read, Grep, Glob, Bash, WebFetch — no Edit/Write).

---

## Reading order for a new teammate

1. This README — what Hornero is and how to use it.
2. [`methodology.md`](methodology.md) — the two-layer synthesis (harness compounding + multi-agent collaboration).
3. [`playbooks/onboarding.md`](playbooks/onboarding.md) — a 30-minute hands-on walkthrough.
4. [`playbooks/role-cheatsheet.md`](playbooks/role-cheatsheet.md) — 1-page quick reference.
5. The `roles/<role>/ROLE.md` for the role most relevant to your work.

For deeper material on orchestration: `playbooks/orchestration-heuristics.md` (when to use 1 vs 4 vs 7 roles), `playbooks/multi-role-review.md` (plain-language companion to the skill), `playbooks/feedback-ritual.md` (weekly extraction cadence).

---

## Source articles

The methodology draws on two:

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — governs how the harness compounds (five principles).
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — governs how roles collaborate (orchestrator-worker pattern).

See `methodology.md` for the full synthesis.

---

## Status

**v0 — under construction.** Six roles (**software-engineer**, **tester**, **designer**, **security-expert**, **marketing-expert**, **product-manager**) have ROLE + sources + first-draft skills. The remaining role (data-scientist) has ROLE.md + sources.md scaffolded; its skills land in a later phase. Cross-role process skills (`spec-the-problem`, `multi-role-review`, `extract-lesson`, `harness-check`, `context-reset-check`) are shipped.

## Roadmap — what's remaining before v1

### Content
- [x] **data-scientist role** — shipped: `metric-definition`, `experiment-design`, `causal-dag` (component) + `pre-launch-measurement-audit` (workflow, sibling to tester/security/marketing pre-launch audits). Four roles now ship a `pre-launch-*` workflow that the PM's `cross-functional-orchestration` can compose in parallel for a launch.
- [x] **product-manager workflow skill** — shipped as [`cross-functional-orchestration`](roles/product-manager/skills/cross-functional-orchestration/SKILL.md). Composes `multi-role-review` with PM framing (customer-job triage in front, outcomes-shaped decision synthesis behind), so the PM can act as the cross-functional orchestrator when the integrating thread is the customer job.
- [ ] **First editorial pass** on the 24 shipped skill drafts. Drafts read as drafts; a sweep to tighten examples, prune restatement, and verify every framework citation is precise enough that a reader could trace it to the source page.

### Templates and onboarding
- [x] **`templates/CLAUDE.md.template`** review — TDD-skill path made concrete; PM-orchestrator pattern referenced for cross-functional decisions; named reviewer subagents listed for downstream teams to know what's callable by name.
- [x] **`templates/AGENTS.md`** review — Hornero-vs-project `install.sh` clarified; full role roster + descriptions added to the multi-role-review section; "When in doubt" updated with `CATALOG.md` and named-subagent paths.
- [x] **`examples/sample-session.md`** refresh — two annotated sessions: a dispatcher-led 4-role review on a small feature (engineer + tester + designer + PM + data-scientist), and a PM-orchestrated launch composing the four pre-launch sibling workflows in parallel.
- [ ] **`research/` folder** — currently empty; the plan called for distilled book notes per role. Optional for v1 if `sources.md` is doing enough work.

### Verification (per plan §Verification)
- [ ] **20-sample eval** of `multi-role-review` against representative tasks; score on source-citation rate, finding distinctness, conflict surfacing, actionability. Target: ≥0.8 mean before declaring v1.
- [ ] **Clean-install test** — fresh machine, clone, `install.sh`, complete a role critique in <15 min.
- [ ] **Non-engineer reach** — a designer or marketer reaches productive use in <30 min using `playbooks/onboarding.md` alone.

### Polish
- [x] **License** — MIT, with explicit carve-out noting that incorporated frameworks remain the IP of their named authors.
- [x] **`ATTRIBUTION.md` completeness** — swept against the 29 shipped skills + all 7 `sources.md` files; phase tags removed; anchors and see-also split; missing names added (Mironov, Heath brothers, Humble & Farley, Nygard, Feathers, Pettichord, Halvar Flake, Hernán & Robins, Westreich & Greenland, VanderWeele & Ding, Deng et al., Goodhart, Campbell). The corresponding `sources.md` files updated where the cited author wasn't already present.
- [x] **`scripts/catalog.sh`** — generates `CATALOG.md` from role + skill frontmatter; powers the dispatcher protocol in `CLAUDE.md`.

### Open for post-v1
- Forward-reference skills inside each role (interactive flows like `tour-selector` for tester, `inclusion-walkthrough` for designer, `auth-flow-review` for security). 13 forward-references named across the shipped roles.
- A Claude Code marketplace plugin distribution path.
- Publish as `npx hornero init` for one-step setup in any repo.

## Repo structure

```
CLAUDE.md               # Dispatcher protocol — also the file teams copy/adapt
CATALOG.md              # Generated one-liner index (powers the dispatcher)
roles/                  # One folder per role — ROLE.md, sources.md, skills/
skills/                 # Cross-role process skills (spec-the-problem, extract-lesson, multi-role-review, ...)
agents/                 # Optional Claude Code subagent wrappers
templates/              # AGENTS.md, CLAUDE.md, settings.json drop-in templates
playbooks/              # Human-readable workflow guides
research/               # Distilled book notes per role
scripts/                # validate-skill.sh, catalog.sh
examples/               # Annotated sample sessions
methodology.md          # The two-layer synthesis
ATTRIBUTION.md          # Credits to incorporated experts
install.sh              # Copies skills + agents into ~/.claude
```

## License

[MIT](LICENSE). The MIT license covers Hornero's synthesis, structure, and prose. Frameworks and vocabularies incorporated from named authors (see each role's `sources.md` and [`ATTRIBUTION.md`](ATTRIBUTION.md)) remain the intellectual property of their respective authors and publishers.

## Acknowledgements

See `ATTRIBUTION.md` for the full list of expert sources whose work this methodology incorporates.
