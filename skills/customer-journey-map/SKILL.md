---
name: customer-journey-map
description: Use when a team needs to lay out the end-to-end customer journey across stages, touchpoints, emotions, and pain points to find the highest-impact intervention.
role: product-manager
intent: |
  Maps the full arc of a customer's experience — from the first trigger of
  awareness through the habits of a loyal repeat customer — by documenting
  what they do, where they interact, what they think, and how they feel at
  each stage. The artifact surfaces which stages carry the heaviest friction
  and translates that into prioritised intervention opportunities. It is a
  strategic alignment tool, not a flowchart.
type: component
theme: discovery
best_for:
  - Diagnosing where the experience breaks down across a multi-stage customer arc
  - Aligning cross-functional stakeholders on what customers actually do versus what the team assumes
  - Identifying the highest-leverage intervention point before committing to a solution
scenarios:
  - "I need to understand why activation is fine but 90-day retention is weak — map the journey to find where the emotional arc breaks"
  - "Marketing, product, and CS each have different theories about the onboarding problem — use the map to get everyone on the same evidence base"
  - "New product area with no prior discovery — map a known persona's current journey before writing a single PRD"
estimated_time: "3–4 hours (workshop); 60–90 minutes (PM solo with existing research)"
---

# Customer journey map

> v0 draft. Anchored in Kalbach (*Mapping Experiences*, 2nd ed., O'Reilly, 2020) as the primary framework. Torres (*Continuous Discovery Habits*) for opportunity-anchoring; Indi Young (*Practical Empathy*) and Beverly Newman for the empathy-layer discipline. Editorial review recommended before production use.

## Purpose

Produce a persona-anchored, evidence-based map of the customer's end-to-end experience — from the moment they first encounter the problem your product might solve to the habits they develop as a loyal customer.

The output is a structured matrix: stages across the top, experience layers down the rows. The point is not the artifact — it is the forced reckoning with where the emotional arc turns negative and where intervention would actually matter.

Distinct from a service blueprint: a service blueprint maps internal processes and the frontstage/backstage split in parallel with the customer experience. A customer journey map maps only what the customer perceives and feels. Internal complexity is invisible to the customer until it surfaces as friction; this map tracks that friction, not its organisational cause.

Distinct from a UX flow: a UX flow traces paths through a specific product surface — screens, states, interactions. A customer journey map traces the arc of a relationship across time, touchpoints, and channels, most of which exist outside the product. A checkout funnel is a UX flow. "Customer decides to trial, onboards, gets to first value, refers a colleague" is a journey.

## Key Concepts

### The canonical CJM structure (Kalbach)

Kalbach (*Mapping Experiences*, ch. 3–5) identifies the core layers that, together, constitute a useful journey map. All must be present for the artifact to drive decisions rather than decorate walls.

**Horizontal axis — stages:**
Discrete phases that mark a qualitative shift in the customer's goal or relationship with the product. The number of stages depends on the product and persona; five is a useful default: Awareness, Consideration, Decision, Onboarding, and Loyalty. The stages are *the customer's* phases, not the company's funnel stages. If the company calls it "activation" and the customer calls it "figuring out whether this is worth my time," use the customer's language.

**Vertical axis — experience layers:**

- **Actions** — what the customer does. Observable, not inferred.
- **Touchpoints** — where they interact with the brand. Include channels the company does not own: review sites, word-of-mouth, community forums.
- **Thoughts** — what they believe or wonder at this stage. Drawn from direct quotes where possible.
- **Emotions** — how they feel. Not "interested" or "satisfied." Specific: "relieved that setup was faster than feared" or "frustrated that the trial clock started before they finished the import."
- **Pain points** — the specific frictions, gaps, and moments of negative emotion.
- **Opportunities** — one opportunity per pain point, stated as a customer outcome, not a feature.

### Persona-anchored versus aggregate maps

A map anchored to one persona has a specific trigger, a specific emotional arc, and specific alternatives the customer is using — it can drive decisions. An aggregate map representing "all users" averages across segments with incompatible journeys and produces generalizations no one can act on.

Build one map per meaningful persona. If two personas have structurally different journeys (different entry points, different stakes, different competitive alternatives), they need separate maps. If they are largely similar with one divergent stage, annotate the divergence rather than building two full maps.

### Discovery-anchored opportunity-tagging (Torres)

Torres (*Continuous Discovery Habits*) argues that opportunities — not solutions — are the correct currency of product discovery. Each pain point on the map should be tagged as an opportunity: a customer outcome the team could improve. Opportunities are stated in customer language, without implying a solution. This connects the journey map to an opportunity-solution tree and prevents the artifact from becoming a feature wish list.

### The empathy-layer discipline (Young, Newman)

Indi Young and Beverly Newman's work on empathy mapping (antecedents to the modern CJM) establishes that the thoughts and emotions rows are only as good as the evidence behind them. Inferred emotions ("the customer probably feels confused here") are hypotheses, not findings. Each emotion row entry should have a citation: an interview quote, a support-ticket pattern, an NPS verbatim. If it has no citation, mark it as an assumption.

## Application

Six steps; PM time 60–90 minutes with existing interview research, 3–4 hours running as a workshop with cross-functional participants.

### Step 1 — Anchor to one persona and bound the scope (10–15 min)

Name the persona for this map. Reference the team's existing proto-persona if one exists; if not, run `proto-persona` first. Do not proceed with "all users."

State the journey scope: which entry point (what triggers awareness?) and which exit point (what constitutes the end of the arc you're mapping?). A B2B SaaS onboarding journey might run from "signs up for trial" to "invites a second team member" — not from "hears about the product" to "renews after year two." Bound the scope to where you have evidence and where your interventions can plausibly reach.

**Quality check:** Can you name the persona in two sentences — segment, current context, what job they're trying to get done? If not, the persona is too generic to anchor the map.

### Step 2 — Define stages (15–20 min)

Name the stages in the customer's language, not the company's. A useful heuristic: a new stage begins when the customer's primary goal shifts. "Evaluating options" and "getting to first value" have different goals; they belong in different stages.

Validate the stages against evidence: do you have interviews, analytics, or support data for each? A stage with no evidence is a hypothesis and should be labelled as such.

Typical stage range is four to six. Fewer than four often means the team has collapsed stages that have meaningfully different emotional arcs. More than seven usually means the team has confused sub-steps within a stage for stages themselves.

### Step 3 — Populate actions and touchpoints (20–30 min)

For each stage, list what the customer actually does and where they interact with the brand or category. Ground this in evidence: call recordings, session recordings, support tickets, interview notes.

Actions should be observable: "Googles the product name and reads three G2 reviews" rather than "researches options." Touchpoints should include the full channel set — not just owned channels. A touchpoint you don't own (a competitor comparison post, a peer recommendation in a Slack community) is often more influential than the ones you do.

**Common trap:** Only listing digital touchpoints and only listing ones the company controls. Real journeys route through channels the team didn't plan for.

### Step 4 — Map thoughts and emotions; cite evidence (20–30 min)

For each stage, record: what does the customer believe at this point, and how do they feel?

Use direct quotes where available. If quoting, attribute the source type (interview, support ticket, NPS verbatim) without naming the customer. If you are inferring, flag it: `[inferred — validate]`. An emotion row filled with inferences is a hypothesis map, which has value, but should not be treated as a finding.

The emotion curve across stages is the most strategically useful output of the map. Find the stage where the emotional arc turns negative. That is the highest-priority intervention zone — not necessarily where the most features are requested.

### Step 5 — Tag pain points and opportunities (15–20 min)

Review the thoughts and emotions rows. Every negative emotion, confusion, or gap in actions (the customer wanted to do something and couldn't) is a pain point.

For each pain point, write one opportunity in this form: "Customer can [desired outcome] without [current friction or cost]." No feature names. No UI patterns. If a feature name appears in the opportunity, the framing is not done.

This opportunity list is the direct input to an opportunity-solution tree. It is also the artifact's main deliverable: everything upstream exists to produce a credible, evidence-grounded opportunity list.

### Step 6 — Identify the highest-leverage intervention zone (10–15 min)

Scan the complete map and answer: which stage carries the most emotional weight, the most unmet alternatives, and the most business consequence if unaddressed?

Apply two filters:
- **Customer stakes:** Which stage, if improved, would most change the emotional arc?
- **Business stakes:** Which stage, if improved, would most change the metric the team is accountable for (conversion, activation, retention, referral)?

Name one primary intervention zone before the map is handed off. A map that produces only a list of pain points without a named priority has done half the work.

## Examples

### Example 1 — Completed stage excerpt (B2B SaaS onboarding, "First-value seeker" persona)

```markdown
## Stage: Onboarding (signs up → completes first meaningful task)

**Actions**
- Completes sign-up form; receives welcome email; clicks through to product
- Watches onboarding video; skips it at 40 seconds
- Navigates to the main dashboard; looks for the import button
- Imports a file; gets an error about column headers; Googles the error
- Finds a support article; reformats the file; import succeeds
- Completes one task with imported data

**Touchpoints**
- Welcome email (owned)
- In-product onboarding checklist (owned)
- YouTube search (not owned)
- Support knowledge base (owned)
- Peer community forum thread from 2022 (not owned)

**Thoughts**
- "I thought this would be faster — why do I need to reformat a CSV?"
  [interview, n=6]
- "I don't know if I'm using this right or if the data looks weird on purpose"
  [support ticket theme, last 90 days]

**Emotions**
- Cautiously optimistic at sign-up → frustrated at import error →
  relieved when the support article resolves it, but trust has dropped
  [interview arc, n=8; emotion drop corroborated by 3-day session drop-off
  in analytics]

**Pain points**
- Import error is opaque; no in-product explanation of column format requirements
- Onboarding checklist doesn't adapt after the import step completes

**Opportunities**
- Customer can import any common file format without reformatting or leaving
  the product to find documentation
- Customer sees the checklist advance in real time as they complete tasks,
  confirming they're on the right path
```

**What makes this excerpt work.** Every thought has a citation type and evidence signal. The emotion entry traces the arc across the stage rather than assigning a single adjective. Pain points are specific events, not categories of dissatisfaction. Opportunities are stated in customer outcome language with no feature names.

### Example 2 — Counter-example: a UX flow masquerading as a journey map

A team building an expense-reporting feature produces this "journey":

```
Stage 1: User opens the expense form
Stage 2: User fills in amount and category
Stage 3: User attaches a receipt
Stage 4: User submits
Stage 5: User waits for approval
Stage 6: User gets reimbursed
```

This is not a customer journey map. It is a UX flow — a sequence of product interactions within a single feature session. There is no emotional arc across a relationship arc. There is no awareness stage, no competitive alternatives, no consideration of what the customer does when they are not in the product. The "stages" are UI states.

The diagnostic: if every stage takes place inside the product and the total arc completes in one session, it is a UX flow. A journey map covers touchpoints and channels outside the product and spans days, weeks, or months. For the expense-reporting feature, the real journey map would begin with "employee learns the expense policy has changed" and end with "reimbursement lands in their account and they trust the process will work next time." That arc includes stages outside the product and reveals opportunities a UX flow cannot surface.

## Common Pitfalls

### Pitfall 1 — Aggregate persona ("all users")

**Symptom.** The persona is "our users" or "enterprise customers" — no specific segment, no current context.

**Consequence.** The thoughts and emotions rows average across segments with incompatible journeys. A mid-market power user and a first-time enterprise admin have different emotional arcs at every stage. The averaged map produces observations no one can act on.

**Fix.** One map per meaningful persona. If the team resists this, name two customers by first name and ask: "Would both of them describe stage 3 the same way?" The disagreement exposes the need for separate maps.

---

### Pitfall 2 — Inferred emotions stated as findings

**Symptom.** The emotions row says "feels overwhelmed" or "excited" with no citation.

**Consequence.** The team treats the map as evidence when it is a hypothesis. Intervention priorities are set based on the team's projection, not the customer's experience. (Young's *Practical Empathy* frames this as the difference between empathy — grounded in the other person's perspective — and projection.)

**Fix.** Every emotion entry must have a source: interview quote, support ticket pattern, NPS verbatim, session-recording observation. Inferences should be labelled `[inferred — validate]`. A map with 40% inferences is still useful; a map that hides its inferences is not.

---

### Pitfall 3 — Touchpoints limited to owned channels

**Symptom.** The touchpoints row lists only the company's website, app, and email. Nothing outside the product.

**Consequence.** The map misses the touchpoints with the highest influence: peer recommendations, review sites, community forums, competitive trial periods. Interventions are designed for the channels the team controls, not the channels that actually drive behaviour.

**Fix.** Explicitly ask in discovery: "Where do you go when you're not sure how to proceed? Who do you ask?" The answer is usually not the company's own support site.

---

### Pitfall 4 — Opportunities stated as features

**Symptom.** The opportunity column says "build an automated import formatter" or "add a real-time checklist."

**Consequence.** The map collapses the discovery-to-delivery gap before it has been crossed. The opportunity list becomes a feature backlog rather than an input to solution exploration. Solutions are locked in at the map stage, before the team has considered alternatives.

**Fix.** Rewrite every opportunity as a customer outcome: "Customer can import without reformatting" not "build an import formatter." The solution exploration happens downstream, anchored to the opportunity.

---

### Pitfall 5 — Map treated as a one-time deliverable

**Symptom.** The journey map is produced once, presented to leadership, and archived. The team continues to build against it 18 months later, despite major product and market changes.

**Consequence.** Kalbach is explicit: alignment maps are living artifacts. A map that reflects the 2023 onboarding experience is not a useful input to 2025 planning. Out-of-date maps create false confidence — the team believes they understand the customer because the map exists.

**Fix.** Review the map at each major product change and quarterly otherwise. Torres' continuous-discovery cadence provides a structural home: new interview rounds feed the map; the map feeds the opportunity-solution tree.

---

### Pitfall 6 — Confusing the stage-level arc with a session-level flow

**Symptom.** Stages are UI states or task steps, not shifts in the customer's goal (see counter-example above).

**Consequence.** The "map" cannot reveal inter-stage friction, competitive alternatives, or emotional arc degradation over time — it only describes what happens inside the product during a single session.

**Fix.** Apply the test: does this stage span more than one session? Does it include touchpoints outside the product? If the answer to both is no, it is a UX flow. Useful, but not a journey map.

## References

- **Jim Kalbach** — *Mapping Experiences: A Complete Guide to Creating Value through Journeys, Blueprints, and Diagrams*, 2nd ed. (O'Reilly, 2020). Primary framework for this skill: the canonical stage/layer structure (ch. 3–5), the distinction between journey maps and service blueprints (ch. 6), and the alignment-as-living-artifact discipline (ch. 8). The six experience layers, the persona-anchoring requirement, and the intervention-zone identification step all trace directly to Kalbach.
- **Teresa Torres** — *Continuous Discovery Habits: Discover Products That Create Customer Value* (Product Talk Press, 2021). Opportunity-tagging discipline: opportunities are customer outcomes, not solutions. The map's output feeds an opportunity-solution tree. Torres' continuous-discovery cadence provides the structural home for keeping the map current.
- **Indi Young** — *Practical Empathy: For Collaboration and Creativity in Your Work* (Rosenfeld Media, 2015); **Beverly Newman** — foundational empathy-mapping practice. Evidence-citation discipline for the thoughts and emotions rows: the distinction between grounded empathy and projected inference. Applied in Step 4 and Pitfall 2.
- **Related Hornero skills:**
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD provides the durable job framing and competitive-alternatives lens that anchors the CJM's persona and alternatives fields. Run JTBD before the map when the team lacks a clear job statement.
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — the primary evidence source for the thoughts, emotions, and pain-points rows. If the team cannot populate those rows from existing research, run discovery interviews before building the map.
  - [`interview-synthesis`](../interview-synthesis/SKILL.md) — converts raw interview notes into the tagged themes and direct quotes that populate the map's evidence layer.
  - [`opportunity-solution-tree`](../opportunity-solution-tree/SKILL.md) — the natural downstream artifact. The map's opportunity list is the input to the OST; the OST structures the solution exploration that the map's highest-leverage intervention zone points toward.
  - [`proto-persona`](../proto-persona/SKILL.md) — prerequisite when no persona exists. The CJM requires a named persona; proto-persona is the minimum viable persona artifact.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/customer-journey-map) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
