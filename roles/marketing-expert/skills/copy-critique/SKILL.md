---
name: copy-critique
description: Use when marketing copy on any surface — homepage hero, ad, onboarding email, sales-deck slide — needs a structured critique before shipping. Catches vague claims, feature-not-benefit writing, adjective stacking, company-language in customer-facing surfaces, and generic-AI-aesthetic copy.
intent: |
  Produces a severity-ranked critique of marketing copy. Each finding
  cites the principle violated, names the severity (Blocker / Concern /
  Note), and proposes a rewrite direction. Anchored in Ogilvy (testing-
  driven craft; the headline carries everything), Wiebe (voice-of-
  customer discipline; copy must use buyer language, not company
  language), Schwartz (awareness-level matching), and Sutherland
  (framing effects over rational argument).
type: component
theme: copy-craft
best_for:
  - A homepage hero section before or after a design review
  - An ad (display, paid social, search) before launch
  - An onboarding or nurture email before the sequence goes live
  - A sales-deck slide before an important meeting
  - Any copy suspected of sounding "like AI wrote it" or "like the internal team wrote it"
scenarios:
  - "Review our homepage headline before the new design ships"
  - "Critique this LinkedIn ad — it's getting clicks but we think the copy is wrong"
  - "Our onboarding email open rate is 40% but click rate is 2% — what's the copy doing wrong"
  - "The sales team says the deck's value-prop slide isn't landing"
  - "Does this copy sound like us or like a generic AI?"
estimated_time: 15-30 minutes (critique); 1-2 hours (rewrite direction on 3-5 surfaces)
---

# Copy critique

> v0 draft. Grounded in David Ogilvy's *Ogilvy on Advertising* (1983) and *Confessions of an Advertising Man* (1963), Joanna Wiebe's voice-of-customer copy methodology (Copy Hackers), Eugene Schwartz's *Breakthrough Advertising* (1966) on awareness levels, and Rory Sutherland's *Alchemy* (2019) on framing over fact. Claude Hopkins's *Scientific Advertising* (1923) provides the testing discipline that predates and underlies Ogilvy.

## Purpose

Produce a structured copy critique that:

1. **Names each defect** with severity: **Blocker** (copy actively misleads or repels the buyer), **Concern** (copy fails to do its job without actively harming), **Note** (polish-level; doesn't block shipping).
2. **Cites the principle violated** — traceable to a named source, not to vague taste.
3. **Proposes a rewrite direction** — not finished copy, but a specific alternative that removes the defect. The copy owner rewrites; the critique gives them the heading.
4. **States what to keep** — critique is not demolition. Good copy is named as such.

The critique is not a style review. It is a functional review: does this copy do the job it was given? The job is to make the right buyer think "that's me, that's my problem, this might be different" — and keep reading.

A critique that says "the writing feels a bit generic" without naming what makes it generic and how to fix it is aesthetics, not craft. The skill exists to produce critiques that are actionable, not advisory.

## Key Concepts

### Ogilvy: the headline is the ad

David Ogilvy's canonical observation: five times as many people read the headline as read the body. A weak headline wastes everything below it. A headline that fails to:

- **Arrest the right reader** (not all readers — the right ones)
- **Make a specific claim** (not a mood, not a metaphor)
- **Convey a benefit** (not a feature, not a product description)

...has already lost the sale before the first sentence of body copy.

Ogilvy's testing discipline: copy is not art, it is an argument. Arguments can be tested. Every claim in the copy is a testable hypothesis; the critique names which ones have evidence behind them and which are asserted.

### Wiebe: voice of customer

Joanna Wiebe's foundational rule: the best copy already exists — in the mouths of your customers. Reviews, support tickets, sales-call transcripts, Reddit threads, and churn interviews contain the exact language buyers use to describe their problem and the value they want. Copy that uses that language converts; copy written in the company's language converts less.

**Company language** is the vocabulary of the team that built the product: "seamless," "powerful," "end-to-end," "best-in-class," "next-generation," "AI-powered." These words appear in every competitor's copy, convey no specificity, and signal to buyers that the company is writing for its own ego, not for them.

**Customer language** is specific, often unpolished, and anchored in a problem the buyer actually experiences: "I can't get a clean P&L before the board meeting," "every month-end is a disaster," "I spent three days trying to reconcile that number." Copy that mirrors this language triggers recognition; the buyer thinks "they get it."

The critique checks: is this copy in the company's language or the customer's?

### Schwartz: awareness levels

Eugene Schwartz (*Breakthrough Advertising*): the most important fact about copy is the awareness level of the audience it addresses. Five levels:

1. **Most aware.** The buyer knows the product and just needs an offer. Copy can lead with price or deal.
2. **Product aware.** The buyer knows the product exists but hasn't committed. Copy leads with differentiation.
3. **Solution aware.** The buyer knows the type of solution they want but doesn't know the product. Copy leads with the solution shape.
4. **Problem aware.** The buyer knows they have a problem but hasn't thought about solutions. Copy leads with naming and amplifying the problem.
5. **Unaware.** The buyer doesn't yet know they have the problem. Copy leads with the shift (Raskin's territory) — reframing the world before naming any problem.

