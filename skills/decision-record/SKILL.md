---
name: decision-record
description: Use after a non-trivial decision is made — captures the diagnosis, the decision, the alternatives rejected and why, the validation plan, and the revisit-by date as a durable artifact in `memory/decisions/`.
intent: |
  The write side of the Hornero memory layer. Converts ephemeral
  decisions (made in an orchestrated review, a strategy session, a
  PRD critique, a launch debate) into structured records committed
  to the project's `memory/decisions/` directory. Future sessions
  query these via `memory-query` before proposing approaches that
  may have already been considered and rejected.
type: component
theme: memory
resources:
  - github
best_for:
  - After a orchestrated review synthesises a recommendation
  - After a strategy-kernel or bet-portfolio session lands
  - After a contested PRD, RFC, or ADR is resolved
  - Whenever an alternative is *rejected* with reasoning worth preserving
scenarios:
  - "Multi-role-review on a payments-feature PR converges on shadow-column migration — capture the diagnosis (50M-row table, exclusive-lock risk), the decision (shadow column), the rejected alternatives (naive ALTER, pg_repack) and *why*"
  - "Strategy-kernel session produces a posture (refuse SMB segment, double down on mid-market) — record it so next quarter's bet-portfolio doesn't re-litigate"
  - "PRD review rejects a feature on viability grounds — record it so the next PRD from the same team starts upstream of the rejection"
estimated_time: 5-10 minutes
---

# Decision record

## Purpose

Capture a decision as a durable artifact so future work doesn't re-litigate it from scratch. Most teams' "memory" lives in Slack threads, retro notes, and senior engineers' heads — none of which an AI assistant can query, and none of which survive turnover. A decision record is a Rumelt-shaped Markdown file (diagnosis + decision + coherent actions), committed to the repo at `memory/decisions/`, that any future session — human or AI — can scan before proposing approaches.

The skill exists because the most expensive failure mode in AI-assisted work is **re-proposing approaches the team has already considered and rejected**. The fix is not better prompting; it is project-local memory the assistant queries before proposing.

## Key Concepts

### The Rumelt shape

A decision record borrows Rumelt's strategy kernel ([`skills/strategy-kernel`](../../skills/strategy-kernel/SKILL.md)) compressed into a record:

1. **Diagnosis** — one paragraph naming the central challenge the decision is responding to. The crux, not a list of considerations.
2. **Decision** — one sentence stating what was chosen.
3. **Coherent actions** — bulleted resource-allocation steps that operationalise the decision.
4. **Alternatives rejected (with reasons)** — every option seriously considered, why it was set aside. This is the load-bearing section; without it, the record reads as a fait accompli and loses its teaching value.
5. **Validation plan** — observable signals that will confirm or refute the decision.
6. **Revisit-by date** — the explicit horizon at which the decision should be re-examined regardless of outcome.

### Distinct from ADR and PRD

This skill overlaps with two existing artifacts and is deliberately distinct from both:

| Artifact | Owner | Scope |
|---|---|---|
| `adr` (a future `software-engineer` role skill) | software-engineer role | Architectural decisions — system topology, framework choice, data-model trade-offs |
| [`skills-prd`](../../skills/prd/SKILL.md) | product-manager role | Feature specification — problem, hypothesis, success criteria, scope |
| **`decision-record`** (this skill) | **cross-role** | **Any decision an orchestrated review produces, especially cross-functional ones — pricing, packaging, strategy posture, launch sequencing, bet portfolio, role-mix calls** |

Use ADR for "we chose Postgres over DynamoDB." Use PRD for "we are building search filters." Use `decision-record` for "we are refusing the SMB segment this year" or "we accepted the shadow-column migration over pg_repack after security and DB review."

### File layout

```
memory/
  decisions/
    2026-05-14-shadow-column-migration.md
    2026-05-12-refuse-smb-segment.md
    2026-04-30-jwt-rs256-over-hs256.md
  SUMMARY.md         # optional — recent activity index, hand-maintained or generated
```

Filenames are `YYYY-MM-DD-kebab-slug.md`. Date is the decision date, not the file-creation date. The slug should read as the decision itself in three to six words.

### Frontmatter shape

