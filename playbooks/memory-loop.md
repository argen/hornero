# Memory loop — the read-decide-write cycle

Hornero ships a project-local memory layer at `memory/decisions/`. This playbook walks the loop end-to-end: how reviewer agents read it, how producer skills consume it, and how decisions get written back so the next session starts upstream of where this one started.

## The principle

The most expensive failure mode in AI-assisted engineering is **re-proposing approaches the team already considered and rejected**. The fix is not better prompting; it is project-local memory the assistant queries before proposing, and writes back after deciding.

Hornero's version of this loop is intentionally markdown-only: structured Markdown files in `memory/decisions/`, grep-scale retrieval, no vector store, no daemon, no CLI. Projects that outgrow grep-scale memory have an obvious upgrade path ([Quorum / Chronicle](https://github.com/balpal4495/Quorum) is the higher-infrastructure version of this idea). But for the projects most teams actually work in, markdown + grep is sufficient and stays human-readable forever.

## The three skills

| Skill | Side | Purpose |
|---|---|---|
| [`skills/memory-query`](../skills/memory-query/SKILL.md) | Read | Scan `memory/decisions/` before reviewing or producing. Surface 1-5 relevant prior decisions. |
| [`skills/decision-record`](../skills/decision-record/SKILL.md) | Write | After a decision lands, capture diagnosis + decision + rejected alternatives + validation + revisit-by. |
| Reviewer agents (all 7) | Read (preamble) | Every reviewer agent runs `memory-query` as its first step. |

## The loop, in eight steps

### 1. A new piece of work arrives

A PR, an RFC, a PRD, a launch question, a roadmap call — anything that would normally trigger a Hornero role or `multi-role-review`.

### 2. Memory check (reviewer-preamble)

The reviewer agent (or the orchestrator) runs `memory-query`:

- Does `memory/decisions/` exist? If not, log "no memory dir, proceeding without prior context" and skip to step 4.
- Grep frontmatter for matches on `scope`, `affected_areas`, or `roles`.
- Surface 1-5 most relevant prior decisions, ranked by recency × overlap × `status:committed`.

### 3. Lead with conflicts

If a surfaced prior decision **directly conflicts** with the current proposal, lead the review with the conflict. Do not bury it in the deep dive.

> *"Memory check: this PR proposes HS256-signed JWTs. Prior decision `2026-04-30-jwt-rs256-over-hs256` rejected HS256 explicitly (key-rotation problem). Leading the review with this — is the new proposal a deliberate revisit, a supersede, or an oversight?"*

If no conflict, mention the surfaced records as context and proceed with the normal review.

### 4. Review or produce as usual

The role's standard heuristics apply. The memory check informs the work; it does not replace it.

### 5. Synthesise the outcome

If the work was a `multi-role-review` or `cross-functional-orchestration`, synthesise the role findings into a recommendation. If the work produced a new decision (cross-functional, posture-shaping, alternative-rejecting), proceed to step 6. If it produced a feature spec or a critique, no decision-record is needed.

### 6. Decide whether to write

A decision warrants a `decision-record` when **all** of the following hold:

- A real choice was made (not just analysis).
- Alternatives were seriously considered.
- A future session might benefit from knowing about it.

A decision **does not** warrant a record when:

- It's a routine implementation choice already covered by code/ADR.
- It's a feature spec (use [`skills-prd`](../roles/product-manager/skills/prd/SKILL.md) instead).
- It's an architectural call (use [`skills-adr`](../roles/software-engineer/skills/adr/SKILL.md) instead).

Records are for *cross-role* decisions and *strategy postures* — the calls that ADR / PRD scopes don't cover.

### 7. Write the record

Invoke `decision-record`. Produce `memory/decisions/YYYY-MM-DD-slug.md` with:

- Frontmatter: `id`, `title`, `date`, `status`, `roles`, `scope`, `affected_areas`, `revisit_after`.
- Body: diagnosis, decision, coherent actions, alternatives rejected (with reasons), validation plan, references.

### 8. Commit the record to git

`memory/decisions/` is committed to git like any other source artifact. The corpus survives sessions, teammates, and turnover. The next session — whoever runs it — starts with this context.

