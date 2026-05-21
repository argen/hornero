# Use cases — how to get the most out of Hornero

> Six common PM workflows, each showing which skills to sequence, what to feed each one, and what ends up in the chronicle. Read [`examples/sample-session.md`](sample-session.md) for a single-skill annotated example; read [`examples/week-with-hornero.md`](week-with-hornero.md) for a five-day narrative. This guide focuses on **multi-skill sequences** — the workflows that compound.

---

## How to read these

Each workflow shows:

- **When to use** — the trigger situation
- **Skills in sequence** — ordered steps with what each step produces
- **What persists** — what ends up in the chronicle after the workflow completes
- **Example prompts** — the actual words you'd type
- **Notes** — edge cases and common variations

Skill names in `backtick format` are matchable by the dispatcher; you don't need to name them explicitly. The prompts below show natural-language form — just describe what you're doing.

---

## Workflow 1 — Discovery interview cycle

**When to use:** you have customer interviews scheduled and want structured evidence, not opinion.

### Skills in sequence

1. `discovery-interview-prep` — produces a tailored interview guide grounded in Torres' continuous-discovery and Moesta's switch-interview technique; interactive (asks what you're trying to learn first)
2. Conduct the interview with the guide
3. `/ingest <transcript>` — preserves the raw transcript under `chronicle/source/` (gitignored), drafts a structured synthesis in `chronicle/ingestion/` (sourcing-tagged observations + implications), and proposes `chronicle.sh propose` commands for the entries the interview informs
4. `interview-synthesis` — after 3+ interviews, produces per-interview snapshots, cross-interview theme rollup, OST updates, and a quote bank

### What persists

- `chronicle/ingestion/<date>-<slug>.md` — synthesis with sourcing-tagged observations
- `chronicle/source/<uuid>.txt` — raw transcript (gitignored, not committed)
- Proposed updates to open `type: hypothesis` entries the interview informs (promoted via `hypothesis-track`)

### Example prompts

```
1. "Prep me for discovery interviews on activation with enterprise users. I'm trying to
   learn why users don't reach the first value moment."

2. "Run /ingest on today's transcript with Aiko." (or paste inline)

3. "Synthesise the three interviews I ingested this week on activation."
```

### Notes

- Run `discovery-interview-prep` once per interview series, not once per interview — the guide adapts to the target segment and question
- After 3+ interviews, `interview-synthesis` is more useful than running it after one; the OST update gains signal only when themes recur
- The sourcing tag on each ingestion observation matters: `[documented]` (transcript exists) vs `[verbal]` (your recall) vs `[intuition]` (your interpretation) — these affect which chronicle entries the observation can promote

---

## Workflow 2 — Strategy kernel review

**When to use:** before quarterly planning, before a big roadmap call, or when the team is debating "what are we even trying to do?"

### Skills in sequence

1. `problem-framing-canvas` — interactive; produces a structured problem statement (who has it, what triggers it, what happens if unsolved, what alternatives exist) before any strategy document is written
2. `strategy-kernel` — critiques or produces a strategy artifact using Rumelt's diagnosis → guiding policy → coherent actions structure; surfaces whether the "strategy" is actually a list of independent initiatives
3. `bet-portfolio` — makes implicit bets explicit: 3–7 bets, each with assumption, evidence weight, kill criterion, and revisit cadence
4. `chronicle-record` → `chronicle.sh propose` → human commit — records the strategy decision with alternatives-rejected and validation plan

### What persists

- `chronicle/entries/<date>-<slug>.md` of `type: decision` — the strategy decision with `scope: [strategy]`, alternatives rejected, and `review_after` date

### Example prompts

```
1. "Frame the core problem with activation before we write the Q3 strategy."

2. "Write a strategy kernel for the Q3 activation initiative. Our central obstacle is
   that 60% of signups never reach the first value moment within 7 days."

3. "Make the implicit bets in this strategy explicit — what are we assuming is true?"

4. "Record this as a strategy decision in the chronicle."
```

### Notes

- `strategy-kernel` is most useful as a *critic* of an existing draft — paste in the current strategy doc and ask for a Rumelt-lens review
- `bet-portfolio` is a follow-on, not a prerequisite — run it after the kernel to check whether the coherent actions imply undisclosed assumptions
- If the strategy touches multiple roles (finance, engineering, marketing), consider `/orchestrate` instead of single-PM dispatch — see Workflow 5

---

## Workflow 3 — Launch readiness sweep

**When to use:** a feature or product is 2–4 weeks from launch and you need to know if it's ready.

### Skills in sequence

1. `prd` — critique the spec before it's locked; surfaces solution-shaped thinking, missing counter-metrics, and items that are out-of-scope but load-bearing
2. `press-release` — working-backwards artifact; forces customer-facing language and the "is this worth building?" test early (run this *before* the PRD if the feature is still in discovery)
3. `positioning-statement` — Moore + Dunford template; distinguishes the product from alternatives in one sentence
4. `cross-functional-orchestration` — for a full launch-readiness call, dispatches the PM-orchestrator role (roles: engineer, designer, security, marketing) and synthesises a go/no-go with owned actions

### What persists

- `chronicle/entries/<date>-launch-go-nogo.md` of `type: decision` — launch decision with coherent actions and `review_after` set to post-launch retrospective date

### Example prompts

```
1. "Critique this PRD for the payment revamp. Flag solution-shaped thinking and missing
   counter-metrics." [paste PRD]

2. "Write a working-backwards press release for the new payment experience."

3. "Draft a positioning statement — what's the one sentence that distinguishes this
   from Stripe's standard checkout?"

4. "/orchestrate Is the v2 payment feature ready to ship? Roles: engineer, designer,
   security. Synthesise to a go/no-go with owners."
```

### Notes

- `press-release` is most useful *before* the PRD is written, not after — it prevents solution capture at the spec stage
- If the launch is already locked and you're doing a readiness review, go straight to `cross-functional-orchestration` or `prd` critique
- The go/no-go decision in the chronicle should name the owner, the ship condition, and the roll-back trigger

---

## Workflow 4 — Finance and pricing review

**When to use:** before a board meeting, a CFO review, a pricing change, or whenever you need to be fluent in unit economics without bluffing.

### Skills in sequence

1. `saas-revenue-growth-metrics` — ARR, NRR, GRR, CAC payback, magic number, expansion levers; produces a structured read of top-of-funnel and retention health
2. `saas-economics-efficiency-metrics` — Rule of 40, burn multiple, gross margin, contribution margin; produces a capital-efficiency read
3. `finance-based-pricing-advisor` — sets or evaluates a pricing change using cost-plus, value-based, willingness-to-pay, and margin-floor lenses; interactive
4. `chronicle-record` → commit — records the pricing decision with the finance rationale and alternatives rejected

### What persists

- `chronicle/entries/<date>-pricing-<change>.md` of `type: decision` — pricing decision with `sourcing: documented` (if backed by WTP research) or `sourcing: intuition` (if not)

### Example prompts

```
1. "Walk me through our ARR and NRR story. Our ARR is $3.2M, NRR is 108%, GRR is 91%.
   What's healthy and what's flagged?"

2. "Assess our Rule of 40. Revenue growth is 45%, operating margin is -12%."

3. "We're considering raising enterprise tier pricing from $800/seat to $1,200/seat.
   Evaluate this through the finance-pricing lens."

4. "Record the enterprise pricing decision in the chronicle."
```

### Notes

- Run the metrics skills *before* the pricing advisor — they surface whether you have a revenue-growth or a unit-economics problem (or both), which changes the pricing lever you should pull
- `finance-based-pricing-advisor` is interactive; it will ask for your current WTP data before making a recommendation — if you don't have WTP data, it will flag the sourcing gap
- The `sourcing` field on the chronicle entry matters: a pricing decision resting on `intuition` without WTP data should have `sourcing: intuition` — the `/review` skill will surface it as thin

---

## Workflow 5 — Weekly PM rhythm

**When to use:** every week, as a discipline. The chronicle compounds only when you feed it consistently.

### Monday: situational awareness load

```
"What decisions and open hypotheses are relevant for the activation initiative this week?
 Scope: activation, onboarding."
```

This dispatches `chronicle-recall`, which queries `chronicle/entries/` for entries with matching scope tags and returns the relevant subset — prior decisions, open hypotheses, and any decisions with an overdue `review_after`. Load this before any non-trivial artifact review or proposal.

### During the week: record decisions as they land

```
"Record the decision to defer bulk-export to Q4. Diagnosis: engineering capacity
 is needed for the activation re-work. Alternatives: partial export in Q3 (rejected —
 incomplete feature ships a bad first impression). Revisit: 2026-09-01."
```

This dispatches `chronicle-record`, which drafts a `type: decision` entry and calls `chronicle.sh propose`. You review and commit.

### Friday: chronicle health + harness health

```
"/review"       ← weekly chronicle health sweep (six checks)
"/extract-lesson"  ← harness health (captures lessons from the week into proposals)
```

`/review` surfaces stale hypotheses, overdue decisions, thin sourcing, and scope entropy.
`/extract-lesson` captures surprises and validated approaches from the session as proposals for harness files. Both run in 5 minutes and keep the layers from decaying.

### What persists

- New `type: decision` entries for each non-trivial decision
- Updated hypothesis entries (via `hypothesis-track`) for new evidence
- Harness proposals from `extract-lesson` (human-gated before any file changes)

### Notes

- The Monday load matters most: entering a week without reading prior decisions means you risk re-litigating settled questions
- `chronicle-record` vs `decision-record`: use `chronicle-record` for the strict-schema path (preferred for validated decisions); `decision-record` is the older looser format, writes to `memory/decisions/` rather than `chronicle/entries/`
- `/review` doesn't need to be Friday — run it whenever you notice the chronicle feels stale. But a weekly cadence pairs well with the feedback ritual in [`playbooks/feedback-ritual.md`](../playbooks/feedback-ritual.md)

---

## Workflow 6 — Stakeholder prep and capture

**When to use:** before any important 1:1, design review, vendor call, or QBR where you need to be prepared and want to capture what surfaces.

### Skills in sequence

1. `/prep <person-or-topic>` — loads the matching `type: stakeholder` entry, recent decisions in their scope, open hypotheses they're involved in, and recent ingestion notes; renders a one-page brief with open asks, likely disagreement points, and suggested questions
2. Conduct the meeting
3. `/ingest <notes>` — preserves raw notes, drafts synthesis with sourcing-tagged observations, proposes chronicle updates
4. `stakeholder-update` — appends a dated row to the stakeholder's entry (Open asks, Concerns, Last contact, Decision affinity) via `chronicle.sh append`; does not force a full supersede

### What persists

- `chronicle/entries/<stakeholder-id>.md` → `## Last contact` row updated
- `chronicle/ingestion/<date>-<meeting-notes>.md` — synthesis of meeting notes with sourcing tags
- If a decision surfaced in the meeting: new `type: decision` entry via `chronicle-record`

### Example prompts

```
1. "/prep Maya" (or "/prep CTO 1:1 on API strategy")

2. "Here are the notes from my 1:1 with Maya: [paste notes]"
   or: "/ingest maya-1on1-2026-05-21.md"

3. "Update Maya's stakeholder entry — she's now concerned about the API migration
   timeline and wants a decision by June 1."
```

### Notes

- `/prep <topic>` (not a person) works when you're preparing for a meeting on a theme rather than with a specific person — it queries by scope tags instead of stakeholder entry
- If the meeting produced a new decision (not just an update), run `chronicle-record` after the stakeholder-update
- `stakeholder-update` only appends to whitelisted sections — it can't change the stakeholder's name or role. For structural changes, supersede the entry via `chronicle-record`

---

## Choosing between workflows

| You're trying to... | Start with |
|---|---|
| Learn why customers behave the way they do | Workflow 1 (discovery) |
| Align the team on strategy before planning | Workflow 2 (strategy kernel) |
| Ship a feature | Workflow 3 (launch readiness) |
| Prepare for a finance or board conversation | Workflow 4 (finance review) |
| Maintain decision hygiene week-to-week | Workflow 5 (weekly rhythm) |
| Prepare for or debrief a meeting | Workflow 6 (stakeholder prep) |
| Tackle something that spans multiple concerns | `/orchestrate <task>` → the PM-as-orchestrator pattern |

For anything that spans two or more of these (e.g., a quarterly planning cycle that touches strategy + finance + stakeholder prep), start with `/orchestrate` and let it frame the work as a customer job before dispatching individual roles.
