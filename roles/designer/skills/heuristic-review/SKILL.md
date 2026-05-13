---
name: heuristic-review
description: Use when a designer needs to evaluate a UI surface against Jakob Nielsen's 10 usability heuristics — applied with judgement, not as a tickbox — to surface usability defects before user testing or after a contested design critique.
intent: |
  Produces a heuristic review that resists two failure modes: tickbox
  mode (running through 10 items with one-word answers) and the
  inverse, expanding into vague aesthetic critique. The review names
  specific violations of specific heuristics, cites the surface, and
  proposes remediations. Heuristics that don't apply are deliberately
  omitted, not padded.
type: component
theme: ux-craft
best_for:
  - A pre-launch usability check on a new surface
  - An evaluation of a contested design where the team disagrees
  - A quick (15-30 minute) sanity check ahead of a critique session
  - A periodic audit of an existing surface to identify drift
scenarios:
  - "30-minute heuristic review of a redesigned filters panel"
  - "Pre-launch heuristic pass on a new admin console"
  - "Settling a team disagreement by walking the disputed flow against heuristics"
  - "Annual heuristic audit of the top three flows by traffic"
estimated_time: 30-90 minutes (one surface); 5-10 minutes (focused single-heuristic check)
---

# Heuristic review

> v0 draft. Grounded in Jakob Nielsen's 10 Usability Heuristics for User Interface Design (NN/g, 1994; updated 2020), Don Norman's *The Design of Everyday Things*, Steve Krug's *Don't Make Me Think*, and the NN/g methodology that defines heuristic evaluation as a discount-usability technique.

## Purpose

Walk a surface through Nielsen's 10 heuristics and produce a list of specific violations with reproductions and remediations. Heuristic review is a *discount* usability method — it does not replace user testing, but it surfaces 60–80% of the issues at a fraction of the cost when applied with judgement (Nielsen's own data, replicated repeatedly).

The skill teaches what "with judgement" means. Most heuristic reviews fail not because the heuristics are wrong but because the reviewer either:

- runs through the list mechanically, producing one-line findings per item ("yes, status visible. yes, real world match…"), or
- abandons the structure halfway and writes a generic critique ("the design feels cluttered").

Neither is a heuristic review. The skill steers between them.

## Key Concepts

### Nielsen's 10 heuristics

The canonical list (updated 2020 by NN/g):

1. **Visibility of system status** — the system keeps users informed about what's going on, through appropriate feedback within a reasonable time.
2. **Match between the system and the real world** — the design speaks the users' language, with words, phrases, and concepts familiar to them; follows real-world conventions; information appears in a natural and logical order.
3. **User control and freedom** — users have clearly marked "emergency exits" from unwanted states; can undo and redo; aren't trapped.
4. **Consistency and standards** — users don't have to wonder whether different words, situations, or actions mean the same thing; the design follows platform and industry conventions.
5. **Error prevention** — even better than good error messages: a careful design that prevents problems from occurring in the first place. Eliminate error-prone conditions, or check for them and present users with a confirmation option.
6. **Recognition rather than recall** — minimize the user's memory load by making elements, actions, and options visible. The user shouldn't have to remember information from one part of the interface to another.
7. **Flexibility and efficiency of use** — accelerators (shortcuts, gestures, presets) speed up the interaction for expert users while remaining invisible to novices.
8. **Aesthetic and minimalist design** — interfaces shouldn't contain information that is irrelevant or rarely needed. Every extra unit of information competes with the relevant ones.
9. **Help users recognize, diagnose, and recover from errors** — error messages in plain language; precisely indicate the problem; constructively suggest a solution.
10. **Help and documentation** — even better when the system can be used without documentation; when documentation is needed, it is findable, focused on the user's task, and concise.

Each heuristic is a *prompt*, not a rule. A surface that "violates" heuristic 8 by showing more information than necessary may be doing so deliberately for a data-dense expert tool. The review's job is to surface where the heuristic *should* apply but doesn't.

### Heuristic review is not user testing

NN/g's own framing: heuristic review and user testing are complementary, not substitutes. Heuristic review:

