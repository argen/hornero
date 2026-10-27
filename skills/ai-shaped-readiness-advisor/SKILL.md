---
name: ai-shaped-readiness-advisor
description: Use when a PM suspects their team is using AI tools without meaningfully changing how they work — to assess maturity across five AI-PM competencies and identify the highest-leverage capability gap to close first.
role: product-manager
intent: |
  Runs a structured maturity assessment across five AI-PM competencies —
  context design, agent orchestration, outcome acceleration, team-AI
  facilitation, and strategic differentiation — and produces a ranked
  recommendation for which competency to build next. Distinguishes between
  teams that have added AI tools (AI-first) and teams that have redesigned
  around AI as a structural capability (AI-shaped).
type: interactive
theme: ai-pm
best_for:
  - A PM or team that uses AI tools daily but hasn't seen strategic uplift
  - A product org trying to prioritise AI investment for the next quarter
  - A leader who needs an honest baseline before setting an AI transformation agenda
scenarios:
  - "My team uses Claude and Copilot everywhere but I'm not sure we're working any differently"
  - "I want to assess where we sit on AI maturity before next quarter's planning"
  - "Leadership is asking 'how AI-forward are we?' and I need a defensible answer"
estimated_time: "15-20 min"
---

# AI-shaped readiness advisor

> v0 draft. Anchored in Cagan (*Empowered*, four risks adapted for AI), Torres
> (*Continuous Discovery Habits*), and Doshi (PM judgment quality). Primary
> synthesis from Dean Peters' Substack research on AI-shaped product organisations
> (2026). Editorial review recommended before production use.

## Purpose

Most teams that adopt AI tools achieve efficiency gains, not structural advantage. They write PRDs faster, summarise research more quickly, and respond to stakeholders in less time. These are real gains — but they're table-stakes within months, because any competitor can replicate them by hiring or subscribing.

This skill draws that line sharply. **AI-first** is the efficiency lane: doing the same work faster with AI assistance. **AI-shaped** is the redesign lane: rebuilding how the team discovers, decides, and ships around AI as a native capability. The distinction matters because only the second creates durable competitive separation.

The advisor runs you through a maturity self-assessment across five competencies, synthesises a profile, then recommends the one competency with the highest unlocking leverage — the gap whose closure makes everything else more tractable.

## Key Concepts

### AI-first versus AI-shaped

The two states differ on what is being optimised:

| Dimension | AI-first | AI-shaped |
|-----------|----------|-----------|
| What changes | Task speed | How work gets done |
| Unit of improvement | Artifact creation | Learning cycles |
| AI's role | Writing assistant | Strategic co-intelligence |
| Defensibility | Months | Compounding over years |
| Example | "We use AI to draft PRDs 2× faster" | "We validate hypotheses in 48 h instead of 3 weeks" |

The test for AI-first: could a competitor match the capability by staffing up? If yes, it's efficiency, not moat.

---

### The five AI-PM competencies

These are the structural capabilities that separate AI-shaped teams from AI-first ones. They have a dependency order: competencies 1 and 2 are foundational; 3 and 4 build on them; 5 requires maturity across all four.

#### 1. Context design

The practice of building a **durable reality layer** — a structured, version-controlled body of constraints, definitions, and evidence standards that both humans and AI agents can trust and reference consistently.

Context design is not about volume. The failure mode — context stuffing — is pasting everything available into a prompt window and hoping attention lands on what matters. Context engineering is the inverse: deciding what to persist versus what to retrieve, who owns each boundary, and what information would actually change a decision if it changed.

Key artefacts: constraints registry, operational glossary, evidence standards document, two-layer memory architecture (conversational short-term + persistent long-term).

Cagan's four risks adapted for AI: without context design, **value risk** and **feasibility risk** assessments degrade because the AI is operating on assumptions, not on the team's actual constraints. Every output carries silent hallucination risk where structured context would have provided a guardrail.

#### 2. Agent orchestration

The practice of replacing one-off prompts with **repeatable, traceable workflows** — sequences where each step is defined, inputs and outputs are structured, and the reasoning at each step is auditable.

