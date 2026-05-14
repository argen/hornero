---
name: accessibility-audit
description: Use when a designer needs to audit a UI surface against WCAG 2.2 conformance and inclusive-design principles — not as a compliance tickbox but as a usability check for the full audience.
intent: |
  Produces or evaluates an accessibility audit that resists the
  compliance-theatre failure mode. The audit names specific failures
  with reproductions, surfaces situational and temporary constraints
  alongside permanent disabilities, and ties findings to specific
  remediations rather than vague "improve a11y" recommendations.
  Anchored to WCAG 2.2 AA as the floor and Kat Holmes's inclusive
  design framework as the broader frame.
type: component
theme: accessibility-and-inclusion
best_for:
  - A new surface approaching launch
  - A surface that passes automated tools but feels broken to real users
  - A redesign of a high-traffic flow (checkout, signup, search)
  - A pre-launch pass on a regulated product (public sector, healthcare, finance)
scenarios:
  - "Auditing a redesigned checkout flow before public launch"
  - "Diagnosing why a 'WCAG AA compliant' dashboard is unusable to a screen-reader user"
  - "Pre-launch pass on a new admin console with complex tables"
  - "Auditing a redesigned navigation against keyboard-only and screen-reader use"
estimated_time: 60-180 minutes (first audit); 15-30 minutes (focused re-audit)
---

# Accessibility audit

> v0 draft. Grounded in WCAG 2.2 (W3C, 2023), Kat Holmes's *Mismatch: How Inclusion Shapes Design* (2018) and the Microsoft Inclusive Design Toolkit, Jakob Nielsen's heuristics where they intersect accessibility, and Mike Monteiro's *Ruined by Design* on the ethical stakes.

## Purpose

Audit a UI surface so that real users — keyboard-only, screen-reader, low-vision, colorblind, motor-impaired, cognitively-loaded, situationally-impaired (driving, parenting, bright sun) — can complete the surface's goals.

Two failure modes the audit deliberately resists:

1. **Compliance theatre.** A "WCAG AA compliant" surface that fails the first real screen-reader walkthrough. Automated tools catch 30–40% of accessibility issues; the rest require human review.
2. **Permanent-only thinking.** Designing only for permanent disabilities misses the larger audience: temporary impairments (a broken wrist, an eye infection, sleep deprivation) and situational constraints (bright sunlight, a baby in one arm, a noisy environment). Holmes's principle — *solve for one, extend to many* — directly applies.

The audit produces a finding inventory each item has a specific reproduction, a severity, and a remediation. Vague "improve accessibility" findings are not audits; they are diary entries.

## Key Concepts

### WCAG 2.2 AA as floor

The Web Content Accessibility Guidelines (W3C, 2023) define four principles — **Perceivable, Operable, Understandable, Robust** (POUR) — and 50 success criteria. AA conformance covers the criteria most relevant to most products; AAA covers further criteria for specialised contexts (medical, public-sector portals).

WCAG conformance is the *floor*. Surfaces can be technically compliant and substantively inaccessible. The audit checks WCAG criteria but does not stop there.

### Kat Holmes's inclusive design

Holmes (*Mismatch*) and the Microsoft Inclusive Design Toolkit reframe accessibility around three intersecting situations:

- **Permanent.** Someone who is blind. A wheelchair user. A non-native speaker of the product's language.
- **Temporary.** Someone with a broken arm. A new parent on broken sleep. A user with conjunctivitis.
- **Situational.** Someone driving. Someone holding a baby. A bright-sun phone screen. A noisy café where audio cues are useless.

The audit considers all three. A flow that requires precision touch fails for permanent motor impairments, temporary broken wrists, and situational one-handed-baby-holding. Solving for one extends to many — the design improvement that helps the wheelchair user also helps the user in a bright-light situation.

### POUR as the audit's spine

The audit walks the surface through the four POUR principles:

- **Perceivable** — can the user *take in* the information regardless of sensory channel? Color contrast, text alternatives, captions, screen-reader semantics.
- **Operable** — can the user *act* on the interface regardless of input modality? Keyboard navigation, motor-friendly targets, no time-outs without recourse, no seizure triggers.
- **Understandable** — can the user *make sense of* the interface? Clear language, predictable interactions, error messages that explain and recover, consistent labels.
- **Robust** — does the interface work with the *tools* the user brings? Semantic HTML / native components; assistive-technology compatibility; future-tool compatibility.

### Severity discipline

Each finding has a severity, chosen by impact, not by aesthetics:

