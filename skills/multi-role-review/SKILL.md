---
name: multi-role-review
description: Use when a task, plan, diff, or artifact would benefit from parallel critique by 2-7 expert role personas — orchestrates dispatch, artifact passing, and synthesis.
intent: |
  Implements the orchestrator-worker pattern from Anthropic's multi-agent
  research system, sharpened for role-based critique. The lead agent
  decomposes the task per role, spawns role subagents in parallel, collects
  condensed findings as artifacts, and synthesizes a unified report.
type: workflow
theme: orchestration
best_for:
  - Cross-functional decisions (architecture, launch, strategy)
  - PR or RFC review where multiple expert lenses matter
  - Pre-launch audits — product, design, security, data, marketing
  - Plan critique before committing to a non-trivial implementation
scenarios:
  - "Reviewing a payments-feature PR with security, software-engineer, and tester roles before merge"
  - "Critiquing a launch plan with product-manager, marketing-expert, and designer before GTM"
  - "Auditing an ML pipeline with data-scientist, software-engineer, and security-expert"
estimated_time: 5-15 minutes
---

# Multi-role review

## Purpose

Run parallel expert critique on a piece of work, with each lens grounded in canonical sources. Produces a synthesized report that surfaces non-overlapping findings, escalates conflicts between roles, and recommends next steps. The skill enforces the discipline that makes multi-agent review *useful* rather than noisy: detailed delegation, parallel dispatch, artifact passing, hard caps on subagent count, and end-state evaluation of the synthesis.

## Key Concepts

The orchestration discipline is drawn from Anthropic's engineering post ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system). The eight rules below are the operational core of this skill.

### Rule 1 — Resource scaling

Match subagent count to task complexity. Anthropic's evidence: agents over-spawn (50 subagents for a simple query) absent explicit guidance.

| Task class | Roles to invoke |
|---|---|
| Single-domain task (a bug fix, a UI tweak, a copy edit) | 1 role |
| Cross-functional review (a feature PR, a PRD draft) | 2-4 roles |
| Major decision (architecture choice, launch plan, org-level strategy) | 5-7 roles |

If the user requests "all roles," push back: ask which 3-5 are actually load-bearing.

### Rule 2 — Detailed delegation

Every subagent invocation must specify:

1. **Scope** — what to evaluate
2. **Output format** — markdown structure, line cap (typically ≤200 lines), section headings
3. **Sources to consult** — point at the role's `sources.md` and `ROLE.md`
4. **Success criteria** — what a useful finding looks like
5. **Out-of-scope** — explicitly state what the role should NOT evaluate (delegated to other roles)

Vague directives like "review this from a security lens" cause duplicated work across subagents. Anthropic measured this.

### Rule 3 — Parallel-first

Spawn role subagents concurrently — single message, multiple tool calls. Sequential dispatch only when one role's output is genuine input to another (e.g., security review *of* a designer's proposed data-flow diagram).

### Rule 4 — Artifact passing

Role subagents write their full findings to `tmp/<role>-review-<task-slug>.md`. The lead agent reads file references, not full output through the chat channel. Keeps the lead's context window lean — critical for complex multi-role tasks where each role might produce 200 lines.

### Rule 5 — Start wide, narrow later

