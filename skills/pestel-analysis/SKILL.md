---
name: pestel-analysis
description: Use when a team needs to scan the external macro environment — Political, Economic, Social, Technological, Environmental, Legal — for forces that could shift strategy, inform a market-entry decision, or feed a strategy-kernel diagnosis.
role: product-manager
intent: |
  Maps the six macro-environmental dimensions that sit outside any company's
  direct control but shape which strategies are viable and which are brittle.
  The output is not a catalogue of external facts — it is a prioritised short
  list of load-bearing forces, ready to feed the diagnosis step of a strategy
  kernel or stress-test the assumptions behind a bet-portfolio.
type: component
theme: outside-in
best_for:
  - Feeding the diagnosis step of a strategy-kernel before annual or quarterly planning
  - Stress-testing a market-entry or geo-expansion decision against macro risks
  - Grounding a competitive-teardown when the competitive threat is regulatory, economic, or platform-driven rather than product-driven
scenarios:
  - "I'm preparing the annual kernel refresh and need to surface macro forces the team is implicitly assuming away"
  - "We're evaluating an EU launch and need to know which PESTEL forces are material before the board deck"
  - "A regulatory change was just announced — run a rapid PESTEL scan to find what else in the environment is shifting at the same time"
estimated_time: "2–4 hours (first pass); 45–60 minutes (refresh on a prior scan)"
---

# PESTEL analysis

> v0 draft. Grounded in Aguilar's original environmental scanning framework
> (1967), Johnson, Scholes & Whittington's canonical PESTEL treatment
> (*Exploring Strategy*, 8th–11th editions), Porter's five-forces complement
> (*Competitive Strategy*, 1980), and Rumelt's diagnosis-shaping role for
> strategy work (*Good Strategy / Bad Strategy*, 2011). Editorial review
> recommended before production use.

## Purpose

Produce a prioritised map of the macro-environmental forces that could
materially shift what your product strategy must accomplish — and which ones
can safely be noted and parked.

PESTEL is a scanning lens, not a research destination. Its job is to surface
the forces operating at the level above industry dynamics: the forces that
reshape what the whole industry must contend with, not just what you must
contend with relative to a specific competitor. Done well, it generates a
short list of 3–5 material forces, each connected to a strategic implication.
Done badly, it generates a catalogue of 30 items no one reads after the
planning meeting.

The skill sits one level above competitive-teardown in the diagnostic stack:
PESTEL identifies the environmental conditions under which the competitive
game is played; competitive-teardown analyses how a specific competitor is
positioned within that environment. The canonical downstream consumer of a
PESTEL scan is the diagnosis step in strategy-kernel — the macro forces that
are material should either name or sharpen the crux.

## Key Concepts

### The six dimensions

Aguilar (1967) identified four macro scanning dimensions (Economic,
Technical, Political, Social — ETPS). Johnson, Scholes & Whittington extended
the canonical treatment to six, adding Environmental and Legal to produce the
PESTEL acronym used since the late 1990s:

- **Political** — government policy, political stability, trade agreements,
  public-sector procurement behaviour, subsidy regimes, sanctions exposure.
  Distinct from Legal: political forces are discretionary and subject to
  election cycles; legal forces are codified constraints.

- **Economic** — growth rates, inflation, currency movements, interest rates,
  consumer spending confidence, credit availability, labour-market tightness.
  The economic dimension sets the envelope for unit economics and pricing
  power across the horizon.

- **Social** — demographic shifts, cultural attitude changes, workforce
  composition changes, health and safety norms, media-consumption patterns,
  evolving customer expectations around trust or transparency. Social forces
  move slowly but irreversibly; they tend to be underweighted in annual
  planning cycles and overweighted in hindsight.

- **Technological** — platform infrastructure shifts, API ecosystem changes,
  AI/ML capability curves, open-source displacement, infrastructure pricing
  curves, digital-adoption rates in the target segment. Technological forces
  are where product teams most commonly confuse "interesting" with "load-
  bearing" — not every capability shift changes the strategic game.

- **Environmental** — climate-related regulatory pressure, physical climate
  risk to supply chains, ESG reporting requirements, carbon pricing,
  sustainability preferences from enterprise buyers. Material for physical
  products and logistics-heavy businesses; often low-impact for pure software
  (state that explicitly rather than leaving it blank).

