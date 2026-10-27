---
name: revenue-architecture
description: Use when the PM needs to map the full product growth system — funnel, activation, retention, expansion, churn — as a connected graph, identify the bottleneck stage, and surface which levers move the system vs which produce only local lift.
role: product-manager
intent: |
  Produces three artifacts: a revenue-architecture diagram (nodes + flows +
  feedback loops, not a linear funnel), a leverage analysis (bottleneck
  identified, lever hypotheses confidence-weighted and LNO-classified), and
  an instrumentation gap list (stages with missing or invalid data). This is
  the PM's systems-mapping discipline; success-metrics and bet-portfolio are
  downstream of it.
type: workflow
theme: systems-thinking
best_for:
  - Quarterly or annual planning where growth is stalling and the cause is unclear
  - Pre-strategy work: before writing a bet portfolio or OKR, map the system
  - Investment-case debates: which stage deserves the next engineering cycle
  - Post-mortem when a growth initiative moved a local metric but not North Star
scenarios:
  - "PM suspects activation is the problem but the team has been optimising trial signup for two quarters"
  - "North Star metric flat for 90 days; CEO wants to know where the leak is"
  - "New PM joining a product with no coherent view of where revenue is actually coming from"
  - "Preparing the diagnosis section of a strategy kernel for a B2B SaaS product"
estimated_time: 90-150 minutes (first pass with existing data); 30-60 minutes (update cadence)
---

# Revenue architecture

> v0 draft. Anchored in Cutler's systems thinking and North Star Framework,
> Cagan's business viability risk, Gilad's Confidence Meter, and Doshi's LNO
> triage. Editorial review recommended.

## Purpose

Map the product's revenue system as a connected graph and identify where
the system's leverage actually lives.

The exercise produces three artifacts: a system diagram (nodes, flows, feedback
loops), a leverage analysis (bottleneck + weighted lever hypotheses), and an
instrumentation gap list. Together they make business viability risk concrete —
Cagan's category that most teams underweight because the leaks are invisible
without explicit mapping.

Distinct from [`success-metrics`](../success-metrics/SKILL.md): that skill is
*measurement design* for a single feature, launch, or quarter. Revenue-architecture
is *systems mapping* across the whole product economy — which stages are coupled,
where the bottleneck is, what lever moves what. Run revenue-architecture first;
success-metrics instruments what revenue-architecture surfaces as the binding
constraint.

Distinct from the data-scientist's `metric-definition` (a future `data-scientist` role skill):
that skill handles definitional integrity for a *single* metric. PM-led;
the data-scientist skill is the technical complement when stage-to-stage
correlations harden into causal claims.

## Key Concepts

### The pipeline as a system, not a funnel (Cutler)

A funnel implies linear sequential drop-off. Real growth systems have feedback
loops — retention feeds referral which feeds acquisition; activation quality
feeds expansion rate; churn signals re-enter via win-back. Representing the
system as a funnel makes the loops invisible. The diagram shape is nodes +
flows + feedback loops, not a waterfall. Canonical base shape:

```
traffic → trial → activation → retention → expansion
                      ↑              ↓           ↓
                 reactivation ← churn       referral → traffic
```

If the diagram has no cycles, it is still a funnel.

### The bottleneck principle (Cutler)

The slowest stage caps the whole system. Investment in a non-bottleneck stage
produces local improvement that does not move North Star. This is Cutler's
explicit systems-thinking critique of feature-factory growth work: optimising
downstream of the constraint is locally rational and system-irrelevant.

### Cagan's business viability risk

Cagan (*Inspired*) names four product risks: value, usability, feasibility,
and business viability. Viability risk — does caring about the product produce
a sustainable business? — is what revenue-architecture makes concrete. The
system diagram exposes whether unit economics hold at each stage.

### Gilad + Doshi on lever evaluation

For each lever hypothesis, apply two lenses:

- **Gilad Confidence Meter** (*Evidence-Guided*, 2024) — High (data + research),
  Medium (some evidence, significant uncertainty), Low (belief only). Low-confidence
  levers get cheap tests before resources.
- **Doshi LNO** — Leverage (disproportionate system-level return), Neutral
  (maintenance), Overhead (mandatory, minimise). Only L levers move North Star.

### North Star and activation

The architecture resolves to one North Star metric and its primary input metrics.
Without a named North Star, local stage optimisation has no integrating check.

