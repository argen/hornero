---
name: chronicle-recall
description: Use before reviewing, proposing, or producing any non-trivial artifact — queries the project's `chronicle/entries/` layer for prior decisions whose scope, role, status, or keywords overlap with the current work, and surfaces relevant entries before fresh analysis begins.
intent: |
  The read side of the Hornero Chronicle layer. Closes the most expensive
  failure mode in AI-assisted work — re-proposing approaches the team has
  already considered, validated, or refuted. Reviewer subagents call this
  skill at the top of every review; producer skills call it before
  drafting a new artifact.
type: workflow
theme: memory
best_for:
  - Top of every reviewer-subagent invocation (the "Chronicle preamble")
  - Before drafting a PRD, strategy kernel, positioning statement, or bet portfolio
  - Before running a multi-role review on a contested topic (when re-expanded)
  - When a user asks "have we already decided X?" or "what do we know about Y?"
  - Cold-start of a fresh session — `chronicle/SUMMARY.md` is the first thing to read
scenarios:
  - "PM drafting a Q3 PRD on SMB onboarding — chronicle-recall scopes by `strategy` and surfaces the 2026-05-15 entry refusing SMB segment. PRD scope shifts before any drafting begins."
  - "Reviewer subagent invoked on a PR that proposes pg_repack — chronicle-recall scopes by `migrations` and surfaces the 2026-04-22 entry that explicitly rejected pg_repack with reasons. Review leads with that context."
  - "Cold-start of a fresh Hornero session in a new project — agent reads `chronicle/SUMMARY.md` first for situational awareness, no query needed yet."
estimated_time: 1-3 minutes
---

# Chronicle recall

## Purpose

Scan the project's Chronicle layer before doing fresh work. If a relevant decision exists, the work should start *upstream of that decision*, not re-derive it. This skill is the read side of the Chronicle loop; [`chronicle-record`](../chronicle-record/SKILL.md) is the write side.

The skill is short by design. It is the **discipline of looking first**, executed via two cheap, deterministic operations: read `chronicle/SUMMARY.md` (cold-start digest), and run `scripts/chronicle.sh query ...` (filtered scan). No vector search, no LLM in the read path — same guarantee as `memory-query`, but against a strict-schema corpus that supports structured filters.

## Key Concepts

### Two access paths

**Cold-start (SUMMARY.md)** — every fresh session starts here. `chronicle/SUMMARY.md` is auto-regenerated on every commit and is short by design (≤ ~50 entries before curation pressure). Reading it gives the agent situational awareness — what postures bind, what's been refuted, what's superseded — without a query call.

**Filtered query (`chronicle.sh query`)** — when the current work has a specific scope, role, or topic, query directly:

```bash
scripts/chronicle.sh query --scope strategy --status validated
scripts/chronicle.sh query --role product-manager --keyword "SMB"
scripts/chronicle.sh query --topic migrations
scripts/chronicle.sh query --sourcing intuition           # entries resting on hunches
scripts/chronicle.sh query --status validated --sourcing verbal  # load-bearing but thinly sourced
scripts/chronicle.sh query --type hypothesis --status open  # what assumptions are currently under test?
scripts/chronicle.sh query --type stakeholder --scope billing  # who cares about billing?
```

Output is byte-stable: same corpus + same query = same bytes. Filters AND together. `--limit N` caps the result count.

### Status semantics

Every entry has a `status ∈ {validated, open, superseded, refuted}`. When loading entries:

- **validated** — the decision is currently load-bearing. Treat as constraint on new work.
- **open** — decision recorded but not yet validated. Use with caution; flag in critique.
- **superseded** — overridden by a newer entry (linked via `superseded_by`). Follow the link; the newer entry is the binding one.
- **refuted** — actively disproven. Past failures harden future review — surface refuted entries when the proposed approach matches one.

A query with no `--status` filter returns all four. Most reviewer preambles default to `--status validated` for the binding set, then a follow-up scan for `refuted` to catch traps.

### Three entry types

The `type` field distinguishes three shapes:

- **`decision`** — committed postures (Rumelt's kernel).
- **`hypothesis`** — open assumptions under test (Assumption → Prediction → Falsifier → Evidence Log → Resolution).
- **`stakeholder`** — per-person profiles (Role & influence → Open asks → Concerns → Last contact → Decision affinity).

Reviewer preambles benefit from a few scoped queries:

- `--type decision --status validated` for the binding postures on the work's scope.
- `--type hypothesis --status open` for the open assumptions in flight. A new PRD that contradicts a binding decision is a violation; a new PRD that aligns with an open hypothesis is the natural place to add evidence (or to propose the resolution).
- `--type stakeholder --scope <area>` to find the people who care about the area you are touching — pair with the upcoming `/prep` skill before any meeting.

A decision converted from a hypothesis appears as a new entry that `supersedes` the hypothesis, not as an edit-in-place. Follow the supersedes chain to read both. A stakeholder profile that materially changes (new role, big influence shift) is updated the same way.

### Sourcing as a trust signal

Every entry carries `sourcing ∈ {documented, verbal, intuition, industry}` — the weakest source the decision rests on. When a query surfaces a `validated` entry with `sourcing: intuition` or `sourcing: industry`, treat it as load-bearing but thinly sourced: the team committed, but new evidence could legitimately move the posture. Lead the review by naming the source layer ("the policy is recorded with sourcing: intuition; if your PRD has documented evidence either way, that should reset the entry").

Two query patterns worth knowing:

- `--sourcing intuition` or `--sourcing industry` to surface the entries most likely to be wrong.
- `--status validated --sourcing verbal` to find committed-but-undocumented postures — natural follow-up work for the next `/ingest` cycle.

The legacy `decision-record` / `memory-query` layer has no sourcing column; this is one of the reasons new work belongs in Chronicle.

### Determinism guarantee

`scripts/chronicle.sh query` output is **byte-stable** for a given corpus. Test-harness `scripts/test-chronicle.sh` asserts this byte-equality against frozen expected outputs. This means:

- The agent's pre-review Chronicle scan is reproducible across sessions.
- A diff between two harness runs surfaces corpus changes, not retrieval flakiness.
- There is no "the model decided not to surface that entry today" failure mode.

If your retrieval system can't promise this, your situational awareness is theatre.

### What if there's no Chronicle?

If `chronicle/entries/` does not exist (or is empty), this skill **no-ops with a short note**. The absence itself is signal: an early-stage project, the cost-benefit of forcing decisions through the recording loop hasn't yet flipped. Don't error.

The legacy `memory-query` skill on `memory/decisions/` is still useful in that state. Both layers can coexist.

## Application

### The recall preamble

Every reviewer subagent should open with a Chronicle scan, in this order:

1. Read `chronicle/SUMMARY.md` if it exists (cheap).
2. Run a scoped query on the work's domain — `--scope`, `--role`, or `--keyword`.
3. If anything binding surfaces (`status: validated` or `status: refuted` matching the proposed approach), **lead the review with that context** instead of fresh analysis.
4. If nothing surfaces, proceed to fresh analysis but say so explicitly: "No relevant prior decisions in Chronicle; proceeding from first principles."

The preamble is part of the review, not a separate step. Skipping it is the failure mode this skill is designed to close.

### Producer-skill usage

A producer skill (PRD, strategy kernel, positioning statement, bet portfolio) calls this skill **before drafting**, not after. The output of the recall feeds into the producer's framing:

- A PRD's "problem framing" section cites relevant Chronicle entries.
- A strategy kernel's "guiding policy" reuses prior posture entries as constraints.
- A bet portfolio's prioritisation cross-references prior rejected bets.

### Cross-functional reads

When Chronicle is re-expanded to cover multiple roles, recall is the cross-functional integration point: a `product-manager` reviewer can surface decisions originally recorded by `software-engineer` or `data-scientist`. Source role is a filter, not a fence — query without `--role` to see all relevant context.

## Examples

### Reviewer preamble (PM critique on a PRD draft)

```bash
$ scripts/chronicle.sh query --scope strategy --status validated --limit 10
# Chronicle query

Filters: topic=* scope=strategy role=* status=validated sourcing=* type=* keyword=* limit=10

| date | id | type | status | role | sourcing | scope | title |
|---|---|---|---|---|---|---|---|
| 2026-05-15 | 2026-05-15-refuse-smb-segment-for-fy26 | decision | validated | product-manager | documented | strategy,positioning | Refuse SMB segment for FY26 |

1 match(es).
```

The reviewer reads the surfaced entry. The PRD draft proposes an SMB-focused onboarding flow. Review leads: "The Chronicle records a FY26 posture refusing SMB (entry `2026-05-15-...`). This PRD's scope conflicts with that posture. Either the posture is being superseded — in which case the PRD should propose a `chronicle-record` superseding the old entry — or the PRD scope needs to shift upstream of the SMB refusal."

### Cold-start situational awareness (no specific query)

A fresh session opens. The agent reads `chronicle/SUMMARY.md`:

```markdown
| date | id | type | status | role | sourcing | scope | title |
|---|---|---|---|---|---|---|---|
| 2026-05-15 | [`2026-05-15-refuse-smb-segment-for-fy26`](entries/2026-05-15-refuse-smb-segment-for-fy26.md) | decision | validated | product-manager | documented | strategy,positioning | Refuse SMB segment for FY26 |
| 2026-04-22 | [`2026-04-22-shadow-column-migration`](entries/2026-04-22-shadow-column-migration.md) | decision | validated | cross-role | documented | migrations,database | Use shadow-column migration for user_id widening |
```

The agent has situational awareness before the user's first specific request. When the request lands ("review this PRD for an SMB-focused feature"), it can recall the segment posture immediately without re-querying.

### Empty-corpus skip

```bash
$ scripts/chronicle.sh query
# Chronicle query

Filters: topic=* scope=* role=* status=* sourcing=* type=* keyword=* limit=50

No matches.
```

Agent: "No Chronicle entries yet — proceeding from first principles. After this review, I'll propose a Chronicle entry capturing the decision."

## Common Pitfalls

1. **Skipping the preamble.** The single biggest failure mode. A reviewer that doesn't scan Chronicle re-derives decisions in isolation; the corpus pays the recording cost but yields no leverage. Run the preamble *always*, even when you "know" there's nothing relevant.
2. **Over-querying with `--keyword`.** Keyword search is grep over the entire file body, so common words match almost everything. Prefer `--scope`, `--role`, or `--topic` first; use `--keyword` only when scoped filters didn't narrow enough.
3. **Ignoring `status: refuted` entries.** Refuted entries are *signal*, not noise — they document a past approach that was actively wrong. A new proposal matching a refuted entry should explain why this time is different, not pretend the entry doesn't exist.
4. **Following a `supersedes` chain partially.** When you find an entry with `superseded_by`, read the successor too. Stopping at the older entry leads to acting on superseded postures.
5. **Reading Chronicle as authoritative on facts.** Chronicle records *decisions*, not facts. "We decided X" is not "X is still true." `review_after` dates exist for a reason — re-examine on or past that date.
6. **Treating `confidence: 0.85` as conviction.** The author's confidence is one signal; the entry's age, status, and evidence chain matter more.
7. **Forgetting Chronicle is project-local.** Each project carries its own `chronicle/`. Decisions in one project don't migrate; that's intentional. Don't cite decisions from a sibling repo unless they live in this one's Chronicle.

## References

- [`chronicle/README.md`](../../chronicle/README.md) — layer overview, lifecycle, determinism guarantees.
- [`chronicle/SUMMARY.md`](../../chronicle/SUMMARY.md) — the cold-start digest (auto-regenerated; read first on every fresh session).
- [`chronicle/SCHEMA.md`](../../chronicle/SCHEMA.md) — the frontmatter contract the query relies on.
- [`skills/chronicle-record`](../chronicle-record/SKILL.md) — the write side; how new decisions enter the Chronicle.
- [`scripts/chronicle.sh`](../../scripts/chronicle.sh) — the CLI; `query`, `summary`, `validate` subcommands are the read-side surface.
- [`scripts/test-chronicle.sh`](../../scripts/test-chronicle.sh) — the deterministic harness; byte-equality assertions guarantee retrieval reproducibility.
- [`skills/memory-query`](../memory-query/SKILL.md) — the legacy `memory/decisions/` sibling. Both layers can coexist; new work should query Chronicle.
- [`playbooks/memory-loop.md`](../../playbooks/memory-loop.md) — the read-decide-write cycle, worked end-to-end.
- [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules) — the design influence. Quorum uses a vector + BM25 + RRF retrieval pipeline; Hornero's variant uses deterministic filters and grep on a small corpus — same lifecycle, byte-stable retrieval, no embedder dependency.
