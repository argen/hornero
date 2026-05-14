---
name: gtm-sequencing
description: Use when a B2B product is choosing its go-to-market segment sequence — which segment to attack first (the beachhead), which to defer, which adjacent segments form the bowling alley after the beachhead is won. Moore-anchored, Aulet-criteria-driven, distinct from launch-brief (tactical) and positioning-canvas (definitional).
intent: |
  Implements Moore's chasm + bowling-alley methodology, sharpened
  by Aulet's beachhead criteria and Slootman's commercial-velocity
  discipline. GTM sequencing is the strategy layer between positioning
  (diagnosis) and launch-brief (tactics).
type: component
theme: commercial
best_for:
  - Pre-launch sequencing for a new B2B product
  - Re-sequencing when the current beachhead has plateaued
  - Diagnosing a stuck GTM (which chasm got us, what beachhead we should have picked)
  - Aligning pricing-strategy decisions across the sequence
scenarios:
  - "Series A startup picking the first vertical to attack with the new analytics tool"
  - "Mid-stage company $3M ARR plateaued in early adopters — diagnose the chasm"
  - "Enterprise platform launching a new product line — sequence relative to existing customer base"
estimated_time: 3-6 hours (full skill including beachhead scoring with input from PM and founder)
---

# GTM sequencing

> v0 draft. Grounded in Geoffrey Moore's *Crossing the Chasm* (1991, rev. 2014) and
> *Inside the Tornado* (1995), Bill Aulet's *Disciplined Entrepreneurship* (2013, rev. 2024),
> April Dunford's *Obviously Awesome* (2019), Frank Slootman's *Amp It Up* (2022), Mark
> Ritson's strategic-then-tactical sequencing, and Byron Sharp's *How Brands Grow* (2010).

## Purpose

Produce a go-to-market sequencing plan that names the beachhead segment, the bowling-alley
sequence of adjacent segments to attack after the beachhead is won, and — equally load-bearing
— the segments that are deliberately deferred and why.

Listing the segments you could pursue is not strategy. Naming the order, with explicit
reasoning and observable transition triggers, is. Most B2B product teams fail not because
they lacked segment options but because they tried to pursue too many simultaneously, ran
out of resource before achieving escape velocity in any of them, and crossed a chasm they
didn't see coming.

Geoffrey Moore (*Crossing the Chasm*) identified the structural break: the gap between early
adopters (who buy on vision and tolerance for incomplete solutions) and the early majority
(who buy on proven reference accounts and complete solutions) is wide enough to halt most
technology products permanently. The beachhead is the specific segment where you win enough
to build the reference base that carries you across.

**Cross-role link.** The positioning-canvas skill (`roles/marketing-expert/skills/positioning-canvas/SKILL.md`)
produces the "who-cares-most" segment — this is the first candidate beachhead. The PM's
bet-portfolio (`roles/product-manager/skills/bet-portfolio/SKILL.md`) frames which
job-to-be-done is the current company bet. GTM sequencing sits between them: it takes those
inputs and converts them into a sequenced, criteria-verified, time-bound GTM plan.

## Key Concepts

### The technology-adoption lifecycle

Moore's technology-adoption lifecycle (derived from Everett Rogers's diffusion research)
divides a market into five distinct populations, each with different buying motivations:

- **Innovators** (~2.5% of the market). Buy technology for its own sake; tolerate
  incompleteness and bugs; are motivated by novelty and the chance to influence the product.
  They are not a beachhead — they don't buy the way the early majority buys, and their
  reference accounts don't move pragmatists.
- **Early adopters** (~13.5%). Buy on vision: they can see how a disruptive capability
  solves a strategic problem and are willing to assemble the missing pieces themselves. They
  are relationship-driven, not reference-driven. Their reference accounts influence other
  early adopters, not the mainstream.
- **Early majority / pragmatists** (~34%). Buy on proof. They need reference accounts from
  companies like theirs, complete solutions (integrations, support, certifications), and low
  personal risk. They follow each other, not early adopters. This is the mass market.
- **Late majority / conservatives** (~34%). Buy on price and simplicity. They want
  commodity-safe choices — the industry standard. They follow the early majority.
- **Laggards** (~16%). Buy only when there is no alternative; often forced by compliance
  or end-of-life of the prior solution.

