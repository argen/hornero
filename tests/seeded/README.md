# Seeded-flaw fixtures

Three small artifacts (one PRD, one design spec, one engineering plan) where a
specific weakness has been planted. They're the regression net for the role
reviewer personas: if a future edit to `agents/<role>-reviewer.md` makes the
agent rubber-stamp instead of push back, `scripts/play-against.sh --check`
catches it.

The fixtures are **also useful as the day-to-day "give me a critique of this
draft" prompt**. Both modes share one entry point:

```sh
# Day-to-day usage — antagonistic critique of your own draft
./scripts/play-against.sh product-manager  docs/my-prd.md
./scripts/play-against.sh designer         designs/saved-searches.md
./scripts/play-against.sh software-engineer  plans/sessions-migration.md

# Regression — run all three seeded fixtures and assert each role caught its flaw
./scripts/play-against.sh --check
```

## The harness, in one paragraph

`play-against.sh --check` drives interactive `claude` via `expect` —
specifically `scripts/lib/play-against.expect`. It does *not* use `claude -p`;
the harness exercises the same path real users hit. Per fixture it sends one
prompt asking the named `*-reviewer` subagent to critique the file
antagonistically and to terminate the response with the sentinel
`###DONE_REVIEW###`. The transcript is captured, ANSI-stripped, and grepped
for one of a small set of substrings — the **signature** of the planted
flaw. If any fixture's signature doesn't appear, the role agent let the flaw
slip and `--check` fails.

## What's seeded where

| Fixture | Role under test | Planted flaw | Signature (any one) |
|---|---|---|---|
| [`weak-prd.md`](weak-prd.md) | `product-manager-reviewer` | Success criteria are activity metrics ("more users complete the tour"); no outcome metric; no counter-metric guarding against gaming. | `counter-metric` · `gaming` · `Goodhart` · `activity metric` · `outcome` |
| [`weak-design.md`](weak-design.md) | `designer-reviewer` | Flow describes only the happy path. Empty state, error state, and loading state are all absent. | `empty state` · `error state` · `loading` · `state inventory` · `edge case` |
| [`weak-plan.md`](weak-plan.md) | `software-engineer-reviewer` | Adds a `NOT NULL` column to a large table in place; no rollback path, no concurrency note, no backfill plan. | `rollback` · `reversible` · `concurrent` · `backfill` · `in place` |

The signatures are deliberately a **small set of substrings per flaw**, not
exact strings. Model output is non-deterministic; a role that *catches* the
flaw will use at least one of these terms, a role that *misses* it won't.

## Token budget

| | Tokens (approx.) |
|---|---|
| One `--check` case | ~5k input + ~1.5k output ≈ 6k |
| Full `--check` run | ~18k |

A full run takes about a minute of wall-clock per case (subagent dispatch +
the reviewer's turn). Not cheap enough to run on every commit; cheap enough
to run before a release, or whenever the role definitions change.

## Adding a fixture

Each fixture lives in this directory and is referenced from
`scripts/play-against.sh`'s `check_mode()` function. To add one:

1. Write the artifact. Keep it short (~30 lines) and self-contained. The
   planted flaw should be one specific weakness; resist the urge to make it
   broken in five ways.
2. Pick **3-5 substring signatures** that any competent role-reviewer would
   use when calling out the flaw. Err on the side of common terms. Don't
   pick a phrase only your specific draft uses.
3. Add a `run_check_one <role> <fixture> <sig1> <sig2> …` block to
   `check_mode()` in `scripts/play-against.sh`.
4. Document the planted flaw and signature in the table above.

## Prerequisites

- `claude` CLI on `PATH`. The fixtures expect interactive Claude Code's
  TUI (cursor character `❯`, prompt rendering, etc).
- `expect` (`brew install expect` on macOS — pre-installed; `apt install
  expect` on Linux).
- `perl` (used to strip ANSI codes from the transcript before grep).

If the Claude Code TUI changes its prompt rendering, the regex in
`scripts/lib/play-against.expect` may need an update — that's a known fragile
boundary and is documented as a risk in the implementation plan.

## What's deliberately not built

- **No CI integration.** `--check` is local-only by design — keeps API
  credits and auth secrets out of GitHub.
- **No `--record` golden-JSON snapshots.** Signature-grep is enough; the
  maintenance tax of a snapshot diff wasn't worth it.
- **No antagonism severity grading.** A role either mentions the planted
  flaw or it doesn't. Grading is a future PR if v1 reveals roles rubber-
  stamping past the signatures.
- **Only 3 of 7 roles** (`product-manager`, `designer`, `software-engineer`).
  Tester, security-expert, marketing-expert, and data-scientist will follow
  once the assertion shape proves out.
