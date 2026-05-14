# Shreyas Doshi — distilled

> LNO framework, Type-1/Type-2 decision framing, and high-quality-decisions methodology. Public writing (Twitter/X, Lenny's Podcast, Substack) 2019–present. No canonical book; the work lives in long-form threads, frameworks shared on social media, and interview transcripts. Doshi is ex-Google, Twitter, and Stripe PM.

## Why it matters for AI-coding

AI compresses time-to-decision. A PM using AI tools for research, analysis, and draft synthesis will face more decisions per unit time than their pre-AI counterpart. Decision quality will decay unless the PM has an explicit discipline for which decisions warrant deep deliberation and which can be made fast and reversed. Doshi is the sharpest contemporary voice on exactly this: not productivity theatre, but the meta-skill of knowing how to decide.

The LNO framework — which tasks have leverage, which are neutral, which are overhead — is also a direct counter to the AI-era "I can do everything" trap. AI generates options and drafts at speed; without a triage heuristic, PMs spend leverage-level attention on overhead-level tasks, and the reverse.

## Key concepts the role pulls from

- **Type-1 vs. Type-2 decisions.** Borrowed and sharpened from Bezos (the "two-door" frame): Type-1 decisions are irreversible or high-cost-to-reverse — they warrant deep deliberation, broad stakeholder review, explicit documentation. Type-2 decisions are reversible — they should be made quickly, cheaply, by the smallest group. The failure mode Doshi flags: treating every decision as Type-1 (decision paralysis + bloated process) or treating every decision as Type-2 (carelessly blowing through irreversible choices). The `cross-functional-orchestration` skill's "revisit condition" field is a Type-1/Type-2 litmus: if the revisit condition is cheap to trigger, the decision was Type-2.
- **LNO triage.** Every task on a PM's plate is Leverage (moves the thing that matters most), Neutral (routine work that must get done), or Overhead (necessary evil that should be minimized and delegated). Doshi: most PMs invert the distribution — they spend disproportionate time on Overhead, adequate time on Neutral, and too little on Leverage. LNO is not a time-management tool; it's an attention-allocation heuristic. Applied in `cross-functional-orchestration`'s scoping: dispatch only when the decision is Leverage-level.
- **Decision quality ≠ outcome quality.** Doshi's most important separation: a good decision can produce a bad outcome (bad luck, external shock); a bad decision can produce a good outcome (dumb luck). Confusing the two is a systematic failure — teams punish good decisions that went wrong and reward bad decisions that got lucky. The `cross-functional-orchestration` skill's "revisit condition + reasoning" output is designed to preserve the decision's reasoning separately from the outcome, so the team can evaluate decision quality retrospectively.
- **Pre-mortems and decision documentation.** Doshi advocates pre-mortems (imagine the decision failed; why?) as a systematic bias-corrector. Not a check to do once; a practice to build into the synthesis cadence. Referenced in `cross-functional-orchestration`'s "alternative considered" and "what would change our mind" output fields.
- **OKR failure modes.** Doshi's critique of OKRs (cited in the `okrs` skill): Objectives become output-shaped; KRs become vanity metrics; the check-in cadence disappears. His framing reinforces Wodtke's surgical precision without contradicting it.

## What to actually read (1-hour budget)

- Doshi's long-form Twitter/X threads on LNO (search "Shreyas Doshi LNO" — the original thread is still accessible) — 15 minutes.
- His threads on Type-1/Type-2 decisions and decision quality — the core intellectual content is in public social-media writing.
- Lenny Rachitsky's podcast episodes with Doshi (two episodes; ~2022-2023) — 90 minutes total, but the first 45 of either episode covers the key concepts. Audio-first if you prefer.
- The "12 questions for PMs" and "Good Product Team / Bad Product Team" threads for the heuristic-dense version of his worldview.

## What to skip

- Doshi has no single canonical text to skip. The risk is the opposite: fragmentary sourcing across platforms means concepts are sometimes repeated with slight variation. Treat any three consistent sources (two threads + one podcast) as sufficient for the core frameworks.

## How this anchors role skills

- [`cross-functional-orchestration`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — Doshi is explicitly cited in Key Concepts: the decision-quality framing, the Type-1/Type-2 structure, and the "reasoning preserved separately from outcome" requirement in the synthesis step.
- [`okrs`](../../roles/product-manager/skills/okrs/SKILL.md) — Doshi's OKR failure modes are enumerated directly in the skill's Common Pitfalls section.
- General prioritization heuristic: when the PM role is asked to triage what to dispatch versus handle directly, LNO is the implicit frame. If a decision is Overhead-level, the PM should not be orchestrating a multi-role-review for it.

## Cross-role connection

Doshi's decision-quality / outcome-quality separation aligns directly with the data-scientist role's "correlation vs. causation" discipline: both argue that good process deserves to be evaluated independently of the result. A bad metric choice that happened to drive revenue is still a bad metric choice. A causal model that was right in structure but got unlucky on the data is still good science. Both roles push against results-only retrospectives.
