---
name: component-proposal
description: Use when a designer needs to propose a new design-system component or modify an existing one — establishing where it sits in the atomic hierarchy, what gap it fills, what variants and states it needs, and whether it already exists under a different name.
intent: |
  Produces a structured component proposal that catches the most common
  design-system failure — shipping a component that duplicates an existing
  one with slight cosmetic differences — before it happens. Anchors the
  proposal in Frost's atomic taxonomy, ties every variant to an affordance
  rationale (Norman), ensures every component decision is evaluated for
  its inclusion surface (Holmes), and applies Wathan/Schoger's visual-polish
  discipline to the type/spacing/color rhythm of the spec.
type: component
theme: design-systems
best_for:
  - A new UI pattern that has appeared on multiple screens and needs to be extracted into a shared component
  - A request to "add a new card type" or "new button variant" that may duplicate something in the existing system
  - A component that will be used across multiple surfaces and whose API needs to be agreed before implementation
  - A design change that requires new props, variants, or states on an existing component
scenarios:
  - "Proposing a new 'status badge' component after the same pattern appears on four screens"
  - "Evaluating whether a proposed 'pill tag' is different enough from the existing 'chip' to justify a new component"
  - "Speccing a new 'data table' organism before engineering builds it"
  - "Adding a 'danger' variant to an existing button component"
estimated_time: 45-90 minutes (new component proposal); 15-30 minutes (variant addition to existing component)
---

# Component proposal

> v0 draft. Grounded in Brad Frost's *Atomic Design* (2016) on taxonomy and design-system thinking; Adam Wathan & Steve Schoger's *Refactoring UI* (2018) on the visual-polish discipline applied to component design; Kat Holmes's *Mismatch: How Inclusion Shapes Design* (2018) on the inclusion surface of every component decision; Don Norman's *The Design of Everyday Things* on affordances and signifiers as the conceptual layer component design implements.

## Purpose

Before a new component is built, answer three questions rigorously:

1. **Do we already have this?** The most common design-system failure is shipping a component that duplicates an existing one with slight cosmetic differences, creating two sources of truth, two maintenance burdens, and eventual visual inconsistency as the two drift apart.
2. **Where does this component sit in the atomic hierarchy?** A component that belongs at the atom level but is proposed at the organism level will be too constrained for reuse; one that belongs at the organism level but proposed at the atom level will be too simple to compose into what the design actually needs.
3. **What is the full surface of this component?** Props, variants, states, accessibility, inclusion, responsive behaviour — all resolved before engineering begins. Changes after implementation are an order of magnitude more expensive.

The proposal is the agreement surface. Design and engineering agree on what is being built before building it. The proposal is also the refactoring trigger: when the same pattern appears three times without a proposal, the proposal is overdue.

**Cross-skill note:** When a component proposal requires API changes to existing components — renaming props, changing slot structure, removing variants — pair with `roles/software-engineer/skills/refactor-plan/SKILL.md` to sequence the change safely. When the proposal touches interaction or accessibility beyond the scope of this skill's a11y section, pair with [`accessibility-audit`](../accessibility-audit/SKILL.md) for the per-component pass.

## Key Concepts

### Frost's atomic taxonomy

Brad Frost (*Atomic Design*) provides the taxonomy this skill uses to classify components:

- **Atoms** — the smallest indivisible UI elements. Button, input, label, icon, badge, avatar. They have no meaningful sub-components. They should be context-agnostic: the `Button` atom doesn't know it's in a form or a dialog.
- **Molecules** — groups of atoms that function together as a unit. Form field (label + input + error text). Search bar (input + button). Card header (avatar + name + timestamp). The molecule has a single primary function and is still relatively reusable.
- **Organisms** — complex, relatively standalone UI sections composed of atoms and molecules. A navigation bar. A product card grid. A multi-step form. Organisms are less reusable than molecules — they encode more context.
- **Templates** — page-level layouts. Mostly engineering territory; mentioned for completeness.
- **Pages** — specific instances. Out of scope for component proposals.