**The chasm** is the gap between early adopters and the early majority. Early adopters
tolerate a visionary incomplete solution; pragmatists will not act without a complete
solution and peer references. A product that has sold well to early adopters does not
automatically sell to pragmatists. This is the failure mode Moore documents extensively:
the product appears to be growing, early-adopter revenue looks encouraging, and then growth
stalls because pragmatists won't buy without references from people like themselves.

### The bowling-alley pattern

Moore (*Inside the Tornado*, 1995): the pragmatist market is not one undifferentiated mass.
It is composed of vertical segment niches, each with its own reference networks. Pragmatists
in one vertical follow each other; they don't follow pragmatists in adjacent verticals.

The bowling-alley pattern: win one segment completely (the lead pin), then use that segment's
references and product completeness as the force to topple the next pin, and so on. Each
successive segment is easier than starting cold because the prior win gives you reference
accounts, a complete-product blueprint, and sales-cycle velocity.

The shape: **beachhead segment → bowling-alley sequence → tornado (mainstream acceleration)**
→ **Main Street (commodity)**.

- **Beachhead:** One specific segment, fully won. Revenue may be modest. The win matters
  because it produces the reference accounts and product completeness that pragmatists in
  adjacent segments require.
- **Bowling alley:** Sequential segment expansion. Each segment selected because the
  prior segment's wins are credible there. Not simultaneous expansion — sequential.
- **Tornado:** When the product category tips into mainstream adoption, the constraint
  becomes distribution, not segment fit. Broad-reach marketing (Sharp) becomes affordable
  and effective. Mass market.
- **Main Street:** Market maturity, commoditization pressure, pricing erosion. Not GTM
  sequencing territory — that is product and pricing strategy.

### The whole product requirement

Moore's insight on why the chasm exists mechanically: early adopters assemble the missing
pieces themselves (integrations, workarounds, custom implementations). Pragmatists will not.
They require a **whole product** — everything they need to achieve the value the product
promises, without assembling it themselves.

