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

### Sourcing is the weakest-link signal

Every entry carries `sourcing ∈ {documented, verbal, intuition, industry}`. The hierarchy is ordered strongest → weakest, and **the value is the weakest source the decision rests on**, not the strongest. A decision supported by one documented finding plus three hallway conversations is `verbal`, not `documented`, because future-you needs to see that the entry is exposed if the verbal claims turn out to be wrong.

The four levels:

- **`documented`** — durable written sources: interview transcripts, dashboards with timestamps, RFCs, signed contracts, support tickets, market reports.
- **`verbal`** — a person said it; not in a durable artifact. Stakeholder commitments, off-the-record conversations.
- **`intuition`** — the author's judgment based on prior experience in this specific context.
- **`industry`** — generic field knowledge with no citation specific to this project ("SaaS Rule of 40 says…").

Why this matters: a `validated` entry with `sourcing: intuition` is a signal — the team committed, but the source layer is thin. The next reviewer should treat it as a candidate for upgrading (find documented evidence) rather than as load-bearing.

**Don't anchor at `documented` by default** — calibrate to the truth. If the decision genuinely rests on a hunch, say so. The discomfort of writing `intuition` is the feature.

### Four entry types: decision, hypothesis, stakeholder, customer

The `type` frontmatter field is required and takes one of:

- **`decision`** (default) — a posture, policy, or commitment. Follows Rumelt's strategy kernel: Diagnosis → Decision → Coherent actions → Alternatives rejected → Validation plan → Notes.
- **`hypothesis`** — an open assumption under test. Body shape: Assumption → Prediction → Falsifier → Evidence Log → Resolution → Notes.
- **`stakeholder`** — one person the team coordinates with. Body shape: Role & influence → Open asks → Concerns → Last contact → Decision affinity → Notes.
- **`customer`** — one B2B account (the company, not an individual). Body shape: Account profile → Usage shape → Health signals → Decision drivers → Stakeholders → Notes.

All four types share frontmatter; the validator branches body-section enforcement on `type`. The distinction is load-bearing because future readers need to tell apart "what we believe and are testing" from "what we have committed to" from "who we are coordinating with" from "which account is at stake." Bundling them confuses the recall loop.

A stakeholder entry's `confidence` reflects how well the author understands that person's position; a low number is a signal the next interaction should be discovery, not pitch. The `affected_areas` field captures which parts of the product or roadmap the stakeholder cares about — useful when a PRD touching `billing/` should auto-surface the people for whom `billing` is in their affected_areas list.

A customer entry is the account-level sibling of stakeholder. The pattern in B2B startups is one customer entry per company (Acme Corp) and zero-or-more stakeholder entries inside it (Hugo at Acme, Devlin at Acme). The customer entry's `## Stakeholders` section references the stakeholder entry IDs; the stakeholder entries name the account in prose. `affected_areas` on a customer entry captures which parts of the product matter to that account's renewal or expansion; `scope` typically includes `customers` plus segment tags (`enterprise`, `mid-market`, `smb`) and any per-account context (`renewal-q3`, `expansion-candidate`).

**When in doubt**, write a hypothesis. A premature decision entry that turns out to be wrong is harder to walk back than a hypothesis that evolves with evidence. The `Resolution` section in a hypothesis is where the eventual decision entry (or refutation) gets linked.

A hypothesis ends in one of three ways:
1. Evidence accumulates → propose a new `decision` entry that `supersedes` the hypothesis. The hypothesis flips to `status: superseded`.
2. The Falsifier triggers → propose a refutation note and flip the hypothesis to `status: refuted`.
3. The Validation plan still hasn't run by `review_after` → revisit; either tighten the prediction or kill the hypothesis.

A stakeholder or customer entry is updated when the person's role / account's profile materially changes — propose a new entry that `supersedes` the previous profile. Lightweight updates (a new open ask, a new support ticket pattern, a contact date, a fresh usage metric) are append-only edits to the relevant body sections; the `stakeholder-update` and `customer-update` skills exist for those flows (deferred follow-up — see roadmap).

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
  --sourcing documented \
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

### A hypothesis entry

See [`tests/chronicle/fixtures/good/2026-05-18-invite-friction-blocks-team-activation.md`](../../tests/chronicle/fixtures/good/2026-05-18-invite-friction-blocks-team-activation.md) — an open hypothesis about activation friction, with a prediction, a falsifier, an evidence log of two observations, and an open resolution. The corresponding CLI:

```bash
scripts/chronicle.sh propose \
  --type hypothesis \
  --title "Invite-link friction blocks team activation under 50 seats" \
  --status open \
  --confidence 0.55 \
  --source-role product-manager \
  --sourcing verbal \
  --scope activation,growth \
  --affected-areas "onboarding/,src/invite/" \
  --decision "Invite-link friction is the primary blocker for teams of <50 seats reaching the activation event." \
  --assumption "Teams under 50 seats hit a single-admin bottleneck during onboarding." \
  --prediction "Bulk-invite UX drops time-to-activation by 30% within 60 days of rollout." \
  --falsifier "Time-to-activation stays within ±10% with at least 25% adoption of bulk invite." \
  --review-after 2026-07-01
```

