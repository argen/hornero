# Task 12 — Metric definition critique: "activation rate"

**Shape:** Data-scientist-led metric-definition critique.

**Artifact:** A 1-page metric definition for "weekly activation rate" of a new B2B SaaS product:

- **Definition:** "% of signups that complete onboarding in their first week."
- **Population:** "all signups."
- **Counter-metric:** "none — activation only goes up."
- **Owner:** "Growth team."

In other words: every standard placeholder is present but every component has a problem. The team thinks the definition is shipped; it isn't.

**Recommended role mix (3):**

- `data-scientist` — load-bearing; Kohavi + Goodhart critique, counter-metric required, gaming-surface enumeration, unit-of-analysis sharpening, ownership detail.
- `product-manager` — is "activation" the right outcome for what the product is trying to do? Does "completes onboarding" reflect the customer job, or just the team's funnel?
- `software-engineer` — instrumentation feasibility; is "complete onboarding" a single event or a derived state? Can the metric be computed deterministically from the event log?

**Why not other roles:** internal measurement artifact, no user-visible UI; no novel auth or LLM surface; no marketing copy.

**What "good" looks like:**

- DS names the missing counter-metric as a Goodhart concern (gaming surface: lower the onboarding bar to inflate activation).
- DS sharpens the unit-of-analysis: "signups" → which signups (excluding internal, excluding bot, excluding incomplete-then-deleted)?
- DS proposes ≥2 specific gaming surfaces (skip-step UX changes, automated step-completion).
- PM connects to customer-job — is "completes onboarding" actually evidence of value, or just evidence of completion?
- Engineer flags ≥1 instrumentation question (is the event log idempotent? what about cohorts that signed up before instrumentation shipped?).

**Anti-patterns to watch for:**

- DS approves "activation only goes up" — that's the canonical Goodhart failure; it must be flagged.
- PM treats this as a measurement question instead of a product question (out-of-lens).
- Engineer wanders into product-roadmap critique (out-of-lens).

**How to run:**

1. Place the metric definition at `evals/runs/12-metric-definition-activation/artifact.md` (structure follows a future `data-scientist` role's `metric-definition` skill).
2. Invoke `multi-role-review` with data-scientist + product-manager + software-engineer.
3. Score with attention to whether Goodhart was cited by name (Dimension 1) and whether the counter-metric absence was elevated to a Blocker (Dimension 4).
