# Task 08 — Positioning canvas draft review

**Shape:** Strategic-marketing critique of a first-draft positioning canvas.

**Artifact:** A 1-page positioning canvas (Dunford 5-component) for a new B2B SaaS product:

- Competitive alternatives: "Excel, the status quo"
- Unique attributes: "AI-powered, fast, easy to use"
- Value: "saves time"
- Best-for segment: "growing teams"
- Market category: "the AI productivity platform"

In other words: every standard placeholder is present. The team thinks they're done; they aren't.

**Recommended role mix (2-3):**

- `marketing-expert` — the load-bearing role; Dunford canvas critique, Sharp on mental availability, Hoffman on adjective marketing.
- `product-manager` — does the positioning match the customer job? Is the "growing teams" segment specific enough to support a roadmap?
- `designer` (optional, 3rd role only if the canvas is intended to drive homepage copy) — does the positioning translate to a usable visual hierarchy?

**Why not other roles:** strategy artifact, no code or measurement → no engineer / tester / security / data-scientist.

**What "good" looks like:**

- Marketing names ≥3 placeholder values that don't position. "Excel, the status quo" is true of half the world's SaaS market; "growing teams" is unscoped; "AI-powered, fast, easy to use" is adjective marketing (Dunford / Ritson).
- Marketing proposes a tighter alternative for at least 1 component (segment narrowing is the highest-leverage move).
- PM connects positioning to product strategy — is "growing teams" what the roadmap is built around, or is the roadmap built around enterprise security and the positioning is performative?
- The synthesis names a single forcing decision: tighten segment-and-category before going to marketing tactics.

**Anti-patterns to watch for:**

- Marketing approves "growing teams" as specific enough (it isn't).
- PM doesn't engage strategically — treats positioning as marketing-only territory.
- Synthesis offers "iterate on the positioning" without naming the specific high-leverage component to change.

**How to run:**

1. Use a synthetic canvas with deliberately-generic content (the artifact above is suitable).
2. Invoke `multi-role-review` with marketing + PM (and designer if testing 3-role).
3. Score, with particular attention to whether the synthesis surfaced the adjective-marketing failure mode.
