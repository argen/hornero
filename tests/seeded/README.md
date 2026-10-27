# Seeded-flaw fixtures

One small PRD with a specific weakness planted in it, plus a clean-PRD
negative control. They're the regression net for the
`product-manager-reviewer` role: if a future edit to
`agents/product-manager-reviewer.md` makes it rubber-stamp instead of push
back, `scripts/play-against.sh --check` catches it.

The fixture is **also useful as the day-to-day "give me a critique of this
draft" prompt**. Both modes share one entry point:

```sh
# Day-to-day usage — antagonistic critique of your own draft
./scripts/play-against.sh product-manager  docs/my-prd.md
./scripts/play-against.sh designer         designs/saved-searches.md   # any role works
./scripts/play-against.sh software-engineer  plans/sessions-migration.md

# Regression — run the seeded PM fixtures
./scripts/play-against.sh --check
```

Interactive mode supports all seven role personas. **`--check` covers
product-manager only** in v1; if a real regression in another role's persona
ever motivates the token cost, add a fixture per the recipe below.

## The harness, in one paragraph

`play-against.sh --check` drives interactive `claude` via `expect` —
specifically `scripts/lib/play-against.expect`. It does *not* use `claude -p`;
the harness exercises the same path real users hit. Per fixture it sends one
prompt asking the named `*-reviewer` subagent to critique the file
antagonistically and to terminate the response with the sentinel
`###DONE_REVIEW###`. The transcript is captured, ANSI-stripped, and grepped
for one of a small set of substrings — the **signature** of the planted
flaw. If the signature doesn't appear, the role agent let the flaw slip and
`--check` fails.

## What's seeded

| Fixture | Role under test | Planted flaw | Signature (any one) |
|---|---|---|---|
| [`weak-prd.md`](weak-prd.md) | `product-manager-reviewer` | Success criteria are activity metrics ("more users complete the tour"); no outcome metric; no counter-metric guarding against gaming. | `counter-metric` · `gaming` · `Goodhart` · `activity metric` · `outcome` |

The signatures are deliberately a **small set of substrings per flaw**, not
exact strings. Model output is non-deterministic; a role that *catches* the
flaw will use at least one of these terms, a role that *misses* it won't.

## Token budget

| | Tokens (approx.) |
|---|---|
| One `--check` case | ~5k input + ~1.5k output ≈ 6k |
| Full `--check` run (1 positive + 1 negative) | ~13k |

A full run takes about a minute of wall-clock per case. Cheap enough to run
before a release or whenever `agents/product-manager-reviewer.md` changes.

## Validity — what this test does and does not prove

`--check` is a **coarse regression net**, not a rigorous evaluation. Honest
inventory:

| What it catches | What it doesn't |
|---|---|
| PM agent goes silent / rubber-stamps without using any flaw-related vocabulary | False positives — the agent mentions a signature word in passing ("no rollback issues here") |
| Catastrophic drift in the PM persona | Subtle drift that still trips the signature for the wrong reason |
| Missing-fixture regressions (script fails if a fixture file is gone) | Flake rate (single-run observations; variance is unknown) |
| Signature-too-liberal (covered by the negative control — see below) | Signature-too-strict (the agent might catch the flaw in different words; we'd miss it) |

For deeper measurement of orchestrated-review **synthesis** quality (which
this script does *not* test), see [`evals/README.md`](../../evals/README.md)
and the 4-dimension human-judge rubric.

## Negative control

`clean-prd.md` is a deliberately well-built PRD: outcome-shaped success
metric, a guardrail panel against the obvious gaming failure mode, specific
target audience, named scope. The negative-control case runs this fixture
through the **same** PM-reviewer with the **same** "find 3 problems" prompt,
then asserts that *none* of the flaw signatures
(`counter-metric`, `gaming`, `Goodhart`, `activity metric`, `outcome`) fire.

If the negative control passes, it doesn't prove the signatures are perfect
— it just shows they're not so liberal they fire on a deliberately clean
artifact. If it **fails**, the diagnosis is in `tests/seeded/last-run/` —
read the transcript and tighten the signature.

## Transcripts

`scripts/play-against.sh --check` writes each transcript to
`tests/seeded/last-run/<fixture>-vs-<role>.{log,stripped.log}` regardless of
pass/fail. The `.log` is the raw expect transcript (ANSI + cursor codes);
the `.stripped.log` is grep-friendly. Both are gitignored.

Spot-check after a green run: open one or two `.stripped.log` files and
read what the reviewer actually said. If the signature matched because the
agent mentioned the word in passing rather than as a substantive critique,
the test is positive but the signal is wrong — tighten the signature.

## Adding a fixture

If a real regression in another role's persona forces the question, add a
fixture:

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
- **No fixtures for the other six roles** in v1. Add per the recipe above
  only when a real regression demands the token cost.
