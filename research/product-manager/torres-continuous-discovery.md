# Teresa Torres — distilled

> *Continuous Discovery Habits* (2021). Product Talk. The operational manual for weekly customer-touchpoint discipline — Opportunity Solution Trees, structured interviewing, and assumption testing as a continuous practice rather than a project phase.

## Why it matters for AI-coding

AI collapses implementation cost toward zero; the bottleneck shifts entirely to deciding *what* to build. Without a discovery discipline, AI-assisted teams accelerate into the wrong thing faster than ever before. Torres provides the discipline: a cadence, a visual decision artifact, and a synthesis practice that keep customer evidence in the loop at the pace AI now demands.

Where Cagan defines what discovery *is*, Torres operationalises how it *runs* — weekly, structured, compound. The two work in sequence: Cagan's four risks frame the question; Torres' habits generate the evidence that answers it.

## Key concepts the role pulls from

- **Opportunity Solution Tree.** The persistent visual artifact: desired outcome at the top → customer opportunities (problems, unmet needs) → solution hypotheses → assumption tests. The OST is the output of `discovery-interview-prep` and the input to evidence-weighted prioritization. Prevents solution-first thinking by making the opportunity layer explicit.
- **Continuous-vs-project discovery.** One customer conversation per week, every week — not a quarterly research sprint followed by months of building in the dark. The cadence is the point: evidence compounds; any single interview is not decisive. Powers the weekly touchpoint requirement in `cross-functional-orchestration`.
- **Assumption testing.** Before prototyping, name the riskiest assumption and test it cheaply — a concierge, a fake door, a single conversation. Torres distinguishes a test (cheap, directional) from a prototype (expensive, conclusive). Used in `prd` when the evidence section marks a claim as assumed vs. validated.
- **Interview snapshots.** The per-interview synthesis artifact: 3-5 verbatim quotes, the story arc, surprises, open questions, OST placement. Replaces "we talked to 50 people" hand-waves with traceable, referenceable evidence. The `discovery-interview-prep` Step 4 post-interview synthesis is directly Torres' snapshot discipline.
- **Outcome over output.** Shared with Cagan and Perri, but Torres operationalises it weekly: every tree has a *desired outcome* at the root; work that doesn't trace to that outcome is out of scope. The `prd` skill's success-metric + counter-metric structure enforces the same contract.

## What to actually read (1-hour budget)

- **Chapters 1-3** — the continuous-discovery framing, the argument for cadence over depth, and why project-based discovery fails. The intellectual foundation for everything that follows. ~50 pages.
- **Chapter 4** — the Opportunity Solution Tree in full: how to draw it, how to populate it from interviews, how to navigate it toward experiments. The methodology's central artifact.
- **The interview snapshot template** (appendix / online resources at producttalk.org) — the per-interview synthesis form Torres provides. More useful than any chapter description of it.

## What to skip

- The later chapters on tooling and team adoption (roughly chapters 10-12) — valuable in a large org but tangential to the individual PM or small team using this methodology. The frameworks are fully operational without the change-management scaffolding.
- The habit-stacking framing in chapter 2's opening is motivational in register; experienced PMs can skim past it to the OST mechanics.

## How this anchors role skills

- [`discovery-interview-prep`](../../roles/product-manager/skills/discovery-interview-prep/SKILL.md) — Torres is the primary anchor: the OST as the destination for interview evidence, the weekly cadence as the operating constraint, and the snapshot discipline as the post-interview synthesis requirement.
- [`prd`](../../roles/product-manager/skills/prd/SKILL.md) — the evidence section of a PRD traces directly to interview snapshots and OST placement. A claim marked "assumed" vs. "validated" uses Torres' assumption-test vocabulary.
- [`cross-functional-orchestration`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — the weekly customer-touchpoint frequency in the orchestration cadence is Torres' cadence discipline. The "evidence available" field in a decision recommendation distinguishes snapshot-backed claims from internal hypotheses.

## Cross-role connection

Torres' discovery practice and the tester role's exploratory-charter skill are the same epistemological move in different domains: both are time-boxed, mission-driven investigations designed to surface unknown unknowns before they become expensive. The exploratory charter sets a session goal and a coverage frame; the Torres interview sets a desired outcome and an opportunity to investigate. Both produce synthesis artifacts (the charter debrief, the interview snapshot) that compound across sessions into a durable understanding of the system — one of a product's customers, one of a product's behavior.
