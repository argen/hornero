# Orchestration heuristics

When to invoke 1 vs 4 vs 7 roles. When to dispatch in parallel vs sequentially. How to keep multi-agent reviews from degenerating into noise.

Grounded in Anthropic's ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — see `methodology.md` for the eight operating rules.

## How many roles? — the triage matrix

| Task shape | Roles |
|---|---|
| Bounded change, single concern (typo, rename, small refactor) | 0 — just do it |
| Single-domain task (a bug fix in one file, a UI tweak) | 1 |
| Cross-functional review (feature PR, RFC draft, plan critique) | 2-4 |
| Major decision (architecture, launch, repositioning) | 5-7 (rare) |
| "Review everything" — repo or strategic-level audit | Split into smaller tasks first |

### Rules of thumb

- **Default low.** If unsure between 3 and 5, pick 3.
- **Add roles only with cause.** Each added role needs a named reason — "this work also touches X."
- **Drop a role mid-flight if it isn't earning its keep.** A role surfacing only generic findings is the wrong role for this task.
- **Never invoke 7 roles automatically.** Even for major decisions, ask "which 7?" If you can't name a reason for each, you don't need all 7.

## Which roles? — the work-to-role mapping

Work is rarely cleanly one domain. The patterns:

### Anything touching users
- `product-manager` (problem fit, scope, success criteria)
- `designer` (interaction, accessibility, missing states)

### Anything touching auth, data, dependencies
- `security-expert`
- `software-engineer` (often)

### Anything touching measurement, models, experiments
- `data-scientist`
- `product-manager` (decision-supporting)

### Anything touching public communication
- `marketing-expert`
- `product-manager` (alignment with positioning)

### Anything touching code itself
- `software-engineer`
- `tester` (often, on non-trivial changes)

The intersection of two columns is a good 2-3 role review. Three columns suggests 4-5 roles.

## Parallel vs sequential

**Parallel by default.** Spawn roles in one message, multiple tool calls. Anthropic's evidence: up to 90% time savings.

**Sequential only when:**

1. **A role's output is genuine input for another.** Example: security-expert needs the designer's data-flow diagram to threat-model the new flow. Designer goes first, then security-expert.
2. **The user asks for staged review.** Example: "do the PM pass first, decide if we proceed, then bring in design and engineering." Honor it.
3. **The first role might invalidate the work.** Example: if PM review concludes "this is solving the wrong problem," the others are wasted. Run PM first, abort if PM rejects.

If you're tempted to go sequential for any other reason, ask: is this a real dependency or an imagined one? Imagined dependencies kill the orchestration's value.

## Resource-scaling guardrails

Anthropic measured: agents over-spawn without explicit guidance. They saw 50 subagents for queries that needed 1.

Hornero's hard limits:

- **Max 7 role subagents per invocation.** (One per role.)
- **No nested spawning.** A role subagent cannot spawn another role subagent. If a role discovers it needs another lens, it flags "consult X" in its output — the user invokes that separately.
- **Synthesis within 1 turn** of receiving the last finding. No back-and-forth iteration.

Why hard limits: emergent behavior in multi-agent systems is unpredictable; without limits, sessions can spiral and waste tokens for no signal.

## When to expand the role set mid-review

You started a 3-role review; one of the roles' findings reveals a concern outside its lens. Two options:

**Option A — Note as "consult X," let the user decide.** Most common. The current review completes; the user runs a follow-up if they want.

**Option B — Spawn an additional role as a follow-up to the current review.** Only if (a) the additional role's findings are genuinely needed before synthesis, and (b) the total stays ≤7. State explicitly in the synthesis that you added the role and why.

Default to A. B is the exception, not the rule.

## When to drop a role mid-review

A role's output came back generic or "no concerns" — and the briefing was reasonable. Possible interpretations:

- **The role was wrong for this task.** Drop it from the synthesis; note in "what was not reviewed" with reason "no concerns surfaced; likely not load-bearing for this work."
- **The brief was wrong.** Re-brief and re-run. Acceptable if you're not in a hard time-box.
- **The role's `sources.md` is missing something this task needed.** Capture as an extract-lesson candidate.

Generic findings are themselves data — they tell you about the brief or the role, not just about the work.

## Resource cost — be honest

A 4-role review costs roughly 4× the tokens of a single-role review, plus orchestration overhead. For a typical engineering org, that's:

- $0.05-0.20 per review (cheap)
- 5-15 minutes wall-clock
- ≤400 lines of synthesis to read

The user's bottleneck is usually the reading, not the spend. Optimize for output quality and density, not cheapness.

## Anti-patterns

### Over-spawning to look thorough
**Symptom:** 7-role reviews on routine work. Cost without value.
**Fix:** Pick the load-bearing roles only. Justify each.

### Sequential dispatch for no reason
**Symptom:** Reviews take 4x as long as they need to.
**Fix:** Real dependencies are rare. Default parallel.

### Synthesis-as-concatenation
**Symptom:** "Here's role 1, here's role 2, here's role 3, here's role 4."
**Fix:** The synthesis must integrate. Conflicts must be named. Recommendations must be ranked across roles.

### Hoping more roles means more accuracy
**Symptom:** Doubling roles when reviews feel weak.
**Fix:** Tighten briefs first. A poorly-briefed 7-role review is worse than a well-briefed 3-role review.

### Treating multi-role review as a substitute for engineering judgment
**Symptom:** Every decision routed through multi-role review.
**Fix:** Multi-role review supplements judgment for cross-cutting work. It doesn't replace expertise on bounded work.

### Mixing exploration and editing in the same context
**Symptom:** A reviewer subagent both critiques and edits, or the orchestrator re-explores in the same turn it's writing. Review quality drops; edits drift; both turns end up half-doing each other's job.
**Fix:** Reviewers are read-only by construction. The orchestrator turn synthesises and writes. If the synthesis surfaces new exploration needs, that's a separate read-only pass — don't bolt it onto the write turn. Anthropic's blog calls this out as a top subagent mistake.
