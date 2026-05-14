# Kat Holmes — distilled

> *Mismatch: How Inclusion Shapes Design* (2018). MIT Press. The book that reframes accessibility as a design quality problem, not a compliance checklist.

## Why it matters for AI-coding

AI design tools default to able-bodied, English-speaking, modal interaction. The training distribution for design decisions skews heavily toward the imagined "average user" — sighted, using a mouse or touch on a modern device, in a quiet environment, reading in a Latin-script language. Holmes's *Mismatch* reframes what this means: it is not that the design is "not yet localised" or "not yet accessible." It is that the design has a specific set of exclusions built into it, and those exclusions compound. The methodology treats Holmes as the framing for any accessibility claim — not "does this surface pass WCAG?" but "who is this surface currently designed for, and who does it currently exclude?"

This matters for AI-generated UI specifically because AI agents will produce WCAG-compliant surfaces (automated tools will pass, contrast ratios will be adequate) that still systematically exclude users who fall outside the modal case. Holmes gives the reviewer the frame to name that exclusion.

## Key concepts the role pulls from

- **Solve for one, extend to many.** Holmes's central insight: designing for a specific constrained use case produces solutions that extend to a much wider audience. The curb cut (designed for wheelchair users; used by cyclists, delivery workers, parents with strollers) is the canonical example. In software: designing for keyboard-only navigation (for motor-impaired users) produces a better keyboard experience for all power users. The principle reframes inclusion as a design *opportunity*, not a compliance *obligation*.
- **The exclusion spectrum: permanent, temporary, situational.** Holmes and the Microsoft Inclusive Design Toolkit identify three types of constraints. Permanent (someone who is blind). Temporary (someone with a broken wrist after surgery). Situational (someone holding a baby, driving, in bright sunlight). Each produces the same interaction constraint: one-handed touch. Designing for the permanent case extends, as a free benefit, to the temporary and situational cases. This is the frame the `accessibility-audit` skill uses for its inclusive-design extension pass.
- **Mismatch as the design problem.** Holmes redefines disability: it is not a property of a person but a *mismatch* between the person's needs and the design's assumptions. "The disability is the design" is the sharpest formulation. This shifts the reviewer's question from "does this user have a disability?" to "does this design create a mismatch?" A different, more productive question.
- **Who is at the table.** Holmes's argument that inclusion must be upstream of the design decision — not a post-hoc audit of an already-designed surface. The people whose exclusion is being designed must be present in the design process, not just consulted in a review. The methodology uses this to distinguish the accessibility audit (a downstream corrective) from inclusive-design practice (an upstream process argument that the audit can name but cannot substitute for).
- **The persona spectrum.** Holmes's extension of Cooper's persona concept: rather than a single representative user, a spectrum of users from most to least modal — and design decisions evaluated at both ends of the spectrum, not just at the centre.

## What to actually read (1-hour budget)

- **Chapters 1-3** — the mismatch reframe; the exclusion spectrum; the curb-cut argument. ~70 pages. The conceptual core.
- **Chapter 5** — "Designing for One to Extend to Many" — the design application of the solve-for-one principle. ~30 pages. The most operationally useful chapter.
- The **Microsoft Inclusive Design Toolkit** (free PDF, microsoft.com/design/inclusive) — the practical companion; the activity cards are the most useful format for applying Holmes in a team context.

## What to skip

- Holmes's historical survey of disability policy and legislation (chapter 2, much of chapter 4) — essential context but not load-bearing for the methodology's design-review and audit skills. Read for understanding; skip when time-constrained.

## How this anchors role skills

- [`accessibility-audit`](../../roles/designer/skills/accessibility-audit/SKILL.md) — load-bearing. The skill's inclusive-design extension pass is Holmes's permanent/temporary/situational lens operationalised into a specific audit step. Holmes is explicitly named in the skill's frontmatter and References.
- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the accessibility step draws on Holmes for its framing of "beyond WCAG": the question is not just "does it pass?" but "who does it exclude?"
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — Holmes's situational constraints (slow network, one-handed, bright sun) are listed in the state audit's edge-state checklist, traceable to the Microsoft Inclusive Design Toolkit.

## Cross-role connection

Holmes and the security-expert's threat-model skill share a structural move: both expand the scope of "who is the user" beyond the modal, assumed case. Threat modelling asks "who might attack this system, and are we only defending against the attack we imagined?" Inclusive design asks "who might use this system, and are we only designing for the user we imagined?" Both disciplines surface a class of real users — malicious actors; constrained users — whom the design team systematically discounts. The security-expert's habit of enumerating threat actors by motivation and capability is methodologically parallel to Holmes's persona spectrum from most to least modal. Running both passes together on a new surface catches the broadest range of unexamined assumptions.
