---
name: opportunity-solution-tree
description: Use when a PM needs to connect a desired outcome to the customer opportunities that could move it, map solution hypotheses against each opportunity, and select an experiment without collapsing the tree into a flat feature list.
intent: |
  Produces a four-level tree — outcome, opportunities, solutions, experiments —
  that keeps a team in divergent mode long enough to avoid premature convergence
  on a single solution. The tree is Torres' continuous-discovery artifact: it
  externalises the reasoning behind *why this opportunity, this solution, this
  test* rather than burying it in a roadmap entry. The output is a prioritised
  branch ready to experiment against, plus an explicit record of the branches
  not taken.
type: component
theme: discovery
best_for:
  - When a team has a measurable outcome but is jumping straight to solutions — the tree forces opportunity-level thinking first
  - When discovery has surfaced three or more customer problems and the team needs a principled way to pick one
  - When a stakeholder feature request arrives and the PM needs to surface the underlying opportunity before committing to scope
scenarios:
  - "We have a churn OKR for Q3 — what should we actually build to move it?"
  - "Interviews surfaced six problems; we need to pick one branch to test this sprint"
  - "Sales wants a specific integration; PM needs to determine whether that's the right solution to the underlying opportunity"
estimated_time: "90–180 minutes (first tree); 30–60 minutes (subsequent sessions with an existing tree)"
---

# Opportunity-solution tree

> v0 draft. Anchored in Teresa Torres (*Continuous Discovery Habits*, 2021) as the canonical author of the Opportunity Solution Tree framework. Cagan's four risks (*Inspired*, *Empowered*) applied as an opportunity stress-test. Christensen's JTBD (*Competing Against Luck*) as the lens for naming opportunities cleanly. Editorial review recommended before production use.

## Purpose

Map a desired outcome to the customer opportunities that could plausibly move it, generate solution hypotheses under each opportunity, and connect solutions to experiments — without collapsing to a single path until the team is ready to test.

Torres (*Continuous Discovery Habits*, ch. 3-5) defines the Opportunity Solution Tree as the artefact that keeps continuous-discovery teams honest: it makes the implicit choice structure explicit. Most teams carry a mental tree, but leave it undrawn — which means they can't audit it, debate it, or update it when they learn something. Drawing it is the work.

Distinct from a roadmap: a roadmap commits to delivering. An OST commits to testing. A branch on the tree is not a feature; it is a hypothesis about which opportunity, addressed by which solution, validated by which experiment, would move the outcome. Branches get pruned when evidence disconfirms them; the roadmap does not grow until the tree has been navigated.

Distinct from a problem-framing canvas: the canvas produces a structured problem statement for a single, specific opportunity. The OST is the frame that establishes which opportunities are worth running a canvas on. The two are sequenced: OST first to identify and prioritise the opportunity space; canvas second to develop the highest-priority opportunity into a PRD-ready problem statement.

Distinct from OKRs: OKRs name what to move and by how much. The OST names why those metrics — the customer opportunity stack that, when addressed in sequence, produces the outcome movement the OKR targets. Without an OST, OKRs produce feature requests; with one, they produce a navigable discovery agenda.

## Key Concepts

### The four-level structure (Torres)

Torres defines four levels, each with a specific function:

**Level 1 — Desired outcome.** One measurable product or business metric the team is accountable for in the current discovery cycle. Not a vision; not a goal list. A single number the team is trying to move. Examples: 60-day retention for new B2B accounts; trial-to-paid conversion rate; weekly active users among the enterprise segment. The outcome disciplines the tree: every opportunity must plausibly connect to it.

**Level 2 — Opportunities.** Customer problems, needs, frictions, or desires that, if addressed, could move the outcome. Opportunities are customer-language descriptions of real situations, not internal framings of work. "Users don't understand the pricing model" is an opportunity. "We need a better pricing page" is a solution masquerading as an opportunity — one of the most common and expensive mistakes in tree-building. Torres is explicit: an opportunity tree that contains solutions at the opportunity level is not a tree; it is a pre-decided roadmap with discovery theatre on top.

The tree should carry three to five top-level opportunities for any given outcome. Fewer than three is insufficient divergence; more than seven and the team cannot hold the structure.

