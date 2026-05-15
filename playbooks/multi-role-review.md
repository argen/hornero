# Multi-role review — practical guide

> **Dormant.** Hornero currently ships PM-only — there are not enough roles
> available for the parallel-critique pattern this playbook describes. The
> companion `skills/multi-role-review/SKILL.md` was retired alongside the
> non-PM roles. The playbook is preserved unchanged as the re-expansion
> reference: when ≥2 non-PM roles are restored, restore the skill from git
> history and this guide applies again as-is.

Plain-language companion to the retired `skills/multi-role-review/SKILL.md`. Read this if you want to *use* the skill effectively (post re-expansion). Read the historical SKILL.md if you want to understand the mechanism in detail.

## What it is

A protocol for getting parallel expert critique on a piece of work, where each "expert" is an AI subagent adopting one of Hornero's role personas.

Concretely: you have a PR, a plan, a launch artifact, or an RFC. You invoke `multi-role-review` and pick 2-5 roles. The orchestrator spawns those roles in parallel, each reviews from its lens, and you get back one synthesized report.

## When to use it

**Good fits:**
- A PR that touches multiple concerns (auth + UX + data flow)
- A pre-launch checklist where product, design, security, and data all matter
- An RFC or major design doc where you want multiple lenses before committing
- A plan critique before starting a non-trivial implementation
- A retrospective on a launched feature

**Bad fits:**
- A typo fix (use no roles, just commit)
- A bounded refactor (one role is enough, usually software-engineer)
- A pure aesthetic tweak (designer alone)
- "Review my entire codebase" (too broad — scope to one artifact)

## How to invoke it

Simplest form:
> "Run multi-role-review on this PR."

The orchestrator will ask you which roles to invoke. Better — pre-specify:
> "Run multi-role-review on this PR. Use product-manager, security-expert, and tester."

Best — give context:
> "Run multi-role-review on this PR adding OIDC SSO. Use security-expert, designer, product-manager. Security: focus on the auth flow and recovery path. Designer: focus on error states. PM: focus on the lockout risk for users who haven't configured SSO."

The more context you give, the better the role briefs the orchestrator can construct.

## Picking roles — quick guide

| If the work involves... | Always include... | Often include... |
|---|---|---|
| User-visible UI | designer | product-manager |
| Auth, data flow, dependencies | security-expert | software-engineer |
| Metrics, models, experiments | data-scientist | product-manager |
| Public messaging, launches | marketing-expert | product-manager, designer |
| Performance-sensitive code | software-engineer | tester |
| Cross-functional decisions | product-manager | (depends) |
| Test strategy | tester | software-engineer |

For depth on which role suits which work, see [`orchestration-heuristics.md`](orchestration-heuristics.md).

## What good output looks like

A useful multi-role review produces:

1. **A short summary** (2-3 sentences) naming the highest-stakes finding overall.
2. **Per-role findings** (1-2 broad-pass bullets + 1 deep-dive finding per role). Each finding cites a source from the role's `sources.md`.
3. **A "Conflicts between roles" section.** Explicit. Two roles disagree → both positions named → the underlying value tradeoff stated. If no conflicts surfaced, that's stated too.
4. **A ranked combined-recommendations list.** 3-5 items. Each names the role(s) that surfaced it.
5. **A "What was not reviewed" section.** Names the roles not invoked and why.

If your output is missing any of these, the orchestrator skipped a step. Ask it to redo the synthesis.

## What bad output looks like

- All findings overlap → role briefs weren't specific enough (out-of-scope wasn't enforced).
- One role returns "no concerns" → either the role was wrong for this work, or it wasn't briefed well.
- Synthesis is four mini-reports glued together → orchestrator did concatenation, not synthesis.
- No conflicts named → roles may be too aligned, or the synthesis is glossing over tension.

When you see bad output: don't accept it. Send it back with a request to tighten.

## The cost

Multi-role review is not free:

- **Time.** 5-15 minutes typically. Add a few minutes for triage and reading the synthesis.
- **Tokens.** Roughly N × the cost of a single-role review. Picking the right N is the discipline.
- **Cognitive load.** A 4-role review produces ≥4 findings to digest. Plan for that.

The cost is worth it for high-stakes work (anything you'd want a real cross-functional review for). It's not worth it for routine work.

## Pacing in a working day

Realistic cadence for a productive team:

- 0-3 multi-role reviews per week for routine PRs (most should not need it).
- 1 multi-role review per significant feature or RFC.
- 1 multi-role review pre-launch on anything customer-facing.

If you're running multi-role review on every PR, the orchestration is replacing engineering judgment instead of supplementing it. Pull back.

## Working with conflicts

The most valuable output of multi-role review is when roles *disagree*. Examples from real reviews:

- Designer wants graceful fallback for failed SSO; security-expert wants no fallback at all. → Resolution requires the team to weigh accessibility against attack surface.
- Marketing-expert wants the homepage hero to lead with a bold capability claim; product-manager wants it to lead with a customer outcome. → Resolution depends on awareness-level of the audience (Schwartz).
- Tester wants 90% line coverage gate; software-engineer wants test quality over coverage number. → Resolution names what "test quality" means concretely.

These tensions are real. The orchestrator should surface them as tensions, not pretend-resolve them.

When the orchestrator's synthesis tries to "balance both" without picking, push back: ask for the recommendation, with the tradeoff stated.

## Combining with other skills

- **Before:** Run `spec-the-problem` first if the work being reviewed isn't already problem-shaped. Specs make for sharper role briefs.
- **After:** Run `extract-lesson` if the review surfaces a recurring pattern (e.g., security-expert keeps flagging the same control gap → CLAUDE.md update).
- **In parallel (different conversation):** Run `harness-check` periodically to confirm the repo is still set up to use multi-role review effectively.

## A worked example

**Setup.** PR #423: "Add SSO via OIDC, replace email/password fallback."

**Invocation.**
> "Run multi-role-review on PR #423. Use software-engineer, security-expert, designer, product-manager. Context: replacing email/password with mandatory OIDC; ~18% of users haven't configured SSO. The team is debating whether to ship now or stage."

**Orchestrator triage.** "4 roles confirmed. Briefing each."

**Parallel dispatch.** Four subagents spawn concurrently. Each writes to `tmp/<role>-review-pr-423.md`.

**Synthesis (excerpt).**
> **Highest-stakes finding.** Removing email/password as fallback closes the account-recovery path; ~18% of users would lose access if their SSO provider fails on first login (security + product-manager surfaced this jointly).
>
> **Per-role findings.** [...]
>
> **Conflicts between roles.**
> - Designer recommends graceful fallback UI for failed OIDC callback. Security-expert flags fallback as an attack surface (federation provider spoofing). Tradeoff: usability vs adversarial robustness. Resolution requires product decision on user-impact tolerance.
>
> **Combined recommendations (ranked).**
> 1. (security, product-manager) Do not ship until recovery path is defined. Options: temporary email-code recovery for the 18%, or staged rollout with SSO-only as opt-in first.
> 2. (designer, security-expert) Define error states for failed OIDC callback that don't introduce fallback attack surface.
> 3. (software-engineer) Fix token-refresh race in the implementation.
> 4. (tester) Add adversarial tests for callback URL tampering.

**Outcome.** Team holds the PR for one week. Implements staged rollout. Ships safely.

This is the win condition. Not "the AI told us what to do" — but "the AI surfaced a tension the team hadn't named, and the team decided."
