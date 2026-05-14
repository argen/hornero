---
name: interview-synthesis
description: Use after discovery interviews to produce per-interview snapshots, theme rollups, OST updates, and a quote bank — the post-call discipline that makes the continuous-discovery cadence compound.
intent: |
  Takes raw notes or transcripts from one or more customer interviews and
  produces four artifacts: a per-interview snapshot (Torres methodology),
  a theme rollup when multiple interviews are synthesised, OST updates
  (new branches, strengthened evidence, killed branches), and a quote bank
  of verbatim customer language. Evidence is classified by quality (Fitzpatrick)
  and themes are rated by confidence (Gilad). Closes the post-interview
  discipline gap that is the most common failure mode of continuous-discovery
  practice.
type: interactive
theme: discovery
best_for:
  - Within 24h of any discovery interview — capturing evidence before memory decays
  - After 3-5 interviews — aggregating snapshots into a theme rollup
  - Before a PRD is drafted — confirming the OST has been updated with fresh evidence
  - When a team asks "what did we learn from all those customer calls?"
scenarios:
  - "PM completing a batch of 5 onboarding-friction interviews and needs a theme rollup before sprint planning"
  - "Researcher handing off interview notes to PM — snapshot format creates a consistent handoff artifact"
  - "PM reviewing whether an existing OST branch has enough evidence to move to solution design"
  - "Marketing asking for customer language for a campaign — quote bank feeds VOC mining"
estimated_time: 30-45 minutes per snapshot; 60-90 minutes for a theme rollup across 3-5 interviews
---

# Interview synthesis

> v0 draft. Torres methodology (snapshot format, OST placement) combined with
> Fitzpatrick's evidence-quality filter and Gilad's Confidence Meter for theme
> weighting. Editorial review recommended.

## Purpose

Produce the post-interview artifacts that make the continuous-discovery cadence
compound: per-interview snapshots, a theme rollup, OST updates, and a quote bank.

Without synthesis, interviews are anecdote. With synthesis, interviews are
evidence — the accumulated kind that shifts product decisions.

This skill is the downstream counterpart to `discovery-interview-prep`. The prep
skill produces the interview guide; this skill produces what comes after the call.
Both are required for Torres' continuous-discovery cadence to work.

Distinct from the marketing role's `voc-mining` skill. VOC mining extracts customer
language from passive corpora — reviews, support tickets, Reddit. Interview synthesis
is the operational practice of synthesising live PM-conducted discovery interviews.
They share evidence: the quote bank produced here feeds VOC mining downstream. Run
this skill first; the quote bank is the handoff artifact to marketing.

## Key Concepts

### The Torres interview snapshot

Teresa Torres (*Continuous Discovery Habits*): every interview produces a single
snapshot artifact — not a transcript summary, but a structured artifact with five
fields: subject (anonymized), context, 3-5 verbatim quotes, story arc, and OST
placement. The snapshot is the auditable evidence unit. "We talked to 50
customers" is a claim; 50 snapshots are evidence. Without the artifact, the claim
is unverifiable and the cadence cannot compound.

### Fitzpatrick's anti-flattery filter (The Mom Test)

Rob Fitzpatrick (*The Mom Test*, 2014): customers are unreliable narrators of their
future behavior. They are reliable narrators of their past behavior, especially when
they can name specifics — dates, dollar amounts, tool names. The synthesis must
classify each quote before treating it as evidence.

Classification required for every verbatim quote:

- **Past-behavior-specific** — "Last Tuesday I exported to Excel and spent four
  hours cleaning it." Highest evidentiary value.
- **Past-behavior-vague** — "We do that kind of thing pretty often." Usable;
  needs corroboration.
- **Hypothetical** — "I would probably use that if it were faster." Downweight;
  signals interest only.
- **Complimentary** — "This looks great, honestly." Evidence of nothing.
- **Suggestion** — "You should add a calendar view." VOC mining material;
  not evidence of a problem.

Only past-behavior quotes — specific or vague — count as evidence in the theme
rollup. Hypotheticals and compliments do not advance confidence ratings.

### The theme rollup discipline

Multiple snapshots aggregate into themes. Themes are weighted by three factors:
recurrence (how many interviews named this?), severity (how consequential?), and
source diversity (across different segments, roles, company sizes, or within one
segment?). A theme from 4 of 5 interviews at the same company is weaker than a
theme from 3 of 5 interviews across distinct segments.

### Gilad's Confidence Meter applied to themes

Itamar Gilad (*Evidence-Guided*, 2024): every theme carries a confidence rating.

- **Data confidence** — 6+ interviews, past-behavior-specific quotes,
  cross-segment. Safe to treat as evidence in a PRD.
- **Insight confidence** — 2-5 interviews, mix of specific and vague past-behavior.
  Worth acting on; not conclusive. Name it as insight, not fact.
