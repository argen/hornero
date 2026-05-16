---
name: context-engineering-advisor
description: Use when an AI workflow is producing vague, inconsistent, or expensive output — to diagnose whether the root cause is context stuffing and to redesign the information architecture grounding the AI.
intent: |
  Context engineering is not prompt writing. It is the deliberate design of
  what information an AI receives, in what structure, at what moment — treating
  the model's attention as a scarce resource rather than a bucket to fill.
  Context stuffing (volume without intent) and context engineering (structure
  with purpose) produce different reliability curves at scale; this skill
  diagnoses where a PM's workflow sits on that curve and moves it toward the
  engineering end.
type: interactive
theme: ai-pm
best_for:
  - Diagnosing why an AI workflow is inconsistent or expensive despite having "all the information"
  - Designing the information architecture for a multi-step AI agent or product feature
  - Deciding what to persist, what to retrieve on demand, and what to delete from a context setup
scenarios:
  - "I paste the entire PRD every time and Claude still gives hedged non-answers — what's broken?"
  - "Our agent chain is costing 10× what we budgeted and the outputs are getting worse as the knowledge base grows"
  - "I need to architect context for a new AI workflow in my product — where do I start?"
estimated_time: "20-40 minutes"
---

# Context engineering advisor

> v0 draft. Primary conceptual grounding: Andrej Karpathy (context engineering
> as a systems discipline), Anthropic (contextual retrieval, prompt caching),
> Drew Breunig (context budgets and retrieval tradeoffs), and Latent Space
> podcast / Simon Willison (practitioner documentation of failure modes).
> Dean Peters synthesised these threads for PM practitioners; that synthesis
> is the proximate source. Hornero re-expresses it in its own voice under MIT.
> Editorial review recommended before production use.

## Purpose

Diagnose whether an AI workflow is suffering from **context stuffing** — feeding volume in place of structure — and redesign the information architecture so the model's attention is concentrated on what the current decision actually requires.

This is not about which model to use or how to phrase prompts. It is systems design: what information enters the context window, how it is chunked and sequenced, when it is retrieved rather than persisted, and when the window should be cleared entirely. A workflow with correct context architecture will outperform the same workflow with better prompts but broken architecture.

The scope is PM-relevant: designing AI product features, running agent workflows for discovery and synthesis, and evaluating AI-assisted product decisions. The framing applies equally to personal tool use and to product architecture decisions.

## Key Concepts

### Context stuffing vs. context engineering

The distinction Andrej Karpathy drew publicly: "context stuffing" is the reflex of adding more — more documents, more history, more background — on the theory that completeness improves output. Context engineering is the discipline of deciding *what the model needs to attend to for this specific task*, then delivering only that.

