# Don Norman — distilled

> *The Design of Everyday Things* (1988, revised edition 2013), with sidelong reference to *Emotional Design* (2004) and *Living with Complexity* (2010). The book that gave HCI its working vocabulary.

## Why it matters for AI-coding

AI-generated interfaces default to recognisable patterns *without understanding why those patterns work*. They produce screens that look right at a glance and break under any real use. Norman's framing gives a reviewer the vocabulary to say what's wrong beyond "it looks weird" — specifically, *which* fundamental design principle is being violated, and what mental model the screen is asking the user to adopt.

This matters most for AI-generated UI in two situations: (a) novel interactions the model has weak prior on (multi-step forms, error recovery, async operations) and (b) interfaces that look like familiar patterns but encode a different conceptual model underneath. Norman's "the user's mental model is built from what the system shows them" stance is the antidote to "ship it, the screen is technically there."

## Key concepts the role pulls from

- **Affordances vs signifiers.** An affordance is what an object can do (a door affords pushing). A signifier is what the design shows the user about what it can do (a flat plate signals push; a handle signals pull). AI-generated UIs frequently get this inverted — handles on push doors. Powers the entire heuristic-review's first pass.
- **Mappings.** The relationship between controls and the thing being controlled. Natural mappings (volume slider up = louder) are learnable; arbitrary mappings (keyboard shortcut for delete = Ctrl+Y) are not. Powers state-audit's "interactions table" discipline.
- **Feedback.** Every action needs a visible system response within a perceivable window (~100ms for direct manipulation, ~1s for command). Loading states, optimistic updates, success confirmations — all of state-audit's empty/loading/error/success/partial inventory descends from Norman's feedback principle.
- **Constraints (physical, logical, semantic, cultural).** What the design makes *impossible* — a USB connector that only fits one way, a date picker that grays out unavailable dates. AI-generated UIs over-rely on validation-after-the-fact when constraints would prevent the error entirely.
- **Conceptual model.** The mental model the user constructs of how the system works, built from the system image (everything the design shows them). When the user's model and the designer's model diverge, every interaction misfires. Powers the methodology's preference for "first ask what mental model this screen builds" before any heuristic critique.
- **Slips vs mistakes.** A slip is a correct intention executed wrongly (typo). A mistake is a wrong intention. Different remediation: slips need undo; mistakes need clearer signifiers and constraints. Powers the error-state pass in `state-audit`.

## What to actually read (1-hour budget)

- DOET **chapters 1-3** (the psychopathology of everyday things; the psychology of everyday action; knowledge in the head and in the world). ~120 pages of foundational vocabulary. Read these slowly; the rest of the book is application.
- DOET **chapter 5** (human error? no, bad design). ~30 pages. The slip/mistake taxonomy and the error-prevention framing.
- DOET **chapter 6** (design thinking). ~30 pages. The double-diamond and Norman's stance on "design thinking" as practiced.

## What to skip

- The final chapter speculating on the future of design — dated industrial-product-design speculation; not load-bearing.
- *Emotional Design* is genuinely interesting but tangential to the methodology's working concerns. Read for pleasure, not for citation.
- The 2013 revision's added material on activity-centered vs human-centered design — useful framing but rarely surfaces in skill critique; the 1988 core is what travels.

## How this anchors role skills

- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Nielsen's 10 heuristics are downstream applications of Norman's principles. The skill's "broad pass first" approach mirrors Norman's "understand the mental model before nitpicking."
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — the empty/loading/error/success/partial inventory is Norman's feedback principle operationalised into a checklist. The interactions table is Norman's mappings concept.
- [`accessibility-audit`](../../roles/designer/skills/accessibility-audit/SKILL.md) — Norman appears explicitly in the References as a corrective to "accessibility = WCAG compliance"; many accessibility findings are actually mismatched mental models, not sensory-channel issues.
- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the workflow composes Norman-grounded passes (state, heuristic, accessibility); when the role flags a screen as "the mental model doesn't match the system," the citation is Norman.

## Cross-role connection

Norman's slips/mistakes taxonomy maps onto tester's error-handling test coverage (slips → input-validation tests; mistakes → flow-correction tests). Norman's feedback principle maps onto data-scientist's instrumentation discipline — "every action emits a perceivable signal" applies as much to analytics events as to UI affordances.
