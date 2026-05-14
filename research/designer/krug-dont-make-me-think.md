# Steve Krug — distilled

> *Don't Make Me Think: A Common Sense Approach to Web Usability* (3rd ed., 2014); *Rocket Surgery Made Easy: The Do-It-Yourself Guide to Finding and Fixing Usability Problems* (2010). The practitioner's bible for self-evident design and accessible usability testing.

## Why it matters for AI-coding

AI-generated UIs prioritise novelty over recognition. The model has seen thousands of interfaces and tends to produce surfaces that are visually differentiated, compositionally interesting, and cognitively demanding — each screen is its own design problem, solved fresh, without the benefit of convention. Krug's central mandate cuts directly against this: *don't make the user think*. Recognition over novelty. Convention over originality. The user's cognitive budget is spent on their goal, not on decoding the interface. This is the working designer's implementation of Nielsen's H4 (consistency and standards) and H6 (recognition over recall) — stated at ground level, in practitioner voice, with no ceremony.

The second argument — from *Rocket Surgery Made Easy* — is equally load-bearing for the methodology: usability testing is not a research project. It is a practice. Five users, an afternoon, a hallway or a Zoom call. The discipline is finding the problems; the formality of the study is irrelevant. AI teams that defer user testing because "we don't have a UX researcher" are the exact audience Krug wrote *Rocket Surgery* for.

## Key concepts the role pulls from

- **The "don't make me think" principle.** Every design decision that requires the user to stop and figure something out is a cognitive cost. Costs compound. A surface that requires three small cognitive decisions is noticeably harder than a surface requiring none — even if each decision is trivial in isolation. The principle is the practitioner instantiation of Nielsen's recognition-over-recall heuristic.
- **Billboard design.** Krug's observation that users *scan* pages rather than read them — choosing the first plausible option that looks like it might work. The practical implication: visual hierarchy, clear labels, and obvious affordances matter more than information completeness. AI-generated UI tends to include all the information; Krug argues for surfacing the *signal* and burying the rest.
- **Happy talk must die.** Marketing copy on functional surfaces ("Welcome to our platform! We're so glad you're here.") is wasted pixels that delays the user's goal. Krug names this specifically because it is the most common violation — and because it is exactly what AI-generated onboarding copy defaults to.
- **DIY usability testing.** From *Rocket Surgery Made Easy*: recruit anyone who is not on the product team. Test with three to five people. Run a one-hour session. The session reveals more than a month of design review. The methodology's reference to Krug in the design-review skill's "live exercise" section is grounded here: exercising the feature yourself is the minimum; watching someone else exercise it is more.
- **The trunk test.** Krug's heuristic for site-level orientation: if a user arrived on this page without context, could they tell (a) what site this is, (b) what page they're on, (c) what the major sections are, (d) what their options are at this level, (e) where they are in the overall navigation? Pages that fail the trunk test send users into orientation panic. The methodology applies this to any new screen: does it orient the user clearly without requiring context from prior screens?

## What to actually read (1-hour budget)

- *Don't Make Me Think* **chapters 1-7** — the core argument. ~120 pages. Krug writes short; this is a fast read. The trunk test, billboard design, and happy-talk arguments all live here.
- *Don't Make Me Think* **chapter 9** — "Usability testing on 10 cents a day." ~20 pages. The fast-path to the *Rocket Surgery* argument.
- *Rocket Surgery Made Easy* **chapters 2-5** — the one-hour test script; finding and recruiting; the morning debrief. ~60 pages. The operational detail needed to actually run a session.

## What to skip

- *Don't Make Me Think* chapters 10-13 (accessibility, mobile, and parting words) — not dated, but the core argument from chapters 1-7 is more load-bearing for the methodology. Read these when the surface is specifically mobile-first.
- *Rocket Surgery* is short enough to read whole; nothing to skip.

## How this anchors role skills

- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the "live exercise is not optional" step echoes Krug's usability-test discipline; the visual-coherence step's "happy talk" and "billboard" checks are Krug instantiated.
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — Krug's obviousness principle is the informal statement of the state audit's purpose: every state must be legible without explanation. If a user cannot tell at a glance which state the surface is in, the state design has failed the Krug test.
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Krug's practitioner voice is the counterweight to heuristic-evaluation formalism; the skill's findings should be as specific and actionable as Krug's own examples.

## Cross-role connection

Krug's heuristic evaluation method — one trained reviewer, a clear scope, a specific session structure — is a structural sibling of the tester's exploratory-charter approach. Both are empiricist and practitioner-voiced: the value is in the disciplined observation of what actually happens, not in the theoretical model that predicts what should happen. Nielsen provides the framework; Krug provides the no-ceremony implementation; the tester's charter provides the equivalent for functionality coverage. Tester and designer share the same underlying discipline — go look at the thing — applied to different dimensions of quality.