- **Belief confidence** — fewer than 2 interviews, primarily hypothetical quotes,
  or strong PM intuition without corroboration. Worth testing; not worth laundering
  as evidence.

Synthesis is the moment evidence either accumulates or evaporates. A PM who calls
a belief "data" because they want it to be true is generating false confidence, not
performing synthesis.

### Cagan's "evidence over opinion"

Marty Cagan (*Inspired*, 2017): value risk — is the problem real, at scale, for a
named customer? — is what synthesis is testing. Without synthesis, the team's prior
beliefs fill the gap. Evidence confirms or contradicts the prior; the PM's job is to
surface which.

### OST placement as synthesis destination

Every theme must connect to the Opportunity Solution Tree. Three outcomes:
a theme creates a new opportunity branch, adds evidence to an existing branch, or
invalidates a branch. A theme without an OST destination indicates the OST is
missing a branch — update the OST, not the theme. The cadence only compounds when
synthesis loops back.

## Application

### Step 1 — Write the per-interview snapshot (within 24h)

```markdown
# Interview snapshot — <topic> — <date>

**Subject.** <Anonymized: role, company size, segment. No name or company.>
**Context.** <What are they hired to do? What triggered the interview?
  What are they currently using?>

**Verbatim quotes (3-5).** Classified.
1. "<Exact words.>" [past-behavior-specific]
2. "<Exact words.>" [past-behavior-vague]
3. "<Exact words.>" [hypothetical — downweight]

**Story arc.** <What is the customer trying to do? What changes? What do they
  do about it? What is the current end state?>
**Surprises.** <What contradicted the hypothesis from the interview guide?>
**Open questions.** <What did this interview not answer?>
**OST placement.** Touches: <branch>. New opportunity: <if any>.
  Invalidates: <if any>.
```

### Step 2 — Classify every quote (Fitzpatrick filter)

Tag every verbatim quote before the theme rollup. Only past-behavior quotes
(specific or vague) advance a theme's confidence rating. Do not proceed to Step 3
until all quotes are classified.

### Step 3 — Tag OST branches

Every snapshot must touch at least one OST branch. If there is no OST placement,
either the OST is incomplete (add the branch) or the interview was not a discovery
interview.

### Step 4 — Theme rollup (after 3-5 snapshots)

Aggregate across snapshots. For each theme: name it, score recurrence × severity ×
source diversity, assign a Gilad confidence rating, note representative past-behavior
quotes, and state OST placement. Document divergences (conflicting signals),
unverified claims (hypothetical-only themes), and what changed since last synthesis.

### Step 5 — Update the OST

For each theme with insight- or data-confidence: add new branches, update evidence
counts, or kill branches where interviews actively contradicted the opportunity.
A theme rollup that produces no OST change is incomplete.

### Step 6 — Update the quote bank

Extract the most-quotable past-behavior quotes — vivid, specific, customer-native
phrasing — indexed by theme. Feeds the PRD's Evidence section and marketing's VOC
mining. Verbatim only; paraphrasing destroys the downstream value.

### Step 7 — Surface the deltas

Write one paragraph: what changed since the last synthesis? What moved from belief
to insight? What was invalidated? This is the synthesis's deliverable to the team.

## Examples

### Worked example — B2B onboarding friction (5 interviews)

A PM runs 5 interviews with customers who churned or exceeded the 30-day activation
target. OST branch: "New users don't reach first value quickly enough." Prior
hypothesis: onboarding is blocked on team setup.

**Snapshot — Interview 2 (condensed)**

Subject: Head of Legal Ops, Series B SaaS, 120 employees. Six weeks post-signup,
activation incomplete. Three key quotes: (1) "I spent three hours clicking around
looking for a way to import our playbook before I gave up and emailed support."
[past-behavior-specific]; (2) "I'm not a video person — I need a checklist I can
skim." [past-behavior-vague]; (3) "Support was great, super responsive."
[complimentary — downweight]. Story arc: arrives expecting to migrate existing
playbook; no import path visible; reverts to Word while waiting for support; still
bifurcating six weeks later. Surprise: team-setup hypothesis never mentioned.
OST: new branch "No path to migrate existing playbook at signup"; branch weakened:
"Onboarding blocked on team setup" — zero evidence.

**Theme rollup (5 interviews, condensed)**

| Theme | Recurrence | Severity | Diversity | Confidence |
|---|---|---|---|---|
| Playbook migration is the activation blocker | 4/5 | High | Cross-segment | Data |
| Text-based guidance preferred over video | 3/5 | Medium | Cross-segment | Insight |
| Support absorbs the migration gap | 2/5 | High operationally | Same pattern | Insight |

Theme 1 representative quotes (past-behavior-specific):
- "I spent three hours looking for the import. I never found it." — Legal Ops, Series B
- "I rebuilt our entire playbook from scratch. It took a week. I almost cancelled." — Counsel, Series C

