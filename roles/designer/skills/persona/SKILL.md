---
name: persona
description: Use when a designer needs to produce a goal-directed persona (Cooper methodology) — a specific, scenario-bound representation of a target user grounded in research, not invented to justify a decision already made.
intent: |
  Produces a goal-directed persona anchored in research evidence. The
  persona names specific goals, mental models, scenarios, expertise levels,
  and environmental constraints for a real user type. It is the design
  team's primary tool for resisting the "average user" trap — the
  statistical average nobody actually is. Cooper's core argument: design
  for one specific person; the design that serves them well will serve
  the broader audience far better than the design optimised for nobody
  in particular.
type: component
theme: ux-craft
best_for:
  - A new product or feature whose target user is contested or vague
  - A redesign where "users want X" masks real goal-level disagreement
  - A team that keeps over-designing by designing for itself
  - A feature where usability risk is the primary risk (Cagan's four risks)
scenarios:
  - "Defining the persona before designing a complex multi-step onboarding flow"
  - "Resolving a team dispute about which user type the feature primarily serves"
  - "Grounding a design critique — 'does this serve Maya, our primary persona?'"
  - "Producing the persona a PM uses to validate JTBD and the designer uses to validate interaction patterns"
estimated_time: 60-120 minutes (research synthesis + first draft); 20-30 minutes (review of existing persona)
---

# Persona

> v0 draft. Grounded in Alan Cooper's *About Face: The Essentials of Interaction Design* (1995, rev. 2014) and *The Inmates Are Running the Asylum* (1999); Erika Hall's *Just Enough Research* (2013, rev. 2019) on the research basis for personas; Don Norman's *The Design of Everyday Things* on mental models and conceptual models. Cross-references the product-manager's `jobs-to-be-done` skill — JTBD names the durable job; the persona names the specific person doing it.

## Purpose

Produce a goal-directed persona that can anchor design decisions for a specific user type. The persona is not a marketing segment. It is not a statistical composite. It is not invented post-hoc to justify the design already drawn.

Cooper's argument, still correct after thirty years: the human mind cannot hold a crowd in focus while designing. Designing for "all users" produces interfaces that serve no user well. Pick one person — specific, scenario-bound, grounded in interview evidence — and design for them. The resulting design will transfer to the broader audience better than any average-optimised approach.

The persona operationalises the designer's answer to: *who is the one person I am designing this for right now, and what does that person need to accomplish?*

**Distinction from jobs-to-be-done:** JTBD (the PM's tool) asks "what durable job is the user hiring this product to do?" That job is abstract and stable — it doesn't change with demographics or context. The persona asks "who, specifically, is doing this job right now, and what is their mental model, scenario, and environment?" Both are needed. JTBD sets the goal; the persona sets the context in which the interaction design must work. See `roles/product-manager/skills/jobs-to-be-done/SKILL.md`.

## Key Concepts

### Cooper's goal-directed design

Alan Cooper (*About Face*, *The Inmates Are Running the Asylum*) introduced the goal-directed persona as a design tool, not a marketing artifact. Three types of goals structure the persona:

- **End goals** — what the user wants to *accomplish*. The terminal state of success from the user's perspective. "I want to know whether my order shipped." Not "I want to use the tracking page."
- **Experience goals** — how the user wants to *feel* during the interaction. "I don't want to feel stupid." "I want to feel in control." These are rarely stated aloud but govern reaction when the interaction fails.
- **Life goals** — who the user wants to *be*. Longer-horizon identity goals that the product can support or undermine. Less relevant for task-focused B2B tools; highly relevant for consumer and identity-adjacent products.

The interaction design exists to serve end goals without violating experience goals. When a design fails to feel "right," the experience goal is usually what's broken.

### Hall's research basis

Erika Hall (*Just Enough Research*): a persona that isn't grounded in real user interviews is a fiction, and fictions are actively harmful because they carry the same apparent authority as evidence-based personas. Teams that have produced research-backed personas have an unfair advantage over teams that invented theirs.

"Just enough" research: three to five research sessions (interviews, observation, contextual inquiry) per distinct user type will surface the patterns that matter for design decisions. Hall's discipline prevents both research-as-delay (running studies for months before designing anything) and design-as-assumption (designing without any research at all).

Minimum evidence for a persona: at least three real user interviews, with direct quotes to support each attributed goal and constraint. Personas without traceable evidence are anti-patterns.

### Norman's mental model and conceptual model

Don Norman (*The Design of Everyday Things*): the user's *mental model* — their internal picture of how a system works — rarely matches the *conceptual model* the designer intended. The gap between the two is where most interaction failures live.

The persona must capture the user's mental model explicitly, not assumed-away. "Maya thinks 'save' and 'sync' are the same action" is a meaningful mental-model statement. It has direct design implications (don't distinguish save and sync in the UI unless you're willing to invest in teaching that distinction). A persona without a mental-model section is leaving out the most design-generative information.

### The "average user" anti-pattern

The most common failure in persona practice: the "average user" persona. Statistically summarising survey responses produces a person who doesn't exist — 34 years old, moderate tech comfort, uses both mobile and desktop, has mild accessibility needs. Nobody is the average across all axes simultaneously.

Cooper's prescription: find the *most demanding user type* whose goals align with the product's purpose, and design for them. The interface that works for a cognitively-loaded, time-pressed, non-expert user will work for everyone less constrained. The interface designed for the median tech-savvy user will fail the user who needs it most.

The designer's own mental model is the most dangerous average. Designers are not users; they know the system, know the jargon, and have never experienced the confusion of encountering it for the first time. The persona is the countermeasure.

### One primary persona per design surface

Cooper's rule: a surface can have at most one primary persona. If it has two, the design will have two competing interaction models, and neither persona will be fully served. Secondary personas can exist — users who will use the surface and whose needs must not be violated — but they do not get to pull the design in their direction. If secondary needs conflict with the primary persona's needs, the primary persona wins, unless the conflict represents a blocker for the secondary user (safety, access, legality).

### Usability risk as one of Cagan's four risks

Marty Cagan identifies four product risks: value (will users buy it?), usability (can users figure out how to use it?), feasibility (can we build it?), and viability (does it work for the business?). The persona is the designer's primary tool for making usability risk concrete. "Can users figure out how to use it?" cannot be answered without specifying who the user is. The persona converts the abstract risk into a testable question: "Can Maya — who has this mental model, operates in this environment, and has these goals — figure out how to use it?"

## Application

### Step 1 — Anchor in research

Before writing any persona text, gather the evidence:

- **Interview or observation notes** — minimum three sessions per persona; preferably five. Note exact quotes (not paraphrases) for goals, frustrations, and stated mental models.
- **Contextual observations** — what environment does this user type operate in? What devices, physical settings, multitasking constraints, interruption patterns?
- **Existing product data** — usage logs, support tickets, NPS verbatims. These don't replace interviews (they show *what* users do, not *why*) but they validate the interview patterns.

If you have no research, note that fact explicitly in the persona. An unresearched persona is a hypothesis, not a tool. Treat it as such — use it to generate testable assumptions, not to close design debates.

### Step 2 — Identify the user type

From the research, identify distinct user types — clusters of users who share goals and constraints meaningfully. The clustering criterion is *goals and mental model*, not demographics.

- Bad clustering: "Users aged 25-34 with college education." That's a segment.
- Good clustering: "Users who are expert in the domain but non-expert in this software tool." That's a goal-and-model cluster that has direct design implications.

Name the distinct types. Pick the one whose goals most directly align with the primary design challenge. That is the primary persona.

### Step 3 — Draft the persona using the template

```markdown
# Persona — <Name>

- **Designer:** <name>
- **Research basis:** <list of evidence — interviews, observations, data sources; how many sessions; date range>
- **User type:** <short label — e.g., "domain expert, software novice" or "task-focused re-user">
- **Primary or secondary:** <primary | secondary>
- **Surface(s) this persona anchors:** <list of features / flows / screens>
- **Status:** Hypothesis (no research) | Draft (partial research) | Validated (≥3 interviews) | Stale (>6 months since update)
- **Last updated:** <YYYY-MM-DD>

---

## Goals

### End goals
<What the persona wants to accomplish. Specific outcomes, not activities.
"Confirm the order shipped and when it arrives" — not "track my order."
Two to four, ranked by importance.>

### Experience goals
<How the persona wants to feel during the interaction. State in first person.
"I don't want to feel like I made a mistake." "I want to stay in control."
One to three. Source at least one from a direct user quote.>

### Life goals (optional)
<Only for consumer products or identity-adjacent surfaces. Who does this
person want to be? What self-image does the product support or threaten?>

---

## Mental model

<How the persona *thinks* the system works, regardless of how it actually
works. Specific, concrete, potentially wrong.>

<Examples of mental-model statements that have design implications:>
- <"Maya thinks 'drafts' are saved automatically; she has never pressed a Save button.">
- <"Soren believes 'undo' doesn't work after a save, so he is afraid to try things.">
- <"Priya expects search to find things by context and synonym, not exact string match.">

<Include the gaps: where does the persona's mental model diverge from the
system's conceptual model? Those gaps are where the interaction design must
bridge or educate.>

---

## Scenario

<The canonical scenario — the realistic, specific situation in which this
persona encounters the surface. Written as narrative, present tense.>

<Example:>
> It's Wednesday morning. Maya has just finished a call with her client and
> has 10 minutes before her next one. She opens the app to check whether the
> draft she sent yesterday was approved. She's on her laptop, but she's already
> thinking about the next meeting. She does not remember where the draft-approval
> flow lives; she navigated there before but not recently.

<The scenario should capture: time pressure, environment, emotional state,
prior history with the product, and what triggers the session. It should
make design constraints obvious without stating them explicitly.>

### Scenario — failure case

<A second scenario: what happens when the surface fails this persona? What
does they do? What do they feel? What do they tell their colleagues?>

---

## Expertise levels

| Dimension | Level | Evidence |
|---|---|---|
| Domain expertise (the work itself) | Expert / Intermediate / Novice | <source> |
| Software expertise (computers in general) | Expert / Intermediate / Novice | <source> |
| Product expertise (this specific tool) | Expert / Intermediate / Novice | <source> |
| Mobile fluency (for mobile surfaces) | Expert / Intermediate / Novice | <source> |

<Distinguish these four — a domain expert can be a product novice; a
software expert can be a domain novice. The design implications are different.>

---

## Environmental constraints

<Physical and situational constraints on this persona's use. Not
demographics — constraints.>

- **Device:** <primary device(s); screen size assumptions>
- **Network:** <connection assumptions — fast/slow/intermittent>
- **Attention:** <single-task focus or frequent interruptions?>
- **Physical environment:** <desk / commute / outdoor / loud / low-light>
- **Time per session:** <typical session duration and frequency>
- **Accessibility constraints:** <permanent, temporary, or situational — vision, motor, cognitive; none-known is a valid entry>

---

## Frustration inventory

<What frustrates this persona type in the domain, based on research evidence.
These become the usability risks the design must not introduce.>

- <Direct quote or paraphrase from interview — attributed to source session.>
- <…>

---

## What this persona does NOT represent

<Who is explicitly not this persona. The exclusions sharpen the design
focus; without them, the persona expands to include everyone.>

<Examples:>
- <"This persona is not the administrator who configures the system — they have a separate persona.">
- <"This persona is not a first-time-ever user; they've seen similar tools before.">

---

## Open questions

<Each owned, with a date. What would change this persona if answered?>

- <Question (Owner, YYYY-MM-DD).>
```

### Step 4 — Self-review against five checks

1. **Research-basis check.** Every goal and constraint has an evidence source. Personas without sources are hypothesis-only; they must be labelled as such.
2. **Mental-model specificity check.** At least two specific, concrete, possibly-wrong beliefs about the system are stated. "Generally comfortable with technology" is not a mental model.
3. **Scenario vividness check.** A team member who reads the scenario can feel the time pressure and context. "Maya is a busy professional" is not a scenario.
4. **Anti-average check.** The persona is not a demographic median. Ask: does this person literally exist in the research notes? If the answer is "sort of," the persona is probably an average.
5. **Primary-persona singularity check.** There is one primary persona for this surface. If two personas have equal claim, the design scope may be too broad. Resolve before proceeding.

### Step 5 — Review with the team

Walk the persona with the PM (does it map to the JTBD?), the engineer (feasibility constraints — especially environmental and device constraints), and the researcher if there is one. Surface disagreements explicitly rather than silently averaging them into the persona.

A disputed persona is better than a falsely-agreed one. Disputes reveal either genuine uncertainty about the user (solvable with more research) or genuine disagreement about product direction (solvable by PM with a decision).

### Step 6 — Reference the persona in design decisions

A persona that isn't referenced in design decisions is an artifact, not a tool. The discipline: in every design critique, every heuristic review, every state audit, name the persona explicitly. "Does this serve Maya?" is the question, not "does this feel right?"

When a design change is made to serve a secondary persona at the cost of the primary persona's experience, name that trade-off explicitly. It may be the right call — but it should be a deliberate one with a record, not a silent accumulation of compromises.

## Examples

### Example 1 — Validated persona (good, abridged)

```markdown
# Persona — Maya Chen

- **Research basis:** 4 contextual interviews (2024-09 through 2024-10); 12 support tickets coded by theme; NPS verbatim analysis (n=82 low-scoring).
- **User type:** Domain expert (clinical research coordinator), product novice.
- **Primary for:** Document-upload and approval flow.
- **Status:** Validated.

## Goals

### End goals
1. Confirm whether a submitted document has been reviewed — without emailing the reviewer.
2. Know the next action she needs to take, without having to navigate to figure it out.

### Experience goals
- "I don't want to feel like I've made a mistake and not noticed." (Direct quote, Interview 3.)
- "I want to feel like the system is on my side."

## Mental model

- Maya believes documents have three states: "submitted," "reviewed," and "rejected." She is not aware of the "under revision" state the system uses internally. When a document enters "under revision," she interprets the lack of "reviewed" status as the reviewer being slow.
- She believes clicking "back" from a form will lose her work. She is wrong — the form auto-saves — but she has never discovered this, and her behaviour (copying text to a notepad before navigating) reflects the wrong belief.

## Scenario

It's Friday afternoon. Maya has four documents pending review and a 5pm deadline. She opens the document-management tool on her work laptop. She has used it weekly for three months; she knows the main document list but is unfamiliar with the notification settings. She wants to know, in 60 seconds, which of her four documents need her attention before 5pm.

She does not remember where the status filter lives. She remembers it exists because she used it once. She will try to find it; if she can't find it in two navigations, she will scan the list manually.

## Expertise levels

| Dimension | Level | Evidence |
|---|---|---|
| Domain expertise (clinical research) | Expert | 8 years as CRC; interviews |
| Software expertise | Intermediate | "I'm okay with software, not power-user"; Interview 2 |
| Product expertise | Novice-intermediate | Weekly use for 3 months; onboarded without training |

## Environmental constraints

- **Device:** Work-issued Windows laptop, external monitor; occasionally on iPad during site visits.
- **Network:** Office network (fast); hospital site networks (slow, sometimes blocked).
- **Attention:** Frequent interruptions; multiple deadlines in flight; average session 2-5 minutes.
- **Time per session:** 2-5 minutes; returns to the tool 4-6 times per day.
- **Accessibility constraints:** None observed in interviews; situational: often under time pressure equivalent to cognitive load.
```

The design decision that follows directly: the document-status UI must surface "what needs Maya's attention right now" in the first visible element — not buried behind a filter she has to find. The mental-model gap (three states vs. the system's five) means the status labels must map to her model, not the system's internal model.

### Example 2 — Anti-pattern persona (bad)

```markdown
# Persona — Average User

- Age: 28-45
- Tech comfort: moderate
- Uses the product 2-3 times per week
- Wants a fast, simple experience
- Has accessibility needs (mild)
```

Failures: no research basis; demographic median, not a goal cluster; no goals stated (end, experience, or life); no mental model; no scenario; no constraints; "mild accessibility needs" is meaningless; "fast and simple" is designer projection, not user evidence. This persona will not settle any design dispute and will not prevent any usability failure.

### Example 3 — Mental-model gap driving a concrete design decision

A persona for a file-sync app notes: *"Soren believes 'undo' only works before he closes the file. He never attempts to undo an action after saving."* This single mental-model statement drives the design directly: the undo-history affordance must be visible in the closed/saved state — because Soren will never look for it unless prompted. The persona justifies a design decision that might otherwise look like over-engineering.

## Common Pitfalls

### Pitfall 1 — Invented personas

**Symptom:** The persona was produced before or instead of user research. Goals match the feature backlog. No direct quotes exist.

**Consequence:** The persona has the appearance of user-centeredness while encoding designer assumptions as fact. It will be used to close debates that should stay open. Hall calls this "doing research theatre."

**Fix:** Label all unresearched personas explicitly as hypotheses with a status of "Hypothesis." Use them to generate interview questions, not to justify design decisions. Replace with validated personas before launch.

### Pitfall 2 — Persona stuffing

**Symptom:** The primary persona was written after the design was complete. Goals happen to match exactly what the design does. No goal conflicts surface.

**Consequence:** The persona is decorative. Anti-patterns from ROLE.md: "Inventing personas to justify the design that's already drawn."

**Fix:** Write the persona before the design. Use it as a design constraint, not a design validator. If the persona's goals conflict with the current design, that conflict is information — don't smooth it away.

### Pitfall 3 — Average-user persona

**Symptom:** The persona is a statistical composite. Demographic midpoints. Moderate everything. No specific scenario.

**Consequence:** Designing for the average produces UIs nobody actually uses. Interfaces optimised for moderate tech comfort fail both experts (too much hand-holding) and novices (too little help). Cooper's argument since 1999.

**Fix:** Find the most demanding realistic user type. Design for them. The design that serves a time-pressed, attention-divided domain expert will serve the less-constrained user too — the reverse is not true.

### Pitfall 4 — Demographic clustering

**Symptom:** User types are segmented by age, gender, geography, or job title rather than by goals and mental model.

**Consequence:** Two people with the same demographics may have opposite mental models; two people with different demographics may share the same goal cluster. The wrong clustering produces personas that don't generate design implications.

**Fix:** Cluster by goal + mental model. "Expert in the domain, novice in this software" is a useful cluster. "25-34, urban, college-educated" is not.

### Pitfall 5 — No mental model

**Symptom:** The persona describes what the user does, not what they believe the system does.

**Consequence:** The most design-generative information is missing. Mental-model gaps are where interaction failures live. A persona without them cannot predict failure points.

**Fix:** Include at least two specific, concrete, potentially-wrong beliefs about the system. Source them from research ("she said she thought the sync was only triggered on save — Interview 4"). These become the design constraints that prevent the most common user confusion.

### Pitfall 6 — Persona not referenced in design decisions

**Symptom:** The persona exists. It is never mentioned in critiques, reviews, or handoff notes. Reviewers do not ask "does this serve [persona name]?"

**Consequence:** The persona is an artifact with no authority. The design drift that personas prevent — toward team preferences, executive preferences, reviewer aesthetics — proceeds unchecked.

**Fix:** Establish the persona as a design constraint in the project's working agreements. Every design critique includes the question: "Does this serve [primary persona name]?" Deviations are explicit decisions with records, not silent drift.

### Pitfall 7 — Stale persona

**Symptom:** The persona was written eighteen months ago. The product has changed significantly. The persona is still the primary reference.

**Consequence:** Design decisions are being validated against a user type that no longer exists or no longer encounters the product in the same context.

**Fix:** Personas have a shelf life. Flag them as "Stale" when six months have passed without a review. Re-interview when the product or user environment has changed materially. A stale persona is better retired than silently trusted.

## References

- **Alan Cooper** — *About Face: The Essentials of Interaction Design* (rev. ed. 2014); *The Inmates Are Running the Asylum* (1999). The origin of goal-directed personas as a design tool. See `roles/designer/sources.md`.
- **Erika Hall** — *Just Enough Research* (2013, rev. 2019). The research discipline that gives personas evidentiary authority; the minimum-viable-research framing. See `roles/designer/sources.md`.
- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); mental model vs. conceptual model; gulf of evaluation. See `roles/designer/sources.md`.
- **Related Hornero skills:**
  - `roles/product-manager/skills/jobs-to-be-done/SKILL.md` — JTBD names the durable job; the persona names the person doing it. Use both; use them at different moments. JTBD sets direction; persona sets interaction constraints.
  - [`heuristic-review`](../heuristic-review/SKILL.md) — heuristic review is anchored to a persona; findings should cite "this fails Maya's experience goal."
  - [`accessibility-audit`](../accessibility-audit/SKILL.md) — the persona's environmental constraints and accessibility constraints feed the inclusive-design extension pass.
  - [`design-review`](../design-review/SKILL.md) — the workflow that references the persona as one of its evaluation anchors.
  - [`component-proposal`](../component-proposal/SKILL.md) — component proposals should reference which persona's goals the component serves.
