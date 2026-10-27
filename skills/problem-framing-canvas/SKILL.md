---
name: problem-framing-canvas
description: Use before drafting a PRD to produce a structured problem statement — who has it, what triggers it, what happens if unsolved, what alternatives exist, what success looks like for the customer.
role: product-manager
intent: |
  Produces a structured problem statement that captures who has the problem,
  what triggers it, what happens if left unsolved, what alternatives the
  customer is already using, and what success looks like for them. This is the
  pre-PRD artifact: solution-free, customer-grounded, and bounded enough to
  drive a PRD without prescribing one.
type: interactive
theme: discovery
best_for:
  - Before drafting a PRD — problem-framing-canvas is the upstream input
  - When a team disagrees about what the problem actually is
  - When discovery interviews have surfaced an opportunity but it hasn't been structured yet
  - When a feature request arrives without a stated problem
scenarios:
  - "PM with 5 customer interview notes and a mandate to produce a PRD — needs to frame the problem first"
  - "Team debate: 'are we solving for the end user or the admin?' — canvas disambiguates"
  - "A sales-sourced feature request with no user context — canvas forces the PM to do the discovery work before committing to scope"
  - "Cross-functional orchestration step 1 — before dispatching roles, frame the problem"
estimated_time: 30-60 minutes (with existing interviews); 60-90 minutes (with only secondary evidence)
---

# Problem-framing canvas

