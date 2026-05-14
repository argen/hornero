---
name: rfc
description: Use when an engineering team needs to propose a non-trivial technical change — new system, significant refactor, cross-team contract — and wants written debate before commitment, producing a traceable record of what was proposed, what was considered, and what was decided.
intent: |
  Produces or evaluates an RFC (Request for Comments) — a technical design
  document that frames a problem, presents a proposed approach with
  alternatives considered, surfaces risks, and invites scrutiny before
  implementation. The artifact is the substrate for an asynchronous
  technical debate that converges on a decision.
type: component
theme: design-and-decisions
best_for:
  - Cross-team changes (≥3 engineers' future work affected)
  - New systems, services, or sizeable subsystems
  - Significant refactors where direction is contested
  - Public-API or wire-format design where reversibility is low
scenarios:
  - "Designing a new permissions model that several teams will consume"
  - "Replacing an in-process job queue with a managed broker"
  - "Proposing a uniform telemetry conventions across all services"
  - "Migrating from REST to gRPC for internal service-to-service calls"
estimated_time: 60-180 minutes (first draft); 15-30 minutes (review)
---

# RFC — Request for Comments / Technical Design Doc

> v0 draft. Grounded in Will Larson's engineering-strategy writing (*An Elegant Puzzle*, *Staff Engineer*), Tanya Reilly's design-doc craft (*The Staff Engineer's Path*), John Ousterhout's design-as-writing thesis (*A Philosophy of Software Design*), and the IETF RFC tradition adapted for company-internal use.

## Purpose

An RFC turns a technical proposal into something the team can argue about *before* code lands. Two outcomes are valuable:

1. **The good RFC ships.** Reviewers refine it; the author iterates; the team converges on an approach with eyes open about trade-offs.
2. **The bad RFC dies cheap.** A clear written proposal makes its weaknesses legible faster than 4 weeks of half-merged code.

An RFC is **not** a spec to be approved verbatim. It is a scaffold for a structured technical conversation. The conversation is the value; the resulting decision is downstream.

After acceptance, the decisions made in an RFC are often captured as one or more [ADRs](../adr/SKILL.md) for long-term traceability. The RFC is the working document; the ADR is the lapidary record.

## Key Concepts

### Larson's engineering-strategy template

Will Larson (*An Elegant Puzzle*, *Staff Engineer*) defines a recurrent structure that travels well across teams: **Context → Problem → Proposed approach → Alternatives → Risks → Decision needed**. The key innovation is foregrounding **what decision is being asked** at the top, so reviewers know how to engage.

### Reilly's design-doc craft

Tanya Reilly (*The Staff Engineer's Path*) emphasises:
- **Tell a story.** A design doc that reads as a sequence of facts loses the reader. The narrative arc — "here's the problem, here's why it's hard, here's the move I'm proposing, here's what could go wrong" — keeps reviewers oriented.
- **Right level of detail.** Enough to enable scrutiny; not so much that the doc becomes a spec. Code-level pseudocode belongs in the RFC only when the API shape itself is the decision.
- **Audience-explicit.** The first paragraph names who the doc is for: this team, adjacent teams, a specific reviewer for a specific concern.

### Ousterhout's design-as-writing

John Ousterhout (*A Philosophy of Software Design*, ch. on "design it twice"): the act of writing the design exposes problems that thinking alone hides. The first draft of an RFC will reveal at least one issue the author hadn't seen. If it doesn't, the RFC is too shallow.

### Reversibility framing

Borrowing from Bezos via Doshi: distinguish **Type-1 decisions** (one-way doors — public APIs, schema changes, wire formats, vendor lock-ins) from **Type-2 decisions** (two-way doors — internal module structure, naming, internal queue choice). RFCs are warranted for Type-1; Type-2 usually doesn't need one. Stating which type the decision is, in the RFC opening, calibrates reviewer engagement.

### Async-first, sync-resolved

The RFC lives in version control or a doc tool that supports inline comments. Most debate happens async. A sync meeting is held only when async has surfaced a disagreement that text can't resolve. The RFC author runs the meeting; the meeting's job is to converge, not to re-litigate.

### One RFC, one direction

Larson again: an RFC proposes *one* approach as primary, with alternatives in a clearly subordinate role. An RFC that presents three "options" with no recommendation is the author asking the team to do their job. State a position; argue for it; show what you considered.

## Application

### Step 1 — Decide whether an RFC is warranted

Apply the three-test filter:

1. **Cross-team test.** Does this decision affect ≥3 engineers' future work, or any team other than yours?
2. **Reversibility test.** Is this a one-way door (Type-1)?
3. **Disagreement test.** Is there meaningful technical disagreement that text could resolve faster than a meeting?

If two or more tests pass, write an RFC. If only the cross-team test passes and the decision is reversible, an ADR + PR description may be enough. If only the reversibility test passes within one team, an ADR alone suffices.

### Step 2 — Draft using the template

```markdown
# RFC NNNN — <Concise title>

- **Status:** Draft | In review | Accepted | Rejected | Superseded by RFC-NNNN
- **Author(s):** <name(s)>
- **Reviewers:** <named individuals or teams whose sign-off is requested>
- **Audience:** <who this doc is written for>
- **Decision type:** Type-1 (one-way door) | Type-2 (two-way door)
- **Decision needed by:** <YYYY-MM-DD>
- **Last updated:** <YYYY-MM-DD>

## TL;DR

<3-5 sentences. The problem, the proposed approach, the asked-for decision.
A reviewer should be able to read this and decide whether the RFC needs
their attention.>

## Context

<What's the system today; what's true that the proposal is responding to.
History matters: prior attempts, prior decisions (link ADRs), prior
incidents. Avoid restating things the audience already knows; link instead.>

## Problem

<The specific problem this RFC solves. Stated independently of any solution.
Concrete: who is affected, in what scenarios, with what cost.>

## Goals and non-goals

### Goals
- <Specific, testable outcomes this RFC commits to.>

### Non-goals
- <Adjacent concerns this RFC explicitly does NOT address. Critical for
  scope discipline.>

## Proposal

<The primary approach. Enough detail to enable scrutiny:
- Architecture sketch (diagram if it helps; ASCII or linked image).
- Key interfaces / API shape / wire format (only where the shape is
  load-bearing).
- Data model changes.
- Operational model (deploy, on-call, rollback).
- Migration path from current state.

Avoid pseudocode unless the API surface itself is the decision.>

## Alternatives considered

<For each non-trivial alternative (2-4):

### <Alternative name>

- **Summary:** what it is.
- **Pros / cons specific to our situation.**
- **Why not chosen:** the specific failure for our context.>

## Risks and mitigations

<Identify the failure modes:
- Technical risks (scale, correctness, security).
- Operational risks (on-call burden, blast radius).
- Organisational risks (team capacity, knowledge concentration).

For each, name the mitigation. A risk without a mitigation is a reason to
slow down, not a footnote.>

## Migration / rollout plan

<Phased plan, with explicit rollback criteria at each phase. Required
for any change touching production systems.>

## Open questions

<Specific items still under discussion. Each open question is owned by a
named person with a deadline.>

## Decision asks

<What you need from reviewers, in priority order:
1. <Specific decision A — who needs to sign off>
2. <Specific concern B — whose feedback is requested>>

## References

- <Related RFCs, ADRs, incidents, external docs, prior art.>

## Appendix (optional)

<Deep-dive content that would clutter the body: benchmarks, formal
analyses, detailed schemas. Keep the body readable; push depth here.>
```

### Step 3 — Self-review against six checks

Before circulating:

1. **TL;DR test.** A reviewer who reads only the TL;DR can decide whether to engage. If you can't write a 3-sentence TL;DR, the proposal isn't clear in your own head yet.
2. **Problem-solution separation.** The Problem section reads as a problem, not as the proposal in disguise.
3. **Non-goals named.** At least one non-goal is listed. If you can't think of one, scope is fuzzy.
4. **Alternatives have substance.** Reilly: a straw-man alternative is worse than no alternative — it signals you didn't take the question seriously.
5. **Risks honest.** At least one risk has a real probability of materialising; mitigations are specific, not "we'll handle it."
6. **Decision asks explicit.** Reviewers know what is being asked of them.

### Step 4 — Circulate

Share with named reviewers; give them a deadline matched to the decision date. Use inline comments; resolve threads as they conclude. The author owns the document — incorporate, decline (with reasoning), or escalate. Do not silently drop comments.

### Step 5 — Drive to a decision

Larson: the worst outcome is an RFC that decays without a decision. If async stalls, call a 30-minute decision meeting. If after the meeting the decision is still unclear, the RFC is too ambitious — split it or shrink scope.

### Step 6 — Persist the decision

Once Accepted, write the resulting ADR(s) for long-term traceability. The RFC stays as the working record of the debate; the ADR captures the lapidary outcome.

## Examples

### Example 1 — Sharp opening (good)

```markdown
## TL;DR

Our four services duplicate retry/backoff/circuit-breaker logic, with
three different defaults. We propose a thin shared client wrapper
(`platform-http`) with one set of defaults and per-call overrides.
We need sign-off from each service owner on the migration order and
from SRE on the timeout defaults.

## Decision type

Type-2 (two-way door — each service can revert independently to bespoke
clients).
```

This TL;DR tells a reviewer in 6 lines what the doc is about, what is being asked, and how reversible the decision is. They can decide whether to engage in under a minute.

### Example 2 — Non-goals discipline (good)

```markdown
## Non-goals

- We are NOT moving to gRPC in this RFC. That's RFC-0024, in flight
  separately. This RFC is HTTP-only.
- We are NOT changing service discovery. The wrapper takes a hostname
  the way the existing clients do.
- We are NOT proposing a uniform retry policy across services. The
  defaults are starting points; service owners can override per call.
```

Each non-goal pre-empts a likely scope-creep direction. Reviewers won't waste comments on those threads.

### Example 3 — Failure mode (bad)

```markdown
## Proposal

We'll build a new platform layer for HTTP clients. It will have retries,
backoff, circuit breakers, observability, and a plugin system. It will
be Type-1 because we want everyone to adopt it. Migration: TBD.
```

Failures: "plugin system" is unjustified scope-creep; "Type-1 because we want adoption" confuses social ambition with technical irreversibility; "Migration: TBD" is the author asking reviewers to fill in the load-bearing section. A reviewer cannot engage productively with this — there's nothing to react to.

## Common Pitfalls

### Pitfall 1 — RFC as spec

**Symptom:** The RFC reads as a complete implementation specification — full schemas, every endpoint, pseudocode for each function.

**Consequence:** Reviewers either skim (losing the chance to catch design issues) or get lost in implementation detail and miss the design decisions. The author also wastes effort that the code will obsolete.

**Fix:** Reilly's "right level of detail" rule — only specify where the *shape* of the thing is the decision. Internal naming, function signatures, and helper structure stay out of the RFC.

### Pitfall 2 — Three options, no recommendation

**Symptom:** The proposal section lists three approaches as peers, with phrases like "the team can choose."

**Consequence:** The author has outsourced the design work. Reviewers cannot engage with three roughly-equal options async; the discussion either devolves into preferences or stalls.

**Fix:** State one approach as primary; the others go into Alternatives. If you genuinely can't pick a primary, the RFC isn't ready — keep designing.

### Pitfall 3 — Missing audience and decision asks

**Symptom:** The RFC doesn't say who needs to read it or what decision is being requested.

**Consequence:** The right reviewers don't engage; the wrong reviewers comment on the wrong things; the doc accumulates noise.

**Fix:** Name reviewers and decision asks explicitly. "I need sign-off from SRE on the timeout defaults" is a specific ask; "feedback welcome" is not.

### Pitfall 4 — Open questions without owners

**Symptom:** The Open Questions section lists 8 items with no owner or deadline. The RFC stalls.

**Consequence:** Async debate keeps re-litigating the same questions because nobody is empowered to close them.

**Fix:** Every open question has a named owner and a date. If you can't assign an owner, that's the actual problem.

### Pitfall 5 — Risk laundering

**Symptom:** Every risk is rated "low" or paired with a one-line mitigation like "we'll monitor and adjust."

**Consequence:** When a risk materialises in production, the post-mortem will reveal the RFC predicted it but didn't actually plan for it.

**Fix:** A real mitigation is specific, observable, and someone's responsibility. If you can't write a real one, the risk is unmitigated — say so and decide whether to proceed anyway.

### Pitfall 6 — Decision drift

**Symptom:** The RFC is "Accepted" but no ADR is written and no migration starts. Six months later, half the team has forgotten what was decided.

**Consequence:** The decision quietly reverts to status-quo by default.

**Fix:** Acceptance is followed by (a) ADR(s) written and (b) the first migration PR opened within a week. If neither happens, treat the RFC as withdrawn.

### Pitfall 7 — Cross-team ambush

**Symptom:** The RFC is shared with only the author's team but commits other teams to work.

**Consequence:** Adjacent teams discover their work being scheduled in your RFC, which destroys trust.

**Fix:** If another team's work is on the path, that team's named lead is a required reviewer before Acceptance. No exceptions.

## References

- **Will Larson** — *An Elegant Puzzle* (2019); *Staff Engineer* (2021); essays on [lethain.com](https://lethain.com/) covering engineering strategy and decision-making practice. See `roles/software-engineer/sources.md`.
- **Tanya Reilly** — *The Staff Engineer's Path* (2022); design-document craft, especially audience and narrative.
- **John Ousterhout** — *A Philosophy of Software Design* (2nd ed. 2021), ch. 16 ("Design It Twice"); design-as-writing argument.
- **Shreyas Doshi** — Type-1 vs Type-2 decision framing (Bezos lineage); applied to engineering RFCs. See `roles/product-manager/sources.md` (Doshi is anchored on the PM side; the framing crosses cleanly into engineering decision-making).
- **Industry references** — Google's internal "design doc" tradition (publicly described in *Software Engineering at Google*, Winters, Manshreck, Wright, 2020); IETF's [RFC 7322](https://www.rfc-editor.org/rfc/rfc7322) for naming/section discipline (adopted loosely, not as a hard rule).
- **Related Hornero skills:**
  - [`adr`](../adr/SKILL.md) — for the lapidary record of a decision the RFC produces.
  - [`refactor-plan`](../refactor-plan/SKILL.md) — for the in-flight plan when an RFC commits to refactoring existing code.
  - [`prd`](../../../product-manager/skills/prd/SKILL.md) — pair with a PRD for user-facing changes; RFC handles the technical half.
  - [`multi-role-review`](../../../../skills/multi-role-review/SKILL.md) — for RFCs touching multiple domains (UX, security, data); orchestrates the cross-role review.
