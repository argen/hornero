# Hornero Methodology

A two-layer synthesis. The first layer governs how the harness compounds over time. The second governs how roles collaborate as a team in any given session.

## Source articles

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the harness layer
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — the collaboration layer

## Layer 1 — Harness principles (Chris MDP)

### 1. Harness beats prompts

The scaffolding around requests matters more than the model or the wording. Quality emerges from context selection, file structure, skill files, and the agent loop — not from clever phrasing.

**In Hornero:** every role and skill is a piece of scaffolding. The repo *is* the harness.

### 2. Spec problems, not solutions

Brief the AI on constraints and success criteria; leave implementation open. Waterfall-style upfront specification breaks the moment circumstances change.

**In Hornero:** the `spec-the-problem` cross-role skill forces a problem statement + constraints + success criteria pass before any non-trivial implementation. Role producer-mode skills follow the same pattern.

### 3. Context sweet spot

Output quality peaks with sufficient detail — too little produces generic results, too much causes the model to drown in noise. Knowing when to reset the conversation is a learnable skill.

**In Hornero:** the `context-reset-check` cross-role skill detects drift signals (long sessions, repeated rework, contradictory outputs) and recommends starting fresh with a tight brief.

### 4. Feedback-loop discipline

Lessons from agent failures must feed back into CLAUDE.md, skill files, and tests — not stay locked in individual conversations.

**In Hornero:** the `extract-lesson` cross-role skill runs at session end. It scans for surprises and corrections, then proposes concrete deltas to a role file or skill. The `playbooks/feedback-ritual.md` formalizes this as a weekly review.

### 5. Senior-engineer role shift

The job becomes training the agent and teaching colleagues, not reviewing every diff. You build skill files; you don't manually check every change.

**In Hornero:** the repo is the training material. Every role file teaches the agent how to think from that role's perspective. Every skill teaches one durable competence.

## Layer 2 — Multi-agent orchestration (Anthropic)

The role skills are most powerful when invoked together. Hornero adopts the orchestrator-worker pattern, sharpened for role-based critique and production.

### Architecture

- **Lead agent (orchestrator)** receives the user's task, decomposes it, spawns role subagents in parallel, synthesizes their condensed findings.
- **Role subagents (workers)** adopt a specific role persona, work in an isolated context window, return a condensed report — not full reasoning.
- **Synthesizer** is the lead agent (not a separate role); it integrates findings, surfaces conflicts, produces unified output.

### Eight operating rules

1. **Resource scaling** — match subagent count to task complexity: single-domain → 1 agent; cross-functional → 2-4; major decision → 5-7.
2. **Detailed delegation** — every spawn includes scope, output format, sources to consult, success criteria, and what NOT to investigate.
3. **Parallel-first** — concurrent dispatch in one message. Sequential only when one role's output is genuine input to another.
4. **Artifact passing** — subagents write findings to `tmp/<role>-review-<task>.md`. Lead reads references, not chat-channel output.
5. **Start wide, narrow later** — reviewer-mode roles begin broad, then drill into 1-3 specific concerns.
6. **End-state evaluation** — grade the synthesis, not intermediate steps. Did it surface non-overlapping findings? Cite sources? Produce next steps?
7. **Failure-mode guardrails** — max 7 role subagents per invocation; no nested spawning; synthesis within 1 turn of last finding.
8. **Heuristics over rigid rules** — instill judgment about when to escalate, drop, or handle conflict; don't prescribe fixed sequences.

These rules are encoded in `skills/multi-role-review/SKILL.md` and `playbooks/orchestration-heuristics.md` — not just documented here.

## The memory layer

The two layers above govern *behaviour within sessions*. A third primitive — the memory layer — governs *what carries across them*.

Hornero ships a project-local memory layer at `memory/decisions/`: structured Markdown decision-records, frontmatter-indexed, grep-scale retrieval, committed to git. The two skills [`memory-query`](skills/memory-query/SKILL.md) (read) and [`decision-record`](skills/decision-record/SKILL.md) (write) compose with the seven reviewer agents, which run a memory check as the first step of every review. The end-to-end loop is walked in [`playbooks/memory-loop.md`](playbooks/memory-loop.md).

Why this matters: the most expensive failure mode in AI-assisted engineering is **re-proposing approaches the team already considered and rejected**. The harness layer (Chris MDP) says lessons must feed back into the project; the memory layer is *where* they feed back to. The orchestration layer (Anthropic) says synthesise findings into actionable output; the memory layer is *where* the synthesis becomes durable.

The layer is opt-in per project. If `memory/decisions/` does not exist, every role and skill still works — they just operate without prior-decision context. Most projects should turn it on after the second time someone re-derives a decision the team already made.

For teams that outgrow grep-scale memory, the upgrade path is [Quorum / Chronicle](https://github.com/balpal4495/Quorum) — vector retrieval, gated commits, GH Action proposals. Hornero's role-based reviewers and Quorum's Council are the same orchestrator-worker pattern under different vocabularies; the two compose cleanly.

## The three layers in practice

A productive session uses all three:

- **Per-session** — orchestration rules govern which roles are invoked, how they're briefed, and how findings are synthesized.
- **Across sessions (within a project)** — the memory layer governs which prior decisions inform new work, and what new decisions get captured.
- **Across projects (the harness itself)** — harness principles govern what gets remembered, where the methodology is stored, and how Hornero compounds.

The roles are the substrate. The orchestration is how they collaborate today. The memory layer is how the project compounds. The harness is how the methodology compounds.