Copy written for the wrong awareness level fails regardless of craft quality. A homepage hero that leads with product features (Level 2 copy) for an audience that is Problem Aware (Level 4) will not convert — the buyer isn't looking for features, they're looking for recognition.

The critique states the likely awareness level of the audience and checks whether the copy matches it.

### Sutherland: framing over fact

Rory Sutherland (*Alchemy*): buyers make decisions through perception and framing, not through rational fact-evaluation. The *way* a value claim is framed changes its effect, independent of its factual content. "Our onboarding takes 15 minutes" and "you'll be running in the time it takes to have a coffee" are factually equivalent; they produce different responses.

The critique surfaces the framing choices in copy — not to replace them with false frames, but to ask: is this the most persuasive true frame for this buyer? Copy that presents a list of rational features to a buyer who makes an emotional decision is ignoring how decisions actually work.

### Detecting generic-AI-aesthetic copy

Copy generated by or styled after AI content tools tends toward a recognizable cluster of failure modes:

- **Adjective stacking:** "seamless, intuitive, scalable solution" — multiple adjectives that each claim a distinct quality without any of them being specific.
- **Hollow abstractions:** "unlock the power of," "transform your," "supercharge your" — verbs so generic they attach to any product.
- **Comprehensiveness signaling:** "everything you need," "end-to-end," "all-in-one" — claiming total coverage as a substitute for specific value.
- **Synthetic enthusiasm:** exclamation marks where none are needed; confidence that wasn't earned.
- **Feature as benefit:** "100+ integrations" without "so that [outcome]."

These patterns aren't uniquely AI-produced — they've existed in bad marketing copy for decades. AI tools have made them the path of least resistance because they are the modal output of training data that skews toward mediocre marketing copy. The critique names them explicitly when present.

### Vague-claim taxonomy

The critique flags vague claims in these categories:

| Vague-claim type | Example | What's missing |
|---|---|---|
| Adjective stack | "powerful, seamless platform" | Specific capability that earns the adjective |
| Superlative without evidence | "the best accounting software" | For whom? By what measure? |
| Feature without benefit | "100+ integrations" | "so that [outcome the buyer achieves]" |
| Benefit without mechanism | "close your books faster" | By how much? How? |
| Social proof without specificity | "hundreds of happy customers" | A specific customer, a specific outcome |
| Urgency without cause | "act now" / "limited time" | Why limited? What changes? |

## Application

### Step 1 — Declare the surface and the audience

Before critiquing, state:

- **What surface?** (homepage hero, ad, email, deck slide, landing page)
- **Who is the audience?** (ICP from positioning canvas, or your best inference)
- **What is the awareness level?** (Schwartz's five levels — your inference, checked against context)
- **What is the copy supposed to do?** (Arrest attention? Build recognition? Drive a click? Trigger a demo?)

If you don't know any of these, the first critique finding is: "Audience and purpose not specified — the copy cannot be evaluated for fitness until they are."

### Step 2 — Read once without the framework

Read the copy once. Note your instinctive reactions:

- Where did you lose interest?
- Where did you feel talked-at rather than recognized?
- What did you retain after one read?
- What's the one thing the copy is trying to say? (If you can't answer in 8 words, neither can the buyer.)

Your instinctive reading is data. Record it before the framework.

### Step 3 — Apply the critique framework

Work through these checks in order. Each check that surfaces a finding becomes a finding in the output table.

**Check 1 — Headline.**
Is it doing Ogilvy's five-times job? Does it arrest the right reader, make a specific claim, convey a benefit? Could a competitor swap their name in and have it still read?

**Check 2 — Awareness-level match (Schwartz).**
What level is the copy written for? What level is the audience probably at? If they differ, what must change?

**Check 3 — Company language vs. customer language (Wiebe).**
Underline every phrase that sounds like internal vocabulary. Flag adjective stacks. Check: are the words the ones the customer uses to describe the problem, or the ones the company uses to describe the product?

**Check 4 — Feature-not-benefit.**
For every feature mentioned, ask: is there a "so that" completing it? Does the copy name the outcome the buyer achieves, or does it leave them to infer it?

**Check 5 — Vague claims.**
Check against the vague-claim taxonomy. Each vague claim that can be made specific should be flagged with a direction for specificity.

**Check 6 — Framing (Sutherland).**
Is the copy making rational arguments to an emotionally-deciding buyer? Is the value framed from the buyer's perspective or the company's? What's the implicit bet about how buyers make decisions?

**Check 7 — Generic-AI-aesthetic patterns.**
Check for the cluster: adjective stacking, hollow abstractions, comprehensiveness signaling, synthetic enthusiasm, feature-as-benefit. Name each instance.

**Check 8 — Evidence.**
Does the copy make claims it doesn't support? Is social proof specific or generic? Are quantified outcomes present?

### Step 4 — Produce the critique table

For each finding:

```markdown
| # | Surface | Severity | What's wrong | Principle | Rewrite direction |
|---|---------|----------|-------------|-----------|-------------------|
| 1 | Headline | Blocker | [exact phrase] — [why it fails] | [source + principle] | [direction, not finished copy] |
```

Severity guide:
- **Blocker:** Copy actively misleads, repels, or fails to engage the right buyer. The surface should not ship as-is.
- **Concern:** Copy fails to convert as well as it could; doesn't send buyers away but doesn't pull them in. Should be improved before launch if time allows.
- **Note:** Polish-level. Doesn't block shipping; worth addressing in the next cycle.

### Step 5 — State what to keep

Name the copy elements that are working. A critique that only destroys misses the point. Ogilvy's discipline: what's earning its place? The copy owner needs to know what the framework protects, not just what it challenges.

### Step 6 — Prioritize

If there are more than five findings, rank the top three and say why. The copy owner often has one sprint to fix copy before a launch; the critique should help them spend it well.

## Examples

### Example 1 — Copy critique table (homepage hero, B2B SaaS accounting)

**Copy submitted:**

> Headline: "The powerful, seamless platform for modern finance teams"
> Sub: "LedgerStack gives you everything you need to close faster, report better, and scale with confidence. 100+ integrations. AI-powered insights. Trusted by 500+ companies."