## Worked example — the shadow-column migration

A real-world example showing the full loop.

### What happened

A PR proposes adding a NOT NULL column to a 50M-row `users` table. The PR shows a single migration: `ALTER TABLE users ADD COLUMN signup_source TEXT NOT NULL DEFAULT 'unknown';`

### Step 2-3 (memory check + conflict)

The software-engineer reviewer agent runs `memory-query` first.

```
> Memory check: scanning memory/decisions/ for {database, migration, users-table, schema-change} ...

Found 0 matching records. This is genuinely new territory.
```

No prior decisions surfaced. The reviewer proceeds with a normal review.

### Step 4-5 (review + synthesis)

The reviewer flags: exclusive lock on `users` for the duration of the migration. Staging measurement: 4m17s. Auth offline for 4+ minutes. Recommends multi-role-review with security-expert (auth surface) and data-scientist (backfill volume).

Multi-role-review runs. Synthesis: shadow-column pattern (add nullable → backfill → add NOT NULL → swap reads). pg_repack rejected (tooling dependency, no rollback). Naive ALTER rejected (lock duration).

### Step 6-7 (write the record)

A decision was made; alternatives were considered; future sessions will care. Worth writing.

The PM (or orchestrator) invokes `decision-record`. The file `memory/decisions/2026-05-14-shadow-column-migration.md` is created with diagnosis, decision, coherent actions, rejected alternatives, validation plan, revisit-by 2026-08-14.

### Step 8 (commit)

The record is committed alongside the migration PR. Both ship together.

### Three months later — the loop pays off

A new engineer joins. Six months in, a different PR proposes pg_repack for a different large-table migration. The software-engineer reviewer runs `memory-query` and surfaces `2026-05-14-shadow-column-migration`:

> *"Memory check: a 2026-05 decision on a similar problem explicitly considered and rejected pg_repack (tooling dependency, no rollback). The rationale may still hold — or your migration is in a different shape. Worth naming explicitly in the PR before review."*

The new engineer doesn't re-derive the rejection from scratch. They either adopt the prior pattern, or they explain why their case is different — *upstream* of the review, not in response to it.

That's the loop.

## Common pitfalls

1. **Recording analyses, not decisions.** A memo summarising a discussion is documentation; a record names a *choice*. If no alternative was rejected, it's probably not a decision-record.
2. **Skipping the memory check.** Reviewer agents that skip the preamble lose most of the layer's value. The discipline is "look first, then think."
3. **Letting the corpus rot.** Records past their `revisit_after` date should be reviewed. A corpus of stale "committed" records that no longer hold is worse than no corpus. Schedule a quarterly revisit pass; flip the status of records that no longer apply.
4. **Confusing memory with documentation.** Memory captures *decisions* (what we chose and why); documentation captures *state* (how things currently are). Mixing the two pollutes both.
5. **Surfacing too many records.** Five is the soft cap on a memory-check surface. Ten is noise — readers stop reading. If your scope tags routinely produce more than five matches, the tags are too coarse.

## When the layer is off

If `memory/decisions/` does not exist, the layer is **opt-in** and everything still works:

- Reviewer agents log "no memory dir" and proceed with standard heuristics.
- `memory-query` no-ops with a short note.
- `decision-record` can still be used; it creates `memory/decisions/` on first write.

Most projects should turn it on. The break-even is roughly "after the second time someone re-derives a decision the team already made." For small early-stage projects, that hasn't happened yet — wait until it does.

## See also

- [`skills/memory-query`](../skills/memory-query/SKILL.md) — read side, in full.
- [`skills/decision-record`](../skills/decision-record/SKILL.md) — write side, in full.
- [`playbooks/feedback-ritual.md`](feedback-ritual.md) — the weekly cadence; memory-loop is one input to this ritual.
- [`skills/extract-lesson`](../skills/extract-lesson/SKILL.md) — surfaces decisions worth recording from session transcripts.
- [Quorum / Chronicle](https://github.com/balpal4495/Quorum) — the higher-infrastructure version of this idea (vector retrieval, gated commits, GH Action proposals). Hornero's memory layer is the markdown-only Hornero-shape; Quorum is the upgrade path for projects that outgrow grep-scale memory.
