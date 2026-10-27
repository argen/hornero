---
name: company-research
description: Use when a PM needs to produce a structured research pass on a company — competitor, acquirer, partner, or prospect — that goes beyond surface-level web search and yields a defensible brief with source discipline.
role: product-manager
intent: |
  Guides the PM through a tiered intelligence-gathering process that moves from
  question-first framing through structured source selection to a synthesis brief.
  The output is not a company biography — it is an answer to a specific strategic
  question, grounded in verifiable sources, with gaps named explicitly. LLM-generated
  specifics (quotes, numbers, launch dates) must always be verified against primary
  sources before the brief is shared or acted on.
type: workflow
theme: outside-in
best_for:
  - Building a competitor intelligence brief before a strategy-kernel refresh or bet-portfolio exercise
  - Preparing for a partnership or acquisition conversation where the other party's strategy is underexplored
  - Giving a new PM a rapid, structured ramp on a key market player
scenarios:
  - "A competitor just closed a $50M round and is expanding into our core segment — I need a brief by Monday"
  - "We're heading into a partnership conversation with a platform company and I've never looked at them carefully"
  - "I'm joining a new team and need to understand the two main competitors before my first strategy week"
estimated_time: "3–6 hours (first brief); 1–2 hours (refresh of a prior brief)"
---

# Company research

> v0 draft. Grounded in Bensoussan & Fleisher's competitive-intelligence framework, Porter's
> five-forces lens, and Dunford's positioning-context framing. LLM assistance accelerates
> source discovery and synthesis but introduces hallucination risk — every named quote, metric,
> or date must be traced to a primary source before the brief leaves your hands.

## Purpose

Produce a structured research brief that answers a specific question about a named company —
not a general-purpose dossier. The question drives source selection; source selection drives
depth; depth drives the brief.

The output is a two-to-four page artifact: question, answer, supporting evidence by tier,
signal gaps, and open questions. It feeds the `strategy-kernel` diagnosis, the
`competitive-teardown` product analysis, the `positioning-statement` refresh, and any
partner or acquisition prep work.

This skill covers **company-level** research: strategy, leadership posture, product direction,
market positioning, and observable signals. For deep product surface analysis (feature-by-feature,
JTBD mapping, switching costs), use `competitive-teardown`. For macro-environment framing
(regulatory, economic, social forces), use `pestel-analysis`.

## Key Concepts

### Research depth tiers

Not every question demands the same depth. Picking the wrong tier wastes time or produces thin
conclusions. Bensoussan & Fleisher (*Analysis Without Paralysis*) distinguish three practical tiers:

- **Surface** (30–60 min): company website, LinkedIn overview, Crunchbase/PitchBook, recent press.
  Sufficient for "who is this company?" context before a meeting. Not sufficient for any strategic
  decision.
- **Structured** (2–4 hrs): earnings transcripts or investor letters, executive interviews (podcasts,
  conference talks), product blog, engineering blog, job postings, G2/Capterra/Glassdoor reviews,
  regulatory filings. Sufficient for a competitive brief or partnership prep.
- **Deep** (1–2 days): primary customer conversations, channel-partner interviews, financial model
  reconstruction (for public co's), technical signal analysis (API docs, changelog depth, open-source
  repos), talent-flow mapping. Sufficient for an acquisition thesis or a major strategic bet.

Default to structured unless you can articulate why deep is warranted.

### Signal sources and what they reveal

| Signal source | What it reveals | Reliability | Staleness risk |
|---|---|---|---|
| Earnings calls / investor letters | Leadership priorities, admitted challenges, quantified bets | High (accountable) | Low (recent) |
| Executive podcast / conference talks | Stated philosophy, product framing, cultural tone | Medium (curated) | Medium |
| Engineering / product blog | Technical choices, architectural posture, hiring bar | High (shows, not tells) | Low |
| Job postings | Where they're investing now, capability gaps, team structure | High (revealed preference) | Very low |
| Product changelog / release notes | Shipping cadence, feature priorities, segment targeting | High | Very low |
| Customer reviews (G2, Capterra, TrustRadius) | Actual pain points, switching triggers, segment fit | Medium | Low |
| LinkedIn headcount / talent flow | Growth rate, function prioritisation, departures | Medium | Very low |
| Press coverage | What they want the market to believe | Low (managed) | Variable |
| Company website / "About" page | Brand positioning, not strategy | Low | Medium |

### The question this research must answer

Every brief is organised around a single primary question. Without it, research sprawls into a
company biography with no decision utility. Good questions are specific and time-bounded:

- "How is [competitor] repositioning their enterprise tier in the next 12 months, and what does
  that imply for our mid-market pricing strategy?"
