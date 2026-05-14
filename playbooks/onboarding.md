# Onboarding — Day 1 with Hornero

This playbook gets a new teammate productive with Hornero in ≤30 minutes. Read top to bottom; skip nothing.

> **Not a developer?** Hornero works for designers, PMs, marketers, and data scientists — not just engineers. If you've never used a terminal, jump to [`non-engineer-quickstart.md`](non-engineer-quickstart.md) for a friendlier on-ramp. You can come back here once you've made your first dispatch.

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

> **Do I need to run `install.sh`?** No. Hornero works as the project itself. `install.sh` is only for users who want the roles, skills, and reviewer subagents available *globally* across every project on their machine. The 30-minute onboarding does not require it.

## Step 2 — Try your first dispatch with `/kickoff` (5 min)

In the session, type:

```
/kickoff
```

The agent will ask one short question — "what's something you could use a second opinion on right now?" — and then run a real dispatch on your answer. You'll see what a Hornero output feels like in practice.

If you don't have anything specific in hand, try one of these — pick the row that matches your role:

| Your role | Try | Bring |
|---|---|---|
| Engineer | `Review my last commit. ≤200 lines.` | Any recent commit |
| Designer | `Run a heuristic review on this screen.` | Screenshot, Figma URL, or written state list |
| PM | `Critique this PRD draft.` | A doc or outline in any format |
| Marketer | `Critique this positioning statement.` | A homepage hero, launch brief, or 1-paragraph positioning draft |
| Tester | `Write a regression test for BUG-1247.` | A reproducible bug |
| Security | `Threat-model the new auth flow.` | A diagram, a doc, or a list of endpoints |
| Data scientist | `Audit this experiment design.` | An A/B test brief or metric definition |

The agent declares the chosen role and skill in one line before starting. Redirect with one word if it picks wrong: *"designer instead."*

## Step 3 — Read the methodology (10 min)

Now that you've seen one dispatch land, the methodology will make sense. Read in order:

1. [`README.md`](../README.md) — what Hornero is and why
2. [`methodology.md`](../methodology.md) — the two-layer model (harness + multi-agent collaboration)
3. [`roles/README.md`](../roles/README.md) — how to invoke roles

Skim. You don't need to memorise the role list yet.

## Step 4 — Try a multi-role review (5 min)

For something more substantial — a PR, a feature plan, a launch artifact, a contested decision — use `/review` or `/orchestrate`:

```
/review this design — use designer + product-manager + marketing-expert
```

or, when the integrating thread is a customer job:

```
/orchestrate Plan the v2 launch — is it ready?
```

`/review` runs roles in parallel and synthesises their findings. `/orchestrate` adds a PM frame on top: the work is restated as a customer job, the role mix is picked from the job rather than from a checklist, and the synthesis lands as a *product decision* (outcomes, success criteria, alternative considered, revisit condition).

You should see:
- Each role producing **non-overlapping** findings — if they overlap, the briefs need tightening
- Conflicts between roles **named explicitly**, not silently averaged
- A **ranked recommendation list** at the end

## Step 5 — Slash commands at a glance

| Command | When to use |
|---|---|
| `/kickoff` | Your first dispatch. Run once. |
| `/role <name> <task>` | A single named role — `/role designer audit the onboarding screens for a11y`. |
| `/review <target>` | Multi-role critique, you pick the roles. |
| `/orchestrate <task>` | PM frames as customer job, picks the roles, synthesises a decision. Marquee command for launches and cross-functional calls. |
| `/catalog` | See everything Hornero ships (roles, skills, commands). |
| `/extract-lesson` | End of session. Captures surprises as durable updates. |

Natural language always works too — the dispatcher in [`CLAUDE.md`](../CLAUDE.md) / [`AGENTS.md`](../AGENTS.md) matches plain prompts and declares the chosen role/skill before acting.

## You're now operating in Hornero

Two habits to start building immediately:

### Run `spec-the-problem` before non-trivial implementation

When a task arrives solution-shaped ("add a retry button"), translate to problem-shape first. The skill forces this.

### Run `/extract-lesson` at session end

When a session ends, run it. It scans for surprises and proposes durable deltas to roles, skills, or your project memory. Without this habit, the harness doesn't compound.

## Next steps

- [ ] [`playbooks/role-cheatsheet.md`](role-cheatsheet.md) — 1-page role quick reference
- [ ] [`playbooks/orchestration-heuristics.md`](orchestration-heuristics.md) — when to use 1 vs 4 vs 7 roles
- [ ] [`playbooks/multi-role-review.md`](multi-role-review.md) — plain-language companion to the skill
- [ ] [`playbooks/feedback-ritual.md`](feedback-ritual.md) — weekly extraction cadence
- [ ] When ready, read your most-relevant `roles/<role>/ROLE.md` in full

## Troubleshooting

**The agent doesn't pick up the skill.** The Hornero-as-project flow expects you to be inside the `hornero/` directory when you run `claude` or `codex`. If you're in a different repo and want Hornero available there too, run `./install.sh` once to make the roles, skills, and subagents global.

**Skill output feels generic.** The skill's `description` may not be triggering well. Invoke explicitly: *"Use the `heuristic-review` skill at `roles/designer/skills/heuristic-review/SKILL.md`."*

**Multi-role review produces overlapping findings.** Brief discipline. Each role spawn needs `scope`, `output format`, `sources to consult`, `success criteria`, and `out-of-scope`. The out-of-scope line is the most-skipped and most-load-bearing.

**Skills lose anchor sources in the output.** Run `scripts/validate-skill.sh <path>` to check anatomy. If it passes but content is generic, the skill needs editorial review.

## Where to get help

- This repo's [`playbooks/`](.) directory has plain-language guides
- The full Anthropic multi-agent post: <https://www.anthropic.com/engineering/multi-agent-research-system>
- Chris MDP's source article: <https://www.chrismdp.com/coding-with-ai/>
- Open an issue on this repo for unclear conventions