**OST update.**
- New branch added: "No path to migrate existing playbook at signup" — data-confidence —
  move to solution design.
- "Onboarding blocked on team setup" — demoted from insight to belief;
  zero corroboration across 5 interviews.

**What changed.** The team-setup hypothesis was wrong. Playbook migration was not on
the OST at all and is now the highest-weighted opportunity. The parent branch
("slow activation") is confirmed; the sub-branch diagnosis shifted entirely.

## Common Pitfalls

### Pitfall 1 — Synthesis as summarisation

**Symptom.** The snapshot is a bullet-point summary of what was said. No verbatim
quotes. No Fitzpatrick classification. No OST placement.

**Consequence.** No auditable evidence. VOC mining has no material. OST doesn't
update because there is nothing to connect.

**Fix.** Verbatim quotes, classified, with OST placement — all required fields. A
summary without them is not a snapshot.

### Pitfall 2 — No verbatim quotes preserved

**Symptom.** Quotes are paraphrased ("the customer said onboarding was confusing")
rather than verbatim.

**Consequence.** Marketing's VOC mining depends on the customer's actual language.
Paraphrase destroys it. Copy teams write about customer problems in company language,
not customer language.

**Fix.** Verbatim-only in the quote fields. Paraphrase belongs in the story arc,
labeled as the PM's interpretation.

### Pitfall 3 — Confirmation bias on theme selection

**Symptom.** The PM's prior hypothesis appears as Theme 1 despite appearing in 2 of
5 interviews. Contradicting themes are buried.

**Consequence.** Synthesis launders the PM's opinion as customer evidence. Gilad's
anti-HiPPO discipline applies in reverse: the PM should not launder their own priors
as customer evidence any more than they should let executive opinion override it.

**Fix.** The "what changed" section is mandatory. If the prior hypothesis is not the
top-weighted theme, say so explicitly. Finding out you were wrong is the synthesis
working correctly.

### Pitfall 4 — Themes never connected back to OST

**Symptom.** A thorough theme rollup is produced. The OST is not updated.

**Consequence.** Torres' core failure mode: interviews happen, synthesis happens,
the OST stays static. No compounding. Prioritisation runs on the prior OST, not
the current evidence.

**Fix.** OST update is Step 5, not optional. Every theme rollup must produce at
least one OST change. If synthesis produces no change, either the OST is wrong or
the interviews were off-topic.

### Pitfall 5 — "We talked to 50 people" without traceable snapshots

**Symptom.** Large evidence claim; no individual snapshots. The evidence is the PM's
general impression from many conversations.

**Consequence.** Torres' core anti-pattern. The claim is anecdote. A team that
cannot produce snapshots has not done synthesis.

**Fix.** Every interview → one snapshot. Reconstructed snapshots (from notes after
the fact) should be flagged with degraded confidence explicitly.

### Pitfall 6 — Hypothetical quotes treated as evidence

**Symptom.** "Customers told us they'd pay for this" cites quotes classified as
hypothetical or complimentary.

**Consequence.** Fitzpatrick's core failure: social approval treated as purchase
intent. False confidence in an unvalidated opportunity.

**Fix.** Fitzpatrick classification (Step 2) before theme rollup. Only past-behavior
quotes advance confidence ratings. Hypotheticals go to the unverified-claims section.

## References

- **Teresa Torres** — *Continuous Discovery Habits* (2021). Per-interview snapshot
  format; the OST as the persistent discovery artifact; the weekly cadence that
  requires synthesis to compound. Core methodology.
- **Rob Fitzpatrick** — *The Mom Test* (2014). Evidence classification: past
  behavior vs. hypotheticals vs. compliments. Applied in Step 2; also anchors
  Pitfall 6.
- **Marty Cagan** — *Inspired* (2008, rev. 2017). Evidence-over-opinion as PM
  discipline; value risk as the thing synthesis is testing.
- **Itamar Gilad** — *Evidence-Guided* (2024). Confidence Meter applied to themes:
  data / insight / belief. Anti-HiPPO discipline applied to the PM's own priors.
- **Related Hornero skills:**
  - [`discovery-interview-prep`](../discovery-interview-prep/SKILL.md) — the
    upstream skill; produces the interview guide and the hypotheses this skill's
    synthesis must test.
  - [`jobs-to-be-done`](../jobs-to-be-done/SKILL.md) — synthesis often surfaces
    job-shaped themes; the JTBD skill produces the statement that names and
    frames them.
  - [`prd`](../prd/SKILL.md) — the PRD's Evidence section draws from the quote
    bank and theme rollup produced here.
  - [`roles/marketing-expert/skills/voc-mining`](../../../marketing-expert/skills/voc-mining/SKILL.md) —
    the synthesised quote bank feeds VOC mining; distinct skill with distinct
    procedure.
