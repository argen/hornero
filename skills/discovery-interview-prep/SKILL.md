---
name: discovery-interview-prep
description: Use to plan a discovery interview — produces an interview guide grounded in Teresa Torres' continuous-discovery methodology and Bob Moesta's switch-interview technique.
role: product-manager
intent: |
  Produces a structured interview guide for a discovery conversation
  with a customer or prospect. Grounded in continuous-discovery practice
  (Torres) and switch-interview methodology (Moesta). Reduces the
  risk of confirming what you already believe.
type: interactive
theme: discovery
best_for:
  - Before a customer interview where you need actionable evidence
  - Onboarding a PM to a discovery cadence
  - Re-grounding a stalled feature investigation with fresh customer voice
scenarios:
  - "PM preparing for next week's six customer interviews on a checkout-flow problem"
  - "Designer joining a switch-interview to understand the moment of dissatisfaction"
  - "Product team aligning on discovery questions before a research sprint"
estimated_time: 15-25 minutes (per interview guide)
---

# Discovery interview prep

> v0 draft. Combines Torres' Opportunity Solution Tree methodology with Moesta's switch-interview structure. Editorial review recommended.

## Purpose

Produce an interview guide that surfaces evidence — not opinions, not feature requests, not confirmation of internal assumptions. The skill is interactive: it asks the PM what they're trying to learn, then generates a guide tailored to that question.

A good discovery interview rarely produces neat answers; it produces stories that *reveal* the customer's context, behavior, and motivations.

## Key Concepts

### Continuous discovery (Torres)

Teresa Torres (*Continuous Discovery Habits*): customer interviews happen weekly, not quarterly. The cadence matters more than the depth of any single interview. Each interview adds to a running understanding; no single one is decisive.

The Opportunity Solution Tree (OST) is the persistent artifact: outcome at the top → opportunities (problems / unmet needs) discovered through interviews → solutions hypothesized → experiments to test.

### The "stories, not opinions" rule

Customers are unreliable narrators of their own future behavior. They are reliable narrators of their own past behavior. The interview's job is to elicit *stories* — specific, recent, concrete — not opinions or predictions.

- ❌ "Would you use this if we built it?"
- ✅ "Tell me about the last time you tried to [do the relevant thing]."

The first question's answer is uninformative ("yes, probably"). The second question's answer reveals motivation, context, friction, and alternatives.

### Switch interviews (Moesta)

For customers who recently switched to (or considered switching to) your product, the switch interview reconstructs the timeline:

- When did the **first thought** of switching occur?
- What **events** during the consideration period moved the customer along?
- What was the **switch moment** (purchase / signup / first use)?
- What were the **forces** at play (push, pull, anxiety, habit)?

This is the canonical interview technique for understanding why people choose a product.

### What to never ask

- Future hypotheticals ("would you...")
- Feature requests ("what would you like us to build?")
- Compound questions ("how do you do X, and what tools do you use?")
- Leading questions ("don't you think...")
- Yes/no questions when a story would do better

## Application

### Step 1 — Ask the PM 4 questions

The skill is interactive. Adapt these questions to context:

**Q1.** What outcome / opportunity / problem are you investigating?

**Q2.** Who are you talking to (specifically)? Recent switcher? Long-term user? Non-customer? Considered-but-didn't?

**Q3.** What do you suspect you'll hear? (This question's purpose: identify confirmation bias and design questions that could *disconfirm* the suspicion.)

**Q4.** What decision will the interview inform? If the answer is "general learning," push back: discovery is best when tied to a near-term decision.

### Step 2 — Generate the guide

Produce a guide structured around 4-6 questions, plus follow-up prompts. Total interview time: 30-45 minutes.

```markdown
# Discovery interview guide — <topic>

**Outcome being investigated.** <one sentence>
**Interviewee.** <segment / context>
**Decision this informs.** <near-term decision>

## Warm-up (3-5 min)
- "Tell me a little about your role and what you spend most of your week doing."
- (Listening for: what's important to them, what language they use,
  what their day-to-day looks like.)

## The core story (15-20 min)
- "Walk me through the last time you <relevant activity>. Start with
  when you first noticed you needed to do it."
- Follow-up prompts (use 2-3, not all):
  - "What were you using before / instead?"
  - "What made you decide it was time to <do the action>?"
  - "What other options did you consider?"
  - "Tell me about the moment you decided to <use current solution>."
  - "What was the hardest part?"

## Specifics (5-10 min)
- "Show me, if you can." (Screen share, walkthrough, artifacts.)
- (Listening for: what they actually do, not what they say they do.
  Specific friction points. Workarounds.)

## Counterfactual probe (5 min)
- "If [current solution] disappeared tomorrow, what would you do?"
- (Listening for: real competitive alternatives, including
  do-nothing.)

## Wrap (2-3 min)
- "What did I not ask about that I should have?"
- (Listening for: things the interviewee thinks are important that
  you missed. Sometimes the most-valuable signal.)

## What I am NOT going to ask
- Future hypotheticals
- "Would you use it if..."
- Feature requests
- Leading questions
```

