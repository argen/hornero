# Task 02 — PRD review: duplicate cohort feature

**Shape:** PRD critique.

**Artifact:** A 1-page PRD for the "duplicate cohort" feature (see `examples/sample-session.md` Session A for the structure). Stated problem, three success criteria, two constraints, an out-of-scope list.

**Recommended role mix (4):**

- `product-manager` — problem fit, success-criteria measurability, big-risk coverage (Cagan's value/usability/feasibility/viability).
- `designer` — the 3-click target, state inventory for the duplicate flow.
- `software-engineer` — feasibility, audit-trail implications, schema impact.
- `data-scientist` — the 40% success-metric definition; counter-metric; gaming surface.

**Why not other roles:** no auth or data-flow change → no security. No public launch → no marketing.

**What "good" looks like:**

- Data-scientist names the operational definition gap in "immediately edit" with a concrete fix (session-boundary anchor + counter-metric for abandonment).
- Engineer surfaces the audit-trail / `derived_from` schema implication that the spec didn't budget.
- Designer enumerates all six states (empty / loading / error / partial / success / permission-denied) rather than just "looks fine."
- PM frames at least one finding around big-risk coverage (probably viability — measurement adequacy).
- The synthesis names ≥1 conflict: probably "is the schema change in scope" or "is the success target 40% defensible."

**Anti-patterns to watch for:**

- Each role surfacing the same "the success criteria need sharpening" finding (overlap).
- PM and designer both reviewing the UX flow (PM should defer to designer).
- No conflict surfaced (the schema-scope tension is right there).

**How to run:**

1. Use the PRD shown in `examples/sample-session.md` Session A as the artifact, or write a fresh one.
2. Invoke `multi-role-review` (or `cross-functional-orchestration` for the PM-orchestrator path) with the four roles.
3. Score.