**Level 3 — Solutions.** Concrete product, service, or process approaches that could address a specific opportunity. Each opportunity should have at least three candidate solutions before the team picks one. The branching matters: if a team can only name one solution to an opportunity, they have not yet understood the opportunity well enough — or they have already pre-committed to the solution and are working backwards. Torres recommends generating solutions through assumption mapping and assumption testing, not through brainstorming sessions that converge on consensus.

**Level 4 — Experiments.** Tests that can confirm or disconfirm the core assumption of a solution, at the lowest possible cost, before committing to building. Torres distinguishes between *assumption tests* (small, fast, cheaply de-risk one critical assumption) and *solution tests* (prototypes, A/B tests, concierge runs that de-risk a more complete solution). The tree should carry at least one experiment per solution under the prioritised opportunity.

### Why the structure is a tree, not a list

A flat list of opportunities is the failure mode this framework exists to prevent. A list has no outcome discipline — any item can be added without connection to what the team is trying to move. A list has no branching — it cannot represent the relationship between an opportunity and the solutions available to address it, or the relationship between a solution and the assumption it rests on.

The tree structure enforces three disciplines simultaneously: outcome-anchoring (every branch traces to a single outcome), divergence before convergence (multiple opportunities, multiple solutions), and assumption transparency (experiments surface what the team doesn't yet know, not just what they're building).

### Opportunity sizing and the prioritisation decision

Not all opportunities are equal. Before committing to a branch, Torres recommends sizing each opportunity across three dimensions:

- **Reach.** What proportion of the customer population affected by the outcome encounters this opportunity? An opportunity that affects 8% of users is a candidate; an opportunity that affects 65% is a priority.
- **Frequency.** How often does a given customer encounter this opportunity? Daily friction is not the same as quarterly friction.
- **Stakes.** What is the cost of the opportunity to the customer if it goes unaddressed? A five-minute inconvenience and a three-hour productivity loss call for different investment levels.

Cagan's four risks (*Inspired*) apply here as a stress-test: is the opportunity real (value risk)? Can customers engage with a solution if we build it (usability risk)? Can we actually address it within reasonable constraints (feasibility risk)? Does addressing it create sustainable business value (viability risk)? An opportunity that clears all four risks on sizing is a strong candidate for the first branch to develop.

### The relationship between the tree and continuous discovery

Torres frames the OST as a living document, not a planning deliverable. The distinction matters: a planning deliverable is drawn once, handed off, and executed against. A living document is updated every time the team runs an experiment — branches are marked confirmed or disconfirmed, sub-opportunities are added as interviews surface them, solutions are pruned when assumptions fail.

This means the tree has a cadence. Teams running continuous discovery typically update the OST weekly: at the end of each experiment cycle, the relevant branch is annotated with what was learned, and the prioritisation decision is revisited. A team that drew the OST three months ago and has not touched it since has a planning artefact, not a discovery tool.

The cadence also governs how many branches are active at once. Torres recommends keeping one active branch — one prioritised opportunity, one solution under test — at a time per team. The remaining branches stay visible but dormant, ready to activate when the current branch concludes or evidence shifts the prioritisation.

### What makes a good opportunity (Torres / Christensen)

Christensen's JTBD lens (*Competing Against Luck*) is the cleanest framing for opportunity quality: an opportunity is the gap between the job the customer is trying to get done and the current solutions available to them. A good opportunity names that gap in customer terms — not in product terms, not in feature terms, not in internal terminology.

Torres adds: an opportunity should be falsifiable. "Users are confused" is not falsifiable in useful ways. "New users who complete onboarding cannot configure the core workflow without contacting support" is falsifiable — it can be tested with session recordings, support-ticket analysis, or a five-minute usability session.

Three quality checks for every opportunity statement before it enters the tree:

1. **Solution-free.** Remove the opportunity if it names a feature or a UI pattern. Rewrite in customer-situation language.
2. **Outcome-connected.** Can you draw a direct line from this opportunity to the desired outcome? If the reasoning requires more than two steps, the connection is speculative — note it and weight it lower.
3. **Evidence-grounded.** Is there at least one piece of customer evidence (interview quote, session recording, support ticket, churn survey response) that supports this opportunity? An opportunity with no evidence is a hypothesis; label it as such.

## Application

Seven steps; 90-180 minutes for the first tree. Steps 1-3 are the load-bearing work; steps 4-7 are faster once the structure is clear.

### Step 1 — Anchor to the outcome (10-15 minutes)