- **Catches** issues that violate well-known principles.
- **Misses** issues that only real users would surface — workflow gaps, mental-model mismatches in unfamiliar domains, edge-case behaviour under stress.

A heuristic review with no user testing afterwards is a *partial* validation. Stating this in the review's preamble keeps stakeholder expectations calibrated.

### Severity, by Nielsen

Nielsen's severity ratings:

- **0** — not a usability problem.
- **1** — cosmetic only; fix when there's time.
- **2** — minor usability problem; low priority.
- **3** — major usability problem; high priority to fix.
- **4** — usability catastrophe; imperative to fix before release.

The audit assigns severities. Catastrophes are released to the team as immediate blockers; cosmetics are batched.

### Aggregate by reviewer count

Nielsen showed that 3–5 independent reviewers catch 60–80% of issues; one reviewer alone catches ~35%. For high-stakes surfaces, the review is run by multiple reviewers independently, then merged. For routine surfaces, a single reviewer is acceptable with a note acknowledging the limitation.

### Heuristics that don't apply are *omitted*

A common failure mode is padding the review with "N/A" entries for heuristics that don't apply. The discipline: only include heuristics where the surface either passes notably (worth acknowledging) or fails (the audit's purpose). Omit silently otherwise.

## Application

### Step 1 — Scope the surface and goals

State the surface, the goal the user is trying to achieve on it, and the persona. "Heuristic review of the filters panel on the search results page" is scope; "Heuristic review of the website" is not.

State who reviewed (one person? several independently?) and over what duration. Heuristic reviews benefit from a fixed time-box (45-60 minutes is typical for a single surface).

### Step 2 — Walk the surface, heuristic by heuristic

For each of the 10 heuristics:

- Walk the surface paying attention to that specific heuristic.
- Note specific findings — what is happening on the surface, what heuristic principle is being violated (or notably honoured), where exactly.
- Don't fix problems mid-walk; capture and continue.

A useful sequence: do all 10 heuristics on one screen / flow before moving on; rather than do heuristic 1 on every screen, then heuristic 2 on every screen. This keeps context fresh.

### Step 3 — Severity and remediation

For each finding, assign Nielsen severity (0-4) and propose at least one remediation. Heuristics where the surface notably *passes* can be captured as positive findings — useful when the audit wraps up to acknowledge what works.

### Step 4 — Draft the review using the template

```markdown
# Heuristic review — <Surface name>

- **Reviewer(s):** <name(s); if independent reviews were merged, list how>
- **Surface:** <screen / flow / component>
- **User goal under review:** <what the user is trying to do on this surface>
- **Date:** <YYYY-MM-DD>
- **Time-boxed at:** <duration>
- **Status:** Draft | In review | Approved | Re-audit needed

## Summary

<3-5 sentences. Highest-severity findings; overall posture; what's
working notably well; pointer to remediation owners.>

## Findings, by heuristic

(Heuristics where the surface neither notably passes nor fails are omitted.)

### Heuristic 1 — Visibility of system status

**Finding 1.1 — Severity 3.**
<Specific behaviour observed on the specific surface; where on the surface;
what principle is violated.>
**Remediation:** <one or more options>.

### Heuristic 2 — Match between system and real world

(…)

### Heuristic 5 — Error prevention

(…)

## Positive findings

<Where the surface notably honours a heuristic — worth keeping when the
remediations land.>

## Severity rollup

| Severity | Count |
|---|---|
| 4 (catastrophe) | <n> |
| 3 (major) | <n> |
| 2 (minor) | <n> |
| 1 (cosmetic) | <n> |

## Out of scope

<Surfaces / flows / heuristics deliberately not covered, with reason.>

## What this review does not catch

<Standard disclaimer: heuristic review does not replace user testing.
List specific testing recommendations that follow.>

## References

<Links to other Hornero skills consulted: state-audit, accessibility-audit,
related design-review workflow.>
```

### Step 5 — Walk findings with the design team

