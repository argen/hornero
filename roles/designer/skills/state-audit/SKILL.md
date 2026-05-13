---
name: state-audit
description: Use when a designer needs to inventory every state an interactive surface must support — empty, loading, error, partial, success, and edge — before declaring the design or build complete.
intent: |
  Produces or evaluates a state inventory for a UI surface. Most shipped
  designs cover only the success state; states that surface on first
  use, slow networks, missing data, partial failure, or pathological
  inputs are designed by accident, then patched in production. This
  skill makes those states explicit, owned, and reviewable — anchored
  to feedback-and-status principles from Norman and Nielsen rather
  than treated as engineering edge cases.
type: component
theme: ux-craft
best_for:
  - A new flow or screen approaching implementation
  - A surface in code review where reviewers can't tell which states exist
  - A retro on an incident that surfaced a state nobody designed
  - An audit of an existing surface before a refactor or redesign
scenarios:
  - "Auditing the states a redesigned cart page must support"
  - "Inventorying first-run, empty, error, and re-entry states for a new dashboard"
  - "Listing partial-failure states for a multi-provider checkout"
  - "Producing the state map a designer hands to engineering as a build contract"
estimated_time: 30-60 minutes (first inventory); 10-15 minutes (review)
---

# State audit

> v0 draft. Grounded in Don Norman's *The Design of Everyday Things* (feedback principle), Jakob Nielsen's first usability heuristic ("Visibility of system status"), Steve Krug's *Don't Make Me Think* (obviousness), and the long lineage of UI-state taxonomies popularised by Brad Frost and Adam Wathan & Steve Schoger.

## Purpose

For a given UI surface, produce a complete, explicit inventory of the states it must support. The inventory is the build contract: engineering implements every state in the inventory, and ships nothing outside it. Reviewers compare the implementation to the inventory rather than imagining states from scratch.

The inventory is not a stylistic exercise. It is the single highest-leverage countermeasure against the most common shipped-too-early failure: empty/loading/error states designed by accident and patched after the first user complaint.

## Key Concepts

### Norman's feedback principle

Donald Norman (*The Design of Everyday Things*): every action a user takes must be acknowledged by the system, within a perceptible time, in a form the user can understand. A blank screen is not feedback. A spinner with no context is barely feedback. State design *is* feedback design.

### Nielsen's first heuristic — visibility of system status

Jakob Nielsen's first usability heuristic: *the system should always keep users informed about what is going on, through appropriate feedback within reasonable time.* The state inventory operationalizes this: for every state the system can be in, the user must be able to tell which one it is, and what they can do about it.

### The five canonical states

Most surfaces need five distinct states. Naming them prevents the most common gap (only-success-state) failure:

- **Empty** — the surface has nothing to show because nothing has been created yet. Distinguish *first-time empty* (user has never used this) from *cleared empty* (user used to have data; now they don't).
- **Loading** — data is being fetched. Distinguish *first paint* (skeleton, content shape implied) from *refresh* (existing content stays, freshness indicated separately) from *long-running* (>2s; needs explicit "still working" feedback).
- **Error** — the system failed in a way that prevents the user's goal. Must surface what failed, whether retry is possible, and where to go next.
- **Partial** — the system succeeded partly. Some items loaded, some didn't; some fields validated, some didn't; some providers responded, some timed out. This is the state most designs ignore entirely.
- **Success / populated** — the obvious one. Often the only one that gets designed.

### The sixth state — edge

Beyond the canonical five, every surface has *edges*: cases that are technically the success state but stress the design in ways that break it. The audit names them explicitly:

- **Long content** — usernames at character limit, titles wrapping to many lines, paragraphs in buttons.
- **Many items** — 1, 5, 50, 500, 10,000. Each often warrants a distinct treatment.
- **Zero / one / N copy** — "1 item" vs "5 items" vs "items" vs "no items" — singular/plural and zero-vs-one are different rules.
- **Missing fields** — nullable values rendered without their fields collapsing layout or showing "undefined".
- **Slow / offline / failed dependency** — what does the surface show when a non-critical dependency is unreachable?
- **Wrong locale / RTL** — direction flip; non-Latin scripts; large character widths (e.g., Devanagari ascenders).

Edges are not the same as errors. An edge is a successful render under pathological inputs; an error is a failed one.

### State *transitions* are also designs

A state inventory that lists states but ignores transitions between them is half-finished. Loading → success has different feedback needs than loading → error. Error → retry → success differs from error → give-up → empty. Each transition is a moment where the user can be confused; each warrants explicit design.

### "Designed by accident" is the failure mode to prevent

The state-audit's purpose is to surface every state *before* engineering builds them, so each state is designed deliberately. The opposite is what happens by default: engineering implements the success state from the comp, then improvises the others under time pressure. Improvised states are where AI-aesthetic spinners and "Something went wrong" copy come from.

## Application

### Step 1 — Scope the surface

Define what counts as one surface for this audit. Heuristics:

- **A screen / page / view** is usually one surface.
- **A modal or sheet** is its own surface if it can be in distinct states relative to the underlying screen.
- **A widget that appears on many screens** is one surface, audited once.
- **A flow** (signup, checkout, onboarding) is *not* one surface — it is N surfaces audited sequentially.

If the scope feels ambiguous, smaller wins. A precise inventory of three screens is more useful than a vague one of a "flow."

### Step 2 — Identify what the surface depends on

State combinatorics come from dependencies. For the surface, list:

- **Data the surface displays** (cart items, user profile, search results, dashboard metrics).
- **Network calls the surface makes** (each is a potential error / partial / slow).
- **User input the surface accepts** (text, file upload, selection — each has its own success / error / empty).
- **Permissions / capabilities the surface relies on** (notifications, camera, biometric).
- **External providers the surface composes** (payment, identity, search backend).

For each dependency, ask: what does the user see while it is loading, failed, partial, or absent?

### Step 3 — Draft the state inventory

```markdown
# State inventory — <Surface name>

- **Designer:** <name>
- **Surface:** <screen / view / widget>
- **Linked design:** <Figma / mockup / repo path>
- **Status:** Draft | In review | Approved | Stale
- **Last updated:** <YYYY-MM-DD>

## Dependencies

- <Data source / call / capability — short description>
- <…>

## States

### 1. Empty — first-time
- **When:** <condition that puts the surface here>
- **What the user sees:** <description; reference to comp if there is one>
- **Affordance:** <what action(s) can be taken from this state>
- **Copy:** <exact strings; do not write "TBD">
- **Transition out:** <what state(s) this leads to and how>

### 2. Empty — cleared / re-entry
(If distinct from first-time empty.)

### 3. Loading — first paint
- **When:** <fresh navigation; no cached content>
- **What the user sees:** <skeleton? shimmer? content shape implied?>
- **Time threshold:** <after how long does this transition to long-running?>
- **Transition out:** <success | error | long-running>

### 4. Loading — refresh
(If the surface supports refresh-in-place separate from first paint.)

### 5. Loading — long-running
- **When:** <after Nms of first-paint loading>
- **What the user sees:** <explicit "still working" + escape hatch>
- **Affordance:** <can the user cancel? continue elsewhere?>

### 6. Error — recoverable
- **When:** <expected failure modes; list each>
- **What the user sees:** <clear cause + retry affordance + alternative path>
- **Copy:** <specific; not "Something went wrong">

### 7. Error — unrecoverable
- **When:** <e.g., permission revoked at OS level; account suspended>
- **What the user sees:** <route to support / explanation / next step>

### 8. Partial
- **When:** <multi-call surface where some calls succeed, some fail>
- **What the user sees:** <successful items rendered; failed items marked
  distinctly; retry-per-item or retry-all affordance>

### 9. Success — populated
- **When:** <the happy path>
- **What the user sees:** <the comp>

### 10. Success — edges
For each edge variant the surface must support:
- **Long content:** <how truncation / wrapping / overflow works>
- **Many items:** <pagination? virtualization? list-end empty state?>
- **Zero / one / N copy:** <which strings change>
- **Missing fields:** <which fallbacks render>
- **Wrong locale / RTL:** <which assumptions flip>

## State transitions

A table or diagram listing every transition the surface supports, with the trigger and any feedback the transition itself produces (toast, animation, focus management).

| From | To | Trigger | Feedback |
|---|---|---|---|
| empty | loading | user creates item | optimistic insert; toast on confirm |

## Out of scope

<States this audit deliberately does NOT cover, with reason.>

## Open questions

<Each owned, with a date.>
```

### Step 4 — Self-review against seven checks

1. **Five-canonical-states check.** Every one of empty / loading / error / partial / success is present or explicitly deferred with reason.
2. **First-time-vs-cleared empty check.** If both apply, both are listed.
3. **Loading-fidelity check.** First-paint vs refresh vs long-running are distinguished if the surface needs them.
4. **Error-recovery check.** Every error state names how the user recovers — retry, alternative path, route to support. "Something went wrong" with no recovery is not a state, it is a placeholder.
5. **Partial-state honesty.** If the surface makes more than one network call, the audit either lists the partial state or explicitly defends its absence.
6. **Edge-cases-named check.** At least three edges are listed (long content, many items, missing fields are the most common). Skipping all of them is a failure.
7. **Transitions-listed check.** The transitions table has at least the same number of rows as 60% of the states. Surfaces with mostly states and no transitions are incomplete maps.

### Step 5 — Walk the inventory with engineering

The inventory is a build contract. Engineering reads it; gaps become questions ("we have no copy for the long-running loading state — do you want a generic 'still working' or something context-specific?"); the answers go back into the inventory.

This conversation is where most of the state-audit's value materializes. A designer who hands the inventory off without the conversation loses half of it.

### Step 6 — Hand off + reuse

The inventory lives next to the design (Figma, repo, doc). When the surface is reviewed, the reviewer compares the build to the inventory. When the surface is changed later, the inventory is updated alongside the change.

## Examples

### Example 1 — Cart-page inventory (good, abridged)

```markdown
# State inventory — Cart page

Linked: figma.com/file/.../cart-v3
Status: Approved (2025-11-04)

## Dependencies
- GET /cart (items, totals, promo)
- GET /cart/recommendations (cross-sell)
- POST /cart/item/{id}/qty (line-item update)
- POST /cart/promo (promo apply)
- GET /shipping/methods (shipping options)

## States

### Empty — first-time
When: user has never added to cart; cart is `{items: []}`.
What: hero illustration (existing component IL/02), headline "Your cart's empty", CTA "Browse products" → /catalog.
Copy: exact strings in linked Figma frame "Cart / Empty / First".

### Empty — cleared / re-entry
When: user previously had items; cart was emptied (purchase OR explicit clear OR expiry).
What: smaller version of empty-first-time + a "Saved for later" rail if the user has saved items.
Copy: "Cart's empty again. Saved items below ↓"
Transition out: from saved → cart restores state Empty → Loading → Success.

### Loading — first paint
When: navigation to /cart, no cached cart.
What: header + 3 skeleton rows (line items) + footer skeleton.
Time threshold: 2s → long-running state.

### Loading — refresh (line-item qty update)
When: user changes a line item's quantity.
What: optimistic update of the line; the total bar gets a subtle pulsing
animation (1.5px translucent overlay) while the new total is computed.
Reduced-motion: replace pulse with static "Updating…" text.

### Loading — long-running (>2s)
What: replace skeletons with explicit "Still loading your cart…" + a "Try again" link that retries the request.

### Error — cart load failed
When: GET /cart returns 5xx, times out, or network unreachable.
What: friendly title "Couldn't load your cart" + specific reason where known + Retry button + link to support.
Copy: never "Something went wrong" alone.

### Error — line-item update failed
When: POST /cart/item/{id}/qty fails after optimistic update.
What: revert the optimistic line; inline error on the line ("Couldn't update — tap to retry"); the rest of the cart is unaffected.

### Error — promo invalid
When: POST /cart/promo returns 400 (bad code) or 410 (expired).
What: inline form error tied to the promo input; cart contents unchanged.

### Partial — recommendations failed but cart loaded
When: GET /cart succeeds; GET /cart/recommendations fails.
What: cart renders fully; the cross-sell rail is hidden (no error visible to user); a single anomaly event logged.

### Partial — shipping methods unavailable
When: GET /shipping/methods times out.
What: cart renders; the shipping selector shows a disabled state ("Shipping options unavailable — Retry") rather than blocking checkout entirely.

### Success — populated (happy path)
See Figma frames "Cart / Success".

### Success — edges
- Long product title: truncate at 2 lines with ellipsis; full title in hover/long-press tooltip.
- 50+ items: virtualize the list (engineering); keep the totals bar pinned.
- Singular vs plural: "1 item" / "2 items" / "0 items"; never "1 items".
- Missing image: fallback to category icon (existing token icon/category/<slug>).
- RTL locales (Arabic, Hebrew): direction flips; the cart icon's chevron flips; prices remain LTR per locale convention.

## State transitions

| From | To | Trigger | Feedback |
|---|---|---|---|
| empty-first-time | loading-first-paint | user adds to cart from /catalog | (transition is on /catalog, not /cart) |
| loading-first-paint | success | response < 2s | skeletons fade to content (200ms) |
| loading-first-paint | error-load-failed | 5xx or timeout | skeletons replaced by error frame |
| loading-first-paint | loading-long-running | >2s elapsed | skeleton stays, "Still loading…" text fades in |
| success | loading-refresh | qty change | inline optimistic + pulse on total |
| loading-refresh | success | POST 2xx | pulse stops |
| loading-refresh | error-line-item | POST 4xx/5xx | revert line, inline error |
| success | partial-shipping | shipping call times out post-load | shipping selector disables |

## Out of scope
- Saved-for-later rail (separate inventory `saved-items`).
- Guest-vs-authenticated cart merge (separate inventory `cart-merge`).

## Open questions
- Long-running loading copy: should we name the bottleneck if we know it? (Owner: Bruno, by 2025-11-08.)
```

A reviewer comparing the build against this inventory has a precise checklist. An engineer asked to implement the cart has a precise contract. A future incident referencing "we didn't have a state for X" has a precise artifact to update.

### Example 2 — Failure mode (bad)

```markdown
# Cart page states
- Empty
- Loading
- Filled
- Error
```

Failures: empty isn't disaggregated; loading isn't disaggregated; "Error" is a label, not a state design; partial state absent; no edges; no transitions; no dependencies; no copy. This is a list of words, not an inventory.

## Common Pitfalls

### Pitfall 1 — Success-state-only

**Symptom:** The inventory lists only the populated state in any detail; empty / loading / error / partial are placeholders with no copy or affordance.

**Consequence:** Engineering improvises the other states under time pressure. The improvisations become the AI-aesthetic spinners and "Something went wrong" copy users encounter.

**Fix:** No state ships without explicit copy and affordance, including the loading and empty states. The audit's purpose is to force the conversation.

### Pitfall 2 — "Error" as one state

**Symptom:** A single "Error" entry; no decomposition of error types (network, permission, validation, server, dependency).

**Consequence:** All errors render the same; users can't tell what failed; recovery is generic ("try again"); retry-loops on unrecoverable errors waste user time.

**Fix:** Decompose by error class. Each class has its own copy and recovery affordance. Some errors aren't retry-able — they need different shapes (route to support, suggest alternative path).

### Pitfall 3 — Partial state ignored

**Symptom:** The surface makes 3-7 network calls. The inventory has one success state assuming all 7 succeed.

**Consequence:** Real production conditions (one provider slow, one timed out) produce undesigned shapes — usually either a broken-looking partial render or a blocking error that the user couldn't have avoided.

**Fix:** For multi-call surfaces, partial is a first-class state. Decide explicitly: which calls' failure blocks the surface? Which degrade silently? Which surface inline errors?

### Pitfall 4 — Edges only at QA time

**Symptom:** Long content, many items, missing fields are discovered when QA runs them, not by the designer.

**Consequence:** Layout breaks are patched in implementation; the design system grows ad-hoc overrides; consistency erodes.

**Fix:** Edges are part of the audit. Designer enumerates them; design comp covers at least the highest-risk ones (long content, zero/one/N, missing fields).

### Pitfall 5 — Inventory without transitions

**Symptom:** All states are listed; the transitions between them are not.

**Consequence:** The trickiest moments (loading→error→retry→loading→success) are designed in isolation. The composition is awkward in motion even though each frame is fine.

**Fix:** Transitions table with trigger and feedback. Plus motion / focus / toast specifications for the transitions where they matter.

### Pitfall 6 — Inventory as fiction

**Symptom:** The audit is produced; engineering ignores it; reviewers don't reference it; it falls out of date.

**Consequence:** The artifact's authority erodes. The states drift back to "design the success, improvise the rest."

**Fix:** The inventory is referenced in PR descriptions (e.g., "implements states 1, 3, 6, 9 from cart-state-inventory"). Reviewers compare the build to it. When the build deviates, the inventory is updated, not silently abandoned.

### Pitfall 7 — Copy as "TBD"

**Symptom:** Every state's Copy field is "TBD" or "to be written by content."

**Consequence:** Content is written under deadline pressure by whoever is available. Voice fragments; "Something went wrong" appears in three different places with three different tones.

**Fix:** Write exact strings, even if they are placeholders the content team will refine. The designer is responsible for the *shape* of every string in the inventory; content can rewrite individual words later.

### Pitfall 8 — Per-screen audit; flow ignored

**Symptom:** Each screen has an inventory; the flow connecting them does not.

**Consequence:** Inter-screen states (a user arriving at a screen from a failed action on the previous one) are undesigned.

**Fix:** For non-trivial flows, the audit is extended with a flow-level state: which entry conditions does each screen handle? What does "back" from this screen mean in each state?

## References

- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); feedback principle; gulf of evaluation. See `roles/designer/sources.md`.
- **Jakob Nielsen** — 10 Usability Heuristics for User Interface Design (NN/g, 1994; updated 2020); heuristic 1 (visibility of system status). [nngroup.com](https://www.nngroup.com/articles/ten-usability-heuristics/).
- **Steve Krug** — *Don't Make Me Think* (3rd ed. 2014); obviousness principle.
- **Adam Wathan & Steve Schoger** — *Refactoring UI* (2018); visual hierarchy and the cost of missing-state design.
- **Brad Frost** — *Atomic Design* (2016); state taxonomy as a component-system concern.
- **Microsoft Inclusive Design Toolkit** — situational / temporary / permanent constraints inform state coverage (network down ↔ network slow ↔ ambient noise).
- **Related Hornero skills:**
  - [`accessibility-audit`](../accessibility-audit/SKILL.md) — accessibility pass complements the state audit; many edge cases are accessibility cases.
  - [`heuristic-review`](../heuristic-review/SKILL.md) — Nielsen-10 review will repeatedly hit heuristic 1, which the state audit covers structurally.
  - [`design-review`](../design-review/SKILL.md) — the workflow that consumes the state inventory as one of its inputs.
  - `roles/tester/skills/test-plan/SKILL.md` — state inventory feeds the test plan's HTSM Function / Data / Time rows.
  - `roles/software-engineer/skills/rfc/SKILL.md` — for non-trivial surfaces, the state inventory is referenced from the RFC's UX section.
