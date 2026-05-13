---
name: adr
description: Use when an engineering team needs to record an architectural decision — the context, the options considered, the choice, and the consequences — in a lightweight, durable artifact.
intent: |
  Produces or evaluates an Architecture Decision Record. An ADR captures
  one decision: why it was made, what was considered, what trade-offs it
  accepts, and what it means for the team going forward. The artifact is
  small, version-controlled with the code, and immutable after acceptance —
  superseded by a later ADR rather than edited in place.
type: component
theme: design-and-decisions
best_for:
  - A choice that future engineers will want to understand, not just the outcome
  - A decision affecting more than one engineer's future work
  - A trade-off where the alternatives are non-obvious and worth recording
scenarios:
  - "Choosing Postgres over MySQL for a new service"
  - "Adopting (or deprecating) a shared library across services"
  - "Deciding the team will use OpenTelemetry rather than vendor SDKs"
  - "Locking in REST vs RPC for an external API"
estimated_time: 15-40 minutes (first draft); 5-10 minutes (critique)
---

# ADR — Architecture Decision Record

> v0 draft. Grounded in Michael Nygard's "Documenting Architecture Decisions" (2011), Martin Fowler's lightweight-ADR writing, and John Ousterhout's design-documentation guidance.

## Purpose

Capture a single architectural decision so a future engineer — or future you — can answer two questions without archaeology:

1. **Why did we choose this?** What problem were we solving, what alternatives did we weigh, what made this the answer?
2. **What did we accept by choosing this?** What constraints, costs, and follow-on work did this decision bake in?