Write the desired outcome in one sentence: the specific metric, its current value, the target value, and the time horizon. "Increase 60-day retention for new B2B accounts from 41% to 55% by end of Q3" is an outcome. "Improve retention" is a goal; it cannot anchor a tree because it doesn't constrain which opportunities are in scope.

If the team cannot agree on a single outcome, the tree cannot be drawn. Surface the disagreement explicitly — it is a strategy question (which outcome is the team accountable for?) that must be resolved before discovery work begins.

### Step 2 — Generate opportunities (20-30 minutes)

Working from customer evidence — interviews, session recordings, support tickets, survey data, churn analysis — list every customer problem, friction, or unmet need that plausibly connects to the outcome. Do not filter yet; this is a divergence step.

Audit each candidate opportunity for solution-language before moving forward. The test: can the opportunity be stated without naming a product feature? If the answer is no, rewrite. "Customers need a bulk-import tool" becomes "customers who manage large datasets cannot migrate their existing data without manual re-entry." The rewrite reveals an opportunity; the original named a solution.

Target: five to eight opportunities. More than eight and the team is not scoping to the outcome; they are listing every problem they've ever heard.

### Step 3 — Build the opportunity sub-structure (20-30 minutes)

For each top-level opportunity, ask whether it contains sub-opportunities — more specific problems that sit within the larger opportunity space. Torres recommends treating opportunities as nested, not flat. "New users cannot reach first value" might contain: "new users don't know what to do on first login," "new users set up the product incorrectly for their use case," and "new users who get stuck have no in-product guidance." Each sub-opportunity can have its own solutions and experiments.

The sub-structure is what turns the tree from a list into a navigable structure. It also reveals scope: a top-level opportunity with four well-defined sub-opportunities is a longer discovery arc than one with a single specific sub-opportunity.

### Step 4 — Size and prioritise opportunities (15-20 minutes)

For each top-level opportunity (and its sub-structure), apply the sizing dimensions: reach, frequency, stakes. Apply Cagan's four-risks stress-test. The goal is not a precise score but a defensible ordering: which opportunity, if addressed well, would have the highest impact on the outcome?

Name the prioritisation reasoning explicitly — it will be challenged. A PM who can say "we prioritised opportunity 2 because it affects 60% of accounts in the churn cohort, triggers daily, and maps to a value-risk binding constraint" is holding the tree accountable. A PM who says "we went with opportunity 2 because it felt most impactful" is not.

The four-risks stress-test applied to opportunities:

- **Value risk.** Is there real, confirmed evidence that this problem exists and that customers care enough about it to change behaviour if it were solved? Evidence-level check: do you have more than one customer source for this opportunity, or is it a single anecdote?
- **Usability risk.** Is this a problem of customer difficulty, motivation, or workflow mismatch? The distinction shapes solution design: difficulty problems call for simplification; motivation problems call for incentive or context changes; workflow mismatches call for meeting customers at a different point in their process.
- **Feasibility risk.** Is this an opportunity the team can address within a discovery cycle? Some real opportunities are real but unreachable given current technical or resource constraints. Name it and park it; don't spend experiment cycles on structurally unreachable problems.
- **Viability risk.** If a solution to this opportunity were adopted by 80% of the affected customer segment, would it move the outcome metric enough to justify the discovery investment? An opportunity that is real, reachable, and usable but whose maximum impact on the outcome is modest warrants a lower priority than a smaller but higher-leverage problem.

### Step 5 — Generate solution hypotheses for the prioritised opportunity (20-30 minutes)

For the selected opportunity (or the highest-priority sub-opportunity), generate at least three candidate solutions. Apply the same divergence discipline as step 2: force multiple options before evaluating any. The common failure here is to name one obvious solution and declare it the only option. That is a sign the team has already pre-committed.

For each solution, make the core assumption explicit: "This solution works if [assumption]." The assumption is the input to experiment design. A solution without a named assumption cannot be tested; it can only be built and hoped.

Two kinds of assumptions are worth naming separately for each solution:

- **Desirability assumption.** Do customers want this? Would they change their behaviour if we offered it? This is the value-risk test applied to the specific solution hypothesis.
- **Efficacy assumption.** If customers engage with this solution, does it actually address the opportunity? A well-designed checklist that users ignore does not address an onboarding friction problem; the assumption that users will engage with the checklist is a separate, testable claim.

Experiment design in step 6 targets one of these assumption types per test. Naming both early prevents the common pattern of testing desirability (yes, users like this concept) while leaving efficacy unvalidated (no evidence they will actually use it at the moment the friction occurs).