- "What is [platform partner]'s stated developer ecosystem strategy, and are they moving toward
  direct competition with us?"
- "What evidence is there that [acquirer] is building the capability we have, rather than buying it?"

Dunford (*Obviously Awesome*) frames this as understanding your competitive context before you can
position against it. You cannot know how to differentiate until you know what they are actually
doing — not what their homepage says.

### The brief artifact shape

A well-formed brief contains:

1. **Primary question** — the one sentence the brief must answer.
2. **Summary answer** — the answer in 3–5 sentences, grounded in tier-2+ signals, with explicit
   uncertainty flags where evidence is thin.
3. **Evidence by tier** — organised sections for each tier used, with source citations and dates.
4. **Signal gaps** — what you could not find or verify; names the research's blind spots honestly.
5. **Implications** — what this means for the strategic question that prompted the research
   (feeds `strategy-kernel` diagnosis or `competitive-teardown` framing).
6. **Open questions** — residual questions with ownership and deadline.

### LLM-generated research: the specific risk

LLMs accelerate source discovery and synthesis but have two failure modes specific to company research:

- **Hallucinated specifics**: fabricated quotes, revenue figures, product names, or personnel titles
  that sound authoritative. These are the most dangerous because they read exactly like real research.
- **Stale data**: training-cutoff lag means that product launches, leadership changes, funding rounds,
  and strategic pivots from the last 12–18 months may be absent or wrong.

**Mitigation**: treat every LLM-generated specific (any named quote, exact number, or event date)
as a hypothesis to be verified against a primary source before it enters the brief. If you cannot
find the primary source in 5 minutes of searching, excise the claim.

## Application

Five steps; total PM time 3–6 hours for a structured brief. Step 1 is the most important and
typically the most skipped.

### Step 1 — Frame the primary question (15–30 min)

Write the primary question the brief must answer before opening any source. The question should:

- Name the company
- Name the strategic context (competitive pressure, partnership evaluation, market entry, etc.)
- Name the time horizon
- Imply the decision it feeds

Also write: "If I had this answer, what would I do differently?" If the answer is "nothing in
particular," the research is not yet tied to a decision. Reconsider scope or defer.

Output: one paragraph that you can paste as the brief's first section.

### Step 2 — Select sources for the right tier (20–30 min)

Based on the question, decide which tier you need (surface, structured, or deep). Then map the
question to the relevant signal sources. The mapping is not exhaustive; it is targeted:

- Strategy / leadership posture → earnings calls, investor letters, executive interviews
- Product direction → changelog, product blog, job postings in PM/Eng
- Market positioning → customer reviews, press (with skepticism), analyst coverage
- Capability investment → engineering blog, open-source repos, hiring patterns
- Cultural and org signals → Glassdoor (directional only), leadership LinkedIn posts, exec tenure

Write a short source list (6–12 sources) before you start scanning. This prevents the most common
failure mode: opening a browser, following link trails, and producing unfocused notes with no
structural thread.

### Step 3 — Structured scan (60–180 min depending on tier)

Work through the source list. For each source:

1. Capture the claim, quote, or data point — verbatim if quoting.
2. Record the source URL or citation and the date.
3. Tag it to the part of the primary question it informs.
4. Flag uncertainty: is this a primary source (accountable, first-person), secondary (journalist
   interpreting), or tertiary (analyst summarising analyst)?

When sources contradict each other, note the contradiction rather than discarding the minority
signal. Contradictions are often the most important findings — they reveal positioning gaps,
internal tension, or market confusion.

**When a source disagrees with your hypothesis**: record it. Research that confirms only what
you already believed is not intelligence; it is motivated reasoning. Porter (*Competitive Strategy*)
frames competitive analysis as uncovering the competitor's actual choices and constraints, not
confirming your existing model.

### Step 4 — Synthesise to the question (30–60 min)

Return to the primary question from Step 1. Write the summary answer in 3–5 sentences, using only
claims you can cite to tier-2 or higher sources. Then structure the supporting evidence into a
brief section per signal category (leadership posture, product direction, etc.).

Be explicit about signal gaps: "We could find no recent evidence of how [company] is thinking about
[topic]" is a legitimate and important finding. Gaps tell you where the competitive picture is
genuinely uncertain, which is strategic information.

Calibrate confidence:

- **High confidence**: multiple independent tier-1/tier-2 sources agree; the claim is recent and
  specific.
- **Medium confidence**: single credible source; or consistent but soft pattern across secondary
  sources.
- **Low confidence / flag**: LLM-generated or inferred; no primary source found; data > 18 months old.

### Step 5 — Produce the brief and name implications (30–60 min)

Write the brief in this shape:

```markdown
# Company research brief — [Company] / [Date]

**Primary question:** [one sentence]

## Summary answer
[3–5 sentences. Grounded in tier-2+ sources. Confidence level stated explicitly.
Gaps named.]

## Evidence

### Leadership posture and strategy
[Findings from earnings calls, investor letters, executive interviews. Source + date
for each claim.]

### Product direction
[Findings from changelog, product blog, job postings. Source + date.]

### Market positioning
[Findings from customer reviews, press (flagged as tier-3 where applicable), analyst
coverage.]

### [Additional section if signal category warrants it]

## Signal gaps
[What you could not find or verify. Be specific: "No public comment from leadership on
[topic] since [date]" is more useful than "limited information available."]

## Implications
[What this means for the strategic question that prompted the research. 3–5 bullets.
Feeds into: strategy-kernel diagnosis / competitive-teardown / positioning-statement /
other downstream skill.]

## Open questions
- [Question] — Owner: [name] — Due: [date]
```

## Examples

### Example 1 — Structured brief for a B2B SaaS team (good)

**Context.** A PM at a data-integration platform is preparing the Q3 strategy-kernel refresh.
A competitor recently raised a $40M Series B and announced a "unified data fabric" positioning.
The primary question is: "Is [competitor]'s new positioning a genuine capability shift or a
repositioning of the same product with a new name — and what does that imply for our mid-market
differentiation?"

**Step 1 output.** "Competitor X has repositioned from 'ETL tool' to 'unified data fabric' after
closing Series B. I need to know whether this reflects new capability (connectors, transformation
engine, semantic layer) or new marketing. The answer changes whether I need to accelerate our
semantic layer roadmap this quarter or hold."

**Step 2 source list.** Product changelog (last 6 months), Series B press release + any linked
exec quote, G2 reviews from the last 6 months, three recent job postings (data engineer, PM, sales
engineer), LinkedIn headcount delta over 12 months, the CTO's last conference talk (found via
YouTube).

**Synthesis finding.** "The changelog shows no new connector types in 6 months; the only material
release is a UI redesign of the pipeline builder. The CTO conference talk (re-watched) uses
'data fabric' but describes functionality identical to the prior 'ETL platform' messaging. G2
reviews from buyers in the last 3 months still categorise it as a transformation tool. Job
postings show 8 open roles in sales engineering and 0 in data science / ML — consistent with a
sales-motion repositioning, not a capability investment. Confidence: high that this is a marketing
move, not a capability shift."

**Implication.** "No need to accelerate the semantic layer roadmap on competitive grounds this
quarter. The differentiation window from our actual semantic layer remains intact. The
competitor's Series B is accelerating their sales motion, not their product — watch for pricing
pressure in deals, not feature parity."

**What makes this good.** The question was specific before any source was opened. The changelog
and job postings are revealed-preference sources that reveal investment decisions, not stated
intentions. The synthesis explicitly states confidence level and names the decision it affects.

---

### Example 2 — Wikipedia summary masquerading as research (bad)

```
Company: Acme Analytics
Acme was founded in 2015 and is headquartered in Austin, Texas. They offer a
cloud-based analytics platform for mid-market companies. The company has raised
$85M across three rounds and serves over 2,000 customers. Their CEO has said
the company is "focused on customer success and innovation."

Implication: Acme is a strong competitor with significant funding and customer base.
```

**What makes this bad.** The "primary question" is never stated — this is a profile, not
intelligence. Every fact is available from a homepage or Crunchbase; no tier-2 sources were
consulted. The CEO quote is a generic PR statement with no source, no date, and no context —
it reveals nothing about strategy. The "implication" is not an implication; it is a rephrasing
of "they are well-funded and have customers," which was already known. Nothing in this brief
changes any decision.

The tell: you could replace "Acme Analytics" with any competitor and the brief would read
the same. Real intelligence is specific; generic profiles are not intelligence.

## Common Pitfalls

### Pitfall 1 — Research without a question

**Symptom.** The PM opens a browser and starts collecting notes before writing a primary question.
The resulting brief is a company biography: comprehensive, chronological, and undirected.

**Consequence.** Hours spent; no decision-utility. Stakeholders ask "so what?" and the PM has
no clean answer because the research was not framed around a decision.

**Fix.** Step 1 is non-negotiable. Write the primary question and the decision it feeds before
opening any source. If you cannot write either in 10 minutes, the research is premature — surface
what you already know first and identify the specific gap.

### Pitfall 2 — Homepage depth mistaken for research

**Symptom.** The brief's sources are the company's About page, a press release, and a recent
news article. The synthesis reads like a product description.

**Consequence.** The brief reports what the company wants you to believe, not what they are
actually doing. This is worse than no research because it creates false confidence.

