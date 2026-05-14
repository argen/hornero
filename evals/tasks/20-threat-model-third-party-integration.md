# Task 20 — Threat model: third-party integration

**Shape:** Security-led threat model for a third-party integration. **A separate threat-model shape from task 05 (which was LLM-specific).**

**Artifact:** A 1-page proposal to integrate with a third-party expense-management tool (similar to Ramp / Brex / Pleo) via their REST API. The integration: (1) pulls transaction data into our product (read), (2) creates expense reports on user demand (write), (3) supports OAuth-based per-user auth. The proposal includes a system diagram (with a missing trust boundary at the OAuth callback), an auth-flow description, a data-flow description, and a "we'll handle errors" placeholder. Three seeded issues: (1) the OAuth callback trust boundary is unmarked; (2) the token-refresh flow isn't described; (3) the write-path (creating expense reports) has no rate-limit / per-user authorisation check.

**Recommended role mix (3):**

- `security-expert` — load-bearing; Shostack 4-question + STRIDE-per-element + DFD with trust boundaries; OWASP-aligned findings.
- `software-engineer` — auth-flow implementation correctness; idempotency of the create-expense write; error-path completeness.
- `product-manager` — is the integration's value proposition aligned with the auth-and-data complexity? Is the user-experience consequence of OAuth misery acceptable for the customer segment?

**Why not other roles:** internal integration, no marketing / data-scientist surface; designer review applies only if there's a UI flow being added (the proposal doesn't include UI design yet — that's a separate later artifact).

**What "good" looks like:**

- Security draws (or names what the DFD would include) the system with trust boundaries marked — specifically the OAuth callback, the third-party API surface, and the token store. Cites Shostack on STRIDE-per-element.
- Security catches each of the 3 seeded issues: OAuth-callback trust boundary unmarked (Spoofing concern), token-refresh undefined (Information disclosure + Repudiation concern), write-path auth missing (Elevation of Privilege concern). Each cited to STRIDE.
- Engineer surfaces the create-expense idempotency question — if the user retries because the API call timed out, do we create two expense reports?
- PM frames the value-vs-complexity question — if 80% of users will hit OAuth-refresh edge cases, the integration's value-prop must justify that UX cost.
- Synthesis names a single forcing decision: address the 3 seeded findings + idempotency before approving the build, OR proceed with a written acceptance of those risks as known and time-bounded.

**Anti-patterns to watch for:**

- Security cites OWASP generically ("OWASP A02:2021 — broken authentication") without naming the specific control violated (Dimension 1 failure).
- Security misses the trust-boundary issue because the DFD wasn't drawn (Shostack: "no DFD" is itself a finding).
- Engineer or PM wanders into security territory; security wanders into product-strategy. The 3 lenses are intentionally specific.

**How to run:**

1. Place the integration proposal at `evals/runs/20-threat-model-third-party-integration/artifact.md` (the `roles/security-expert/skills/threat-model/SKILL.md` Examples section has the structure for the threat-model output, which is what we expect security to *produce*, not what we're scoring).
2. Invoke `multi-role-review` with security-expert + software-engineer + product-manager.
3. Score with attention to whether the trust-boundary issue made it through the synthesis (Dimension 4 — the recommendation must include drawing the boundary, not just noting its absence).
