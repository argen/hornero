---
name: press-release
description: Use when a team needs to write an Amazon-style working-backwards press release as a forcing function for problem clarity, customer-facing language, and the "is this worth building?" test before any spec is written.
intent: |
  Produces a working-backwards press release — a planning artifact written as
  if the product already shipped perfectly, forcing the team to articulate
  customer value before writing a line of code. The press release is a clarity
  test, not a marketing asset: if you cannot write a compelling one, the idea
  is not yet ready to build. When the PR draft is credible, the FAQ pass turns
  it into a shared alignment artifact for stakeholders and exec review.
type: component
theme: workshops
best_for:
  - Testing whether a new product or major feature is worth building before discovery work begins
  - Aligning cross-functional stakeholders on customer value before the PRD is drafted
  - Sharpening a vague opportunity statement into customer-facing language that survives the "so what?" test
scenarios:
  - "We've agreed we want to solve X — write the press release before the PRD so we know if we actually agree"
  - "Exec review is next week and leadership keeps asking 'why would a customer care' — force the answer now"
  - "PM and design are treating a feature like a solution; make them write the headline first"
estimated_time: "60–90 minutes (first draft + FAQ pass); 20–30 minutes (critique of an existing draft)"
---

# Press release

> v0 draft. Anchored in Colin Bryar & Bill Carr (*Working Backwards*, 2021) and Jeff Bezos's shareholder letters as primary sources. Cagan's outcome framing as the product-team overlay. Editorial review recommended before production use.

## Purpose

A working-backwards press release is a one-to-one-and-a-half-page document written from release day, describing a product or feature as if it shipped and customers love it. The discipline of writing it before building forces three things that most teams skip: naming the specific customer problem, articulating the outcome (not the mechanism), and testing whether the value proposition survives ordinary language.

This is not launch copy. It is a decision gate. Bryar and Carr (*Working Backwards*, ch. 2) describe it as the first required artifact before any engineering work begins at Amazon — a planning tool whose primary output is clarity, not a press release that will ever be published.

Distinct from the PRD: the PRD operationalises one coherent decision into a buildable specification. The press release answers the prior question — "should we build this at all, and for whom?" — in the customer's language, not the team's. A PRD with no press release parent is likely solving a solution rather than a problem.

Distinct from a positioning statement: positioning defines competitive context ("for X, unlike Y, we do Z"). The press release assumes you're right about positioning and asks "what does the customer's life look like when it works?" The two artifacts are complementary — run `positioning-statement` first when competitive context is unclear.

## Key Concepts

### The working-backwards principle (Bryar & Carr)

The Amazon method, as described by Bryar and Carr, inverts the normal product sequence. Most teams start from a solution or a technology and work forward to a customer story. Working backwards starts from the customer's experience on a hypothetical release day and asks: what does it look like? What problem vanished? What did they say about it? What question do they still have?

Writing from that future state forces precision. Vague value propositions — "streamlines workflows," "improves visibility" — cannot survive the press release format because the format demands specific headlines and specific customer quotes. If you cannot write a crisp headline, you do not yet understand the value. That failure is the point: the press release surfaces it before a team of engineers tries to build around it.

Bezos named the approach explicitly in his 2015 and 2018 shareholder letters: the press release as a forcing function, the FAQ as the mechanism for surfacing and resolving the hard questions the press release raises.

### PR/FAQ structure

A working-backwards document has two parts:

**The press release (1–1.5 pages):**

1. **Headline** — benefit-focused, specific, written for a target customer who does not know the company. If it could describe any product in the category, rewrite it.
2. **Sub-head** — one sentence expanding the headline with the customer segment and the primary measurable outcome.
3. **Summary paragraph** — three sentences: what launched, who it's for, what changed for them. No features. No mechanisms. Only outcomes.
4. **Problem paragraph** — the specific, named problem the customer has today, grounded in evidence. A problem paragraph that uses the phrase "inefficient workflows" or "lack of visibility" is a problem paragraph that needs to be rewritten.
5. **Solution paragraph** — how the product resolves the problem, stated as outcome rather than mechanism. "Cuts report preparation from 8 hours to 20 minutes" not "uses AI to process data faster."
6. **Customer quote** — a plausible direct quote from a target customer expressing what changed. Not "this product is amazing" — that is content-free. The quote should name the specific relief: "I used to spend Sunday nights doing this. Now I don't."
7. **Getting-started paragraph** — one or two sentences on how a customer begins. This tests feasibility: if you cannot describe the first step in plain language, the onboarding is not designed yet.
8. **Leader quote** — a company voice statement expressing the customer commitment behind the decision. Specificity test: if this quote could appear in any company's press release, it is not a leader quote, it is a press release cliché.

