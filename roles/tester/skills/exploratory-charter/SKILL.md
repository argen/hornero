---
name: exploratory-charter
description: Use when a tester needs to plan or conduct a structured exploratory test session — a time-boxed, mission-driven investigation of an area to surface bugs and unknown unknowns.
intent: |
  Produces or evaluates an exploratory test charter in Elisabeth
  Hendrickson's format — Mission, Areas, Notes, Bugs — anchored to a
  touring heuristic that biases the session toward a particular class
  of defect. The charter disciplines exploration so it is reproducible
  and defensible, without collapsing into scripted execution.
type: component
theme: test-strategy
best_for:
  - A new feature where automated tests cover the spec but not the unknown
  - A regression-prone area following a near-miss incident
  - Pre-release "are there bugs we don't know to look for" investigation
  - A surface where the team has lost confidence in automated coverage alone
scenarios:
  - "Exploring a new admin-console permission surface before launch"
  - "Stress-touring a redesigned checkout flow ahead of Black Friday"
  - "Money-touring a billing migration to surface revenue-affecting bugs"
  - "Configuration-touring a multi-tenant feature for cross-tenant leakage"
estimated_time: 60-120 minutes per session (charter + execution + report); 10 minutes (charter critique)
---

# Exploratory charter

> v0 draft. Grounded in Elisabeth Hendrickson's *Explore It!* (2013), James Bach & Michael Bolton's RST methodology, and Maaret Pyhäjärvi's working-practitioner writing on combining exploratory and automated testing.

## Purpose

Make exploratory testing a deliberate, repeatable, defensible practice rather than "play with the feature for a while." Three properties matter:

1. **Mission-driven** — every session has a specific question to answer.
2. **Time-boxed** — sessions are short enough (30-120 minutes) that the tester stays attentive; results compound across sessions.
3. **Tour-anchored** — the session adopts a touring heuristic (Hendrickson) that biases attention toward a particular class of defect.

Charters live in version control alongside the test plan, the same way ADRs live alongside the code. A charter is *evidence* the exploration happened — and a forward-pointer for what to explore next.

## Key Concepts

### Hendrickson's charter format

From *Explore It!*: the charter has four sections — **Mission, Areas, Notes, Bugs**. The mission is one sentence ("Explore the checkout flow as a returning customer with a saved card under network throttling to discover bugs in retry behaviour"). Areas are the surfaces you will visit. Notes capture observations and questions in real time. Bugs are filed separately with full reproduction steps.

### Touring heuristics

Hendrickson catalogues a set of tours, each of which biases the session toward a class of defect:

- **Feature tour** — every feature, briefly. Surfaces broken-but-shipping behaviour.
- **Claims tour** — every claim the marketing copy or docs make. Surfaces over-promised behaviour.
- **Configuration tour** — every configuration option / setting / preference. Surfaces option interaction bugs.
- **Stress tour** — every limit (length, count, size, rate). Surfaces boundary failures.
- **Money tour** — every place money moves, accrues, or is reported. Surfaces revenue-affecting defects.
- **Garbage tour** — every place input can be malformed. Surfaces parsing and validation bugs.
- **Interruption tour** — every flow, deliberately interrupted (close tab, network drop, kill app). Surfaces state-recovery bugs.
- **Data tour** — every distinct data class (empty, very long, special characters, multi-byte, RTL languages).
- **History tour** — every recently-changed area (per `git log`). Surfaces regressions in flight.
- **Couch potato tour** — accept every default. Surfaces "what does a passive user experience" issues.

A session adopts *one* tour, named in the charter. Mixing tours in a session dilutes the heuristic and makes outcomes harder to learn from.

### Time-box discipline

Sessions are 30, 60, 90, or 120 minutes. Beyond 120 minutes attention degrades; under 30 minutes there is not enough investigation depth. The time-box is announced at the start; when it elapses, the session ends and the charter is written up — regardless of progress. (If more time is needed, schedule a follow-up charter.)

### Note-taking as the artifact

The notes are the most under-valued piece. They capture:

- What the tester did (the path through the feature).
- What they observed (specific behaviours).
- What they thought (questions, surprises, anomalies).
- What they could not check (deferred areas, blocked observations).