A heuristic review is not delivered as a memo. It is walked through with the designer and engineer responsible for the surface. Reviewers can argue with specific findings — they cannot argue with reproductions. Disputed findings get logged with the dispute and a follow-up plan (often a small user-test).

### Step 6 — Track remediation

Each finding has a remediation owner. When the surface re-enters review, the previous heuristic review is the baseline — fixed issues are confirmed closed; new issues are reviewed against the same heuristics.

## Examples

### Example 1 — Useful heuristic findings (good)

```markdown
## Findings, by heuristic

### Heuristic 1 — Visibility of system status

**Finding 1.1 — Severity 3.**
On the cart page, after a quantity change, the line item updates
optimistically but the cart total bar shows no indication that a
recompute is in progress. If the recompute fails (which we observed in
~3% of staging traffic), the line stays at the new quantity while the
total reverts to the old value, with no UI cue.
**Remediation:** Animate the total bar (subtle pulse) while recompute
is in flight; on failure, the line item reverts AND surfaces an inline
error tied to the line. (Pair with state-audit work — this is also a
missing state.)

### Heuristic 3 — User control and freedom

**Finding 3.1 — Severity 2.**
"Clear cart" is a single tap with no confirmation. Tested with the
sleep-deprived persona (40% of cart users per analytics) — high risk of
accidental clear; no undo is offered.
**Remediation:** Replace with an undo-toast pattern (5-second window),
or add a confirmation dialog for carts >5 items. Undo-toast preferred —
less friction for the modal case (most users) while still rescuing the
accidental case.

### Heuristic 5 — Error prevention

**Finding 5.1 — Severity 4.**
Promo-code input accepts and "applies" promo strings of any format,
including obvious typos and expired codes, before the server responds.
A user tapping "Apply" sees a 600-700ms window where the cart total
appears to drop, then snaps back when the server rejects the code.
**Remediation:** Either (a) inline-validate the promo format client-side
before optimistically updating the total, or (b) don't optimistically
update the total for promos — show a pending state on the promo input
only.

### Heuristic 9 — Help users recognize, diagnose, and recover from errors

**Finding 9.1 — Severity 3.**
When checkout fails due to a card decline, the user sees: "Something
went wrong. Please try again." There is no indication that the card
was declined (vs. a network failure, a server error, or a Stripe
outage); no suggestion to try a different card; no path forward.
**Remediation:** Map specific server error codes to specific copy:
  - card_declined → "Your card was declined. Try a different card or
    contact your bank."
  - card_expired → "Your card is expired. Try a different card."
  - network_error → "Couldn't reach the payment service. Check your
    connection and retry."
  - generic → "Couldn't complete your order. Contact support → <link>"

## Positive findings

- Heuristic 4 (consistency): the design correctly reuses the existing
  `Button/Primary` and `Input/Text` components from the design system;
  no novel inputs invented for this flow.
- Heuristic 8 (minimalist): the cart page resists the temptation to
  cross-sell — the recommendations rail is small, below the fold, and
  doesn't compete with the primary action.
```

### Example 2 — Failure mode (bad)

```markdown
# Heuristic review

1. Status visibility: yes ✓
2. Real-world match: yes ✓
3. Control and freedom: mostly ✓
4. Consistency: yes ✓
5. Error prevention: needs work
6. Recognition: yes ✓
7. Flexibility: not really applicable
8. Aesthetic: clean ✓
9. Error recovery: ok
10. Help: yes ✓

Overall: ship.
```

Failures: tickbox mode; no surface citations; no reproductions; no severity; "needs work" is not a finding; no remediation; "not really applicable" is padding not analysis.

## Common Pitfalls

### Pitfall 1 — Tickbox mode

**Symptom:** Each heuristic has one line. Most lines say "yes ✓". The review takes 8 minutes.

**Consequence:** The review is performative. Stakeholders learn nothing; the reviewer's credibility erodes.

**Fix:** Each finding cites surface + specific behaviour + heuristic violated + severity + remediation. Heuristics with nothing to say are omitted.

### Pitfall 2 — Untethered aesthetic critique