### Step 3 — Brief the interviewer

If someone else is conducting the interview, share:
- The outcome being investigated
- The "what I am NOT going to ask" list
- A reminder: silence is fine. Pause after the interviewee finishes. They often add the most-valuable detail when given space.

### Step 4 — Post-interview synthesis

After the interview, capture (within 24 hours, while memory is fresh):
- 3-5 verbatim quotes (in the customer's words, not paraphrased)
- The story arc — what they were doing, what changed, what they did about it
- Surprises — moments the interview contradicted the suspicion noted in Q3
- Open questions for follow-up

Feed into the Opportunity Solution Tree.

## Examples

### Example 1 — Good guide (B2B compliance tool)

**Outcome:** Reduce time-to-first-contract-reviewed for new users (currently 9 days median).

**Suspicion (from Q3):** New users are bottlenecked on team setup; we should streamline onboarding.

**Disconfirming probe added:** "Tell me about your first week with the tool. What did you actually do, day by day?" (Story, not opinion. Surfaces what the user actually did — which might or might not include team setup.)

**Outcome of interview (real example synthesis):** Out of 6 interviews, 4 users described being blocked not on team setup but on getting their *own* contract templates into the tool. The suspicion was wrong; the bottleneck was content migration, not team setup. The product team pivoted from streamlining team-setup to building a contract-template importer.

### Example 2 — Bad guide (failure)

A draft guide includes:
- "How important is automated reporting to you?"
- "Would you pay more for an enterprise tier with custom dashboards?"
- "What features do you wish we had?"

**What's wrong:** All three are opinion/hypothetical/feature-request questions. They produce uninformative answers ("important," "depends," "more integrations"). They confirm what the team wants to hear.

**Fix:** Rewrite as story-eliciting questions.
- "Tell me about the last time you needed to produce a report. What did you do?"
- "Walk me through the last time you bumped up against a limit in your current tier."
- "Show me a task you do regularly that's frustrating."

## Common Pitfalls

### Pitfall 1 — Confirming the prior

**Symptom:** The PM enters with a hypothesis and the guide is designed to confirm it. Every question elicits "yes" responses.

**Consequence:** Discovery becomes consensus-building for an already-made decision.

**Fix:** Step 1 Q3 ("what do you suspect you'll hear?") plus Q4 (decision informed) force the PM to design at least one question that could disconfirm. If the suspicion can't be disconfirmed by any question, the interview is theatre.

### Pitfall 2 — Too many questions

**Symptom:** Guide has 15 questions; interview overruns; depth on each is shallow.

**Consequence:** Conversation feels like a survey; rapport doesn't build; stories don't emerge.

**Fix:** Cap at 4-6 questions plus follow-up prompts. The interviewer's skill is in pulling on threads, not running through a script.

### Pitfall 3 — Hypotheticals leaking in

**Symptom:** "Would you..." or "If we built..." or "Imagine..." in the guide.

**Consequence:** Answers are speculation, often biased to please.

**Fix:** Every question elicits a story about past behavior. If a question can't be rephrased as "tell me about the last time...", consider whether you need to ask it at all.

### Pitfall 4 — Skipping the "show me" step

**Symptom:** Interview is verbal-only; no walkthroughs, no artifacts.

**Consequence:** You hear what users *say* they do, which differs from what they *actually* do.

**Fix:** Whenever possible, "show me" beats "tell me." A screen share or walkthrough of an artifact reveals friction the user has normalized.

### Pitfall 5 — No synthesis discipline

**Symptom:** Interviews happen; quotes don't get captured; the OST doesn't update; the team forgets what was learned in a month.

**Consequence:** Each interview is a one-shot; no compounding.

**Fix:** Step 4 synthesis is non-negotiable. Capture quotes verbatim within 24 hours; update the OST weekly.

## References

- **Teresa Torres** — *Continuous Discovery Habits*; the Opportunity Solution Tree; the weekly discovery cadence.
- **Bob Moesta** — switch-interview methodology; *Demand-Side Sales*.
- **Rob Fitzpatrick** — *The Mom Test*; the canonical guide for avoiding biased questions.
- **Erika Hall** — *Just Enough Research*; practical interview methodology.
- **Joanna Wiebe** — voice-of-customer mining (a written-source cousin of live interviews; see marketing-expert role).
- **Related Hornero skills:**
  - `skills/jobs-to-be-done/SKILL.md` — JTBD statements are downstream of discovery interviews.
  - `skills/prd/SKILL.md` — Problem section cites interview evidence.