| # | Surface | Severity | What's wrong | Principle | Rewrite direction |
|---|---------|----------|--------------|-----------|-------------------|
| 1 | Headline | Blocker | "powerful, seamless" — adjective stack; any competitor can use these words; no specific value claimed | Wiebe (company language); Ogilvy (headline must make specific claim) | Lead with the buyer's outcome or problem. Draft direction: "Close your books in 2 days, not 10 — built for multi-entity finance teams" |
| 2 | Headline | Blocker | "modern finance teams" — audience is unspecific; a solo freelancer and a 12-entity CFO both read "modern finance teams" | Schwartz (awareness-level match — copy must arrest the right reader) | Name the specific segment: "multi-entity scale-up CFOs" or the specific trigger: "when you have more entities than your accounting software can handle" |
| 3 | Sub | Concern | "100+ integrations" — feature without benefit; the buyer doesn't know what outcome 100 integrations produces for them | Ogilvy (benefit over feature); Wiebe (buyer outcome language) | "Connects to the tools your team already uses — no re-keying, no CSV exports, no monthly reconciliation ritual" |
| 4 | Sub | Concern | "AI-powered insights" — generic-AI-aesthetic; "AI-powered" is now default background radiation in SaaS copy; it signals nothing about specific capability | Generic-AI-aesthetic detection | Replace with a specific capability: "Flags intercompany discrepancies before close — without a controller doing the manual check" |
| 5 | Sub | Note | "Trusted by 500+ companies" — social proof too generic; the buyer wants to know if *companies like theirs* trust it | Ogilvy (evidence specificity) | Add segmentation: "Trusted by 300+ multi-entity scale-ups, including [named customer]" or a specific outcome quote |
| 6 | Headline | Note | "scale with confidence" — hollow abstraction; confidence is a feeling, not an outcome; buyers can't verify it | Wiebe (customer language vs. company language) | Replace with a specific outcome: "add a new entity in 15 minutes, not a quarter" |

**What to keep:** The sub's opening verb "gives you" orients toward the buyer. "Close faster, report better" names buyer outcomes (good direction; need more specificity on "faster" and "better"). The overall three-benefit structure (close / report / scale) is a reasonable shape.

**Top 3 priorities for a one-sprint fix:** (1) Rewrite the headline with specific audience + outcome — this is the five-times-read surface; (2) Replace "AI-powered insights" with a specific capability — it's actively eroding trust with a technically literate audience; (3) Specificity-upgrade on "500+ companies" to include a segment signal or a named customer.

### Example 2 — Awareness-level mismatch (onboarding email for Problem-Aware audience)

**Copy submitted (Day 1 onboarding email, subject: "Unlock the power of LedgerStack"):**

> "Welcome to LedgerStack! Here's what you can do with your new account:
> - Configure your chart of accounts
> - Connect your integrations
> - Invite your team
> Start exploring →"

**Critique:**

The copy is written for a Most-Aware (Level 1) or Product-Aware (Level 2) buyer — someone who chose LedgerStack and is ready to configure. But Day 1 onboarding emails are delivered to new signups who are at varying points of commitment, some of whom signed up impulsively and haven't yet *decided* to use the product.

The headline ("Unlock the power") is generic-AI-aesthetic. The CTA ("Start exploring") is activation-free — it asks the buyer to go find the value themselves.

For a Problem-Aware buyer who signed up after a painful month-end: the email should start with the problem they just came from, then connect each setup step to the relief it produces.

Rewrite direction:
- Subject: "Most people finish their first close in 2 days. Here's the setup that gets you there."
- Open: Name the problem. "If you signed up because your last month-end was brutal, this email is for you."
- Connect each step to outcome: "Connect your existing accounting software — so you don't re-key a single transaction."
- CTA that is outcome-shaped: "Set up your first entity (15 minutes) →"

## Common Pitfalls

### Pitfall 1 — Critique as taste expression

**Symptom:** The critique says "this feels generic" or "I'd write it differently" without naming which principle is violated and how to fix it.

**Consequence:** The copy owner doesn't know what to change; the next draft is the copy owner's best guess about what the reviewer wanted.

**Fix:** Every finding cites a principle and proposes a rewrite direction. "Feels generic" is aesthetics; "this is company language (Wiebe) — swap [specific phrase] for customer-sourced language from the VOC corpus" is craft.

### Pitfall 2 — Blocking a launch on Note-level findings

**Symptom:** All findings are marked Blocker; the review is a comprehensive list of everything sub-optimal.

