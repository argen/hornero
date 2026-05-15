# Onboarding — Day 1 with Hornero

This playbook gets a new teammate productive with Hornero in ≤30 minutes. Read top to bottom; skip nothing.

> **Currently PM-only.** Hornero retracted in 2026-05 to ship a single role
> (`product-manager`). The onboarding below is shaped around PM work — PRDs,
> positioning, OKRs, problem framing, cross-functional decision
> orchestration. If you came expecting an engineering or design lens
> specifically, see [`../ROADMAP.md`](../ROADMAP.md) for the re-expansion plan;
> the multi-role onboarding flow returns when the relevant role is restored.

## Prerequisites (5 min)

- [ ] [Claude Code](https://claude.com/claude-code) **or** [OpenAI Codex](https://github.com/openai/codex) installed and signed in
- [ ] You can run `claude` (or `codex`) from a terminal
- [ ] You've cloned this repo locally

If you've never run a terminal command, the Claude Code install docs walk you through the one-time setup in ~10 minutes — it's not a daily-driver muscle, just initial plumbing.

## Step 1 — Open Hornero (1 min)

```bash
cd hornero
claude          # or:  codex
```

That's it. `CLAUDE.md` (for Claude) and `AGENTS.md` (for Codex) live at the repo root. Your AI tool reads them automatically and the dispatcher is now active.

> **Do I need to install anything?** No, not for this walkthrough. Hornero works as the project itself. To make roles, skills, and reviewer subagents available *globally* across every project, there are two options: install as a Claude Code plugin (`claude --plugin-dir <path-to-hornero>`, namespaces commands as `/hornero:<name>`) — preferred — or run `./install.sh` which copies into `~/.claude/` and works for both Claude and Codex. The 30-minute onboarding does not require either.

## Step 2 — Try your first dispatch with `/kickoff` (5 min)

In the session, type:

```
/kickoff
```

The agent will ask one short question — "what's something you could use a second opinion on right now?" — and then run a real dispatch on your answer. You'll see what a Hornero output feels like in practice.

If you don't have anything specific in hand, try one of these — pick the PM-shaped task closest to your real work:

| You want to... | Try | Bring |
|---|---|---|
| Critique a PRD | `Critique this PRD draft.` | A doc or outline in any format |
| Sharpen positioning | `Sharpen the positioning for this product.` | A homepage hero, launch brief, or 1-paragraph positioning draft |
| Articulate the customer's job | `Articulate the JTBD for this feature.` | A feature description in any format |
| Frame a problem | `Frame this as a product problem, not a solution.` | A solution-shaped ask ("add a retry button") |
| Define a success metric | `Define an activation metric for new signups.` | A working description of "activation" in your product |
| Prioritise a roadmap | `Help me prioritise this backlog.` | A list of items in any format |

The agent declares the chosen skill in one line before starting. Redirect with one word if it picks wrong: *"use okrs instead."*

## Step 3 — Read the methodology (10 min)

Now that you've seen one dispatch land, the methodology will make sense. Read in order:

1. [`README.md`](../README.md) — what Hornero is and why
2. [`methodology.md`](../methodology.md) — the two-layer model (harness + multi-agent collaboration)
3. [`roles/README.md`](../roles/README.md) — how to invoke roles

Skim. You don't need to memorise the role list yet.

## Step 4 — Try PM-led orchestration (5 min)

For a contested decision or a launch readiness call — use `/orchestrate`:

```
/orchestrate Plan the v2 launch — is it ready?
```

`/orchestrate` adds a PM frame: the work is restated as a customer job, the synthesis lands as a *product decision* (outcomes, success criteria, alternative considered, revisit condition).

> **Multi-role critique is dormant.** With one role currently shipped, the
> `/orchestrate` fan-out resolves to a single PM lens. Once additional roles
> are restored (see [`../ROADMAP.md`](../ROADMAP.md)), the orchestrator
> resumes spawning multiple reviewer subagents in parallel and synthesising
> non-overlapping findings, named conflicts, and a ranked recommendation
> list.

## Step 5 — Slash commands at a glance

| Command | When to use |
|---|---|
| `/kickoff` | Your first dispatch. Run once. |
| `/role product-manager <task>` | The role currently shipped — `/role product-manager draft a PRD for cohort-duplicate`. |
| `/orchestrate <task>` | PM frames as customer job, synthesises a decision. Marquee command for launches and cross-functional calls. |
| `/catalog` | See everything Hornero ships (the PM role, its skills, the cross-role process skills, commands). |
| `/extract-lesson` | End of session. Captures surprises as durable updates. |
| `/audit` | Quarterly rot review — surfaces unused skills. |

The `/review` command from the v0-era multi-role surface was retired with the non-PM roles; it returns once two or more non-PM lenses are restored.

Natural language always works too — the dispatcher in [`CLAUDE.md`](../CLAUDE.md) / [`AGENTS.md`](../AGENTS.md) matches plain prompts and declares the chosen role/skill before acting.

## You're now operating in Hornero

Two habits to start building immediately:

### Run `spec-the-problem` before non-trivial implementation

When a task arrives solution-shaped ("add a retry button"), translate to problem-shape first. The skill forces this.

### Run `/extract-lesson` at session end

When a session ends, run it. It scans for surprises and proposes durable deltas to roles, skills, or your project memory. Without this habit, the harness doesn't compound.

## Next steps

- [ ] [`playbooks/role-cheatsheet.md`](role-cheatsheet.md) — 1-page role quick reference
- [ ] [`playbooks/orchestration-heuristics.md`](orchestration-heuristics.md) — *(dormant)* when to use 1 vs 4 vs 7 roles
- [ ] [`playbooks/multi-role-review.md`](multi-role-review.md) — *(dormant)* plain-language companion to the retired skill
- [ ] [`playbooks/feedback-ritual.md`](feedback-ritual.md) — weekly extraction cadence
- [ ] [`playbooks/skill-rot-review.md`](skill-rot-review.md) — quarterly retirement cadence (pairs with [`/audit`](../.claude/commands/audit.md))
- [ ] [`playbooks/adoption.md`](adoption.md) — DRI, working group, approval process for adopting Hornero in a team
- [ ] [`playbooks/memory-loop.md`](memory-loop.md) — project-local memory layer end-to-end
- [ ] [`playbooks/claude-md-layering.md`](claude-md-layering.md) — when to add a sub-`CLAUDE.md` in a monorepo or multi-service project (uses [`templates/sub-CLAUDE.md.template`](../templates/sub-CLAUDE.md.template))
- [ ] [`templates/MAP.md.template`](../templates/MAP.md.template) — codebase orientation map for unconventional repo structures
- [ ] Read [`roles/product-manager/ROLE.md`](../roles/product-manager/ROLE.md) in full

## Troubleshooting

**The agent doesn't pick up the skill.** The Hornero-as-project flow expects you to be inside the `hornero/` directory when you run `claude` or `codex`. If you're in a different repo and want Hornero available there too, install it as a Claude Code plugin (`claude --plugin-dir <path-to-hornero>`) or run `./install.sh` once to copy roles/skills/subagents into `~/.claude/` globally.

**Skill output feels generic.** The skill's `description` may not be triggering well. Invoke explicitly: *"Use the `prd` skill at `roles/product-manager/skills/prd/SKILL.md`."*

**Multi-role review unavailable.** Hornero ships PM-only today. Restore an additional role per [`../CONTRIBUTING.md`](../CONTRIBUTING.md) § *Restoring a retired role* to enable parallel critique.

**Skills lose anchor sources in the output.** Run `scripts/validate-skill.sh <path>` to check anatomy. If it passes but content is generic, the skill needs editorial review.

## Where to get help

- This repo's [`playbooks/`](.) directory has plain-language guides
- The full Anthropic multi-agent post: <https://www.anthropic.com/engineering/multi-agent-research-system>
- Chris MDP's source article: <https://www.chrismdp.com/coding-with-ai/>
- Open an issue on this repo for unclear conventions