**The internal FAQ (1–5 pages depending on complexity):**

Two sections: external-facing questions (what customers and press will ask) and internal-facing questions (what executives and engineering will ask). The FAQ is where the hard tradeoffs and the implementation uncertainties live. The press release earns its optimism; the FAQ owns the caveats.

Cagan (*Inspired*, ch. 1–2) frames the team's job as delivering outcomes over output. The press release is the instrument that makes that abstract principle concrete: an artifact that is structurally incapable of listing features, because features do not appear in press releases.

### Release-day language as a sharpness test

"Release-day language" means: what would a journalist or customer actually say, in plain English, on the day this ships? This is a useful diagnostic because internal language is habitually solution-shaped and jargon-heavy. Phrases like "leverages our proprietary ML pipeline," "enables end-to-end traceability across the data lifecycle," and "empowers users with a unified experience" are internal language. They describe mechanisms, architecture, and aspiration. They do not describe what changed for a customer.

The test is simple: read a sentence aloud and ask "would a customer say this?" If no, translate it. This translation work is the hard intellectual labour of the press release exercise — and the reason it cannot be skipped.

### Press release vs PRD: the sequencing discipline

The press release precedes the PRD. It answers the customer-problem question. The PRD answers the solution-design question. A PRD written without a press release typically contains problem statements that are solution-shaped, success metrics defined by feature adoption rather than customer outcomes, and a scope that reflects what the team already wanted to build rather than what the customer problem demands.

The press release is also distinct from the `strategy-kernel`: the kernel names the multi-quarter posture and the binding constraint across the portfolio. The press release zooms in on one specific customer-facing deliverable within that posture. A press release with no kernel parent is either self-justifying feature work or an indication that the kernel hasn't been operationalised.

## Application

### Step 1 — Frame the question (5 minutes)

Write one sentence naming the customer, the problem, and the horizon: "For [segment], who today [specific friction], write the press release for the version of [product/feature] that ships in [quarter]." This framing scopes the draft and prevents the common drift where the press release becomes a product vision document covering three years of roadmap.

If you do not yet know who the customer is or what their problem is specifically, stop. Run `jobs-to-be-done` or conduct discovery first. A press release written without a grounded problem statement will produce compelling fiction, not a useful planning artifact.

### Step 2 — Draft the headline and sub-head (10 minutes)

Write the headline before any other section. The headline is the hardest sentence in the document because it must be benefit-focused, specific, and meaningful to someone who has never heard of your company.

Quality bar:
- **Specific outcome, not vague improvement.** "Cuts invoice processing from 8 hours to under 20 minutes for freelancers" passes. "Revolutionises freelance finance management" fails.
- **Passes the competitor-name swap test.** Replace your product name with a direct competitor. If the headline still reads true, it is not differentiated. Rewrite until the swap breaks it.
- **Names the customer segment or the problem, not the product.** Headlines that lead with the product name force the reader to already care about the product. Headlines that name the problem or the outcome earn the reader's attention.

Write the sub-head immediately after: one sentence adding the segment precision the headline elided, plus the primary measurable outcome if it was not in the headline.

### Step 3 — Write the problem paragraph (15 minutes)

Describe the customer's current reality in specific, measurable terms. This is the most important paragraph in the document. If it is vague, everything downstream will be vague.

Evidence it should contain:
- **A named, specific friction.** Not "invoicing is time-consuming." "Freelancers manually re-enter line items from client emails into three different systems for each project."
- **A scale indicator.** Time, frequency, dollar cost, error rate. Something that makes the problem size legible.
- **A source or grounding signal.** Customer interviews, usage data, support tickets, published research. "Unvalidated belief" is acceptable at the earliest stage — name it as such so the team knows what needs verification.

Avoid the trap of validating a solution in the problem paragraph. "Currently, businesses lack an integrated AI-powered invoice system" is a solution-shaped problem statement. "Freelancers spend an average of four hours per project on billing administration" is a problem statement.

### Step 4 — Write the solution and customer quote paragraphs (15 minutes)

The solution paragraph translates the specific problem from step 3 into the specific outcome the product delivers. One mechanism is acceptable ("by automatically extracting and matching line items") but it must be in service of an outcome statement ("reducing billing administration to under 10 minutes per project"), not a substitute for one.

