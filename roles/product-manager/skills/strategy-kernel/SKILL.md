---
name: strategy-kernel
description: Use when a PM needs to produce or critique a strategy artifact — to name the central obstacle (diagnosis), articulate the posture for overcoming it (guiding policy), and confirm the actions reinforce each other rather than sitting as an independent initiative list (coherent actions).
intent: |
  Produces a Rumelt-style three-part strategy kernel: a named diagnosis of the
  crux, a guiding policy that channels effort against that diagnosis, and a set
  of coherent actions whose reinforcing structure is what makes the kernel more
  than a list of initiatives. The artifact is posture-shaped, not feature-shaped
  or goal-shaped — it names which game the team is playing and which games it is
  refusing to play across a multi-quarter horizon.
type: component
theme: strategy
best_for:
  - When a PM or leadership team needs to answer "what is our strategy" and the current answer is a goal list or a set of parallel initiatives
  - Before a bet-portfolio exercise — the kernel is the frame that makes bets legible
  - When competitive pressure has intensified and the team is adding initiatives rather than concentrating them
  - When a new PM inherits a roadmap and needs to understand whether a coherent strategy underlies it
  - When a strategy doc exists but a Rumelt-diagnosis test reveals it contains no diagnosis
scenarios:
  - "We keep shipping features but market share isn't moving — write the strategy kernel before Q3 planning"
  - "The roadmap has 11 initiatives and everything is high priority — is this a strategy?"
  - "New PM joining a fintech product — what's the strategy, and is it a real strategy or a goal list?"
  - "Leadership wants a strategy for the enterprise segment expansion — produce the kernel"
estimated_time: 60-120 minutes (with access to diagnosis inputs); 30-45 minutes (kernel drafting once diagnosis is clear)
---

# Strategy kernel

> v0 draft. Anchored in Richard Rumelt (*Good Strategy / Bad Strategy*, 2011; *The Crux*, 2022) as the primary framework. Cagan's four risks (*Inspired*, *Empowered*) as the structured input to diagnosis. Perri (*Escaping the Build Trap*) as the org-architecture overlay. Editorial review recommended before production use.

## Purpose

Produce a three-part strategy kernel: diagnosis, guiding policy, and coherent actions.

The kernel is the minimum viable strategy artifact — not a plan, not a goal list, not a vision statement. It is an answer to three questions that cannot be answered generically: What is the actual obstacle? What is our posture for overcoming it? What specific, reinforcing actions operationalise that posture?

