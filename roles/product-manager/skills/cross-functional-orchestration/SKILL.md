---
name: cross-functional-orchestration
description: Use when a PM needs to coordinate cross-functional work — a launch, a contested decision, a roadmap call, a strategic question — by framing it as a customer job, dispatching the right role mix, and synthesising into a product decision.
intent: |
  Composes `multi-role-review` with product-management framing so the PM
  acts as the orchestrator-integrator rather than a generic lead agent.
  The skill enforces three disciplines: frame the question as a customer
  job before dispatching (Christensen JTBD); pick the role mix from the
  job, not from politeness (Cagan integration); synthesise into a
  decision recommendation with outcomes and a revisit condition (Wodtke
  outcomes, Doshi decision quality) rather than relaying findings.
type: workflow
theme: orchestration
best_for:
  - A product launch where PM, marketing, tester, and security need to land together
  - A contested "should we build X" decision crossing 2-4 functions
  - A roadmap call that depends on technical feasibility, design viability, and market timing
  - A strategic question (positioning shift, pricing change, new segment) needing multi-lens evidence
scenarios:
  - "Should we build a 'duplicate cohort' feature in Q3 given engineering's refactor backlog?"
  - "Plan the LedgerStack v2 launch — PM + marketing + tester + security"
  - "Is the new admin permissions model ready for GA — viability, security, UX?"
  - "Should we drop the legacy export flow or invest in fixing it?"
estimated_time: 30-90 minutes (PM time); 5-15 minutes (role subagent time, parallel)
---

# Cross-functional orchestration

> v0 draft. Grounded in Marty Cagan's PM-as-integrator (*Inspired*, *Empowered*), Martin Eriksson's PM Venn (Tech/Business/UX), Clayton Christensen's Jobs-to-be-Done, Christina Wodtke's outcomes-over-outputs (*Radical Focus*), Shreyas Doshi's high-quality-decisions framing, and Anthropic's orchestrator-worker multi-agent pattern.

## Purpose

Run a PM-led orchestration of cross-functional work, producing:

1. **A reframed question** — the user's prompt restated as a customer job + outcomes + constraints.
2. **A justified role mix** — 2-5 roles chosen because the job demands them, not because all roles are present.
3. **Parallel role findings** — via [`skills/multi-role-review`](../../../../skills/multi-role-review/SKILL.md), passed in with a PM-framed brief.
4. **A PM-synthesised decision recommendation** — outcomes, success criteria, alternative considered, revisit condition.

This skill is not `multi-role-review` with a different name. `multi-role-review` is the generic orchestration *mechanism* — any role can invoke it. `cross-functional-orchestration` is the PM-specific *composition* of that mechanism: it adds JTBD-shaped triage in front and outcomes-shaped synthesis behind. The PM is the integrator; this is the skill that makes integration legible.

It is also not the only orchestrator pattern. A staff engineer orchestrates a technical migration; a security expert orchestrates an incident retrospective; a CMO orchestrates a launch from the message side. PM-led orchestration fits cross-functional product decisions where the *customer job* is the integrating thread. When the integrating thread is technical or compliance-driven, route to the appropriate orchestrator instead.

## Key Concepts

### PM as integrator, not adjudicator

Cagan (*Inspired*, *Empowered*) and Eriksson (PM Venn) frame the PM as the integrator at the intersection of Tech, Business, and UX — the role whose job is to hold the whole, not to out-engineer the engineers or out-design the designers. The orchestrator skill operationalises that: PM frames the question, dispatches experts, synthesises their findings into a product decision. The PM does not pretend to be a security oracle or a refactoring oracle.

### Jobs-shaped triage

Christensen, Hall, Dillon & Duncan (*Competing Against Luck*) and Bob Moesta (*Demand-Side Sales*) frame product work around the customer's **job** — the progress they're trying to make. Triaging the role mix from the job (rather than from a list of "people who should probably be involved") is the load-bearing PM contribution. If you can't articulate the job in one sentence, the orchestration is premature.

### Outcomes over outputs

Wodtke (*Radical Focus*) and Perri (*Escaping the Build Trap*) push the team away from "did we ship X" toward "did the customer's progress change." The synthesis step asks the team: what outcomes will tell us this decision was right? Without that, the orchestration produces sign-off, not learning.

### High-quality decisions

