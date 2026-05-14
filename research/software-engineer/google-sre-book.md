# Google SRE — distilled

> *Site Reliability Engineering: How Google Runs Production Systems* (2016, eds. Betsy Beyer, Chris Jones, Jennifer Petoff, Niall Richard Murphy). Plus *The Site Reliability Workbook* (2018) and *Building Secure & Reliable Systems* (2020). Available free at [sre.google/books](https://sre.google/books/).

## Why it matters for AI-coding

The SRE canon is the methodology's grounding for "what does it mean to actually run software." AI-generated code reaches functional correctness; production reliability is a different discipline that the SRE corpus codifies.

Three contributions matter most:

1. **The SLI / SLO / error-budget vocabulary** — a way to quantify "reliable enough" that's defensible against both "everything must be 100%" and "ship and see." The role's reviews reach for this language when reliability targets are being argued.
2. **Blameless postmortems** — the discipline that turns incidents into durable harness improvements. The methodology's `extract-lesson` skill and the per-role postmortem heuristics inherit directly.
3. **Toil reduction** — the framing that distinguishes "engineering work that compounds" from "manual work that recurs forever." The methodology's whole "harness compounds over time" thesis (from Chris MDP) is an applied case of this distinction.

## Key concepts the role pulls from

- **SLI (Service Level Indicator)** — what we measure. Specific signal, not a vibe. The data-scientist's `metric-definition` skill has SRE-flavoured language.
- **SLO (Service Level Objective)** — the target the SLI must hit (e.g., "99.9% of requests served in <250ms over rolling 28 days"). Decisions are made against the SLO, not the SLI.
- **Error budget** — `1 - SLO`. The amount of failure the team is allowed to spend before the SLO is breached. Funds risk-taking: if you have budget, ship the experiment; if you don't, focus on reliability work.
- **Blameless postmortem.** When something breaks, the writeup names *what* broke and *why the system allowed it*, not *who is at fault*. Re-orients learning away from defence and toward correction.
- **Toil.** Manual, repetitive, automatable, tactical, devoid of enduring value, scales with service growth. Distinct from "engineering work." SRE's job is to push the toil ratio below 50%.
- **Reduce, monitor, automate.** Order of operations for reliability work. Reducing the surface that needs monitoring beats more monitoring; automation only ever helps after the surface is right.
- **The four golden signals** — latency, traffic, errors, saturation. The four metrics you should always be able to read about a service.

## What to actually read (1-hour budget)

The book is huge. The essential chapters:

- **Chapter 1 — Introduction.** Frames the SRE role and the cultural commitments.
- **Chapter 4 — Service Level Objectives.** The SLI/SLO/error-budget triad.
- **Chapter 15 — Postmortem Culture: Learning from Failure.** The discipline; the templates; the failure modes when blameless culture isn't real.

If you have a second hour: Chapter 5 (Eliminating Toil) and Chapter 16 (Tracking Outages). Together these are about half of what the role's reliability-review heuristics draw on.

## What to skip

- Chapters on Google-specific infrastructure (Borg, Spanner-as-tool) — interesting but not portable; skip unless you're at Google scale.
- The case-study chapters are great reading but lower-density for working extraction.

## How this anchors role skills

- General review heuristic: when the role evaluates a feature that touches production reliability, the language used (SLI / SLO / error budget / golden signals) is SRE-direct.
- [`tdd-discipline`](../../roles/software-engineer/skills/tdd-discipline/SKILL.md) — when the methodology argues for tests as a reliability investment, the production-side case is SRE-flavoured.
- Indirect: `extract-lesson`'s framing of "incident → durable harness delta" is SRE-flavoured postmortem culture applied to AI-coding sessions.
- The data-scientist's `metric-definition` skill uses SRE-flavoured metric design vocabulary (owner, baseline, definition rigour).

## Cross-role connections

- **Tester role.** SRE intersects with testing on "what does production tell us that tests didn't?" Humble & Farley's *Continuous Delivery* is the closer match for the tester role; SRE is the production-side complement.
- **Security-expert role.** *Building Secure & Reliable Systems* (the third SRE book) explicitly fuses security and reliability — same blameless culture, same SLO-style thinking applied to security incidents. Worth a separate distilled note when that role's research/ entries get authored.

## A note on the format

The SRE books are written as collections of essays by many authors. Quality is uneven. The methodology pulls from the high-density chapters listed above; the rest are useful as reference, not as load-bearing canon.
