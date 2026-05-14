# Task 18 — Positioning statement critique: platform pivot

**Shape:** PM-led positioning-statement critique with marketing reviewer. **Uses the PM-side `positioning-statement` skill (Moore template), not the marketing-side `positioning-canvas`.**

**Artifact:** A 1-page positioning statement (Moore template) for a B2B SaaS company pivoting from a single-product tool to a platform play:

- "For mid-market finance teams who need to manage spend across multiple vendors, our product is an AI-powered spend platform that gives them visibility, control, and savings. Unlike traditional procurement tools, we focus on the operator's workflow, not the buyer's process."

Three seeded issues: (1) "mid-market" is unscoped (5K-employee firms? 500-employee? both?); (2) "AI-powered" is the canonical Dunford adjective-marketing anti-pattern; (3) the "unlike traditional procurement tools" framing names a category competitor the customer might not even think they're choosing against.

**Recommended role mix (2):**

- `product-manager` — load-bearing on Moore-template execution; does each slot have a falsifiable value? Cites Moore + Dunford (PM-side `sources.md`).
- `marketing-expert` — Dunford anti-positioning critique, Sharp on mental availability, sharpening of competitive-alternatives.

**Why not other roles:** strategy artifact, no engineering / testing / security / data-scientist / designer surface at this stage.

**What "good" looks like:**

- PM names the unscoped "mid-market" as an immediate problem; proposes a tightening (employee range, revenue range, or function-shape: finance teams *with multi-entity reporting*, e.g.).
- Marketing names "AI-powered" as adjective marketing (Dunford); proposes the provable-attribute replacement (specific capability that's testable: "automated GL coding," "vendor-deduplication across legal entities," etc.).
- Marketing also flags the competitive-alternatives framing — "traditional procurement tools" may not be what the customer compares against (more likely: spreadsheets, status-quo workflows). Cites Dunford on competitive alternatives.
- Synthesis names a single forcing decision: rewrite the statement before any external use, with the 3 specific revisions targeted.
- Cross-role consistency: PM and marketing should largely agree (this is a positioning artifact); the rubric's Dimension 3 (conflict-surfacing) may legitimately score *low* here if there's nothing to genuinely conflict on — and the synthesis should say so explicitly.

**Anti-patterns to watch for:**

- PM approves the statement on Moore-template completeness alone (every slot filled), ignoring slot quality.
- Marketing approves "AI-powered" because "everyone says it now" (the canonical Dunford failure mode that the methodology must resist).
- The 2 roles produce identical findings — this is a 2-role review, so some overlap is expected; the rubric's Dimension 2 should reflect that not every task warrants 2+ distinct lenses.

**How to run:**

1. Place the positioning statement at `evals/runs/18-positioning-statement-platform-pivot/artifact.md` (the `roles/product-manager/skills/positioning-statement/SKILL.md` Examples section has the structure).
2. Invoke `multi-role-review` with product-manager + marketing-expert (2 roles).
3. Score, with attention to whether each of the 3 seeded issues surfaced with a named citation.

**Note on Dimension 3:** for 2-role reviews where the roles' lenses converge, "no conflicts found" can legitimately score 1.0 *if* the synthesis names this explicitly. Hiding a non-existent conflict to score points is worse than naming the convergence.