Doshi's high-quality-decisions framing distinguishes the *decision quality* from the *outcome quality* — a good decision can produce a bad outcome (and vice versa). The skill demands the PM record the decision's reasoning and the revisit condition so the team can later assess decision quality independently of luck.

### Orchestrator-worker, with PM framing

The Anthropic multi-agent research system framing (orchestrator-worker, detailed delegation, parallel-first, artifact passing, end-state eval) underlies `multi-role-review`. This skill consumes that protocol. Where `multi-role-review` says "decompose the task per role," this skill says "decompose the customer job per role, in PM language." Same machinery, sharper framing.

### The minimum role set

Cagan: the smallest set of people that can make the call is the right set. Eriksson: the integrator's job is to keep the meeting small enough to decide. Don't dispatch 7 roles when 3 will do; don't dispatch 3 when the job genuinely demands 5. The triage is the PM's contribution to scarcity — every role added is added by name and reason.

### Decision-shaped recommendation

A useful recommendation answers: **what are we doing, what we are not doing instead, what outcomes we'll watch, when we'll revisit, and what would change our mind.** Vague recommendations ("the team should align") are not orchestration outputs; they are meeting transcripts.

## Application

Six steps; PM time 30-90 minutes (less for simple decisions, more for launches); role-subagent time runs in parallel and totals 5-15 minutes via `multi-role-review`.

### Step 1 — Frame the question as a customer job (10-15 minutes)

Before dispatching anyone, the PM restates the cross-functional ask as:

- **The customer job** — one sentence in customer language. "Customers using cohorts for country-level reporting want to start a new analysis from a near-copy of an existing cohort rather than rebuilding from scratch."
- **The outcomes** — 1-3 observable signals that would tell us the decision was right (engagement-with-feature, time-to-second-analysis, support-ticket reduction).
- **The constraints** — what bounds the answer (engineering capacity this quarter, security review queue, the launch date marketing has committed to).

If the prompt arrives without a job — "should we build X?" — the PM converts it first. The conversion is the orchestrator's protective layer against feature-factory thinking (Perri).

Output: a one-page frame the PM stands behind.

### Step 2 — Triage the role mix from the job (5-10 minutes)

For each candidate role, ask: **what would this role surface that the job demands and nobody else would?** If you can't answer, the role doesn't go in.

PM-led heuristics:

- **Job touches user comprehension** → designer.
- **Job touches non-trivial new code, infrastructure, or migration** → software-engineer.
- **Job involves user input crossing trust boundaries, auth, data, or LLM tools** → security-expert.
- **Job has measurable success criteria that need protection** → tester (regression risk) + data-scientist (measurement validity).
- **Job is launch-shaped** (positioning, audience, channel timing) → marketing-expert.

If you arrive at >5 roles, drop the weakest match. Cagan's minimum-set discipline: every added role widens synthesis cost. Strict cap of 5 in this skill (vs. `multi-role-review`'s upper bound of 7) — when 6+ are genuinely needed, you're orchestrating a launch and should compose with the pre-launch sibling workflows instead.

Output: an itemised role mix, each line `role — what this role uniquely surfaces`.

### Step 3 — Compose with multi-role-review (5-15 minutes wall-clock)

Invoke [`skills/multi-role-review`](../../../../skills/multi-role-review/SKILL.md) with the framed brief. The PM provides:

- **The framed question** (Step 1) as the shared context for all role subagents.
- **A per-role scope** that names *the part of the job this role owns*. Not "review the PR for security" — "review the PR for whether the auth changes preserve the customer's trust that a saved cohort is theirs alone."
- **The standard delegation fields** (output format, sources, success criteria, out-of-scope) per `multi-role-review` Rule 2.

The subagents run in parallel and return condensed findings via the standard `tmp/<role>-review-<slug>.md` artifact pattern. The PM does not re-implement orchestration; this step *uses* the orchestration mechanism.

### Step 4 — Synthesise through the PM lens (15-30 minutes)

Read the role findings. Then write a synthesis that does five things `multi-role-review`'s generic synthesis doesn't:

1. **Map findings to the customer job.** Each finding either advances, blocks, or is orthogonal to the job. Orthogonal findings get filed; they're not synthesis material.
2. **Surface trade-offs in product language.** Not "engineering wants a 3-week refactor and design wants a new component," but "if we ship in 2 weeks we delay the engineering refactor by a quarter, and we ship the existing component pattern users already understand." The PM translates each function's vocabulary into the customer-job frame.
3. **Identify the single decision** the orchestration is forcing. Not 7 sub-decisions — the one decision that, once made, unblocks the rest.
4. **Name the alternative explicitly.** Heath brothers' Widen Your Options: any decision recommendation is sharpened by naming the alternative considered and the reason it was set aside. "We're not [alternative] because [reason]."
5. **Carry citations forward.** When summarising each sibling's finding, name 1-2 load-bearing citations from that role's review — the framework, author, OWASP code, NIST control, or named source they leaned on. The PM-synthesised decision is *defensible* only when its grounding is visible; without citations the synthesis reads as PM judgement asserting authority over expert findings, and the decision becomes unreviewable after the meeting. Rule of thumb: one named source per sibling, surfaced inline in the synthesis paragraph (preferred) or in a "Grounding" line at the foot of the decision recommendation (acceptable fallback). This requirement was added after the v0 eval pilot (`evals/PILOT-REPORT.md`) caught a citation washout in PM-orchestrator synthesis — distinct from `multi-role-review`'s plain synthesis where citations sit closer to the findings.

Output: a synthesis section ≤1 page that a non-PM stakeholder can read in 3 minutes and act on.

### Step 5 — Produce the decision recommendation (10-15 minutes)

Write the recommendation in this shape:

```markdown
# Decision — <one-sentence framing of the question>

**Recommendation:** <one sentence: what we are doing>

**We are NOT:** <one sentence: alternative considered, reason set aside>

**Outcomes we'll watch:**
- <metric / signal>: <expected direction within timeframe>
- <metric / signal>: <expected direction within timeframe>

**Revisit condition:** <what would change this decision — concrete signal, not "if things go poorly">

**Owners:**
- <role / person>: <what they do next>

**Open questions:** <each owned by a name with a deadline; none if there are none>

**Grounding:** <one line per sibling — the load-bearing source they cited. e.g., "Security: OWASP ASVS V2.9.1 (timing-safe comparison); Tester: Hendrickson's Money tour; Marketing: Dunford positioning canvas; Data-science: Kohavi SRM check.">
```

This shape encodes Doshi's decision-quality discipline (the reasoning is recorded so the decision can be assessed independently of outcome) and Heath brothers' WRAP framework (Widen options, Reality-test, Attain distance, Prepare to be wrong → the "revisit condition" line is "prepare to be wrong" made operational). The Grounding line is the citation-carry-forward discipline made operational — without it, the orchestrator-of-orchestrators synthesis tends to compress citations out of the decision artifact (eval pilot finding, task 04: cite-rate 0.0 with 1.0 on every other dimension).

### Step 6 — File and follow up (5-10 minutes)

The recommendation goes to:

- The product wiki / decision log (this is the durable artifact; meeting notes aren't).
- A calendar entry for the revisit condition (not "Q3 retro" — the *specific signal* that would trip the revisit).
- A handoff line to each named owner.

Open questions go on the discovery list (Torres OST: opportunities, not solutions, at this stage).

## Examples

### Example 1 — "Should we build a duplicate-cohort feature?" (good)

A PM receives the cross-functional ask: "Should we build a 'duplicate cohort' feature this quarter? Engineering says it's small but they're mid-refactor; design isn't sure about the right UI; CS keeps mentioning it."

**Step 1 — Frame.** Customer job: *Users who build a cohort want to start a near-copy with one or two attribute changes (country, device, date range) without rebuilding from scratch.* Outcomes: time-to-second-analysis halves; cohort-rebuild support tickets drop 80%; weekly cohort-creation rate rises. Constraints: engineering's refactor of the cohort-storage layer is mid-flight; no new visual components this quarter.

**Step 2 — Triage.** designer (UI pattern + state inventory for the duplicate flow); software-engineer (feasibility against refactor; data-model impact); product-manager-self (synthesis, JTBD evidence from CS tickets). No security: no auth or data-trust change. No marketing: no launch. No tester at this stage — we'll add when the PR exists.

**Step 3 — Compose.** Brief each role through `multi-role-review`. Designer scope: "Map the states for the duplicate-then-edit flow given the constraint of no new visual components." Engineer scope: "Can this ship before the refactor lands without paying interest twice?"

**Step 4 — Synthesise.** Designer finds two viable patterns reusing existing components; the lighter one matches CS-ticket language. Engineer finds the feature is 2 days of work *if* it lands before the refactor's last commit (in 6 days); 2 weeks of work afterward. PM frames: "Decision is whether to slot 2 days into the current sprint or wait a quarter."

**Step 5 — Recommendation:**

```
Recommendation: Slot the duplicate-cohort feature into the current sprint
using the lighter UI pattern (re-uses Cohort Card component); ship before
the refactor's last commit on 2026-05-26.

We are NOT: holding for the post-refactor implementation (would pay
the 5x cost and miss the cohort-creation Q2 outcome).

Outcomes we'll watch:
- Time-to-second-analysis: halves within 30 days post-ship
- "Duplicate cohort" support tickets: drop ≥80% in 30 days
- Weekly cohort-creation rate: +15% trend by end of Q3

Revisit condition: If by 2026-06-15 the duplicate-feature usage is <10%
of cohort-creation events, we re-investigate whether duplicate was the
actual job (vs. fork-with-annotations).

Owners:
- engineering lead: lands the change in the current sprint
- design: confirms the lighter pattern in the design review skill
- PM: writes the rollout note + adds the outcome dashboard widget
```

What makes this good: the question got framed as a job; the role mix was justified per-role; the synthesis names the single decision (sprint slot vs. quarter wait); the alternative is explicit; the revisit condition is a specific signal.

### Example 2 — "Plan the LedgerStack v2 launch" (good, larger)

PM receives: "Plan the LedgerStack v2 launch — payments migration, new dashboard, pricing change. Cut Tuesday."

**Step 1 — Frame.** Customer job: *Existing customers want to migrate to v2 without losing trust in their billing accuracy, and prospects need to understand why v2 exists and which pricing tier fits them.* Outcomes: migration-completion ≥95% for existing customers in first 30 days; v2 sign-ups ≥150% of v1 monthly run rate; trust-NPS no worse than -2 points vs. pre-migration. Constraints: pricing change is announced; Tuesday cut; ops team's queue is full.

**Step 2 — Triage.** marketing-expert (positioning + launch brief); tester (pre-release pass on migration + dashboard); security-expert (pre-launch audit on payments swap); product-manager-self (orchestration + synthesis). 4 roles — at the upper bound of this skill. Designer is not added because the UI changes are surfaced through the dashboard, which is already through `design-review`; that's a separate workflow that's already run.

**Step 3 — Compose.** Invoke `multi-role-review` with the three pre-launch sibling workflows in parallel: marketing runs `pre-launch-marketing-audit`, tester runs `pre-release-test-pass`, security runs `pre-launch-security-audit`. PM provides each with the framed job and the outcomes.

**Step 4 — Synthesise.** Marketing flags positioning misalignment for the mid-tier (the brief says "for growing teams" but the pricing implies "for established teams" — a known buyer-confusion problem). Tester flags 2 blockers (refund-email regression + order-detail data loss). Security flags 1 warning (KWD rounding direction, small audience). PM frames: "Decision is whether to ship Tuesday as scheduled with positioning-tier fix, or HOLD until next cut for tester blockers; security is acceptable as warning."

**Step 5 — Recommendation:**

```
Recommendation: HOLD the Tuesday cut; ship the following Tuesday after
BUG-1302 and BUG-1305 are merged and the tester suite re-runs green.
Marketing fixes the mid-tier positioning copy in the homepage hero and
sales deck before re-cut. Security warning is tracked, not blocking.

We are NOT: shipping Tuesday with feature-flagged blockers (option
considered; rejected because BUG-1305 is visible on the v1→v2 migration
itself — flagging would mean a partial migration UX).

Outcomes we'll watch (post next-Tuesday ship):
- Migration completion ≥95% in 30 days
- v2 sign-ups ≥150% of v1 monthly run rate in 14 days
- Trust-NPS within ±2 points of pre-migration

Revisit condition: If migration completion is <70% by day 14, we pause
new-customer v2 onboarding and run a discovery pass to identify the
hold-up.

Owners:
- engineering lead: BUG-1302 + 1305 merged + re-run by Monday
- CMO: mid-tier positioning copy refresh in homepage + deck by Monday
- security: tracks KWD rounding for finance sign-off post-launch
- PM: drafts the customer migration email; writes the rollout note
```

What makes this good: the orchestrator did not declare GO/HOLD by counting votes; it weighed findings against the customer-job frame and named the single decision. The recommendation is decision-shaped, not summary-shaped.

### Example 3 — Failure mode (bad)

```markdown
# Cross-functional review — Q3 roadmap

We ran a multi-role review with all 7 roles. Findings below from each
team, then a list of considerations and risks.

[7 sections of role findings copied verbatim]

Recommendation: The team should align on priorities before committing.
```

Failures: no framed customer job; all 7 roles dispatched (no triage); synthesis is relay (findings copied verbatim); recommendation is theatre ("align on priorities"); no decision, no alternative, no outcomes, no revisit condition. This is a meeting transcript pretending to be orchestration.

## Common Pitfalls

### Pitfall 1 — PM as adjudicator

**Symptom:** PM overrides engineering's feasibility call or design's pattern recommendation because they "have product judgement."

**Consequence:** Specialists disengage; future role reviews get formulaic; the PM accumulates technical debt they'll get blamed for later.

**Fix:** Cagan's integrator framing. The PM holds the *whole* — they don't out-specialise the specialists. If you disagree with a role's finding, escalate explicitly ("I think this conflicts with X; can we discuss?") rather than overruling silently.

### Pitfall 2 — Triage by inclusion

**Symptom:** Every cross-functional ask gets all 7 roles "just to be safe."

**Consequence:** Synthesis cost blows up; the meeting widens; specialists feel their time is being wasted; the decision-quality of the output drops because the PM can't hold 7 lenses simultaneously.

**Fix:** Per-role justification at Step 2. If you can't say what a role *uniquely* surfaces, the role doesn't go in. Strict cap of 5 in this skill; if 6+ are genuinely needed, you're orchestrating a launch — compose with the pre-launch sibling workflows.

### Pitfall 3 — Synthesis-as-relay

**Symptom:** The synthesis section is each role's findings concatenated, in role order, with no integration.

**Consequence:** Stakeholders read 7 sections and can't tell what to do. The PM's value-add disappears; orchestration becomes a Google Doc with seven heads.

**Fix:** Synthesis maps each finding to the customer-job frame, identifies the single forcing decision, and names the alternative. If the synthesis is shorter than the inputs, you're doing it right.

### Pitfall 3b — Citation washout in synthesis

**Symptom:** The synthesis names findings, owners, and decisions but contains zero named sources, frameworks, or expert citations — even when the underlying sibling readouts cited extensively.

**Consequence:** The decision becomes unreviewable after the meeting. A stakeholder reading the synthesis a quarter later can't tell whether the security claim is grounded in OWASP, the measurement claim in Kohavi, the positioning claim in Dunford — or whether the PM just asserted them. The orchestration loses its expert grounding the moment the PM writes it up.

**Origin:** This pitfall was identified by the v0 eval pilot (`evals/PILOT-REPORT.md` task 04: source_citation_rate dropped to 0.0 while every other dimension scored 1.0). The decision-shape compression that makes PM-orchestrator synthesis valuable also collapses the citation trail unless the synthesis explicitly carries citations forward.

**Fix:** Step 4 requirement 5 (carry citations forward) and the "Grounding" line in the decision-recommendation template. Rule of thumb: at least one named source per sibling, either inline in the synthesis paragraph or in the Grounding line at the foot of the recommendation. If you cannot name a source for a sibling's load-bearing finding, that sibling's review didn't ground its finding adequately — go back to the sibling, don't paper over the gap.

### Pitfall 4 — Skipping the framing step

**Symptom:** PM jumps from the prompt straight to dispatching roles; the framing-as-customer-job step is skipped.

**Consequence:** Roles each interpret the prompt differently; findings don't compose; synthesis devolves into "what were we even deciding?"

**Fix:** Step 1 is non-negotiable. The framed job is the shared context every role subagent receives. If you can't write the job in one sentence, the work isn't ready to orchestrate.

### Pitfall 5 — Decision avoidance

**Symptom:** Recommendation is "investigate further," "align the team," "consider options," indefinitely.

**Consequence:** The orchestration produces no decision; the team escalates to the next forum; the PM's authority erodes.

**Fix:** Doshi's decision-quality discipline — a high-quality decision can be wrong but it must be a decision. If you genuinely can't decide, name the *missing evidence* required and the *deadline by which it arrives*. "We will decide on 2026-05-20 once <signal> is in." A scheduled decision is a decision.

### Pitfall 6 — PM as the only orchestrator

**Symptom:** Every cross-functional ask, regardless of nature, gets routed through this skill.

**Consequence:** Technical-only work gets framed in customer-job language when it shouldn't (a refactor's integrating thread is technical risk, not user job); security-only work gets a product gloss that obscures the threat surface.