A session that produces no notes has produced no learning, regardless of whether bugs were found.

### Bug filing vs note-taking

Bugs are filed in the team's issue tracker with full repro steps, not in the charter. The charter links to bugs filed. This keeps the charter scoped to its actual purpose (evidence of investigation) and the bugs in the place the team already manages them.

### Charter sessions, not roving testing

Pyhäjärvi: the discipline is *charter-based exploratory testing*, not "ad-hoc testing dressed up." A session that wanders off its charter is two half-sessions, each weaker than one focused session would have been.

### Pair / ensemble exploration

Pyhäjärvi again: two-tester or whole-team ensemble sessions surface different bugs than solo sessions, because participants notice different things. The charter format supports this — one driver, one navigator, real-time note-taking by the navigator. Useful for high-stakes surfaces (pre-release critical paths, security-adjacent features).

## Application

### Step 1 — Decide tour and surface

Frame three questions:

1. **What class of defect am I most worried about for this surface right now?** Pick the matching tour.
2. **What is the smallest surface I can productively explore in one session?** Resist scope expansion — "the new admin console" beats "the whole application."
3. **What automated coverage already exists?** Exploratory complements automation; it shouldn't duplicate it. Read the test plan first.

If your top concern is "I don't know what to worry about," start with a Feature tour to build a map, then return with a more targeted tour.

### Step 2 — Draft the charter

```markdown
# Charter — <Tour name>: <Surface>

- **Tester(s):** <name(s)>
- **Date / time:** <YYYY-MM-DD, time-box: 30/60/90/120 minutes>
- **Status:** Planned | In progress | Complete | Abandoned
- **Linked plan:** <test-plan link if applicable>
- **Build / version under test:** <SHA, version, env>

## Mission

<One sentence. "Explore [surface] using [tour] as a [persona] to discover
bugs in [area of concern]." The clearer the mission, the cleaner the notes.>

## Areas in scope

<3-7 specific areas the session will visit. Bulleted, concrete.>

## Areas explicitly out of scope

<What we will NOT investigate in this session — defer to a follow-up
charter or to automated coverage.>

## Setup / environment

<What the tester needs in place before starting: account, data, feature
flags, environment, tools.>

## Notes

<Filled in during the session — appended chronologically. Each entry
timestamped if practical.

  10:04  Logged in as a returning customer; saved-card list loaded
         normally (3 cards).
  10:06  Tried to add a card with expired date — form rejected; good.
  10:09  Tried to add a card with date "13/2030" — accepted! Submitted
         silently. Filed BUG-1247.
  10:12  Network throttle to "slow 3G"; tried checkout again; spinner
         spun for 14s and then page said "Success" but no order id.
         Reproduced 2x. Filed BUG-1248.
  10:25  Couldn't get into the gift-card path — modal didn't open.
         Tracker has it as "in flight" — not blocked, just not testable
         today. Deferred.>

## Bugs filed

<Links / IDs only. Full repros live in the tracker.>

## Follow-up charters

<What this session surfaced that warrants its own session.>

## Coverage summary

<3-5 sentences. What got covered, what didn't, what level of confidence
the tester now has about this surface.>
```

### Step 3 — Execute the session

1. **Start the timer.** Don't pre-explore; the charter is your plan.
2. **Take notes continuously.** When you find a bug, capture enough to file later; don't break flow to write a full ticket.
3. **Stay on charter.** If you find an obvious bug outside the charter's areas, note it and keep going. Don't pivot the session.
4. **Stop when time elapses.** Even mid-flow. Discipline preserves the practice.
5. **Write up immediately.** Notes get less accurate within an hour of the session ending.

### Step 4 — File bugs, schedule follow-ups, archive the charter

- Each bug becomes a tracker ticket with full repro steps and the charter referenced.
- Follow-up charters get added to the backlog.
- The completed charter is committed to the repo (e.g., `tests/charters/2025-11-04-money-tour-checkout.md`). It is the audit trail.

### Step 5 — Critique against six checks (when reviewing a charter)

When reviewing someone else's charter — or your own before circulating:

1. **Mission specificity.** Could you swap "checkout" for "search" without changing the rest? If yes, the mission is too vague.
2. **One tour, named.** If the charter says "we'll do feature + stress + money," it's three half-charters.
3. **Time-boxed.** A box is stated and respected.
4. **Notes-substantive.** Notes describe observations, not "tested fine." A note that just says "OK" has captured no learning.
5. **Out-of-scope present.** At least one area excluded with reason. Otherwise the session bleeds.
6. **Followups captured.** What didn't get explored should be visible as future charters or backlog.

## Examples

### Example 1 — Money tour on a billing migration (good)

```markdown
# Charter — Money tour: Stripe → Adyen migration in checkout

- **Tester:** Aisha
- **Date / time:** 2025-11-04, 09:30, 90-minute box
- **Status:** Complete
- **Linked plan:** test-plan-2025-q4-payments.md
- **Build:** SHA c4f29b1, staging env "checkout-staging-3"

## Mission

Explore the checkout flow with the new Adyen integration enabled as a
returning paid customer, focusing on every place money is calculated,
displayed, charged, refunded, or reported.

## Areas in scope

- Cart total calculation (subtotal, tax, shipping, discount, gift-card credit).
- Currency rounding for EUR, JPY (no decimals), KWD (3 decimals).
- Saved-card list rendering and selection.
- Refund flow from admin console.
- Receipt email (subject and body).
- Invoice PDF.
- Order detail page in customer account.

## Out of scope

- Subscription billing (different code path; separate charter).
- B2B invoicing (different code path; separate charter).
- Fraud-rule rejection flow (security-adjacent; coordinate with security-expert).

## Setup

- Test account with: 2 saved cards, 1 active gift-card balance, EUR-locale.
- Adyen feature flag ON.
- Admin access for refund testing.

## Notes

09:32  Cart with EUR 99.95 + 21% VAT → showed €120.94. Rounded correctly.
09:34  Switched cart to JPY ¥9999 + 0% tax → ¥9999. No decimals shown. OK.
09:36  KWD cart with KWD 12.345 → displayed KWD 12.34. Rounded DOWN — should
       round to nearest. Filed BUG-1301.
09:42  Applied 10% discount to EUR cart. Tax was calculated on pre-discount
       subtotal — possibly intentional; flagged for finance review,
       not a bug per se. Filed Q-218 (question, not bug).
09:48  Saved-card list rendered "Visa ****1111" — masked correctly.
09:50  Gift-card balance applied via tickbox. Cart total updated. Charge
       was for total-minus-gift-balance; gift balance decremented by exact
       amount. OK.
10:02  Refunded an order partially via admin. Adyen refund issued for
       partial amount; but receipt email said "refunded in full" —
       wrong copy. Filed BUG-1302.
10:18  Invoice PDF: rendered totals correctly, but Adyen reference number
       was blank where Stripe charge ID used to appear. Filed BUG-1303.
10:35  Receipt email: subject said "Your Stripe receipt for order ..." —
       hardcoded provider name. Filed BUG-1304.
10:47  Order detail page: "Payment method: Visa" — but no provider, no
       last-4. Worse than before. Filed BUG-1305.
10:58  Box elapsed; some currency edge cases not visited (CHF, MXN).

## Bugs filed

- BUG-1301 (KWD rounding direction)
- BUG-1302 (refund email copy wrong)
- BUG-1303 (invoice PDF missing Adyen ref)
- BUG-1304 (receipt subject hardcoded "Stripe")
- BUG-1305 (order detail loses provider/last-4 info)
- Q-218 (tax-on-pre-discount subtotal — finance question, not a bug)

## Follow-up charters

- Money tour on subscription billing migration (next week).
- Garbage tour on Adyen webhook payload (could parse malformed gracefully?).
- Configuration tour on per-tenant Adyen credential setup.

## Coverage summary

Cart, totals, currency rendering, gift-card, saved-card, refund admin
flow, receipts, invoice, order detail explored. Subscription, B2B,
fraud-flow out of scope. Five bugs filed (one revenue-correctness, four
post-purchase comms). Currency rounding for CHF/MXN not visited; add to
follow-up. Confidence in cart-math layer: high. Confidence in
post-purchase comms layer: low — strong recommendation to block release
until BUG-1302 through BUG-1305 are fixed.
```