The failure mode of stuffing is not that the model complains. It is that attention dilutes silently. Research on long-context performance (including Anthropic's own evaluations) shows a "lost in the middle" pattern: content at the beginning and end of a context window is weighted higher than content in the middle. A 100-page context with the load-bearing two paragraphs buried in the middle performs worse than a four-page context with those paragraphs near the top — even though the larger context "contains more information."

The economic model differs too. Context stuffing treats tokens as storage. Context engineering treats tokens as a budget for scarce attention. These are not equivalent, and optimizing for one degrades the other.

| Dimension | Context stuffing | Context engineering |
|---|---|---|
| Mindset | Volume = quality | Structure = quality |
| Default move when output is bad | Add more context | Fix the structure |
| Persistence policy | Persist everything just in case | Retrieve with stated intent |
| Agent handoff | Pass full prior context downstream | Define what the next agent actually needs |
| Failure response | Retry until it works | Diagnose and restructure |
| Cost model | Context as storage (cheap to add) | Context as attention (expensive to dilute) |

### The context budget

Drew Breunig's framing: every model invocation has a **context budget** — a finite window, but more importantly a finite attention capacity within that window. The PM's job is to allocate that budget against the decision being made, the same way a product budget is allocated against a strategy rather than spread evenly across all possible initiatives.

Budget allocation forces three explicit choices:

1. **Persist or retrieve?** Core constraints, operational definitions, and user preferences that apply to 80%+ of interactions belong in the persistent layer. Historical documents, prior PRD versions, and past research transcripts belong in a retrieval layer — fetched on demand by query relevance, not pre-loaded regardless of relevance.

2. **Retrieve what, for what decision?** Retrieval without intent is stuffing through a different mechanism. RAG that returns 50 chunks per query has the same dilution problem as manually pasting 50 documents. Contextual Retrieval (Anthropic's technique of prepending a brief explanatory frame to each chunk before embedding it) improves retrieval precision materially — the chunk arrives with its own context, not just its content.

3. **When to reset?** Context accumulates noise over a long session: dead ends, revised hypotheses, superseded data. The Research → Plan → Reset → Implement cycle (described in Application below) treats a context reset as a deliberate architectural move, not a sign of failure. Compressing research into a high-signal plan artifact, then starting a fresh session with only that artifact, eliminates what might be called context rot — the gradual degradation of output quality as session length grows.

### System context, task context, user context

Three distinct layers, each with a different persistence and ownership model:

- **System context** — the product's invariants: technical constraints, regulatory requirements, operational glossary, non-negotiable design decisions. Owned by the team; changes slowly; persisted in the model's system prompt or a fixed retrieval store. If this is missing, the model hallucinates constraints.
- **Task context** — the specific decision at hand: the PRD under review, the discovery sprint objective, the prioritisation session's items. Owned by the session; changes per invocation; injected at task-start and discarded when the task ends.
- **User context** — preferences, working style, role, prior decisions the user has expressed. Implemented as persistent memory across sessions (vector store, semantic retrieval). Changes slowly; retrieved by relevance rather than dumped wholesale.

Most stuffing happens because these three layers are conflated: everything ends up in the same place, ownership is implicit, and no one has defined the eviction policy.

### The five diagnostic questions

Before redesigning any context setup, these questions identify where the architecture is broken. Each maps to a failure mode:

1. **What specific decision does this context support?** If the answer is "I want the AI to understand my product generally," that is not a decision — it is stuffing bait. Context must be anchored to a task.
2. **Can this be retrieved rather than persisted?** Everything retrieved just-in-time that is not retrieved in more than 20% of interactions should not be in the persistent layer.
3. **Who owns the context boundary?** If no one is accountable for what is in vs. out, the window grows indefinitely. Assign ownership. Audit quarterly.
4. **What breaks if this specific piece is excluded?** The falsification test. If no concrete failure mode can be named, the context element is probably noise.
5. **Is adding context masking a structural problem?** Stuffing often compensates for ambiguous documentation, undefined terms, or conflicting sources. The fix is to resolve the ambiguity, not add more context around it.

## Application

This skill runs as a four-question diagnostic with a synthesis and action plan at the end. Work through the steps in sequence; each answer informs the next question.

---

### Step 1 — Describe the workflow and its symptoms

Before scoring anything, describe the AI workflow and what is going wrong.

Questions to answer (briefly; bullet responses are fine):

- What is the workflow doing? (PRD writing, discovery synthesis, agent chain for recommendations, etc.)
- How is context currently provided? (paste docs, project memory, custom system prompt, RAG, etc.)
- What are the symptoms? Choose from:
  1. Vague or hedged answers despite providing "all the context"
  2. Inconsistent outputs — works sometimes, not others
  3. Retrying prompts 3+ times to get a usable result
  4. Token costs escalating without accuracy improving
  5. Agent chain outputs degrading as the chain gets longer
  6. No clear symptoms — workflow is OK but I want to design it properly from the start

If you selected 3 or more of options 1–5, proceed directly to Step 2. If you selected option 6, skip to Step 4 (architecture design rather than diagnosis).

---

### Step 2 — Apply the five diagnostic questions

Work through each question against your specific workflow. For each, the goal is a one-sentence answer — not a framework exercise, but a concrete statement that will survive review.

**Q1 — What is the decision?**
Complete this sentence: "I need this context because I am deciding \_\_\_\_, and without \_\_\_\_ I cannot make that decision."
If you cannot complete it, the context is structurally unanchored.

**Q2 — Persist or retrieve?**
For each major block of context, classify it:
- Always-needed (applies to 80%+ of invocations) → persist
- Episodic (applies to ≤20% of invocations) → retrieval layer
- Neither → candidate for deletion

**Q3 — Who owns the boundary?**
Name the person or team accountable for context inclusion decisions. If the answer is "everyone" or "no one," that is the failure. Assign it.

**Q4 — Falsification test**
For each context element, complete: "If I remove \_\_\_\_, then \_\_\_\_ breaks in \_\_\_\_ scenario."
A vague completion ("the AI might not understand the product as well") is not a failure mode — it is a comfort preference. Only concrete, scenario-specific completions justify inclusion.

**Q5 — Structural mask check**
Is any context element present because the underlying document it summarises is ambiguous, conflicting, or undefined? If yes, the upstream document needs to be fixed. The context addition is a workaround, not a solution.

After completing these five questions, you will have a list of:
- Context elements to delete (failed Q4)
- Context elements to move from persist to retrieval (Q2 reclassification)
- Structural problems to fix before any context redesign will hold (Q5)
- An ownership assignment (Q3)

---

### Step 3 — Classify the failure mode

Based on Steps 1 and 2, the workflow's problem is most likely one of:

1. **Unanchored context** — no specific decision driving what's included; context is "general product knowledge." Fix: anchor every element to a named task; discard everything else.
2. **Persist/retrieve collapse** — episodic data (historical PRDs, old interview transcripts) is in the always-on layer, crowding out the task-specific context. Fix: build a retrieval layer; move historical data out of persistent context.
3. **No context boundary owner** — the window has grown organically; nobody has accountability for what's in it. Fix: assign ownership, document the manifest, schedule a quarterly audit.
4. **Context rot in a long session** — a research or multi-step session has accumulated noise (dead ends, superseded hypotheses) that is now competing with the current task. Fix: implement the Research → Plan → Reset → Implement cycle described below.
5. **RAG as stuffing** — retrieval is implemented but returns too many chunks per query (no precision filtering), or chunks lack context (plain text snippets with no framing). Fix: reduce top-k to 3–5 chunks; implement Contextual Retrieval if chunk boundaries are ambiguous.

Select the failure mode that best fits. If more than one applies, address them in the order listed — unanchored context is the root; the others are downstream.

---

### Step 4 — Design or redesign the architecture

With the failure mode(s) identified, design the target architecture using the three-layer model:

**System context (persist)**
Document the invariants that apply to every invocation: product constraints, regulatory requirements, key definitions, non-negotiable decisions. Aim for compression: this layer should be dense and short — a 500-word constraints manifest beats a 5,000-word background doc.

**Task context (inject per session)**
Define what gets added at task-start and discarded at task-end. This layer is decision-anchored: it contains only what the stated task requires.

**User/episodic context (retrieve)**
Historical documents, prior research, past decisions. Retrieved by semantic query, not pre-loaded. Define the retrieval precision: how many chunks per query? What metadata filters? What freshness cutoff?

**Reset policy**
For workflows that span multiple phases (research, synthesis, implementation), define when the context window resets. The Research → Plan → Reset → Implement cycle is: gather broadly in the research phase (large, noisy window is acceptable); synthesise into a high-signal plan artifact (a PLAN.md or SPEC.md that is the single source of truth); clear the context window; start the implementation session with only the plan artifact. The reset is the architectural move that prevents context rot from compounding.

Produce a **Context Manifest** — a short document that records:

```markdown
# Context manifest — [workflow name]

## System context (always persisted)
- [List invariants: constraints, glossary, non-negotiables]

## Task context (injected per session)
- [List what gets added per task type]

## Episodic/retrieval (fetched on demand)
- [List sources, top-k per query, freshness policy]

## Excluded (with reason)
- [What is explicitly out and why — so the team can hold the line]

## Owner: [Name]
## Next review: [Date + 90 days]
```

---

### Step 5 — Synthesise and prioritise actions

Produce a three-tier action plan:

**This week (immediate fixes)**
- Delete everything that failed the Q4 falsification test
- Apply the Research → Plan → Reset → Implement cycle to the next multi-phase workflow
- Write the Context Manifest — even a rough first draft creates accountability

**Next two weeks (foundation)**
- Move episodic data to a retrieval layer (even a manual "fetch the document when you need it" policy is better than always-on persistence)
- Define operational glossary if undefined terms are appearing in AI outputs
- Assign context boundary owner formally

**Within the month (architecture)**
- Implement Contextual Retrieval for any RAG setup (Anthropic's technique: prepend a brief context fragment to each chunk before embedding)
- Tune top-k: start at 3, test at 5, resist the reflex to go higher
- Instrument token usage and output consistency as leading metrics on context health

## Examples

### Worked example — discovery synthesis workflow (context rot diagnosis)

**Situation.** A PM at a growth-stage B2B company uses Claude for discovery synthesis. The workflow: paste 8–12 user interview transcripts plus the current PRD, ask for insight themes. It worked well for the first few sprints. Now (12 sprints in) the outputs are vague and inconsistent; the PM has started retrying 3–4 times per synthesis.

**Diagnostic run.**

Q1 (decision anchor): "I am deciding which user pain points to prioritise for the next roadmap cycle." The decision is clear. But the context has expanded sprint-over-sprint — the PM has added each new PRD version to the project memory, so the AI now has 12 versions of the PRD plus a growing library of past synthesis outputs.

Q4 (falsification): Asked about each context element, the PM can name concrete failures only for the current PRD version, the current sprint's interview transcripts, and the product's technical constraints. The past 11 PRD versions, the archived synthesis outputs, and the competitive research from Q1 all fail the test — no concrete failure mode if removed.

Q5 (structural mask): The current PRD has three conflicting definitions of "active user" that were never reconciled. The PM has been adding more context around this to help the AI "understand the nuance," which is the structural mask pattern.

**Diagnosis.** Persist/retrieve collapse (failure mode 2) compounded by context rot (failure mode 4). The structural ambiguity (Q5) is driving the PM toward more stuffing rather than fixing the source.

**Action plan.**
- Immediate: delete all PRD versions except current; delete archived synthesis outputs; delete Q1 competitive research.
- This week: reconcile the three "active user" definitions in the PRD — the AI's inconsistency is partly a reflection of genuine document ambiguity.
- Next sprint: implement Research → Plan → Reset → Implement. Run the synthesis session (research phase), write a one-page THEMES.md (plan), clear project memory, start the PRD update session with only THEMES.md as input.
- Architecture: use retrieval only for past interview quotes when a specific theme requires validation — not the full transcripts always-on.

**Outcome signal.** Token usage per synthesis drops roughly 70%. The PM stops retrying because the window no longer contains 11 versions of context competing with the current task. The "active user" reconciliation produces an immediate quality improvement — showing that the stuffing was masking a document problem, not compensating for it.

---

### Worked example — agent chain (RAG as stuffing)

**Situation.** A product team has built a three-agent chain for competitive analysis: Agent A (research) → Agent B (synthesis) → Agent C (recommendations). They use a vector store with 3,000 company documents. Each agent receives the full prior agent's output plus its own retrieval results (top-k = 50 per query). The chain started well and has degraded over six months as the knowledge base has grown.

**Diagnostic run.**

Q1 (decision anchor): Each agent has a clear decision, but the handoff spec says "pass the full context so Agent B has everything Agent A found." That is stuffing logic built into the architecture.

Q2 (persist/retrieve): The 3,000-document knowledge base has no freshness policy — competitive data from 3 years ago ranks equally with data from last week.

Q4 (falsification): Agent B needs a 2–3 page synthesis from Agent A, not Agent A's full research window. Agent C needs Agent B's recommendation shortlist, not Agent B's synthesis in full.

**Diagnosis.** RAG as stuffing (failure mode 5) compounded by no context boundary at agent handoffs (failure mode 3).

**Restructure.**
- Reduce top-k from 50 to 5 per query; add a recency filter (documents older than 18 months require explicit recall, not default inclusion).
- Agent A outputs: a 2-page structured brief (named decision, top 3 findings, confidence rating per finding). This becomes Agent B's sole input — not the full research context.
- Agent B outputs: a recommendation shortlist with rationale (one page). This becomes Agent C's input.
- Implement Anthropic's Contextual Retrieval: each document chunk in the store is prefixed with a brief summary of the document it comes from, so retrieval returns chunks that are self-contextualising.
- Assign context boundary owner (Lead PM); document each agent's input/output spec; review quarterly.

## Common Pitfalls

### Pitfall 1 — "Infinite context" marketing taken literally

**Symptom.** The team responds to quality degradation by increasing the context window. The phrase "1M token context window" is invoked as a solution.

**Consequence.** Long-context performance does not scale linearly with window size. Attention dilutes; the "lost in the middle" effect compounds; latency and cost increase without accuracy gains. Anthropic's own research shows accuracy degrading substantially past roughly 32k tokens of noise-heavy context.

**Fix.** A larger window is a higher budget ceiling, not a license to stop budgeting. Treat tokens as scarce regardless of what the ceiling is. The fix for quality degradation is almost never "add more window" — it is "remove the noise."

---

### Pitfall 2 — Normalising retries as a quality strategy

**Symptom.** "It works if you run it three times and take the best output" becomes an accepted workflow.

**Consequence.** The team is paying for inconsistency rather than fixing it. Each retry is evidence that the context structure is broken. Normalising retries removes the pressure to diagnose the root cause.

**Fix.** Treat retry rate as a context health metric. If retry rate is above one per task, the context structure needs a diagnostic pass. The three-retry pattern almost always traces to either context rot or unanchored context — both are structural, not stochastic.

---

### Pitfall 3 — Retrieval without intent (RAG as buffet)

**Symptom.** A RAG system is implemented, but top-k is set high (20–50 chunks), metadata filtering is sparse, and chunks have no self-contextualising prefix. The system "retrieves" but the context window is still diluted — just by retrieval outputs rather than pasted documents.

**Consequence.** The model receives many chunks that are tangentially related to the query. Synthesis quality degrades. The team concludes "RAG doesn't work" rather than "RAG without precision doesn't work."

**Fix.** Start at top-k = 3. Add a recency filter. Implement Contextual Retrieval (prepend each chunk with a one-to-two sentence summary of the document it comes from before embedding). Test at top-k = 5 before increasing further. The question is not "how many chunks might be relevant?" but "what is the minimum set of chunks the model needs to answer this specific query?"

---

### Pitfall 4 — Persist/retrieve collapse over time

**Symptom.** A context setup that worked well at project start degrades over months. Nobody changed anything intentionally, but the always-on layer has accumulated: new PRD versions were added but old ones were never removed; synthesis outputs were saved back into context; meeting notes from six months ago are still in the project memory.

**Consequence.** The always-on layer is now partially episodic. The model receives a mix of current and historical context with no signal about recency. Output quality degrades and the team attributes it to the model rather than the context.

**Fix.** Assign a context boundary owner. Run a quarterly audit: apply the Q4 falsification test to every element in the always-on layer. Move anything that fails to the retrieval layer or discard it. An explicit "last reviewed" date in the Context Manifest makes the decay visible.

---

### Pitfall 5 — Skipping the reset phase

**Symptom.** A multi-phase workflow (research, synthesis, implementation) runs in a single session or project without clearing context between phases. The implementation phase inherits the research phase's noise, dead ends, and superseded hypotheses.

**Consequence.** Context rot — the model's outputs in the implementation phase are influenced by abandoned research directions and overwritten decisions from the research phase. The outputs are internally consistent with a context state that no longer reflects the team's intent.

**Fix.** The Research → Plan → Reset → Implement cycle is the structural remedy. The reset between Plan and Implement is not an inconvenience — it is the mechanism that ensures the implementation session starts clean. The PLAN.md or SPEC.md artifact is the compressed, high-signal handoff that makes the reset possible without losing the research work.

---

### Pitfall 6 — Stuffing as a substitute for document quality

**Symptom.** The PM is adding context to help the AI "navigate the ambiguity" in an underlying document. The PRD has conflicting definitions; the specs have internal contradictions; the constraints have never been formally documented.

**Consequence.** The stuffing masks the structural problem temporarily and makes it worse over time — more context is added to explain the context, and the model's outputs reflect genuine document ambiguity as inconsistency.

**Fix.** Q5 (structural mask check) exists specifically for this. Before adding context to compensate for an ambiguous document, fix the document. Reconcile conflicting definitions. Write the constraints manifest. Build the operational glossary. A tight, unambiguous 300-word constraints document outperforms a 3,000-word document-plus-explanation context on every quality metric.

## References

- **Andrej Karpathy** — originator of "context engineering" as a named discipline, distinguishing it from prompt engineering as a systems concern rather than a phrasing concern. Primary conceptual anchor for the stuffing vs. engineering distinction. Source: public statements and writing, 2024–2025.
- **Anthropic** — [Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval) (technique for prepending explanatory context to RAG chunks before embedding; documented 35% reduction in retrieval failure rate); prompt caching documentation (persistent layer cost model). Primary technical source for retrieval precision recommendations.
- **Drew Breunig** — context budget framing; retrieval/freshness/precision tradeoff analysis for LLM workflows. Source: writing on LLM systems architecture, 2024–2025.
- **Latent Space podcast / Simon Willison** — practitioner documentation of long-context performance degradation, "lost in the middle" pattern, and the gap between marketing claims ("infinite context") and engineering reality. Secondary source for the large-window cautions in Pitfall 1.
- **Marty Cagan** — *Inspired* (2017); *Empowered* (2020). The four risks (value, usability, feasibility, business viability) inform the context audit framing: a context setup with unvalidated structural assumptions carries product risk, not just cost risk. See `roles/product-manager/sources.md`.
- **Related Hornero skills:**
  - [`ai-shaped-readiness-advisor`](../ai-shaped-readiness-advisor/SKILL.md) — context engineering is one of the five competencies of AI-shaped product work; that skill provides the broader readiness assessment of which this is the deep-dive.
  - [`prd`](../prd/SKILL.md) — the PRD is both a context consumer (AI-assisted PRD writing depends on well-structured task context) and a common source of context rot (accumulated PRD versions are a canonical stuffing culprit).
  - [`success-metrics`](../success-metrics/SKILL.md) — token usage and retry rate are operational metrics for context health; this skill's action plans should wire to the success-metrics stack to make context quality visible.
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — interview synthesis is one of the highest-frequency AI tasks for PMs and one of the most common stuffing sites (full transcripts pasted when only thematic excerpts are needed).

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/context-engineering-advisor) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
