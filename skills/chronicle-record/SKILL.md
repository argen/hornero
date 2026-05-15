---
name: chronicle-record
description: Use after a non-trivial decision is made — captures a structured, schema-validated entry into the project's `chronicle/` layer so future sessions and roles can load it as situational awareness. This is the strict-schema successor to `decision-record`.
intent: |
  The write side of the Hornero Chronicle layer. Converts a decision
  reached in a session into a Markdown-with-YAML-frontmatter file that
  passes deterministic validation, lives in `chronicle/entries/` after a
  human-gated commit, and shows up in `chronicle/SUMMARY.md` for future
  sessions to load on cold-start.
type: workflow
theme: memory
best_for:
  - After a reviewer subagent converges on a recommendation worth preserving
  - After a strategy / posture / pricing call lands
  - After a PRD review rejects an alternative with reasoning
  - After a multi-role review (when re-expanded) produces a coherent recommendation
  - Whenever an alternative is rejected with reasoning the team would re-derive in 6 months
scenarios:
  - "PM critique converges on 'refuse SMB segment for FY26' — chronicle-record captures the diagnosis (CAC payback >12mo), the decision, the rejected alternatives ('pursue both', 'pursue SMB-only') with reasons, and the validation plan. Future PRDs starting from SMB framing will surface this entry via chronicle-recall."
  - "Engineering decision to use shadow-column migration over pg_repack on a 50M-row table — captured by the cross-role review session. When a future role is restored and asked about the same migration pattern, chronicle-recall surfaces this entry first."
  - "Success-metrics policy ('outcome metrics only, never activity') agreed in a strategy session — chronicle-record commits it. Six months later, a different reviewer proposes an activity metric in a PRD; chronicle-recall surfaces the policy before the PRD critique even starts."
estimated_time: 3-8 minutes
---

# Chronicle record

## Purpose

Capture a decision as a machine-queryable artifact so future sessions don't re-derive it. The artifact lives at `chronicle/entries/<id>.md` and conforms to a strict schema enforced by `scripts/chronicle.sh validate`. Any future role — including roles that did not exist at the time of the decision — can load `chronicle/SUMMARY.md` cold-start or call `chronicle-recall` for filtered queries.

The skill exists because **prompting alone does not survive sessions**. The discipline of recording a decision is what makes the next session pick up upstream of it, instead of re-litigating it. Markdown-with-frontmatter is the storage format; the validator is the discipline.

This skill replaces the older `decision-record` skill for new work. Both can coexist; `decision-record` continues to write to the looser `memory/decisions/` layer, while `chronicle-record` writes to the strict `chronicle/` layer with deterministic harness backing.

## Key Concepts

### Two-stage write — propose, then commit

The Chronicle layer is **never** auto-written. The write path is:

1. **Propose** — `scripts/chronicle.sh propose ...` builds a file at `chronicle/proposals/<uuid>.md`. No LLM is involved; the script takes CLI args and emits a fixed shape. Proposals are gitignored.
2. **Human review** — a human reads the proposal, edits the body if needed.
3. **Commit** — `scripts/chronicle.sh commit <uuid>` moves the proposal to `chronicle/entries/<date>-<slug>.md`, re-validates it, regenerates `chronicle/SUMMARY.md`. The agent does not call commit; the human does.

This split is structural, not advisory. The query path looks only at `chronicle/entries/`, never at `chronicle/proposals/`, so a half-formed proposal cannot leak into future sessions until a human has gated it.

### The schema is locked

Every entry's frontmatter must conform to [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md). Required fields: `id`, `title`, `date`, `status`, `confidence`, `source_role`, `scope`, `affected_areas`, `decision`. The validator rejects unknown fields, out-of-range confidence, illegal status / role, mismatched filename, missing body sections.

The body has six required sections in fixed order: Diagnosis → Decision → Coherent actions → Alternatives rejected → Validation plan → Notes. The shape is Rumelt's strategy kernel + a validation plan; the discipline is in the *ordering* (diagnosis before decision; alternatives before validation).

### Confidence is a real field, not a vibe

`confidence ∈ [0, 1]` is required on every entry. Decisions made under low confidence (≤0.6) carry that visibly into the index, so reviewers loading the SUMMARY know which postures to treat as load-bearing vs. provisional. **Don't anchor at 0.85 by default** — calibrate.

### IDs are content-addressable

`id = <YYYY-MM-DD>-<kebab-slug-of-title>`. No randomness. This means:
- Entries sort naturally by date.
- Cross-references (`evidence: [id1, id2]`, `supersedes: id`) are human-readable.
- A file's name is derived from its content — renaming a file without re-deriving the id fails validation.

### Supersedes — the only allowed in-place mutation

When a new decision overrides an old one, set `supersedes: <old-id>` in the new entry. On commit, the validator flips the old entry's `status` to `superseded` and sets its `superseded_by` field. **This is the only path** by which a committed entry's status changes — there is no `chronicle.sh edit`. To "amend," supersede.

## Application

### How to invoke

Most often the agent reaches this skill through the **`chronicle-recall` → critique → chronicle-record** loop in a session:

1. At the top of a session, `chronicle-recall` surfaces relevant prior decisions.
2. The session produces a new decision (PM critique, strategy call, multi-role recommendation).
3. The agent proposes the entry with `chronicle-record`.
4. Human commits.

The CLI invocation looks like:

```bash
scripts/chronicle.sh propose \
  --title "Refuse SMB segment for FY26" \
  --status validated \
  --confidence 0.85 \
  --source-role product-manager \
  --scope strategy,positioning \
  --affected-areas "ROADMAP.md,evals/" \
  --decision "Refuse SMB segment; double down on mid-market through FY26." \
  --alternatives "Pursue SMB,Pursue both segments" \
  --rejected-reason "SMB CAC >12mo payback.,Resource split would dilute both bets." \
  --validation "Mid-market pipeline share >70% by Q3." \
  --review-after 2026-12-01 \
  --diagnosis "Mid-market deals close 4.2x faster; SMB churn 41% at 18mo." \
  --coherent-actions "Reorient AEs; sunset SMB onboarding by Q2."
```

The agent then announces the proposal id and stops. The human reviews `chronicle/proposals/<uuid>.md` and either edits + commits or discards.

### When to record vs. when not to

**Record** when:
- A decision rejects alternatives that future sessions are likely to re-propose.
- A strategy posture is set (segment focus, pricing tier, geography).
- A success-metrics policy is chosen.
- A migration pattern is selected over rejected alternatives.
- A multi-role recommendation converges.

**Don't record**:
- Routine fixes, renames, formatting.
- One-shot operational steps.
- Things adequately covered by ADRs, PRDs, commit messages, or the existing `decision-record` Markdown layer.
- "We discussed this" without an actual decision.

A Chronicle with >200 entries on a single project signals overuse. Curate.

### Distinct from neighbouring artifacts

| Artifact | Layer | Strict schema? | Format |
|---|---|---|---|
| ADR (engineering) | repo-local | no | Markdown |
| PRD | repo-local | no | Markdown |
| `decision-record` (legacy) | `memory/decisions/` | partial (frontmatter only) | Markdown |
| **`chronicle-record`** (this skill) | `chronicle/entries/` | **yes — validator + harness** | Markdown with strict frontmatter |

Use ADR for "Postgres over DynamoDB." Use PRD for "we are building search filters." Use `chronicle-record` for "we refused the SMB segment" or "we accepted shadow-column over pg_repack after cross-role review."

## Examples

### A strategy posture entry

See [`tests/chronicle/fixtures/good/2026-05-15-refuse-smb-segment-for-fy26.md`](../../tests/chronicle/fixtures/good/2026-05-15-refuse-smb-segment-for-fy26.md) — the canonical example.

### A migration decision entry

See [`tests/chronicle/fixtures/good/2026-04-22-shadow-column-migration.md`](../../tests/chronicle/fixtures/good/2026-04-22-shadow-column-migration.md) — a cross-role decision capturing diagnosis, the rejected alternatives (pg_repack, online ALTER, dual-write), validation signals, and the rollback path.

### A superseding entry (sketch)

If we later decide to flip the FY26 posture mid-year:

```bash
scripts/chronicle.sh propose \
  --title "Re-open SMB segment after enterprise tier wins" \
  --status validated \
  --confidence 0.70 \
  --source-role product-manager \
  --scope strategy,positioning \
  --affected-areas "ROADMAP.md" \
  --decision "Re-open SMB segment Q4 FY26 after enterprise tier proves CAC payback model." \
  --supersedes 2026-05-15-refuse-smb-segment-for-fy26 \
  --diagnosis "..." --coherent-actions "..." --validation "..."
```

On commit, the predecessor entry's `status` flips to `superseded` and its `superseded_by` field is set. The SUMMARY index regenerates. Anyone running `chronicle-recall --scope strategy` will see the new posture first.

## Common Pitfalls

1. **Bypassing the human gate.** The agent must never call `commit` itself. Proposing without committing is correct; committing without human review defeats the entire design.
2. **Anchoring confidence at 0.85.** The confidence field is informative only if it varies. A decision made on thin evidence should ship at 0.50 and trigger a sooner `review_after`.
3. **Writing the decision as advocacy.** A Chronicle entry is a fair record, not a sales pitch. The alternatives section is where the entry earns its teaching value — if a future reader can't see why the rejected options were tempting, the record is broken.
4. **Recording discussions instead of decisions.** No decision, no record. The Chronicle's signal-to-noise determines whether future sessions actually use it.
5. **Forgetting `review_after`.** A decision without a revisit date calcifies. Set one even if approximate.
6. **Hand-editing committed entries.** The only allowed mutation is `supersedes`. Hand-editing breaks the harness and the audit trail.
7. **Skipping the validator.** `scripts/chronicle.sh validate` runs in pre-commit and smoke-check. If it complains, fix the entry — don't bypass the hook.
8. **Treating Chronicle as a replacement for ADRs or PRDs.** It's not. Chronicle records the *decision and its alternatives*; ADRs and PRDs do longer-form work. Chronicle entries cite them.

## References

- [`chronicle/README.md`](../../chronicle/README.md) — the layer overview, lifecycle, determinism guarantees.
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — the locked frontmatter contract.
- [`skills/chronicle-recall`](../chronicle-recall/SKILL.md) — the read side; how reviewer agents load Chronicle context before fresh analysis.
- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — the single CLI entry point.
- [`scripts/test-chronicle.sh`](../../scripts/test-chronicle.sh) — the deterministic harness; positive + negative + byte-equality query classes.
- [`skills/decision-record`](../decision-record/SKILL.md) — the legacy Markdown-only sibling. Both layers can coexist; new work should land in Chronicle.
- [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — the design influence; Quorum uses JSON entries + vector retrieval + LLM-powered scoring (Jury/Council). Hornero's variant is Markdown + grep + deterministic harness — same lifecycle, simpler substrate.
- Richard Rumelt, *Good Strategy / Bad Strategy* (2011) — the Diagnosis / Decision / Coherent actions kernel the entry body uses.
- Michael Nygard, "Documenting Architecture Decisions" (2011) — the ADR pattern this record generalises beyond architecture.