A reviewer can argue with the prioritisation; they cannot claim the session was unstructured. Each note is specific; each bug is filed; the coverage summary makes the recommendation defensible.

### Example 2 — Failure mode (bad)

```markdown
# Charter — Testing the new feature

- **Tester:** me
- **Date:** today

## Mission
Test the new feature.

## Notes
Looked good. A couple of issues — will file later.

## Bugs
TBD.
```

Failures: mission is vacuous; no tour named; no time-box; notes are insubstantial; bugs not filed. The charter is evidence of nothing.

## Common Pitfalls

### Pitfall 1 — Mission as topic, not question

**Symptom:** Mission reads "Explore checkout" rather than "Explore checkout under throttled network to discover bugs in retry behaviour."

**Consequence:** The session has no center of gravity. The tester drifts. Notes are unfocused. Future readers can't tell what was investigated.

**Fix:** Mission is one sentence in the form *"Explore [surface] using [tour] as [persona] to discover bugs in [class of defect]."* If you can't fill in the blanks, pre-think more before starting.

### Pitfall 2 — Tour mixing

**Symptom:** The charter says "Feature + Money + Stress tour."

**Consequence:** The session attempts three things, completes none deeply. Each tour's specific bias is diluted.

**Fix:** One tour per session. If multiple tours are needed, schedule multiple sessions.

### Pitfall 3 — No time-box, or "until I'm done"

**Symptom:** Session "wraps up" when the tester feels finished.

**Consequence:** Attention drifts; later notes are weaker than earlier; the session expands inconsistently across days.

**Fix:** 30 / 60 / 90 / 120 minutes. Pick one. Honour it. Schedule a follow-up if needed.

### Pitfall 4 — Test-while-charting

**Symptom:** Bugs are fully filed during the session — repro steps written in the tracker, screenshots uploaded mid-flow.

**Consequence:** Flow breaks; later areas don't get visited; the session essentially becomes a single-bug investigation.

**Fix:** Capture enough in notes to reconstruct; file properly after the session ends. Five minutes of post-session filing > thirty minutes of in-session filing.

### Pitfall 5 — Note-taking as ceremony

**Symptom:** Notes read "Cart works. Checkout works. Payment works." Same shape for every area.

**Consequence:** The notes contain no observations. The artifact is evidence of nothing.

**Fix:** Notes capture *specific things you saw*, including surprises and questions. If your note for an area could be copy-pasted from another area, you haven't observed it.

### Pitfall 6 — Charter without follow-ups

**Symptom:** Coverage summary says "looks good"; no follow-up charters proposed.

**Consequence:** Either the surface was trivial (then a charter wasn't warranted), or the tester missed the chance to compound learning into the next session.

**Fix:** Every session generates at least one follow-up charter idea (even if "investigate area X next quarter"). The compounding harness is built one charter at a time.

### Pitfall 7 — Charter as automation backlog

**Symptom:** Every note ends with "should automate this."

**Consequence:** Exploration becomes a script-writing exercise; the discovery purpose is lost.

**Fix:** Some findings warrant automation, some don't. The session's job is to *find* and *learn*. Automation decisions get made after, by reviewing the charter in cold blood and asking "which of these would I want regression coverage on?"

## References

- **Elisabeth Hendrickson** — *Explore It! Reduce Risk and Increase Confidence with Exploratory Testing* (2013). The charter format and the touring heuristics are hers. See `roles/tester/sources.md`.
- **James Bach & Michael Bolton** — Session-Based Test Management (SBTM); RST methodology that frames exploration as deliberate practice. [satisfice.com](https://www.satisfice.com/).
- **Maaret Pyhäjärvi** — *Exploratory Testing* (2017); working-practitioner writing on charter-based and ensemble testing.
- **Brian Marick** — early framing of exploratory vs scripted testing; testing quadrants.
- **Related Hornero skills:**
  - [`test-plan`](../test-plan/SKILL.md) — the plan that inventories charters and the surfaces they cover.
  - [`pre-release-test-pass`](../pre-release-test-pass/SKILL.md) — the workflow that orchestrates one or more charters at release time.
  - [`regression-test`](../regression-test/SKILL.md) — bugs surfaced here become failing tests authored there.
