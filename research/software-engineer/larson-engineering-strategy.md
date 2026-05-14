# Will Larson — distilled

> *An Elegant Puzzle: Systems of Engineering Management* (2019, Stripe Press) and *Staff Engineer: Leadership Beyond the Management Track* (2021, self-published). Larson's blog at lethain.com extends both books continuously.

## Why it matters for AI-coding

AI accelerates the implementation half of engineering work — writing, testing, refactoring code — while the strategy and coordination half remains human. Staff engineers in AI-augmented orgs find their leverage increasingly in the writing artifacts: the RFC that frames a decision before code lands, the strategy memo that channels team energy, the tech-radar that depreciates old choices. Larson is the sharpest practitioner-theorist on engineering strategy as writing practice. The methodology's `rfc` skill draws its template structure directly from his work.

The "systems" framing in *An Elegant Puzzle* — treating teams, processes, and technical debt as interacting systems rather than one-off problems — also provides the methodology with its default lens for diagnosing repeated failure patterns rather than blaming individuals.

## Key concepts the role pulls from

- **Engineering strategy as writing.** Larson's core claim: good engineering strategy is a written artifact — durable, reviewable, revisable — not a shared mental model that lives in one person's head. Strategy memos, tech-radars, RFC templates are the tools. Writing exposes gaps in the thinking that conversation conceals.
- **Staff+ archetypes.** *Staff Engineer* maps four operating patterns — Tech Lead, Architect, Solver, Right Hand — each with different leverage points, audience, and scope of influence. Useful for calibrating what kind of technical leadership a given situation calls for.
- **The RFC template.** Larson's recurrent structure: Context → Problem → Proposed approach → Alternatives → Risks → Decision needed. The key innovation is foregrounding the specific decision being asked, so reviewers know how to engage.
- **Succession over heroism.** Larson's management-side insight that applies equally to technical leadership: a staff engineer who is the only person who can maintain a system has created a liability, not an asset. Knowledge and decision-making capacity must be distributed.
- **Pace-layering technical debt.** *An Elegant Puzzle* models technical debt as existing at different rates of change (infrastructure, platform, product). Interventions appropriate at one layer are wrong at another; the model prevents one-size-fits-all debt remediation.
- **Four states of a team.** Falling behind → treading water → paying down debt → innovating. Teams at each state need different interventions; Larson's framework prevents applying the same fix regardless of where the team is.

## What to actually read (1-hour budget)

- *An Elegant Puzzle*, **"Systems of engineering management"** section (ch. 2-3) — the four team states and the systems framing.
- *An Elegant Puzzle*, **"Navigating organisations"** section — the engineering strategy chapters, especially "Write five, then synthesise."
- *Staff Engineer*, **"Operating as a Staff Engineer"** (Part 2, ch. 5-9) — the writing artifacts, the staff meeting circuit, how to work on what matters.
- Larson's lethain.com essays "Strategies and Visions" and "Finding the right company" — concise versions of the book's core strategy arguments, freely available.

## What to skip

- The hiring and performance management chapters of *An Elegant Puzzle* — valuable for engineering managers; peripheral for engineers adopting the role's technical-leadership skills.
- Salary and promotion system design sections — Larson covers them thoroughly; not load-bearing for the methodology.

## How this anchors role skills

- [`rfc`](../../roles/software-engineer/skills/rfc/SKILL.md) — the RFC template's Context → Problem → Proposal → Alternatives → Risks → Decision structure is Larson's. The "one RFC, one direction" norm and the "worst outcome is a decision that decays" framing are his.
- General technical leadership heuristics: Larson is the citation when the role coaches an engineer on writing as a leverage tool — the memo that avoids a meeting, the strategy doc that aligns a team without a sync.

## Cross-role connection

Larson's engineering-strategy writing practice is the direct counterpart of the product-manager role's product-strategy artifacts (PRD, roadmap). The PM and the staff engineer are producing parallel written artifacts for the same decisions, from their respective domains. When cross-functional orchestration breaks down, it's often because the engineering strategy doc and the product strategy doc have drifted apart; Larson and the PM canon (Cagan, Torres) are the two sides of the same alignment problem.