### Step 6 — Design experiments (15-20 minutes)

For each solution under the prioritised opportunity, identify the cheapest test that could confirm or disconfirm the core assumption before significant build investment. Torres distinguishes assumption tests (quick, cheap, single assumption) from solution tests (more complete, more expensive). Default to assumption tests first.

Experiment types include: customer interviews focused on the assumption ("Have you ever tried to solve this by doing X?"), data queries against existing product instrumentation, fake-door tests, concierge tests (manually perform the solution for a small cohort), paper prototypes, and A/B tests. The experiment tier matters: do not propose an A/B test when an interview would answer the same question in two days.

Select one experiment to run first — the one that tests the assumption with the highest impact on the prioritisation decision.

### Step 7 — Draw and commit the tree (10-15 minutes)

Externalise the full tree in a shared artefact: the outcome, all top-level opportunities with prioritisation rationale, the solution hypotheses under the prioritised opportunity, and the selected experiment. The tree should be visible to the full team, not locked in a PM's notes.

The tree is a living document. When an experiment concludes, update the relevant branch — mark the assumption confirmed or disconfirmed, note the implication for adjacent branches. A branch that has been tested and disconfirmed is not a failure; it is evidence that the team has narrowed the solution space.

**Update protocol after each experiment:**

1. Mark the tested assumption as confirmed, disconfirmed, or inconclusive (and why the experiment was inconclusive — underpowered, wrong participant profile, ambiguous signal).
2. If confirmed: advance to the next assumption in the solution, or, if the solution is fully de-risked, recommend it for a PRD.
3. If disconfirmed: revisit the other solution hypotheses under the same opportunity. If all solutions under an opportunity are exhausted, reconsider the opportunity's prioritisation — the evidence may be pointing to a different branch.
4. If the prioritised opportunity's sizing changes materially based on new evidence, re-run step 4 across all top-level opportunities before committing to the next branch.

The tree update is a team event, not a PM solo activity. A five-minute standing update at the end of each experiment cycle is sufficient. The tree should never go more than two weeks without a review; a static tree is a signal that discovery has stalled.

## Examples

### Example 1 — Worked OST (B2B SaaS retention)

**Context.** A B2B project-management tool, 250-seat median customer size. Desired outcome: increase 60-day retention for new accounts from 41% to 55% in Q3. Exit interviews (n=14) and session-recording analysis (n=80 new-account sessions) are the primary evidence sources.

```
Desired outcome: 60-day retention, new B2B accounts — 41% → 55%, Q3

├── Opportunity A: Teams do not complete enough of the product
│   to judge its value before renewal pressure arrives
│   (Reach: 70% of churned accounts; Frequency: once, at onboarding;
│   Stakes: high — determines whether trial becomes commitment)
│
│   ├── A1: First login presents no clear starting action
│   │   ├── Solution A1a: Onboarding checklist with role-based first task
│   │   │   Core assumption: role-based first task exists and is unambiguous
│   │   │   Experiment: 5 usability sessions — can users identify their
│   │   │   role and name a first task from existing content?
│   │   │
│   │   ├── Solution A1b: Guided setup wizard (linear, 5 steps)
│   │   │   Core assumption: teams will complete a 5-step linear flow
│   │   │   Experiment: interview 8 onboarded accounts — did they complete
│   │   │   setup end-to-end, or did they self-direct after step 2?
│   │   │
│   │   └── Solution A1c: Template library presented at first login
│   │       Core assumption: templates match real team workflows
│   │       Experiment: audit 20 existing templates against job categories
│   │       from exit interviews — what % are a close match?
│   │
│   └── A2: Teams that get stuck have no recovery path in-product
│       (Sub-opportunity with own solutions; not prioritised this cycle)
│
├── Opportunity B: Decision-makers who approved the purchase are
│   not engaging with the product themselves
│   (Reach: 45% of churned accounts; Frequency: ongoing; Stakes: medium
│   — economic buyer disengagement predicts non-renewal)
│
└── Opportunity C: Teams adopt the product for one workflow but
    do not expand to adjacent workflows before renewal
    (Reach: 35% of churned accounts; Frequency: once, at ~45 days;
    Stakes: medium — expansion correlates with renewal)

Prioritised branch: A → A1 → Experiment A1a (next two weeks)
Rationale: highest reach in churn cohort; binds on value risk;
assumption test is low-cost and will invalidate or validate A1a
before any build commitment.
```

