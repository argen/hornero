# Jakob Nielsen — distilled

> *10 Usability Heuristics for User Interface Design* (1994, refreshed 2020). Plus Nielsen Norman Group articles. The canonical heuristic set.

## Why it matters for AI-coding

AI design tools and agents produce plausible-looking UIs faster than any human team — and plausible is not correct. Nielsen's heuristics are the *correction layer* that catches the slop: the missing loading states that violate H1 (Visibility of system status), the invented interaction patterns that violate H4 (Consistency and standards), the forms that accept bad input and blame the user rather than preventing the error (H5), and the screens that demand the user remember context from three steps back (H6 Recognition rather than recall). Without a structured heuristic pass, AI-generated UI ships with a predictable failure profile that Nielsen catalogued in 1994 and which has not changed. The methodology treats a heuristic review as a non-optional pre-launch gate, not a nice-to-have. A Norman pass builds vocabulary for *what went wrong*; a Nielsen pass builds procedure for *finding it systematically*.

## Key concepts the role pulls from

- **The 10 heuristics themselves as a checklist.** The canonical list is the procedure for `heuristic-review`, applied with judgement not as a tickbox. The four heuristics most frequently violated by AI-generated surfaces: **H1 Visibility of system status** (loading, async, partial-failure states absent or wrong), **H4 Consistency and standards** (novel interaction patterns inconsistent with platform or product conventions), **H6 Recognition rather than recall** (options and context buried instead of surfaced), and **H9 Help users recognise, diagnose, and recover from errors** (generic error messages that name no cause and offer no path forward).
- **Severity ratings (Nielsen's 0–4 scale).** Nielsen proposed a five-point severity scale: 0 (not a problem), 1 (cosmetic), 2 (minor), 3 (major), 4 (usability catastrophe — imperative to fix before release). `heuristic-review` adopts this scale directly; it is what allows a review to produce a prioritised remediation list rather than an undifferentiated complaints log.
- **Discount usability engineering.** Nielsen's core insight: 3–5 independent evaluators catch 60–80% of usability problems; a single evaluator catches ~35%. The cost of expert review is a fraction of the cost of user testing, making it the right first pass. This is why one designer reviewer is load-bearing in the methodology's review workflow — not infinitely scaling with more reviewers, but not skippable. A single `heuristic-review` pass is the discount-engineering minimum.
- **Heuristic evaluation vs. user testing.** These are distinct activities with different coverage profiles. Heuristic evaluation catches principle violations efficiently; user testing catches workflow gaps, mental-model mismatches in novel domains, and behaviour under real conditions. Neither substitutes for the other. This distinction is why `heuristic-review` is a standalone skill rather than folded into a user-test skill — and why every `heuristic-review` artifact ends with explicit user-test recommendations.

## What to actually read (1-hour budget)

- **NN/g — "10 Usability Heuristics for User Interface Design"** (nngroup.com; 2020 refresh). The primary source. ~20 minutes. The 2020 refresh clarifies H9's wording and adds illustrative examples; read this, not the 1994 paper text.
- **Nielsen — "Severity Ratings for Usability Problems"** (NN/g, 1994). ~10 minutes. The 0–4 scale; how to combine frequency, impact, and persistence into a single severity rating. This is the scoring rubric `heuristic-review` uses.
- **NN/g — "How to Conduct a Heuristic Evaluation"** (~10 minutes). The review procedure: scope, walkthrough sequence, merging multiple evaluators.
- **NN/g — "Error Message Guidelines"** (~10 minutes). Specific application of H9; the most common heuristic violation in AI-generated surfaces. Grounds H9 findings in concrete patterns.
- **NN/g — "Recognition and Recall in UX"** (~10 minutes). Specific application of H6; disambiguates the heuristic from vague "discoverability" language.

## What to skip

- Early 1990s book chapters from Nielsen's *Usability Engineering* (1993) that predate responsive layout, mobile interaction, and async UI patterns — the heuristics aged; the contextual examples didn't.
- The NN/g article library is large and uneven in rigour; a significant portion reads as SEO-optimised content marketing rather than methodology. Filter for articles with explicit research citations or quantitative backing; skim or skip the "best practices" listicles.

## How this anchors role skills

- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — load-bearing. The 10 heuristics are the procedure; Nielsen's severity scale is the scoring rubric; discount-usability is the theoretical justification for the skill existing at all.
- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — heuristic citations are the mechanism by which findings get justified in a design-review workflow; "this violates H5" is a defensible claim; "this feels off" is not.
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — H1 (Visibility of system status) is the load-bearing heuristic for state-inventory work; the empty/loading/error/success/partial checklist is H1 operationalised into a per-state pass.

## Cross-role connection

Nielsen's heuristic-evaluation method is a structural sibling of the tester's exploratory-charter approach: both are heuristic-guided, structured explorations of a surface by a single trained reviewer, operating within a fixed time-box, producing a severity-ranked findings list. The reviewer pattern that runs through the methodology — one trained reviewer as a gate, not a rubber stamp — descends directly from this lineage. The tester's charter names missions where Nielsen names heuristics; the artefact shape and the severity discipline are the same move applied to different concerns.

The engineer role connects through H5 (Error prevention): Nielsen's principle that constraints preventing bad input outrank error messages cleaning up after it maps directly onto defensive input-validation discipline and the methodology's preference for type-safe APIs over runtime guards.