One-off prompting is tactical. It produces results that can't be reproduced, can't be reviewed at scale, and don't compound. Orchestrated workflows produce compound effect: a research → synthesis → critique → decision → rationale-log workflow run consistently produces an institutional knowledge base. The same prompt run ad hoc produces a chat history.

Version-controlled prompts and agents are the equivalent of version-controlled code: they make the workflow reproducible, improvable, and transferable across team members.

#### 3. Outcome acceleration

The practice of using AI to **compress learning cycles**, not to produce deliverables faster. The distinction is load-bearing.

Torres (*Continuous Discovery Habits*) frames continuous discovery as a rhythm of small, frequent experiments that reduce validation lag. AI reshapes that rhythm: feasibility spikes that took two weeks of engineering time can run overnight; user research synthesis that took a week can run in an hour; pre-validation against known constraints can happen before a meeting rather than during it. The bottleneck shifts from execution to decision-making.

Shipping faster without compressing learning produces the wrong thing faster. Outcome acceleration targets the learning cycle, not the production cycle.

#### 4. Team-AI facilitation

The practice of redesigning **team operating systems** so AI is integrated as co-intelligence — not used privately, not treated as a black box, not invoked as an accountability shield.

The Cagan *Empowered* framing applies directly: empowered teams have clear accountability for outcomes and use whatever tools are available to achieve them. Teams that use AI without review norms, evidence standards, or decision-authority clarity are not empowered — they've diffused accountability into a tool. The questions that matter: Who reviews AI outputs, and when? What does the team do when AI and human judgment diverge? Is psychological safety high enough for anyone to challenge an AI-produced recommendation?

#### 5. Strategic differentiation

The practice of using AI capabilities to create **competitive advantages that are structurally hard to replicate** — not just efficiencies that become table-stakes.

