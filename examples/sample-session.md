# Sample sessions — Hornero in real use

Two annotated walkthroughs. Synthesised from typical patterns, not from a specific recorded transcript. The goal: show what a productive Hornero session feels like, not just what the methodology prescribes.

- **[Session A — Dispatcher-led single task](#session-a)**: an everyday feature request handled by the dispatcher + a focused multi-role review. ~45 minutes wall-clock.
- **[Session B — PM-orchestrated launch](#session-b)**: a cross-functional launch handled by `product-manager` / `cross-functional-orchestration`, composing the four pre-launch sibling workflows. ~3 hours wall-clock.

> **Setup assumption.** Both sessions run inside a project whose `CLAUDE.md` has the Hornero dispatcher protocol wired up, with `CATALOG.md` up to date and the reviewer subagents installed under `~/.claude/agents/`. Without that setup the agent can still do the work — it just costs more prompt explicitness.

---

<a id="session-a"></a>

## Session A — Dispatcher-led single task

### Setup

**Project:** A B2B SaaS analytics tool. The team is shipping a new "Custom Cohorts" feature: users can define segments based on event sequences, save them, and reuse them across reports.

**Today's task (user message #1):**
> "Add a 'duplicate cohort' button to the cohort detail page. Users keep asking for it."

A typical solution-shaped request. Let's watch a Hornero-equipped agent work this.

### Phase 1 — Dispatcher picks `spec-the-problem` (1 min)

The prompt is solution-shaped, not bounded enough to be trivial. The agent scans `CATALOG.md` and announces:

**Agent:**
> Adopting `spec-the-problem` — the prompt is solution-shaped ("add a duplicate button"); spec the problem before implementing.

The declaration is the user's correction point. No correction follows.

### Phase 2 — Spec the problem (3 min)

**Agent:**
> Before implementing: which problem are we solving with "duplicate cohort"? Two possibilities shape the work very differently:
>
> 1. Users want a quick starting point for similar cohorts — solved by duplicate.
> 2. Users want to A/B variant a cohort to compare it — duplicate is one option; "fork with annotations" is another.
>
> Which is the underlying need?

**User:** "The first. People build a cohort, then want a near-copy for a different country or device."

**Agent produces spec:**

```markdown
# Spec — Duplicate cohort

**Problem.** Users build a cohort, then want a near-copy with one or
two attributes changed (country, device, date range). Today they
rebuild from scratch, which is slow and error-prone.

**Constraints.**
- Must preserve the original cohort's audit trail
- Must not duplicate the cohort's saved-results cache (would mislead)
- Must work for cohorts owned by other users (with view permission)

**Success criteria.**
- A user who has a cohort can produce a near-copy in ≤3 clicks
- The copy is editable and saves independently
- ≥40% of users who duplicate then immediately edit the copy (signal
  that duplication is the right unit of action, not "save as variant")

**Out of scope.**
- Cohort A/B comparison (different feature)
- Bulk duplication (defer)
- Sharing the duplicate to a different account (different feature)
```

User accepts. The spec is now the reference document.

### Phase 3 — Dispatcher escalates to `multi-role-review` (1 min)

The agent reads the spec. The work touches data ownership (engineer), the 3-click target (designer), permissions (engineer + security adjacent), and the 40% measurement (data-scientist). Multiple roles' triggers fire strongly.

**Agent:**
> Two-plus roles' triggers fire on this spec (engineer for the API + audit-trail; designer for the 3-click target + states; data-scientist for the 40% metric definition). Escalating to `multi-role-review`. Roles: product-manager (success-criteria sanity), designer, software-engineer, data-scientist. Skipping security-expert — no auth or data-flow changes, just permission-respecting duplication on existing endpoints.

Per `multi-role-review` Rule 1, four roles is appropriate scope. Per Rule 2, each role gets a five-field delegation block.

### Phase 4 — Multi-role review (12 min wall-clock)

The agent dispatches all four in a single message via the named-subagent path (since `product-manager-reviewer`, `designer-reviewer`, etc. are installed):

```python
# pseudocode for the parallel dispatch
spawn(subagent_type="product-manager-reviewer", prompt=delegation_block_pm)
spawn(subagent_type="designer-reviewer",         prompt=delegation_block_designer)
spawn(subagent_type="software-engineer-reviewer", prompt=delegation_block_engineer)
spawn(subagent_type="data-scientist-reviewer",   prompt=delegation_block_data)
```

Each subagent writes to `tmp/<role>-review-duplicate-cohort.md` and returns a ≤10-line summary.

**Findings (synthesised excerpt):**

**product-manager:**
- Broad pass: spec is well-formed; problem-shape captures the need; success criteria measurable.
- Deep dive: the 40% target is plausible but unanchored — typical "near-copy then edit" patterns in B2B analytics show 60-70% (Cagan / Torres on continuous discovery patterns). Recommend setting 50% as the success target, not 40%.

**designer:**
- Broad pass: the 3-click target is achievable; main UX question is where the duplicate button lives.
- Deep dive: per the [`state-audit`](../roles/designer/skills/state-audit/SKILL.md) heuristic, six states needed — loading (cohorts can take seconds to materialise), empty (user has 0 cohorts), error (source cohort being deleted concurrently), permission-denied (user lost view access between page-load and click), partial (huge cohort takes >5s — show progress), success. (Nielsen heuristic #5 on error prevention.)

**software-engineer:**
- Broad pass: implementation is straightforward; existing cohort-creation API already supports the fields needed.
- Deep dive: audit trail handling. Calling `create-cohort` with the source payload shows the user as creator but loses the "duplicated from X" relationship. Recommend a `derived_from` foreign key on the cohort model. Schema migration needed; flag for `pt-online-schema-change` because the table is large (>10M rows). (Fowler, *Refactoring*: small, behaviour-preserving steps; Ousterhout's "deep modules" — the audit relationship belongs in the model, not in event logs.)

**data-scientist:**
- Broad pass: the 40% metric needs operational definition.
- Deep dive: applying [`metric-definition`](../roles/data-scientist/skills/metric-definition/SKILL.md) to the success criterion — "immediately edit" is ambiguous. Operational: "the user edits ≥1 attribute of the duplicated cohort within the same session, where session = 30 min of inactivity timeout." Counter-metric (per Goodhart): `cohort_duplicated_then_abandoned` symmetrically — if users duplicate then never save, duplication may be the wrong shape entirely. Owner: Growth PM. (Kohavi on metric design; Kozyrkov on decisions before metrics.)

### Phase 5 — Synthesis with conflicts named (3 min)

The agent reads the four artefacts (not the return summaries) and produces a synthesis:

```markdown
# Multi-role review — duplicate cohort feature

Roles invoked: product-manager, designer, software-engineer, data-scientist

## Summary

Two findings affect scope: the audit-trail constraint implies a
schema change the spec didn't budget (engineer); the 40% success
target should be 50% with an operationally-defined denominator and a
named counter-metric (data-scientist + PM converging).

## Conflicts between roles

1. **Schema change in scope?** Engineer says the `derived_from`
   foreign key is required to satisfy the audit-trail constraint.
   PM hadn't budgeted a schema migration. → User decision.
2. **Success target.** PM says 50% (benchmarked); designer's state-
   audit suggests abandonment rate may be higher than expected for
   the cross-user permission-denied case, which could lower the
   observed rate. → Hedged target with counter-metric.

## Recommendations (ranked)

1. (engineer + PM) Add `derived_from` schema migration to scope. The
   spec's audit-trail constraint already implies it.
2. (data-scientist + PM) Lock the metric definition operationally —
   `cohort_duplicated_then_edited` with a 30-min-inactivity session
   boundary; track `cohort_duplicated_then_abandoned` as counter-
   metric. Target 50%.
3. (designer) Implement all six states explicitly; loading and
   permission-denied are load-bearing.
```

### Phase 6 — User decisions (2 min)

**User:**
> "Add the foreign key, target 50%, instrument the metric properly. Designer feedback applies as you build. Go."

The agent doesn't argue. The user resolved both conflicts. The spec is amended:

```diff
 **Success criteria.**
 - A user who has a cohort can produce a near-copy in ≤3 clicks
 - The copy is editable and saves independently
-- ≥40% of users who duplicate then immediately edit the copy
+- ≥50% of users who duplicate then edit ≥1 attribute within the same
+  30-min-inactivity session; track abandonment as counter-metric

+**Schema impact.** Adds `cohorts.derived_from` foreign key. Migration
+via `pt-online-schema-change` due to table size.
```

### Phase 7 — Implementation (35 min)

Standard work. Red/Green TDD. The schema migration, the API endpoint, the button, the modal, the instrumentation. Agent runs tests after each substantial change.

Two surprises during implementation, both surfaced naturally because the relevant role context was already in the agent's head:

- The cohorts table is 12M rows; the migration needs `pt-online-schema-change`. The engineer-role mindset already flagged this in Phase 4; the implementation uses it from the start.
- The 30-min inactivity boundary doesn't match the existing events pipeline's 15-min boundary. Agent flags and asks the user. User confirms — pipeline boundary is 15 min; the spec's 30 min was wrong. Spec updated; metric re-checked.

The second surprise is captured by the agent as a candidate `extract-lesson` proposal: "next time, check the events-pipeline session definition before specifying time-windowed metrics."

### Phase 8 — Pre-commit review (5 min)

Before committing, the agent runs a smaller multi-role review focused on the actual implementation. Two roles only — design and PM already approved direction.

The agent re-uses the dispatcher implicitly: "Run multi-role-review on the diff with engineer + tester" — the dispatcher knows to skip the others.

**software-engineer-reviewer:**
- The `derived_from` foreign key is correct; the migration is safe.
- One nit: the API endpoint duplicates query logic from the create endpoint; recommend extracting a `_build_cohort_payload` helper. Not blocking.

**tester-reviewer:**
- Coverage is good on the happy path. Missing: a test for the permission-denied edge case when the source cohort's permissions change between load and duplication request. (HTSM "Time" dimension: state changes between checks.) Add per [`regression-test`](../roles/tester/skills/regression-test/SKILL.md) discipline if a bug ever surfaces here; for now an integration test asserting the permission-denied state.

User accepts both. Adds the helper extraction and the missing test. Commits.

### Phase 9 — Session end (3 min)

Agent invokes `extract-lesson`.

**Lessons surfaced (3 max, per the skill's cap):**

1. **Target:** `roles/data-scientist/ROLE.md`, "What I look for — deep dive."
   **Proposal:** Add a heuristic: "For time-windowed metrics, confirm the operational definition of 'session' / 'session boundary' against the events pipeline's actual definition before specifying. Mismatch is a recurring cause of disagreement between PM specs and data-team reads."
   **Rationale:** Surfaced as a real friction point in this session; pattern likely recurs.

2. **Target:** None — proposal cancelled.
   **Rationale:** Considered proposing "add to software-engineer ROLE.md a deep-dive heuristic about concurrent DDL on large tables," but the role file already covers "implementation idioms" broadly and adding stack-specific guidance would bloat. The lesson lands in this project's CLAUDE.md instead (project-specific memory).

3. **Target:** Project memory (`~/.claude/projects/<this-project>/memory/`).
   **Proposal:** Save `feedback_session_boundary_definition.md` capturing the specific definition mismatch.
   **Rationale:** Project-specific; not transferable.

User accepts proposals 1 and 3; rejects nothing.

### Session A — Outcome

- Spec landed (3 min).
- Dispatcher's escalation to `multi-role-review` saved the user from naming roles by hand.
- Multi-role review caught two issues (audit trail / metric operational definition) before implementation, saving rework.
- Implementation completed (35 min).
- Pre-commit review caught one missing test.
- Two durable lessons captured.

Total wall-clock: ~62 minutes for the agent; ~9 minutes of user attention across the session.

---

<a id="session-b"></a>

## Session B — PM-orchestrated launch

### Setup

**Project:** Same B2B SaaS analytics tool, six weeks later. The team has built **LedgerStack v2**: a payments-provider migration (Stripe → Adyen) bundled with a new billing dashboard and a pricing-tier change. Cut is Tuesday; the launch is Wednesday.

**Today's task (user message #1):**
> "Plan the LedgerStack v2 launch. Cut Tuesday. I need to know whether we're ready."

This is cross-functional by nature — engineering, marketing, security, measurement all in scope. The integrating thread is the customer's job (migrating without losing trust in billing accuracy).

### Phase 1 — Dispatcher picks the PM-orchestrator (1 min)

The agent scans `CATALOG.md`:

**Agent:**
> Adopting `product-manager` / `cross-functional-orchestration` — the prompt is launch-shaped with customer-job-as-integrating-thread; PM-orchestrator is the right pattern (cross-functional, PM-led synthesis). I'll compose `multi-role-review` with PM framing and dispatch the pre-launch sibling workflows in parallel.

### Phase 2 — Frame the question as a customer job (15 min)

**Agent:**
> Before dispatch: state the customer job and the outcomes.
>
> **Customer job:** Existing customers want to migrate to v2 without
> losing trust in their billing accuracy, and prospects need to
> understand why v2 exists and which pricing tier fits them.
>
> **Outcomes:**
> - Migration completion ≥95% for existing customers in first 30 days
> - v2 sign-ups ≥150% of v1 monthly run rate within 14 days
> - Trust-NPS no worse than -2 points vs. pre-migration
>
> **Constraints:** Pricing change is publicly announced; Tuesday cut;
> ops queue is full.

**User:** "Job and outcomes correct. Go."

### Phase 3 — Triage the role mix (5 min)

**Agent:**
> Per `cross-functional-orchestration` Step 2:
>
> - **marketing-expert** — pricing + positioning are public; the launch message has to land.
> - **tester** — migration is the riskiest mechanic; needs pre-release pass.
> - **security-expert** — payments-provider swap is auth + data-flow change.
> - **data-scientist** — measurement of migration completion + NPS is the success criteria; needs measurement audit.
>
> 4 roles, at the upper cap of this skill. **Designer** not added — the dashboard UI changed but `design-review` already ran two weeks ago and signed off. **software-engineer** not added — the code is reviewed and merged; the question is launch-readiness, not code-correctness. (If we were earlier in the build cycle, engineer would be in.)

### Phase 4 — Compose with `multi-role-review`, dispatch the four sibling workflows in parallel (90 min wall-clock; 15 min user attention)

Each sibling role runs its `pre-launch-*` workflow as a single subagent invocation. The agent writes the four delegation blocks and dispatches in a single message:

```python
spawn(subagent_type="marketing-expert-reviewer",
      prompt=delegate("run pre-launch-marketing-audit on LedgerStack v2; outcomes attached; ..."))
spawn(subagent_type="tester-reviewer",
      prompt=delegate("run pre-release-test-pass on LedgerStack v2; ..."))
spawn(subagent_type="security-expert-reviewer",
      prompt=delegate("run pre-launch-security-audit on LedgerStack v2; ..."))
spawn(subagent_type="data-scientist-reviewer",
      prompt=delegate("run pre-launch-measurement-audit on LedgerStack v2; ..."))
```

Each subagent writes a full Go/Fix-then-go/Hold recommendation to `tmp/<role>-prelaunch-ledgerstack-v2.md` and returns the headline.

**Headlines (excerpt):**

**marketing-expert / pre-launch-marketing-audit:**
> FIX-THEN-GO. Mid-tier positioning is misaligned between the homepage hero ("for growing teams") and the pricing page implication ("for established teams") — known buyer-confusion shape (Dunford). Required pre-cut: rewrite mid-tier copy in homepage + sales deck.

**tester / pre-release-test-pass:**
> HOLD. Two blockers: BUG-1302 (refund-email says "refunded in full" when partial) and BUG-1305 (order-detail page loses provider/last-4 on the v1→v2 migration — visible regression). Three warnings tracked. GO once both BUG fixes merged + suite re-runs green.

**security-expert / pre-launch-security-audit:**
> GO. Threat model refreshed; Adyen webhook validation correct; PCI scope unchanged from v1. One warning: KWD currency rounding direction is wrong for a small audience — tracked, not blocking, finance sign-off post-launch.

**data-scientist / pre-launch-measurement-audit:**
> FIX-THEN-GO. Three findings:
> - BUG-M1: `migration_completion_rate` definition drifted (denominator changed from "customers in migration cohort" to "customers prompted to migrate"). Re-baseline + communicate in readout.
> - BUG-M2: `trust_NPS_delta` has no counter-metric; without it, an NPS lift could mask a concurrent-CS-volume spike. Add and instrument before launch.
> - Causal-claim audit: the "pricing change causes ARPU lift" claim is observational with confounded selection (mid-tier customers self-select). Weaken to associational in launch communications; experiment in subsequent cohort.

### Phase 5 — Synthesise through the PM lens (20 min)

The agent does not relay findings verbatim. Per `cross-functional-orchestration` Step 4, it integrates against the customer-job frame.

**Single forcing decision:** *cut Tuesday or hold to next Tuesday.*

**Mapping findings to the job:**

- Tester blockers (BUG-1302, BUG-1305) **break the job directly** — both surface during the migration UX; a customer hitting either loses trust in billing accuracy.
- Marketing positioning gap **misframes the job** for prospects but doesn't break it for existing customers (the primary audience for the cut).
- Data-scientist BUGs **measure the wrong outcome** if uncorrected; would compromise post-launch decision quality.
- Causal-claim weakening **prevents a future over-claim**; non-blocking.
- Security warnings **don't affect the job**; tracked separately.

**Trade-off in product language:** Ship Tuesday with feature-flagged blockers? Considered. Rejected because BUG-1305 is *on the migration path itself* — flagging it would mean a partially-broken migration UX for the affected customers. The whole point of the cut is the migration; flagging breaks the cut.

### Phase 6 — Decision recommendation (10 min)

```markdown
# Decision — LedgerStack v2 launch readiness

**Recommendation:** HOLD the Tuesday cut. Ship the following Tuesday
after BUG-1302 + BUG-1305 are merged and the tester suite re-runs
green. Marketing fixes the mid-tier positioning copy in the homepage
hero and sales deck before re-cut. Data-scientist BUGs (M1 + M2)
fixed before re-cut. Security KWD warning tracked, not blocking.

**We are NOT:** shipping Tuesday with feature-flagged blockers
(considered; rejected because BUG-1305 is on the migration path
itself — flagging would mean a partial-migration UX for affected
customers).

**Outcomes we'll watch (post next-Tuesday ship):**
- Migration completion ≥95% in 30 days
- v2 sign-ups ≥150% of v1 monthly run rate in 14 days
- Trust-NPS within ±2 points of pre-migration
- (Counter-metric) CS volume per migration cohort week — alarm at +20%

**Revisit condition:** If migration completion is <70% by day 14 of
the new ship date, pause new-customer v2 onboarding and run a
discovery pass to identify the hold-up.

**Owners:**
- Engineering lead: BUG-1302 + 1305 merged + re-run by Monday EOD.
- CMO: mid-tier positioning copy refresh in homepage + deck by Monday EOD.
- Data team: re-baseline `migration_completion_rate`; add `trust_NPS_delta`
  counter-metric; weaken pricing-causal language in launch comms.
- Security: tracks KWD rounding; finance sign-off post-launch.
- PM: drafts the customer migration email; writes the rollout note;
  schedules the revisit on day 14.
```

Circulated to head of payments, head of CX, and the four role leads. Head of payments accepts.

### Phase 7 — Session end (5 min)

Agent invokes `extract-lesson`.

**Lessons surfaced (2):**

1. **Target:** `roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md`, "Common Pitfalls" section.
   **Proposal:** Add a pitfall titled "Definition drift unspoken in launch communications." This audit's BUG-M1 was a definition drift the team would have communicated externally; an explicit pitfall about communicating definitional changes alongside metric numbers would generalise.
   **Rationale:** The drift wasn't caught earlier because no skill flagged "the launch readout will display this metric with the new definition; was the change communicated?" Worth folding back.

2. **Target:** `roles/marketing-expert/skills/positioning-canvas/SKILL.md`, "Examples" section.
   **Proposal:** Add the LedgerStack mid-tier mismatch as a concrete example of homepage-vs-pricing-page positioning drift.
   **Rationale:** Specific, real example beats hypothetical.

User accepts both.

### Session B — Outcome

- Decision delivered: HOLD with a specific flip condition.
- Four sibling pre-launch workflows ran in parallel; the PM-orchestrator did the integration that none of the four siblings could have done alone (each views the launch through its own lens; the customer-job frame integrates).
- Two durable lessons captured for the methodology.
- Stakeholder sign-off in one round; no political escalation.

Total wall-clock: ~2.5 hours for the agent (much of it parallel subagent runtime); ~30 minutes of user attention.

---

## What these sessions demonstrated

- **The dispatcher saves the user from naming roles.** "Add a duplicate button" and "plan the launch" became `spec-the-problem` and `cross-functional-orchestration` automatically, with the agent declaring its choice in one line.
- **Multi-role review and PM-orchestration compose.** The launch ran four sibling pre-launch workflows in parallel; the PM-orchestrator framed the question and synthesised against the customer job. Generic multi-role-review without PM framing would have produced a meeting transcript; with framing, it produced a decision.
- **Skill composition works.** The data-scientist's `pre-launch-measurement-audit` internally used `metric-definition`, `experiment-design`, and `causal-dag`. The designer's `design-review` would have used `state-audit` + `accessibility-audit` + `heuristic-review`. Workflows that compose components stay tractable.
- **Named subagents are leaner than generic.** `subagent_type: "tester-reviewer"` carries the role's mindset, heuristics, anti-patterns, and source list in the system prompt — the delegation block only carries the task-specific brief.
- **Conflicts named beat conflicts averaged.** Session A surfaced two tensions; the user resolved both. Session B surfaced four overlapping recommendations; the PM-orchestrator integrated them against the customer job and produced a single forcing decision.
- **Lessons land in specific durable files.** Across both sessions, four candidate lessons were proposed, three accepted, all routed to specific files (a ROLE.md, a SKILL.md, a project memory) — not the conversation.

## What they didn't demonstrate

- **The major-decision shape (5-7 roles).** Session B was a 4-role audit; the cap for `cross-functional-orchestration` is 5. The 6-7-role case (a strategy session, an org-level call) needs a different worked example.
- **A failure where the dispatcher picks wrong.** Both sessions had a clean dispatch; the user-redirect path ("designer instead") is documented but not shown.
- **A subagent producing thin output that the orchestrator drops.** A real session occasionally sees this; the worked examples here had four useful subagents each.
- **The full feedback-ritual cadence.** Two sessions of `extract-lesson` proposals; the long-tail compounding effect is not visible at this scale.

Real sessions show more variance. Use these as a baseline, not a template.
