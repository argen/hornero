---
name: okrs
description: Use to draft or critique quarterly OKRs — Objectives + Key Results — grounded in Christina Wodtke's radical-focus methodology.
intent: |
  Produces or evaluates a set of OKRs that actually drive focus rather
  than performing planning theatre. Most teams' OKRs are too many, too
  vague, or too output-oriented. This skill catches those failure modes.
type: component
theme: strategy
best_for:
  - Drafting OKRs for a team or product line for a coming quarter
  - Critiquing OKRs that feel uninformative or unactionable
  - Mid-quarter re-evaluation when an OKR is clearly not going to be met
scenarios:
  - "PM setting team OKRs for Q2"
  - "Leadership review of cross-team OKR alignment"
  - "Diagnosing why last quarter's OKRs didn't drive decision-making"
estimated_time: 60-120 minutes (collaborative draft); 15 minutes (critique)
---

# OKRs — Objectives and Key Results

> v0 draft. Grounded in Wodtke's *Radical Focus*; tempered by Doshi's commentary on OKR failure modes. Editorial review recommended.

## Purpose

Produce OKRs that drive focus. The artifact's job is to make some work obviously prioritized and other work obviously deprioritized. OKRs that produce neither effect are vanity.

The skill is a critique-oriented one: it's easier to identify why an OKR set is bad than to write a good one from scratch, but practice with the diagnostic surfaces the right questions during drafting.

## Key Concepts

### Radical focus (Wodtke)

Christina Wodtke (*Radical Focus*): the point of OKRs is *radical focus*. A team that adopts OKRs and emerges with five Objectives and twenty Key Results has missed the point entirely.

Rules of thumb:

- **1 Objective per team per quarter.** Maybe two if the team is large or split.
- **3 Key Results per Objective.** Maximum. Three is already pushing it.
- **The Key Results are outcomes, not outputs.** "Ship feature X" is not a KR; "Reduce checkout abandonment from 18% to 12%" is.
- **Aim for ambitious.** A team that meets 100% of its OKRs every quarter is sandbagging. ~70% completion is the canonical "stretch goal" zone.

### Objective vs Key Result

**Objective.** Qualitative, inspirational, time-bound. "Make checkout the fastest in our category by EOQ." The objective answers "where are we going?"

**Key Result.** Quantitative, measurable, outcome-based. "Reduce checkout abandonment from 18% to 12%." The KR answers "how will we know we got there?"

A common confusion: stating Objectives quantitatively. "Reduce checkout abandonment to 12%" *as an Objective* is actually a Key Result without an Objective; the Objective ("Make checkout fast") is missing.

### Doshi's failure modes

Shreyas Doshi: OKRs frequently fail because:

1. **Objectives are output-shaped.** "Ship the new checkout flow." This is roadmap-pretending-to-be-OKR.
2. **Key Results are vanity metrics.** "Achieve 1M monthly active users." If hitting it doesn't change a downstream decision, it's vanity.
3. **OKRs are non-aspirational.** Set to "achievable in 3 weeks" because the team learned that missing OKRs is penalized.
4. **OKRs are not connected to strategy.** Each team optimizes locally; the company doesn't move.
5. **OKRs are reviewed annually, not weekly.** No mid-flight correction; OKRs become an end-of-quarter narrative exercise.

### The bench test

For each proposed Key Result, ask: "If we hit this number exactly, would we know whether the Objective is met?" If unsure, the KR doesn't measure what it claims to measure. If hitting it but not the Objective is plausible, the KR is a proxy and probably a bad one.

## Application

### Step 1 — Identify the Objective

Start with the question: "What is the one most-important thing for this team to do this quarter?"

Two tests for the Objective:

- **Specificity test.** It is recognizable to someone outside the team within 30 seconds.
- **Aspirationality test.** A team member's reaction is "we're not sure we can pull this off." If their reaction is "we'll probably hit that by April," it's too easy.

Capped at 1, maybe 2 Objectives total. If the team has more, ask what gets *deprioritized* to make room.

### Step 2 — Identify the 3 Key Results

Each KR must:

- Be a number (or a binary observable; "ship X" only acceptable when X is a discrete external signal, not "did we work on X").
- Be measurable today (baseline established, data source identified).
- Be directionally clear (up is good, or down is good — pick one).
- Be outcome-oriented (movement in user/business behavior or business state, not work completion).
- Survive the bench test.

If a Key Result is "ship feature X by date Y," it's a milestone, not a KR. Milestones go in a roadmap; not all milestones map to KRs.

### Step 3 — Apply diagnostic checks

Before finalizing:

1. **Count check.** ≤2 Objectives total. ≤3 KRs per Objective. If you can't get under the cap, prioritization isn't done yet.
2. **Output-vs-outcome check.** Each KR is a state-of-the-world change, not a piece of work shipped.
3. **Strategy-link check.** Each Objective connects to a company- or product-level strategy. If the Objective is detached, the team is optimizing locally.
4. **Aspirationality check.** Each KR target is ambitious enough that the team is genuinely uncertain.
5. **Bench test.** Each KR, hit exactly, would tell you about the Objective.
6. **Cadence check.** There is a weekly OKR check-in scheduled. (Without it, OKRs decay; the cadence is the discipline.)