- **Legal** — data-protection law (GDPR, CCPA and successors), sector-specific
  regulation (financial services, healthcare, AI Act), IP regime, employment
  law, anti-trust exposure. Legal forces are codified and enforceable now;
  political forces may become legal forces within the horizon.

### What PESTEL is not

**Not a substitute for SWOT.** PESTEL covers external macro forces only.
SWOT surfaces internal strengths and weaknesses alongside external
opportunities and threats. The standard sequence is PESTEL first — it
populates the Opportunities and Threats slots of a SWOT with macro-grounded
evidence rather than hunches.

**Not a substitute for Porter's five forces.** Porter's model
(*Competitive Strategy*, 1980) analyses industry-level structural forces:
supplier power, buyer power, substitutes, new entrants, rivalry. PESTEL
operates one level higher — the forces that shape the industry conditions
Porter's model takes as inputs. Run PESTEL to understand the environment;
run five forces to understand the industry structure within it.

**Not a competitor analysis.** PESTEL says nothing about what a specific
competitor is doing. Use competitive-teardown for that. PESTEL may surface
macro conditions that affect which competitive strategies are viable — that
is the handoff.

### Signal versus noise — the materiality filter

The dominant failure mode in PESTEL is breadth without prioritisation:
every dimension gets three bullet points, none are ranked, and the output
is a list of true-but-undifferentiated facts about the world.

Rumelt's diagnosis-shaping framing (*Good Strategy / Bad Strategy*, ch. 1–2)
is the corrective: a macro force is **material** only if it changes the
diagnosis of the strategic challenge. Test each candidate force against three
questions:

1. **Relevance to this product and segment** — does this force directly
   affect the customers, channels, or cost structure this product depends on?
   If not, it belongs in a footnote, not the analysis.
2. **Magnitude within the horizon** — will it be meaningfully larger, smaller,
   or structurally different by the end of the planning horizon? Forces that
   are stable are constraints to design within, not strategic questions.
3. **Actionability** — does knowing this force change what the team should
   build, position, price, or refuse? A force with no actionable implication
   is background noise, not strategy input.

A well-executed PESTEL scan surfaces 3–5 material forces and explicitly
parks the remainder.

## Application

### Step 1 — Set horizon and scope (15 minutes)

Before scanning, name two parameters:

**Planning horizon.** PESTEL forces have different velocities. Legal changes
can arrive in 12–18 months; demographic shifts take a decade. The horizon
determines which forces are in-flight versus speculative. Typical horizons:
6–18 months (tactical), 18–36 months (strategic kernel horizon), 3–5 years
(market-entry bet).

**Product and segment scope.** A PESTEL scan for a US-based B2B fintech
serving community banks has a different relevant set of forces than a scan
for a consumer wellness app targeting Gen Z in Southeast Asia. Scope the
scan before scanning; an unscopped PESTEL defaults to the entire world and
produces noise.

Write one scoping sentence: *"PESTEL scan for [product] serving [segment] in
[geographies], horizon [months/years], to inform [specific decision or
artifact]."*

### Step 2 — Scan each dimension (30–60 minutes per pass)

For each of the six dimensions, identify candidate forces. Use a structured
evidence base: industry analyst reports, regulatory agency publications,
central bank communications, demographic studies, peer-reviewed technology
forecasts. Do not rely on intuition alone for macro claims — the political
and economic dimensions especially require cited evidence to be credible.

For each candidate force, write two things:
- A factual claim with a source and date.
- A product-specific implication: *"This force means [X] for our
  product/segment."*

A force without a product-specific implication is not yet ready to include —
either surface the implication or park the force.

### Step 3 — Apply the materiality filter (30–45 minutes)

With candidate forces assembled, apply the three materiality questions from
Key Concepts (relevance, magnitude, actionability) to each.

Classify each force as:

- **Material** — relevant, in-motion within the horizon, actionable. Include
  in the ranked output.
