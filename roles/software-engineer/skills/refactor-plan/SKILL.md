---
name: refactor-plan
description: Use when an engineer needs to plan a non-trivial refactor — a structural code change that preserves behaviour — with an explicit safety net, sequence, and rollback path.
intent: |
  Produces or evaluates a refactor plan. A refactor changes the structure
  of existing code without changing its observable behaviour. This skill
  enforces the separation between structural (tidying) and behavioural
  changes, requires a working safety net (tests or characterisation), and
  sequences the work as a series of small, reversible steps rather than
  one large rewrite.
type: component
theme: code-change
best_for:
  - Untangling code that has accreted complexity without test coverage
  - Replacing an internal abstraction without changing callers
  - Splitting a god-class or god-module into focused units
  - Renaming or relocating concepts across a codebase
  - Preparing existing code for a new feature that current structure can't host
scenarios:
  - "Extracting a payment provider abstraction from a tangled checkout flow"
  - "Splitting a 4000-line OrderService into Order, Pricing, and Fulfilment"
  - "Renaming `customer` to `account` across services after a domain shift"
  - "Replacing an in-process job runner with a queue without changing job semantics"
estimated_time: 30-90 minutes (plan); execution measured in PRs, not hours
---

# Refactor plan

> v0 draft. Grounded in Martin Fowler's *Refactoring* (2nd ed., 2018), Kent Beck's *Tidy First?* (2023), Sandi Metz on duplication-vs-abstraction, and Michael Feathers' *Working Effectively with Legacy Code* (2004) for the untested-code case.

## Purpose

Plan a refactor so that:

1. **Behaviour is provably preserved.** A reader of the plan can see what evidence supports the claim that nothing changes from the outside.
2. **Each step is small and reversible.** Any individual PR could be reverted without taking the codebase to a worse state than before.
3. **Structural and behavioural changes are separated.** No commit, no PR, no step mixes "tidying" with "changing what the code does."
4. **The end-state is named, not assumed.** A reader can tell what "done" looks like and what intermediate states are legitimate vs accidental.

A refactor without a plan tends to one of two failure modes: the giant-rewrite that stalls half-done, or the "while-I'm-here" creep that smuggles behaviour change into a structural diff. The plan exists to prevent both.

## Key Concepts

### Fowler's refactoring catalogue

Martin Fowler (*Refactoring*, 2nd ed., 2018) defines a refactor as **a change to the internal structure of code that does not change its external behaviour**. The book's catalogue (Extract Function, Move Method, Replace Conditional with Polymorphism, Strangler Fig, Branch by Abstraction, etc.) gives the team a shared vocabulary. The plan names the moves it intends, in Fowler's terms; this disciplines scope and makes review legible.

### Beck's tidy-first separation

Kent Beck (*Tidy First?*, 2023): structural changes are "tidyings"; behavioural changes are everything else. A commit, a PR, a deployment unit should contain *one* of these — never both. The reason is review cost: tidyings are read for "is the behaviour preserved?"; behavioural changes are read for "is the new behaviour right?" Mixing them forces the reviewer to do both at once, which is where bugs slip.

### Metz on duplication vs abstraction

Sandi Metz ("The Wrong Abstraction", 2016): **duplication is far cheaper than the wrong abstraction**. The natural impulse during a refactor is to unify "similar" things into one. Resist until you can name *what* about them is the same; if the names of the parameters you'd thread through diverge in meaning, the things weren't actually the same. Wait for the third case (Rule of Three) before extracting.

### Feathers's seam concept

Michael Feathers (*Working Effectively with Legacy Code*, 2004): a **seam** is a place where you can change behaviour without editing it in place — a function boundary, a class boundary, an injection point. The first move when refactoring untested code is to introduce seams that allow tests to be written, then add tests, then refactor. Without tests, "refactor" is "rewrite-and-pray."

### Characterisation tests

Feathers again: when the existing code lacks tests, write **characterisation tests** — tests that pin down *what the code currently does*, including the bugs. These are not assertions of correctness; they are assertions of preservation. The refactor must keep them green. If the original behaviour included a bug, the characterisation test pins the bug; fixing the bug is a separate, behavioural change.

