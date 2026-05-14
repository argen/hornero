# John Cutler — distilled

> The Beautiful Mess (Substack), North Star Framework (Amplitude, 2020), and "feature factory" diagnostics. Public writing 2016–present. Cutler is a product evangelist and researcher who translates systems-thinking concepts — feedback loops, second-order effects, local vs. global optimization — into PM practice through visual frameworks, diagnostic heuristics, and long-form essays.

## Why it matters for AI-coding

AI roadmap tools generate flat lists of features ranked by estimated impact. What they miss is the system: how the feature affects adjacent parts of the product, what feedback loops it creates, whether optimizing one metric degrades another. Cutler's contribution is the language and visual vocabulary for making second-order effects visible before they become expensive surprises.

The "feature factory" diagnostic — organizations that treat shipping as progress — is Cutler's version of Perri's build trap, rendered in systems terms: the factory is a local optimum that prevents the global optimum. AI accelerates local optimization and makes global disoptimization harder to see.

## Key concepts the role pulls from

- **North Star Metric.** A single metric that captures product value delivery — not revenue, but the customer behavior that drives revenue. The North Star is positioned between inputs (features, investment) and outputs (revenue, retention) so it names *what the product does for customers*. Used in `cross-functional-orchestration`'s outcome-framing step and in `prd`'s success-metric requirement. The key discipline: one North Star, with leading indicators below it and lagging outcomes above it.
- **Input metrics vs. output metrics.** Cutler's systems framing distinguishes metrics teams can directly influence (inputs: feature adoption, onboarding completion) from metrics that are downstream results (outputs: retention, revenue). Optimizing outputs directly is like pulling on a plant to make it grow. The PM's job is to find the right inputs and let the system do the work. Powers the counter-metric requirement in `prd`.
- **Feature factory diagnostics.** Cutler's "12 Signs You're Working in a Feature Factory" (2016 essay — still widely circulated) provides a diagnostic checklist: no outcome measurement, no follow-up on shipped features, roadmaps as commitments rather than hypotheses, etc. Used as a review heuristic when the PM role flags that a team has slipped into feature-factory mode.
- **Systems mapping.** Making feedback loops visible before they're triggered. Cutler advocates for lightweight system diagrams — not full causal loop diagrams, but enough to name the reinforcing and balancing loops a product change creates. Surfaces the second-order effects AI-generated roadmaps miss.
- **The "work that doesn't feel like work" problem.** Cutler's observation that PM work most valued by organizations (stakeholder management, status updates, roadmap maintenance) is often the work with the least leverage — and vice versa. Aligns with Doshi's LNO framing; together they argue that a PM's leverage is invisible in most org's incentive structure.

## What to actually read (1-hour budget)

- **"12 Signs You're Working in a Feature Factory"** (2016, Medium) — 10 minutes. The single most widely-shared Cutler piece; the diagnostic that named the pattern.
- **The North Star Framework** (Amplitude, 2020) — a short guide (~40 pages), free download. Chapters 1-3 are the conceptual core; the rest is worked examples.
- **The Beautiful Mess** (Substack) — pick 3-5 recent essays. Cutler publishes frequently; the recent work is where the systems-thinking vocabulary is sharpest. Good starting essays: "Continuous Improvement vs. Continuous Disruption," "The Hierarchy of Purpose."

## What to skip

- The later sections of the North Star Framework on cross-team alignment are process-heavy and more useful for a Director+ audience than for an individual PM or an agent adopting the role.
- Cutler's older Medium writing (pre-2018) is foundational in ideas but has been refined; when the Substack version of an idea exists, prefer it.

## How this anchors role skills

- [`prd`](../../roles/product-manager/skills/prd/SKILL.md) — the North Star / input-output metric structure is the implicit model behind the success-metric + counter-metric requirement. A good PRD metric is an input metric in Cutler's vocabulary.
- [`cross-functional-orchestration`](../../roles/product-manager/skills/cross-functional-orchestration/SKILL.md) — systems thinking surfaces when the PM asks "what does this change affect beyond the immediate feature?" before dispatching role reviewers. Cutler's second-order-effects framing is the reason the skill asks for "what are we *not* doing instead."
- General: the feature-factory diagnostic is a review heuristic. When the PM role flags a PRD as "output-shaped" or a roadmap as "commitment-not-hypothesis," the citation is Cutler (alongside Perri, who names the same pattern in organizational terms).

## Cross-role connection

Cutler's systems-mapping practice and the data-scientist role's causal-DAG discipline are close cousins: both make assumptions about causality explicit and visible before those assumptions propagate into decisions. Cutler's loops are qualitative and visual; Pearl's DAGs are formal and mathematical. Together they bracket the range of rigor appropriate to different decision sizes.
