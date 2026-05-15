# Chronicle

A project-local, machine-queryable memory of decisions. Future sessions — and roles other than the one that made the decision — load it as situational awareness before proposing approaches that have already been considered, rejected, or validated.

> Inspired by [Quorum's Chronicle module](https://github.com/balpal4495/Quorum/tree/main/modules). Hornero's variant is Markdown-with-YAML-frontmatter (matches house style) with a deterministic harness (matches `validate-skill.sh` / `validate-resource.sh`).

## Why this exists

The most expensive failure mode in AI-assisted work is **re-proposing approaches the team has already considered and rejected**. Slack threads, retro notes, and senior engineers' heads are not queryable. Chronicle is the queryable surface.

Two earlier paths still exist:
- `decision-record` skill — write side, free-form `memory/decisions/` Markdown
- `memory-query` skill — read side, grep over the above

Chronicle adds **schema strictness, a CLI, a query primitive, an auto-summary, and a test harness**. The two layers can coexist on a project; new work should land in Chronicle.

## Layout

```
chronicle/
  README.md         # this file
  SCHEMA.md         # the frontmatter contract — locked, validator-enforced
  SUMMARY.md        # auto-regenerated digest of recent entries (read on session start)
  entries/          # committed records, one .md file per decision
  proposals/        # staged records awaiting human commit (gitignored)
```

## Lifecycle

1. **Propose** — agent (or human) runs `scripts/chronicle.sh propose ...`. A new file lands in `chronicle/proposals/<uuid>.md`. **No LLM in this step** — the script takes CLI args and writes a fixed shape.
2. **Review** — human reads the proposal. Edits in place if needed.
3. **Commit** — human runs `scripts/chronicle.sh commit <uuid>`. The proposal moves to `entries/<date>-<slug>.md`, schema is re-validated, `SUMMARY.md` is regenerated.
4. **Query** — any future session runs `scripts/chronicle.sh query --topic <slug>` (or `--scope`, `--role`, `--status`, `--keyword`). Output is byte-stable for a given corpus.

The human gate is structural, not advisory. `propose` and `commit` are separate commands; nothing in the query path looks at `proposals/`.

## Determinism guarantees

- **Write path is LLM-free.** `propose` builds the file from CLI args. No completion call.
- **Schema validation** is regex + grep, identical pattern to `validate-resource.sh`.
- **Query output is sorted by `(date desc, id asc)`** and emits a fixed Markdown shape; running the same query twice on the same corpus produces byte-identical bytes.
- **The test harness** at `tests/chronicle/` keeps fixtures + expected query outputs and asserts byte equality. Pre-commit + `smoke-check.sh` run the harness.
- **IDs** are content-addressable: `<ISO date>-<slug>` derived from the title. No randomness in committed names.

## How roles consume Chronicle

Two paths:

1. **Session-start load**: `chronicle/SUMMARY.md` is kept short (~50 lines max) and listed in the dispatcher protocol as a context-load target. A new session reads it cold for situational awareness without a query call.
2. **Explicit recall**: reviewer subagents call the `chronicle-recall` skill at the top of every review — same shape as the existing `memory-query` preamble. Producer skills call it before drafting.

A retired role re-introduced later inherits the entire Chronicle automatically — that's the point of the layer.

## Quick start

```bash
# Propose a decision (no LLM, no auto-commit)
scripts/chronicle.sh propose \
  --title "Refuse SMB segment for FY26" \
  --topic "strategy/segment-focus" \
  --status validated \
  --confidence 0.85 \
  --source-role product-manager \
  --scope strategy,positioning \
  --affected-areas "ROADMAP.md,evals/tasks/" \
  --decision "Refuse SMB; double down on mid-market." \
  --alternatives "Pursue SMB; pursue both" \
  --rejected-reason "SMB CAC > 12mo payback; LTV insufficient under current pricing." \
  --validation "Pipeline mid-market share > 70% by Q3; no SMB asks accepted in Q1-Q2." \
  --review-after 2026-12-01

# Review the proposal under chronicle/proposals/, then commit
scripts/chronicle.sh commit <proposal-uuid>

# Query
scripts/chronicle.sh query --topic strategy/segment-focus
scripts/chronicle.sh query --scope strategy --status validated
scripts/chronicle.sh query --keyword "SMB"

# Regenerate SUMMARY.md (also called automatically on commit)
scripts/chronicle.sh summary

# Validate all committed entries
scripts/chronicle.sh validate
```

## When to record vs. when not to

**Record** when:
- A decision rejects alternatives that future sessions are likely to re-propose
- A strategy posture is made (segment focus, pricing tier, geography)
- A success-metrics policy is chosen (e.g. "outcome metrics only; never activity")
- A constraint is accepted (e.g. "no shadow-column migration; pg_repack instead")
- A multi-role review converges on a non-trivial recommendation

**Don't record**:
- Routine bug fixes
- One-shot ops
- Things adequately captured by ADRs, PRDs, or commit messages
- "We discussed this" without an actual decision

A Chronicle with > ~200 entries on a single project signals overuse — curate.

## See also

- [`SCHEMA.md`](SCHEMA.md) — the frontmatter contract
- [`SUMMARY.md`](SUMMARY.md) — auto-generated index (read this first in a fresh session)
- [`skills/chronicle-record/SKILL.md`](../skills/chronicle-record/SKILL.md) — write-side skill (the agent-facing wrapper)
- [`skills/chronicle-recall/SKILL.md`](../skills/chronicle-recall/SKILL.md) — read-side skill (the recall preamble)
- [`scripts/chronicle.sh`](../scripts/chronicle.sh) — single CLI entry point
- [`tests/chronicle/`](../tests/chronicle/) — deterministic harness
