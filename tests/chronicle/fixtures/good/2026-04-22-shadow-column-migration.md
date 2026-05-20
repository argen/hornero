---
id: 2026-04-22-shadow-column-migration
title: Use shadow-column migration for user_id widening
date: 2026-04-22
status: validated
confidence: 0.78
source_role: cross-role
provenance: documented
scope: [migrations, database]
affected_areas: [db/migrations/, src/models/user.ts]
decision: Adopt shadow-column migration; reject pg_repack and online ALTER.
alternatives_considered: [pg_repack, online ALTER TABLE, dual-write window]
rejected_reason: [pg_repack risks exclusive lock on rewrite, online ALTER bloats WAL on 50M-row table, dual-write doubles app complexity for 2-week window]
review_after: 2026-10-22
---

## Diagnosis

`users.id` is `INT4` and projected to overflow within 14 months. Migration must run online on a 50M-row table with no read-side downtime.

## Decision

Adopt shadow-column migration; reject pg_repack and online ALTER.

## Coherent actions

- Add `id_v2 BIGINT` as nullable column; backfill in batches of 10K rows under a budget of 30 min/day.
- Dual-write `id_v2 = id` at the app layer behind a feature flag.
- Cut over read path once `id_v2` is 100% populated; rename and drop the original.

## Alternatives rejected

- **pg_repack** — risks exclusive lock on the rewrite phase; mocked migration in staging blew past SLA.
- **online ALTER TABLE** — would generate 40+ GB of WAL on the production replica; replication lag would breach the 10s alerting threshold.
- **dual-write window** — would require touching 14 callsites; benefit doesn't justify the surface area.

## Validation plan

- Replica lag stays under 5s during backfill batches.
- No SLO breach on the user-facing read path.
- Cutover ships behind a flag with 1% → 100% rollout over 72h.

## Notes

Coordinated with on-call rotation; rollback path is to drop `id_v2` (no schema dependency until cutover).