The key question at taxonomy-placement time: *could this component be used in a significantly different context without modification?* High yes → atom or molecule. Low yes → organism. If the answer is "no, it's specific to this feature" → it may not belong in the design system at all; it may be a one-off composition.

### Norman's affordances and signifiers at the component layer

Don Norman (*The Design of Everyday Things*): affordances are the actual possible actions on an object; signifiers are the perceptible cues that communicate those affordances.

At the component layer, every design decision about shape, color, size, and interaction is simultaneously an affordance and signifier decision. A component proposal that specifies only visual appearance — without specifying what actions the component affords and how those actions are signified — is incomplete. The button's `variant: danger` is a signifier; the signifier must communicate the affordance accurately (this action has irreversible consequences) and consistently (every danger button in the system signals the same gravity).

Norman's framework applied to component proposals: for each variant and state, ask — what does the user believe this component will do? Does the design communicate that belief accurately?

### Wathan/Schoger's visual-polish discipline

Adam Wathan & Steve Schoger (*Refactoring UI*): the visual rhythm of a component — type scale, spacing, color — is not cosmetic. It carries the component's hierarchy, emphasis, and legibility. Specific disciplines:

- **Type** — font size, weight, line-height, tracking, color, and their relationships to adjacent elements. A component's label should sit in the type scale, not at an arbitrary size.
- **Spacing** — padding and margins in multiples of the spacing unit. Components that use off-grid spacing will never compose cleanly with other components.
- **Color** — use semantic color tokens (primary, danger, muted), not raw values. A component that hardcodes `#E53E3E` instead of `color.danger` will diverge from the system on the next rebrand.
- **Shadow and elevation** — communicate depth and layer. Components at the same elevation level share shadow tokens; don't invent a new shadow for one component.

### Holmes on the inclusion surface

Kat Holmes (*Mismatch*): every component decision shapes the inclusion surface of every surface that uses the component. A button with an inadequate touch target isn't just a usability problem on one screen — it's a systemic exclusion once the button is in the design system. The component proposal is the highest-leverage point to catch inclusion failures: fix it here, and it is fixed everywhere the component is used.

Inclusion questions for every component proposal:
- What is the minimum touch target? (44×44pt for touch-primary; 24×24 CSS px WCAG minimum.)
- Does every state communicate through more than color alone?
- Does the component have a complete accessible name in every variant?
- Does the component work at 200% zoom?
- Is there a `prefers-reduced-motion` safe variant for any animated states?

### "Do we already have this?" — the duplicate check

The most common failure mode in design-system growth: the same visual pattern appears under two different component names because two designers solved the same problem independently, or because the existing component wasn't found.

Perform the duplicate check before writing any proposal text:

1. Search the design-system documentation, Figma library, and codebase for the visual pattern (not the proposed name — names vary; visual shapes don't).
2. Check component names that are near-synonyms: `tag` / `chip` / `badge` / `pill` / `label` are frequent near-duplicates.
3. Check if an existing component could be extended with a new variant rather than a new component created.

If a duplicate or near-duplicate exists: the correct output may be "extend the existing component" or "consolidate these two components" rather than "create a new component." Both are valid proposals and should use this template.

## Application

### Step 1 — Duplicate check (always first)

Before anything else, search for the pattern:

1. **Design library search.** Open the design system Figma library (or equivalent). Search for the visual pattern — button, card, badge, tag, whatever shape you're proposing. Expand every result.
2. **Name-synonym search.** List the five nearest synonyms for your proposed name. Search each. Note every result, even if it looks different at first glance.
3. **Codebase check.** Search the component directory in the codebase. Look for the pattern in file names and component names, not just the one name you have in mind.
4. **Document the result.** In the proposal's "existing component analysis" section: either confirm no duplicate exists, or name the duplicate and explain why the new component is still needed (or pivot to an extension proposal).

If you find a near-duplicate and propose to extend it rather than create a new component, the rest of this template still applies — with the "existing component" fields filled and the "modification" fields making the delta explicit.

### Step 2 — Atomic placement

Given the component you're proposing, classify it:

- **Atom?** It has no meaningful sub-components. It is context-agnostic. Could be used anywhere in the system.
- **Molecule?** It combines two to four atoms with a single primary function. It is reusable but more context-specific than an atom.
- **Organism?** It composes atoms and molecules into a complex, somewhat context-specific section. It may encode business logic in its structure.

The classification has implementation consequences. An atom is typically a primitive with no children. A molecule typically accepts slot/children composition. An organism typically has named slots or a complex prop API. Get this right in the proposal; it is expensive to change after implementation.

### Step 3 — Draft the proposal using the template

```markdown
# Component proposal — <ComponentName>

- **Proposer:** <name>
- **Date:** <YYYY-MM-DD>
- **Status:** Draft | In review | Approved | Superseded by <ComponentName>
- **Atomic level:** Atom | Molecule | Organism
- **Target design-system version:** <version or milestone>

---

## Problem statement

<What gap does this component fill? Name the specific pattern that appears
on multiple surfaces without a shared component. Include screenshots or
Figma links to the three or more instances that justify extraction.

Or: what modification does this component require? Name the existing
component and what is changing, and why.>

---

## Existing component analysis

<Result of the duplicate check:>
- **Search terms used:** <list all synonyms searched>
- **Existing components reviewed:** <list all near-candidates found>
- **Conclusion:** <"No duplicate found. Proceeding with new component." OR
  "Near-duplicate: <Name>. Extending it because… / Creating new because…" OR
  "Existing <Name> covers this need with variant addition — see below.">

---

## Component definition

**Name:** `<ComponentName>` (or `<ComponentName.Subcomponent>` for compound)

**One-line description:** <What does this component do, in one sentence?>

**Atomic level and rationale:** <Atom / Molecule / Organism, and why.>

---

## Props / API

| Prop | Type | Default | Required | Description |
|---|---|---|---|---|
| `variant` | `'default' \| 'danger' \| 'muted'` | `'default'` | No | Visual variant, maps to semantic color token |
| `size` | `'sm' \| 'md' \| 'lg'` | `'md'` | No | Size variant, maps to spacing scale |
| `disabled` | `boolean` | `false` | No | Disabled state |
| `label` | `string` | — | Yes | Accessible name (visible or `aria-label`) |
| <…> | <…> | <…> | <…> | <…> |

<Rule: no prop should use raw values (colors, sizes, pixel numbers). All
props map to design system tokens. Raw values in props are a future
inconsistency guarantee.>

---

## Variants

For each variant, describe:
- **Visual appearance** — token references, not raw values.
- **When to use** — the specific context this variant is correct for.
- **Affordance and signifier** (Norman) — what does this variant communicate? Is the signifier unambiguous?

### Variant: default
<Description>

### Variant: danger
<Description — should be used only for irreversible or destructive actions.>

<…>

---

## States

For each interactive state:

| State | Visual change | Accessibility note |
|---|---|---|
| Default | <description; token references> | — |
| Hover | <description> | `hover` is not available on touch; the component must not rely on hover for any information. |
| Focus | Focus ring ≥3:1 contrast against background; `outline` visible, not removed. | Keyboard and assistive-tech users depend on this. |
| Active / Pressed | <description> | |
| Disabled | Reduced opacity (not via `color: gray` alone) + `cursor: not-allowed` | `aria-disabled="true"`, not `disabled` attribute, when the element must remain focusable. |
| Loading (if applicable) | <description> | `aria-busy="true"`; announce completion to screen readers via live region. |
| Error (if applicable) | <description> | `aria-invalid="true"` + `aria-describedby` pointing to error text. |

---

## Accessibility specification

<Required section. Every component proposal must complete this.>

- **Accessible name:** How does the component get its accessible name in each variant? (`aria-label`, `aria-labelledby`, visible text, slot content?)
- **Role:** What ARIA role does this component have? (Use native HTML semantics before `role="..."`)
- **Keyboard interaction:** Tab to reach; Enter or Space to activate (for buttons); arrow keys for selection (for groups). List all key interactions.
- **Focus management:** Where does focus go after activation? After dismissal?
- **Color-only communication:** Does any state communicate through color alone? If yes, add a secondary signal (icon, text, pattern).
- **Touch target:** ≥44×44pt for touch-primary; ≥24×24 CSS px minimum (WCAG 2.2).
- **Animation:** Does the component animate? If yes, is there a `prefers-reduced-motion` safe fallback?
- **Zoom:** Component must be tested at 200% browser zoom. List any known constraints.

---

## Visual specification

<Token references, not raw values. Use this section to specify:>

- **Typography:** token name, not pixel size.
- **Spacing:** token name from the spacing scale.
- **Color:** semantic token names (e.g., `color.text.default`, `color.bg.danger.subtle`).
- **Border radius:** token name.
- **Elevation / shadow:** token name.
- **Transitions:** duration token + easing token; or `none` if not animated.

<Wathan/Schoger discipline: every value must sit in the design system scale.
Non-scale values are flagged for review.>

---

## Responsive behavior

<How does the component change across breakpoints? If no change: state "no
responsive changes." Don't omit this section — "unchanged" is an explicit
decision, not an oversight.>

---

## Related and conflicting components

| Component | Relationship | Decision |
|---|---|---|
| `<Name>` | Near-duplicate: same visual pattern, different name | Consolidate / Keep separate because… |
| `<Name>` | Composition parent: this component lives inside it | Coordinate API changes |
| `<Name>` | Composition child: this component uses it internally | Pin version dependency |
| `<Name>` | Functional overlap: could be used instead | Use <this one> when X; use <that one> when Y |

---

## Migration / adoption plan

<If this is a new component: which existing ad-hoc implementations does it
replace? List them. Who owns migration?>

<If this is an extension of an existing component: which existing usages
need to be updated? Is the change additive (no migration needed) or breaking
(migration required)?

Breaking changes to existing components require coordination with the
engineer's `refactor-plan` skill.>

---

## Open questions

<Each owned, with a date.>
- <Question. (Owner, YYYY-MM-DD)>
```

### Step 4 — Self-review against five checks

1. **Duplicate-check documented.** The existing-component-analysis section names every synonym searched and states a conclusion. An absent or one-line analysis is incomplete.
2. **Atomic level justified.** The level is argued, not just stated. "Atom because it has no sub-components and is context-agnostic" is a justification. "Atom" is not.
3. **No raw values in props or spec.** Every color, size, and spacing reference is a token name. A proposal with raw hex values will introduce drift from day one.
4. **Accessibility section complete.** Accessible name, role, keyboard interaction, focus management, color-only check, touch target, animation, zoom — all addressed. A blank or "TBD" section is a blocker on approval.
5. **Related-components table filled.** At least three near-candidates considered. A component proposal that claims no relationship to existing components usually hasn't searched carefully enough.

### Step 5 — Review with engineering before approval

The proposal is an agreement surface between design and engineering. Before approval:

- Walk the props/API with the engineer who will implement it. Prop names and types affect downstream usage; negotiating them before implementation is free; after, it requires a deprecation cycle.
- Walk the accessibility specification. Engineers often have more context about platform constraints (how focus management works in the framework, what ARIA patterns are already established) that should refine the spec.
- Confirm token availability. Proposals that reference tokens that don't yet exist in the system need a token proposal first or a note that token creation is in scope.

### Step 6 — Approval and implementation handoff

An approved proposal is the component's build contract. Engineering implements exactly what the proposal specifies. Deviations during implementation are escalated to the proposer, not made unilaterally — the divergence is either a proposal error (update the proposal) or an implementation choice (document the reason in the proposal's decision log).