The whole product typically includes:
- Core product (what you build).
- Integration with the tools the segment already uses (the stack they won't replace).
- Implementation support and documentation (for the segment's sophistication level).
- Certifications and compliance (SOC 2, GDPR, enterprise SSO — each segment has a
  different bar).
- Partner ecosystem and professional services (when integration complexity exceeds
  self-service).
- Customer references specifically from the segment (pragmatists check references from
  companies they recognize as peers, not from earlier-adopter reference accounts).

The whole product requirement changes at each bowling-alley transition. The second segment
almost always requires a different whole product than the first — different integrations,
different compliance profile, different support model. This is why the second segment is
harder than the first.

### Aulet's six beachhead-market criteria

Bill Aulet (*Disciplined Entrepreneurship*, 2013) gives the most operational version of
beachhead selection. A viable beachhead segment must satisfy all six:

1. **Identifiable.** You can name the companies and the buyers in this segment. If you
   can't build a target list of 200 companies, the segment is not defined.
2. **Accessible.** You can reach the buyers through channels you can afford and operate.
   A segment accessible only through relationships you don't have is theoretical.
3. **Strong reason to buy.** The segment has an urgent, felt problem your product solves.
   "They would benefit from" is weaker than "they are actively trying to solve this and
   the current alternatives are failing them."
4. **Whole product deliverable.** You can deliver the complete solution the segment needs
   today — without asking them to assemble missing pieces. This is the chasm-crossing
   requirement in operational form.
5. **Adjacent to a large next segment.** The beachhead win is a stepping stone, not an
   end state. The next segment must be reachable from the beachhead's reference base.
6. **Aligned with the founding team's strengths.** The team has unfair access to this
   segment — domain knowledge, existing relationships, or a technical advantage. A beachhead
   where you compete on equal footing is a poor beachhead; you want structural advantage.

### Slootman on commercial velocity at the beachhead

Frank Slootman (*Amp It Up*, 2022) adds the operator's discipline: segment selection is not
just about fit — it is about the commercial velocity the segment enables. A beachhead that
fits Aulet's criteria but produces a 12-month sales cycle, high churn, and low expansion
revenue is a poor beachhead even if it's technically winnable.

Slootman's frame: the beachhead should produce **land-and-expand economics**. Initial ACV
may be modest; expansion from the beachhead customer base (more seats, more modules, more
use cases within the same account) should add material revenue before you need to attack
the second segment.

The "sales-led vs. marketing-led GTM" debate (common at Series A) is, per Slootman, a false
dichotomy during the beachhead phase. Both are required in sequence: sales-led to win the
first reference accounts and learn the segment's buying process; marketing-led to scale
distribution once the sales playbook is proven. Attempting marketing-led scale before the
sales playbook exists wastes budget. Staying sales-led after the playbook exists leaves
growth on the table.

### Sharp on mental availability and the timing of broad reach

Byron Sharp (*How Brands Grow*, 2010): brand growth comes from penetration (reaching more
buyers in the category) rather than from loyalty (extracting more from existing buyers).
Mental availability — being thought of in buying situations by the widest possible set of
category buyers — is built through reach, frequency, and consistent distinctive assets over
time.

In GTM sequencing terms: broad-reach mental availability investment is the right move when
the product is in tornado or early Main Street phase — you can afford to reach the full
category, and the category is large enough that diffuse reach pays off. During the
beachhead and bowling-alley phases, broad-reach spend is too expensive and too slow per
sale. The constraint is reference-account density within specific segments, not share of
voice across the category. Sharp's prescription is for later-stage GTM; forcing it during
the beachhead phase is a common cash-burn mistake.

### The second segment is harder than the first

First-segment lessons transfer less than teams expect. Three structural reasons:

- **Whole product changes.** The second segment's pragmatists have a different integration
  stack, a different compliance profile, and a different support model. The whole product
  built for segment one is usually incomplete for segment two.
- **Reference accounts don't transfer.** Pragmatists check references from their peers.
  A reference from a segment-one company does not carry weight with a segment-two buyer.
- **Sales motion changes.** The buyer persona, the economic decision-maker, the objection
  set, and the success criteria often differ between segments. The sales playbook must be
  rebuilt, not reused.

Acknowledging this in advance — budgeting for a second beachhead investment, not just an
"expansion" — is the difference between a sequencing plan that survives contact with reality
and one that doesn't.

### Three distinct GTM postures

The skill produces plans in one of three postures, at different lifecycle stages:

1. **Beachhead phase.** One segment, fully won. Sales-led; whole-product investment;
   reference-account density. Metric: full segment penetration and net-dollar retention,
   not pipeline volume.
2. **Bowling-alley phase.** Sequential segment expansion. Playbook transfer where it works,
   rebuild where it doesn't. The beachhead references do the selling into the next segment.
3. **Broad-market launch (tornado / Main Street).** Broad-reach marketing becomes the
   right move. Distribution, channel partnerships, physical availability. Sharp's mental
   availability model applies. This posture is premature before the bowling alley is won.

## Application

### Step 1 — Confirm the positioning canvas is current and sharp

The positioning canvas (`roles/marketing-expert/skills/positioning-canvas/SKILL.md`)
produces the "who-cares-most" segment. Before scoring beachhead candidates, confirm the
canvas has been reviewed in the last six months, is grounded in customer interview evidence
(at least 10-15 interviews), and produces a specific segment rather than a category
("Series B-C SaaS PMs at 50-300 person companies with a product analytics gap" rather than
"product managers at growth-stage companies").

If the canvas is missing, stale, or produces a vague segment, pause the sequencing exercise
and complete the canvas first. GTM sequencing done against a vague who-cares-most is
premature.

Also cross-reference the PM's bet-portfolio (`roles/product-manager/skills/bet-portfolio/SKILL.md`):
which job-to-be-done is the current company bet? The GTM sequence should serve that bet,
not contradict it.

### Step 2 — List candidate beachhead segments (3-5)

Draft 3-5 candidate beachhead segments. For each, write one paragraph covering:

- The buyer persona (role, company stage, company size, industry vertical if relevant).
- The specific problem the product solves for this segment.
- The current alternative they use (the competitive comparison the positioning canvas names).
- An estimate of the addressable market within this segment — enough to be a meaningful
  beachhead without being so large it's not a segment.
- Why this segment came onto the list (a pattern in existing customers, a founder
  relationship, an observed market gap, a competitive-teardown finding).

The list should include the who-cares-most segment from the positioning canvas plus 2-4
alternatives. This creates the comparison that drives the scoring step.

### Step 3 — Score each candidate against Aulet's six criteria

For each of the 3-5 candidates, apply Aulet's six criteria qualitatively. A simple
format: three columns (criterion, score as Strong / Partial / Weak, and evidence).

| Criterion | Score | Evidence |
|---|---|---|
| Identifiable | Strong / Partial / Weak | Can you name 100+ target companies? |
| Accessible | Strong / Partial / Weak | Do you have channels to reach them? |
| Strong reason to buy | Strong / Partial / Weak | Urgency and alternatives failing? |
| Whole product deliverable | Strong / Partial / Weak | Can you deliver the full solution today? |
| Adjacent to large next segment | Strong / Partial / Weak | What does winning here unlock? |
| Aligned with team strengths | Strong / Partial / Weak | Unfair access or domain advantage? |

Candidates with Weak on Aulet criteria 3, 4, or 5 should be demoted or deferred — they
fail the beachhead test for commercial, whole-product, or strategic reasons respectively.
Surface the scoring to founders and the PM before proceeding.

### Step 4 — Choose the beachhead and name the bowling-alley sequence

From the scoring, choose the beachhead. State the choice explicitly:

> **Beachhead segment:** [One sentence: who, what problem, what alternative they're leaving.]
> **Why this segment and not [runner-up]:** [One paragraph naming the Aulet criteria where
> this segment won and where the runner-up was weaker.]

Then name 2-3 adjacent segments for the bowling-alley sequence, in order. For each,
state: why this segment is adjacent to the beachhead (shared reference networks, similar
whole product, adjacent buyer persona), and what the beachhead win enables there.

Bowling alley, written out: **Segment A (beachhead) → Segment B → Segment C.**
Each arrow is a decision, not a hope.

### Step 5 — Name the transition triggers between segments

A transition trigger is an observable signal that the beachhead is sufficiently won to
justify beginning the second-segment investment. Examples of the type of signal to define:

- ARR threshold from the beachhead segment (e.g., $X million ARR from segment-one accounts).
- Reference-account density (e.g., N named reference accounts willing to take reference
  calls from segment-two prospects).
- Net-dollar retention in the beachhead segment above a threshold (segment one is paying
  and expanding, not churning).
- Inbound pipeline from the second segment arriving without active investment (segment two
  is finding you via beachhead references before you've targeted them).

Name one primary trigger per transition. A team that does not have a named trigger tends
to over-invest in the first segment beyond the point of diminishing return, or jumps to the
second segment before the first is won. Both are failure modes.

### Step 6 — Map the whole product gap for the next segment

Before the transition trigger fires, map what is missing for the second segment's
pragmatists. This is Moore's whole product requirement applied prospectively.

For the second-segment whole product, answer each:

- **Integrations:** What tools does this segment already use that the product must connect
  to? What is the integration readiness today?
- **Compliance and certifications:** Does this segment require SOC 2 Type II, GDPR
  compliance, HIPAA, enterprise SSO, role-based access control? What is the current
  compliance posture vs. what this segment requires?
- **Support model:** What level of support does this segment expect? Will self-serve
  documentation suffice, or does the segment require dedicated CSM, SLA-backed support,
  or professional services?
- **Partners:** Are there implementation partners, system integrators, or channel partners
  already serving this segment whose endorsement or integration is required?
- **Reference accounts:** How many named reference accounts from segment two must be in
  hand before the segment's pragmatists will take meetings?

The whole product gap map becomes a product and partnership roadmap input. Cross-reference
the PM's competitive-teardown (`roles/product-manager/skills/competitive-teardown/SKILL.md`)
for segment-level whole product benchmarks from the existing competitive analysis.

### Step 7 — State the deferred segments and why

This is the Rumelt-style refusal step. A sequencing plan without deferred segments is a
wish list, not a strategy. Name at least 3 segments that are explicitly not in the plan
for this cycle, with the specific reason each was deferred.

Deferred segment format:

> **[Segment name]:** Deferred because [specific Aulet criterion it fails / strategic
> reason / whole product gap too large / timing / team capability gap]. Reconsider when
> [observable trigger that might change this — a product capability gap closes, a
> competitor exits, a partnership becomes available].

The deferred list protects the plan from drift. When a new sales opportunity arrives from
a deferred segment, the team has a written rationale to consult rather than relitigating
the sequencing decision from scratch.

### Step 8 — State the cross-role decisions this sequencing locks in

GTM sequencing is not a marketing-only decision. State explicitly what the chosen sequence
requires from:

- **Pricing strategy** (`roles/marketing-expert/skills/pricing-strategy/SKILL.md`): Does
  the beachhead segment require a different pricing model than the second segment? (E.g.,
  beachhead = usage-based; second segment = seat-based because of enterprise procurement
  processes.) Pricing architecture decisions should be made now, not discovered at the
  transition.
- **Product (PM):** Whole product gaps (Step 6) are a product roadmap input. The PM must
  approve or flag resource constraints before the sequencing plan is finalized.
- **Hiring:** The beachhead sales motion (likely sales-led, direct) requires different
  headcount and skills than the bowling-alley expansion motion. Name what hiring is implied
  by the sequence and when.
- **Positioning canvas:** The beachhead win may sharpen or narrow the who-cares-most
  segment definition. Build a trigger to update the canvas at the transition point.

## Examples

### Example A — B2B analytics tool: disciplined sequencing (good)

**Company:** Series A analytics SaaS, 12 months post-GA, $1.2M ARR from a mix of early
adopters across several verticals. Growth has slowed; sales cycles are lengthening.

**Canvas output:** who-cares-most = Series B-C SaaS product managers at companies with
50-300 employees who need behavioral cohort analysis but can't justify the cost of
enterprise analytics platforms.

**Candidate beachhead segments:**
1. Series B-C SaaS PMs (50-300 employees) — direct match with canvas.
2. Series D-E PMs (300-1,000 employees) — larger ACV, but whole product gap is larger too
   (SSO, SOC 2, role-based access control, procurement process).
3. Mid-market RevOps leaders — adjacent problem, different buyer persona, different
   integration stack.
4. Enterprise product analytics teams — very large potential ACV; but procurement cycle
   is 9-12 months, whole product gap is significant, and the team has no enterprise sales
   capability.
5. Agencies with analytics practices — accessible via content marketing, but low ACV and
   high churn; not a stepping stone to adjacent segments.

**Aulet scoring (abbreviated):**

Segment 1 (Series B-C SaaS PMs): Strong on all six criteria. Identifiable (Crunchbase
filter), accessible (PLG + targeted outbound), strong reason to buy (established via
customer interviews), whole product deliverable (no SSO required at this stage), adjacent
to segment 2 (Series D-E PMs share reference networks), aligned with team strengths (two
founders are former B2B SaaS PMs).

Segment 2 (Series D-E PMs): Strong on 1, 3, 5; Partial on 4 (SOC 2 in progress; SSO and
role-based access control not yet built); Weak on 6 (no enterprise sales motion currently).

Segment 4 (Enterprise): Weak on 4 (whole product gap: SOC 2 Type II, MSA process, formal
procurement, dedicated CSM), Weak on 6 (no enterprise AE, no SE, no legal resources for
custom MSAs). Deferred.

**Chosen beachhead:** Segment 1, Series B-C SaaS PMs at 50-300 employees.

**Bowling-alley sequence:** Series B-C SaaS PMs → Series D-E SaaS PMs → mid-market
RevOps leaders.

**Transition triggers:**
- Beachhead → Segment 2: $5M ARR from beachhead segment, plus 20% of pipeline arriving
  inbound from Series D-E companies without active outbound. Plus SOC 2 Type II complete
  and SSO launched.
- Segment 2 → Segment 3: 30 named reference accounts in the Series D-E segment willing
  to take reference calls; RevOps integration (Salesforce, HubSpot) production-ready.

**Whole product gap (second segment, Series D-E):**
- SOC 2 Type II report required. Currently in audit; complete in Q3.
- Enterprise SSO (Okta, Azure AD) required. On roadmap for Q2.
- Role-based access control (admin / viewer / editor tiers) required. Not started.
- Reference accounts: 3-5 Series D-E companies willing to take reference calls. Currently
  have 1 opportunistic customer in this band; need 4 more before active sales motion starts.

**Deferred segments:**
- **Enterprise product analytics (>1,000 employees):** Deferred. Whole product gap is
  18-24 months of work; procurement cycle incompatible with current cash runway. Reconsider
  after Series B close and dedicated enterprise AE hired.
- **Agencies with analytics practices:** Deferred. Low ACV ($500-1,500/year), high churn
  (agency client turnover drives platform churn), and no adjacent segment reachable from
  this beachhead. Reconsider only if a partnership model emerges.
- **SMB (<50 employees):** Deferred. Strong reason to buy is weaker (analytics is a nice-
  to-have at that scale, not a strategic need); whole product is over-engineered for their
  use; accessible only via high-volume low-ACV motion the team can't support yet.
- **Consumer analytics (B2C product teams):** Deferred. Different whole product (different
  data volumes, different privacy requirements), different buyer persona, different
  competitive set. Not adjacent to any planned bowling-alley segment.

**Cross-role locks:** Pricing stays usage-based through beachhead and Segment 2; at
Segment 3 (RevOps) evaluate shift to seat-based per RevOps procurement norms. PM owns
SOC 2 and SSO roadmap items as prerequisites for transition trigger. Hire a dedicated
enterprise AE only after transition trigger for Segment 2 fires.

---

### Example B — Developer tool startup: wrong sequence diagnosed (cautionary)

**Company:** Developer tooling startup, pre-revenue, well-funded seed round ($3M). The
team decided to launch to "all developers everywhere" — a PLG product, self-serve, broad
content marketing, Hacker News launch, Twitter presence.

**What happened:** 2,200 free signups in the first month. Activation rate: 18%. Paid
conversion: 2.1%. ARR at 12 months: $180,000. Runway: 4 months. The team raised a
small bridge but the growth trajectory couldn't support a Series A.

**The diagnostic teardown:** The product solves a specific problem — automated dependency
vulnerability scanning for Python packages in production environments. This is a
well-defined job. The beachhead segment it should have targeted: Series A-B
Python-first startups (30-150 engineers) where a single platform engineer is responsible
for security posture and doesn't have budget for an enterprise scanner.

Why this beachhead was right and was not chosen:
- **Identifiable:** Lists of Python-first startups at Series A-B are buildable (GitHub
  API, LinkedIn, Crunchbase). The team never built a target list — they launched to
  "the developer internet."
- **Accessible:** Platform engineers at Series A-B companies are reachable via a
  high-quality technical blog and targeted outreach. The team went broad (Hacker News,
  Product Hunt) and got a large unqualified audience instead.
- **Strong reason to buy:** For a platform engineer whose startup had its first security
  incident, this product solves a burning problem. For a developer at a large enterprise
  with a dedicated security team, this product is a nice-to-have they'll never expense.
  The team measured DAU, not segment-specific activation.
- **Whole product deliverable:** At the beachhead, the whole product was achievable in
  90 days (GitHub Actions integration, Slack alerts, a clear setup guide). Instead, the
  team built a broad feature surface trying to serve multiple personas simultaneously.
- **Adjacent to large next segment:** The Series A-B Python beachhead leads naturally to
  Series C-D companies (larger teams, more repos, higher ACV) and then to multi-language
  support for polyglot shops. Neither was planned.
- **Aligned with team strengths:** The founder was a former platform engineer at a Series
  B startup. This was the segment they understood. They chose not to exploit that advantage
  because "we want to be for all developers."

**The chasm they hit:** The 2,200 signups were almost entirely innovators and early
adopters — developers who sign up for new tools out of curiosity, not because they had the
burning problem. The early-majority pragmatists — the platform engineers with a real
security mandate — were not reached because the product's positioning, onboarding, and
content were generic rather than segment-specific.

**What the right sequencing would have looked like:**
- Beachhead: Series A-B Python-first startups, platform engineer buying persona.
- Target list of 400 companies, direct outreach to 200, aim for 20 paying customers in
  90 days at $200-400/month.
- Bowling alley: → Series C-D polyglot shops → mid-market DevSecOps teams.
- The broad "all developers" launch: deferred until after the bowling alley produces
  $1.5M ARR and the brand has earned its credibility in the security-conscious developer
  segment.

The lesson: a broad-market launch before the bowling alley is won is not an accelerant.
It is an accelerant to burning out without segment density. The 2,200 free signups were
not a traction signal — they were a noise signal from a non-targeted launch.

## Common Pitfalls

### Pitfall 1 — Broad-market launch before the bowling alley is won

**Symptom:** The team launches to "all companies with this problem," invests in broad-
reach content and paid channels, and measures total signups rather than segment-specific
activation and conversion.

**Consequence:** Sharp's mental-availability investment is expensive without the segment
density to convert. Moore's chasm hits: the innovators and early adopters respond; the
early majority doesn't follow because there are no pragmatist references to follow.

**Fix:** Map where the company sits on the adoption lifecycle before choosing GTM posture.
Broad-reach spend is right at the tornado phase, not the beachhead phase. Match the
marketing posture to the lifecycle stage.

### Pitfall 2 — Beachhead by anecdote

**Symptom:** The beachhead is defined as "companies like our first 3 customers" without
Aulet scoring or a target list. The first 3 customers were accidents of the founder's
network, not a strategic choice.

**Consequence:** The beachhead segment may not be identifiable, accessible, or adjacent
to any attractive next segment. The company wins a few more anecdotal customers and then
runs out of segment to exploit.

**Fix:** Run Aulet's six criteria. If you can't build a target list of 100+ companies,
the segment is not defined. Founding-team network deals count as evidence; they do not
count as a segment.

### Pitfall 3 — Whole product gap unaddressed for the second segment

**Symptom:** The beachhead is won; the team declares the second segment open and begins
selling into it without completing the whole product for that segment's pragmatists.

**Consequence:** Sales cycles lengthen; deals stall at security review, integration
requirement, or procurement process. The team interprets this as a sales problem or a
pricing problem; it is a whole product problem (Moore).

**Fix:** Map the whole product gap for the next segment before the transition trigger
fires (Step 6). The transition trigger should include "whole product items X, Y, Z
complete" as explicit conditions, not just an ARR threshold.

### Pitfall 4 — No deferred-segments list

**Symptom:** The GTM plan names the beachhead and a bowling-alley sequence but has no
list of segments that are deliberately excluded.

**Consequence:** Without the refusal, there is no strategy — only a wish list (Rumelt's
diagnosis via `roles/product-manager/skills/strategy-kernel/SKILL.md`). Every inbound
opportunity from a deferred segment triggers a sequencing debate. Sales pursues
opportunistic deals in the wrong segments; the beachhead never achieves the reference
density required to cross the chasm.

**Fix:** Name 3-5 deferred segments with specific reasons and reconsider triggers.
The deferred list is as important as the sequencing plan; it is the constraint that makes
the sequencing plan real.

### Pitfall 5 — Conflating sequencing with launch-brief tactics

**Symptom:** The GTM sequencing document names the beachhead and then immediately
specifies channels, assets, and campaign timelines — effectively becoming a launch brief
rather than a sequencing strategy.

**Consequence:** The strategy layer is skipped. Channels and assets are chosen before
the beachhead is verified. The launch-brief (`roles/marketing-expert/skills/launch-brief/SKILL.md`)
is a downstream document from the sequencing plan; it is not the sequencing plan.

**Fix:** The GTM sequencing output is a segment-sequencing plan with triggers and
whole-product gap maps. The launch-brief translates that plan into channel-sequence-
measurement for the specific beachhead. Keep them separate and in order.

### Pitfall 6 — First-segment success extrapolation

**Symptom:** The beachhead is won; the team assumes the same sales motion, pricing,
and messaging will transfer to the second segment because "we've proven the model."

**Consequence:** Reps are trained on the wrong buyer persona; pricing hits procurement
process objections it wasn't designed for; whole product gaps discovered mid-deal
rather than in advance.

**Fix:** Acknowledge structurally that the second segment requires a partial rebuild
(Step 6, Step 8). Write down the specific differences in buyer persona, whole product
requirements, and sales motion for segment two before the sales team starts pitching it.

### Pitfall 7 — Pricing assumptions that don't survive segment transitions

**Symptom:** The beachhead segment was won on usage-based pricing because it fit how
those buyers think about value. The second segment's enterprise procurement requires
seat-based or flat-fee annual contracts; the pricing architecture doesn't support this.

**Consequence:** Deals close but require heavy custom negotiation. The pricing model
becomes a point of friction for every segment-two deal. The cross-role pricing-strategy
coordination (Step 8) was skipped.

**Fix:** Evaluate pricing model per segment as part of the sequencing plan, not as a
reactive decision when the second-segment deals arrive. Cross-reference
`roles/marketing-expert/skills/pricing-strategy/SKILL.md` during the sequencing exercise.

### Pitfall 8 — Founder over-attachment to the initial traction segment

**Symptom:** The data shows the beachhead segment is won and the transition trigger has
fired, but the founder wants to "go deeper" in segment one because "that's where we have
relationships."

**Consequence:** Marginal beachhead investment competes with the bowling-alley investment;
the adjacent segments are never attacked decisively; competitors cross from adjacent
segments and take the market the bowling alley would have reached.

**Fix:** The transition trigger is written down before this decision is live. When the
trigger fires, the conversation is "here is the observable signal we agreed on; are we
acting on it?" rather than a strategic debate from scratch. Pre-commitment to criteria
is the protection against the founder's legitimate but sometimes misaligned pattern
recognition.

## References

- **Geoffrey Moore** — *Crossing the Chasm: Marketing and Selling Disruptive Products to
  Mainstream Customers* (1991, rev. 2014); *Inside the Tornado: Marketing Strategies from
  Silicon Valley's Cutting Edge* (1995). The technology-adoption lifecycle, the chasm,
  the whole product requirement, the bowling-alley pattern, and the tornado-phase transition.
  Anchored in `roles/product-manager/sources.md` (Moore's primary anchor home); referenced
  cross-role in `roles/marketing-expert/sources.md`.
- **Bill Aulet** — *Disciplined Entrepreneurship: 24 Steps to a Successful Startup* (2013,
  rev. 2024). The six beachhead-market criteria. Cited in `roles/marketing-expert/sources.md`
  see-also. The beachhead-to-commercial-model bridge is extended in the `commercial-model-design`
  skill.
- **April Dunford** — *Obviously Awesome: How to Nail Product Positioning So Customers Get
  It, Buy It, Love It* (2019). The "who-cares-most" segment as the first beachhead candidate;
  positioning and GTM sequencing as the same decision viewed from two angles.
  See `roles/marketing-expert/sources.md`.
- **Frank Slootman** — *Amp It Up: Leading for Hypergrowth by Raising Expectations,
  Increasing Urgency, and Elevating Intensity* (2022). Commercial-velocity discipline at
  the beachhead; land-and-expand economics; the sales-led vs. marketing-led sequencing
  question. Cited in `roles/marketing-expert/sources.md` see-also.
- **Mark Ritson** — strategic-marketing essays in *Marketing Week* and *Mini MBA in
  Marketing*. GTM sequencing as the strategy layer between positioning (diagnosis) and
  launch-brief (tactics). See `roles/marketing-expert/sources.md`.
- **Byron Sharp** — *How Brands Grow: What Marketers Don't Know* (2010). Mental
  availability scaling; the timing of broad-reach investment relative to lifecycle stage.
  See `roles/marketing-expert/sources.md`.
- **Cross-role references:**
  - `roles/product-manager/sources.md` — Moore's anchor home; Rumelt (strategy-kernel
    refusal pattern).
  - [`roles/product-manager/skills/competitive-teardown/SKILL.md`](../../../product-manager/skills/competitive-teardown/SKILL.md) —
    competitive segment analysis informing the beachhead pick (Step 3 evidence input).
  - [`roles/product-manager/skills/bet-portfolio/SKILL.md`](../../../product-manager/skills/bet-portfolio/SKILL.md) —
    the company's current job-to-be-done bet; sequencing must serve the bet, not contradict it.
  - [`roles/product-manager/skills/strategy-kernel/SKILL.md`](../../../product-manager/skills/strategy-kernel/SKILL.md) —
    Rumelt's refusal pattern; the deferred-segments list (Step 7) applies the same
    discipline: strategy without refusal is a wish list.
- **Sibling marketing skills:**
  - [`positioning-canvas`](../positioning-canvas/SKILL.md) — upstream input; the
    "who-cares-most" segment is the first beachhead candidate.
  - [`launch-brief`](../launch-brief/SKILL.md) — downstream output; once the beachhead is
    chosen, launch-brief is how you launch into it.
  - [`pricing-strategy`](../pricing-strategy/SKILL.md) — the cross-role sibling that
    determines what monetization model fits each segment as the sequence advances.
