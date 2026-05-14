# Task 09 — Test plan critique: checkout-cart system

**Shape:** Tester-led test plan critique.

**Artifact:** A 2-page test plan for a checkout-cart system about to ship a multi-currency + multi-payment-provider refactor. Includes a Risks table, an HTSM-by-dimension section, and a deliberately-deferred-coverage section. The plan is plausible but has two failure modes seeded: (1) a risk row about Daylight Saving rollover in scheduled cleanup jobs with no idempotency assertion in the mitigation; (2) HTSM Time dimension covers concurrency but doesn't cover replica-lag during deploys.

**Recommended role mix (3):**

- `tester` — load-bearing role; HTSM coverage critique, risk-table evaluation, what's *not* covered and whether the deferral is justified.
- `software-engineer` — does the plan match the actual implementation? Are the test techniques (property-based, integration, contract) plausible for the codebase?
- `product-manager` — does the plan's deferred-coverage section align with the product's risk tolerance? (Cart-abandonment is the load-bearing outcome.)

**Why not other roles:** internal infrastructure, no marketing/positioning surface; no novel measurement; no LLM or auth surface.

**What "good" looks like:**

- Tester surfaces ≥2 specific HTSM coverage gaps that aren't already named in the plan's deferred section.
- Engineer connects ≥1 risk to a real code surface (specific service, specific handler).
- PM names the cost of one of the deferred-coverage items in customer-language (cart-abandonment minutes, refund volume, trust-score impact) — not engineering-language.
- The synthesis distinguishes "missing from the plan" from "deliberately deferred and explicitly noted" — these are different and the rubric's actionability dimension depends on it.

**Anti-patterns to watch for:**

- Tester critiques the plan against an imaginary perfect plan (every HTSM cell populated) rather than against this system's actual risk surface.
- Engineer wanders into product-strategy critique (out-of-lens).
- Three roles return overlapping "more property-based tests" findings (Dimension 2 failure).

**How to run:**

1. Place a plausible test plan at `evals/runs/09-test-plan-checkout-cart/artifact.md` (the `roles/tester/skills/test-plan/SKILL.md` Examples section has a usable template).
2. Invoke `multi-role-review` with tester + software-engineer + product-manager.
3. Score, with particular attention to whether the synthesis distinguished gap-vs-deferred.