After the component ships, the proposal is linked from the design system documentation as the record of the design intent.

## Examples

### Example 1 — Well-scoped new atom (abridged)

```markdown
# Component proposal — StatusBadge

- **Atomic level:** Atom
- **Status:** Approved

## Problem statement

The same "status pill" pattern appears in 6 distinct places across the product:
- Order list (figma: /orders-v3, frame "Status pill")
- Dashboard widgets (figma: /dashboard-v2, frame "Status indicator")
- Admin console (React: `components/admin/StatusCell.tsx`)
- (+ 3 more)

Each is implemented independently; four use different colors for "active"; two use different border-radius values. Extracting into a shared component will enforce consistency and reduce the 4-color / 2-radius divergence to 0.

## Existing component analysis

- **Search terms:** badge, chip, tag, pill, label, status, indicator
- **Existing reviewed:** `Chip` (Figma + repo) — Chip handles interactive selection; StatusBadge is purely informational (no click affordance). Different affordances → different components justified.
- **Conclusion:** No duplicate. `Chip` is the nearest neighbor but its interaction model is distinct. Proceeding with new component.

## Props / API

| Prop | Type | Default | Required | Description |
|---|---|---|---|---|
| `status` | `'active' \| 'inactive' \| 'pending' \| 'error'` | — | Yes | Semantic status; maps to color token |
| `label` | `string` | — | Yes | Human-readable status label |
| `size` | `'sm' \| 'md'` | `'md'` | No | Size variant |

## Accessibility specification

- **Accessible name:** The `label` prop is rendered as visible text inside the badge. No aria-label needed.
- **Role:** No interactive role — purely informational. `<span>` with semantic color.
- **Color-only:** Status is communicated by both color AND the label text. Color-only failure: not present.
- **Touch target:** Not interactive — touch target not applicable.
```

