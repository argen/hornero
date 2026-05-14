# Task 05 — Threat model review: customer-support LLM agent

**Shape:** Threat-model critique for an LLM-integrated feature.

**Artifact:** A 1-2-page threat model for a customer-support LLM agent that can read internal docs, query the orders database, and send emails on behalf of the user. The artifact includes a DFD, an actor list, and a STRIDE walk — but no LLM-Top-10 mapping, and no explicit treatment of the lethal trifecta (data + tools + external content).

**Recommended role mix (3):**

- `security-expert` — STRIDE depth, OWASP ASVS coverage, LLM Top 10 mapping, the lethal trifecta lens.
- `software-engineer` — implementation seams the threat model assumes; do the controls actually live where the diagram says?
- `data-scientist` — LLM-eval design implied by the model (refusal eval, adversarial-prompt eval, false-positive cost on the email-sending control).

**Why not other roles:** internal-tools change → no marketing. UI is a wrapper around the agent — designer could be invoked for the human-in-the-loop UX but the threat model is the artifact under review, not the UX.

**What "good" looks like:**

- Security flags the lethal-trifecta concern explicitly (the agent has data + tools + external content all together) with reference to Simon Willison's framing via the security-expert llm-risk-assessment skill or the OWASP LLM Top 10.
- Engineer surfaces ≥1 control that lives in a different place than the threat model assumes (e.g., "the email-sending guard is in app code, but the agent can call the tool directly; the guard doesn't fire").
- Data-scientist proposes an eval set design (adversarial prompts + refusal eval) and names what the false-positive cost is for the email-sending action.
- The synthesis names ≥1 conflict — likely security wanting the email-sending tool removed entirely vs. PM/engineering wanting it gated by approval.

**Anti-patterns to watch for:**

- Security review is generic ("watch out for prompt injection") without naming the specific lethal-trifecta surface in this artifact.
- Engineer review is a code review (the artifact is the threat model, not the code).
- Data-scientist review is missing entirely or wanders into accuracy claims about LLMs.

**How to run:**

1. Use a synthetic or real threat-model artifact.
2. Invoke `multi-role-review` with the three roles.
3. Score, paying particular attention to whether the LLM-specific risks were surfaced (this task is specifically designed to test for them).
