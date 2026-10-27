---
name: audit
description: Runs a rot-review pass that surfaces skills, roles, and hooks that may no longer be earning their keep. Run quarterly. Reuses validate-skill, smoke-check, and the eval suite to separate validated, still-load-bearing items from compensatory ones that are candidates for retirement.
type: command
disable-model-invocation: true
---

# /audit

The user wants a structured pass to find Hornero rot — skills, roles, hooks, or rules that exist to compensate for older-model limitations or one-time incidents and are now drag rather than scaffolding.

Source: Anthropic, ["How Claude Code Works in Large Codebases"](https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start) — *"Retire compensatory skills/hooks. Rules optimized for older models may constrain newer ones."*

## What to do

1. **Load and follow [`playbooks/skill-rot-review.md`](../../playbooks/skill-rot-review.md)** — it's the human-judgment checklist. This command is the automation that feeds it.

2. **Run the mechanical sweep** — surface the data the judgment turn needs:

   ```bash
   ./scripts/smoke-check.sh
   ```

   Confirms baseline health: all skills pass anatomy, frontmatter intact, CATALOG.md not drifting, install.sh count matches. If smoke-check fails, fix that first — rot review on a broken baseline is noise.

3. **Catalog usage scan** — for each skill, check the most recent `evals/runs/*` directory:
   - Skills invoked in ≥1 recent run → "load-bearing"
   - Skills not invoked in the last N runs → "candidate for retirement" (not "delete" — candidates are the input to the judgment step, not the output)
   - Skills cited by other skills (via `[[name]]` links or References) → "load-bearing even if not directly invoked"

4. **Sources-anchor cross-check** — for each role's `sources.md`, list anchors that no skill in that role currently cites in its Key Concepts or References. These are candidates for sources-pruning or for a skill that should exist but doesn't.

5. **Compensatory-rule scan** — read top-level `CLAUDE.md`, `AGENTS.md`, `DISPATCHER.md`, `methodology.md` and any project memory files. Flag any rule that:
   - References a specific past incident with no other current justification ("don't do X because last quarter…").
   - Was written for an older model and may not be needed by the current generation.
   - Is a workaround for a tool limitation that's since been fixed.

6. **Present findings, three buckets**:

   - **Load-bearing — keep.** Validated by recent invocation or live citation chain.
   - **Candidates for retirement.** With evidence (last invocation date, no citers, original incident no longer applicable). Propose the exact deletion / merge.
   - **Compensatory — review.** Rules that may no longer be earning their keep. Surface, don't auto-delete; the user decides.

7. **Stop at proposals.** Do not delete anything in this command. The playbook is the human-judgment turn; the user accepts or rejects each candidate individually.

## Output shape

```
Audit pass — <date>

Baseline: smoke-check ✓ (59 skills, 7 ROLE.md, 7 agents, CATALOG zero drift)

Skills not invoked in last <N> eval runs:
- <role>/<skill> — last invoked: <date or "never since v1"> — citers: <list or "none">

Sources-anchor orphans (in sources.md but not cited by any skill):
- <role>: <anchor 1>, <anchor 2>

Compensatory rules to review:
- <file>:<line> — "<rule>" — added <when?> for <incident?>. Current relevance: <judgment>.

Recommend running playbooks/skill-rot-review.md to decide retire / merge / keep per candidate.
```

## When NOT to run

- Less than 3 months since the last `/audit` — too soon for meaningful signal.
- Hornero is in active heavy development with skills landing weekly — let the dust settle first.
- The user just wants smoke-check; run `./scripts/smoke-check.sh` directly instead.