- **Blocker** — a user cannot complete the goal. Examples: form labels missing, focus invisible, keyboard trap, contrast below 3:1 on essential controls.
- **High** — a user can complete the goal but with significant friction or risk of error. Examples: long focus path, ambiguous icons, decorative animation that doesn't respect `prefers-reduced-motion`.
- **Medium** — friction for some users, fine for others. Examples: redundant ARIA, suboptimal heading structure where a workaround exists.
- **Low** — polish; would-be-nice. Examples: focus ring color contrast against background, single non-critical alt-text refinement.

Findings without severity are noise; findings with inflated severity erode trust in the audit.

### Reproduce, don't generalize

Each finding cites the specific surface, the specific tool, and the specific behaviour observed:

> "Checkout step 2, focus enters the postcode field, tabbing forward jumps three fields ahead because input #shipping-method has `tabindex=10` overriding source order. Tested in VoiceOver/Safari 17 and NVDA/Firefox 121. Severity: high."

Not "tab order is broken."

A reproduction is the audit's load-bearing claim. Without one, the finding is unfalsifiable; with one, engineering can verify and fix.

## Application

### Step 1 — Frame and scope

Set the audit's scope. Heuristics:

- **A flow** (signup, checkout) is the right scope. Auditing every screen in a product at once produces a low-quality audit.
- **A complex surface** (a data table, a media player) often warrants its own audit.
- **A surface with a recent change** is a natural scope; pair the audit to the diff.

State the **tools** used. A meaningful audit uses at least:

- **Two screen-readers.** Pair desktop (NVDA + Firefox or VoiceOver + Safari) with mobile (TalkBack on Android or VoiceOver on iOS) if the product runs on both.
- **Keyboard only.** Tab, Shift-Tab, Enter, Space, Esc, arrow keys; no mouse.
- **Automated check.** axe DevTools, Lighthouse, or platform equivalent. (Catches the 30–40% it catches; everything else needs human review.)
- **Color-vision simulator.** Chrome DevTools rendering tab; macOS Color Filters; or a dedicated tool.
- **At a low-vision zoom level.** 200% or 400%, depending on policy.

### Step 2 — Walk the surface

Run the surface through POUR in sequence. For each principle, the audit produces a section of findings.

**Perceivable pass.**

- Color contrast: every text and meaningful UI element at AA or above (4.5:1 body, 3:1 large text / non-text). Test computed colors, not token names.
- Color-vision: nothing communicated by color alone (status badges, link distinction, form-error indicators).
- Screen-reader semantics: heading hierarchy traversable; landmarks present (`main`, `nav`, `header`, `footer`); images either alt-described or marked decorative; icon-only buttons have accessible names.
- Captions / transcripts: media has captions; audio-only has transcripts.
- Text alternatives: SVG icons either `aria-hidden` (decorative) or labelled (functional).

**Operable pass.**

- Keyboard reach: every interactive element is reachable. No mouse-only affordances.
- Focus visible: focus ring meets ≥3:1 contrast against background; not removed by CSS.
- Focus order: matches visual order; no surprising jumps; modals trap focus correctly and return to invocation point on close.
- Focus management on dynamic content: when a route changes or a modal opens, focus moves explicitly; when a route closes, focus returns to a sensible anchor.
- Target sizes: ≥24×24 CSS px (WCAG 2.2 AA); larger (44×44) for touch-primary surfaces (iOS HIG / Material).
- Motion: animations respect `prefers-reduced-motion`; no parallax / strobing in violation of WCAG 2.3.1 (three flashes / threshold).
- Time-outs: any time-out has warning + extend option; no timeouts on input forms without rescue.

**Understandable pass.**

- Language: `lang` attribute set; mixed-language passages marked.
- Form labels: every input has a programmatically-associated label; placeholders are not the only label.
- Error messages: explain the cause, suggest a fix, are programmatically associated with the field.
- Consistent navigation: same nav element appears in same place across pages.
- Predictable interactions: change of context doesn't happen on focus; only on activation.

**Robust pass.**

- Semantic HTML / native components: `button`, `a`, `nav`, `main`, `h1–h6` used before reaching for `div role="..."`.
- ARIA used only when no semantic alternative exists.
- States communicated: aria-expanded, aria-selected, aria-current, aria-busy used as appropriate; live regions for important async updates.
- Tested across at least one screen-reader the surface's users are likely to use.

### Step 3 — Inclusive-design extension pass

Beyond WCAG, walk the surface through Holmes's permanent / temporary / situational lens for the highest-risk constraints:

- **One-handed use.** Can the surface be operated by a user holding a baby, a coffee, or with a broken wrist?
- **Low-bandwidth / offline.** Does the surface degrade gracefully, or hang?
- **Bright sun / glare.** Does contrast hold when ambient light is high? (Use a glare-simulator overlay or a real outdoor test.)
- **Cognitively loaded user.** Can someone interrupted halfway through complete the task on return? Are key actions undo-able?
- **Non-native language reader.** Is the copy at a reading level appropriate to the audience? (Hemingway / Flesch-Kincaid heuristics where relevant.)
- **Older device.** Does the surface work on a 4-year-old mid-range Android? (Performance is an accessibility concern.)

