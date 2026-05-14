# Mike Monteiro — distilled

> *Ruined by Design: How Designers Destroyed the World, and What We Can Do to Present It* (2019); *Design Is a Job* (2nd ed., 2019). The argument that design is a political act with material consequences, and that professional responsibility requires the ability and willingness to refuse harmful work.

## Why it matters for AI-coding

AI tools generate work without naming consequences. A design system prompt produces a component; a UI generation prompt produces a screen; an agent produces a feature — none of them flags that the dark pattern you're about to ship will extract money from confused elderly users, or that the notification permission flow is deliberately manipulative, or that the engagement metric you're optimising for will push vulnerable users toward harmful content. Monteiro's argument is that this absence of ethical accountability is not a property of AI tools specifically; it is the failure mode of designers who have accepted that their job is to execute requirements rather than evaluate them. The methodology cites Monteiro whenever a design review includes a check for dark patterns, manipulative defaults, or harmful interactions — the claim that "design is a political act" is the theoretical grounding for making those checks load-bearing rather than optional.

## Key concepts the role pulls from

- **Design is a political act.** Every design decision distributes power and attention — between the product and the user, between the platform and the creator, between the majority case and the marginalised case. Treating design decisions as neutral technical choices obscures this distribution. The methodology uses this framing to make ethics-adjacent design findings (dark patterns, manipulative flows, inaccessible defaults) first-class review findings rather than opinion.
- **The ability to say no.** Monteiro's argument for designer professional responsibility: the ability to refuse to design harmful things is the core professional competence, not a luxury. A designer who cannot refuse work is not a professional; they are a production resource. The methodology cites this as the theoretical basis for a design review that can produce a "Hold" verdict — not just aesthetic concerns but ethical ones.
- **Dark patterns as design decisions.** Dark patterns (forced continuity, roach motels, hidden unsubscribe flows, confirmshaming, misdirection) are not accidents; they are designed. Someone chose that interaction. Monteiro names this to make the designer's responsibility undeniable: you cannot claim you didn't know what you were designing. The `design-review` skill's dark-pattern check is Monteiro operationalised.
- **The client relationship and the design brief.** From *Design Is a Job*: designers serve their clients, but they serve their users more. When client requirements harm users, the designer's obligation runs to the user. This is the practitioner version of Monteiro's political-act argument — it says specifically what the designer does when requirements conflict with user welfare.
- **Codes of professional conduct.** Monteiro argues for explicit designer codes of conduct analogous to medical or legal professional ethics — the idea that the profession as a whole sets a floor for what its members will and will not do. The methodology doesn't enforce a code, but the accessibility-audit and design-review skills' ethics references (to Monteiro) create the frame for naming design decisions as professional choices, not just technical ones.

## What to actually read (1-hour budget)

- *Ruined by Design* — read the whole book. It is short (~200 pages), polemical, and best read in one sitting. The argument is cumulative; skipping sections reduces its effect.
- *Design Is a Job* **chapters 3, 5, 7** — working with clients; presenting work; saying no. ~70 pages. The practical complement to *Ruined by Design*'s political argument.

## What to skip

- *Design Is a Job*'s contractual and business chapters (pricing, invoicing, hiring) — useful for independent practitioners; tangential for the methodology. Read if you freelance.

## How this anchors role skills

- [`accessibility-audit`](../../roles/designer/skills/accessibility-audit/SKILL.md) — Monteiro appears explicitly in the skill's References, providing the ethical-stakes argument: accessibility is the designer's responsibility, not the legal team's. The "compliance theatre" anti-pattern is a Monteiro concern as much as a quality concern.
- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the visual-coherence step's dark-pattern check and the skill's "Hold" verdict category are grounded in Monteiro's argument that design review must include ethical accountability, not only aesthetic and functional review.
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Monteiro's framing answers the "why do we do structured heuristic review at all?" question: because the alternative is shipping things nobody evaluated.

## Cross-role connection

Monteiro's argument about designer responsibility for harms is a structural sibling of the security-expert's LLM-risk-assessment skill: both are about naming consequences before shipping, and both require the reviewer to be willing to surface uncomfortable findings that slow or block release. Where LLM risk assessment asks "what could go wrong if the model misbehaves?", Monteiro asks "what could go wrong if the design works exactly as intended?" Both disciplines address harms that are invisible to reviewers focused only on correctness. A team that runs both passes — security-expert's risk assessment and designer's ethics-grounded design review — before launch has closed more of the gap between "it works" and "it is safe to ship."