Each role subagent does a broad pass first (from `ROLE.md`'s "What I look for — broad pass"), then drills into 1-3 specific concerns using deep-dive heuristics. Don't ask roles to deep-dive immediately; they default to overly narrow searches.

### Rule 6 — End-state evaluation

Grade the synthesized output, not intermediate subagent steps. A good synthesis:

- Surfaces ≥1 finding per role that the others did not surface (otherwise the roles overlap and you're wasting calls)
- Cites sources from each role's `sources.md`
- Names ≥1 explicit conflict between roles (or states "no conflicts found" — the absence is also a finding)
- Recommends ≥1 concrete next action
- Stays within ~400 lines for a 4-role review (each role contributing ≤100 lines of distilled findings)

### Rule 7 — Failure-mode guardrails

Hard caps. The skill stops working without them:

- **Max 7 role subagents per invocation** (one per role).
- **No nested spawning** — a role subagent must not spawn another role subagent.
- **Synthesis within 1 turn** of receiving the last subagent finding.
- If a subagent hangs or returns an empty artifact, the lead notes it in the synthesis and proceeds with the remaining N-1 — never restarts the whole orchestration.

### Rule 8 — Heuristics over rigid rules

The skill teaches judgment: when to escalate to more roles, when to drop a role mid-flight, how to handle two roles surfacing contradictory recommendations. It does not prescribe a fixed sequence. Anthropic's evidence: rigid rules degrade fast in novel situations.

## Application

### Step 1 — Triage

Ask the user (or decide, if the user has signalled enough):

> "Which roles are load-bearing for this task? The candidates are: software-engineer, product-manager, designer, tester, security-expert, data-scientist, marketing-expert."

Heuristic: if the work touches users, include `product-manager` and `designer`. If it touches data flow or auth, include `security-expert`. If it touches measurement, include `data-scientist`. Pick the minimum set — usually 3, rarely more than 5.

### Step 2 — Brief each role

For each selected role, draft a delegation block with all five required fields (Rule 2). Use this template. (Note: subagents are spawned with explicit `roles/{role}/ROLE.md` paths — they start without `CLAUDE.md` / `CATALOG.md` and therefore do not go through dispatcher matching. Their role is assigned, not selected.)

```
Adopt the {role} role from roles/{role}/ROLE.md.

Scope: {one-sentence scope, e.g., "Review the attached PR for measurement validity"}
Output format: Markdown file at tmp/{role}-review-{slug}.md, ≤200 lines, with sections:
  - "Broad pass" (3-5 bullets)
  - "Deep dive" (1-3 concerns, each with source citation)
  - "Recommendation" (1-3 concrete actions)
Sources: cite from roles/{role}/sources.md; do not introduce frameworks not in that file
Success criteria: at least one finding the other roles would miss; every finding traceable to a source
Out of scope: {what this role should NOT review — name the other roles that own those concerns}
```

### Step 3 — Parallel dispatch

Spawn all role subagents in a **single message** with multiple tool calls. Each subagent gets its own delegation block. No serial dispatch unless Step 2 surfaced a genuine dependency.

### Step 4 — Collect artifacts

Wait for all subagents to complete. Read the `tmp/<role>-review-<slug>.md` files — not the subagent return messages. The artifact is the source of truth.

If a subagent failed to produce an artifact, note it in the synthesis ("$role review unavailable — see Step 7"). Do not retry; the orchestration is a single pass.

### Step 5 — Synthesize

Produce a single document with this structure:

```markdown
# Multi-role review — {task slug}

Roles invoked: {list}

## Summary
2-3 sentences. The highest-stakes finding overall.

## Findings by role
For each role:
  - Broad pass (1-2 bullets, distilled from the artifact)
  - Deep dive (the role's strongest finding, with source citation)
  - Recommendation

## Conflicts between roles
Explicit. "Designer recommends X; security-expert flags X as a risk because Y."
If no conflicts: state "No conflicts surfaced — note that this may itself be a signal that the roles are too aligned."

## Combined recommendations
Ranked. 3-5 max. Each one names the role(s) that surfaced it.

## What was not reviewed
Roles not invoked, and why.
```

### Step 6 — Hand back to user

Return the synthesis, *not* the individual artifacts. The user can drill into `tmp/<role>-review-<slug>.md` files if they want more depth.

### Step 7 — Capture lessons

If the synthesis surfaced a recurring pattern (a role consistently misfires, a delegation template needs tightening, a role's `sources.md` is missing an anchor), invoke `extract-lesson` to propose a delta. This closes the feedback loop.

## Examples

### Example 1 — Cross-functional PR review (success)

**Task:** Review PR #423: "Add SSO via OIDC, replace email/password fallback"

**Triage:** software-engineer, security-expert, designer, product-manager (4 roles — auth touches all of them)

**Delegation snippet for security-expert:**
```
Adopt the security-expert role from roles/security-expert/ROLE.md.

Scope: Threat-model the OIDC flow change in PR #423; assess removal of
       email/password as auth degradation.
Output format: tmp/security-review-pr-423.md, ≤200 lines.
Sources: OWASP ASVS (auth controls), Shostack threat-modeling (STRIDE).
Success criteria: explicit threats categorized by STRIDE; assessment of
                  attack surface delta; recommendation on whether to keep
                  email/password as recovery path.
Out of scope: UI presentation of SSO flow (designer); product implications
              of forced SSO (product-manager); test coverage (tester).
```

**Synthesis outcome:** four roles, four non-overlapping findings. Security flagged that removing email/password closes an account-recovery path. Designer flagged missing error states for failed OIDC callback. Engineer flagged token-refresh race in the implementation. PM flagged that 18% of users haven't configured SSO and would be locked out. Conflict surfaced: designer wanted graceful fallback UI; security wanted no fallback at all. Resolved in synthesis recommendation: phased rollout with recovery email codes — a fifth concrete action the original PR didn't address.

### Example 2 — Over-spawning (failure)

**Task:** "Review this typo fix."

**What the agent did wrong:** spawned all 7 roles. Marketing-expert returned "this typo fix has no marketing implications." Data-scientist returned similar. Five of seven reviews were noise.

**What Rule 1 prescribes:** typo fix is a single-domain task → 1 role (software-engineer, or skip multi-role-review entirely).

**Lesson captured:** added explicit triage guardrail — "If the task is bounded to a single file and <50 lines changed, default to 1 role and require justification to invoke more."

## Common Pitfalls

### Pitfall 1 — Vague delegation

**Symptom:** Multiple subagents return the same finding (e.g., security-expert and software-engineer both flag the same SQL injection). Or one role returns a one-paragraph generic summary.

**Consequence:** Wasted calls; user loses confidence in the orchestration; synthesis becomes harder because findings overlap.

**Fix:** Enforce Rule 2 — every delegation includes scope + format + sources + criteria + out-of-scope. The "out of scope" line is the most-skipped and most-load-bearing.

### Pitfall 2 — Over-spawning

**Symptom:** Invoking 7 roles when 3 would do. Five reviews return "no concerns" or generic affirmations.

**Consequence:** Token cost, user fatigue, signal-to-noise collapse. Anthropic explicitly cites this as the most common multi-agent failure mode.

**Fix:** Rule 1 + the triage step. Default conservatively. If unsure, start with 3 and add roles only if the synthesis reveals gaps.

### Pitfall 3 — Sequential dispatch when parallel would work

**Symptom:** The skill takes 10x longer than necessary because the lead is invoking roles one at a time.

**Consequence:** Negates the entire point of multi-agent orchestration. Anthropic measured up to 90% time savings from parallel dispatch on complex queries.

**Fix:** Rule 3 — single message, multiple tool calls. The only valid exception is a real dependency, not an imagined one.

### Pitfall 4 — Synthesis as concatenation

**Symptom:** The synthesis reads as four mini-reports glued together with headers, no integration, no conflict-surfacing.

**Consequence:** The user could have read the four artifacts directly; the synthesis adds no value.

**Fix:** Rule 6 — the synthesis must explicitly name conflicts (or assert their absence) and produce a ranked, combined recommendation list. If you can't write the Conflicts section meaningfully, the roles weren't briefed sharply enough — go back to Step 2.

### Pitfall 5 — Swallowing role conflicts

**Symptom:** Two roles disagree (designer wants X; security flags X as risk); the synthesis picks one and discards the other, or papers over the disagreement with "consider both."

**Consequence:** The user is denied the most valuable output multi-role review can produce — a clear named tension that requires their judgment.

**Fix:** Surface conflicts explicitly in the Conflicts section. State each role's position, the source it cites, and the underlying value tradeoff. Then recommend — but never hide.

### Pitfall 6 — Re-spawning a failed subagent

**Symptom:** One role returns garbage; the lead retries with the same brief, gets garbage again, retries again. The orchestration loops.

**Consequence:** Stuck. Token spend. User waits.

**Fix:** Rule 7 — single pass. If a role fails, note it in the synthesis and proceed. If retries are needed, that's a separate, user-initiated invocation with a tightened delegation.

## References

- **Anthropic Engineering** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — the source for all eight rules in Key Concepts.
- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — harness principles; "Spec problems, not solutions" is the foundation of Rule 2.
- **Related Hornero skills:**
  - `skills/spec-the-problem/SKILL.md` (phase 3) — runs before multi-role-review to ensure the task itself is well-specified
  - `skills/extract-lesson/SKILL.md` (phase 3) — runs after, captures recurring delegation mistakes
- **All role ROLE.md files** — the delegation references each role's `ROLE.md` + `sources.md`.

## Skills index entry

This is a workflow skill. It orchestrates *every* role's reviewer-mode content. It does not orchestrate producer-mode work; for that, invoke a role's component or workflow skills directly.