The `--decision` flag still applies to hypotheses — it holds the one-sentence claim used as the index-friendly copy. The hypothesis-specific flags (`--assumption`, `--prediction`, `--falsifier`, `--evidence-log`, `--resolution`) scaffold the body sections.

### A stakeholder entry

See [`tests/chronicle/fixtures/good/2026-05-19-maya-vp-sales.md`](../../tests/chronicle/fixtures/good/2026-05-19-maya-vp-sales.md) — a VP Sales profile with three open asks, two concerns, decision-affinity notes, and a `--review-after` set 90 days out. The corresponding CLI:

```bash
scripts/chronicle.sh propose \
  --type stakeholder \
  --title "Maya — VP Sales" \
  --status open \
  --confidence 0.70 \
  --source-role product-manager \
  --sourcing verbal \
  --scope stakeholders,enterprise \
  --affected-areas "export,billing,contracts" \
  --decision "VP Sales representing enterprise-tier customers; high influence on export and billing roadmap calls." \
  --role-influence "VP Sales. Owns the enterprise book. Reports to CRO." \
  --open-asks "2026-05-15 — Bulk export of customer activity logs in CSV (QBR)" \
  --concerns "Two recent renewals cited export latency under load." \
  --last-contact "2026-05-15 — QBR sync; reiterated export ask." \
  --decision-affinity "Strong yes on enterprise renewal levers; strong no on SMB features." \
  --review-after 2026-08-19
```

The `--decision` flag holds the one-sentence summary of the stakeholder's role and stake — used as the index-friendly copy. The body-specific flags scaffold the sections.

### A customer entry

See [`tests/chronicle/fixtures/good/2026-05-20-acme-corp.md`](../../tests/chronicle/fixtures/good/2026-05-20-acme-corp.md) — a 200-seat enterprise account with usage shape, health signals, decision drivers, and two stakeholders inside (Hugo and Devlin). The corresponding CLI:

```bash
scripts/chronicle.sh propose \
  --type customer \
  --title "Acme Corp" \
  --status open \
  --confidence 0.72 \
  --source-role product-manager \
  --sourcing documented \
  --scope customers,enterprise,renewal-q3 \
  --affected-areas "export,billing,contracts" \
  --decision "Enterprise customer (200-seat, \$180k ARR); expansion candidate gated on per-seat invoicing; renewal at risk on export performance." \
  --account-profile "Enterprise; 200 seats across 3 BUs; \$180k ARR; renews 2026-09-30." \
  --usage-shape "DAU/MAU 0.62 (declining from 0.71 in Q1); export usage -18% MoM after rate-limit rollout." \
  --health-signals "2 export-latency tickets in May; one SLA breach; NPS shifted +40 → +20 (n=8)." \
  --decision-drivers "Strong yes on export latency improvements and per-seat invoicing; strong no on UX changes that retrain admin workflows." \
  --stakeholders-here "Hugo (Head of Ops): 2026-05-19-hugo-acme-ops. Devlin (CFO): not yet captured — owns the per-seat invoicing ask." \
  --review-after 2026-08-01
```

The `## Stakeholders` section is the cross-reference. Stakeholder entries inside this customer should name the customer in prose; the customer entry references the stakeholder IDs. Don't try to enforce the cross-reference via frontmatter fields — keeping it in prose lets the relationship be richer than "1:N" and keeps the validator simple.

### A superseding entry (sketch)

If we later decide to flip the FY26 posture mid-year:

```bash
scripts/chronicle.sh propose \
  --title "Re-open SMB segment after enterprise tier wins" \
  --status validated \
  --confidence 0.70 \
  --source-role product-manager \
  --sourcing verbal \
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
3. **Anchoring sourcing at `documented`.** Same failure mode as the confidence anchor. The sourcing field is the weakest source the decision rests on, not the strongest. If one of the legs of the argument is hallway conversation, the entry is `verbal` — regardless of how solid the other legs are.
4. **Writing the decision as advocacy.** A Chronicle entry is a fair record, not a sales pitch. The alternatives section is where the entry earns its teaching value — if a future reader can't see why the rejected options were tempting, the record is broken.
5. **Recording discussions instead of decisions.** No decision, no record. The Chronicle's signal-to-noise determines whether future sessions actually use it.
6. **Forgetting `review_after`.** A decision without a revisit date calcifies. Set one even if approximate.
7. **Hand-editing committed entries.** The only allowed mutation is `supersedes`. Hand-editing breaks the harness and the audit trail.
8. **Skipping the validator.** `scripts/chronicle.sh validate` runs in pre-commit and smoke-check. If it complains, fix the entry — don't bypass the hook.
9. **Treating Chronicle as a replacement for ADRs or PRDs.** It's not. Chronicle records the *decision and its alternatives*; ADRs and PRDs do longer-form work. Chronicle entries cite them.

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
