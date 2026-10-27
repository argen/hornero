# Onboarding — Day 1 with Hornero

This playbook gets a new teammate productive with Hornero in ≤30 minutes. Read top to bottom; skip nothing.

> Hornero ships one role today — `product-manager` — carrying **38 skills**
> across discovery, strategy, AI-PM, finance literacy, outside-in scanning,
> GTM, workshops + delivery, operations, and the PM-to-Director career
> arc. Whatever product-shaped work you have, there is almost certainly a
> lens for it.

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

## Step 2 — Try your first dispatch (5 min)

The fastest way in is to **just describe what you're working on**. The dispatcher matches your prompt against the catalog, declares its choice in one line, and starts. No menu to navigate.

If you want a guided opening, type `/kickoff` — it gives a 3-sentence intro about what Hornero offers and invites you to describe your situation in your own words, then routes the same way. Use it once to see the flow; after that, plain prompts are enough.

If you don't have something specific in hand, here are seed prompts across the live skill themes — pick the one closest to your real work:

| You want to... | Try | Bring |
|---|---|---|
| Critique a PRD | `Critique this PRD draft.` | A doc or outline in any format |
| Sharpen positioning | `Sharpen the positioning for this product.` | A homepage hero, launch brief, or 1-paragraph draft |
| Articulate the customer's job | `Articulate the JTBD for this feature.` | A feature description |
| Frame a problem | `Frame this as a product problem, not a solution.` | A solution-shaped ask ("add a retry button") |
| Define a success metric | `Define an activation metric for new signups.` | A working description of "activation" |
| Build an opportunity-solution tree | `Map an OST from this discovery insight.` | A research finding or customer-quote bundle |
| Map a customer journey | `Map the onboarding journey end-to-end.` | A rough flow description, screenshots optional |
| Plan a workshop | `Plan a 90-min positioning workshop.` | The decision the workshop has to land |
| Write an Amazon-style press release | `Draft a PR/FAQ for this feature.` | The customer-facing change you're considering |
| Size a market | `Size the TAM/SAM/SOM for this new vertical.` | A 1-sentence ICP + the obvious adjacent markets |
| Read SaaS economics | `What does our Rule of 40 say about our health?` | The growth rate + FCF margin numbers |
| Choose an acquisition channel | `Should we invest in paid search or content for Q3?` | ACV, ICP, current motion |
| Coach a PM-to-Director transition | `I'm a senior PM about to step up — what changes?` | Your current scope + your team's expectations |
| Self-diagnose AI-shaped readiness | `Audit our team's AI-PM competencies.` | Your team's current AI involvement |

The agent declares the chosen skill in one line before starting. Redirect with one word if it picks wrong: *"use okrs instead."* If the prompt is ambiguous, the dispatcher asks **one** clarifying question (not a menu) and converges in a single turn.

## Step 3 — Read the methodology (10 min)

Now that you've seen one dispatch land, the methodology will make sense. Read in order:

1. [`README.md`](../README.md) — what Hornero is and why
2. [`methodology.md`](../methodology.md) — the two-layer model (harness + multi-agent collaboration)
3. [`roles/README.md`](../roles/README.md) — how to invoke roles
4. [`VOICE.md`](../VOICE.md) — how Hornero speaks. Calm, terse, plain-spoken; the bird's working metaphor (patient layers, duet, no preening). Lifecycle touchpoints carry voice; artefact outputs stay neutral.

Skim. You don't need to memorise the role list yet.

## Step 4 — Try PM-led orchestration (5 min)

For a contested decision or a launch readiness call — use `/orchestrate`:

```
/orchestrate Plan the v2 launch — is it ready?
```

`/orchestrate` adds a PM frame: the work is restated as a customer job, the synthesis lands as a *product decision* (outcomes, success criteria, alternative considered, revisit condition).

## Step 5 — Slash commands at a glance

| Command | When to use |
|---|---|
| `/kickoff` | Your first dispatch. Run once. |
| `/role product-manager <task>` | The role currently shipped — `/role product-manager draft a PRD for cohort-duplicate`. |
| `/orchestrate <task>` | PM frames as customer job, synthesises a decision. Marquee command for launches and cross-functional calls. |
| `/catalog` | See everything Hornero ships (the PM role, its skills, the cross-role process skills, commands). |
| `/extract-lesson` | End of session. Captures surprises as durable updates. |
| `/audit` | Quarterly rot review — surfaces unused skills. |

Natural language always works too — the dispatcher in [`CLAUDE.md`](../CLAUDE.md) / [`AGENTS.md`](../AGENTS.md) matches plain prompts and declares the chosen role/skill before acting.

## You're now operating in Hornero

Two habits to start building immediately:

### Run `spec-the-problem` before non-trivial implementation

When a task arrives solution-shaped ("add a retry button"), translate to problem-shape first. The skill forces this.

### Run `/extract-lesson` at session end

When a session ends, run it. It scans for surprises and proposes durable deltas to roles, skills, or your project memory. Without this habit, the harness doesn't compound.

## Next steps

- [ ] [`playbooks/role-cheatsheet.md`](role-cheatsheet.md) — 1-page role quick reference
- [ ] [`playbooks/feedback-ritual.md`](feedback-ritual.md) — weekly extraction cadence
- [ ] [`playbooks/skill-rot-review.md`](skill-rot-review.md) — quarterly retirement cadence (pairs with [`/audit`](../skills/audit/SKILL.md))
- [ ] [`playbooks/adoption.md`](adoption.md) — DRI, working group, approval process for adopting Hornero in a team
- [ ] [`playbooks/memory-loop.md`](memory-loop.md) — project-local memory layer end-to-end
- [ ] [`playbooks/claude-md-layering.md`](claude-md-layering.md) — when to add a sub-`CLAUDE.md` in a monorepo or multi-service project (uses [`templates/sub-CLAUDE.md.template`](../templates/sub-CLAUDE.md.template))
- [ ] [`templates/MAP.md.template`](../templates/MAP.md.template) — codebase orientation map for unconventional repo structures
- [ ] Read [`roles/product-manager/ROLE.md`](../roles/product-manager/ROLE.md) in full

## Troubleshooting

**The agent doesn't pick up the skill.** The Hornero-as-project flow expects you to be inside the `hornero/` directory when you run `claude` or `codex`. If you're in a different repo and want Hornero available there too, install it as a Claude Code plugin (`claude --plugin-dir <path-to-hornero>`) or run `./install.sh` once to copy roles/skills/subagents into `~/.claude/` globally.

**Skill output feels generic.** The skill's `description` may not be triggering well. Invoke explicitly: *"Use the `prd` skill at `skills/prd/SKILL.md`."*

**Skills lose anchor sources in the output.** Run `scripts/validate-skill.sh <path>` to check anatomy. If it passes but content is generic, the skill needs editorial review.

## Where to get help

- This repo's [`playbooks/`](.) directory has plain-language guides
- The full Anthropic multi-agent post: <https://www.anthropic.com/engineering/multi-agent-research-system>
- Chris MDP's source article: <https://www.chrismdp.com/coding-with-ai/>
- Open an issue on this repo for unclear conventions
