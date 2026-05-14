# Byron Sharp — distilled

> *How Brands Grow: What Marketers Don't Know* (Oxford University Press, 2010) and *How Brands Grow Part 2* (with Jenni Romaniuk, 2015). The Ehrenberg-Bass Institute's empirical-marketing canon.

## Why it matters for AI-coding

AI-era marketing tools accelerate segmentation and targeting — the exact activities Sharp's empirical work says are chronically over-applied. The default AI-generated launch plan optimises for narrowly-targeted messaging to "high-value" existing customers; Sharp's evidence across hundreds of categories says that is precisely backwards: **mental availability + broad reach** drives growth, not micro-segmentation or loyalty extraction. The `pre-launch-marketing-audit` skill exists partly to catch this anti-pattern before it ships. Sharp's work gives the methodology a falsifiable standard to argue against the trend — which is the only kind of marketing argument worth having.

## Key concepts the role pulls from

- **Mental availability.** The probability that the brand is thought of in buying situations — this is the actual objective of marketing. Not awareness (which Sharp treats as an imprecise proxy), not preference (which follows mental availability, not the reverse). Building mental availability requires reach, frequency, and consistent use of distinctive assets over time. Powers `launch-brief`'s primary-mode framing and the audit's mental-availability readiness check.
- **Distinctive assets.** Colours, characters, sounds, shapes, taglines — the recognition layer that makes a brand retrievable from memory without requiring deliberate recall. Sharp's evidence: assets compound when reused consistently; every campaign that reinvents the visual language wastes the prior campaign's accumulation. Powers `launch-brief`'s distinctive-asset continuity check (Pitfall 5).
- **Double Jeopardy.** A robust empirical law: smaller brands have both fewer buyers *and* lower loyalty — both penalties at once. This directly defeats the loyalty-strategy anti-pattern ("if we can't win market share, we'll defend our core"). Naming it prevents teams from planning around loyalty increases as a substitute for penetration. Powers the `pre-launch-marketing-audit`'s empirical-marketing critique.
- **Light buyers drive growth.** Most category buyers are light, infrequent purchasers of any given brand. Growth comes from getting more of them to buy occasionally — not from getting existing heavy buyers to buy more. The heavy-buyer myth is what makes narrow-targeting look rational; Sharp's data shows it isn't. Powers the audit's targeting-anti-pattern check.
- **Category Entry Points** (Romaniuk, *Part 2*). The specific cognitive triggers — situations, needs, moods — that bring a category (and ideally, a brand) to mind. The strategic question is not just "do they know us?" but "in what situations do they think of us?" Powers the `positioning-canvas`'s "when does the customer think of this?" prompt, refining Dunford's best-fit customer segment component with a temporal dimension.

## What to actually read (1-hour budget)

- *How Brands Grow* — Chapters 1, 2, 4, 7: the empirical laws, Double Jeopardy, light buyers, and how brains retrieve brands. These four chapters carry Sharp's load-bearing claims; everything else is elaboration.
- *How Brands Grow Part 2* — Chapter 4 (Distinctive Asset Building) and Chapter 6 (Category Entry Points). Romaniuk's contributions operationalise Sharp's theory; Chapter 6 is the most directly applicable to the `positioning-canvas` skill.
- Total: approximately 80 pages if you read the six chapters and skip the framing chapters.

## What to skip

- The late chapters in *Part 1* on B2B applicability — the evidence base is thinner; Sharp's strongest claims are grounded in CPG (fast-moving consumer goods). Apply with care in B2B SaaS contexts; adapt the principle but don't treat the specific empirical magnitudes as portable.
- Several of *Part 2*'s media-planning chapters are dated — written when social media's brand-building evidence was thin and the digital-vs.-TV debate was active. The principles (reach, consistency) hold; the specific channel framing does not age well.

## How this anchors role skills

- [`launch-brief`](../../roles/marketing-expert/skills/launch-brief/SKILL.md) — load-bearing. Mental availability is the stated objective of awareness-mode work in the brief; distinctive assets is a required section (Step 3, strategic shape). Sharp is the named reference for Pitfall 5 (distinctive-asset reinvention) and the awareness-vs.-activation mode distinction.
- [`pre-launch-marketing-audit`](../../roles/marketing-expert/skills/pre-launch-marketing-audit/SKILL.md) — load-bearing. The audit's empirical-marketing critique catches narrow-targeting anti-patterns and loyalty-strategy substitution; Double Jeopardy and light-buyer findings are cited directly as the evidentiary basis for flagging those patterns.
- [`positioning-canvas`](../../roles/marketing-expert/skills/positioning-canvas/SKILL.md) — supporting. Sharp's Category Entry Points concept (via Romaniuk) refines Dunford's best-fit customer component by asking *when* the customer thinks of the category, not just *who* the customer is. The canvas's "buying situation" prompt is grounded here.

## Cross-role connection

Sharp's mental-availability and distinctive-assets framing connects directly to the designer's brand-system thinking — Brad Frost / design-system territory. Where the designer asks "is this recognisable as us?", Sharp's evidence reframes the answer: recognisability is the asset, not a side-effect of nice design. Consistent use of a slightly mediocre logo compounds into strong mental availability; a beautifully redesigned one resets the accumulation clock. That is a data argument, not an aesthetic one — and it is the argument to make when the designer and CMO are disagreeing about whether to refresh the visual identity at launch.