What makes this tree work: the outcome is specific and measurable. Opportunities are stated in customer language and sized explicitly along reach, frequency, and stakes. The sub-structure (A1, A2) shows that "Opportunity A" is itself a problem space, not a single point — it contains distinct sub-opportunities with different solution profiles. Solution hypotheses each carry a named assumption that determines the experiment design; two solutions with different assumptions call for different experiments even if they address the same sub-opportunity. The selected experiment — five usability sessions testing the role-based task assumption — is calibrated to answer the assumption question in days, not weeks, before any build commitment is made. Branches B and C remain visible on the tree with sizing context attached; they are not backlog items, not forgotten work, and not closed off — they are explicitly deprioritised for this cycle with the reasoning recorded so the next prioritisation pass can revisit them with fresh evidence.

The tree's visible record of what was *not* chosen is as valuable as what was. A team that can only tell you what they are building cannot tell you whether they made the right prioritisation call. A team that can point to the tree and say "we chose A over B because A had three times the reach and tested a value-risk binding constraint" is doing discovery, not feature delivery.

### Example 2 — Flat list (failure mode)

The following is not a tree. It is the failure mode the OST framework exists to prevent.

```
Backlog items (Q3):
- Onboarding checklist
- Welcome email sequence
- In-app tooltips
- Template library
- Role-based setup wizard
- Customer success check-in at day 7
- Expansion nudge at day 30
- NPS survey at day 45
```

What fails here: there is no outcome anchor — the list does not say what metric it is trying to move. There are no opportunities — every item is a solution, and solutions appear at the same level as each other with no structure showing which customer problem each addresses. There is no divergence discipline — no indication that alternatives were considered and rejected. There is no assumption transparency — no test criterion accompanies any item. This list could have been produced without a single customer conversation. A team working from this list is already in the build trap.

## Common Pitfalls

### Pitfall 1 — Solutions at the opportunity level

**Symptom.** The opportunity section contains entries like "Build a guided tour," "Add a progress indicator," or "Send re-engagement emails." These are solutions. The PM has collapsed levels 2 and 3.

**Consequence.** The tree loses its divergence value. There is now only one solution per opportunity (the one embedded in the opportunity statement), and no other options can be evaluated because the opportunity is already solution-shaped. Discovery becomes post-hoc justification.

**Fix.** For every opportunity-level entry, ask: "What customer problem does this address?" If the answer is a different sentence — a real problem statement — that is the opportunity. The original entry is the solution. Move it to level 3.

### Pitfall 2 — Single-outcome ambiguity

**Symptom.** The team has listed two or three outcomes at the top of the tree: "improve retention AND increase expansion AND reduce churn." These are related but distinct, and the opportunities that move retention are not necessarily the same as the ones that drive expansion.

**Consequence.** Opportunity sizing becomes impossible because the same opportunity rates differently against each outcome. Prioritisation breaks down. The tree becomes a portfolio disguised as a tree.

**Fix.** One tree, one outcome. If the team is genuinely accountable for multiple outcomes this cycle, draw separate trees and prioritise across them explicitly. Don't merge them into a single structure; the structure's coherence depends on a single anchoring metric.

### Pitfall 3 — Opportunity tree drawn once, never updated

**Symptom.** The team drew the tree in a planning session, selected a branch, and has not touched it since. Experiments have concluded; the tree has not been updated to reflect what was learned.

**Consequence.** The tree becomes a planning artefact rather than a discovery artefact. The team is executing against a prioritisation decision that may have been invalidated by the last experiment. Torres' continuous-discovery framing is clear: the tree is the team's live map of what they know and don't know. A static tree is not a discovery tool; it is a roadmap with extra steps.

**Fix.** Establish a cadence — typically weekly, at the end of an experiment — for updating the tree. Mark confirmed and disconfirmed assumptions on each branch. Reprioritise if evidence shifts the sizing of an opportunity.

### Pitfall 4 — Experiments sized like features

**Symptom.** Every experiment on the tree is a multi-sprint build: "A/B test with 5,000 users," "build a full concierge onboarding program," "instrument the entire activation funnel." The team is proposing to build their way to learning.

**Consequence.** The experiment layer loses its de-risking function. Expensive experiments are deferred because they compete with feature work. The tree has solutions but no validated learning path. Torres is explicit that assumption tests should take days, not weeks — anything larger is a solution test, not a first experiment.