The customer quote is the adversarial test for the solution paragraph. Write a plausible direct quote from a target customer. If the quote cannot be specific — if the best you can produce is "this saves me so much time!" — the solution paragraph is still too vague. Go back and sharpen the outcome. A good customer quote names what specifically changed: "I used to do this on Sunday nights. Now I do it in five minutes while the coffee brews."

### Step 5 — Complete the press release structure (10 minutes)

Write the summary paragraph (three sentences: what launched, for whom, what changed). Write the getting-started paragraph (one to two sentences on first step). Write the leader quote (customer-specific, not company-generic).

If the getting-started paragraph is hard to write, it is because the onboarding flow is undesigned. Surface this explicitly: "Getting-started is TBD — onboarding design is a required input before this PR is ready."

### Step 6 — Run the "so what?" test (5 minutes)

Read the press release aloud. After each paragraph, ask: "So what — what does this tell a customer that changes whether they care?" If a paragraph cannot survive this question, cut or rewrite it. The press release should read as a sequence of escalating reasons to care: problem (I have this), solution (it resolves it), quote (someone like me confirms it), getting-started (I know what to do next).

### Step 7 — Write the FAQ pass (20 minutes)

Draft four to six external questions (what a customer or journalist would ask) and four to six internal questions (what an exec or engineer would ask). For each, write a concise answer. The questions that are hardest to answer are the most important: they are the unresolved risks the press release is hiding.

Bryar and Carr note that the FAQ is where Amazon teams discover whether the press release is credible. A press release with easy FAQ answers is either describing a very simple product or a very shallow set of assumptions. Surface the hard questions now. Better to resolve them in the FAQ than in a post-launch retrospective.

External FAQ examples: "How is this different from [named competitor]?" "How much does it cost?" "What do I need to set it up?" "What happens when [failure mode]?"

Internal FAQ examples: "Why this customer segment and not [adjacent segment]?" "What's the go-to-market assumption this PR depends on?" "What has to be true about feasibility for the getting-started paragraph to be honest?" "What's the biggest assumption in the problem paragraph and how do we validate it?"

### Step 8 — Socialise and pressure-test (ongoing)

Share the press release with one person outside the product team — a customer, a sales rep, a customer success lead — before treating it as a stable planning artifact. If they cannot explain back the customer problem in their own words after reading it, the problem paragraph is still too internal.

The press release is ready to anchor the PRD when:
- A non-PM stakeholder can read the headline and summary paragraph and accurately describe who the customer is and what problem is being solved.
- The FAQ contains at least two hard internal questions whose answers are marked "TBD — investigate before PRD."
- The customer quote is specific enough that swapping a different product in would make it false.

## Examples

### Example 1 — Worked PR/FAQ: Billing automation for freelancers

**Context.** A fintech platform serving independent contractors. Discovery interviews (n=14) show that billing administration consumes 3-6 hours per project, predominantly in re-entering client-provided data across invoice tools, accounting software, and tax trackers. The binding problem is manual data re-entry, not invoice formatting.

---

**Headline:** Acme Invoicer Cuts Freelancer Billing Time from Hours to Minutes — No Manual Entry Required

**Sub-head:** Independent contractors using Acme Invoicer automatically extract, match, and file billing data from client emails, eliminating the manual re-entry that consumes an average of four hours per project.

**Summary:** Acme today launches Invoicer, a billing tool built for independent contractors who invoice directly from client communications. By treating client emails as structured data sources rather than reference documents, Invoicer reduces per-project billing administration from a multi-hour task to under ten minutes — without requiring contractors to change how clients send information.

**Problem:** Freelancers working with multiple clients manage billing across incompatible formats: some clients send SOWs, some send PDFs, some send unstructured email threads with line items embedded in conversation. Extracting billable items, entering them into an invoice tool, reconciling against a separate accounting record, and flagging for quarterly tax tracking is a multi-step manual workflow that repeats for every project. Fourteen contractor interviews found an average of 4.2 hours per project spent on billing administration — time that cannot be billed, cannot be delegated, and compounds across a full client portfolio.

**Solution:** Invoicer connects to the contractor's inbox, identifies client communications containing billable items using a supervised extraction model, drafts the invoice for contractor review and approval, and syncs the approved record to their accounting and tax tools in a single step. The contractor approves or edits a pre-filled invoice; they do not re-enter data. "I used to do this on Sunday nights with three browser tabs open," said Maria Chen, a UX contractor in the beta cohort. "Now I approve an invoice in the time it takes to read the email."

