# Task 14 — Strategic narrative critique: early-stage startup

**Shape:** Marketing-led strategic-narrative critique.

**Artifact:** A 2-page strategic narrative (Raskin 5-part: problem of the old, change in the world, promised land, magic gift, evidence) for a Series-A B2B fintech startup that wants to "redefine compliance reporting for mid-market companies." The narrative is plausible but has three issues: (1) "change in the world" is generic ("AI is changing everything"); (2) "magic gift" describes the *product* not the *enabling-attribute that makes the promised land reachable*; (3) "evidence" is a single anecdotal customer quote and a hand-wave "we've spoken to 50 prospects."

**Recommended role mix (2):**

- `marketing-expert` — load-bearing; Raskin 5-part + Dunford positioning anchoring + Sharp on mental availability.
- `product-manager` — does the narrative match the product strategy? Is the "promised land" actually buildable on the current roadmap, or is the team selling a future they can't deliver?

**Why not other roles:** strategic marketing artifact, no code / security / measurement / UI surface that needs reviewing at this stage.

**What "good" looks like:**

- Marketing names each of the 3 issues specifically — generic "change in the world" cited as Raskin failure mode, magic-gift-as-product-not-attribute as Dunford anti-positioning, evidence-thinness as Sharp/mental-availability failure.
- Marketing proposes a sharper "change in the world" (a specific shift, datable if possible — new regulation, new buyer behaviour, new economic constraint).
- PM connects narrative-promise to roadmap-reality — flags any gap between what the narrative says and what's on the next 4 quarters' roadmap.
- Synthesis recommends a single forcing decision: revise the 3 weakest sections of the narrative before any external use, OR revise the roadmap to match the narrative's promise. Naming both options matters.

**Anti-patterns to watch for:**

- Marketing approves "AI is changing everything" — it's the most-cited generic narrative opening; flagging it is the test.
- PM treats this as marketing-only territory (it isn't — narrative-vs-roadmap consistency is a PM concern).
- Synthesis offers "tighten the narrative" without naming the specific high-leverage section to revise.

**How to run:**

1. Place the strategic narrative at `evals/runs/14-strategic-narrative-startup/artifact.md` (the `roles/marketing-expert/skills/strategic-narrative/SKILL.md` Examples section has the structure).
2. Invoke `multi-role-review` with marketing-expert + product-manager.
3. Score with attention to whether each of the 3 seeded weaknesses surfaced with a named citation.
