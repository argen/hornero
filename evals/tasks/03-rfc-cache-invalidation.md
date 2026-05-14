# Task 03 — RFC review: cache-invalidation strategy

**Shape:** Engineering RFC critique.

**Artifact:** A ~2-page RFC proposing a new cache-invalidation strategy for a high-traffic content API (move from TTL-based to tag-based, with a Redis backing store). Includes a migration plan, a fallback section, and an SLO target.

**Recommended role mix (3):**

- `software-engineer` — design clarity, alternatives considered, evolutionary-architecture concerns (strangler vs. cutover), idempotence on retries.
- `tester` — what regression risk the migration introduces, what tests the existing TTL behaviour relied on, the HTSM Time dimension (cache races, expiry edge cases).
- `data-scientist` — does the SLO target have a defensible baseline / counter-metric? Will the metric move-detection be possible given variance?

**Why not other roles:** internal infrastructure, no UI → no designer. No auth or data-flow trust boundary → no security (unless cache poisoning, but the RFC doesn't propose user-controllable cache keys). Internal change → no marketing.

**What "good" looks like:**

- Engineer cites Fowler on strangler-fig or branch-by-abstraction for the migration path, with a specific concern about the proposed cutover shape.
- Tester flags ≥1 race condition in cache-invalidation with a citation to Bach/Bolton's HTSM Time dimension.
- Data-scientist names whether the SLO target is achievable given current variance; cites Kohavi on metric design or Kozyrkov on decision-first metrics.
- The synthesis surfaces ≥1 conflict — likely tester wanting longer parallel-run, engineer wanting faster cutover for ops simplicity.

**Anti-patterns to watch for:**

- Engineer review wandering into "you should use library X instead of Y."
- All three roles producing variants of "what's the rollback plan?" (overlap).
- No conflict surfaced — these three roles routinely have real tension on migration timing.

**How to run:**

1. Provide a synthetic RFC artifact or use a real one from the team's archive.
2. Invoke `multi-role-review` with the three roles.
3. Score.
