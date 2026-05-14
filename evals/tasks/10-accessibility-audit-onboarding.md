# Task 10 — Accessibility audit: onboarding flow

**Shape:** Designer-led accessibility audit of an onboarding flow.

**Artifact:** Six screen designs (Figma export or screenshots) for a B2B SaaS onboarding flow: signup → email verification → workspace creation → invite teammates → connect data source → first-task. Plus a 1-page state-inventory document the designer claims is "fully accessible." Seeded failures: (1) a focus-trap on the modal "connect data source" step; (2) colour-only error indication on the form fields in step 4; (3) a celebratory animation on step 6 with no `prefers-reduced-motion` gate.

**Recommended role mix (3):**

- `designer` — load-bearing; WCAG 2.2 audit, Holmes/inclusion frame, severity-ranked findings citing specific success criteria.
- `tester` — keyboard-tour and screen-reader-tour heuristic exploratory pass; oracles for "what does 'works' mean for a screen reader."
- `software-engineer` — implementation feasibility of each remediation; flags any "fix" that would require redesigning the component library.

**Why not other roles:** strategic-marketing not in scope on internal onboarding; no novel measurement; no auth-flow re-architecture (the auth itself is a fixed contract).

**What "good" looks like:**

- Designer surfaces each of the 3 seeded failures, each cited to a specific WCAG 2.2 success criterion + severity. No "the page needs more contrast" generic finding.
- Tester independently catches ≥1 issue via the keyboard tour (Hendrickson) that the designer's static review didn't surface.
- Engineer adjudicates remediation effort honestly — at least one remediation should be flagged as "needs design-system PR, not a one-line fix."
- The synthesis distinguishes Blockers (WCAG AA fail) from Improvements; the recommendation is Go / Fix-then-go / Hold using `design-review`'s shape.

**Anti-patterns to watch for:**

- Designer relies on automated-tooling output (axe / Lighthouse) and doesn't add judgement.
- Tester re-finds what the designer already found (Dimension 2 failure).
- "Pass WCAG 2.2 AA" claimed without per-finding citation (Dimension 1 failure).

**How to run:**

1. Place the screen designs + state inventory at `evals/runs/10-accessibility-audit-onboarding/artifact.md`.
2. Invoke `multi-role-review` with designer + tester + software-engineer.
3. Score, with attention to whether each seeded failure was caught with the appropriate WCAG citation.
