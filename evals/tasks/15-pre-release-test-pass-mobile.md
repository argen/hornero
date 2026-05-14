# Task 15 — Pre-release test pass: mobile app v3.0

**Shape:** Tester-orchestrated workflow composition. **This task exercises the `pre-release-test-pass` workflow skill specifically** — invoke that workflow, not plain `multi-role-review`.

**Artifact:** A release-candidate package for a B2B SaaS mobile app v3.0 (iOS + Android). Includes: release notes (5 user-visible changes + 12 bug fixes), the test plan for this release cycle (`test-plan` output), a regression-test report (87/90 tests passing — 3 flaky), an exploratory-charter completion report, and a manual smoke-pass checklist completed by QA. The release manager asks: Go, Fix-then-go, or Hold?

**Recommended role mix (4):**

- `tester` — workflow runner; runs `pre-release-test-pass`; synthesises evidence into Go / Fix-then-go / Hold.
- `software-engineer` — adjudicates the 3 flaky tests (real bugs vs flakiness vs environmental); estimates fix cost.
- `security-expert` — has anything in the diff touched auth / data flow / dependency surface that warrants a security re-check before release?
- `designer` — any user-visible regression in the 5 user-visible changes that wasn't caught by automated tests? (State-audit on the deltas only, not the whole app.)

**Why not other roles:** marketing review happens at a different cycle (launch-brief is downstream); data-scientist measurement-audit is downstream (post-release).

**What "good" looks like:**

- Tester correctly distinguishes the 3 flaky tests using oracles — at least one of the three should be re-classified (real bug, not flake).
- Tester produces a Go / Fix-then-go / Hold recommendation with a specific rationale per contributing input (test-plan coverage met? exploratory-charter findings actionable? smoke-pass complete?).
- Engineer estimates the fix cost honestly — if a flake is a real bug, what's the fix size and the regression-test that would have caught it?
- Security gives a Go or Hold with named scope (not a generic "no obvious concerns"); if Go, names what was checked.
- Designer's state-audit on the 5 deltas surfaces ≥0 findings — zero is acceptable if the deltas are genuinely minor; if so, the synthesis should say so explicitly.
- The final Go / Fix-then-go / Hold is decision-shaped, names the revisit-condition if Fix-then-go.

**Anti-patterns to watch for:**

- Tester runs as `multi-role-review` instead of `pre-release-test-pass` (loses the workflow's discipline).
- "Pass" claimed because the test count is high, without engaging with the flakes (Bach/Bolton: skill over script).
- Synthesis is a concatenation of role inputs without a single forcing decision (Dimension 4 failure).
- The 4 roles produce overlapping "looks fine" findings (Dimension 2 failure).

**How to run:**

1. Place the release-candidate package at `evals/runs/15-pre-release-test-pass-mobile/artifact.md` (or as a folder with multiple files referenced from it).
2. Invoke `tester` / `pre-release-test-pass` workflow specifically (NOT plain multi-role-review).
3. Score the workflow's synthesis, not the contributing role-level inputs.

**Note:** like task 04 (PM-orchestrated launch), this task exercises a workflow-composition path. Score it in the workflow-composition cohort alongside 04 when aggregating; the simpler 3-role multi-role-review tasks make up the other cohort.