### Step 4 — Draft the audit using the template

```markdown
# Accessibility audit — <Surface name>

- **Auditor:** <name>
- **Surface:** <flow / screen / component>
- **Scope:** <what is in scope; what is out>
- **Tools used:** <screen-readers, browsers, automated tools, simulator settings>
- **Conformance target:** WCAG 2.2 AA + inclusive-design extensions
- **Status:** Draft | In review | Approved | Re-audit needed
- **Date:** <YYYY-MM-DD>

## Summary

<3-5 sentences: highest-severity findings; overall posture; specific
conditions under which the surface is or is not currently usable.>

## Blockers

| # | Surface | Finding | Tool / repro | Remediation | Owner |
|---|---------|---------|--------------|-------------|-------|

## High-severity findings

(Same table shape.)

## Medium-severity findings

(Same table shape.)

## Low-severity findings

(Same table shape.)

## Inclusive-design extension findings

<Findings from the permanent / temporary / situational pass that don't
map cleanly to a WCAG criterion but materially affect the audience.>

## Passing notes

<What the audit confirmed works. Brief; the audit is for findings, but
acknowledging the wins keeps trust.>

## Out of scope

<What this audit deliberately did not cover, and why.>

## Re-audit conditions

<When should this surface be re-audited? On every diff to it? Annually?
After a specific change is made?>

## References

<Linked WCAG criteria, axe / Lighthouse reports, screen-reader recording
links.>
```

### Step 5 — Walk findings with engineering and design

Each finding has a remediation; remediations have an owner. The audit is shared with engineering and PM. Reviewers can argue with specific findings (severity, remediation choice) — they cannot argue with reproductions.

Findings that engineering disputes get logged with the dispute and a re-audit plan ("we believe focus return is correct; user testing scheduled 2025-11-18").

### Step 6 — Re-audit after remediation

The audit is not done when remediations land — it's done when a re-audit confirms the findings are closed. Re-audits are cheaper than full audits; budget for them.

## Examples

### Example 1 — A useful finding (good)

```markdown
| # | Surface | Finding | Tool / repro | Remediation | Owner | Severity |
|---|---------|---------|--------------|-------------|-------|----------|
| 12 | Checkout step 2, postcode field | After entering a postcode and pressing Tab, focus jumps to the "Place order" button two sections below, skipping the shipping-method radio group entirely. Affects all keyboard users; affects all screen-reader users. | NVDA 2024.1 / Firefox 121; VoiceOver / Safari 17 — reproduced both. The skip is caused by `tabindex="10"` on `button#submit-order` overriding source order. | Remove `tabindex="10"`. Verify focus passes through `fieldset#shipping-methods` between postcode and submit. | Engineering / payments-checkout team | Blocker |
```

The reviewer can act on this. The reproduction is unambiguous; the remediation is specific; the severity is defensible (a user cannot reach a required field).

### Example 2 — Inclusive-design finding (good)

```markdown
## Inclusive-design extension findings

