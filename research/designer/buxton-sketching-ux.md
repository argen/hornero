# Bill Buxton — distilled

> *Sketching User Experiences: Getting the Design Right and the Right Design* (2007). The book that reframes fidelity as a deliberate design tool, not an accident of timing.

## Why it matters for AI-coding

AI design tools make high-fidelity outputs cheap. Figma plugins, generative UI, and code-from-mockup pipelines produce polished screens in seconds — which is exactly when Buxton's central argument becomes urgent. Cheap generation collapses the distinction between "what the design looks like" and "whether the design is right." Buxton's core claim is that fidelity signals commitment: a detailed, pixel-perfect mockup communicates "this is decided," and kills the conversation that should precede that decision. When high fidelity is expensive, the cost enforces the discipline. When it is free, the discipline must be enforced deliberately — by choosing low-fidelity sketches during the *exploration* phase even when a polished output is available. The methodology cites Buxton whenever a design-review receives a final-looking mock before the problem is fully understood.

## Key concepts the role pulls from

- **Getting the design right vs. getting the right design.** Two distinct activities requiring different tools. Getting the right design is divergent — exploring the space of possibilities; getting the design right is convergent — refining a chosen direction. Confusing them is the root of most expensive rework. The methodology uses this distinction to justify separate exploration and refinement phases.
- **Fidelity as a signal, not a state.** The polish of a design artefact tells a collaborator what is open for challenge. A napkin sketch signals "push back on the concept." A Figma prototype with a design system applied signals "this is decided; critique the details." Choosing fidelity is a communication act, not just a production act.
- **The 1:10:100 cost curve.** Changes made during sketching are cheap; the same change made post-implementation is an order of magnitude more expensive. The curve is the economic argument for front-loading exploration. AI generation compresses the cost of creation but not the cost of *rework after commitment* — which is what the curve actually describes.
- **Sketch quantity before quality.** Buxton advocates generating many rough alternatives before converging on one. The value is not in the individual sketch but in the contrast between sketches — each alternative reveals what the other assumes. AI-generated UI tends to produce one strong candidate; Buxton's argument is that the second and third sketches, however weak, are the source of insight.
- **The "look and feel" distinction.** Look (what the design looks like statically) is different from feel (how it behaves in motion and over time). Buxton argues that feel cannot be evaluated in static artefacts — you need time-based exploration (video sketches, prototypes, enacted scenarios). This underpins the design-review skill's "live exercise is not optional" principle.

## What to actually read (1-hour budget)

- **Part I, chapters 1-3** — the right-design vs. design-right framing, the designer as sketcher, and the fidelity argument. ~60 pages. This is the load-bearing argument.
- **Part II, chapter 8** — "What is a sketch?" — the precise definition of a sketch vs. a prototype. ~20 pages. Grounds the vocabulary.
- **Chapter 12** — "From Design to Engineering." ~15 pages. The hand-off argument; when and how to increase fidelity as exploration closes.

## What to skip

- The lengthy case studies of Buxton's own design projects (chapters 14-17) — interesting context but not methodology-load-bearing. The argument from earlier chapters is sufficient.
- The industrial-design tangents (chapters 9-11) — valuable background but rarely surfaces in software UI work; the principles have already been stated more directly in Part I.

## How this anchors role skills

- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the classification step (polish vs. new surface) maps to Buxton's fidelity-matches-stage argument. The skill cites Buxton explicitly in its References section.
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Buxton's argument that evaluation method should match fidelity is the theoretical basis for when to run a heuristic review vs. when to push back on the design process itself.
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — the "designed by accident" failure mode the skill exists to prevent is a fidelity problem: the success state was high-fidelity (designed) and the error state was low-fidelity (improvised). Buxton frames this explicitly.

## Cross-role connection

Buxton's structured low-fidelity exploration of a design space is a structural sibling of the tester's exploratory charter: both are time-boxed, mission-driven, heuristic-guided investigations of a problem space before committing to a solution. The tester's "explore the charter area before scripting tests" and Buxton's "sketch broadly before refining" are the same epistemic move applied to different disciplines. Both resist the pull of premature convergence — on test cases or on designs — that comes from working only with polished artefacts.
