# Task 07 — Experiment readout: pricing change causes ARPU lift

**Shape:** Experiment-readout critique. Tests the **causal-claim** lens specifically.

**Artifact:** A 1-page experiment readout claiming "our pricing tier change caused a 12% ARPU lift among mid-tier customers (p<0.01)." Includes a chart, an n, a baseline, and a recommendation to roll out broadly.

**Twist for the eval:** The "experiment" is **observational** — mid-tier customers self-selected into the new pricing tier; the comparison is to mid-tier customers who didn't migrate. The artifact presents this as causal.

**Recommended role mix (3):**

- `data-scientist` — the load-bearing role; causal-claim audit (Pearl), backdoor identification, sensitivity analysis (E-value), distinction from RCT.
- `product-manager` — what decision does this readout support? Is the recommendation defensible given the claim's strength?
- `marketing-expert` — if the readout drives messaging ("our pricing causes ARPU lift"), the attribution honesty matters (Hoffman).

**Why not other roles:** no PR / code change → no engineer. No accessibility / UI → no designer. No security implications → no security.

**What "good" looks like:**

- Data-scientist names the selection-bias problem explicitly using a DAG: `customer_intent → pricing_choice → ARPU` (with `customer_intent` as the unobserved confounder). Cites Pearl + Rubin or Hernán/Robins.
- Data-scientist proposes the honest options: (a) run a real RCT on subsequent cohort; (b) report as associational; (c) instrument-variable analysis if defensible.
- PM frames the recommendation against the four big risks — viability claim depends on the causal interpretation; the recommendation to roll out broadly is premature if the claim is observational.
- Marketing surfaces attribution-honesty risk — citing 12% causally in messaging when the data is observational is the same shape as last-click-as-truth (Hoffman).
- The synthesis names ≥1 conflict — likely PM wanting to ship with weakened-claim messaging vs. data-scientist wanting to wait for the RCT.

**Anti-patterns to watch for:**

- Data-scientist approves the claim because the p-value is below 0.01 (significance worship, missing the selection bias entirely).
- PM relays the data-scientist finding without examining the recommendation-quality implication.
- Marketing doesn't engage because "the data is engineering's job."

**How to run:**

1. Provide a synthetic readout. The artifact must clearly state that mid-tier customers chose the new pricing (no random assignment).
2. Invoke `multi-role-review` with the three roles.
3. Score, with particular weight on whether the causal-claim audit fired.