| # | Constraint | Finding | Remediation |
|---|------------|---------|-------------|
| 1 | One-handed (situational: holding a baby; permanent: motor impairment) | The "delete" affordance on the cart-line is a 22×22pt icon button at the right edge of the card on mobile, requiring a thumb-reach across the device. | Increase target to 44×44pt; alternatively replace with swipe-to-delete (with visible affordance) on touch surfaces. |
| 2 | Bright sun (situational) | The "Saved" success toast uses gray-400 background with gray-600 text; at outdoor brightness levels the toast is invisible. (Tested with glare-simulator overlay at 80% intensity.) | Increase toast contrast to ≥4.5:1 in the default theme; add platform-respect "auto-bright" variant. |
| 3 | Sleep-deprived (temporary, common for parent persona which is 40% of cart users per analytics) | The cart-clear action has no confirmation — a tired tap on a sticky finger irrevocably clears a 30-item cart. | Add a confirmation dialog; or undo-toast pattern (preferable, less friction for the rest). |
```

These findings often surface real impact even where the surface is fully WCAG-conformant. They are the audit's distinctive value over an automated check.

### Example 3 — Failure mode (bad)

```markdown
# Accessibility audit
- Run axe — 0 errors. ✓
- Looks accessible.
- Recommend: ship.
```

Failures: no scope; no tools beyond axe (which catches a fraction of real issues); no human walk-through; no inclusive-design pass; "looks accessible" is not a finding; no severity; no remediation; no re-audit.

## Common Pitfalls

### Pitfall 1 — Automated tools only

**Symptom:** Audit consists of running axe / Lighthouse and reporting their output.

**Consequence:** Surface passes the audit and fails real screen-reader users. Automated tools catch ~30-40% of WCAG issues; the rest (focus order, label clarity, alternative-text quality, dynamic-content management, motion) require human review.

**Fix:** Automated tools are step zero. The audit's value is in the human walk-through that follows.

### Pitfall 2 — One screen-reader only

**Symptom:** "Tested with VoiceOver." Nothing else.

**Consequence:** Real users overlap multiple screen-readers (NVDA on Windows is the most-used desktop SR; TalkBack is used by Android users; JAWS in enterprise). Surface-screen-reader interactions vary; one SR's success is not portable.

**Fix:** At least two SRs across two OS/browser combos. For mobile-first products, mobile SR is non-negotiable.

### Pitfall 3 — Permanent-only

**Symptom:** Audit considers blind / motor-impaired / deaf users. Ignores temporary and situational.

**Consequence:** Misses the larger audience — most users encounter temporary or situational impairments; many of the design improvements would have been free wins.

**Fix:** Inclusive-design extension pass is part of the audit, not an optional add-on.

### Pitfall 4 — Findings without reproductions

**Symptom:** "Focus management is poor." "Color contrast needs work."

**Consequence:** Engineering doesn't know what to fix. The audit gets bounced back; trust erodes; "the a11y audit is vague" becomes the team's view.

**Fix:** Every finding cites the specific surface, the specific tool, the specific behaviour. A finding without a reproduction is not yet an audit finding — it is a hunch.

### Pitfall 5 — Severity inflation or deflation

**Symptom:** Every finding is "high" (audit reads as alarmism); or every blocker is downgraded to "medium" (audit reads as toothless).

**Consequence:** Engineering ignores the gradient. The next audit's blockers are treated as the previous audit's mediums.

**Fix:** Severity by impact, not by feeling. Blocker = user cannot complete the goal. Be willing to defend each rating.

### Pitfall 6 — No remediation

**Symptom:** Findings list problems but not solutions.

**Consequence:** Engineering improvises remediations; the design intent is lost; some "fixes" introduce new accessibility regressions.

**Fix:** Every finding has at least one suggested remediation. Multiple options when there is genuine choice; recommend one when there isn't.

### Pitfall 7 — Compliance language without compliance practice

**Symptom:** Surface is marketed as "WCAG 2.1 AA compliant" without recent audit evidence.

**Consequence:** Legal exposure (a real regulatory risk in many jurisdictions); reputational exposure (a user with assistive tech encounters the surface and writes publicly about the gap).

**Fix:** If "compliance" is claimed, it is supported by a current audit with reproductions and a re-audit schedule. Otherwise, don't claim it.

### Pitfall 8 — One-time audit, never repeated

**Symptom:** Surface was audited at launch; never re-audited despite quarterly redesigns.

**Consequence:** Accessibility regresses silently as the surface changes. The launch audit becomes a fiction.

**Fix:** Re-audit cadence stated in the audit. Triggered by significant change OR scheduled annually for high-traffic surfaces.

## References

- **W3C** — [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/); the canonical success-criteria list. AA is the audit floor.
- **Kat Holmes** — *Mismatch: How Inclusion Shapes Design* (2018); the permanent / temporary / situational frame. See `roles/designer/sources.md`.
- **Microsoft Inclusive Design Toolkit** — manuals and activities for designing across constraints; [microsoft.com/design/inclusive](https://www.microsoft.com/design/inclusive/).
- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); accessibility findings often map to mismatched mental models, not just sensory channels.
- **Mike Monteiro** — *Ruined by Design* (2019); the ethical-stakes argument that accessibility is the designer's responsibility, not the legal team's.
- **Apple Human Interface Guidelines** and **Material Design Accessibility Guidelines** — platform-specific extensions of WCAG that the audit must respect on respective platforms.
- **Heydon Pickering** — *Inclusive Components* (2018); pattern library for accessible component design.
- **Related Hornero skills:**
  - [`state-audit`](../state-audit/SKILL.md) — many edge cases are accessibility cases; the inventories overlap deliberately.
  - [`heuristic-review`](../heuristic-review/SKILL.md) — Nielsen-10 review intersects with WCAG at heuristics 1, 3, 7, 9; the audits complement.
  - [`design-review`](../design-review/SKILL.md) — the workflow that runs this audit as one of its passes.
  - `roles/tester/skills/test-plan/SKILL.md` — accessibility findings feed the test plan's Operations and Platform HTSM rows.
  - `roles/security-expert/` — accessibility and security overlap on consent, disclosure, and authentication-bypass surfaces.