**Getting started:** Connect your inbox and accounting tool, set your default rate and billing preferences, and Invoicer will surface your first draft invoice from the most recent client project. Average setup time in beta: 11 minutes.

**Leader quote:** "Contractors built the internet and still do their billing in spreadsheets. Invoicer assumes that's not a character flaw — it's a gap in the tooling."

---

**External FAQ (excerpt):**

*Q: How does Invoicer handle clients who send invoices in non-standard formats?*
A: The extraction model handles email, PDF, and plain-text SOWs. Formats outside those three require manual entry for the first project; subsequent projects from the same client use the learned template. (TBD: confirm PDF coverage with engineering before PRD.)

*Q: What accounting tools are supported at launch?*
A: QuickBooks, FreshBooks, Wave. Xero is targeted for Q2. (TBD: confirm Xero timeline before marketing launch copy.)

**Internal FAQ (excerpt):**

*Q: Why independent contractors and not small agencies?*
A: Agencies have bookkeepers. The binding problem — no one to delegate to — is acute for solo operators. Agencies are an expansion segment, not a launch segment.

*Q: What's the biggest assumption in the problem paragraph?*
A: That 4.2 hours per project is representative across contractor types. The n=14 sample skews toward UX and dev. Validate against a broader sample before committing to this figure in external copy.

---

**What makes this draft credible.** The headline names a specific outcome (hours to minutes) tied to a specific mechanism (no manual entry). The problem paragraph contains a number (4.2 hours) from a named source (14 interviews) and names the specific friction (multi-step manual re-entry), not a vague category ("inefficiency"). The customer quote is specific enough that inserting a competitor's name would not preserve its truth — "Maria" is describing a particular workflow change, not expressing generic satisfaction. The FAQ names two open items explicitly, which signals the draft is honest about what is unresolved.

---

### Example 2 — Counter-example: Solution-shaped press release

**Headline:** Acme Launches AI-Powered Invoicing Platform for Modern Freelancers

**Summary:** Acme today announces Invoicer Pro, an innovative AI-powered platform that leverages cutting-edge machine learning to streamline the invoicing workflow for freelancers and independent professionals. With seamless integrations, real-time sync, and an intuitive dashboard, Invoicer Pro brings enterprise-grade automation to the independent workforce.

**Problem:** Managing invoices manually is time-consuming and error-prone. Freelancers juggle multiple tools, leading to workflow fragmentation and lost productivity.

**Solution:** Invoicer Pro uses AI to automatically process and manage invoices, reducing administrative overhead and enabling freelancers to focus on their work.

**Leader quote:** "We're excited to bring the power of AI to freelancers everywhere."

---

**Why this fails the PR/FAQ test.**

The headline leads with the product name and describes a category ("AI-powered invoicing"), not an outcome. Any competitor could claim this headline. The problem paragraph names "time-consuming and error-prone" and "workflow fragmentation" — vague descriptions that could appear in press releases for project management tools, accounting software, or communication platforms. No specific friction, no scale indicator, no customer evidence. The solution paragraph describes mechanisms ("automatically process and manage") with no outcome: we don't know how much time is saved, or for whom, or under what conditions. The customer quote is absent entirely. The leader quote is a press release cliché. This document is internally legible — the team clearly knows what they're building — but it would not survive a customer reading it. That gap is the signal: if the press release cannot be understood by the customer it describes, the team has not yet done the working-backwards work.

## Common Pitfalls

### Pitfall 1 — Feature inventory disguised as a press release

**Symptom:** The solution paragraph lists capabilities: "Includes AI-powered extraction, real-time sync, multi-tool integration, and customisable templates."

**Consequence:** Cagan's output trap (*Inspired*, ch. 2) — the team conflates delivering features with delivering customer outcomes. The press release becomes a PRD pre-announcement rather than a customer value test.

**Fix:** For each feature listed, write the sentence "so the customer can [specific outcome]." If you cannot complete that sentence with something specific, the feature has no place in the press release. Delete the feature list; keep only the outcomes.

---

### Pitfall 2 — Vague problem statement

**Symptom:** The problem paragraph reads "Many businesses struggle with inefficient workflows and lack of visibility into their operations."

**Consequence:** No customer self-identifies. The press release could describe any B2B product. The FAQ will be impossible to write because the problem is undefined. Bryar and Carr are explicit: a vague problem produces a vague press release, and a vague press release is a sign the team doesn't yet understand the customer.