### Strangler fig migration

Fowler ("StranglerFigApplication" essay): for large refactors, run new and old paths side-by-side, route a growing fraction of traffic to the new path, then remove the old. The plan names which fraction migrates in which step, with rollback criteria.

### Branch by abstraction

Fowler ("BranchByAbstraction" essay): introduce an abstraction in front of the thing you want to change, switch callers to the abstraction, replace the implementation behind the abstraction, then inline the abstraction (or keep it if it's now load-bearing). The plan describes which boundary the abstraction sits at and what the cutover sequence is.

### The Rule of Three

Don Roberts via Fowler: **don't extract on the first duplication; do it on the third**. Two similar things may not be the same thing. Three of them probably are. The plan should state, for each proposed extraction, which three concrete callers justify it.

## Application

### Step 1 — Decide whether a plan is warranted

Apply the three-test filter:

1. **Size test.** Will this refactor span more than one PR?
2. **Risk test.** Could this break callers, consumers, downstream services, or production data shape if mis-stepped?
3. **Coordination test.** Will other engineers be working in the same code while this is in flight?

If any test passes, write a plan. A single-PR, single-engineer, internal-only refactor doesn't need a plan — it needs a good PR description.

### Step 2 — Confirm the safety net exists

Before any structural change, the plan verifies that *something* will tell us if behaviour shifts:

- **Unit tests covering the affected code** — preferred. List the test files.
- **Characterisation tests** — write these *first* if unit coverage is thin. The plan names which behaviours need pinning.
- **Integration / contract tests** — sufficient if no unit-level shift is possible.
- **Production observability** — error rates, latency percentiles, business metrics. Sufficient *only* in combination with one of the above; never alone.

If none of the above is in place, **the first phase of the plan is to build the safety net**. Refactoring without a safety net is rewriting.

### Step 3 — Draft the plan using the template

```markdown
# Refactor plan — <Short title>

- **Author:** <name>
- **Status:** Draft | In progress | Done | Abandoned
- **Started:** <YYYY-MM-DD>
- **Tracking issue / RFC:** <link>

## Goal

<One sentence. What structural property changes. What end-state we reach.
"After this plan, callers depend on `PaymentProvider` interface rather
than directly on `StripeClient`.">

## Out of scope

<What this plan deliberately does NOT change. Behavioural changes that
the new structure may *enable* but that ride in separate work.>

## Safety net

- **Existing tests covering this code:** <list test files / suites>
- **Coverage gaps to fill before structural change:** <list characterisation
  tests to add, with target behaviours>
- **Observable signals in production:** <metrics, alerts that would catch
  a behaviour shift>
- **Manual verification, if any:** <only if automation can't reach it; be
  explicit about what is checked>

## Sequence

### Phase 1 — <name, in Fowler terms where possible>

- **Refactoring moves:** <e.g., Extract Function on X, Introduce Parameter
  Object on Y>
- **Files touched:** <approximate list or directory>
- **Verification:** <which tests assert behaviour preservation>
- **PR shape:** structural only; no behavioural change.
- **Rollback:** revertable as a single PR.

### Phase 2 — <name>

…

### Phase N — <name>

## Behavioural follow-ups

<Behavioural changes that this refactor enables, listed separately. Each
one rides in its own PR after the refactor lands.>

## Risks and mitigations

- <Risk specific to this refactor; mitigation specific to this plan.>

## Done criteria

<How we know the refactor is complete. End-state is observable, not
"feels cleaner." E.g., "All callers import from `payment/provider`;
`legacy/payment_client.py` is deleted; CI is green.">
```

### Step 4 — Self-review against six checks

Before sharing:

1. **Behaviour-preservation check.** For each phase, can a reviewer point to the test or signal that proves behaviour didn't shift?
2. **Tidy-first check.** No phase mixes structural and behavioural changes. Behavioural follow-ups are listed separately.
3. **PR-size check.** Each phase fits in a reviewable PR (rough rule: <500 LOC diff; <30 files; ideally <5 minutes of review).
4. **Rule-of-three check.** Every proposed extraction names the three concrete callers that justify it. If you can name only two, defer the extraction.
5. **Reversibility check.** Each phase can be reverted by a single `git revert` without leaving the codebase worse than before that phase started.
6. **End-state check.** "Done" is observable, not "we'll know when we see it."

### Step 5 — Execute, phase by phase

- Open one PR per phase. The PR description names the Fowler move(s) and links the plan.
- Reviewers verify behaviour preservation, not design taste — design taste was settled when the plan was approved.
- If a phase reveals an unanticipated coupling, **stop and update the plan** rather than expanding the in-flight PR.
- Production monitoring runs through the rollout; if behavioural signals shift, halt.

### Step 6 — Mark done

When the end-state is reached, flip Status to Done. Write an ADR if the refactor's outcome is itself a load-bearing architectural decision (e.g., introducing a new abstraction layer). Update any references in the codebase to point at the new structure.

## Examples

### Example 1 — Sensible sequencing (good)

```markdown
# Refactor plan — Extract PaymentProvider interface from StripeClient

## Goal
After this plan, all callers depend on a `PaymentProvider` interface;
StripeClient is one implementation. End-state enables (but does not
include) adding Adyen as a second provider.

## Out of scope
- Adding Adyen. That's a separate behavioural change after this lands.
- Changing retry semantics. The interface preserves current Stripe behaviour.

## Safety net
- Existing tests: `tests/checkout/`, `tests/payment/test_stripe_*.py`
  cover happy path + 12 error cases.
- Gap: webhook signature verification has no test. Phase 1 adds a
  characterisation test pinning current behaviour (including the known
  off-by-one in signature timestamp tolerance).
- Production signals: `payment_failures_total` (rate alert),
  `stripe_api_latency_p99` (latency alert).

## Sequence

### Phase 1 — Build safety net
- Add characterisation tests for webhook handling (pins current
  behaviour including the bug).
- Add contract test for StripeClient method signatures.
- PR shape: tests only; no production code change.
- Rollback: trivial.

### Phase 2 — Introduce PaymentProvider abstraction (Branch by Abstraction)
- Define `PaymentProvider` interface co-located with StripeClient.
- StripeClient becomes the sole implementer; no caller changes.
- PR shape: pure addition; one file; structural.
- Rollback: delete one file.

### Phase 3 — Migrate callers (Move Method, callsite by callsite)
- Switch 14 callsites to depend on `PaymentProvider`. Each callsite
  PR is <200 LOC.
- 4 PRs; one per service.
- Rollback: per-PR revert; mixed state is safe (callers depend on
  either the interface or StripeClient directly; both work).

### Phase 4 — Tidy
- Remove now-unused direct imports of StripeClient outside its package.
- Mark StripeClient package as internal.
- PR shape: structural; small.

## Behavioural follow-ups
- Fix the webhook signature off-by-one (its own PR, with a test that
  *changes* the characterisation test from Phase 1 to assert correct
  behaviour).
- Adyen integration (separate plan).

## Risks and mitigations
- Risk: Phase 3 mixed-state could mask a regression. Mitigation:
  per-service rollout with 24h observation between PRs.

## Done criteria
- All 14 callsites depend on `PaymentProvider`.
- StripeClient is only imported within `payment/providers/stripe/`.
- All tests green; production signals stable for 7 days post-Phase-4.
```

Each phase is small, structural-only, and reversible. The behavioural fix (the off-by-one) is explicitly deferred to its own PR after the refactor lands.

### Example 2 — Failure mode (bad)

```markdown
# Refactor plan — Clean up payment code

## Goal
Make the payment code less of a mess.

## Plan
- Refactor StripeClient.
- Add support for Adyen while we're in there.
- Fix the webhook bug.
- Maybe split into a separate service.
```

Failures: goal is unobservable ("less of a mess"); mixes a refactor with a feature addition (Adyen), a bug fix (webhook), and a possible architectural change (separate service); no safety net; no sequencing; no rollback. This is a wishlist, not a plan.

## Common Pitfalls

### Pitfall 1 — Mixed structural and behavioural changes

**Symptom:** A "refactor" PR also fixes a bug, adds a small feature, or changes default values.

**Consequence:** The reviewer cannot tell what's preserved and what's changed. If a regression appears later, `git bisect` lands on a commit that did several things at once.

**Fix:** Beck's tidy-first rule. Behavioural changes get their own PR, after the refactor, with their own tests. Apply this even when the change "seems small."

### Pitfall 2 — Refactor without a safety net

**Symptom:** The plan starts with structural changes; tests are "to be added later."

**Consequence:** There is no way to know whether behaviour shifted. If a regression appears in production, the team cannot tell whether the refactor caused it.

**Fix:** Feathers's discipline. Phase 1 is *always* building the safety net when existing coverage is thin. Characterisation tests pin current behaviour (including bugs) so structural change is observably behaviour-preserving.

### Pitfall 3 — Premature abstraction

**Symptom:** The plan extracts an interface to satisfy one or two current callers, "anticipating" future ones.

**Consequence:** Metz's wrong-abstraction trap. The abstraction's shape reflects the first one or two callers, not the eventual third. When the third caller arrives, it doesn't fit, and the abstraction has to be reworked at higher cost than the original duplication.

**Fix:** Rule of Three. Wait for the third concrete caller. Until then, duplication is the right move.

### Pitfall 4 — Giant-PR refactor

**Symptom:** A single PR with 4000-line diff that touches 80 files, all "small mechanical changes."

**Consequence:** Reviewers either rubber-stamp it (the worst outcome) or block it for weeks (the second-worst). Merge conflicts pile up; rollback becomes terrifying.

**Fix:** Sequence the refactor as small, independent PRs. Each PR is reviewable in <5 minutes; each is independently revertable. Use Branch by Abstraction or Strangler Fig to enable incremental migration.

### Pitfall 5 — "While I'm here" creep

**Symptom:** The author starts a focused refactor but expands scope mid-flight: "I noticed this other thing nearby and fixed it too."

**Consequence:** The PR becomes hard to review; the plan becomes obsolete; reviewers can't tell what's part of the refactor and what isn't.

**Fix:** Out-of-scope items get a TODO and a follow-up issue. The refactor PR stays focused. If new in-scope work is discovered, update the plan explicitly, not the PR silently.

### Pitfall 6 — End-state by vibes

**Symptom:** "Done" is described as "cleaner," "more maintainable," or "easier to extend." No observable criterion.

**Consequence:** The refactor never ends; the team accretes half-finished restructurings; the codebase ends up worse than before because now there are *two* shapes of the same thing.

**Fix:** State observable done criteria. "All callers depend on PaymentProvider; legacy file is deleted; CI is green; production signals stable for 7 days post-cutover."

### Pitfall 7 — Refactor as rewrite

**Symptom:** The plan proposes building a new module from scratch, then "switching over" callers.

**Consequence:** This isn't a refactor — it's a rewrite. Behaviour preservation is much harder to prove; the new module will lack the patches that accumulated in the old one for good reasons; the switchover is risky.

**Fix:** Refactor in place where possible. Branch by Abstraction lets you swap implementations without writing parallel code paths. If a true rewrite is warranted, write an RFC and treat it as a project, not a refactor.

## References

- **Martin Fowler** — *Refactoring: Improving the Design of Existing Code* (2nd ed., 2018). The catalogue and the vocabulary. See `roles/software-engineer/sources.md`.
- **Martin Fowler** — essays "StranglerFigApplication" and "BranchByAbstraction" on martinfowler.com; the strategies for large-scale incremental migration.
- **Kent Beck** — *Tidy First? A Personal Exercise in Empirical Software Design* (2023). The structural/behavioural separation is from him.
- **Sandi Metz** — "The Wrong Abstraction" (2016 essay); the duplication-vs-abstraction trade-off.
- **Michael Feathers** — *Working Effectively with Legacy Code* (2004). Seams, characterisation tests, the discipline of refactoring untested code.
- **Don Roberts (via Fowler)** — Rule of Three for extraction.
- **Related Hornero skills:**
  - [`tdd-discipline`](../tdd-discipline/SKILL.md) — for the test-first loop when the refactor enables new behaviour.
  - [`adr`](../adr/SKILL.md) — when a refactor introduces an architectural decision worth recording.
  - [`rfc`](../rfc/SKILL.md) — when the refactor is large enough that direction itself is contested.
