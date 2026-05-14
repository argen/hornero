# Task 11 — Refactor plan: split monolithic PaymentRails class

**Shape:** Engineer-led refactor plan critique.

**Artifact:** A 1-page refactor plan for splitting a 900-line `PaymentRails` class into provider-specific adapters (`StripeRails`, `AdyenRails`, `BraintreeRails`). Includes a characterisation-test section, a sequenced step list (4 phases over 2 weeks), a rollback path, and a "what we're NOT refactoring" section. Plan looks tidy but has two real issues: (1) the characterisation tests don't cover the failure-mode shared across providers (the `Refund` path); (2) the sequence collapses two phases that should be independent commits.

**Recommended role mix (3):**

- `software-engineer` — load-bearing; Fowler/Metz refactor critique, characterisation-test adequacy, sequence and rollback.
- `tester` — regression risk during the in-flight refactor; what tests will catch a partial-deploy break; specifically the Refund path coverage.
- `security-expert` — does the refactor preserve the auth boundaries between providers? Could the split introduce a cross-provider data-leak surface?

**Why not other roles:** no user-visible change; no measurement implications; no marketing surface.

**What "good" looks like:**

- Engineer cites Fowler (or Feathers on characterisation tests) by name; surfaces the Refund-coverage gap as a Sequence-and-Safety-Net issue.
- Engineer also catches the over-collapsed phases — names which two should be separate commits and why.
- Tester proposes ≥1 specific test that would catch a partial-deploy failure (replica-lag, mixed-version traffic).
- Security verifies the auth-boundary preservation explicitly (not "looks fine") — names which boundary, names the test that would catch a regression.
- Synthesis names a single forcing decision: ship the plan after adding Refund-path characterisation tests, or block on adding them first.

**Anti-patterns to watch for:**

- Engineer over-uses "extract helper" / "rename" suggestions; Metz on premature abstraction would flag those as candidates for *not* doing.
- Security review is a generic "consider OWASP" pass without naming a specific control.
- The 3 roles all approve the plan and the synthesis is "looks fine, ship it" (Dimension 2 failure).

**How to run:**

1. Place the refactor plan at `evals/runs/11-refactor-plan-payment-rails/artifact.md` (the `roles/software-engineer/skills/refactor-plan/SKILL.md` Examples section has a template).
2. Invoke `multi-role-review` with software-engineer + tester + security-expert.
3. Score, with particular attention to whether the synthesis preserved the Refund-coverage finding through to the recommendation.