### Step 4 — Draft a check-in cadence

Per Wodtke: weekly 15-minute check-ins on:
- Confidence on each KR (low / medium / high) — gut score, no need to defend.
- Priorities this week (3 things, max).
- Health metrics: anything trending the wrong way that's not in the OKRs but matters.

The check-in is the OKR's life support. Without it, OKRs become end-of-quarter theatre.

## Examples

### Example 1 — Good OKR set

```markdown
# Q2 OKRs — Checkout Team

**Objective.** Make checkout the fastest experience in our category.

**Key Results.**
- KR1: Reduce median time-from-cart-to-confirmation from 92s to ≤45s
- KR2: Reduce checkout abandonment rate from 18% to ≤12%
- KR3: Reach top-quartile on independent industry checkout-speed survey
  (Forrester Q3 publication; baseline TBD when published)
```

**Why this works:**
- 1 Objective. Specific, recognizable.
- 3 KRs. All outcomes (time, abandonment rate, external ranking).
- Bench test: hitting all three implies the Objective. Hitting KR1+KR2 without KR3 means we got faster but didn't establish category leadership; flag for review.
- Aspirational: halving median time and reducing abandonment by ~33% is genuinely uncertain.

### Example 2 — Bad OKR set (failure)

```markdown
# Q2 OKRs — Checkout Team

**Objectives.**
1. Ship the new checkout flow
2. Improve performance
3. Better mobile experience
4. Increase conversion
5. Launch promotions feature

**Key Results.** [scattered across objectives, 7 total]
- Build 3 promotional templates
- Reduce JS bundle by 20%
- Migrate to new payment provider
- Increase NPS by 5 points
- ...
```

**Failures:**
- 5 Objectives — no focus.
- Objectives are output-shaped ("ship," "launch," "build").
- KRs are mostly outputs (build templates, migrate provider) rather than outcomes.
- NPS as KR is a vanity metric without a specific decision attached.
- No connection between any KR and the relevant Objective.

This is a roadmap with OKR vocabulary, not OKRs.

## Common Pitfalls

### Pitfall 1 — Too many Objectives

**Symptom:** 5+ Objectives per team per quarter.

**Consequence:** Nothing is deprioritized; the team continues to do everything; OKRs become a list of intentions.

**Fix:** Force ranking. If everything is "Objective 1," nothing is. Hard cap at 2.

### Pitfall 2 — Output-shaped Objectives or KRs

**Symptom:** "Ship X" / "Launch Y" / "Build Z."

**Consequence:** Team can complete the work without moving any meaningful outcome.

**Fix:** Reframe as the outcome the work is supposed to produce. "Ship X" → "Cause behavior change Y that shipping X is supposed to enable."

### Pitfall 3 — Sandbagging

**Symptom:** Team meets 100% of OKRs every quarter; nobody is surprised by any outcome.

**Consequence:** OKRs become commitment-protection, not strategy. Real ambition lives elsewhere (or doesn't).

**Fix:** Wodtke's stretch principle. Aim for ~70% completion as the target. Reward learning from misses; punish sandbagging more than missing.

### Pitfall 4 — Missing check-in cadence

**Symptom:** OKRs set in March; reviewed in June; nobody touched them in between.

**Consequence:** Drift, mid-quarter pivots that bypass OKRs, end-of-quarter narrative-writing to make the OKRs "succeed."

**Fix:** Weekly 15-minute check-in is the discipline. Wodtke: "the cadence is the OKR."

### Pitfall 5 — Local optimization

**Symptom:** Each team's OKRs make sense in isolation; collectively, the company doesn't move on any goal.

**Consequence:** Effort spent on locally-rational work that doesn't add up to company progress.

**Fix:** Step 3 strategy-link check. Each team-level Objective is downstream of a company-level Objective. If not, the team is rowing its own boat.

### Pitfall 6 — Vanity Key Results

**Symptom:** KRs are big-sounding numbers (MAU, signups, page views) disconnected from any decision.

**Consequence:** Team optimizes the number; the number rises; nothing important changes.

**Fix:** Bench test. If hitting the KR exactly would not change any downstream decision, the KR is vanity. Replace with one tied to a real decision.

## References

- **Christina Wodtke** — *Radical Focus* (2016, rev. 2021); the canonical practitioner reference.
- **John Doerr** — *Measure What Matters* (2018); the Google-evangelist view of OKRs (less surgical than Wodtke).
- **Shreyas Doshi** — public commentary on OKR failure modes.
- **Itamar Gilad** — *Evidence-Guided*; aligns OKRs with evidence-weighted decision-making.
- **Andy Grove** — *High Output Management* (1983); OKR origin at Intel.
- **Related Hornero skills:**
  - `roles/product-manager/skills/prd/SKILL.md` — PRDs are typically downstream of OKRs (OKR → opportunity → feature → PRD).
  - `roles/product-manager/skills/jobs-to-be-done/SKILL.md` — JTBD informs the customer / outcome side of Objectives.
