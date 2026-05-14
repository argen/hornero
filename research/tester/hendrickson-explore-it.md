# Elisabeth Hendrickson — distilled

> *Explore It!: Reduce Risk and Increase Confidence with Exploratory Testing* (Pragmatic Bookshelf, 2013). The cleanest practitioner guide to structured exploratory testing.

## Why it matters for AI-coding

AI agents are unusually capable at exhaustive scripted checking — running every assertion, every regression, every known-input case. What they lack is the investigative half: generating surprise, noticing that something is off without knowing what to look for, following the implication of an anomaly. Hendrickson's chartered-exploration method is exactly the structure that makes the investigative half reproducible and assignable — it is exploration with a discipline attached, not ad-hoc fiddling. Without it, an AI-assisted team risks a test suite that is wide and fast but has never once been surprised by the software.

## Key concepts the role pulls from

- **The exploration charter.** Mission + Areas in scope + Notes + Bugs — the four-section artifact that a `exploratory-charter` session produces. The mission is one sentence with a named tour, a surface, and a defect class. The charter is the evidence that exploration happened.
- **Tours.** Hendrickson catalogues named exploration shapes — Feature, Claims, Configuration, Stress, Money, Garbage, Interruption, Data, History, Couch Potato — each biased toward a particular class of defect. One tour per session, named in the charter. This is what makes charters repeatable and learnable rather than "I just poked at it."
- **Time-boxing.** A charter is 30, 60, 90, or 120 minutes. The box is declared at the start and honoured at the end; if more investigation is needed, a follow-up charter is scheduled. The discipline is the point: contained sessions produce contained, reportable outcomes.
- **Recognising "interesting" behaviour.** Hendrickson trains the tester to notice anomalies that don't quite fail an assertion but carry risk — the wrong rounding direction, the copy that says "Stripe" after the provider migrated to Adyen, the blank field where a reference number should be. This is the oracle discipline that automated checking cannot replicate.
- **Touring as repeatable practice.** Because tours are named and chartered, you can hand the artifact to a second tester and the session is meaningful — it is not "look around for bugs." The charter is the handoff unit. This is load-bearing for the methodology's assignability model.

## What to actually read (1-hour budget)

- **Chapter 1** — The explorer's mindset; checking vs exploring; why scripted suites miss whole classes of bugs.
- **Chapter 2** — The charter format: Mission, Areas, Notes, Bugs. The artifact shape is here.
- **Chapter 3** — Recognising interesting behaviour: the oracle heuristics, how to notice without knowing what to look for.
- **Chapter 5** — The full tour catalogue. Read the tour names and their defect-class biases; this is the vocabulary `exploratory-charter` uses directly.
- **Charter examples appendix** — the before/after pair is worth more than a chapter of theory.

~80 pages total; the rest is context.

## What to skip

The late chapters on specific tools (mind maps, automation hooks, commercial test-management software) have aged and are not load-bearing for the methodology. Hendrickson's tool-agnostic content in chapters 1–5 is durable; the tooling chapters are 2013.

## How this anchors role skills

- [`exploratory-charter`](../../roles/tester/skills/exploratory-charter/SKILL.md) — load-bearing. The charter format (Mission/Areas/Notes/Bugs), the touring vocabulary, and the one-tour-per-session discipline are Hendrickson's directly. The skill is essentially a worked application of chapters 2–5.
- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — uses time-boxed charters as one of its evidence sources; the Go / Fix-then-go / Hold recommendation draws on the coverage summary each charter produces.
- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — charters are the alternative to fully-scripted test cases for ambiguous or poorly-understood surfaces; the plan records which areas are covered by charter versus automation.

## Cross-role connection

Hendrickson's chartered exploration is the structural sibling of the designer's heuristic evaluation (Nielsen) — both are structured, heuristic-guided, time-boxed, single-trained-reviewer investigations that produce severity-ranked findings from a named set of lenses. Neither is ad-hoc; neither is fully scripted. The Hornero reviewer pattern — a bounded session with a named heuristic set, a declared scope, and a ranked findings list — is partly Hendrickson and partly Nielsen abstracted across roles.
