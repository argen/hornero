---
name: github-pr-survey
description: Use when an engineer needs to size up a PR before reviewing or merging — diff shape, CODEOWNERS coverage, related issues, CI status, review state. Produces a 60-second briefing the reviewer can read before opening the diff.
intent: |
  Reduce time-to-context on a PR. Surface diff shape, who owns the
  touched code, what issues it claims to close, what CI is saying, and
  whether the review state is honest. Output is a brief, not a verdict.
type: workflow
theme: code-review
resources:
  - github
best_for:
  - Pre-review triage on a long-lived PR
  - Auditing a stack of open PRs for "what should I look at first"
  - Pre-merge sanity check by the PR author
scenarios:
  - "Engineer about to review a 30-file PR they didn't write"
  - "PR author preparing their own pre-flight before requesting review"
  - "Reviewer queue triage — which of N open PRs needs eyes most urgently"
estimated_time: 5-10 minutes per PR
---

# github-pr-survey — pre-review PR briefing

> v0 draft. Workflow over the [`github`](../../../../resources/github/RESOURCE.md) resource. Anchors to Mike Cohn (small batches), John Ousterhout (deep modules / commentary discipline), Trisha Gee (review-not-rubber-stamp). See `roles/software-engineer/sources.md`.

## Purpose

Sizing up a PR before reading the diff. The skill answers four questions in order: *what is changing*, *who owns what's changing*, *what does this claim to do*, *what is CI saying about it*. Output is a one-page briefing that fits in a Slack message or a pre-review note to self — not a review verdict.

Used right, this skill replaces the implicit "open the diff and scroll" pattern that wastes 5-10 minutes per PR and biases the reviewer toward the first hunk they see.

## Key Concepts

### Diff shape ≠ diff size

A 500-line PR that touches one file is fundamentally different from a 500-line PR that touches 30 files. Cohn (small batches) and Ousterhout (deep modules) both argue that *shape* — concentration, layering, and surface area — matters more than total line count. A PR survey leads with shape.

### CODEOWNERS as the social map

`.github/CODEOWNERS` (or `docs/CODEOWNERS`) is the team's declared ownership of the codebase. Touching a file without a CODEOWNERS owner on the review is a signal — either the file's ownership is stale, or the PR is missing a required reviewer. The survey surfaces this; it doesn't enforce.

### Closes-link discipline

GitHub recognises `closes #N` / `fixes #N` / `resolves #N` in PR bodies. PRs claiming to close an issue should reference it; PRs that don't close anything but link issues are exploratory work and warrant a different review depth. The survey reads this from the body and timeline.

### Honest review state

GitHub's `mergeable_state` (`clean`, `unstable`, `behind`, `blocked`, `dirty`) is the official "is this safe to merge" signal. Many teams ignore it and read green-check vibes instead. The survey reads the actual state.

## Application

### Step 1 — Pull the PR slice

If the `github` MCP server is connected, use the structured tool path: `get_pull_request`, `get_pull_request_files`, `get_pull_request_reviews`, `list_commits` for the PR's commits. Otherwise drop to `gh pr view --json` + `gh api .../pulls/N/files` per [`resources/github/RESOURCE.md`](../../../../resources/github/RESOURCE.md) § *Fallback Without MCP*.

Three slices to pull:

1. **PR metadata** — title, body, base, head, draft, mergeable, mergeable_state, additions/deletions, changed_files.
2. **File list** — paths, additions/deletions per file.
3. **Reviews + checks** — approvals, change-requests, current CheckRun statuses.

### Step 2 — Compute diff shape

From the file list:

- **Concentration:** what fraction of changed lines are in the top file? In the top 3 files? A "broad shallow" PR (30 files, 3 lines each) is structurally different from a "narrow deep" PR (3 files, 200 lines each). Both can be fine; the review approach differs.
- **Layer crossings:** how many distinct directory roots are touched? A PR that crosses `frontend/` + `backend/` + `migrations/` warrants more scrutiny than one in `frontend/components/` alone.
- **Test ratio:** lines added in `**/*test*` / `**/*spec*` / `tests/` vs. lines added elsewhere. A PR with zero test changes touching production code is a flag, not a fault.

### Step 3 — Map CODEOWNERS coverage

Parse `.github/CODEOWNERS` (the MCP server returns the raw file; the gh fallback uses `gh api repos/{owner}/{repo}/contents/.github/CODEOWNERS`). For each changed file:

- Match against CODEOWNERS globs (later-rule wins per GitHub's documented semantics).
- For each matched owner, check whether they're in the PR's reviewers list or approving review.

Output: *coverage = files with an owner in the review queue / total files with declared owners*. < 0.7 is worth surfacing.

### Step 4 — Read the closes-links

Scan PR body and timelineItems for `closes`/`fixes`/`resolves` references. For each linked issue:

- Is the issue open? Closed? In what state?
- Does the issue title align with the PR title? (A PR closing 3 issues from different areas often does too much.)

### Step 5 — Read the CI honestly

Don't trust the green checkmark; read `mergeable_state` and the explicit CheckRun conclusions:

- `mergeable_state: clean` — passes all required checks + branch up to date + has required reviews. Mergeable.
- `mergeable_state: unstable` — passes required checks but some non-required check failed. Often fine; sometimes a flaky test hiding a real issue.
- `mergeable_state: behind` — branch is behind base; needs rebase / merge.
- `mergeable_state: blocked` — failing required check or missing required review.
- `mergeable_state: dirty` — merge conflict.

### Step 6 — Write the briefing

```markdown
# PR survey — #<N> — <title>

**Status:** <draft|ready> · <mergeable_state> · CI: <pass|fail|mixed>
**Diff shape:** <N> files, +<add>/-<del>. Top file: <path> (<X>% of changes).
**Layers crossed:** <frontend, backend, migrations, ...>
**Test ratio:** <added test lines> / <added prod lines> (= <ratio>)

## Ownership
- CODEOWNERS coverage: <X>/<Y> files have a declared owner in the review queue.
- Missing: <files with owners not yet in reviewers>

## What it claims to do
- Closes: #<issue> (<state>; <title>)
- Linked but not closing: #<issue>

## Read first
1. <file path> — <why>
2. <file path> — <why>

## Open questions for the author
- <q1>
- <q2>
```

The "Read first" list is the survey's most-load-bearing output. It saves the reviewer from being anchored on whatever hunk happens to open the diff.

## Examples

### Example 1 — Broad shallow refactor

**Pull:** PR #142, 47 files, +312/-198, no tests changed.

**Shape:** broad shallow. Top file is 23% of changes; rest is ≤ 5% each. Layers crossed: `app/`, `lib/`, `docs/`.

**CODEOWNERS:** 47 changed files, 31 have declared owners. Only 1 of 4 owning teams is in the reviewers list — `@org/api`, `@org/docs`, `@org/lib-platform` are all missing.

**Closes-links:** body says "rename utility module"; no issue link.

**Briefing's *Read first*:**
1. `lib/util/index.ts` — the rename root; if this is wrong, everything downstream is wrong.
2. `app/api/handlers/auth.ts` — the only non-mechanical caller change (the rest are import-only).
3. `migrations/` — there's a single migration mixed in; verify it actually belongs in this PR.

### Example 2 — Narrow deep change

**Pull:** PR #208, 3 files, +480/-12, all in `services/billing/`. 280 of 480 lines are in `services/billing/proration.ts`.

**Shape:** narrow deep. Concentrated in one file (58%). One layer (`services/billing/`).

**CODEOWNERS:** all 3 files owned by `@org/billing`; both billing-team members are on the review queue.

**Closes-links:** "closes #1042" — an open issue titled "Proration miscalculates on plan downgrades."

**CI:** `mergeable_state: unstable`. The required test suite passes; an integration nightly is failing on a Stripe sandbox flake unrelated to this code.

**Briefing's *Read first*:**
1. `services/billing/proration.ts` (lines 89-220) — the core algorithm change. Read it against the test cases in the same PR.
2. Tests in the same file — verify they actually pin the new behaviour, not just exercise it.
3. The Stripe nightly failure — confirm it's the documented flake, not a regression.

### Example 3 — Stale ownership signal

**Pull:** PR #77, 4 files, +60/-30. All in `tools/scripts/`.

**CODEOWNERS:** `tools/scripts/` is owned by `@org/devx`. `@org/devx` was disbanded 4 months ago.

**Briefing's *Open questions* leads with:** "Ownership of `tools/scripts/` per CODEOWNERS is `@org/devx`, which no longer exists. Who owns this directory now? Either CODEOWNERS needs updating, or this PR needs a real reviewer."

The PR was not the failure here; CODEOWNERS was. The survey surfaced it; the engineer can choose to fix CODEOWNERS in a follow-up or ask in channel.

## Common Pitfalls

### Pitfall 1 — Survey as gate

**Symptom:** Engineer treats the survey output as a verdict ("CODEOWNERS coverage < 0.7 means reject").

**Consequence:** Survey calcifies into a rule. Real-world PRs hit edge cases; teams resent the tool.

**Fix:** The survey produces a briefing, not a verdict. Coverage < 0.7 is a *question to raise*, not a *reason to block*.

### Pitfall 2 — Surveying every PR

**Symptom:** Engineer runs the survey on every 10-line typo-fix PR.

**Consequence:** Overhead. PR throughput drops. Team learns to skip the survey, including for the PRs that needed it.

**Fix:** Survey large or cross-layer PRs (≥ 200 lines changed OR ≥ 3 directory roots OR ≥ 5 files) and external-contributor PRs. Tiny PRs don't need it.

### Pitfall 3 — Trusting green checkmark over `mergeable_state`

**Symptom:** Survey reads "all checks pass" from the visual; misses that one required check is queued, not green.

**Consequence:** Merge a PR that wasn't actually ready.

**Fix:** Always read `mergeable_state` explicitly; treat `unstable` as "look at why."

### Pitfall 4 — Ignoring the test-ratio

**Symptom:** A 400-line production change with 0 test lines added passes survey because all checks are green.

**Consequence:** Tests prove the old behaviour; the new behaviour is verified only by manual inspection.

**Fix:** Test ratio < 0.1 on a PR > 100 prod lines goes in the *Open questions* section.

### Pitfall 5 — Anchoring on the first file in the diff

**Symptom:** Without an explicit *Read first* list, the reviewer opens the diff and starts reading at the alphabetically-first file path.

**Consequence:** Reviewer attention is unrelated to where the risk is.

**Fix:** Always produce the *Read first* list of 2-3 paths. Make it the load-bearing output of the survey.

## References

- **John Ousterhout** — *A Philosophy of Software Design*; deep modules / commentary discipline. See `roles/software-engineer/sources.md`.
- **Mike Cohn** — *Succeeding with Agile*; small batches argument.
- **Trisha Gee** — *Getting Started with Code Review*; review-not-rubber-stamp.
- **GitHub docs** — CODEOWNERS semantics and `mergeable_state` enumeration.
- **Resources used:** [`resources/github/RESOURCE.md`](../../../../resources/github/RESOURCE.md).
- **Related Hornero skills:**
  - `roles/software-engineer/skills/refactor-plan/SKILL.md` — when the survey reveals "this PR is two PRs."
  - `skills/decision-record/SKILL.md` — if the PR enshrines a non-obvious decision, write it up.
  - `skills/memory-query/SKILL.md` — check for prior decisions affecting the touched area before reviewing.