Distinct from the PRD: a PRD is feature-shaped (what to build, why, how we'll know it works). The PRD operationalises one coherent action into a buildable specification; the kernel tells you which PRDs are worth writing.

Distinct from OKRs: OKRs name what to move and by how much. The kernel tells you *why* those specific metrics, in those specific proportions, are the right game to play. Without a kernel, OKRs are well-formatted guesses.

Distinct from cross-functional orchestration: orchestration shapes a specific decision under time pressure. The kernel is the multi-quarter posture that makes individual decisions legible. Orchestration consumes the kernel; it does not produce one.

The output is typically 1-2 pages: a named diagnosis, a guiding-policy paragraph, and 4-6 coherent action statements with explicit descriptions of how each reinforces the others.

## Key Concepts

### The kernel itself (Rumelt)

Rumelt (*Good Strategy / Bad Strategy*, ch. 1-2) identifies three components that together constitute a real strategy. Each is non-substitutable:

- **Diagnosis** — names the crux of the situation, simplified to its essential challenge. Not a list of problems; a single named obstacle that, if overcome, changes the game. Rumelt: "A good diagnosis defines or explains the nature of the challenge."
- **Guiding policy** — the overall approach for dealing with the challenge named in the diagnosis. Not a goal or a target; a *posture* that channels and concentrates effort. Rumelt: "Like the guardrails on a highway, the guiding policy does not tell you where to go, but it does define and constrain the manner in which you can move."
- **Coherent actions** — specific resource-allocation steps that operationalise the guiding policy. The defining property of coherent actions is that they *reinforce each other*. A list of initiatives where each item is independent is not coherent actions; it is a task list.

All three components must be present for the artifact to qualify as a strategy kernel. A document with only a guiding policy and no diagnosis is a philosophy. A document with only coherent actions and no guiding policy is a project plan. A document with diagnosis and actions but no guiding policy has no mechanism for deciding which actions to keep when resources are constrained.

### Rumelt's bad-strategy diagnostics

Rumelt dedicates chapters 3-4 of *Good Strategy / Bad Strategy* to bad strategy — a distinct category of artifact, not a minor defect of good strategy. Bad strategy exhibits one or more of these patterns:

- **Fluff** — abstract restatement of the obvious dressed in jargon. Identifying the problem as "we need to better align our go-to-market motion with the evolving expectations of enterprise buyers" sounds strategic but is non-diagnostic — it names no specific obstacle, no crux.
- **Failure to face the challenge** — the diagnosis is either missing or written to avoid naming the uncomfortable obstacle. A real diagnosis names something specific and often implies painful trade-offs.
- **Mistaking goals for strategy** — the most common failure mode in product contexts. "Double ARR," "become the market leader in SMB," "achieve a 4.8 App Store rating" are goals, not strategies. They name destinations without naming the obstacle or the approach.
- **Blue-sky objectives** — long lists of aspirations with no plan, no concentration of resources, no acknowledgment of constraint. The tell: every item on the list is desirable, and none of them are in tension with each other.

A strategy artifact that contains none of the kernel components and exhibits one or more of these patterns is bad strategy. Recognising bad strategy is as important as producing good strategy — many PM strategy docs are bad strategy dressed in slides.

### Diagnosis as the load-bearing step

Most strategy work skips or weakens the diagnosis. The guiding policy is drafted directly from a vague sense of the situation, producing a policy that could apply to any company in the category. The actions follow from the generic policy and are therefore uncoordinated.

Rumelt (*The Crux*, ch. 1-3) frames the diagnosis as the hardest and most valuable part of strategy work — the "crux" of the crux-finding process. A good diagnosis does three things: it simplifies a complex situation to its essential shape, it names the one or two factors whose resolution would change the game, and it implies trade-offs (by naming the crux, it implicitly deprioritises every other concern).

The diagnostic work cannot be replaced by data collection. Data informs diagnosis; it does not produce it. The diagnosis is a judgment about which data is load-bearing.

### Coherence of actions (Rumelt)

Rumelt's specific test for coherent actions: do the actions *reinforce each other*, or are they independent initiatives accidentally grouped under a shared heading?

Coherent actions produce compound effect — each action makes the other actions more effective. The guiding policy for "compress time-to-first-value" produces coherent actions when every action either removes a step from the onboarding path, increases the velocity of the remaining steps, or reduces the cost of abandonment. An action that does none of those things — even if desirable — is not a coherent action under that guiding policy; it is a separate initiative that should either be scheduled separately or dropped.

Coherence is what distinguishes a strategy from a portfolio of good ideas. A portfolio of good ideas is manageable; a strategy is concentrating.

### Cagan's four risks as the input to diagnosis (Cagan)

Cagan (*Inspired*, *Empowered*) defines the four risks that product work must address: value (will customers want this?), usability (can they use it?), feasibility (can the team build it within constraints?), and business viability (does it work for the business?).

The four risks are useful as a structured diagnostic input. The kernel's diagnosis should answer which of these is the *binding constraint* — the one risk whose resolution unlocks the others. A team whose binding constraint is value risk (customers don't believe the product solves a real problem) has a different diagnosis from a team whose binding constraint is business viability risk (the unit economics don't close at current scale).

Stress-testing the diagnosis against all four risks catches the common error of diagnosing a visible symptom (e.g. high churn) rather than the underlying binding constraint (e.g. the sales motion is onboarding the wrong customer segment, creating an inevitable mismatch between expectation and product).

### Perri's org-architecture overlay (Perri)

Perri (*Escaping the Build Trap*) identifies the structural conditions under which teams slip from strategy into feature factories: no coherent product strategy connecting team-level work to portfolio-level goals, so teams fill the vacuum with output metrics and initiative lists.

The team-level kernel must connect to a portfolio-level strategy. An orphan kernel — one where the team has a coherent guiding policy but the portfolio has no corresponding posture — will be eroded by the next planning cycle's initiative list. The connection check: can the team's kernel be traced to a guiding policy at the portfolio or company level? If not, the kernel is at risk of being treated as a commitment rather than a concentrating device.

## Application

Eight steps; PM time 60-120 minutes for a full first pass. Diagnosis (steps 1-3) is the work; drafting (steps 4-8) is relatively fast once diagnosis is clear.

### Step 1 — Name the strategic question (5-10 minutes)

Write the question the kernel must answer in one sentence, including the time horizon. "How do we reduce 60-day churn among SMB customers from 40% to ≤15% in the next three quarters?" beats "What is our growth strategy?" The strategic question scopes the diagnosis; a kernel that answers the right question for the wrong time horizon is not useful.

### Step 2 — Diagnose the crux (20-40 minutes)

Identify the one or two essential challenges whose resolution would change the answer to the strategic question. Ground the diagnosis in evidence — customer interviews, usage data, support tickets, unit economics — then simplify: what is the load-bearing factor? Apply Rumelt's test: if you overcame this one obstacle, would the strategic question answer itself? If yes, it is a candidate diagnosis. If not, you have named a symptom, not a crux. Write the diagnosis in 2-4 sentences, specific and falsifiable.

### Step 3 — Stress-test the diagnosis against the four risks (10-15 minutes)

For each of Cagan's four risks, ask: is this risk the binding constraint?

- **Value risk** — do customers not want this enough to change behavior?
- **Usability risk** — do customers want it but can't use it effectively?
- **Feasibility risk** — does the team lack the capability or capacity to deliver?
- **Business viability risk** — does the unit economics or business model prevent sustainable delivery?

The binding constraint is the risk that, if resolved, would unlock the others. If your initial diagnosis points to feasibility but the stress-test reveals the actual binding constraint is value risk, revise the diagnosis before proceeding. A guiding policy built on the wrong diagnosis will concentrate effort on the wrong obstacle.

### Step 4 — Draft the guiding policy (15-20 minutes)

Write the posture that channels effort against the diagnosis. The guiding policy is not a goal — it does not say "we will grow to X." It says "we will do Y rather than Z, because the diagnosis tells us Y is the concentrating move." It must contain at least one explicit trade-off: what are you *not* doing or accepting less of in order to concentrate here?

Good: "Compress time-to-first-verified-transaction to under 24 hours by re-architecting around customer-provided KYC data rather than internally-run verification — accepting reduced fraud-signal fidelity in exchange for activation speed."

Weak: "Improve the onboarding experience to drive better activation."

### Step 5 — Enumerate candidate actions; name how each reinforces the others (15-20 minutes)

List 5-8 candidate actions. For each, write one sentence describing how it reinforces the *other* actions — not just how it serves the guiding policy independently. An action that cannot reinforce any of the others is either a separate initiative (schedule it separately) or noise (drop it). Narrow to 4-6 with the strongest mutual reinforcement.

### Step 6 — Apply the bad-strategy diagnostics (10 minutes)

Before committing to a draft, apply Rumelt's diagnostic checklist to what you have:

- **Fluff check.** Read the diagnosis aloud. Does it name a specific obstacle, or is it jargon that could apply to any company in the category? Rewrite until the diagnosis names something specific.
- **Goal-list check.** Is the guiding policy actually a goal ("achieve X")? Or is it a posture ("do Y rather than Z")? Rewrite if it's a goal.
- **Challenge-facing check.** Does the diagnosis name the uncomfortable truth, or does it name a comfortable restatement of the strategy the team already wanted to pursue? If uncomfortable, it is probably real. If comfortable, it is probably fluff.
- **Blue-sky check.** Are all the coherent actions desirable and non-competing? If so, they are not coherent actions — they are aspirations. Coherent actions under a real guiding policy create tension (some things are deprioritised).

### Step 7 — Sanity-check coherence (5-10 minutes)

Can you describe in plain language why action B makes action A more effective, and why action C makes both A and B more effective? If the reinforcement chain breaks, the actions are not coherent under this guiding policy. Cross-functional input is required: engineering confirms feasibility coherence; design confirms usability coherence. A kernel without cross-functional review on step 7 should be marked as a hypothesis pending review.

### Step 8 — Write the kernel (15-30 minutes)

Produce the artifact in this shape:

```markdown
# Strategy kernel — <product / scope / horizon>

**Strategic question:** <one sentence>

## Diagnosis
<2-4 sentences. The named crux. Specific, falsifiable, evidence-grounded.>

## Guiding policy
<1-3 sentences. The posture. Includes an explicit trade-off.>

## Coherent actions
1. **<action name>** — <what it does and how it reinforces the other actions>
2. **<action name>** — <what it does and how it reinforces the other actions>
3. **<action name>** — <what it does and how it reinforces the other actions>
4. **<action name>** — <what it does and how it reinforces the other actions>
[4-6 total]

## Binding constraint
<Which of Cagan's four risks is the primary binding constraint? One sentence.>

## What we are not doing
<1-3 items explicitly deprioritised. Coherent actions imply deprioritisation;
name it so the team can hold the line.>
```

## Examples

### Example 1 — B2B fintech onboarding (worked kernel)

**Context.** A B2B fintech product offering business bank accounts to SMBs. Trial-to-paid conversion is 38%; the industry average for comparable products is 55-65%. Customer interviews (n=18) and support-ticket analysis show that 60% of trials that churn do so in the first 7 days, and the modal exit reason is "we couldn't get set up in time." The current onboarding flow requires a 5-day internal KYC verification step before the customer can make their first transaction.

```markdown
# Strategy kernel — SMB fintech trial conversion / Q3-Q4 2026

**Strategic question:** How do we raise trial-to-paid conversion from 38%
to ≥58% within two quarters, without increasing fraud exposure above
current baseline?

## Diagnosis
We lose 60% of churning trials in the first 7 days because compliance
verification takes 5 business days — longer than the window in which
new SMB customers evaluate whether a financial tool is worth switching
to. The binding constraint is business viability risk: the current
internal KYC process was designed for regulatory defensibility, not
for activation speed, and no combination of UX improvements will
compress a 5-day verification queue. Customers who reach first
transaction convert at 81%; customers who don't reach it within
7 days convert at 9%.

## Guiding policy
Shrink time-to-first-verified-transaction to under 24 hours by
re-architecting the onboarding flow around customer-provided KYC
pre-fill — accepting a shift from internally-run verification to
verification-on-customer-data, and accepting the compliance overhead
of building a pre-fill integration, in exchange for activation speed
that our current architecture cannot achieve any other way.

## Coherent actions
1. **Build KYC pre-fill from existing customer data sources (Companies
   House, Plaid, Stripe Identity)** — reduces the data-collection
   burden on new customers from 40+ fields to ~8, which compresses
   the application time and directly reduces the queue that triggers
   the 5-day wait. Makes actions 2 and 3 possible by reducing the
   verification surface.
2. **Parallel-run automated pre-fill verification against the current
   manual queue** — the pre-fill data enables automated rule-based
   checks that clear 70-80% of low-risk applicants in under 2 hours,
   releasing human reviewers to concentrate on the 20-30% flagged
   cases. Reinforces action 1 by making the reduced surface checkable
   at speed; reinforces action 3 by freeing compliance capacity.
3. **Redesign the onboarding UI as a single-session flow with live
   progress feedback** — customers currently abandon because the
   process feels opaque and indefinite. A single-session flow with
   estimated completion time (anchored to the 24-hour target)
   reduces abandonment independent of the backend speed, and sets
   an expectation that the team can now meet. Reinforces actions 1
   and 2 by converting their speed improvement into a visible and
   credible promise.
4. **Instrument first-transaction rate as the lead activation metric
   and gate the Q3 OKR on it** — makes the 24-hour target visible
   in the weekly team cadence, creates a forcing function for actions
   1-3, and surfaces regression immediately if the pre-fill or
   automated-check pipeline slows. Reinforces the other actions by
   ensuring any deviation from the guiding policy is caught before
   it compounds.
5. **Defer expansion of the product account-type menu until
   conversion reaches ≥55%** — adding SMB account variants before
   solving activation would fragment the pre-fill data model and
   multiply the verification surface. Named explicitly so the team
   can defend it when account-type requests arrive.

## Binding constraint
Business viability risk: the current internal KYC process creates a
structural floor on activation speed that no UX or messaging change
can overcome.

## What we are not doing
- Launching additional account types (SMB Plus, payroll accounts)
  until conversion target is reached
- A/B testing onboarding copy variants — messaging is not the
  binding constraint
- Expanding to the EU market in Q3 — regulatory complexity would
  multiply the pre-fill surface before the core architecture is proven
```

**What makes this kernel good.** The diagnosis names a specific obstacle (5-day KYC queue) with a specific mechanism (trials who don't reach first transaction within 7 days convert at 9%), not a general dissatisfaction with onboarding. The guiding policy contains an explicit trade-off (compliance overhead of pre-fill integration accepted in exchange for speed). The coherent actions reinforce each other in a describable chain: actions 1-2 remove the structural floor; action 3 converts that removal into a visible customer promise; action 4 instruments the whole system; action 5 names the deprioritisation. Remove any one action and the chain weakens.

### Example 2 — Bad strategy (diagnostic exercise)

```markdown
# Growth strategy — 2026

## Goals
- Become the market leader in SMB financial tooling
- Improve NPS to 65+
- Expand to 3 new markets
- Ship the new dashboard, payroll integration, and mobile app
- Double ARR by end of 2026

## How we'll get there
We will invest in product quality, go-to-market excellence, and
customer success to deliver a best-in-class experience that drives
growth and retention across all segments.
```

**Rumelt diagnostic.** No diagnosis — the document names no obstacle, no crux, no specific challenge. The "goals" section is a classic goal list: each item is desirable, none create tension with each other, none imply trade-offs. The "how we'll get there" paragraph is fluff: "invest in product quality, go-to-market excellence, and customer success" could describe any B2B SaaS company at any time. There is no guiding policy (no posture, no trade-off). The actions are initiatives listed without coherence structure — becoming market leader, improving NPS, expanding to new markets, shipping three features, and doubling ARR are not reinforcing actions under a guiding policy; they are a wish list.

This document fails all four of Rumelt's bad-strategy tests: it exhibits fluff, fails to face any named challenge, mistakes goals for strategy, and provides blue-sky objectives. It is not a minor-defect strategy; it is bad strategy.

## Common Pitfalls

### Pitfall 1 — Strategy-as-goal-list

**Symptom.** The strategy artifact is a list of targets: "double ARR," "reach 10,000 customers," "achieve 4.8 App Store rating." Each item is measurable and desirable. None of them answer "how."

**Consequence.** Rumelt's "mistaking goals for strategy" — the team has named destinations without doing any work on the obstacle between here and there. Resource allocation cannot be derived from a goal list because the goals don't imply trade-offs.

**Fix.** For each goal, ask "what is the specific obstacle between us and this goal?" That question produces a diagnosis. Reposition the goals as OKR-layer outcomes; the kernel provides the mechanism.

### Pitfall 2 — Diagnosis skipped or restated in jargon

**Symptom.** The "diagnosis" section says something like: "The market is evolving rapidly and customers expect more integrated solutions while competition intensifies across all segments." This is jargon that names no specific obstacle.

**Consequence.** Rumelt's "fluff" — a guiding policy built on a non-diagnostic diagnosis will be generic, and generic guiding policies produce uncoordinated actions.

**Fix.** Apply the falsifiability test: is there evidence that could change this diagnosis? If not, it is a truism, not a diagnosis. Ask: "What is the one thing that, if we fixed it, would change the game?" If the team can't answer, the diagnostic work is not done.

### Pitfall 3 — Actions accidentally independent

**Symptom.** The coherent actions section lists 6-8 initiatives that all serve the guiding policy, but none make each other more effective. Removing any one action would not weaken the others.

**Consequence.** Rumelt's "lack of coherence" — a project plan dressed in strategy language. When prioritisation pressure arrives, the team has no principled basis for deciding which action to protect.

**Fix.** For each action, write: "This action reinforces [action X] by [specific mechanism]." If no mechanism can be named, the action is independent — move it to a separate initiative backlog.

### Pitfall 4 — Blue-sky objectives

**Symptom.** The kernel's guiding policy or actions contain no trade-offs and no explicit deprioritisation. Everything is additive. The document could describe any well-resourced company doing everything at once.

**Consequence.** Rumelt's "blue-sky objectives" — strategy without constraint is aspiration. Resource allocation without trade-offs is not strategy; it is a budget request. A team that has not named what it will *not* do has not made a strategic choice.

**Fix.** The "What we are not doing" section in the kernel template is not optional. Every guiding policy implies deprioritisation. If no deprioritisation can be named, the guiding policy is too generic to constrain anything.

### Pitfall 5 — Kernel disconnected from team day-to-day

**Symptom.** The kernel exists as a document but the team's sprint priorities, backlog, and OKRs don't trace to it. Perri's build-trap signal: the team is shipping features that are not coherent actions under the guiding policy.

**Consequence.** The kernel becomes a shelf artifact: referenced in leadership decks, ignored in planning. The gap erodes trust in the PM's strategic role.

**Fix.** Each coherent action should map to at least one OKR outcome and at least one near-term PRD. If a coherent action has no downstream OKR or PRD, either it is too abstract (break it down) or the planning cycle hasn't been synchronized to the kernel.

### Pitfall 6 — Kernel written in isolation by PM without cross-functional input

**Symptom.** The PM produces the kernel alone, then presents it as the strategy. Coherent actions have not been reviewed for feasibility by engineering, for usability by design, or for market validity by sales or CS.

**Consequence.** Cagan's four risks not stress-tested — the diagnosis may misidentify the binding constraint; the guiding policy may conflict with market realities sales has been absorbing for months. A kernel produced in isolation is a hypothesis, not a strategy.

**Fix.** Steps 3 and 7 require cross-functional input explicitly. At minimum: engineering on feasibility coherence; design on usability coherence; one revenue-facing function on the diagnosis. The PM synthesises; the PM does not solo-author.

## References

- **Richard Rumelt** — *Good Strategy / Bad Strategy: The Difference and Why It Matters* (2011, Crown Business). Chapters 1-4 are load-bearing for this skill: ch. 1-2 define the kernel (diagnosis, guiding policy, coherent actions); ch. 3-4 define bad strategy (fluff, failure to face the challenge, mistaking goals for strategy, blue-sky objectives). The kernel structure and all four bad-strategy diagnostics in this skill trace directly to these chapters. See `roles/product-manager/sources.md`.
- **Richard Rumelt** — *The Crux: How Leaders Become Strategists* (2022, PublicAffairs). Extends the diagnosis methodology: the "crux-finding" process, the discipline of simplifying complex situations to a named essential challenge, and the practitioner case studies that show diagnosis in context. Used in steps 2-3 of Application.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017, Wiley); *Empowered: Ordinary People, Extraordinary Products* (2020, Wiley). The four risks (value, usability, feasibility, business viability) are used in this skill as a structured input to diagnosis: the binding constraint is the one risk whose resolution unlocks the others. See `roles/product-manager/sources.md`.
- **Melissa Perri** — *Escaping the Build Trap: How Effective Product Management Creates Real Value* (2018, O'Reilly). The org-architecture overlay: team-level kernels must connect to portfolio-level strategy or they will be eroded by feature-factory planning cycles. The build-trap signal in Pitfall 5 traces directly to Perri. See `roles/product-manager/sources.md`.
- **Related Hornero skills:**
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — the coherent actions in the kernel typically map to bets in the portfolio. The kernel is the frame that makes individual bets legible and comparable; bet-portfolio is the downstream allocation exercise.
  - [`cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — orchestration consumes the kernel. The "strategic question" in step 1 of this skill is often the framing that orchestration then executes on for a specific decision.
  - [`prd`](../prd/SKILL.md) — PRDs ladder to the kernel. Each coherent action in the kernel should be traceable to one or more PRDs. A PRD with no kernel parent is either self-justifying feature work or a sign the kernel hasn't been operationalised.
  - [`competitive-teardown`](../competitive-teardown/SKILL.md) — teardowns feed the diagnosis. Understanding what the competitive set is doing — and why customers choose or leave competitors — is primary evidence for the diagnosis step. Run competitive-teardown before step 2 when the diagnosis involves competitive positioning.
  - [`okrs`](../okrs/SKILL.md) — OKR outcomes are the quarterly expression of what the kernel's coherent actions are designed to move. Without a kernel, OKRs are goal lists. With one, OKRs become the measurement layer on top of a posture.
  - [`problem-framing-canvas`](../problem-framing-canvas/SKILL.md) — the problem-framing canvas is the feature-level diagnostic; the strategy kernel is the portfolio-level diagnostic. When a kernel diagnosis is uncertain, a problem-framing canvas pass on the crux area can sharpen the evidence base before diagnosis is committed.
