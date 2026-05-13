# Sample session — Hornero in real use

Annotated walkthrough of a real Hornero session. Synthesized from typical patterns, not from a specific recorded transcript. The goal: show what a productive session feels like, not just what the methodology prescribes.

## Setup

**Project:** A B2B SaaS analytics tool. The team is shipping a new "Custom Cohorts" feature: users can define segments based on event sequences, save them, and reuse them across reports.

**Today's task (user message #1):**
> "Add a 'duplicate cohort' button to the cohort detail page. Users keep asking for it."

A typical solution-shaped request. Let's watch a Hornero-equipped agent work this.

---

## Phase 1 — Spec the problem (3 min)

Agent invokes `spec-the-problem` because the request is solution-shaped and not bounded enough to be trivial.

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

**Problem.** Users build a cohort, then want a near-copy with one
or two attributes changed (country, device, date range). Today they
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

---

## Phase 2 — Multi-role review on the plan (12 min)

Agent recognizes the work touches multiple concerns: data ownership, UX (the 3-click target), permissions (others' cohorts), analytics (the 40% measurement). Triggers `multi-role-review`.

**Agent triage:**
> Roles to invoke: product-manager, designer, software-engineer, data-scientist.
>
> - product-manager — verify the spec's success criteria match the real need
> - designer — the 3-click target plus edit flow needs explicit interaction design
> - software-engineer — implementation patterns; audit trail handling
> - data-scientist — the 40% measurement needs operational definition
>
> Security-expert not invoked — no auth/data-flow changes, just permission-respecting duplication on existing endpoints.

**Parallel dispatch.** Four subagents spawn at once. Each writes to `tmp/<role>-review-duplicate-cohort.md`.

**Findings (synthesized excerpt):**

**Product-manager:**
- Broad pass: spec is well-formed; problem-shape captures the need; success criteria measurable.
- Deep dive: the 40% target is plausible but unanchored — typical "near-copy then edit" patterns in B2B analytics show 60-70% (Cagan / Torres on continuous discovery patterns). Recommend setting 50% as the success target, not 40%.

**Designer:**
- Broad pass: the 3-click target is achievable; main UX question is where the duplicate button lives.
- Deep dive: states inventory. Loading state for duplication (cohorts can take seconds to materialize). Empty state if user has 0 cohorts. Error state if the source cohort is being deleted concurrently. Permission-denied state if the user lost view access between page load and click. (Nielsen heuristic #5: error prevention.)

**Software-engineer:**
- Broad pass: implementation is straightforward; existing cohort-creation API already supports the fields needed.
- Deep dive: audit trail handling. If we just call create-cohort with the source's payload, the audit shows the user as creator but loses the "duplicated from X" relationship. Recommend a `derived_from` foreign key on the cohort model. Schema migration needed.

**Data-scientist:**
- Broad pass: the 40% metric needs operational definition.
- Deep dive: "immediately edit" is ambiguous. Operationally: "the user edits ≥1 attribute of the duplicated cohort within the same session, where session = 30 min of inactivity timeout." Recommend instrumenting this as a single event `cohort_duplicated_then_edited` with the time-to-edit attribute. Counter-metric: are users abandoning the duplicate without saving? Track `cohort_duplicated_then_abandoned` symmetrically.

**Conflicts surfaced:**
- PM says success target should be 50%, not 40%. Designer's state-inventory work suggests the abandonment rate might be higher than 50% due to permission-denied edge cases for cross-user duplication. Tension: how high to set the bar.
- Software-engineer wants `derived_from` foreign key (schema migration); product-manager hadn't scoped this. Tension: is the audit trail in scope or not?

**Combined recommendations (ranked):**
1. (software-engineer, product-manager) Add `derived_from` to scope. The audit-trail constraint in the spec implies it; without it, the constraint is violated.
2. (data-scientist, product-manager) Sharpen the success-criterion measurement: `edited_within_session` defined operationally, with a counter-metric for abandonment.
3. (designer) Implement all five state variants explicitly. Loading and permission-denied are the load-bearing ones.
4. (product-manager) Set success target at 50%, not 40%; baseline data from analogous features supports it.

---

## Phase 3 — User decisions (2 min)

**User:**
> "Okay — add the foreign key, target 50%, instrument the metric properly. Designer feedback applies as you build. Go."

The agent doesn't argue. The user resolved both conflicts. The spec is now amended:

```diff
 **Success criteria.**
 - A user who has a cohort can produce a near-copy in ≤3 clicks
 - The copy is editable and saves independently
-- ≥40% of users who duplicate then immediately edit the copy
+- ≥50% of users who duplicate then edit ≥1 attribute within the same
+  30-min-inactivity session; track abandonment as counter-metric

 **Out of scope.**
 - Cohort A/B comparison (different feature)
 - Bulk duplication (defer)
 - Sharing the duplicate to a different account (different feature)
+
+**Schema impact.** Adds `cohorts.derived_from` foreign key.
```

---

## Phase 4 — Implementation (35 min)

Standard work. Red/Green TDD. The schema migration, the API endpoint, the button, the modal, the instrumentation. Agent runs tests after each substantial change.

Two surprises during implementation:

- The cohorts table is large (~12M rows). The migration to add `derived_from` would lock the table on standard MySQL. Agent flags, suggests using `pt-online-schema-change`. (Software-engineer mindset surfaced this; the role's deep-dive heuristics flag concurrent-DDL issues.)

- The 30-min inactivity session boundary requires coordinating with the existing session-tracking infrastructure. Agent doesn't have full picture of how sessions are tracked; flags and asks the user, who explains it lives in the events pipeline with a different definition (15-min, not 30-min).

The second surprise is captured by the agent as a candidate `extract-lesson` proposal: "next time, check the events-pipeline session definition before specifying time-windowed metrics."

---

## Phase 5 — Pre-commit review (5 min)

Before committing, agent invokes a smaller multi-role review focused on the actual implementation:

> "Run multi-role-review on the diff. Use software-engineer (correctness, idioms), tester (coverage, edge cases). Skip the other roles — design and PM already approved direction."

Two roles. Parallel dispatch.

**Software-engineer:**
- The `derived_from` foreign key is correct; the migration is safe with `pt-online-schema-change`.
- One nit: the API endpoint duplicates query logic from the create endpoint; recommend extracting a `_build_cohort_payload` helper. Not blocking.

**Tester:**
- Coverage is good on the happy path. Missing: a test for the permission-denied edge case when the source cohort's permissions change between load and duplication request. Recommend adding (low cost, high value).

User accepts both. Adds the helper extraction and the missing test. Commits.

---

## Phase 6 — Session end (3 min)

Agent invokes `extract-lesson`.

**Lessons surfaced (3 max, per the skill's cap):**

1. **Target:** `roles/data-scientist/ROLE.md`, "What I look for — deep dive."
   **Proposal:** Add a heuristic: "For time-windowed metrics, confirm operational definition of 'session' / 'session boundary' against the events pipeline's actual definition before specifying. Mismatch is a recurring cause of disagreement between PM specs and data-team reads."
   **Rationale:** Surfaced as a real friction point in this session; pattern likely recurs.

2. **Target:** None — proposal cancelled.
   **Rationale:** Considered proposing "add to software-engineer ROLE.md a deep-dive heuristic about concurrent DDL on large tables," but the role file already covers "implementation idioms" broadly and adding stack-specific guidance would bloat. The lesson lands in this project's CLAUDE.md instead (project-specific memory).

3. **Target:** Project memory (`~/.claude/projects/<this-project>/memory/`).
   **Proposal:** Save `feedback_session_boundary_definition.md` capturing the specific definition mismatch.
   **Rationale:** Project-specific; not transferable.

User accepts proposals 1 and 3; rejects nothing.

---

## Session outcome

- Spec landed (3 min).
- Multi-role review caught two issues (audit trail / metric operational definition) before implementation, saving rework.
- Implementation completed (35 min).
- Pre-commit review caught one missing test.
- Two durable lessons captured.

Without Hornero: the duplicate button might have shipped without the foreign key, the metric definition would have caused a measurement disagreement in a month, and the lessons would have stayed in the conversation rather than the methodology.

With Hornero: the team's collective skill compounded. Next time a time-windowed metric comes up, the data-scientist role catches the session-boundary question by default.

That's the win condition.

---

## What this session demonstrated

- **Spec problems, not solutions.** The duplicate-button request became a clearer feature.
- **Harness beats prompts.** The agent didn't need clever prompting to think across roles; the roles existed in the harness.
- **Detailed delegation matters.** Each role got an explicit brief; findings didn't overlap.
- **Parallel dispatch saved time.** Four roles in parallel: ~12 minutes total. Sequential: 45+ minutes.
- **Synthesis with conflicts named beat synthesis as concatenation.** Two real tensions surfaced; user resolved both with confidence.
- **End-state evaluation worked.** No grading of intermediate steps; the multi-role output's quality was the metric.
- **Feedback loop closed.** Lessons landed in specific durable files, not the conversation.

## What it didn't demonstrate

- Major decisions (5-7 roles). This was a 4-role review.
- The full feedback-ritual cadence. Only one session's worth of extraction.
- Heterogeneity in role outputs (e.g., a role returning generic findings and being dropped). All four roles produced useful output here.
- Conflict between roles requiring user judgment with no clear resolution. Both conflicts here were resolvable by the user with a quick decision.

Real sessions show more variance. Use this as a baseline, not a template.