```yaml
---
id: 2026-05-14-shadow-column-migration
title: Shadow-column pattern for NOT NULL migration on users table
date: 2026-05-14
status: committed             # committed | superseded | reversed
roles: [software-engineer, security-expert, data-scientist]
scope: [database, migrations]
affected_areas:
  - db/migrations/
  - src/models/user.ts
revisit_after: 2026-08-14
supersedes: []                # IDs of prior decisions this replaces
references:
  - PR-432
  - ADR-017
---
```

`roles` names which Hornero roles weighed in (used by the reviewer agents to know whose prior judgement is encoded). `scope` and `affected_areas` are the grep handles future sessions use to find this record.

## Application

Run this skill **after** a decision has actually been made — not as a brainstorm scaffold, not as a decision-making tool. The decision itself happens in an orchestrated review, a strategy session, a PRD review, or a real-time call. This skill captures what was decided.

1. **Restate the diagnosis.** Ask: *what was the central challenge this decision is responding to?* If the answer is a list of three things, you have not yet diagnosed; you have summarised. Compress to the crux. (Rumelt: a diagnosis names what is *hard* about the situation.)
2. **State the decision in one sentence.** No qualifiers. No "we'll explore X." A decision is the moment ambiguity collapses.
3. **List rejected alternatives with reasons.** This is the part that pays compound interest. Every alternative seriously considered, in one or two lines, with the disqualifying reason. If you cannot list at least two alternatives, the decision was probably a foregone conclusion — note that explicitly.
4. **List coherent actions.** What concrete steps follow from the decision? These are not aspirations; they are commitments.
5. **Define the validation plan.** What signal would tell us this decision was right or wrong? When will we look at that signal?
6. **Set a revisit-by date.** Default: three months for tactical decisions, six to twelve months for strategic. The date matters more than the cadence — calendar pressure beats good intentions.
7. **Write the file.** Use the frontmatter shape above. Commit to git.

## Examples

### A shadow-column migration record

`memory/decisions/2026-05-14-shadow-column-migration.md`:

```markdown
---
id: 2026-05-14-shadow-column-migration
title: Shadow-column pattern for NOT NULL migration on users table
date: 2026-05-14
status: committed
roles: [software-engineer, security-expert, data-scientist]
scope: [database, migrations]
affected_areas: [db/migrations/, src/models/user.ts]
revisit_after: 2026-08-14
references: [PR-432]
---

## Diagnosis

The `users` table has 50M rows and serves the auth hot path. Adding a NOT NULL column via naive `ALTER TABLE` takes an exclusive lock for several minutes — measured at 4m17s in staging. The lock blocks every login for the duration. The crux is **how to add the column without taking auth offline**, not "how to add the column quickly."

## Decision

Use the shadow-column pattern: add nullable column → backfill in batches → add NOT NULL constraint once 100% backfilled → swap reads.

## Coherent actions

- Migration 0042: add nullable `signup_source` column.
- Job: batch backfill 10k rows/min off-peak, with progress in `migrations_progress` table.
- Migration 0043: add NOT NULL constraint and default; guarded by a check on `migrations_progress`.
- Read swap: feature flag `read_signup_source_v2` flipped after constraint applied.
- Rollback: feature flag flip back; column stays nullable; no schema reversal needed.

## Alternatives rejected

- **Naive `ALTER TABLE ... ADD COLUMN ... NOT NULL DEFAULT ...`** — exclusive lock for 4m+ on a hot table; auth downtime unacceptable.
- **`pg_repack`** — viable but adds tooling dependency, requires extension install on the managed DB, and provides no rollback path mid-migration.
- **Postpone the column** — feature dependent on this data; postponement was a 3-month slip, judged worse than the engineering complexity.

## Validation plan

- p99 auth latency unchanged during backfill window (signal: Grafana board `api/auth-latency`).
- Zero failed logins attributable to the migration (signal: Sentry release-tagged errors).
- Re-examine on **2026-08-14** regardless: was the rollback path ever exercised? If not, document the pattern as house style.

## References

- PR-432 (the migration)
- Hornero orchestrated review on 2026-05-13 (engineering + security + data lenses)
```

### A strategy posture record

`memory/decisions/2026-05-12-refuse-smb-segment.md`:

```markdown
---
id: 2026-05-12-refuse-smb-segment
title: Refuse the SMB segment for 2026 — focus mid-market exclusively
date: 2026-05-12
status: committed
roles: [product-manager, marketing-expert]
scope: [strategy, segmentation]
affected_areas: [roadmap, gtm/, sales-enablement/]
revisit_after: 2026-11-12
references: [strategy-kernel-Q2-2026]
---

## Diagnosis

Our pipeline-to-close ratio for SMB is 4.2x worse than mid-market (12% vs 51%). SMB CAC payback is 19 months vs 7 for mid-market. The instinct to "serve both" is splitting product roadmap, GTM messaging, and support load across two ICPs whose jobs-to-be-done diverge on three of five dimensions. The crux is **focus**, not capacity.

## Decision

Refuse the SMB segment for 2026. All product, marketing, and sales investment goes to mid-market.

## Coherent actions

- Roadmap: drop the SMB-specific onboarding redesign (was Q3). Reinvest in mid-market admin tooling.
- GTM: rewrite homepage above-the-fold for mid-market (>50 employees). Retire SMB landing page.
- Sales: SMB inbound routed to partner channel with referral commission.
- Pricing: leave SMB tier in place but stop investing in conversion optimisation for it.

## Alternatives rejected

- **Serve both segments** — current state; the diagnosis itself is the rejection.
- **Drop SMB entirely (deprecate the tier)** — would lose ~$2M ARR with no upside; the refusal is to *invest*, not to *cut*.
- **Build an SMB-only sub-brand** — explored; org doesn't have the headcount to run two GTMs.

## Validation plan

- Mid-market pipeline volume in Q3 vs Q1 baseline (signal: Salesforce report `MM-pipeline-quarterly`).
- Sales-rep cycle time on mid-market deals (signal: deal velocity dashboard).
- Re-examine on **2026-11-12** regardless: did refusing SMB actually free the capacity we predicted, or did mid-market just absorb the same volume in different shape?

## References

- `strategy-kernel-Q2-2026` (the broader kernel this decision implements)
- Multi-role-review on 2026-05-10 (product-manager + marketing-expert + data-scientist)
```

## Common Pitfalls

1. **Writing the record as advocacy.** A decision record is not a sales pitch for the decision; it is a *fair representation* of the alternatives. If a future reader can't see why the rejected options were tempting, the record fails its teaching purpose.
2. **Omitting the diagnosis.** The most common failure is a record that jumps to "we decided X" without naming the crux. Without diagnosis, the decision floats — and future readers can't tell whether their situation matches.
3. **Vague alternatives.** "Other approaches were considered" is not an alternative. Each rejected option needs a one-line description and a one-line reason.
4. **No revisit-by date.** Decisions without revisit dates calcify into dogma. The date is the discipline.
5. **Capturing every meeting.** Records are for decisions, not discussions. If nothing was decided, no record. The signal-to-noise of the corpus determines whether future readers actually use it.
6. **Mistaking ADRs for decision-records.** ADRs are architectural and engineer-owned. If a decision is genuinely cross-functional (PM + marketing + eng + security), use a decision-record so all roles' reviewer agents pick it up. Keep ADRs for engineer-internal calls.
7. **No status updates.** When a decision is superseded, mark it. A corpus of "committed" records that no longer hold is worse than no corpus.

## References

- [`skills/memory-query`](../memory-query/SKILL.md) — the read side; how reviewer agents and future sessions scan `memory/decisions/` before proposing.
- [`skills/strategy-kernel`](../../skills/strategy-kernel/SKILL.md) — the longer-form Rumelt artifact this record is a compressed instance of.
- a future `software-engineer` role's `adr` skill — engineer-scoped sibling artifact; use ADR for architectural decisions, decision-record for cross-role ones.
- [`playbooks/memory-loop.md`](../../playbooks/memory-loop.md) — the read-decide-write cycle, worked end-to-end.
- Richard Rumelt, *Good Strategy / Bad Strategy* (2011) — diagnosis / guiding policy / coherent actions, the kernel this record borrows. The "alternatives rejected" section is Rumelt's discipline ported into ADR-style format.
- Michael Nygard, "Documenting Architecture Decisions" (2011) — the ADR pattern this record generalises beyond architecture.