The duplicate-check caught `Chip` before the proposal proceeded; the distinction (interactive vs. informational) is documented and defensible.

### Example 2 — Variant addition to existing component

```markdown
# Component proposal — Button / loading variant

- **Atomic level:** Atom (extension of existing Button)
- **Status:** In review

## Problem statement

Three separate implementations of a "button with loading spinner" have
appeared in checkout, onboarding, and the admin form. Each uses a different
approach (spinner placement left vs. right vs. overlay; different disabled
behaviour). Centralising as a `loading` state on the existing Button component.

## Existing component analysis

- **Conclusion:** Extending existing `Button` atom. This is a new state, not a new component.

## States — addition to existing Button

| State | Visual change | Accessibility note |
|---|---|---|
| Loading | Leading spinner (existing `Spinner/sm` atom) + label dimmed 60% + `disabled` behaviour | `aria-busy="true"` on the button; label unchanged (don't swap to "Loading…" — screen readers read the button label + busy state independently). |
```

This correctly routes to an extension of an existing component rather than proposing a new one.

### Example 3 — Failure mode (bad)

```markdown
# New component: FancyCard

A card with rounded corners, a shadow, and a gradient header.

Props: title, subtitle, image, content, cta

Colors: #2D3748, #E2E8F0, linear-gradient(#667EEA, #764BA2)
```

Failures: no duplicate check; no atomic level; no problem statement (what gap does it fill?); raw hex values in props; no accessibility specification; no state inventory; no token references; no related-components analysis; no migration plan. This proposal will produce an inconsistent, inaccessible component that duplicates existing cards with slight variations.

## Common Pitfalls

### Pitfall 1 — Skipped duplicate check

**Symptom:** The proposal jumps straight to the component spec. No existing-component analysis section.

**Consequence:** A near-duplicate ships. The system now has `Badge` and `Tag` that look almost identical, maintained by different people, diverging over time.

