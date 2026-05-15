# Adopting Hornero in your team

Hornero ships as a methodology and a working harness, not as a turnkey product. A team adopting it for the first time needs to decide who owns it, who can change it, and how it's introduced — otherwise the harness fragments into tribal variants per developer.

Anthropic's blog: *"Assign a DRI for Claude Code configuration. Invest in infrastructure before broad rollout. Establish cross-functional working groups. Define approval processes."* This playbook is Hornero's version of that guidance.

## Step 1 — Name a DRI (Directly Responsible Individual)

**One person owns Hornero in your team.** Not a committee, not "whoever last touched it." The DRI:

- Owns the `CLAUDE.md` / `AGENTS.md` / sub-CLAUDE.md hierarchy for your repos.
- Reviews PRs that touch `roles/`, `skills/`, or `.claude/commands/`.
- Runs the [skill-rot review](skill-rot-review.md) cadence quarterly.
- Decides when to upgrade Hornero from upstream (or when to fork stable).
- Is the final voice on "should this rule live in CLAUDE.md or a skill?"

The DRI does not need to be the most senior engineer or the loudest opinion. They need to have **bandwidth** (this is real ongoing work, ~2-4 hours/month after setup) and **judgment** about where structure helps vs. ossifies.

If your team is <5 people, the DRI can be a co-founder or tech lead. If >20 people, the DRI usually sits in a platform / dev-tools / DX role.

## Step 2 — Form a cross-functional working group (for the first 90 days)

Hornero spans roles by design — engineering, design, PM, marketing, security, data, testing. Adoption that's run only out of engineering bakes engineering biases into the configuration.

For the first 90 days, the working group meets every 2 weeks:

- One person per role Hornero covers that your team actually uses (skip roles you don't have — Hornero is not "use all 7 or nothing").
- 30-minute meetings. Agendas: what's working, what's bouncing, which skills should be retired/added, what's missing from `sources.md` for your stack.
- After 90 days, fold the working group into the DRI's regular cadence + ad-hoc consultations.

## Step 3 — Set the approval bar before broad rollout

Before letting any team member add new roles, skills, or slash commands, decide:

- **Who reviews additions.** Default: DRI + one role peer. Don't let a single engineer add a "security" skill without a security person looking; don't let a single PM rewrite the `product-manager` ROLE.md unilaterally.
- **What anchors are required.** Hornero's discipline: every framework in Key Concepts traces to a `sources.md` entry. Enforce in CI via `scripts/validate-skill.sh`.
- **When experimental skills become standard.** Default: a skill is "experimental" for 30 days after merge, marked with `type: experimental` in frontmatter. After 30 days the working group decides standardize / keep-experimental / retire.

Aggressive: gate every skill addition behind multi-role review (cumbersome, but high-discipline orgs do this). Light: DRI-only review until rot review surfaces a problem. Pick a level your team can sustain.

## Step 4 — Install infrastructure before broad rollout

The blog explicitly: *"Small team pre-configures tooling so developers experience productivity on day one."* For Hornero, that means:

- **Preferred for Claude Code teams: install as a plugin.** `claude --plugin-dir <path-to-hornero>` for local testing; once you've validated, distribute via a marketplace (see [Claude Code plugin marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)). Commands become namespaced (`/hornero:orchestrate`, `/hornero:review`, …).
- **Alternative — install.sh.** For Codex teams or for global availability across non-plugin sessions, run `<path-to-hornero>/install.sh --claude` / `--codex` / `--both` to copy roles/skills/agents/commands into `~/.claude/`.
- `templates/settings.json` merged into team members' `~/.claude/settings.json` for opt-in guardrail hooks (validate-skill, catalog-regen, smoke-check) on top of the plugin's built-in session-lifecycle hooks.
- A `MAP.md` (copy [`templates/MAP.md.template`](../templates/MAP.md.template)) in your repo root, populated with your folder structure.
- Reviewer subagents (`agents/*-reviewer.md`) visible in the user's Agent tool list.
- The [`/kickoff`](../.claude/commands/kickoff.md) command working — that's the day-one productivity moment.

Don't roll out to the team until at least one full multi-role review has run end-to-end on a real artifact in your repo. The first session is the most fragile.

## Step 5 — Establish the maintenance cadences

Two cadences, set at adoption:

- **Weekly: [feedback ritual](feedback-ritual.md).** 15 minutes; one person reads recent `/extract-lesson` outputs and decides which propose durable updates.
- **Quarterly: [skill-rot review](skill-rot-review.md).** 60-90 minutes; the DRI runs [`/audit`](../.claude/commands/audit.md) and walks the working group through candidates.

Without these, Hornero accumulates without pruning, and the harness becomes liability rather than leverage.

## Step 6 — Start with PM, restore roles incrementally

Hornero currently ships PM-only. Don't restore all six retired roles on day one. Adopt in waves matched to the work the team actually faces:

- **Wave 1 (week 1):** `product-manager` only — the role currently shipped. Use it for PRDs, positioning, OKRs, problem framing, cross-functional decision orchestration.
- **Wave 2 (week 3+):** Restore the role matching the next-most-common work surface — `software-engineer` for code-shaped decisions, `designer` for UI teams, `data-scientist` for analytics teams, `security-expert` for fintech / health. Each is a content drop-in per [`../CONTRIBUTING.md`](../CONTRIBUTING.md) § *Restoring a retired role*.
- **Wave 3 (week 6+):** Add others as the work warrants. Most teams settle on 3-5 active roles, not all 7.

The dispatcher in `DISPATCHER.md` handles partial role sets — it never assumes every role is wired in.

## Common failure modes

### "We installed Hornero, no one uses it"
**Cause:** No DRI; rollout was technical-only; no day-one demonstration of value.
**Fix:** Pick a DRI now. Run `/kickoff` together as a team. Pick one upcoming decision and route it through `/orchestrate` or `/review` so the team sees the output.

### "Every developer customized their own version"
**Cause:** No approval process; no working group; tribal variants accumulated.
**Fix:** Pick the canonical configuration. PR every variant back to that canonical. Enforce in CI via `scripts/smoke-check.sh`.

### "We added 20 skills in month one and they're all stale"
**Cause:** Eagerness without rot review.
**Fix:** Run [`/audit`](../.claude/commands/audit.md) immediately. Retire half. Set the quarterly cadence so it doesn't repeat.

### "The methodology slowed us down"
**Cause:** Dispatch on trivial edits; multi-role review on bounded changes; over-formalisation.
**Fix:** Re-read [`DISPATCHER.md`](../DISPATCHER.md) "When the dispatcher does NOT apply" and [`playbooks/orchestration-heuristics.md`](orchestration-heuristics.md) triage matrix. Default to fewer roles, not more.

## Linked artifacts

- [`playbooks/onboarding.md`](onboarding.md) — Day 1 walkthrough for individual contributors.
- [`playbooks/feedback-ritual.md`](feedback-ritual.md) — weekly cadence.
- [`playbooks/skill-rot-review.md`](skill-rot-review.md) — quarterly cadence.
- [`/audit`](../.claude/commands/audit.md) — automation for the quarterly review.
- [`CONTRIBUTING.md`](../CONTRIBUTING.md) — anatomy and discipline rules for additions.