**Consequence:** The team either ships and ignores the critique (loss of credibility) or delays the launch over polish (opportunity cost greater than copy gap).

**Fix:** Severity is load-bearing. Blockers are only findings that actively mislead buyers or repel the target ICP. Most copy ships with Concerns and Notes. Prioritize the top 3.

### Pitfall 3 — Rewriting the copy for the owner

**Symptom:** The critique produces finished alternative copy in the reviewer's voice.

**Consequence:** The copy owner loses ownership; the finished copy may reflect the reviewer's voice rather than customer language; the methodology doesn't transfer.

**Fix:** Rewrite *direction*, not finished copy. "Lead with [specific problem] using the customer's language from [VOC source]" transfers the method. "Here's the exact copy:" does not.

### Pitfall 4 — Ignoring awareness level

**Symptom:** Critique evaluates copy against a single standard ("is it compelling?") without asking what level of buyer it's addressing.

**Consequence:** Compelling copy for a Most-Aware buyer (lead with offer) will correctly be critiqued as "too promotional" for an Unaware audience — but the fix isn't to "make it less promotional," it's to move the opening from offer to shift.

**Fix:** Always state the intended awareness level in Step 1. Let Schwartz govern the opening strategy.

### Pitfall 5 — "AI-generated" as a finding without specifics

**Symptom:** The critique notes "this sounds like AI wrote it" without naming the specific patterns.

**Consequence:** Not actionable. The copy owner doesn't know what to change.

**Fix:** Name the specific pattern — adjective stack, hollow abstraction, comprehensiveness signaling — and the specific instance. "Seamless, intuitive, scalable (adjective stack): replace with one specific claim that earns its place" is actionable.

### Pitfall 6 — Critiquing without knowing the positioning

**Symptom:** Critique evaluates copy without knowing the product's positioning — who it's for, what differentiates it, what the customer language is.

**Consequence:** Findings reflect the reviewer's guesses about the buyer, not the product's actual positioning. Rewrite directions may be precise but wrong.

**Fix:** Step 1 requires naming the audience and positioning anchor. If the positioning canvas is available, read it first. If it's not, the first finding is "positioning canvas missing — VOC and differentiation claims cannot be verified."

## References

- **David Ogilvy** — *Ogilvy on Advertising* (1983); *Confessions of an Advertising Man* (1963). The headline-as-five-times-the-ad discipline; testing-driven copy; the long-copy thesis; benefit over feature. See `roles/marketing-expert/sources.md`.
- **Joanna Wiebe** — Copy Hackers; voice-of-customer methodology; copy mining from customer sources; company language vs. customer language. See `roles/marketing-expert/sources.md`.
- **Eugene Schwartz** — *Breakthrough Advertising* (1966). The five awareness levels; matching copy to audience readiness. See also in `roles/marketing-expert/sources.md`.
- **Rory Sutherland** — *Alchemy: The Surprising Power of Ideas That Don't Make Sense* (2019). Framing over fact; the psycho-logic of purchase decisions. See `roles/marketing-expert/sources.md`.
- **Claude Hopkins** — *Scientific Advertising* (1923). Testing discipline; the copy-as-argument tradition that predates Ogilvy.
- **Bob Hoffman** — *The Ad Contrarian* essays. Skepticism of AI-generated copy claims; the case for specificity and human observation.
- **Related Hornero skills:**
  - [`positioning-canvas`](../positioning-canvas/SKILL.md) — the copy critique's positioning anchor; without it, Step 1 is incomplete.
  - [`voc-mining`](../voc-mining/SKILL.md) — produces the customer-language corpus the critique's Wiebe findings reference.
  - [`strategic-narrative`](../strategic-narrative/SKILL.md) — the narrative that homepage hero and sales-deck copy must implement.
  - [`pre-launch-marketing-audit`](../pre-launch-marketing-audit/SKILL.md) — the workflow that coordinates copy critique with channel and brief review.
