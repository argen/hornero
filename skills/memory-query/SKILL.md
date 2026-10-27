---
name: memory-query
description: "Scans the project's memory/decisions/ directory for prior decisions whose scope, affected areas, or roles overlap the current work, and surfaces the relevant entries before fresh analysis begins. Use before reviewing, proposing, or producing a non-trivial artifact in a project that keeps lightweight decision files. If the project has a chronicle/ layer use chronicle-recall instead, which queries schema-validated entries."
intent: |
  The read side of the Hornero memory layer. Closes the most expensive
  failure mode in AI-assisted work — re-proposing approaches that the
  team has already considered and rejected. Reviewer agents call this
  skill at the top of every review; producer skills call it before
  drafting a new artifact.
type: workflow
theme: memory
best_for:
  - Top of every reviewer-agent invocation (the "memory check" preamble)
  - Before drafting a PRD, RFC, ADR, strategy kernel, or launch brief
  - Before running an orchestrated review on a contested topic
  - When a user asks "have we thought about X?"
scenarios:
  - "Security-expert reviewer is invoked on a JWT change — memory-query scans for prior auth decisions, surfaces a 2026-04 record rejecting HS256, reviewer leads with that context"
  - "PM drafting a Q3 PRD on SMB onboarding — memory-query surfaces the 2026-05-12 record refusing the SMB segment, PRD scope shifts before any drafting"
  - "Engineer about to propose pg_repack for a migration — memory-query surfaces the 2026-05-14 shadow-column record that explicitly rejected pg_repack with reasons"
estimated_time: 1-3 minutes
---

# Memory query

## Purpose

Scan the project's local memory before doing fresh work. If a relevant decision has already been made, the work should start *upstream of that decision*, not re-derive it. This skill is the read side of the memory loop; [`decision-record`](../decision-record/SKILL.md) is the write side.

The skill is short by design. It is the *discipline of looking first*, not a sophisticated retrieval system. Markdown + grep is sufficient — a project with more than ~100 decision records has bigger problems than retrieval (corpus curation, role boundaries, decision discipline).

## Key Concepts

### What lives in `memory/`

By convention, a Hornero-equipped project carries:

```
memory/
  decisions/        # one Markdown file per decision (see decision-record skill)
  SUMMARY.md        # optional — recent activity index
```

If `memory/decisions/` does not exist, this skill no-ops with a short note (no error). The absence itself is signal: this is an early-stage project, and the cost-benefit of forcing decisions through the recording loop has not yet flipped.

### Frontmatter is the index

Every decision-record file carries structured frontmatter:

```yaml
id: 2026-05-14-shadow-column-migration
title: ...
date: 2026-05-14
status: committed | superseded | reversed
roles: [software-engineer, security-expert, data-scientist]
scope: [database, migrations]
affected_areas: [db/migrations/, src/models/user.ts]
revisit_after: 2026-08-14
```

Queries match on `scope`, `affected_areas`, and `roles`. Body text is searched only after frontmatter narrows the candidate set.

### What counts as "relevant"

A decision is relevant to the current task if any of:

- **Scope overlap** — a tag in the record's `scope` matches a tag the current task touches (auth, database, pricing, onboarding, etc.).
- **Affected-area overlap** — the current work touches a file path or module named in `affected_areas`.
- **Role overlap** — the current invocation is one of the roles in `roles` and the topic word-overlaps.
- **Direct mention** — the current task or PR description names the decision ID or a synonym.

Surface 1-5 records, ranked by recency × overlap × `status:committed`. Do not surface more — the value collapses with volume.

## Application

The skill is invoked in one of two postures: reviewer-preamble or producer-preamble. Both follow the same shape.

### Reviewer preamble (every reviewer agent should run this first)

1. **Identify the topic.** What is being reviewed? Extract 2-5 keywords (e.g., "auth", "JWT", "session", "key rotation").
2. **Check existence.** Does `memory/decisions/` exist in the working directory? If not, log "No memory/ directory; proceeding without prior-decision context" and stop.
3. **Scan frontmatter.** Grep `memory/decisions/*.md` for matches in `scope`, `affected_areas`, or `roles`. Read the candidates' bodies.
4. **Filter by status.** Drop records where `status: superseded` *unless* the superseding record is also surfaced (rare; surfaces a versioning lineage).
5. **Rank.** Recency (most recent first), then specificity of overlap, then `committed` over other statuses.
6. **Surface.** State, in the review opening: "Memory check: N relevant prior decisions found. <id1> (date): <one-line summary>. <id2>: ..." If conflicts exist between prior decisions and the current proposal, name them explicitly.