Differentiation requires new customer capabilities (what can users do that they couldn't before?), workflow rewiring that can't be replicated without re-architecting the operating model, or economics that competitors can't match without full restructuring. This competency can't be built before the others; it's the compounding effect of the prior four working together at scale.

---

### Dependency order

Context design is foundational: workflows built without durable context are fragile and produce unreliable outputs. Agent orchestration multiplies the value of good context and enables outcome acceleration. Team-AI facilitation can develop in parallel with 1–3 but is required for scale. Strategic differentiation emerges when the other four are at Level 3+.

Skipping the dependency order doesn't save time; it produces rework when the missing foundation forces a rebuild.

## Application

The skill gathers context through up to eight questions, scores each competency on a 1–4 scale, synthesises a maturity profile, and recommends a priority competency with a four-week action plan.

---

### Session start — choose your mode

Before the first context question, offer the user a heads-up and entry choice:

"This takes about 15–20 minutes and up to 13 questions (8 context + 5 scoring). How do you want to run it?

1. **Guided** — one question at a time; I'll adapt based on your answers.
2. **Context dump** — paste what you already know; I'll skip redundant questions and go straight to scoring gaps.
3. **Best-guess** — give me your role and primary goal; I'll flag my assumptions and keep moving."

Accept `1`, `2`, `3`, combinations, or free text mapping to the closest mode.

In best-guess mode, label every inferred item as `Assumption [High/Medium/Low confidence]` and include an Assumptions to Validate section in the final output.

---

### Step 1 — Context gathering (Questions 1–8, one per turn)

Show progress as `Context Q[n]/8` on every turn.

1. Which AI tools does your team use today?
2. How does your team typically use them — one-off prompts, saved templates, or multi-step workflows?
3. Who uses AI consistently — just you, the PM team, or cross-functional teams?
4. What's the size and stage of your team (approximate headcount and startup/growth/enterprise)?
5. How are decisions made — centralized, distributed, or consensus-driven?
6. What competitive advantage are you trying to build with AI?
7. What's the biggest bottleneck slowing your learning and iteration cycles right now?
8. Has your team established any shared review norms or evidence standards for AI outputs?

After question 8, summarise back in four lines: current AI usage pattern, team context, strategic intent, primary bottleneck. Confirm before scoring.

---

### Step 2 — Maturity scoring (Questions 1–5, one per turn)

Show progress as `Scoring Q[n]/5`. Present four levels per competency; user selects 1–4.

**Question 1 — Context Design**

Which best describes your team's context layer?

1. **Level 1** — No structured context. Prompts are assembled fresh each time; no shared constraints registry, glossary, or evidence standards.
2. **Level 2** — Some docs exist (PRDs, strategy memos) but they're not structured for AI consumption and aren't referenced consistently.
3. **Level 3** — Structured context is emerging: project instructions or a CLAUDE.md-style file, a partial constraints registry, defined evidence standards. Coverage is uneven.
4. **Level 4** — A durable reality layer is in place: constraints registry (20+ entries), operational glossary (30+ terms), evidence standards, two-layer memory architecture. AI agents reference these automatically.

**Question 2 — Agent Orchestration**

Which best describes your AI workflow maturity?

1. **Level 1** — Ad-hoc prompts typed as needed. No saved workflows or templates.
2. **Level 2** — Saved reusable prompts or custom projects, but each step is manual and isolated.
3. **Level 3** — Some multi-step workflows exist (research → synthesis → critique) but rely on manual handoffs between steps.
4. **Level 4** — Orchestrated workflows run consistently: each step is defined, traceable, version-controlled, and produces auditable reasoning.

**Question 3 — Outcome Acceleration**

Which best describes how AI affects your learning cycles?

1. **Level 1** — AI speeds up artifact creation (faster PRDs, quicker summaries). Learning cycles unchanged.
2. **Level 2** — AI accelerates research and synthesis. Modest reduction in discovery time, but validation lag is unchanged.
3. **Level 3** — AI compresses validation: feasibility checks and experiment analyses run in days rather than weeks. Applied unevenly.
4. **Level 4** — Learning cycles are systematically 5–10× faster: overnight feasibility checks, async AI synthesis replaces status meetings, automated validation against constraints before any build commitment.

**Question 4 — Team-AI Facilitation**

Which best describes how your team operates with AI?

1. **Level 1** — Individual usage, no shared norms. Team members use AI privately; no visibility into how or when.
2. **Level 2** — Team uses AI but no formal review process. "I used AI" mentioned casually; outputs treated as finals.
3. **Level 3** — Review norms are emerging: AI outputs are treated as drafts. Evidence standards are discussed but not codified.
4. **Level 4** — Clear operating norms: AI outputs require human review, evidence standards are codified, decision authority is explicit (AI recommends, humans decide), and team members can challenge AI outputs without friction.

**Question 5 — Strategic Differentiation**

Which best describes the competitive value of your AI capability?

1. **Level 1** — Efficiency only. AI helps the team work faster on existing tasks. A competitor could match it by adding headcount.
2. **Level 2** — New capabilities: AI enables work at a scale or speed that wasn't possible before, but a well-resourced competitor could replicate it.
3. **Level 3** — Workflow advantages: some processes have been redesigned around AI in ways that create measurable separation. Applied in pockets.
4. **Level 4** — Structural moat: customers have capabilities they can't get elsewhere, economics are 5× better than the industry baseline, and replication would require a full operating-model redesign.

---

### Step 3 — Maturity profile and priority recommendation

Synthesise scores into a profile table:

```
┌──────────────────────────────┬───────┬────────────────────┐
│ Competency                   │ Level │ Maturity           │
├──────────────────────────────┼───────┼────────────────────┤
│ 1. Context Design            │   X   │ [Label]            │
│ 2. Agent Orchestration       │   X   │ [Label]            │
│ 3. Outcome Acceleration      │   X   │ [Label]            │
│ 4. Team-AI Facilitation      │   X   │ [Label]            │
│ 5. Strategic Differentiation │   X   │ [Label]            │
└──────────────────────────────┴───────┴────────────────────┘

Overall: [AI-First | Emerging | Transitioning | AI-Shaped]
```

Level labels: 1 = AI-First, 2 = Emerging, 3 = Transitioning, 4 = AI-Shaped. Overall: average 1–1.5 = AI-First; 2–2.5 = Emerging; 3–3.5 = Transitioning; 3.5–4 = AI-Shaped.

Then apply dependency logic to recommend the priority competency:

- Context Design ≤ 2 → recommend Context Design regardless of other scores
- Context Design ≥ 3 but Orchestration ≤ 2 → recommend Agent Orchestration
- Context + Orchestration ≥ 3 but Outcome Acceleration ≤ 2 → recommend Outcome Acceleration
- Usage is individual, not team-wide → recommend Team-AI Facilitation in parallel with the above
- All others ≥ 3 → recommend Strategic Differentiation

Present three options:

1. **Accept recommendation** — I'll provide a four-week action plan for the priority competency.
2. **Override priority** — You choose a different competency; I'll warn about any dependency gaps and proceed.
3. **Parallel tracks** — I'll design simultaneous workstreams if the profile supports it.

---

### Step 4 — Four-week action plan

Deliver a concrete four-week plan for the selected competency. Each week has 2–4 specific, named deliverables, not principles.

**Context Design plan:** Week 1: constraints registry (10+ entries, version-controlled). Week 2: operational glossary (20+ terms). Week 3: evidence standards document + context boundary owners assigned. Week 4: two-layer memory architecture piloted on one active workflow; Research → Plan → Reset → Implement cycle tested.

**Agent Orchestration plan:** Week 1: map your most frequent AI use case step by step. Week 2: design a workflow loop (research → synthesis → critique → decision → rationale log) with structured inputs and outputs. Week 3: implement and run on three historical examples; compare to manual baseline. Week 4: version-control prompts; document for team replication.

**Outcome Acceleration plan:** Week 1: time-map your current learning cycle; identify the slowest step. Week 2: design an AI workflow targeting that bottleneck (overnight feasibility check, async synthesis, etc.). Week 3: pilot on one live initiative; measure before/after cycle time. Week 4: if cycle time reduced ≥50% with quality maintained, apply to two more initiatives; document.

**Team-AI Facilitation plan:** Week 1: codify one rule — AI outputs are drafts, not finals — and share it with the team. Week 2: set evidence standards (AI must cite sources; reject outputs that don't). Week 3: define decision authority (AI recommends, named role decides; escalation path for disagreements). Week 4: run a team exercise surfacing one AI mistake caught — normalise critical engagement.

**Strategic Differentiation plan:** Week 1: list five things your team could do with AI that a competitor couldn't replicate by adding headcount. Week 2: pick the most defensible candidate; design an end-to-end AI-enabled workflow for it. Weeks 3–4: build a proof-of-concept (PoL probe, not production); test with five customers; assess defensibility.

## Examples

### Fully worked conversation — growth-stage B2B SaaS

**Context gathered:**
- Tools: Claude Projects, Notion AI, GitHub Copilot
- Usage pattern: saved Claude templates for discovery synthesis, one-off prompts for everything else
- AI users: 3 PMs and some engineers; designers not using it
- Team: 12 PMs, 60 engineers, 8 designers; growth stage
- Decision-making: distributed by team, centralised for strategy
- Strategic goal: validate product hypotheses faster than larger competitors
- Primary bottleneck: discovery takes 3–4 weeks; by the time findings land, the sprint is already committed
- Review norms: informal — "treat AI stuff as a draft" is understood but not written down

**Scoring Q1/5 — Context Design:**
> PM selects Level 2. "We have PRDs and strategy docs but they're not structured for AI. Nothing is a constraints registry."

**Scoring Q2/5 — Agent Orchestration:**
> PM selects Level 2. "We have saved Claude templates for synthesis but each step is manual."

**Scoring Q3/5 — Outcome Acceleration:**
> PM selects Level 2. "Research is faster but the validation lag is exactly the same."

**Scoring Q4/5 — Team-AI Facilitation:**
> PM selects Level 3. "Informally understood norms. Not codified."

**Scoring Q5/5 — Strategic Differentiation:**
> PM selects Level 2. "We can analyse more feedback than before but a well-resourced competitor could do the same."

**Profile:**

```
┌──────────────────────────────┬───────┬──────────────┐
│ Competency                   │ Level │ Maturity     │
├──────────────────────────────┼───────┼──────────────┤
│ 1. Context Design            │   2   │ Emerging     │
│ 2. Agent Orchestration       │   2   │ Emerging     │
│ 3. Outcome Acceleration      │   2   │ Emerging     │
│ 4. Team-AI Facilitation      │   3   │ Transitioning│
│ 5. Strategic Differentiation │   2   │ Emerging     │
└──────────────────────────────┴───────┴──────────────┘

Overall: Emerging (average 2.2)
```

**Recommendation:** Context Design first. Context is at Level 2 and the gap is foundational — the 3–4 week discovery lag the PM named as the primary bottleneck can't be systematically compressed by agent orchestration until AI workflows have durable constraints and evidence standards to validate against. Without that layer, orchestrated workflows are fast but fragile.

**Options presented — PM selects option 1 (accept).**

**Four-week plan delivered:**
- Week 1: Create a constraints registry for the current product area — technical limits, pricing constraints, regulatory requirements, strategic no-goes. 10+ entries, in a structured file the PM and engineering lead both review.
- Week 2: Build an operational glossary — "activation," "engaged user," "churn," "customer," and 15 more terms defined unambiguously, including edge cases.
- Week 3: Write an evidence standards document (what counts as "validated" for this team: how many interviews, what data threshold, what competitive signal). Assign context boundary owners — who maintains each section.
- Week 4: Pilot the Research → Plan → Reset → Implement cycle on one discovery workstream. After the research phase, synthesise into a SPEC.md, reset the context window, implement using only the spec. Measure: fewer hallucinated constraints, faster feasibility checks, less repeated context in prompts.

**After four weeks:** Context Design moves to Level 3. Agent Orchestration becomes the next priority — the PM now has a structured context layer that workflows can reliably reference, which unblocks the 3–4 week discovery lag directly.

## Common Pitfalls

### Speed theatre

**Symptom.** The team ships faster and reports "AI transformation is working." When asked what's changed structurally, the answer is "we write PRDs in an hour instead of a day."

**Consequence.** Efficiency gains are real but temporary. Competitors observe the same benefits from their AI tooling subscriptions within a quarter. No structural separation is created. Leadership satisfaction erodes when the revenue needle doesn't move.

**Fix.** Track learning-cycle compression, not artifact-production speed. The right question is: how long does it take from hypothesis to validated signal? If that number hasn't changed, the team is AI-first.

---

### Skipping context design

**Symptom.** The team builds multi-step workflows but results are inconsistent — the same workflow produces different quality outputs depending on who runs it and what they pasted in.

**Consequence.** Orchestrated workflows built on a context-free foundation are fragile. When the constraint or product definition changes, every prompt breaks. The team spends as much time patching context as it would have spent on manual work.

**Fix.** Context design is not optional scaffolding — it's the foundation. Build the constraints registry and glossary before investing in workflow orchestration. Workflows that reference structured context survive product pivots; workflows built on ad-hoc context don't.

---

### Individual transformation without team adoption

**Symptom.** One PM (usually the one running this assessment) is highly AI-shaped. The rest of the team isn't. When that PM is unavailable, the capability disappears.

**Consequence.** The advantage is personal, not organisational. It can't scale, can't be recruited to, and doesn't survive team changes. Leadership rightly perceives it as a single point of failure rather than a team capability.

**Fix.** Team-AI Facilitation is a parallel priority from the moment individual usage is established. Review norms, evidence standards, and decision-authority clarity aren't bureaucratic overhead — they're how the capability survives beyond one person.

---

### Using tools as the proxy for AI-shaped

**Symptom.** The team debates whether to use Claude or ChatGPT, which LLM is best for synthesis, which plugin to install. A lot of evaluation energy, no structural change.

**Consequence.** The tool selection is a distraction from the actual work, which is redesigning how decisions are made, how learning cycles run, and what counts as validated. No tool choice closes a context-design gap.

**Fix.** Deprioritise tool selection decisions until at least one competency is at Level 3. The tools are the implementation detail; the workflow design is the work.

---

### Confusing new capabilities with defensible advantage

**Symptom.** "We can now analyse 10× more user feedback than before" is reported as competitive advantage.

**Consequence.** Capability expansion is not a moat unless competitors face a structural barrier to replication. If a competitor can match the capability by subscribing to the same tool, it's table-stakes, not differentiation.

**Fix.** Apply the "staffing test": could a competitor replicate this capability in six months by hiring or subscribing? If yes, treat it as table-stakes and continue building toward Level 4. Strategic differentiation requires workflow rewiring that competitors can't match without full operating-model redesign.

---

### Scoring optimistically without evidence

**Symptom.** The team scores themselves at Level 3 or 4 across multiple competencies, but when asked to name a specific artefact (constraints registry, workflow documentation, evidence standards), none exists.

**Consequence.** The maturity profile is inflated; the action plan targets the wrong gap; the team invests in Level 4 strategic differentiation work while the foundation is missing.

**Fix.** Maturity scores should be anchored to named artefacts and measurable behaviours, not to intent or self-perception. Level 3 on Context Design means a constraints registry exists with 10+ entries and is referenced in prompts — not "we think about constraints before prompting."

## References

- **Marty Cagan** — *Empowered: Ordinary People, Extraordinary Products* (2020, Wiley). The four-risk framework (value, usability, feasibility, business viability) used in this skill as a diagnostic lens for AI-PM gaps. Cagan's definition of empowered teams — accountable for outcomes, with clear authority and capability to use whatever tools are available — is the governing model for Team-AI Facilitation.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017, Wiley). Original four-risks framing; the product discovery principles underlying Outcome Acceleration.
- **Teresa Torres** — *Continuous Discovery Habits* (2021, Product Talk). The continuous discovery rhythm that AI reshapes under Outcome Acceleration: weekly touchpoints, assumption mapping, rapid experiment cycles. Torres' evidence that frequent small bets outperform infrequent large ones is the argument for compressing learning cycles, not build cycles.
- **Shreyas Doshi** — LNO framework (Leverage / Neutral / Overhead) and PM judgment-quality methodology. Doshi's distinction between tasks where quality of execution matters (Leverage) versus tasks where completion matters (Neutral) shapes how this skill frames AI's highest-return application: compressing the Leverage tasks, not automating the Neutral ones.
- **Dean Peters** — "AI-First Is Cute. AI-Shaped Is Survival" (Dean Peters' Substack, 2026). The AI-first / AI-shaped distinction and the five-competency model are the structural scaffolding for this skill's assessment framework.
- **Dean Peters** — "Context Stuffing Is Not Context Engineering" (Dean Peters' Substack, 2026). The context stuffing / context engineering distinction underlying Competency 1; the five diagnostic questions for context boundary design.
- **Related Hornero skills:**
  - [`prd`](../prd/SKILL.md) — PRDs are the downstream artefact of AI-shaped discovery. A team at Level 3+ on Outcome Acceleration produces PRDs grounded in validated evidence, not assumption.
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — once the maturity profile is clear, use prioritization-advisor to triage competing AI-investment options against capacity and strategy anchor.
  - [`success-metrics`](../success-metrics/SKILL.md) — each competency's success criteria should be anchored to a real metric. Use success-metrics to define how you'll know the competency has moved.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — the four-week action plans produced by this skill map to bets. Use bet-portfolio to size, sequence, and resource them against the portfolio.
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — Strategic Differentiation (Competency 5) requires a diagnosis of the specific competitive crux AI addresses. Use strategy-kernel before investing in Level 4 differentiation work.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/ai-shaped-readiness-advisor) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
