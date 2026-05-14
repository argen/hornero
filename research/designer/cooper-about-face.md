# Alan Cooper — distilled

> *About Face: The Essentials of Interaction Design* (4th ed., 2014, with Reimann, Cronin, Noessel); *The Inmates Are Running the Asylum* (1999). The books that gave interaction design goal-directed design and made the case that programmers should not be in charge of UX decisions.

## Why it matters for AI-coding

AI-generated personas are vague demographic averages: "a 35-year-old professional who wants to be more productive." Cooper's goal-directed design demands specificity about *what the user is trying to achieve*, not who they statistically are. The methodology cites Cooper whenever a design discussion invokes a persona — the test is not "does this persona have a job title and an age?" but "does this persona have a *goal* that creates a design constraint?" In AI-assisted product work, the danger is that generated personas satisfy the form without the function: they feel concrete enough to prevent challenge, but they don't force any design decisions because the goal is underspecified. Cooper's framework is the corrective.

## Key concepts the role pulls from

- **Goal-directed design.** Users do not use software for its features; they use it to achieve goals. Design decisions derive from understanding what goal the user is pursuing at this moment, in this context. A feature that makes sense from the programmer's mental model may be actively wrong from the user's goal model. The methodology uses this to evaluate any design rationale: "what user goal does this decision serve?"
- **The three types of user goals.** Cooper distinguishes *experience goals* (how the user wants to feel — "I don't want to feel stupid"), *end goals* (what the user wants to accomplish — "buy a gift for my sister"), and *life goals* (who the user wants to be — "a competent professional"). Most design work only addresses end goals; experience and life goals constrain the *how*. These distinctions surface in the methodology's critique of AI-generated UI that technically accomplishes the task but feels dismissive or condescending.
- **Personas as design constraints, not marketing segments.** A Cooper persona is a specific fictional individual with a specific goal, a specific mental model, and specific context — not a demographic bucket. The specificity is the point: it forces design decisions. "Elena uses a screen reader on mobile during her commute with one hand" creates constraints; "accessibility-conscious users" does not.
- **The perpetual intermediate.** Cooper's observation that most software is designed for beginners (simple onboarding) or experts (power features), but the largest audience is the *perpetual intermediate*: the person who has used the software long enough to leave the tutorial but not long enough to have memorised all the shortcuts. Designing for the perpetual intermediate is the practical application of goal-directed thinking.
- **Excise tasks.** Tasks the user must perform to accomplish their goal but don't themselves move the goal forward. Cooper's framework is to identify and minimise excise: data entry that exists for the system's convenience, confirmations the user never reads, navigation that exists because the information architecture is tangled. The methodology's preference for progressive disclosure and fewer steps-before-value descends from this.

## What to actually read (1-hour budget)

- *About Face* **Part II, chapters 5-7** — goal-directed design methodology; the three goal types; personas and scenarios. ~90 pages. The conceptual core.
- *About Face* **Chapter 3** — "Goals, not features" — the shortest statement of the central argument. ~20 pages. Good to read first.
- *Inmates* **chapters 1-3** — the "dancing bearware" argument that programmers are not representative users and should not make UX decisions alone. ~50 pages. More polemical than *About Face* but the argument is sharper.

## What to skip

- *About Face* Part IV (controls and widgets reference) — comprehensive but dated; specific widget recommendations have been superseded by platform design systems. Skip unless you need a reference for a specific control pattern.
- The later chapters of *Inmates* — the historical case studies are vivid but the argument has been made by chapter 3.

## How this anchors role skills

- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the visual-coherence and live-exercise steps carry an implicit Cooper question: "what is the user trying to accomplish here, and does this design serve that goal?" The skill's anti-pattern checklist is, in part, an excise-task checklist.
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Cooper's goal-directed lens is the framing that makes heuristic findings *ranked* rather than equivalent: a heuristic violation that blocks a goal is categorically worse than one that creates friction around an excise task.
- [`accessibility-audit`](../../roles/designer/skills/accessibility-audit/SKILL.md) — Holmes's permanent/temporary/situational framing is a direct extension of Cooper's persona specificity: both resist the vague representative-user assumption.

## Cross-role connection

Cooper's goal-directed personas are the designer-role answer to the product-manager's jobs-to-be-done framing. Both frameworks ask "what is the user actually trying to accomplish?" — JTBD at the level of market motivation and Cooper at the level of interaction design. Where JTBD asks "what job does the customer hire this product for?", a Cooper persona asks "what goal is Elena pursuing *in this moment* on *this screen*?" The frames are complementary: JTBD scopes the product vision; Cooper's goal-directed design translates that vision into specific interaction choices. Conflicts between them — a JTBD conclusion that points one way and a persona goal that points another — are the most valuable design conversations to surface.