**Fix:** Duplicate check is step 1, always. Document the synonyms searched. If you find a near-duplicate, explicitly defend the new-component decision or pivot to an extension.

### Pitfall 2 — Wrong atomic level

**Symptom:** A component with complex internal structure (navigation rail, data table, form section) is proposed as a molecule. Or a button variant is proposed as a new organism.

**Consequence:** Molecule-level API on an organism-level component is too rigid to compose; organism-level API on an atom-level component is too complex for simple use cases.

**Fix:** Apply Frost's classification rigorously. Can this component be used in a significantly different context without modification? High yes → lower in the hierarchy. Low yes → higher.

### Pitfall 3 — Raw values in the spec

**Symptom:** Props or visual specs reference hex colors, pixel sizes, or hardcoded shadow values.

**Consequence:** The component starts life already out of sync with the design system. The next design token update will not automatically propagate.

**Fix:** Every color, size, spacing, shadow, and radius value is a token name. If the token doesn't exist yet, note that token creation is a prerequisite and scope it explicitly.

### Pitfall 4 — Accessibility section absent or deferred

**Symptom:** The accessibility specification is blank, "TBD," or "will follow standard button patterns."

**Consequence:** The implementation inherits whatever the engineer guesses. Focus management, accessible names, and ARIA patterns vary significantly across frameworks; "standard patterns" means different things to different engineers. Holmes: every component decision shapes the inclusion surface of every surface that uses it — get it wrong here, and it's wrong everywhere.

**Fix:** Accessibility specification is a required section. Approve nothing without it. If you need help, pair with the `accessibility-audit` skill for the per-component pass.

### Pitfall 5 — No persona or job-to-be-done reference

**Symptom:** The proposal describes the component's appearance in detail but doesn't name who is using it for what.

**Consequence:** Variant and state decisions drift toward engineering preference or designer aesthetics rather than user need. A "danger" variant that looks exciting rather than alarming is a signifier failure.

**Fix:** Name the primary persona and goal the component serves. Even one line: "StatusBadge serves Maya (domain expert, software novice) whose end goal is to know at a glance which items need her attention." The affordance decisions follow from that statement. See [`persona`](../persona/SKILL.md).

### Pitfall 6 — Proposal as fiction

**Symptom:** The proposal is approved, then engineering implements something different. Nobody updates the proposal.

**Consequence:** The proposal is out of date from day one. Future changes to the component are made without understanding the original design intent. The approved proposal no longer reflects reality.

**Fix:** Engineering deviations during implementation are escalated back to the proposer before merging. The proposal is updated to reflect the actual implementation decision, with the rationale for the deviation. The proposal is the living record.

## References

- **Brad Frost** — *Atomic Design* (2016); the atom/molecule/organism taxonomy. See `roles/designer/sources.md`.
- **Adam Wathan & Steve Schoger** — *Refactoring UI* (2018); type/spacing/color discipline in component design; token discipline. See `roles/designer/sources.md`.
- **Kat Holmes** — *Mismatch: How Inclusion Shapes Design* (2018); every component decision shapes the inclusion surface. See `roles/designer/sources.md`.
- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); affordances and signifiers at the component layer. See `roles/designer/sources.md`.
- **Related Hornero skills:**
  - [`persona`](../persona/SKILL.md) — component proposals should reference the persona whose goals the component serves; variant and affordance decisions follow from goal-directed design.
  - [`accessibility-audit`](../accessibility-audit/SKILL.md) — for a deep per-component accessibility pass when the proposal's a11y section is insufficient.
  - [`state-audit`](../state-audit/SKILL.md) — the component's states are a micro-version of the state audit; the two skills are complementary.
  - `roles/software-engineer/skills/refactor-plan/SKILL.md` — breaking changes to existing components require a refactor plan for safe migration.
  - [`design-review`](../design-review/SKILL.md) — the workflow that evaluates component proposals as part of a pre-launch pass.
