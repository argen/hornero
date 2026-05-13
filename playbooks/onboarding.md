# Onboarding — Day 1 with Hornero

This playbook gets a new teammate productive with Hornero in ≤30 minutes. Read top to bottom; skip nothing.

## Prerequisites (5 min)

- [ ] [Claude Code](https://claude.com/claude-code) installed and signed in
- [ ] You can run `claude` from a terminal
- [ ] `~/.claude/` exists
- [ ] You've cloned this repo locally

If any of those fail, fix them before proceeding.

## Step 1 — Install Hornero into your `~/.claude` (5 min)

```bash
cd hornero
./install.sh --dry-run    # see what would be installed
./install.sh              # actually install
```

You'll be asked to confirm any overwrites. Defaults are safe.

Verify:
```bash
ls ~/.claude/skills/        # should show context-reset-check, extract-lesson, harness-check, multi-role-review, spec-the-problem
```

If something looks wrong: `./install.sh --uninstall` reverses everything.

## Step 2 — Read the methodology (10 min)

In order:
1. [`README.md`](../README.md) — what Hornero is and why
2. [`methodology.md`](../methodology.md) — the two-layer model (harness + multi-agent collaboration)
3. [`roles/README.md`](../roles/README.md) — how to invoke roles

You don't need to memorize the role list yet. Skim. The role files become useful when you have a real task.

## Step 3 — Try one cross-role skill (5 min)

Open a Claude Code session in any project you're actively working on. Try:

> "Run harness-check on this repo."

The skill will produce a structured audit. Read the output. This is what a Hornero skill feels like in practice.

If you don't have an active project, run it on the Hornero repo itself.

## Step 4 — Try a role-based critique (5 min)

In an active project, on a non-trivial change:

> "Adopt the software-engineer role from `roles/software-engineer/ROLE.md` and review my last commit. Focus on the deep-dive heuristics. Report findings in ≤200 lines."

> Available roles in Hornero v0: `software-engineer`, `tester`, `designer`, `security-expert`, `marketing-expert`, `product-manager`. (`data-scientist` is scaffolded but skills land in a future phase.)

Notice:
- The agent works through the broad pass first, then drills in
- Findings cite sources from `sources.md`
- The agent flags concerns outside its lens as "consult <other role>"

## Step 5 — Try a multi-role review (5 min)

For something more substantial — a PR, a feature plan, a launch artifact:

> "Run multi-role-review on this. Use roles: product-manager, designer, security-expert."

The orchestrator will:
- Triage the role choice with you
- Dispatch the three roles in parallel
- Synthesize their findings, surfacing conflicts
- Return one report

Notice:
- Each role produces non-overlapping findings (if they overlap, the briefs need tightening)
- Conflicts between roles are explicitly named
- The synthesis ends with a ranked recommendation list

## You're now operating in Hornero

Two habits to start building immediately:

### Run `spec-the-problem` before non-trivial implementation

When a task arrives solution-shaped ("add a retry button"), translate to problem-shape first. The skill forces this.

### Run `extract-lesson` at session end

When a session ends, run the skill. It scans for surprises and proposes durable deltas to roles, skills, or your project memory. Without this habit, the harness doesn't compound.

## Next steps

- [ ] Read [`playbooks/multi-role-review.md`](multi-role-review.md) — plain-language companion to the skill
- [ ] Read [`playbooks/orchestration-heuristics.md`](orchestration-heuristics.md) — when to use 1 vs 4 vs 7 roles
- [ ] Read [`playbooks/role-cheatsheet.md`](role-cheatsheet.md) — 1-page role quick reference
- [ ] Read [`playbooks/feedback-ritual.md`](feedback-ritual.md) — set up the weekly extraction cadence
- [ ] When ready, read your most-relevant `roles/<role>/ROLE.md` in full

## Troubleshooting

**The agent doesn't pick up the skill.** Confirm `~/.claude/skills/<name>/SKILL.md` exists. Run `./install.sh --dry-run` to see what should be installed.

**Skill output feels generic.** The skill description's `description` field may not be triggering well. Invoke explicitly: "Use the multi-role-review skill at `~/.claude/skills/multi-role-review/SKILL.md`."

**Multi-role-review produces overlapping findings.** Brief discipline. Each role spawn needs `scope`, `output format`, `sources to consult`, `success criteria`, and `out-of-scope`. The "out-of-scope" line is the most-skipped and most-load-bearing.

**Skills lose anchor sources in the output.** Possible drift. Run `validate-skill.sh <path>` to check anatomy. If it passes but content is generic, the skill needs editorial review.

## Where to get help

- This repo's `playbooks/` directory has plain-language guides
- The full Anthropic multi-agent post: <https://www.anthropic.com/engineering/multi-agent-research-system>
- Chris MDP's source article: <https://www.chrismdp.com/coding-with-ai/>
- Open an issue on this repo for unclear conventions
