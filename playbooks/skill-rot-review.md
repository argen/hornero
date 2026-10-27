# Skill-rot review — quarterly cadence

Hornero's harness compounds only if it's pruned as well as extended. Skills, roles, and rules added to compensate for a past model limitation, a one-time incident, or an early-adoption gap can outlive their usefulness — and then they're drag.

Anthropic's blog calls this out: *"Review CLAUDE.md every 3-6 months. Retire compensatory skills/hooks once those limitations disappear."* Rules optimized for older models may **constrain** newer ones.

This playbook is the **judgment turn** that pairs with the mechanical [`/audit`](../skills/audit/SKILL.md) command. Run `/audit` first to surface candidates; run this playbook to decide.

## Cadence

- **Default: every 3 months.** Set a recurring calendar reminder; tie it to a quarter-end if your team works in quarters.
- **Trigger early** if: a model upgrade ships (the moment to check whether old workarounds still apply); a major refactor lands in `roles/` or `skills/`; eval scores drop unexpectedly (rot may be masking a real regression).
- **Don't run more often than monthly.** Less than that and the data is noise.

## What you're looking for

Three classes of rot:

### 1. Compensatory rules / skills

Rules that exist because the model "used to" do something wrong, or a one-time incident shaped the response. Tells:
- The rule references a specific incident with no other current justification.
- The rule constrains a behaviour the current-generation model now does correctly by default.
- The skill exists to "remind" the agent of something it now reliably does without the reminder.

**Action:** Retire or merge. If you're unsure, leave the rule and re-check next quarter — but mark it as "watch."

### 2. Unused skills

Skills that haven't been invoked in N consecutive eval runs and aren't cited by other skills.

**Action:** Investigate before deleting. Two reasons a skill goes unused:
- **The need disappeared.** Retire it.
- **The trigger language is wrong.** The skill is still useful but the `description:` / `scenarios:` frontmatter don't match real prompts. Fix the trigger, don't retire.

`/audit` flags unused; this playbook decides which case applies.

### 3. Sources-anchor orphans

Anchors in a role's `sources.md` that no skill cites. They're a hint that either:
- The skill that *should* exist hasn't been written yet (worth creating a stub).
- The anchor was added speculatively and never paid off — retire it.

**Action:** Decide create-stub or retire per anchor.

## The decision turn

For each candidate from `/audit`, write one of these three verdicts:

- **KEEP — evidence:** Cite the current invocation / citation chain that justifies it. If you can't write the evidence in one sentence, the candidate may actually be retire-able.
- **RETIRE — proposed deletion:** Exact file paths and lines to remove. Run `scripts/catalog.sh` after to regenerate CATALOG.md.
- **WATCH — reason and re-check date:** Acceptable for ambiguous cases. Don't leave more than one quarter as WATCH — that's how rot accumulates.

## Retirement procedure

When you decide RETIRE:

1. **Branch.** Never retire on `main`. Use a `chore/skill-rot-Q<quarter>` branch.
2. **Capture evidence in the commit message.** Future-you will want to know *why* this was retired — the incident it addressed, the model behaviour it compensated for, the last invocation date.
3. **Re-run `scripts/smoke-check.sh`.** Removing a skill should not break catalog drift, sources resolution, or install.sh count.
4. **Update `methodology.md` or playbooks** if the retired skill was part of a documented workflow.
5. **Single PR per quarter's rot review.** Don't dribble retirements into unrelated PRs.

## What NOT to retire

- **Anti-pattern entries that prevent recurrence of real failures.** Symptom/Consequence/Fix blocks are cheap to keep and expensive to relearn.
- **Skills you've never invoked but are clearly load-bearing on a real artifact** (e.g., the `pre-launch-*` workflow skills — invoked rarely, but the rare invocation is high-stakes).
- **Rules in `CLAUDE.md` / `AGENTS.md` that anchor the dispatcher protocol itself.** Those aren't compensatory; they're foundational.

## Failure modes to avoid

### Over-pruning to feel tidy
**Symptom:** Aggressive retire calls; the harness loses defensive depth.
**Fix:** Require evidence for RETIRE, not just "I haven't seen it lately."

### Treating "unused" as "broken"
**Symptom:** Retiring a skill whose triggers stopped matching real prompts.
**Fix:** Always check `description:` / `scenarios:` first. The fix is often a frontmatter edit, not a deletion.

### Never running the cadence
**Symptom:** Rules from 12 months ago still apply unchallenged.
**Fix:** Calendar reminder. The blog's specific number is 3-6 months — pick one and stick to it.

### Retiring in silence
**Symptom:** Skills removed without rationale in the commit message.
**Fix:** Future-you needs to know why. The retirement commit is the documentation; treat it as one.

## Linked artifacts

- [`/audit`](../skills/audit/SKILL.md) — the mechanical sweep that produces the candidate list.
- [`scripts/smoke-check.sh`](../scripts/smoke-check.sh) — baseline health check, runs as part of `/audit`.
- [`playbooks/feedback-ritual.md`](feedback-ritual.md) — weekly extraction; this playbook is its quarterly counterpart.