**Fix.** For each solution, ask: "What is the single assumption that, if false, would invalidate this entire solution?" Then ask: "What is the cheapest test of that assumption?" Interviews, data queries, fake-door tests, and paper prototypes should appear before any build commitment.

### Pitfall 5 — Opportunity sizing skipped

**Symptom.** The team selects the prioritised branch based on team preference, stakeholder pressure, or recency bias from the most recent customer call, without applying sizing criteria or the four-risks stress-test.

**Consequence.** The OST provides false rigour — the tree exists but the prioritisation inside it is arbitrary. A low-reach, low-frequency opportunity gets built while a high-reach, high-stakes opportunity sits undiscovered at level 2.

**Fix.** Steps 4 and 5 of Application are non-optional. Sizing does not require precision — rough estimates from exit interviews, support-ticket volume, and session-recording patterns are sufficient. What matters is that the team can articulate *why* this opportunity over the others, in terms of reach, frequency, and stakes, before committing resources to it.

### Pitfall 6 — Tree built in isolation by the PM

**Symptom.** The PM draws the tree alone from their discovery synthesis and presents it to the team as the prioritised plan.

**Consequence.** Cagan's four risks are not stress-tested cross-functionally: the PM's assessment of feasibility risk is untested by engineering; the PM's assessment of usability risk is untested by design. The opportunity prioritisation may reflect the PM's biases rather than the team's collective reading of the evidence. Torres frames continuous discovery as a team sport; the OST is a team artefact.

**Fix.** Opportunity generation (step 2) and prioritisation (step 4) should involve engineering and design at minimum. The tree can be drafted by the PM but should not be committed before at least one cross-functional review of the sizing rationale and the assumptions being tested.

## References

- **Teresa Torres** — *Continuous Discovery Habits: Discover Products That Create Customer Value and Business Value* (2021, Product Talk LLC). The Opportunity Solution Tree is Torres' framework. The four-level structure, the distinction between opportunities and solutions, the continuous-update discipline, and the assumption-test/solution-test distinction all originate here. This skill is a distillation of that methodology. See `roles/product-manager/sources.md`.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017, Wiley); *Empowered: Ordinary People, Extraordinary Products* (2020, Wiley). The four risks (value, usability, feasibility, business viability) are applied in this skill as a structured opportunity stress-test: the binding-constraint risk shapes which opportunity warrants the first branch. See `roles/product-manager/sources.md`.
- **Clayton Christensen, Taddy Hall, Karen Dillon, David Duncan** — *Competing Against Luck: The Story of Innovation and Customer Choice* (2016, HarperBusiness). JTBD provides the canonical framing for what makes a good opportunity: the gap between the job the customer needs to get done and the current solutions available. Applied in the Key Concepts section and in step 2's opportunity audit.
- **Related Hornero skills:**
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — the primary evidence source for opportunity generation. Interview synthesis feeds the OST's opportunity layer; run before drawing the tree if customer evidence is thin.
  - [`interview-synthesis`](../interview-synthesis/SKILL.md) — translates raw interview notes into structured opportunity themes. OST opportunity generation draws directly from interview synthesis output.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD provides the durable job framing that grounds opportunity naming. An opportunity stated in JTBD language ("the gap between what the customer needs to get done and current solutions") is harder to corrupt into solution-language.
  - [`problem-framing-canvas`](../problem-framing-canvas/SKILL.md) — the canvas produces the structured problem statement for a specific, prioritised opportunity. Run after the OST has identified which opportunity to develop: the canvas is the depth instrument; the OST is the breadth instrument.
  - [`prd`](../prd/SKILL.md) — PRDs operationalise the solution selected and validated on a specific OST branch. A PRD without an upstream OST branch is a solution without a documented opportunity rationale.
  - [`proto-persona`](../proto-persona/SKILL.md) — persona framing anchors opportunity sizing to a specific customer context. When the team disagrees on which customer segment the outcome applies to, resolve it with a proto-persona pass before drawing the OST.
  - [`okrs`](../okrs/SKILL.md) — the OST's desired outcome is the same metric the OKR's Key Result is targeting. The two are complementary layers: OKRs set the accountability frame; the OST maps the customer problem stack that will move the metric. Drawing both keeps the discovery work tethered to the commitments made at planning.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/opportunity-solution-tree) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