**Fix:** Apply three tests. (1) Can a specific person read this and say "that's me"? (2) Is there a number — time, frequency, cost, error rate? (3) Is there a source — interviews, data, tickets? If any test fails, the problem paragraph is not ready.

---

### Pitfall 3 — Generic customer quote

**Symptom:** The quote says "This product has revolutionised the way we work" or "We love this tool — it's so intuitive."

**Consequence:** The quote adds no information. It cannot distinguish this product from any other. It signals the team has not done the work of imagining what a specific customer's specific relief would sound like.

**Fix:** Write the quote by finishing this sentence: "I used to [specific friction]. Now [specific change]." If the quote cannot be completed that way, the solution paragraph is still vague. Sharpen the solution, then rewrite the quote.

---

### Pitfall 4 — Internal language in customer-facing copy

**Symptom:** "Leverages our proprietary ML pipeline to enable end-to-end data lifecycle traceability for enterprise-grade compliance workflows."

**Consequence:** The press release is legible only to the team that built it. Bezos's release-day language test (2018 shareholder letter) requires that press release copy survive a reading by someone who has never heard of the product. Internal language fails this test.

**Fix:** Read every sentence aloud and ask "would a customer say this?" Translate mechanisms into outcomes. Translate architecture into behaviour the customer can observe. "Our ML pipeline processes your data" → "Your data is ready in under 30 seconds, with no manual steps."

---

### Pitfall 5 — Skipping the FAQ pass

**Symptom:** The team writes the press release, declares it done, and moves to the PRD.

**Consequence:** The FAQ is where unresolved risks surface. A press release without a FAQ pass is a document that has suppressed its own hardest questions. Those questions reappear as PRD scope disagreements, launch blockers, or post-launch customer complaints.

**Fix:** Require at least four internal FAQ questions before the press release is considered a planning artifact. The rule of thumb from Bryar and Carr: any question that the team finds uncomfortable to answer is exactly the question the FAQ should contain.

---

### Pitfall 6 — Writing the press release after the PRD

**Symptom:** The feature is designed, the PRD is in review, and the team is asked to write a press release "for alignment."

**Consequence:** The press release written after the PRD is reverse-engineered from the solution. It will inherit the solution-shaped framing of the PRD and will not surface whether the customer problem justifies the design. This is the working-backwards failure Bryar and Carr describe as the most common: teams that adopt the format but not the sequence.

**Fix:** Treat the press release as a gate, not a summary. If the PRD is already written, the press release exercise can still be useful as a retrospective clarity test — but be explicit that it is being used post-hoc and may reveal problems with the PRD scope that require revisiting.

## References

- **Colin Bryar and Bill Carr** — *Working Backwards: Insights, Results, and Secrets from Inside Amazon* (2021, St. Martin's Press). Chapter 2 is the canonical description of the press release and FAQ methodology as Amazon practices it: the sequencing discipline (PR before spec), the two-part PR/FAQ structure, and the organisational mechanisms that make the format effective. All structural elements of this skill trace to this source.
- **Jeff Bezos** — Amazon shareholder letters, 2015 and 2018. The 2015 letter names the working-backwards process explicitly in the context of product and service decisions. The 2018 letter discusses release-day language as a thinking discipline and the FAQ as a mechanism for surfacing hard questions before commitment.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017, Wiley). Chapters 1–2 frame the outcome-over-output principle that the press release format enforces structurally. Pitfall 1 in this skill (feature inventory) maps directly to Cagan's output-trap analysis.
- **Håkon Eriksson** — Product management writing on working-backwards methodology as adopted outside Amazon; useful for teams applying the format in non-Amazon organizational contexts where the PR/FAQ has no formal gate status.
- **Related Hornero skills:**
  - [`prd`](../prd/SKILL.md) — the PRD is the downstream artifact that operationalises the press release's customer commitment into a buildable specification. Run press-release first; PRD second.
  - [`positioning-statement`](../positioning-statement/SKILL.md) — positioning defines competitive context before the press release is drafted. The "unlike [competitor]" precision that sharpens the press release headline comes from positioning work.
  - [`success-metrics`](../success-metrics/SKILL.md) — the outcome statements in the press release should map directly to the metrics tracked in success-metrics. If they don't, either the press release is too vague or the metrics are measuring the wrong thing.
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the press release zooms in on a single customer-facing deliverable; the kernel provides the portfolio-level posture that tells you which deliverables are worth writing press releases for.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/press-release) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