Activation is the load-bearing stage for most SaaS products. The architecture
distinguishes activation *gates* (binary: did the user reach first value?) from
activation *quality* (gradient: how strongly?). Activation defined as signup or
first login is a vanity metric — activation must mean *value delivered*, not
*step completed* (Cutler, Cagan).

## Application

1. **Draw the system.** Adapt the base shape to the product's actual stages.
   Name each node; label flows with conversion rates; draw feedback loops
   explicitly (referral, reactivation, expansion-to-retention). If loops can't
   be drawn, the system isn't understood yet.

2. **Instrument-availability check.** For each stage: is it measured at all?
   Is the definition defensible (population, window, exclusions per the
   data-scientist's `metric-definition` standard)? Produce a gap list: one row
   per stage, status (measured / measured-but-suspect / not-measured), and
   what's missing. This is the data-scientist handoff.

3. **Map current performance.** Fill in conversion rates, retention curves,
   expansion rate, churn rate. Write data-quality caveats next to numbers, not
   in footnotes. A map with honest uncertainty is more useful than a clean
   diagram built on guesses.

4. **Identify the bottleneck.** The bottleneck is not simply the lowest
   conversion — some stages are structurally low and irreducible. The bottleneck
   is the stage where (a) conversion is low relative to what is achievable and
   (b) improvement propagates through the whole system. Test: "If this stage's
   rate improved 50%, what happens to North Star?" Proportional improvement =
   bottleneck. Name one.

5. **Generate lever hypotheses.** For the bottleneck and adjacent stages, produce
   3-5 lever hypotheses. Each names the change, the mechanism (why would this
   move the rate?), and the supporting evidence.

6. **Apply Gilad + LNO.** Classify each lever by confidence and L/N/O. Produce
   the investment matrix: High/L → resource now; Low/L → cheap test; High/N →
   schedule; Low/O → cut or automate.

7. **Cross-reference kernel and bet portfolio.** Does the bottleneck update the
   [`strategy-kernel`](../strategy-kernel/SKILL.md) diagnosis? Does the leverage
   analysis add, remove, or reweight bets in [`bet-portfolio`](../bet-portfolio/SKILL.md)?
   A leverage lever not in the portfolio is a gap. A portfolio bet targeting
   a non-bottleneck stage is a misallocation to surface.

8. **Produce the handoff list.** Three outputs: instrumentation gaps → data-scientist
   (prioritised by stage load-bearing weight); lever experiments → relevant teams
   (L/High-confidence as experiment briefs, L/Low-confidence as cheap-test proposals);
   measurement designs → [`success-metrics`](../success-metrics/SKILL.md) for each
   lever approved for investment.

## Examples

### B2B PLG SaaS — self-serve free trial

**System (with loops)**

```
traffic → trial signup → activation → paid customer → expansion (NRR 105%)
               ↑               ↓           ↓                ↓
          reactivation ← churn (15%/mo)  referral → traffic (15% of new trials)
```

**Current performance**

| Stage | Rate | Data quality |
|-------|------|-------------|
| Trial → activation | 12% | Measured; definition suspect — "created a project", not "completed one" |
| Activation → paid | 60% | Measured; reliable |
| Monthly MRR churn | 15% | Measured; reliable |
| Net revenue retention | 105% | Measured; reliable |
| Referral sourcing | 15% of trials | Self-reported; likely understated |

**Bottleneck.** Trial → activation at 12% is the system constraint. Activation-to-paid
is already 60% — improving it to 70% adds 10 points to a 12% base (incremental).
If trial-to-activation moves from 12% to 20%, every downstream stage (conversion,
retention base, expansion base, referral compounding) scales from a larger activated
cohort. North Star (net new MRR) moves proportionally.

**Instrumentation gap.** Activation definition is suspect. Data-scientist handoff:
harden the definition using `metric-definition`; re-baseline; compute activation→paid
correlation per event type before drawing investment conclusions.

**Lever hypotheses**

| Lever | Confidence | LNO | Next action |
|-------|------------|-----|-------------|
| Template gallery — surfaces first completed project in session 1 | Medium | L | Cheap test: 2-week A/B; OEC = hardened activation rate |
| In-app activation coach at session-2 for non-activators | Low | L | Qualitative interviews first; validate session-2 stall hypothesis |
| Email re-engagement for day-3 non-activators | Medium | N | Schedule; keeps system running, doesn't move bottleneck |
| Sales-assist for high-ICP non-activators (intent + firmographic signal) | High | L | Type-1 bet: add to bet-portfolio; `success-metrics` run before resourcing |

**Leverage list.**
- Instrumentation gap → data-scientist: harden activation metric, re-baseline.
- Cheap experiment → growth team: template gallery A/B, activation-to-paid 30-day cohort as counter-metric.
- New bet → portfolio: sales-assist for high-ICP non-activators; `success-metrics` design required.

## Common Pitfalls

### Funnel-as-architecture

**Symptom.** The diagram is a straight waterfall with no loops.

**Consequence.** Referral-driven acquisition and expansion feedback are invisible.
The retention → referral → new-trial compounding loop — often the highest-leverage
mechanism in a PLG product — doesn't appear.

**Fix.** Draw loops before filling in conversion rates. If no cycles exist, it is
still a funnel.

### Local optimisation

**Symptom.** The team invests a quarter in raising activation-to-paid from 60% to
68%. North Star moves 1%.

**Consequence.** Real effort, local result. The bottleneck was trial-to-activation;
downstream investment was capped by the size of the activated cohort.

**Fix.** Apply the bottleneck test (Step 4) before scoping any investment. "If this
stage improved 50%, what happens to North Star?" must have a proportional answer.

### No instrumentation reality check

**Symptom.** The system diagram has clean conversion rates at every stage. The
data-scientist wasn't involved. Nobody checked whether the activation event
correlates with retention at the user level.

**Consequence.** The leverage analysis is built on guesses formatted as data.
The bottleneck may be an artefact of a broken metric.

**Fix.** Step 2 is mandatory. A map with question marks is more honest and more
useful than a clean diagram on suspect data. Route the gap list to the data-scientist
before drawing investment conclusions.

### Crossing into the data-scientist's lane

**Symptom.** PM proposes "activation drives retention" based on stage-to-stage
correlation in the diagram.

**Consequence.** Stage rates are observational. High-ICP users activate *and* retain
better — not because activation causes retention, but because ICP is a confounder.

**Fix.** Flag causal claims; refer to the data-scientist's
`causal-dag` (a future `data-scientist` role skill).
The architecture says "the correlation suggests a relationship"; the DAG makes
the causal structure explicit.

### No connection to the bet portfolio

**Symptom.** The architecture analysis is filed as a deck and never referenced again.

**Consequence.** Six months later the team debates investments with no reference
to the system-level diagnosis. Bets drift back to non-bottleneck stages.

**Fix.** Step 7 is mandatory. The bet portfolio references the most recent
architecture as its diagnosis input. When the architecture is re-run, the portfolio
updates alongside it.

### Activation defined as signup or first login

**Symptom.** Trial-to-activation looks strong (50-70%) because activation = "logged in."

**Consequence.** Users who "activate" by logging in without reaching first value
churn at rates indistinguishable from non-activators. The bottleneck is invisible.

**Fix.** Ask: does a user who just crossed this gate retain at a meaningfully higher
rate than one who didn't? If no, the definition is wrong. Activation = value delivered.

## References

- **John Cutler** — North Star Framework; The Beautiful Mess writing; systems-thinking
  in product; "feature factory" diagnostics. The pipeline-as-system framing, feedback-loop
  diagram shape, and bottleneck-investment discipline are Cutler-anchored throughout.
- **Marty Cagan** — *Inspired* (2017). Business viability risk as a first-class product
  risk that revenue-architecture makes concrete.
- **Itamar Gilad** — *Evidence-Guided* (2024). Confidence Meter applied to lever
  hypotheses in Step 6.
- **Shreyas Doshi** — LNO framework (Leverage / Neutral / Overhead). Applied to lever
  classification in Step 6.
- **Related Hornero skills:**
  - [`success-metrics`](../success-metrics/SKILL.md) — downstream: instruments the
    binding constraint surfaced here. Trigger per lever approved for investment.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — leverage analysis adds, removes, or
    reweights bets. Cross-reference in Step 7.
  - [`strategy-kernel`](../strategy-kernel/SKILL.md) — the bottleneck often appears in
    the kernel's diagnosis. Cross-reference in Step 7.
  - `metric-definition` (a future `data-scientist` role skill)
    (data-scientist) — hardens individual stage metrics before investment decisions.
  - `causal-dag` (a future `data-scientist` role skill)
    (data-scientist) — use when stage correlations are proposed as causal.
