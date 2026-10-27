# Itamar Gilad — distilled

> *Evidence-Guided: Creating High-Impact Products in the Age of Uncertainty* (2024). GIST framework (Goals, Ideas, Steps, Tasks); Confidence Meter; anti-HiPPO; evidence-weighted decision-making as a systematic practice rather than a slogan. Gilad is ex-Google (YouTube) PM and founder of the Evidence-Guided methodology.

## Why it matters for AI-coding

AI hallucinates evidence. It can generate statistics that sound plausible, cite studies that don't exist, and produce "data-backed" recommendations with no real evidence behind them. The PM who uses AI for market research, feature prioritization, or competitive analysis without an explicit evidence-weighting framework will be fooled — not by malice, but by fluency.

Gilad's Confidence Meter — which scores not the idea but the evidence quality behind the idea — is the structural antidote. Before accepting an AI-generated recommendation, the PM applies the confidence check: what evidence does this rest on? What type of evidence? How strong? The AI's answer is almost always "low confidence, untested assumption." That's fine — but the PM must name it as such, or it becomes an unexamined HiPPO.

## Key concepts the role pulls from

- **GIST framework.** Goals → Ideas → Steps → Tasks. A four-layer hierarchy that connects the company's strategic goals to the daily engineering tasks, with evidence required at each transition. Goals are outcome-anchored (Wodtke-compatible). Ideas are hypotheses, not commitments. Steps are small experiments that generate evidence before full investment. Tasks are what engineering works on when Steps are validated. The framework is an explicit anti-roadmap: you cannot commit a roadmap-level item without passing through the Ideas and Steps layers first.
- **The Confidence Meter.** A 1-10 scale (or a five-band version: no evidence → anecdote → hypothesis → tested → validated) that scores the evidence quality behind an idea, not the idea itself. A 10/10 idea supported by a 2/10 evidence base is a risky idea. Gilad's discipline: never let evidence confidence collapse into idea enthusiasm. The Confidence Meter is explicitly cited in the `okrs` skill's "evidence available" framing and in `prd`'s evidence-section requirement.
- **Anti-HiPPO.** HiPPO = Highest-Paid Person's Opinion. Gilad's argument: in most organizations, the loudest voice (usually the most senior) overrides evidence when they conflict. GIST and the Confidence Meter create a structure where evidence can be made visible and explicit, making it harder (not impossible) to override with authority alone. The `cross-functional-orchestration` synthesis step's "evidence available" field is a lightweight HiPPO-counter.
- **ICE scoring — and its limits.** ICE (Impact, Confidence, Ease) is a common prioritization heuristic; Gilad extends it by making Confidence the evidence-quality score rather than a gut feel. The extension forces PMs to separate "we think this will work" (a hypothesis) from "we have evidence this works" (a validated claim). Gilad's version of ICE is more rigorous than most implementations.
- **Continuous validation over big-bang launches.** Gilad argues for a product culture where ideas are continuously tested in small Steps before full build commitment — structurally similar to Torres' discovery cadence but focused on idea-validation rather than opportunity-discovery. The two practices are complementary: Torres' weekly interview cadence surfaces opportunities; Gilad's Steps layer tests the solutions.

## What to actually read (1-hour budget)

- **Chapters 1-4** — the anti-roadmap argument, the GIST framework, and the Confidence Meter introduced. The intellectual foundation. ~70 pages.
- **Chapter 7** — the Confidence Meter in full, with the five-band scoring rubric and worked examples. The most immediately operational chapter.
- Gilad publishes at itamargilad.com — the blog posts that preceded the book (especially "Why I Stopped Using Product Roadmaps" and "GIST Planning") cover the conceptual core in 20 minutes total.

## What to skip

- Chapters on portfolio planning and organizational rollout are valuable for a Chief Product Officer but tangential for an individual PM using the methodology. The frameworks are operational without the org-level scaffolding.
- The later chapters on metrics and OKRs overlap significantly with Wodtke and Cutler; read them for Gilad's specific GIST-layer integration, not as a primary source for those topics.

## How this anchors role skills

- [`prd`](../../skills/prd/SKILL.md) — Gilad's evidence-quality vocabulary ("assumed," "anecdote-backed," "tested," "validated") maps directly to the PRD's evidence section. A PRD that marks assumptions honestly is GIST-compatible; one that presents all claims as validated is a Confidence Meter failure.
- [`okrs`](../../skills/okrs/SKILL.md) — the OKR skill's References cite Gilad as the evidence-weighting complement to Wodtke's focus discipline. GIST Goals are OKR-shaped; GIST Ideas require confidence scoring before roadmap commitment.
- [`cross-functional-orchestration`](../../skills/cross-functional-orchestration/SKILL.md) — the "evidence available" field in the decision recommendation is Gilad's Confidence Meter applied to a cross-functional decision. Distinguishes snapshot-backed claims from internal hypotheses.

## Cross-role connection

Gilad's Confidence Meter and the data-scientist role's "validated vs. observed vs. assumed" evidence taxonomy are the same epistemological structure applied in different registers. Both argue that the label matters: calling a hypothesis a fact is the error, not the existence of the hypothesis. The PM needs a lightweight version of the data-scientist's evidence quality discipline — Gilad provides exactly that.