- **Monitor** — relevant but stable or speculative. Note it; schedule a
  review trigger (e.g., "if EU AI Act enforcement guidance is issued, escalate
  to material").
- **Park** — irrelevant to this product/segment/horizon. Acknowledge once and
  exclude from further analysis.

The materiality filter is where most of the analytical work happens. A team
that can't agree on what's material hasn't done the diagnosis; it has just
collected information.

### Step 4 — Rank material forces by strategic weight (15–20 minutes)

Order the material forces by their potential to change the strategic
diagnosis. This is a judgment, not a formula — it requires the PM to take a
position on which forces are most load-bearing for the specific product and
segment.

Format the ranked list as:

```
**Force 1 — [Short label] ([Dimension])**
Evidence: [Factual claim, source, date]
Implication: [What it means for this product/strategy]
Watch signal: [What would cause this force to accelerate, reverse, or compound]

**Force 2 — ...** [repeat]
```

Aim for 3–5 material forces in the ranked list. A PESTEL scan that produces
more than 7 material forces has not applied the materiality filter.

### Step 5 — Connect to the downstream artifact (15 minutes)

PESTEL analysis is an input, not an output. Before closing the scan, name
the downstream artifact it is feeding and what specifically it contributes:

- **Strategy kernel diagnosis:** which material forces should appear as
  part of the named crux, or as constraints on the guiding policy?
- **Bet-portfolio evidence:** which forces increase or decrease confidence
  in active bets?
- **Market-entry decision:** which forces are the primary go/no-go risks for
  the expansion scenario?
- **Competitive-teardown context:** which forces explain why the competitive
  landscape looks the way it does, or where it is heading?

A PESTEL scan without a named downstream artifact is an exercise. With one,
it is strategy input.

## Examples

### Worked example — US-based embedded fintech, 2026 horizon

**Scope.** Embedded payments and lending product for US-based community banks
($200M–$2B assets), 18-month horizon, informing the Q3 strategy-kernel
refresh.

---

**Materiality filter output (abbreviated)**

| Force | Dimension | Materiality | Rationale |
|---|---|---|---|
| Federal Reserve rate-cut trajectory (2 cuts priced in by end of 2026) | Economic | Material | Directly affects net-interest margin for community bank customers; shapes their appetite for fintech partnerships vs. in-house build |
| EU AI Act enforcement (extraterritorial reach for US firms with EU customers) | Legal | Monitor | No EU revenue today; watch if EU expansion bet advances |
| Stablecoin payment legislation advancing in Congress | Political/Legal | Material | Could fundamentally shift the payment-rail assumptions the product is built on within 18 months |
| Community bank consolidation accelerating (9% reduction in charters 2023–2025) | Economic/Social | Material | TAM is shrinking; must demonstrate cross-sell value per remaining bank faster |
| Open banking mandate expansion (CFPB §1033 rule effective 2026) | Legal | Material | Mandatory data portability shifts the switching-cost structure for data-dependent products |
| Climate stress-testing requirements for banks (OCC guidance, 2025) | Environmental/Legal | Monitor | Low direct impact; watch if it shapes bank tech-spend priorities |
| Remote work normalisation reducing branch transaction volume | Social | Park | Already priced into the market; not a 2026 inflection point |

---

**Ranked material forces**

**Force 1 — Open banking portability mandate (Legal)**
Evidence: CFPB §1033 final rule effective October 2025 requires covered
institutions to provide consumer-authorised data access via standardised APIs
(CFPB, October 2024).
Implication: Products that built moats on data exclusivity face structural
erosion. The switching cost previously embedded in "we have your full
transaction history" dissolves when that history is portable. This changes
the diagnosis: the moat must move to workflow depth and relationship, not
data lock-in.
Watch signal: Implementation timeline litigation; if enforcement delayed
beyond Q2 2026, reduce urgency.

**Force 2 — Stablecoin payment legislation (Political/Legal)**
Evidence: Bipartisan GENIUS Act and STABLE Act both advanced committee votes
in Q1 2026; floor vote expected H2 2026 (Congressional Research Service,
March 2026).
Implication: If either bill passes, the regulatory framework for stablecoin
payments shifts from hostile to defined. Community banks that have avoided
stablecoin rails on compliance grounds gain a clearer on-ramp. This is an
opportunity if the product can position for the transition; a threat if
incumbents move faster.
Watch signal: Floor vote scheduling; any executive-branch commentary on
signing intent.

**Force 3 — Community bank charter consolidation (Economic/Social)**
Evidence: FDIC Call Report data shows 9% reduction in community bank charters
2023–2025; consolidation pace has not slowed (FDIC Quarterly Banking Profile,
Q4 2025).
Implication: TAM contraction is structural, not cyclical. The strategy kernel
must account for a shrinking customer base. Expansion via new charters is not
a credible path; growth must come from deeper penetration of remaining charters.
Watch signal: Quarterly FDIC charter count; any regulatory loosening of
de novo charter approvals.

---

**Downstream connection**

These three forces feed the strategy-kernel diagnosis as follows: Force 1
(open banking) weakens the existing data-lock-in assumption in the guiding
policy — the kernel must name this as part of the crux. Force 3 (consolidation)
sets a structural constraint on TAM that the guiding policy must acknowledge
explicitly. Force 2 (stablecoin legislation) is a near-term bet watch-item
for the bet-portfolio: if the bill passes in H2 2026, the stablecoin-rails
bet should be escalated from "watch" to "shape."

---

### Counter-example — kitchen-sink PESTEL that prioritises nothing

This is the failure mode the materiality filter is designed to prevent:

```
Political: Regulatory changes are happening. Trade policy is uncertain.
Economic: Inflation affects buying behaviour. Exchange rates fluctuate.
Social: Customers want better experiences. Demographics are shifting.
Technological: AI is advancing rapidly. Automation is changing work.
Environmental: Climate change is a global priority. ESG matters.
Legal: Data privacy laws are evolving. Compliance requirements are complex.
```

Every statement is technically true. None are specific to any product,
segment, or horizon. None contain an evidence citation. None surface an
implication. The materiality filter was never applied — every force was
included because excluding any felt like oversight. The output cannot feed
a diagnosis, change a bet's confidence, or inform a single resource-allocation
decision. This is PESTEL as box-ticking, not PESTEL as strategy input.

**The tell:** if every dimension has roughly the same number of bullets and
no force is ranked higher than any other, the materiality filter was skipped.

## Common Pitfalls

### Pitfall 1 — Scanning without a horizon or scope

**Symptom.** The PESTEL covers "global trends" with no named product, segment,
or time horizon. Every dimension has 4–6 bullets of roughly equal weight.

**Consequence.** The output is true but undifferentiated — it describes the
world, not the strategic challenge. No force can be ranked as more material
than any other because there is no anchor point for comparison.

**Fix.** Write the scoping sentence in Step 1 before the first force is
identified. If the horizon and segment scope cannot be named, the upstream
decision has not been made — clarify that first.

### Pitfall 2 — Including forces with no product-specific implication

**Symptom.** A force is listed (e.g., "climate change is a global priority")
with no sentence connecting it to this product's customers, cost structure,
or competitive position.

**Consequence.** The force consumes space and attention without informing any
decision. Readers rightly discount the entire scan when they encounter several
of these.

**Fix.** For each force, require a written implication: *"This means [X] for
[this product/segment]."* If the implication cannot be written, park the
force. Honest acknowledgment that a dimension is low-impact for a specific
product is more useful than a filler entry.

### Pitfall 3 — Confusing political intent with legal constraint

**Symptom.** A proposed regulation that has not yet passed is treated with
the same weight as an existing law. Or a legal requirement is labelled as
"political."

**Consequence.** Strategic responses are planned for constraints that may
never arrive, while existing legal obligations are underweighted.

**Fix.** Separate political forces (discretionary, subject to change) from
legal forces (codified, currently enforceable). For political forces that
could become legal, use the "Monitor" classification with an explicit watch
signal tied to the legislative trigger.

### Pitfall 4 — Using PESTEL as a substitute for industry analysis

**Symptom.** The PESTEL scan covers competitive dynamics, supplier power,
or category rivalry — things that belong in a Porter five-forces analysis or
a competitive-teardown.

**Consequence.** The two frames are conflated. Macro-environment forces (which
affect all players in the industry) are mixed with industry-structure forces
(which determine relative profitability within it). The output cannot feed
either a kernel diagnosis or a competitive-teardown cleanly.

**Fix.** Keep PESTEL strictly at the macro level — forces that apply to the
entire industry and beyond, not to a specific competitive configuration. When
a PESTEL scan surfaces an industry-structural implication, note it and route
it to competitive-teardown or a five-forces pass.

### Pitfall 5 — Running PESTEL once and treating it as permanent

**Symptom.** The PESTEL scan from the last annual planning cycle is referenced
in the current kernel draft with no refresh.

**Consequence.** The diagnosis is built on a stale environmental map. Forces
that were speculative may have crystallised (legislation passed, demographic
shift accelerated); forces that were material may have resolved.

**Fix.** Attach a review cadence to the scan: full refresh for annual kernel
cycles, lightweight refresh (materiality re-rating only) at each quarterly
check-in. Add watch signals to each material force so that a specific trigger
event prompts an out-of-cycle refresh rather than waiting for the calendar.

### Pitfall 6 — Skipping the downstream connection

**Symptom.** The PESTEL scan is completed and filed. The strategy-kernel
diagnosis written in the same planning cycle does not reference any of the
material forces.

**Consequence.** The scan was an exercise, not strategy input. The diagnostic
work is wasted; the kernel is weaker for being disconnected from the macro
context.

**Fix.** Step 5 is not optional. Name the downstream artifact and the specific
contribution before closing the scan. If a material force does not connect to
the downstream artifact, re-examine whether it is genuinely material — or
whether the downstream artifact has not fully incorporated the macro context.

## References

- **Francis Aguilar** — *Scanning the Business Environment* (1967, Macmillan).
  The original ETPS framework (Economic, Technical, Political, Social) from
  which PESTEL descends. Aguilar established the practice of systematic
  environmental scanning as a distinct analytical discipline, separate from
  industry analysis or competitive research. The four-dimension frame was
  the first codified macro-scanning approach in strategy literature.

- **Gerry Johnson, Kevan Scholes & Richard Whittington** — *Exploring
  Strategy* (multiple editions from 8th through 11th, Pearson). The canonical
  PESTEL treatment: the extension of Aguilar's four dimensions to six
  (adding Environmental and Legal), the framework's integration into
  strategic-planning curricula, and the structured analytical sequence this
  skill's Application section adapts. The 8th edition (2008) is the
  commonly cited locus for the six-dimension formulation.

- **Michael Porter** — *Competitive Strategy: Techniques for Analyzing
  Industries and Competitors* (1980, Free Press). The five-forces model
  operates at the industry level — one analytical step below PESTEL. Porter
  provides the structural complement to PESTEL's macro-environment lens: once
  macro forces are mapped, five forces explains how industry economics are
  shaped by supplier and buyer power, substitutes, new entrants, and rivalry.
  The two frameworks are sequentially complementary, not substitutes.

- **Richard Rumelt** — *Good Strategy / Bad Strategy: The Difference and Why
  It Matters* (2011, Crown Business). The diagnosis-shaping role in this
  skill — specifically the materiality filter and the requirement that every
  analytical input connects to a named crux — traces directly to Rumelt's
  treatment of diagnosis in ch. 1–2. A PESTEL scan that does not change or
  sharpen a diagnosis is, in Rumelt's terms, potentially informative but not
  yet strategic.

- **Related Hornero skills:**
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the primary downstream
    consumer of a PESTEL scan. Material forces from the scan should appear
    in the diagnosis step or constrain the guiding policy. A kernel refresh
    that does not include a PESTEL pass risks diagnosing internal symptoms
    while missing macro-level structural shifts.
  - [`competitive-teardown`](../competitive-teardown/SKILL.md) — the
    competitive-teardown operates one level below PESTEL, analysing a specific
    competitor within the macro environment the PESTEL scan describes. Run
    PESTEL first when the competitive threat is regulatory, platform-driven,
    or macro-economic in origin, not just product-driven.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — material PESTEL forces
    should be reflected in the evidence weighting of active bets. A bet
    premised on a stable regulatory environment should have its confidence
    rating revised when a relevant legal or political force is classified as
    material and in-motion.
  - [`company-research`](../company-research/SKILL.md) — company research
    provides the internal evidence base (unit economics, customer data,
    strategic posture) that the PESTEL scan contextualises with macro-
    environmental forces. The two are companion inputs to kernel diagnosis.

*Synthesis cue: adapted from Dean Peters'
[Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/pestel-analysis)
(CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
