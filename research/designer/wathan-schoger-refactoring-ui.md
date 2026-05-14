# Adam Wathan & Steve Schoger — distilled

> *Refactoring UI* (2018). The engineer-authored design tactical guide: specific visual-polish decisions that take a surface from "engineer-built" to "designed," without requiring a full design education.

## Why it matters for AI-coding

AI-generated UI looks engineer-built. The tells are consistent across generation sessions: everything is rounded-2xl; shadows are heavier than the hierarchy warrants; text is center-aligned regardless of content length; spacing is uniform rather than hierarchical; every section header is the same visual weight; colour is used for decoration rather than information. *Refactoring UI* is the most direct corrective in the methodology's bibliography because it operates at exactly the level AI generation fails: not "understand design theory" but "here is the specific change — use a type scale instead of ad-hoc sizes; decrease border radius on non-interactive containers; use neutral greys for supporting text." These are the fixes an AI implementation agent can apply from a design review finding if the finding names them specifically.

The methodology cites Wathan/Schoger in the design-review skill's visual-coherence step as the source of both the AI-aesthetic anti-pattern checklist and the specific remediation vocabulary.

## Key concepts the role pulls from

- **Type scale over ad-hoc sizes.** A defined type scale (8-12 steps from xs to 5xl) with clear semantic roles (display, heading, subheading, body, caption) eliminates one of the most pervasive AI generation tells: text sizes that are all different but none are intentionally different. The scale creates visual rhythm; ad-hoc sizes create visual noise.
- **Spacing rhythm and the constraint system.** Wathan/Schoger argue for a spacing scale (4px base grid) rather than arbitrary spacing. The practical implication: padding and margin values should come from the scale. AI-generated UI uses arbitrary values (11px, 27px, 13px) that produce an uneven visual rhythm even when each individual decision looks locally reasonable.
- **Colour hierarchy, not colour decoration.** Colour earns its place by communicating status, hierarchy, or interaction affordance — not by adding visual interest. The AI-aesthetic anti-pattern: using a brand colour on decorative elements, producing a surface that feels busy and reads as generic. Wathan/Schoger's discipline: neutralise the default palette; add colour back only where it carries semantic weight.
- **Empty space is not empty.** Generous whitespace around elements is not wasted space — it creates hierarchy by separation. AI generation tends to fill available space; Wathan/Schoger argue that deliberate emptiness is the highest-leverage spacing decision.
- **Shadows and borders as hierarchy tools.** Overuse of drop shadows and borders is a canonical AI-aesthetic tell. Wathan/Schoger argue: use a shadow OR a border to create separation, not both; use the lightest shadow that achieves the purpose; reserve heavier shadows for elements that are genuinely elevated (modals, popovers) rather than applying them to all cards.
- **The "designed not decorated" heuristic.** The most concise formulation from the book: every visual decision should be a communication decision. If you cannot state what information a visual treatment is communicating, it is decoration. Decoration should be removed.

## What to actually read (1-hour budget)

- The book has no chapters in the traditional sense — it is a sequence of tactics. Read the **typography section** first (type scale, weight hierarchy, line height), then the **spacing section**, then the **colour section**. ~60-80 minutes to cover these three. The rest is valuable but lower-priority for the methodology.
- *Refactoring UI* is available as a PDF; the tactics are illustrated with before/after examples that are the argument. Read while looking at actual UI you're working on — the apply-immediately format is the book's design.

## What to skip

- The sections on icons and imagery — important for product design but lower-priority for the methodology's current skill set, which focuses on typography, spacing, colour, and layout.
- The book does not have a formal sections-to-skip structure; if time is short, the typography and spacing sections carry the most weight.

## How this anchors role skills

- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — load-bearing. The visual-coherence step's AI-aesthetic checklist (rounded-2xl + shadow + gradient + center-everything) is Wathan/Schoger's anti-pattern vocabulary. The skill cites this work explicitly in its References and Key Concepts.
- [`state-audit`](../../roles/designer/skills/state-audit/SKILL.md) — the audit's observation that "AI-aesthetic spinners and 'Something went wrong' copy" are the consequences of improvised states is a Wathan/Schoger observation: when states are not designed deliberately, they default to visually generic.
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Wathan/Schoger's "designed not decorated" heuristic is the practical instantiation of Nielsen's H8 (Aesthetic and minimalist design). A heuristic-review finding that cites both Nielsen's principle and Wathan/Schoger's specific pattern is more actionable than one citing only the abstract heuristic.

## Cross-role connection

*Refactoring UI* is the most-cited cross-role anchor in the methodology — specifically the engineer/designer boundary. The book exists because engineers frequently own UI implementation without design support, and the gap between "it works" and "it looks designed" is a specific, learnable set of decisions. The engineer's refactor-plan skill and the designer's design-review skill both reference Wathan/Schoger because the visual-polish fixes the book describes are often *refactoring targets*: the same component re-implemented with a type scale, a spacing system, and a stripped-down colour hierarchy. When an engineer is asked to "make it look more professional" and the designer is asked to "make this easier to implement," Wathan/Schoger is the meeting point — a shared vocabulary of specific, buildable visual decisions.