**Symptom:** The review starts in heuristic format and drifts into "the design feels cluttered / generic / underwhelming."

**Consequence:** The aesthetic findings may or may not be valid; they're not heuristic findings, so they can't be defended against the framework. Engineering and PM lose the through-line.

**Fix:** Each finding ties to a specific heuristic. Aesthetic critique is legitimate — but it belongs in a different artifact (a critique session, a design-review workflow with critique scope).

### Pitfall 3 — Inflated severity

**Symptom:** Every finding is severity 3 or 4.

**Consequence:** The team can't prioritise. The catastrophes blend in with the majors. Engineering scope-creeps the remediation.

**Fix:** Apply Nielsen's severity gradient honestly. Severity 4 is "imperative to fix before release" — if you wouldn't block release, it's not a 4.

### Pitfall 4 — Heuristics dictating taste

**Symptom:** Findings boil down to "this doesn't match Nielsen's guidance exactly" without considering context.

**Consequence:** The review pushes the design toward conformist defaults; bespoke design choices (information-dense expert tools, specialist data UIs) get flagged as "violations" when they're deliberate.

**Fix:** Heuristics are prompts, not rules. A finding is a finding only when the violation produces a real usability problem for a real user goal. Honour deliberate departures with reasoning.

### Pitfall 5 — Single reviewer for high-stakes surface

**Symptom:** One designer reviews a checkout flow; ships.

**Consequence:** Nielsen's data: single reviewer catches ~35% of issues. The remaining 65% pass through.

**Fix:** Two to five independent reviewers for high-stakes surfaces. Merge afterward, removing duplicates; the union catches 60–80%.

### Pitfall 6 — Heuristic review replacing user testing

**Symptom:** The review is the only validation before launch.

**Consequence:** Workflow-level usability issues, mental-model mismatches, and edge cases under stress all pass through. They surface as production complaints.

**Fix:** Always include in the review's preamble: "this review does not replace user testing; recommended user test on X within Y weeks of remediation landing."

### Pitfall 7 — No remediation

**Symptom:** Findings list violations; remediations are absent or hand-wavey ("improve error messages").

**Consequence:** Engineering improvises remediations; the design intent fragments; some "fixes" don't address the underlying violation.

**Fix:** Every finding has at least one specific remediation. Multiple options where there is genuine choice; recommend one when there isn't.

### Pitfall 8 — Review filed; never re-run

**Symptom:** Surface was heuristic-reviewed at launch; never re-reviewed despite redesigns.

**Consequence:** New violations enter unchecked. The launch review becomes irrelevant.

**Fix:** Re-review trigger stated in the audit (e.g., "re-run on every PR touching the cart total or promo flow"). For high-traffic surfaces, an annual review at minimum.

## References

- **Jakob Nielsen** — [10 Usability Heuristics for User Interface Design](https://www.nngroup.com/articles/ten-usability-heuristics/) (NN/g, 1994; updated 2020); the canonical list and the discount-usability methodology.
- **Jakob Nielsen** — ["How to Conduct a Heuristic Evaluation"](https://www.nngroup.com/articles/how-to-conduct-a-heuristic-evaluation/) (NN/g); severity rating scale; reviewer-count economics.
- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); the design principles underlying the heuristics. See `roles/designer/sources.md`.
- **Steve Krug** — *Don't Make Me Think* (3rd ed. 2014); the practical voice on what "recognition over recall" means in practice.
- **Erika Hall** — *Just Enough Research* (2nd ed. 2019); on calibrating heuristic review against actual user research.
- **Related Hornero skills:**
  - [`state-audit`](../state-audit/SKILL.md) — heuristic 1 (status visibility) is structurally addressed by the state inventory.
  - [`accessibility-audit`](../accessibility-audit/SKILL.md) — heuristics 1, 3, 7, 9 intersect with WCAG; the audits complement.
  - [`design-review`](../design-review/SKILL.md) — the workflow that runs this skill as one of its passes.
  - `roles/product-manager/skills/discovery-interview-prep/SKILL.md` — when heuristic review surfaces a question only user testing can settle.
