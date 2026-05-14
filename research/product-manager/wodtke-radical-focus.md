# Christina Wodtke — distilled

> *Radical Focus: Achieving Your Most Important Goals with OKRs* (2016, revised 2021). The practitioner's OKR reference — delivered as a fable with an attached methodology section. Wodtke's treatment is more surgical and less evangelical than Doerr's *Measure What Matters*, and it's the anchor the Hornero `okrs` skill is built on.

## Why it matters for AI-coding

AI can generate OKRs at scale — a team can have fifty KRs drafted in five minutes. What Wodtke argues, and what makes her work load-bearing in the AI era, is that the discipline is the *opposite* of scale: one Objective, three Key Results, a weekly check-in, radical focus. AI-assisted OKR generation produces the exact failure mode Wodtke diagnoses — too many, too vague, too output-oriented, unchecked by weekly cadence. The skill built on her work exists to counter the AI-generated OKR artifact, not to enhance it.

OKR theatre is worse with AI. Without Wodtke's discipline — which forces the team to reduce, not expand — AI tools make it trivially easy to produce a plan that looks strategic and changes nothing.

## Key concepts the role pulls from

- **One Objective per team per quarter.** Wodtke's most-contested and most-important rule. Teams resist it because narrowing to one forces real prioritization — it makes the deprioritized work visible. The `okrs` skill hard-caps at two Objectives (with one as the norm) because of this. The cap is not a formatting preference; it's the whole point.
- **Key Results are outcomes, not outputs.** "Ship feature X" is a milestone, not a KR. A KR measures a change in the world — customer behavior, business state, a leading indicator that moves because of the work. This is the load-bearing distinction in the `okrs` skill's Step 2 and is the anti-pattern all six Common Pitfalls in the skill ultimately reduce to.
- **The stretch goal zone.** Wodtke's 70% completion target: a team that meets 100% of its OKRs every quarter is sandbagging; a team that consistently hits 40% is setting fantasy goals. The 70% zone names "ambitious but achievable" more precisely than either extreme. Imported directly into the `okrs` skill's aspirationality check.
- **The weekly check-in cadence.** Fifteen minutes, weekly: confidence per KR (gut score, no need to defend), three priorities for the week, health metrics. Wodtke: "the cadence is the OKR." Without it, OKRs become a March artifact reviewed in June. The `okrs` skill's Step 4 reproduces this cadence exactly.
- **The confidence vote.** Each week, each KR gets a confidence rating (Wodtke uses a 1-10 scale or a traffic light). The point is not precision; the point is surfacing early when a KR is in trouble so the team can adjust mid-quarter rather than explain the miss post-quarter. This is a decision-quality move: the team responds to signals, not results.
- **The fable format.** *Radical Focus* teaches through a story of a startup team failing with OKRs and then succeeding. The methodology section is the appendix — the story is the main event. Wodtke's pedagogical choice is that practitioners learn OKRs by seeing them fail in a relatable way. The Hornero `okrs` skill's failure-examples section is Wodtke's fable made explicit.

## What to actually read (1-hour budget)

- **The fable (Part I)** — ~80 pages, reads in 50 minutes. The narrative arc — from chaotic startup to focused team — makes the discipline legible in a way no methodology section can. If you're going to read one thing, read this.
- **The methodology appendix (Part II)** — the formal rules, the check-in format, the OKR examples. 20 pages. Read this as the reference section after the fable.
- 2021 revision adds a section on team OKRs vs. individual OKRs — useful but not load-bearing for the Hornero skill.

## What to skip

- The 2021 preface on remote-first OKRs — dated quickly; the cadence works across modalities, and the process advice has been superseded by better remote-work literature.
- Doerr's *Measure What Matters* (2018) is complementary but more evangelical and less surgical. Read Wodtke first; read Doerr only if you want the Google/Intel cultural context.

## How this anchors role skills

- [`okrs`](../../roles/product-manager/skills/okrs/SKILL.md) — Wodtke is the primary anchor for every section. The one-Objective cap, the outcome-KR requirement, the stretch-goal framing, the weekly check-in, and the bench test are all Wodtke.
- [`cross-functional-orchestration`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — the outcomes-over-outputs synthesis principle and the "what outcomes will tell us this decision was right?" question are Wodtke's KR vocabulary applied to a cross-functional decision.
- [`prd`](../../roles/product-manager/skills/prd/SKILL.md) — the success-metric + counter-metric structure in a PRD is OKR discipline applied to a feature: what outcome are we targeting, and what's the counter-metric that would tell us we optimized the wrong thing?

## Cross-role connection

Wodtke's weekly confidence vote is the same information-structure as the security-expert role's risk-register: both are cadenced, low-overhead signals designed to surface problems mid-cycle rather than post-cycle. Both reject the "big quarterly review" as the primary feedback loop. The discipline is domain-independent; only the signal content changes.