An ADR is **not** documentation of the *system* (that's elsewhere). It is documentation of the *decision*. The system changes; the decision stays put as a record of what we knew when.

ADRs are committed alongside the code they affect (e.g., `docs/adr/0007-event-bus-postgres-listen-notify.md`), numbered sequentially, and immutable after acceptance. A reversal becomes ADR-0023 "Supersedes ADR-0007."

## Key Concepts

### Nygard's lightweight ADR

Michael Nygard ("Documenting Architecture Decisions", 2011) proposed a five-section template — Status, Context, Decision, Consequences, plus an optional Considered Alternatives section — that became the de facto industry default. The deliberate constraint: each section is short. An ADR that runs over two pages has either too many decisions in it or too much background.

### One decision per ADR

Fowler ("Architecture Decision Records" essay): an ADR captures *one* choice. If the artifact would require multiple "Decision" statements, split it. Multiple decisions in one ADR make superseding partial choices impossible.

### Context, not justification

Ousterhout (*A Philosophy of Software Design*, ch. on documentation): the most valuable thing a design artifact preserves is **what was non-obvious at the time**. The Context section names the forces — load, team shape, regulatory constraint, deadline, prior commitment — that shaped the choice. A future reader who doesn't see those forces will misread the decision as arbitrary.

### Consequences are honest, not flattering

Nygard's framing: consequences include the **negative**, the **neutral**, and the **positive**. An ADR that lists only benefits is marketing, not engineering. Future readers must be able to see the trade-off the team accepted.

### Status as a lifecycle, not a label

Status moves: **Proposed → Accepted → (Deprecated | Superseded by ADR-NNNN)**. Editing an accepted ADR's Decision text loses the historical record. Supersede instead.

### Numbering and discoverability

ADRs live in `docs/adr/NNNN-kebab-title.md`, numbered sequentially. An `INDEX.md` in the same folder lists them with one-line summaries — the smallest viable catalogue.

## Application

### Step 1 — Decide whether an ADR is warranted

Not every choice deserves an ADR. Run the three-test filter:

1. **Future-reader test.** Will an engineer six months from now wonder why we did this? If no, skip.
2. **Cross-engineer test.** Does this affect more than one engineer's future work? If no, skip.
3. **Reversibility test.** Would reversing this be a multi-day effort? If no, skip.

If any test fails, the decision belongs in a code comment, a commit message, or a PR description — not in an ADR.

### Step 2 — Draft the ADR using the template

```markdown
# NNNN — <Short title in the form "subject-verb-object">

- **Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNNN
- **Date:** YYYY-MM-DD
- **Deciders:** <names or roles>
- **Tags:** <2-4 tags: data-store, observability, build-system, etc.>

## Context

<3-8 sentences. The forces at play: load, team shape, deadline, regulatory
constraint, technical history. What was true at the time that the decision
was responding to. NOT a justification for the decision — that comes later.>

## Decision

<1-3 sentences. The choice, stated declaratively in present tense.
"We will use X" or "We adopt Y." If the decision requires more than three
sentences, it's probably more than one decision.>

## Considered alternatives

<For each non-trivial option considered (2-4 alternatives):

### <Alternative name>

- **Summary:** 1-2 sentences on what this option is.
- **Why not:** 1-3 sentences on why it lost. Be specific — "complex" is
  not a reason; "would require us to maintain two parallel sets of
  migration scripts during the cutover, which violates our solo-DBA
  bandwidth constraint" is.>

## Consequences

### Positive
- <Concrete benefit, ideally measurable or observable.>

### Negative
- <What we accept by choosing this. Honest. Specific.>

### Neutral / follow-on work
- <Things this opens up or forecloses; new ADRs likely to follow.>

## References

- <Linked code paths, PRs, prior ADRs, external docs that informed the decision.>
```

### Step 3 — Review against five checks

Before circulating, the author verifies:

1. **One-decision check.** A reader can summarise the decision in a single sentence.
2. **Context-not-justification check.** The Context section describes the *situation*, not the *choice*. Move advocacy to Considered Alternatives.
3. **Alternatives-have-substance check.** At least one alternative has a non-trivial "why not." A straw-man alternative ("we could write our own" → "we don't have time") is not substance.
4. **Honest-consequences check.** At least one Negative consequence is named. If you genuinely believe there are none, that's a sign the ADR is premature — the trade-off hasn't been thought through.
5. **Status-and-number check.** Status is one of the four valid values; ADR has a sequential number; filename and title agree.

### Step 4 — Circulate, then accept

Share Proposed ADRs with the affected engineers. Use comments, not silent edits, to discuss. When agreement holds, flip Status to Accepted with the date. After Accepted, the ADR is **immutable** — future changes ride in new ADRs.

### Step 5 — Index it

Add a one-line entry to `docs/adr/INDEX.md`:

```markdown
- [0007 — Use Postgres LISTEN/NOTIFY for event bus](0007-event-bus-postgres-listen-notify.md) — Accepted 2025-11-04
```

## Examples

### Example 1 — Well-shaped ADR (good)

```markdown
# 0007 — Use Postgres LISTEN/NOTIFY for the internal event bus

- **Status:** Accepted
- **Date:** 2025-11-04
- **Deciders:** Platform team (Aisha, Bruno, Mei)
- **Tags:** events, postgres, observability

## Context

We have a single-region Postgres primary and a 6-engineer platform team.
Three services need to react to write-side events from the orders service:
fulfilment, ledger, and search-indexer. Current implementation is direct
HTTP calls from orders to each consumer, which has caused two incidents
where a downed consumer cascaded into orders-write latency. We have no
Kafka, no NATS, and no operational budget for a new stateful component
this quarter.

## Decision

We will use Postgres LISTEN/NOTIFY for the internal event bus, with a
small `event_outbox` table to provide at-least-once durability before
NOTIFY fires.

## Considered alternatives

### Apache Kafka
- **Summary:** Dedicated event broker; the obvious "right" answer.
- **Why not:** No team member has operated Kafka in production; the
  closest infra engineer is 12 weeks out from being available. Introducing
  a new stateful service this quarter exceeds our on-call budget.

### NATS JetStream
- **Summary:** Lighter-weight broker than Kafka.
- **Why not:** Same operational concern as Kafka — new stateful component,
  new on-call surface. Smaller blast radius, but still a step we can't
  afford this quarter.

### Direct HTTP retries with circuit breakers
- **Summary:** Keep the current architecture, add resilience.
- **Why not:** The incident chain we're trying to break is caused by
  synchronous coupling; retries make it worse, not better. Does not
  address the actual problem.

## Consequences

### Positive
- No new infrastructure component; reuses existing Postgres.
- Outbox pattern is well-understood; ample reference material.
- Migration to Kafka or NATS later is straightforward — outbox consumers
  swap.

### Negative
- LISTEN/NOTIFY payloads are capped at 8KB; we'll need to fetch full
  event bodies from `event_outbox` by ID. Adds one read per event.
- Single-region by construction; future multi-region work will require
  this ADR to be superseded.
- Postgres becomes the bottleneck for event throughput. We estimate
  current load at <500 events/sec, well within capacity, but this is
  a ceiling we'll hit if the platform 10×s.

### Neutral / follow-on work
- ADR-0008 will specify the `event_outbox` schema.
- ADR-0009 will define consumer-side at-least-once + idempotency contract.

## References

- [Outbox pattern (microservices.io)](https://microservices.io/patterns/data/transactional-outbox.html)
- Incident reports INC-2025-09-12 and INC-2025-10-03.
```

This ADR will read clearly in 18 months whether or not the decision still holds, because Context preserves what was true at the time.

### Example 2 — Failure mode (bad)

```markdown
# 0007 — Adopt Postgres for events

## Context
We need better events.

## Decision
We will use Postgres.

## Consequences
This will be more reliable.
```

Failures: Context is vacuous; Decision has no specificity (LISTEN/NOTIFY? logical replication? polling?); no alternatives considered; consequences are unfalsifiable and one-sided. A reader has learned nothing they couldn't have guessed from the title.

## Common Pitfalls

### Pitfall 1 — Justifying in the Context section

**Symptom:** Context reads as a case for the decision rather than a description of the situation. Phrases like "and obviously we need to scale" appear before the Decision section.

**Consequence:** A future reader can't distinguish what was *true* from what the author *believed*. When circumstances change, the ADR becomes hard to re-evaluate.

**Fix:** Context describes the world. Move all "and therefore" reasoning to Considered Alternatives.

### Pitfall 2 — Straw-man alternatives

**Symptom:** All alternatives are dismissed in one line, often as "too complex" or "doesn't fit our style."

**Consequence:** Future readers will suspect (rightly) that alternatives weren't seriously considered. The ADR loses credibility — and so does the next ADR from the same author.

**Fix:** For each alternative, write at least one specific reason it lost. If you genuinely can't, say so explicitly ("we did not investigate X deeply because…") rather than papering over.

### Pitfall 3 — Multiple decisions in one ADR

**Symptom:** The Decision section reads "We will use Postgres for events *and* adopt a new monorepo layout *and* introduce a service-mesh sidecar."

**Consequence:** When one of the three needs reversing, the entire ADR is stuck — you can't supersede half of it.

**Fix:** One ADR per decision. Link related ADRs in References.

### Pitfall 4 — Editing accepted ADRs

**Symptom:** Six months in, someone amends ADR-0007 to soften a Negative consequence because it turned out wrong.

**Consequence:** The historical record is lost. The team loses the ability to learn from what we knew vs what we found out.

**Fix:** Accepted ADRs are immutable. Write ADR-0023 "Supersedes ADR-0007 — observed throughput ceiling, switching to NATS" instead.

### Pitfall 5 — ADR theatre

**Symptom:** Every small decision gets an ADR; the folder has 200 entries; nobody reads them.

**Consequence:** The signal-to-noise ratio collapses. Engineers stop reading ADRs, which defeats their purpose.

**Fix:** Apply the three-test filter (future-reader, cross-engineer, reversibility) before writing. Most decisions don't warrant an ADR.

### Pitfall 6 — Status drift

**Symptom:** ADRs sit in "Proposed" indefinitely. Half the folder is unresolved.

**Consequence:** Future readers can't tell what is in effect. The catalogue becomes unreliable.

**Fix:** A standing rule — Proposed ADRs are decided within two weeks, or explicitly withdrawn. Stale Proposed is worse than no ADR.

## References

- **Michael Nygard** — "Documenting Architecture Decisions" (2011). The canonical ADR essay; the five-section template is his.
- **Martin Fowler** — "Architecture Decision Records" essay on martinfowler.com.
- **John Ousterhout** — *A Philosophy of Software Design*, ch. 13 (Comments Should Describe Things That Are Not Obvious From the Code). Same principle scales to design artifacts.
- **adr.github.io** — community-maintained catalogue of ADR templates and tooling (MADR, log4brains, adr-tools).
- **Related Hornero skills:**
  - [`rfc`](../rfc/SKILL.md) — for decisions large enough to need full proposal-and-debate, write an RFC first; the resulting decision becomes an ADR.
  - [`refactor-plan`](../refactor-plan/SKILL.md) — when an ADR commits to a refactor, the plan lives there.
  - `skills/extract-lesson/SKILL.md` — when an ADR's consequences prove wrong in practice, the lesson feeds back here.