### Producer preamble (before drafting a new artifact)

Same as reviewer-preamble, with one addition: if a surfaced decision *directly answers* the question being posed, stop and ask the user whether the new artifact is intended to **implement** that decision (continue), **revisit** it (note this explicitly in the new artifact's frontmatter), or **supersede** it (the new artifact's frontmatter should carry `supersedes: [<id>]`).

### When no matches surface

Say so explicitly: "Memory check: no prior decisions in `memory/decisions/` match this scope." This is informative — it tells the user the work is genuinely new territory, and the resulting artifact may itself warrant a decision-record afterwards.

## Examples

### A reviewer-agent preamble in action

The security-expert reviewer is invoked on a PR that introduces HS256-signed JWTs.

```
> Memory check: scanning memory/decisions/ for {auth, JWT, session, signing} ...

Found 2 prior decisions:

- 2026-04-30-jwt-rs256-over-hs256 (committed, security + software-engineer)
  Decision: use RS256, not HS256. Rejected HS256 because key rotation requires invalidating all active sessions.
  → DIRECT CONFLICT with current PR. Leading the review with this.

- 2026-03-12-session-storage-redis-out (committed, software-engineer)
  Decision: removed Redis-backed sessions in favour of stateless JWT. Context overlap but not direct conflict.

Proceeding with security review with the RS256 decision as the starting context, not from scratch.
```

The reviewer then leads with the conflict, not with a generic STRIDE pass. The user gets the institutional memory in the first sentence, not the fifth message.

### A producer preamble before a PRD draft

A PM is about to draft a Q3 PRD on improving SMB onboarding.

```
> Memory check: scanning memory/decisions/ for {SMB, onboarding, segment, ICP} ...

Found 1 prior decision:

- 2026-05-12-refuse-smb-segment (committed, product-manager + marketing-expert)
  Decision: refuse the SMB segment for 2026 — focus mid-market exclusively.
  Revisit: 2026-11-12.

This appears to directly conflict with the proposed PRD scope. Three options:

  (a) Drafting this PRD implements something else (mid-market onboarding misread as SMB)?
  (b) The PRD is a deliberate revisit ahead of 2026-11-12?
  (c) The PRD supersedes the prior decision?

Please confirm before I draft.
```

This is the load-bearing case. Without the memory check, the PM might draft an SMB-onboarding PRD that the company decided three weeks ago not to invest in. With the check, the conversation re-centers on whether the strategy has actually changed.

### No-match case

```
> Memory check: no prior decisions in memory/decisions/ match scope {feature-flag, rollout, percentage}.

Proceeding with no prior-decision context. This work is in fresh territory; consider whether the outcome warrants a decision-record entry.
```

## Common Pitfalls

1. **Treating memory-query as optional polish.** If a reviewer agent skips this preamble, the agent's value drops sharply on any non-trivial project. The discipline is "look first, then think" — the same discipline good engineers apply when joining a team.
2. **Surfacing too much.** Five is the soft cap. Ten surfaces are noise; the user stops reading. If the candidate set is large, the *scope tags* are too coarse — that is a memory-corpus problem, not a query problem.
3. **Ignoring superseded records.** A superseded record is a *teaching artifact* — it shows the evolution. Don't drop it silently; surface it as lineage when the superseding record is also relevant.
4. **Confusing memory with documentation.** Memory captures *decisions* (what we chose and why), not state (how the system is currently configured). State lives in code, schemas, dashboards. Records that read like documentation should not be in `memory/decisions/`.
5. **Re-running on every sub-task.** One memory check per invocation (a review, a draft, an orchestrated review run) is enough. Re-running on every tool call burns context.
6. **Trusting `revisit_after` blindly.** A record past its revisit date is not invalid — it is *due for review*. Surface it with a "revisit-due" flag rather than dropping it.

## References

- [`skills/decision-record`](../decision-record/SKILL.md) — the write side; the artifact shape this skill queries against.
- [`playbooks/memory-loop.md`](../../playbooks/memory-loop.md) — the end-to-end read-decide-write cycle.
- Quorum / Chronicle (Bal Pal, [github.com/balpal4495/Quorum](https://github.com/balpal4495/Quorum)) — the higher-infrastructure version of this idea (vector retrieval, gated writes, GH Action proposals). This skill is the markdown-only Hornero-shape; for projects that outgrow grep-scale memory, Quorum is the upgrade path.
- David A. Patterson and John L. Hennessy on retrieval discipline: *Computer Architecture: A Quantitative Approach* — the principle that *cache hit* before *compute* is older than computing; it applies to decision retrieval no less than to memory addressing.