> v0 draft. Anchored in Christensen (JTBD as the canonical problem-framing question), Cagan (customer-job framing + four risks), Doshi (Type-1 problems warrant this artifact; Type-2 don't), and Heath brothers' WRAP (as a see-also for decision readiness). Editorial review recommended.

## Purpose

Produce a solution-free problem statement before a PRD is drafted.

The artifact answers five questions: who has the problem, what triggers it, what happens if it goes unsolved, what alternatives the customer is already using, and what success looks like for them. It is explicitly solution-free. If a solution appears in the canvas, the framing is not done.

Distinct from the PRD: a PRD is solution-shaped (here is what we are building, why, and how we'll know it works). The problem-framing canvas is problem-shaped (here is the problem, at what scale, for whom, with what stakes). The canvas feeds the PRD's Problem section; it does not replace the PRD.

Distinct from the JTBD statement: JTBD surfaces the durable job and the competitive alternatives; problem-framing-canvas surfaces the specific instance of the problem — its trigger, severity, and stakes — that the team intends to solve. The two are complementary. If a JTBD statement exists, the canvas draws on it. If it doesn't, the canvas's "alternatives" section approximates the JTBD's competitive-alternatives field.

## Key Concepts

### The canonical problem-framing question (Christensen)

Christensen (*Competing Against Luck*): "What job is the customer hiring this to do?" This is not a rhetorical question; it is the analytical question that separates a real problem (durable, with competitive alternatives, with stakes) from a feature request (a solution without a stated problem).

The problem-framing canvas is the structured artifact that forces the answer to be concrete: who, when, what stakes, what alternatives. A canvas that could be answered by "any user who wants to do better" is not a problem-framing canvas; it is a placeholder.

### Customer-job framing and the four risks (Cagan)

Cagan (*Inspired*, *Empowered*): the problem-framing step is where the team tests for **value risk** — is there a real problem, at scale, that customers care enough about to change behavior? A canvas that can't name the trigger, the stakes, or the current alternative has not validated value risk. It has described a category of dissatisfaction.

The four risks also apply to the framing itself:

- **Value.** Is the problem real and significant for the named customer? Evidence, not assumption.
- **Usability.** Is the problem one of user difficulty, or of motivation, or of workflow mismatch? The distinction matters for solution design.
- **Feasibility.** Is this a problem the team can realistically solve in a bounded scope?
- **Business viability.** If solved, does the solution create business value — or just user satisfaction that doesn't convert to revenue, retention, or referral?

### Type-1 problems and the case for framing (Doshi)

Doshi: Type-1 decisions are hard to reverse and carry high consequence. Type-2 decisions are reversible and carry low cost of error. Problem framing is warranted when the decision to pursue a solution is Type-1 — where committing resources to the wrong problem is expensive and hard to undo.

For Type-2 situations (a small experiment, a reversible UI tweak, a one-sprint spike), the canvas is overkill. The PM's judgment call is whether the problem warrants formal framing. Heuristics: if the problem is likely to drive a PRD of more than 2 sprints' scope, do the canvas first. If it would drive a single-day experiment, don't.

### Solution-free discipline

The canvas is only valuable if it is solution-free. The moment a solution appears in the framing, the team has skipped the most important step — confirming the problem is real and scoped — and is in the build trap (Perri, *Escaping the Build Trap*).

The discipline: every section of the canvas is audited before the PRD is drafted. If any section names a specific feature or UI pattern, it is removed and replaced with the outcome the customer needs.

### Widen options before narrowing (Heath brothers, see-also)

The Heath brothers' WRAP framework (*Decisive*) — Widen options, Reality-test, Attain distance, Prepare to be wrong — applies at the problem-framing stage. Specifically, "widen options" means: before committing to framing the problem in one way, consider at least one alternative framing. The canvas has a field for this. A team that has only one way of framing the problem has probably not tested the framing.

## Application

Five steps; total PM time 30-90 minutes.

### Step 1 — Name the customer (5-10 minutes)

Identify the customer experiencing the problem. Be specific:

- **Segment, not role.** "Enterprise admin" is more useful than "user." "First-time B2B buyer at a 50-200 person company with no prior category experience" is more useful still.
- **Current context.** What situation are they in when the problem is live? (Not what they do in general — what they are doing at the moment the problem surfaces.)
- **Scope check.** Is this one segment or two? If the problem description only makes sense for one segment but the team is treating it as universal, the canvas needs to split.

If the team cannot name a specific customer, the canvas is not ready to fill in. Route to `discovery-interview-prep` first.

### Step 2 — Name the trigger (5-10 minutes)

The trigger is the specific event or situation that causes the customer to encounter the problem. It is not the category of dissatisfaction — it is the moment.

Good trigger: "When the admin receives a permission-change request from a user in a different department, they must contact IT, wait for approval, and manually track the status in a spreadsheet."

Weak trigger: "When users need to manage permissions."

The trigger does two things: it makes the problem testable (does this trigger exist, at what frequency, for this customer?) and it anchors solution design to the specific situation, not to the general category.

### Step 3 — State the stakes — what happens if unsolved (5-10 minutes)

Describe what happens to the customer if the problem is never solved. This is the "so what?" discipline.

Two levels:

- **Customer stakes.** What is the direct consequence for the customer: time lost, decisions made on bad information, opportunities missed, relationships damaged?
- **Business stakes.** What does the customer-level consequence translate to in business terms: churn, support cost, lost expansion, failed conversion?

If the stakes at both levels are low or uncertain, the problem may not warrant a Type-1 investment. The canvas forces this reckoning before the team commits to a solution.

### Step 4 — Name the alternatives the customer is already using (10-15 minutes)

What is the customer currently doing to address this problem? This is the JTBD competitive-alternatives discipline applied to the specific problem instance.

Alternatives include:
- **Other products** — other tools in or adjacent to the category
- **Manual approaches** — spreadsheets, email threads, direct human coordination
- **Workarounds** — using an existing feature in an unintended way
- **Do nothing** — accepting the problem as a cost of doing business
- **Delegating** — having someone else handle it (internal IT, a consultant, a manager)

Each alternative that exists is evidence that the problem is real and that the customer has made a switching decision at least once (they switched to the workaround from something worse). The quality of existing alternatives is also a pricing and positioning signal: if the best alternative is "email the IT team," a solution that is only marginally better has a low bar; if the best alternative is a well-funded competitor with a mature product, the bar is high.

### Step 5 — State success for the customer (5-10 minutes)

Describe what the customer's situation looks like when the problem is solved, in customer language — not in product language.

A good customer-success statement:
- Describes a changed state of affairs (what they can now do that they couldn't before, or what they no longer have to do)
- Does not name a feature or a UI pattern
- Can be verified by observing the customer's behavior

Weak: "Customers will be able to use the new permissions dashboard to manage access."

Strong: "Admins resolve permission-change requests in under 5 minutes without contacting IT, and can see the status of any pending request without asking anyone."

### Audit before handing off to PRD

Before the canvas is used as PRD input, run a solution-free audit:

1. Does any section name a specific feature, UI component, or technical approach? If yes, remove it.
2. Does the customer-success statement describe an observable behavior change, or does it describe using the product? If the latter, rewrite.
3. Is the trigger specific enough to be testable? (Can you ask 5 customers whether this trigger happens to them and get a clear yes/no?)
4. Are the stakes stated at both customer and business levels?
5. Are the alternatives comprehensive enough to cover the most common current approach?

If all five pass, the canvas is ready to feed the PRD.

## Examples

### Example 1 — Completed canvas (admin permissions problem)

```markdown
# Problem-framing canvas — Admin permissions management

**Customer.**
Mid-senior IT admins at SaaS companies with 100-500 employees. Current
context: managing access for a growing employee base across multiple product
tools, with frequent permission-change requests from department managers.

**Trigger.**
When a department manager submits an access-change request (new user, role
change, or offboarding), the IT admin must: (1) receive the request via email
or Slack, (2) verify the request is authorized, (3) make the change in each
affected tool separately, and (4) manually confirm back to the requester.
At 50-200 requests per month, this consumes 6-10 hours of IT time per week.

**Stakes if unsolved.**
Customer: IT admin is the bottleneck for 3-5 business days per request cycle;
managers escalate to their VP; IT's perceived value within the company is
as a bureaucratic constraint, not an enabler.
Business: ICP segment churns at a rate of 18% within 6 months of reaching
the 150-seat threshold — exit interviews name "IT overhead" in 40% of cases.

**Alternatives currently used.**
- Email/Slack-based manual coordination (current; near-universal in this
  segment below 200 seats)
- IT ticketing system (some; only formalizes the queue, doesn't reduce steps)
- Okta or similar identity management (a minority; too expensive at this
  seat count; partial overlap only)
- Delegating to department managers (rare; security risk; some try it anyway)

Most alternatives make the request visible but don't reduce the per-request
steps or eliminate the tool-by-tool coordination.

**Success for the customer.**
An IT admin receives a permission-change request and fulfills it in under
2 minutes, across all relevant tools, with full audit trail, without Slack
back-and-forth. Department managers can see request status without asking.
IT spends their recovered hours on proactive security work rather than
reactive access administration.
```

What makes this canvas good: the customer is specific (segment + current context, not a generic role). The trigger names the exact sequence of events, with a frequency estimate. The stakes are stated at both levels (admin experience + churn data). The alternatives are comprehensive and include a competitive one (Okta) with a reason for non-adoption. The success statement describes a changed situation in customer language, with no feature names.

### Example 2 — Bad canvas (failure)

```markdown
# Problem-framing canvas — Permissions

**Customer.** Admins.

**Trigger.** When managing permissions.

**Stakes.** It's frustrating and takes time.

**Alternatives.** Other tools.

**Success.** Admins can manage permissions easily with our new permissions
dashboard.
```

Failures: "Admins" is not a segment. "When managing permissions" is a category, not a trigger. "Frustrating and takes time" names no stakes at a business level. "Other tools" is a feature-comparison, not a jobs-level competitive-alternatives list. "New permissions dashboard" is a solution appearing inside the problem frame — immediate disqualifier.

This canvas changes no downstream decision; a PRD built on it will prescribe a solution to a problem the team doesn't actually understand.

## Common Pitfalls

### Pitfall 1 — Solution appearing in the canvas

**Symptom.** The success statement, trigger, or stakes section names a feature, a UI pattern, or a technical component.

**Consequence.** The problem is framed around the solution the team already wants to build. Discovery and scoping decisions downstream are all anchored to the pre-decided solution. (Perri's build trap, entered at the framing stage.)

**Fix.** Solution-free audit before handoff (end of Application section). If a feature name appears anywhere in the canvas, the PM has not finished framing.

### Pitfall 2 — Generic customer segment

**Symptom.** Customer section says "users" or "enterprises" or "knowledge workers."

**Consequence.** The trigger, stakes, and alternatives are averaged across incompatible segments. A PRD built on a generic segment produces features nobody owns.

**Fix.** Step 1 requires segment + current context. If the team can't agree on a specific segment, the canvas isn't ready. Route to discovery-interview-prep first; the segment question is a discovery question.

### Pitfall 3 — Weak trigger

**Symptom.** Trigger describes a general state of dissatisfaction rather than a specific event: "when users struggle with X."

**Consequence.** The trigger is not testable; the team cannot measure its frequency; solution scope is unconstrained.

**Fix.** A good trigger can be used as an interview question: "Does this ever happen to you?" and the interviewee gives a yes/no answer, then a specific example. If the trigger is too broad to generate a yes/no, rewrite it.

### Pitfall 4 — Missing business-level stakes

**Symptom.** Stakes are stated only in customer-experience terms ("frustrating," "takes time") with no translation to business consequences.

**Consequence.** The canvas passes a face-plausibility test but doesn't help the team make a resource-allocation decision. "It's frustrating" does not justify a 6-week engineering investment.

**Fix.** Step 3 requires both levels. If the business-level stakes are unknown, say so explicitly and mark as a hypothesis to validate. A canvas that honestly surfaces unknown business stakes is more useful than one that confabulates them.

### Pitfall 5 — Using canvas for Type-2 problems

**Symptom.** The team runs a full problem-framing canvas for a single-sprint experiment or a UI tweak.

**Consequence.** Overhead disproportionate to the decision; the team learns that problem-framing slows things down; the practice gets discredited.

**Fix.** Doshi's Type-1/Type-2 framing is the gate. The canvas is for Type-1 decisions — where the cost of solving the wrong problem is high. If the decision is reversible and small, skip the canvas and run the experiment. The heuristic: PRD scope of >2 sprints → do the canvas. Single-sprint or smaller → skip.

### Pitfall 6 — Canvas completed by one person without evidence

**Symptom.** PM fills in the canvas in 20 minutes from memory; customer section is based on a vague recollection of sales calls; stakes are assumed.

**Consequence.** The canvas is a confidence artifact, not an evidence artifact. It generates false alignment because the team trusts it without knowing the evidence quality.

**Fix.** Each section should cite its evidence source: interview count, data source, ticket volume. A canvas filled from memory should be marked "hypothesis — pending validation" per field, just as a JTBD statement would be.

## References

- **Clayton Christensen** — *Competing Against Luck* (2016, with Taddy Hall, Karen Dillon, David Duncan). "What job is the customer hiring this to do?" — the canonical problem-framing question. The competitive-alternatives field in the canvas directly applies the JTBD competitive lens to the specific problem instance.
- **Marty Cagan** — *Inspired* (2008, rev. 2017); *Empowered* (2020). Four-risks framework applied to problem framing: value risk is the primary risk being tested by this artifact. Customer-job framing as the PM's first discipline.
- **Shreyas Doshi** — Type-1 vs Type-2 decision framing. The canvas is warranted for Type-1 problems; the pitfall section operationalizes this gate.
- **Melissa Perri** — *Escaping the Build Trap* (2018). The solution-free discipline is Perri's build-trap diagnosis applied at the framing stage: the team enters the build trap the moment a solution appears in the problem frame.
- **Chip Heath & Dan Heath** (see-also) — *Decisive: How to Make Better Choices in Life and Work* (2013). WRAP framework: "Widen options" is operationalized by the canvas's alternatives field and the invitation to consider at least one alternative problem framing.
- **Related Hornero skills:**
  - [`prd`](../prd/SKILL.md) — the problem-framing canvas is the upstream artifact; the canvas's five sections feed the PRD's Problem section directly.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — JTBD provides the durable job framing; the canvas provides the specific problem-instance framing. When a JTBD statement exists, the canvas draws on its competitive-alternatives field.
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — when the canvas cannot be completed because the customer segment or trigger is unclear, route to discovery-interview-prep first.
  - [`cross-functional-orchestration`](../cross-functional-orchestration/SKILL.md) — Step 1 of cross-functional orchestration (frame the question as a customer job) can use the problem-framing canvas as the upstream artifact before dispatching roles. When the orchestrator triages a cross-functional question, the canvas is the first artifact.
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — an item in the backlog with low confidence on value risk may need a problem-framing canvas pass before it can be scored honestly in ICE.
