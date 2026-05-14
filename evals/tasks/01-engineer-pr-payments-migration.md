# Task 01 — Engineering PR: Stripe → Adyen webhook migration

**Shape:** Engineering PR review.

**Artifact:** A 600-line diff replacing Stripe webhook handlers with Adyen equivalents. Includes signature-validation changes, an idempotency-key store migration, and updated test fixtures.

**Recommended role mix (3):**

- `software-engineer` — implementation correctness, idiom, edge cases, dead code.
- `security-expert` — auth: signature validation correctness, replay protection, secret handling.
- `tester` — regression risk of replacing webhook handling; what's covered, what isn't, the manifestation-level tests for the bugs the team knows it has.

**Why not other roles:** no user-visible UI change → no designer. No measurement implications → no data-scientist. Internal infrastructure → no marketing.

**What "good" looks like:**

- Security flags at least one webhook-replay or signature-malleability concern with a named OWASP / Shostack reference and a concrete reproduction.
- Engineer surfaces a non-trivial idiom or coupling issue specific to the diff (not a generic "consider extracting a helper").
- Tester names ≥1 test the diff *should* have but doesn't, mapping the gap to a real failure mode (timezone, replay, partial-failure, idempotency).

**Anti-patterns to watch for:**

- Three roles producing the same "looks fine, ship it" finding.
- Security review citing OWASP without naming a specific control.
- Engineer or tester role wandering into product / UX critique (out-of-lens).

**How to run:**

1. Place the diff at `evals/runs/01-engineer-pr-payments-migration/artifact.md`.
2. Invoke `multi-role-review` with the three roles.
3. Score with `./evals/score.sh evals/runs/01-engineer-pr-payments-migration`.
