---
name: proto-persona
description: Use when a team needs a lightweight, hypothesis-shaped persona to scope a problem or align on a target user before research is available — not a research-backed persona.
role: product-manager
intent: |
  A proto-persona is a structured assumption about who the team is building for.
  It is not a validated persona: it is the best current hypothesis, built from
  whatever signals exist today — sales calls, support tickets, market reports,
  stakeholder memory — and designed to be tested and replaced. Use it to move
  forward with a shared target user when waiting for full research would stall
  design, scoping, or prioritisation decisions.
type: component
theme: discovery
best_for:
  - Early-stage product work where user research hasn't started yet but the team needs a shared reference point
  - Kicking off a discovery sprint and needing to make research-targeting decisions explicit
  - Aligning stakeholders on who the primary user is before roadmap or PRD work begins
scenarios:
  - "PM starting discovery on a new product area with only sales anecdotes and market reports — needs a working user hypothesis before interview recruitment"
  - "Cross-functional team disagreeing on who they're building for — proto-persona makes the assumption explicit so it can be argued and tested"
  - "Feature ideation session where everyone is picturing a different user — proto-persona gives the conversation a shared anchor"
estimated_time: "2–4 hours (team working session); 45 minutes (PM solo from existing signals)"
---

# Proto-persona

> v0 draft. Anchored in Gothelf & Seiden (*Lean UX*, O'Reilly) for the four-quadrant structure and the hypothesis framing; Cooper (*About Face*) for the persona-vs-archetype distinction; Torres (*Continuous Discovery Habits*) for the path from proto-hypothesis to research-validated understanding. Editorial review recommended before production use.

## Purpose

Produce a named, structured user hypothesis that gives the team a concrete target for design, scoping, and interview recruitment — before user research is complete.

The output is a four-quadrant artifact: who this user is, what they do and need, where they feel pain, and what solutions might resonate. Each field is a testable assertion, not a fact. The artifact earns its place by making the team's current assumptions explicit and arguable. An unspoken assumption is worse than a written one: it drives decisions invisibly and cannot be challenged.

A proto-persona is not a demographic profile. It is not a marketing persona. And it is not a validated persona — it has not been built from systematic research. Its job is to focus early work and surface the gaps in understanding that research must fill. The moment the team treats it as truth, it becomes dangerous.

Distinct from a validated persona: a validated persona is built from structured research — multiple interview rounds, synthesis, pattern confirmation. It is stable over months and carries design authority. A proto-persona is built in hours from available signals; it is stable only until the next interview contradicts it. The upgrade path from proto to validated runs directly through `discovery-interview-prep` and `interview-synthesis`.

Distinct from JTBD: a JTBD statement captures the durable job and the competitive alternatives. A proto-persona captures the human carrying that job — their context, behaviours, and the friction they experience today. They are complementary. A proto-persona without a JTBD statement risks describing who someone is without explaining what drives them. Run `jobs-to-be-done` in parallel or just before.

## Key Concepts

### The four-quadrant shape (Gothelf & Seiden)

Gothelf & Seiden (*Lean UX*, ch. 3) define the proto-persona as a four-quadrant canvas deliberately structured to surface both the human and the hypothesis:

**Quadrant 1 — Who they are.** Name, role, and a brief biographical sketch. Enough context to picture the person. Not a demographic census — only the details that bear on how they encounter the problem. Age range, job title, industry, and a line or two about how they work day-to-day. The test: if you strip this quadrant, can you still reason about the other three? If yes, you have too much here.

**Quadrant 2 — Behaviours and needs.** What this person actually does, moment to moment, in the context your product touches. Specific, observable actions — not aspirations or job-description language. What tools they use. What their typical workflow looks like. What they reach for when something needs doing. Gothelf & Seiden's key move: anchor this quadrant in behaviour, not attitude. Attitudes are inference; behaviours are observable.

**Quadrant 3 — Pain points and frustrations.** Where the current workflow breaks down. What they complain about. Where they waste time, lose confidence, or make decisions on bad information. The discipline here is specificity: "frustrated with reporting tools" is not a pain point. "Spends 90 minutes every Monday manually pulling metrics from three tools into a spreadsheet that's out of date by Thursday" is a pain point.

**Quadrant 4 — Potential solutions.** What directions might address the pain. This is the one place in the artifact where solutions are permitted — and the framing is deliberately tentative: potential, not committed. The quadrant tests whether the pain points are specific enough to generate plausible solution directions. If you cannot generate any solution directions from the pain points, the pain points are still too vague.

### Proto-persona vs full persona (Cooper)

Alan Cooper (*About Face*, ch. 5) introduced the persona as a precision instrument: built from extensive field research, populated with verbatim quotes, grounded in observed behaviour across many interviews, and stable enough to make design authority claims. A Cooper-style validated persona takes weeks to produce and carries the weight of systematic evidence.

The proto-persona trades that rigour for speed. It does not replace the Cooper persona; it occupies the space before the Cooper persona exists. The key discipline — which Cooper himself would recognise — is the obligation not to confuse the two. A proto-persona used as if it were a validated persona is worse than no persona at all: it provides false confidence and blocks the research that would actually answer the questions.

The practical difference: a validated persona can resolve a design disagreement. A proto-persona can only frame one. If the team is using the proto-persona to settle arguments rather than to raise testable questions, they are misusing the artifact.

### The hypothesis obligation (Gothelf & Seiden)

Gothelf & Seiden are explicit: the proto-persona is a hypothesis, not a finding. That framing is not cosmetic — it has two operational consequences.

First, every field in the canvas is provisional. The team should be able to write `[ASSUMPTION — VALIDATE]` next to any field they are not confident about. A canvas with no assumption tags probably has not been scrutinised honestly.

Second, every proto-persona should generate a research plan. The purpose of making the assumptions explicit is to know which ones to test first. The highest-stakes assumption — the one that, if wrong, would change the product direction — becomes the first interview question. If the proto-persona doesn't generate a research question, it has not been used correctly.

### From proto to validated (Torres)

Teresa Torres (*Continuous Discovery Habits*, ch. 4-5) describes how teams build genuine customer understanding through continuous, structured interviewing — weekly conversations that accumulate into a richly textured picture of real users. The proto-persona is the entry point to that system, not the destination.

Torres' discipline: assume the proto-persona is wrong in at least one material way. Go find out which way. Update the artifact after every interview round. The proto-persona should have a version number and a last-updated date. If neither exists, the team is treating a hypothesis as a fact.

## Application

Six steps; team working session 2–4 hours, PM solo 45 minutes from existing materials.

### Step 1 — Convene the assumptions (15–30 minutes)

Before touching the canvas, surface what the team already believes about the target user. Go around the room (or async): who do you think we're building for? What do you think they do? What do you think they struggle with?

The goal is not consensus — it is an inventory of assumptions. Disagreement at this stage is the most valuable thing the session can produce: it means the team has been making different decisions based on incompatible user models, and those divergences need to be named before they drive more work.

If the team cannot generate even a rough sketch of who the user might be, the proto-persona session is premature. Route to secondary research first: find three to five similar products' documented user types, pull relevant market reports, or read the last six months of support tickets.

### Step 2 — Name the person (10 minutes)

Give the persona a first name and a role. The name does two things: it makes the artifact easier to reference in conversation ("would Miriam do this?"), and it forces the team to commit to a specific type of person rather than a category. Avoid job-title-only labels — "Enterprise Admin" is a role, not a person. "Miriam, IT lead at a 200-person SaaS company" is a person.

One proto-persona per session. If the team is arguing about two completely different users, run the session twice — once for each — and then decide which is primary. Starting with two simultaneously produces a blended artifact that is accurate for neither.

### Step 3 — Fill the behaviours and needs quadrant first (20–30 minutes)

Counter-intuitive but important: fill quadrant 2 before quadrant 1. Starting with biography produces a demographic profile; starting with behaviour produces a work model. The question is not "who is this person" but "what does this person do, moment to moment, in the context we care about?"

Prompts:
- What does a typical Tuesday morning look like for them, at the part of the job our product touches?
- What tools do they open without thinking?
- What do they have to do manually that they wish they didn't?
- What decisions do they make that they're not confident about?

Write behaviours as observable actions: "opens a spreadsheet," "copies metrics from three tabs," "sends a Slack message to ask for a status update." Not: "values efficiency" or "is data-driven."

Once the behaviour quadrant has enough specificity, fill the biographical quadrant. You will find it easier — the biography now has something to explain rather than something to invent.

### Step 4 — Develop the pain points (15–20 minutes)

For each behaviour in quadrant 2, ask: where does this break down? Where does the friction live? Where does the person lose time, make a mistake, feel uncertain, or work around the system?

Apply the specificity test: a good pain point can be verified in an interview by asking "does this happen to you?" and getting a yes/no answer followed by a specific example. "Frustrated with reporting" fails the test. "Spends 90 minutes on Monday pulling metrics from three tools before the weekly meeting, and the numbers are already stale by Tuesday" passes it.

Mark every pain point with a confidence tag: `[HIGH]` (witnessed or heard repeatedly), `[MED]` (heard once or inferred from analogous products), or `[ASSUMPTION]` (team belief without direct evidence). The distribution of tags tells you where the research plan needs to focus.

### Step 5 — Generate potential solutions (10–15 minutes)

For each high-confidence pain point, write one or two solution directions. Keep them directional, not specified: "reduce the manual steps in the Monday reporting pull" rather than "a dashboard that auto-refreshes." The point is to test whether the pain points have design affordance — if you cannot imagine any solution direction, the pain point is still under-specified.

This quadrant is the most volatile: it is the first to be revised as research accumulates. Treat it as a seed for the `opportunity-solution-tree`, not as a feature list.

### Step 6 — Tag assumptions, plan the research (15 minutes)

Review the complete canvas. For every field where the team's confidence is medium or low, add `[ASSUMPTION — VALIDATE]`. Count the assumption tags. If fewer than a third of fields are tagged, the team is either very well-informed (unlikely before research) or has not been honest (more likely).

Assign the three to five highest-stakes assumptions to interview questions and add them to the recruitment brief for `discovery-interview-prep`. The highest-stakes assumption is the one that, if wrong, would change the product direction most significantly.

Set a review date. The proto-persona should be updated after every interview round, not after a quarterly planning cycle. If it is still unchanged after six interviews, either the canvas is so vague it accommodates anything, or no one is updating it.

## Examples

### Example 1 — Worked proto-persona (B2B operations analytics)

**Context.** Early-stage startup building an operations analytics tool for mid-market logistics companies. No user research yet. Four interviews scheduled for next week. Team needed a shared user hypothesis to align on interview recruitment and question design.

```markdown
# Proto-persona — v0.1 (last updated: 2026-05-16)
# Research status: 0 interviews complete

## Who they are
**Priya, Operations Manager** at a regional logistics company (80–300 employees).
Has been in ops for 6–10 years. Reports to the COO. Manages a team of 3–6
dispatchers and analysts. Comfortable in spreadsheets; uses the company's TMS
daily but knows it doesn't give her what she needs. [ASSUMPTION — VALIDATE: role
title and seniority may vary by company size]

## Behaviours and needs
- Opens three browser tabs every morning: TMS dashboard, a Google Sheet with
  weekly KPIs, and Slack.
- Pulls delivery performance data from the TMS into the Sheet manually each
  Monday (30–45 min). [HIGH]
- Shares a weekly ops summary with the COO via email; builds it by copying
  from the Sheet and writing narrative. [MED]
- Makes carrier routing decisions based on the prior week's on-time rates;
  doesn't have access to real-time performance data. [MED]
- Escalates driver or carrier issues reactively — finds out something went
  wrong from a dispatcher or a customer complaint, not from the data. [ASSUMPTION]

## Pain points and frustrations
- **Monday reporting pull is 30–45 minutes of manual copy-paste** that produces
  data already 5 days stale when she uses it to make routing decisions. [HIGH]
- **No visibility into in-flight delivery status** without asking a dispatcher
  or calling the carrier. [MED]
- **COO asks questions the Sheet can't answer** — "how did carrier X perform
  in the Northeast last quarter?" — and Priya has to go back to raw TMS exports
  and rebuild the cut. [MED]
- **Attribution is unclear when things go wrong** — late delivery, damaged
  goods — because the TMS data doesn't capture the full event chain. [ASSUMPTION]

## Potential solution directions
- Automated daily/weekly performance digest that replaces the manual Sheet pull.
  [tied to pain 1]
- Real-time carrier performance view with configurable thresholds and alerts.
  [tied to pain 2 and 3]
- Investigation workflow that traces a delivery event back through the carrier
  and driver records. [tied to pain 4]
```

**What makes this proto-persona useful.** The behaviours are specific and observable — the Monday reporting pull with a time estimate is the kind of detail that can be confirmed or refuted in one interview question. Pain points are graded by confidence: two are `[HIGH]` (heard repeatedly from analogous contexts), two are `[MED]` (inferred from product-category patterns), one is `[ASSUMPTION]` (team belief without evidence). The solution directions are directional, not specified, and linked to specific pain points. The version number and last-updated date signal that this is a hypothesis under active management.

---

### Example 2 — Counter-example: demographics-soup masquerading as a persona

```markdown
# User persona — Operations Professional

**Demographics:** 28–45 years old. Located in major metro areas. Bachelor's or
master's degree. $70k–$120k salary. Uses LinkedIn regularly. Has 2–3 direct
reports.

**Goals:** Wants to be seen as a strategic thinker. Cares about career growth.
Values work-life balance. Wants tools that are easy to use.

**Frustrations:** Frustrated with complexity. Dislikes manual work. Wants
better reporting.

**Personality:** Detail-oriented. Collaborative. Data-driven.
```

**What's wrong here.** The demographic fields — age range, salary, degree level — carry no product-design information. A 28-year-old ops manager and a 45-year-old ops manager at the same company face the same Monday reporting problem; their age tells you nothing. The goals section is aspirational self-description, not observable behaviour: "wants to be seen as strategic" could describe any knowledge worker. The frustrations are categories, not pain points — "dislikes manual work" cannot be confirmed or refuted in an interview, and it does not tell you which specific manual task to target. The personality attributes are the most common demographic-soup move: they sound like insight but predict no behaviour. "Data-driven" and "detail-oriented" are traits every B2B team attributes to its target user; they discriminate nothing.

This artifact changes no downstream decision. It will not help the team write an interview guide, scope a problem, or resolve a design disagreement. It is a persona-shaped object, not a proto-persona.

## Common Pitfalls

### Pitfall 1 — Demographics without behaviour

**Symptom.** The canvas is dominated by age ranges, locations, salary bands, and education levels. Behaviour and needs fields are either missing or filled with attitude language: "values efficiency," "is tech-savvy."

**Consequence.** Cooper's persona-vs-archetype failure mode: a demographic profile is a statistical archetype, not a person. It cannot answer "would Priya do this?" because it describes a population, not a decision-maker. Design decisions built on demographic profiles average across incompatible users.

**Fix.** Audit the canvas: for each field, ask whether an observer could verify it by watching the person work for an hour. "Copies data from TMS to spreadsheet every Monday" passes. "Values efficiency" fails. Replace every attitude claim with its behavioural equivalent or delete it.

### Pitfall 2 — Treating the proto-persona as research

**Symptom.** The team refers to the proto-persona in planning or design discussions as if its contents were confirmed: "our users don't want X" or "Priya definitely needs Y." No one flags the assumption tags. The canvas has no version number or last-updated date.

**Consequence.** Torres' core warning: treating a hypothesis as a finding blocks the research that would actually validate or refute it. Teams build confidence incrementally — confidence that is not earned from evidence. The proto-persona becomes a bias amplifier rather than a discovery tool.

**Fix.** Establish a norm at the first session: every statement about the proto-persona in conversation is prefaced with "we believe" or "we're assuming." Update the canvas after every interview round. If an interview refutes a field, update the field in the canvas and note the source. A canvas that doesn't change across ten interviews is not a learning artifact — it is a fixed assumption dressed as discovery.

### Pitfall 3 — Multiple primary users collapsed into one canvas

**Symptom.** The team is building for both an end user and an admin, or both a buyer and a practitioner, and has tried to represent both in a single proto-persona by writing "and/or" in the role field or averaging the two behaviour patterns.

**Consequence.** The resulting artifact is accurate for neither user. Pain points from two distinct roles conflict with each other; solution directions point in opposing directions; interview targeting is confused.

**Fix.** If there are two genuinely distinct users (different roles, different contexts, different pain points), produce two proto-personas — one for each — and explicitly designate a primary. The primary is the person whose unmet needs, if served, most directly drive business outcomes. Use the `opportunity-solution-tree` to manage the scope implications of a two-persona discovery programme.

### Pitfall 4 — Fabricated or marketing-copy quotes

**Symptom.** The canvas includes a "voice of the customer" section filled with polish-sounding phrases: "I need a solution that helps me work smarter, not harder" or "I just want everything in one place."

**Consequence.** Gothelf & Seiden's caution applies here: the proto-persona should surface assumptions, not manufacture empathy. Fabricated quotes produce false familiarity — the team feels they "know" the user when they have only heard themselves. These quotes also tend to be so generic that they support any product direction, providing no discriminating signal.

**Fix.** If you have real quotes from sales calls, support tickets, or prior interviews, use them and cite the source. If you don't have any, leave the field blank and mark it `[PLACEHOLDER — NEEDS RESEARCH]`. A blank field is more honest and more useful than a fabricated one.

### Pitfall 5 — Proto-persona as a research substitute

**Symptom.** The team creates a proto-persona and then delays or eliminates the planned research sprint: "we already know who we're building for." The canvas version number stays at v0.1 for three months.

**Consequence.** The proto-persona was built to accelerate research targeting, not replace it. An unvalidated proto-persona that drives a full PRD cycle is a hypothesis producing a product — with no feedback loop to catch the gap between assumed and actual user needs.

**Fix.** Make the research plan non-negotiable at the end of the canvas session (Step 6). Write the first three interview questions before the session closes. If the team is unable to schedule interviews, that is a resource constraint that should be escalated — not resolved by treating the proto-persona as validated. Torres' continuous discovery cadence is the long-run answer: weekly or fortnightly customer conversations that keep the persona current.

### Pitfall 6 — Pain points too vague to generate research questions

**Symptom.** The pain points quadrant contains entries like "manual work," "bad reporting," "too many tools," or "slow processes." No confidence tags. No specificity about which manual work, which reports, which tools.

**Consequence.** A vague pain point cannot be confirmed or refuted in an interview. You cannot ask a customer "do you experience bad reporting?" and get a useful answer. The interview fails to produce evidence, and the canvas never advances beyond v0.1.

**Fix.** For each pain point, write a test question: the exact interview question you would ask to verify or refute it. If you can't write the question, the pain point is not specific enough. Rewrite until the test question is answerable with a yes/no plus an example. "Does the Monday performance pull take more than 30 minutes? Tell me about the last time you did it" is testable. "Do you experience pain around reporting?" is not.

## References

- **Jeff Gothelf & Josh Seiden** — *Lean UX: Designing Great Products with Agile Teams* (2013, 3rd ed. 2021, O'Reilly). The four-quadrant proto-persona structure used in this skill — who they are, behaviours and needs, pain points, potential solutions — is drawn from Gothelf & Seiden's hypothesis-driven design system. Their framing of the proto-persona as a testable assumption (not a research finding) is the load-bearing conceptual distinction in Key Concepts and Pitfall 2.
- **Alan Cooper** — *About Face: The Essentials of Interaction Design* (4th ed. 2014, Wiley; original framework 1999). Cooper's systematic persona methodology — field research, verbatim evidence, design authority — is the validated-persona standard that the proto-persona deliberately defers to. The persona-vs-archetype critique (Pitfall 1) traces to Cooper's observation that demographic profiles describe populations, not people, and therefore cannot resolve design disputes.
- **Teresa Torres** — *Continuous Discovery Habits: Discover Products That Create Customer Value* (2021, Product Talk Press). Torres' continuous interview cadence is the upgrade path from proto-persona to genuine user understanding. Her framing — assume you are wrong about at least one material thing; go find which one — grounds the hypothesis obligation in Key Concepts and the version-control discipline in Pitfall 2. The research plan step (Step 6) is operationalised from her weekly-discovery model.
- **Related Hornero skills:**
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD provides the durable job and competitive alternatives that explain *why* the proto-persona behaves as they do. Run JTBD in parallel or just before to ensure the behaviours quadrant is anchored in a job, not just a workflow description.
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — the natural downstream of a proto-persona session. The assumption tags from Step 4 and the test questions from Step 6 feed directly into interview guide construction.
  - [`problem-framing-canvas`](../problem-framing-canvas/SKILL.md) — the proto-persona names the user; the problem-framing canvas names the specific problem that user has. Run both before drafting a PRD: the proto-persona feeds the "who has the problem" field in the canvas.
  - [`opportunity-solution-tree`](../opportunity-solution-tree/SKILL.md) — the potential solutions quadrant (quadrant 4) is a seed for the OST, not a commitment. Once the proto-persona's pain points are validated through interviews, migrate the solution directions into the OST for structured exploration.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/proto-persona) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