**Fix:** This skill is one orchestrator pattern, not the orchestrator pattern. Route technical migrations to an engineer-led orchestration; route incident retrospectives to a security/SRE-led orchestration. PM-orchestration fits when the integrating thread is the customer job.

### Pitfall 7 — No revisit condition

**Symptom:** Recommendation has outcomes but no revisit condition. "We'll see how it goes."

**Consequence:** Decisions never get revisited; bad calls compound silently; the team loses ability to assess decision quality independent of outcome.

**Fix:** Heath brothers' "prepare to be wrong" → operationalised as "we revisit when X." X must be a concrete signal, not a date. ("If migration completion is <70% by day 14" beats "Q3 retro.")

### Pitfall 8 — Orchestrator-as-tribute

**Symptom:** The skill is invoked ceremonially on small decisions ("should we move this button left or right?") because it feels professional.

**Consequence:** Heavyweight orchestration cost on lightweight decisions; team learns to dread cross-functional reviews; the practice gets diluted.

**Fix:** Trigger gate at the top of Step 1: if the decision can be made by one role in 30 minutes, this skill is overkill. Use the role's component skill directly or the role's reviewer mode. Reserve this skill for decisions where the *integrating thread* is genuinely cross-functional.

## References

- **Marty Cagan** — *Inspired* (2008, rev. 2017); *Empowered* (2020, with Chris Jones). PM as integrator at Tech / Business / UX; the four big risks; the minimum-team-that-can-decide discipline. See `roles/product-manager/sources.md`.
- **Martin Eriksson** — The PM Venn diagram (Tech / Business / UX); *Product Leadership* (2017). The integrator role definition that traveled the industry.
- **Clayton Christensen, Karen Dillon, Taddy Hall, David Duncan** — *Competing Against Luck* (2016); Jobs-to-be-Done as the framing primitive for product work.
- **Bob Moesta** — *Demand-Side Sales* (2020); the switch-interview technique behind JTBD evidence-gathering used in framing.
- **Christina Wodtke** — *Radical Focus* (2016, rev. 2021); outcomes over outputs; OKR practice underpinning the "outcomes we'll watch" section.
- **Melissa Perri** — *Escaping the Build Trap* (2018); the build-trap diagnosis that the framing step protects against.
- **Shreyas Doshi** — High-quality-decisions framing; decision quality vs. outcome quality. The discipline behind recording reasoning + revisit condition.
- **Chip Heath & Dan Heath** — *Decisive: How to Make Better Choices in Life and Work* (2013); WRAP framework (Widen options, Reality-test, Attain distance, Prepare to be wrong). The recommendation shape encodes WRAP.
- **Teresa Torres** — *Continuous Discovery Habits* (2021); Opportunity Solution Tree; open questions feed the OST rather than being closed by the orchestration.
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system); orchestrator-worker, detailed delegation, parallel-first, artifact passing. This skill consumes that protocol via `multi-role-review`.
- **Related Hornero skills:**
  - [`skills/multi-role-review`](../../../../skills/multi-role-review/SKILL.md) — the orchestration mechanism this skill composes with PM framing.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — the framing primitive used in Step 1.
  - [`prd`](../prd/SKILL.md) — when the orchestration's decision triggers a PRD, this skill hands off there.
  - [`okrs`](../okrs/SKILL.md) — the "outcomes we'll watch" line ties to the OKR frame when one exists.
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — when framing reveals the job is unclear, route to discovery before orchestrating.
  - `roles/marketing-expert/skills/pre-launch-marketing-audit/SKILL.md`, `roles/tester/skills/pre-release-test-pass/SKILL.md`, `roles/security-expert/skills/pre-launch-security-audit/SKILL.md` — when orchestrating a launch, these are the sibling workflows the role subagents typically invoke.
