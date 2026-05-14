# Task 04 — Launch plan: LedgerStack v2 (PM-orchestrated)

**Shape:** Pre-launch cross-functional audit. **This task exercises the PM-orchestrator composition specifically** — invoke `cross-functional-orchestration`, not just `multi-role-review`.

**Artifact:** A 2-3-page launch plan for LedgerStack v2 (see `examples/sample-session.md` Session B for the shape): payments-provider migration + new dashboard + pricing tier change, Tuesday cut, public-facing.

**Recommended role mix (4):**

- `product-manager` — orchestrator; frames as a customer job, triages, synthesises.
- `marketing-expert` — positioning + brief audit (compose with `pre-launch-marketing-audit`).
- `tester` — pre-release pass (compose with `pre-release-test-pass`).
- `security-expert` — payments-provider auth + data-flow swap (compose with `pre-launch-security-audit`).
- `data-scientist` — measurement validity for migration completion + trust-NPS + ARPU claims (compose with `pre-launch-measurement-audit`).

So 4 sibling workflows running in parallel, plus the PM as orchestrator. Total: 5 roles invoked but only 4 dispatched (PM is the lead).

**Why not other roles:** dashboard UI was reviewed earlier in build; code merged; engineer not in launch-readiness scope.

**What "good" looks like:**

- The PM-orchestrator restates the customer job in one sentence in customer language at the top — not engineering language.
- The synthesis names a single forcing decision (cut Tuesday vs. hold to next Tuesday), not a list of seven sub-decisions.
- Each sibling workflow contributes ≥1 finding the others didn't — the Go/Fix-then-go/Hold recommendation per sibling is distinct.
- The final recommendation is decision-shaped: what we're doing, what we're not, outcomes we'll watch, revisit condition.
- ≥1 conflict surfaced (e.g., tester says HOLD on a refund-email bug; marketing says FIX-THEN-GO on a positioning copy issue — the PM-orchestrator chooses HOLD because the migration UX is breaking).

**Anti-patterns to watch for:**

- Synthesis is a concatenation of the four sibling readouts (relay, not integration).
- PM adjudicates a technical finding (overrides engineering's call) — Cagan violation.
- The four siblings use inconsistent recommendation shapes (the editorial pass aligned these — make sure it stuck).
- No revisit condition stated.

**How to run:**

1. Use the LedgerStack launch plan shown in `examples/sample-session.md` Session B as the artifact, or substitute a real launch plan.
2. Invoke `product-manager` / `cross-functional-orchestration` (NOT plain multi-role-review).
3. Score the orchestrated synthesis, not the per-sibling readouts.

**Note:** because this task exercises the orchestrator-of-orchestrators path, score it separately from the simpler 3-role multi-role-review tasks. Both contribute to the v1 target but distinguishing them in the run name (`04-launch-plan-ledgerstack-pm-orch`) helps with later analysis.