**Fix.** Tier-3 sources (press, website, PR copy) require corroboration from tier-1 or tier-2
sources before any claim is load-bearing. Job postings, changelogs, and earnings transcripts are
revealed-preference sources — they show investment decisions, not curated messages.

### Pitfall 3 — LLM-generated specifics left unverified

**Symptom.** The brief contains precise-sounding quotes, revenue figures, or product names
generated by an LLM without a primary-source citation. The PM does not flag them as unverified.

**Consequence.** Hallucinated specifics propagate into strategy documents, sales decks, or
exec presentations. Discovery of a fabricated claim in a high-stakes context destroys credibility
for the research and the PM.

**Fix.** Every quote must have a source URL and date. Every metric must trace to a primary
document (filing, earnings transcript, official announcement). If you cannot find the source in
5 minutes, excise the claim and note the gap. The brief is weakened; the decision is not poisoned.

### Pitfall 4 — Gaps hidden rather than named

**Symptom.** The brief omits topics where no evidence was found, presenting the covered areas
as a complete picture.

**Consequence.** Readers assume the absence of evidence is evidence of absence. The PM making
the decision does not know the research has blind spots in areas that may be critical.

**Fix.** A "Signal gaps" section is required, not optional. "We found no public comment from
leadership on [topic] since [date]" is a legitimate research finding. Naming gaps enables the
reader to calibrate confidence and assign follow-up work.

### Pitfall 5 — Confirming the hypothesis the PM already held

**Symptom.** The brief selects sources that support the existing view of the competitor and
omits or discounts contrary signals.

**Consequence.** Motivated research produces motivated conclusions. Strategy decisions made on
motivated research fail when they encounter the actual competitive reality.

**Fix.** When scanning, actively look for evidence that would change your conclusion. Record
every contradiction and include it in the brief. If the contradictions do not affect the summary
answer, explain why. If they do, update the answer.

### Pitfall 6 — Brief produced but not connected to a downstream skill

**Symptom.** The brief is written and filed. The strategy-kernel diagnosis or competitive
positioning work proceeds without referencing it.

**Consequence.** Research debt: the PM did the work; the work did not move the decision.
The brief becomes a shelf artifact.

**Fix.** The "Implications" section explicitly names the downstream skill or decision it feeds
(strategy-kernel, competitive-teardown, positioning-statement, bet-portfolio). Brief the relevant
owner at the end of Step 5; do not assume they will find it.

## References

- **Babette Bensoussan & Craig Fleisher** — *Analysis Without Paralysis: 12 Tools to Make Better
  Strategic Decisions* (2nd ed., FT Press, 2012). The tiered intelligence framework (surface,
  structured, deep), source taxonomy, and the discipline of organising analysis around a specific
  question rather than producing general-purpose profiles are grounded in Bensoussan & Fleisher's
  CI methodology. Primary reference for Steps 2 and 3 of this skill.
- **Michael E. Porter** — *Competitive Strategy: Techniques for Analyzing Industries and
  Competitors* (Free Press, 1980). The framing of competitor analysis as uncovering actual choices,
  constraints, and revealed preferences — rather than confirming existing beliefs — is a direct
  application of Porter's competitor-profiling chapter. The five-forces lens contextualises why
  company-level research matters beyond product feature comparison.
- **April Dunford** — *Obviously Awesome: How to Nail Product Positioning So Customers Get It,
  Buy It, Love It* (Ambient Press, 2019). Dunford's framing that you cannot position your product
  until you understand what you are actually competing against — and what the competitive
  alternatives are for the customer's job — anchors the "Implications" section of the brief and
  the connection to `positioning-statement`.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2nd ed., Wiley, 2017);
  *Empowered: Ordinary People, Extraordinary Products* (Wiley, 2020). The four-risk frame (value,
  usability, feasibility, business viability) informs what competitor signals matter most for
  diagnosis: a competitor's product investment pattern reveals where they believe their binding
  constraint is.
- **Related Hornero skills:**
  - [`competitive-teardown`](../competitive-teardown/SKILL.md) — the downstream product-surface
    analysis that a company-research brief feeds. Use company research to establish strategic
    context; use competitive-teardown for feature-level, JTBD, and switching-cost analysis.
  - [`pestel-analysis`](../pestel-analysis/SKILL.md) — companion macro-environment framing. Company
    research answers "what is this specific company doing?"; PESTEL answers "what forces are shaping
    the environment they and we both operate in?"
  - [`positioning-statement`](../positioning-statement/SKILL.md) — the company-research brief's
    Implications section feeds positioning refresh work directly.
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — company research is primary evidence for the
    kernel's diagnosis step. Run this skill before step 2 of strategy-kernel when the diagnosis
    involves competitive positioning or market context.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/company-research) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
