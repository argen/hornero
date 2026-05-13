---
name: threat-model
description: Use when a system, feature, or significant change is being designed and the team needs to enumerate what could go wrong, who would cause it, and what the system does about it — before the design ossifies.
intent: |
  Produces or evaluates a threat model anchored to Adam Shostack's
  four questions and STRIDE, with a data-flow diagram that names
  trust boundaries explicitly. Resists threat-modeling-as-ceremony:
  every threat is tied to a plausible adversary with a plausible
  motive, and every threat has either a control or a documented
  acceptance of risk.
type: component
theme: design-time-security
best_for:
  - A new system or major subsystem entering design
  - A significant trust-boundary change (new external integration, new tenant model)
  - Authentication or authorization redesign
  - Adding an AI-acting component (LLM with tool / database / shell access)
  - A high-stakes feature where the worst-case outcome is not contained
scenarios:
  - "Threat model for a new permissions service spanning 6 services"
  - "Re-modeling after introducing an LLM agent that can invoke admin tools"
  - "Threat model for a redesigned multi-tenant data isolation boundary"
  - "Threat-modeling a vendor's webhook integration that triggers domain actions"
estimated_time: 2-4 hours (small system); 1-2 days (major subsystem); revisited each significant change
---

# Threat model

> v0 draft. Grounded in Adam Shostack's *Threat Modeling: Designing for Security* (2014) and his "Four Question Framework," Microsoft's STRIDE methodology (Howard & Lipner, formalised by Shostack), Bruce Schneier's *Secrets and Lies* (2000), MITRE's CWE/ATT&CK taxonomies, and OWASP's Threat Modeling Cheat Sheet.

## Purpose

Produce a threat model that:

1. **Names what is being protected**, not vaguely ("the system") but specifically (the user-data store; the authorization service; the cryptographic key store).
2. **Names the adversary and their motive**, plausibly — not "a hacker" but "a logged-in customer trying to read another customer's data," "a curious internal employee with read-only DB access," "a credential-stuffing botnet."
3. **Walks the system through STRIDE** — Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege — against a data-flow diagram.
4. **For each plausible threat, names a control or an accepted risk** — not "this is mitigated" with no specifics.
5. **Closes with Shostack's fourth question** — "did we do a good job?" — which forces the model to be evaluated, not just produced.

A threat model that does not name an adversary, does not have a DFD, or does not pair threats with controls is not a threat model. It is a worry list, which is a less-useful artifact.

## Key Concepts

### Shostack's four questions

Adam Shostack frames threat modeling as four questions, in order:

1. **What are we working on?** Describe the system. A DFD here, not prose.
2. **What can go wrong?** Walk the system through STRIDE (or another taxonomy if the context warrants it).
3. **What are we going to do about it?** Per threat: control, mitigation, or accepted risk.
4. **Did we do a good job?** Review the model against criteria: did we name plausible adversaries? Did we cover the trust boundaries? Did we miss a category?

Step 4 is the most-skipped and the most load-bearing. Without it, every threat model is "done" the moment it's written; the team never learns whether the model was good.

### STRIDE

Microsoft's mnemonic for threat categories, formalised in Shostack's writing:

- **S**poofing — pretending to be someone you're not. Authentication failures.
- **T**ampering — modifying data in transit, at rest, or in flight.
- **R**epudiation — performing an action and denying it; absence of audit.
- **I**nformation disclosure — data leak; unintended read access.
- **D**enial of Service — making a service unusable for legitimate users.
- **E**levation of Privilege — gaining capabilities one shouldn't have.

STRIDE is exhaustive against the threats it categorises but is not the only taxonomy. For LLM-touching systems, the OWASP LLM Top 10 may be more useful; for cloud systems, MITRE ATT&CK for cloud may surface threats STRIDE misses. The skill uses STRIDE as the *default* spine; substitution requires reasoning.

### Data-flow diagrams (DFDs) over architectural diagrams

A DFD shows **data**, **processes**, **data stores**, **external entities**, and **trust boundaries**. The trust boundary is the most important element — every boundary is where threat surface concentrates.

A box-and-arrow architecture diagram is not a DFD. The DFD adds:

- Direction of data flow (which way information moves).
- Trust boundaries (explicit dotted lines across which trust does not extend).
- Data classification (confidential, sensitive, public) where it changes meaning.

The Microsoft Threat Modeling Tool, OWASP Threat Dragon, and pen + paper all produce serviceable DFDs. Tool choice doesn't matter; the DFD existing matters.

### Adversary, plausibly

Schneier and Kim Zetter both make the case: threats are concrete. The model names:

- **Who** — a logged-in customer; a former employee with revoked credentials; a credential-stuffing bot; a nation-state actor targeting our specific vertical. The realism calibrates the depth of control needed.
- **Why** — financial gain; reputational damage; data resale; service disruption. Motive shapes which threats are likely vs. theoretical.
- **What budget** — script-kiddie effort (hours); commodity attacker (days); targeted attacker (weeks, custom tooling); nation-state (months, zero-days). Budget determines whether costly controls are warranted.

A threat model whose adversary is "a hacker" with no further specification has done none of this work.

### Each threat → control OR accepted risk

For every identified threat, the model produces one of three outcomes:

- **Mitigated** — a specific control is named (auth check at endpoint X; rate-limit on Y; logging at Z); the control is testable; the test is named or planned.
- **Transferred** — risk is moved (insurance, contract, third party); document who carries the risk.
- **Accepted** — the team has explicitly decided to accept this risk; document the decision-maker, the date, and the reason.

The default of *unnamed* is the failure: a threat that is "noted" without explicit outcome will be neither mitigated nor revisited.

### Trust boundaries are where the work is

In any DFD, the highest threat density is at trust boundaries: where data crosses from untrusted to trusted (user → service), from one trust domain to another (service → admin tool), or where assumed trust may not hold (internal network → service, in a zero-trust posture).

The model spends most of its analysis budget at boundaries. Interior data flows can be treated more lightly unless they cross sub-boundaries.

### Living document, revisited

A threat model written once at design and never updated drifts out of sync as the system evolves. Revisit triggers:

- **Significant change** — new boundary, new data class, new dependency, new threat actor identified.
- **Incident** — every incident's post-mortem updates the model.
- **Periodic refresh** — annual minimum for high-stakes systems.

## Application

### Step 1 — Frame and scope

Define the scope precisely. Heuristics:

- **A system or subsystem** is the right scope (the cart-service, the auth-service, the LLM-agent runtime).
- **A feature** is a scope only if the feature crosses trust boundaries or introduces a new one.
- **The whole product** is too big — split into subsystems and model each.

State the **scope boundaries** explicitly. Anything outside scope is named and deferred.

### Step 2 — Gather pre-reads

The threat model rests on artifacts produced elsewhere:

- The product's PRD or RFC.
- The system's architecture diagram (the starting point for the DFD).
- The data classification scheme in use (PII / PCI / PHI / business-confidential / public).
- Any prior threat model for adjacent systems.
- The team's threat-actor inventory (if maintained).

### Step 3 — Draw the DFD

Either pen-and-paper, OWASP Threat Dragon, the Microsoft tool, or in a doc. The DFD includes:

- **External entities** — users, third-party services, external APIs.
- **Processes** — services, functions, jobs.
- **Data stores** — databases, caches, queues, file systems.
- **Data flows** — directional arrows showing data movement.
- **Trust boundaries** — dotted lines crossing flows that span trust domains.

The DFD does not need to be pretty; it needs to be readable. Box-arrow on a whiteboard photo is fine.

### Step 4 — Name the adversaries and motives

Before walking STRIDE, list:

```markdown
## Adversaries

### A1 — Logged-in customer trying to read another customer's data
- Plausibility: high (multi-tenant SaaS)
- Budget: minutes; trivial scripting
- Motive: curiosity; data harvesting; competitive intelligence
- Relevant prior incidents: BUG-1119 (2024) IDOR on /api/orders

### A2 — Credential-stuffing botnet
- Plausibility: high (consumer product)
- Budget: cheap commodity tooling
- Motive: account takeover; gift-card resale
- Relevant prior incidents: Q3 2025 wave (12k attempted logins/hour peak)

### A3 — Former employee with revoked credentials
- Plausibility: medium (we offboard well; vendor-managed
  credentials lag)
- Budget: low; insider knowledge advantage
- Motive: reputational damage; data exfiltration
- Relevant prior incidents: none observed; vendor-side incident
  reported 2024-Q2

### A4 — Targeted attacker (nation-state or organised crime)
- Plausibility: low for our vertical (small-medium SaaS)
- Budget: high; could justify zero-days
- Motive: data resale (PII for our customer base)
- Treatment: model considers but defers exhaustive coverage to
  a higher-tier review
```

The model's depth scales with the highest-plausibility adversary.

### Step 5 — Walk STRIDE

For each element of the DFD (each process, each data store, each flow crossing a trust boundary), walk through STRIDE categories:

For each (element, S/T/R/I/D/E) pair, ask: **is this threat plausible for at least one named adversary?** If yes, name it; if no, skip silently.

Record findings in a table:

```markdown
## STRIDE pass

| # | Element | Category | Threat | Adversary | Likelihood | Impact | Control / Outcome |
|---|---------|----------|--------|-----------|------------|--------|-------------------|
| 1 | /api/orders endpoint | S | A1 can spoof another user by manipulating session cookie | A1 | M | High (read other customers' orders) | Session signed with HS256; secret in HSM; rotated quarterly. Test: TC-1001. |
| 2 | /api/orders endpoint | I | A1 can read /api/orders/{id} for another user's id (IDOR) | A1 | H | High (per BUG-1119) | Authorization check at endpoint: order.user_id == session.user_id. Test: TC-1019, TC-1020 (regression for BUG-1119). |
| 3 | login endpoint | D | A2 can mount credential stuffing | A2 | H | M (degrades service; takeover risk for re-used passwords) | Rate limit per-IP (30/min) + per-account (10/hr); CAPTCHA at >5 failures; HIBP check on registration; impossible-travel detection. Test: TC-2001-2004. |
| 4 | admin /api/internal | E | A3 with stale token could escalate to admin | A3 | L | High (full data access) | Tokens revoked on offboarding; token TTL ≤24h; admin tokens require fresh login. Test: TC-3001. **Risk acknowledged:** vendor-managed credentials (Auth0) have 1-hour offboarding lag — accepted by CISO 2025-09-02. |
```

### Step 6 — Pair threats with controls or document acceptance

Every entry in the table has an outcome:

- **Control + test.** The standard outcome. The control is testable; the test exists or is planned with a tracker entry.
- **Accepted risk.** Named decision-maker; date; reason.
- **Deferred.** The threat is real but out of scope for this model; pointer to where it will be addressed.

A threat with no outcome is the bug the model exists to prevent.

### Step 7 — Did we do a good job? (Shostack's Q4)

Self-evaluate against checks:

1. **Adversary realism.** Did we name plausible adversaries with motives and budgets? Did we resist the "hacker" abstraction?
2. **DFD completeness.** Does the DFD cover every trust boundary in the system? Have we marked data classifications where they change?
3. **STRIDE coverage.** Did we walk STRIDE against every element on the DFD, or only the obvious ones?
4. **Control specificity.** Are controls specific (named, testable), or are they "we'll handle it"?
5. **Accepted risks named explicitly.** No silent acceptance.
6. **AI surface considered.** If the system uses LLMs that take action on user input, did we run the OWASP LLM Top 10 in addition to STRIDE? (See [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md).)
7. **Review.** Was the model walked through with engineering and PM? Were objections logged?

Record the evaluation as the model's own appendix. The next refresh starts here.

### Step 8 — Walk with the team

The model is reviewed with the engineers building the system, the PM accountable for it, and (when relevant) the SRE on-call. Reviewers can contest any threat, control, or risk acceptance — they cannot contest the existence of the DFD or the adversary list.

Disputes get logged with the dispute and a decision date.

### Step 9 — Hand off and store

The threat model lives in the repo (or the security-docs repo). It is referenced from RFCs, ADRs, and PR descriptions when the system is changed. Each change to the system checks the model for currency.

## Examples

### Example 1 — Useful threat row (good)

```markdown
| 7 | session-cookie validation | T | A2 / A3 could tamper with session cookie payload to escalate role | A2 (credential-stuffer post-login); A3 (with stolen cookie) | M | High (admin escalation) | Session signed with HS256 (key in HSM, rotated quarterly); signature verified on every request; role field server-validated against fresh DB read every 10 minutes regardless of cookie payload. Test: TC-1107. **Note:** the 10-minute revalidation is a deliberate trade-off between staleness and DB load; reduces to 1-minute under elevated-risk mode (post-incident). |
```

The reviewer can argue with the 10-minute window; they can verify TC-1107 exists; they can trace HSM placement. The threat is actionable.

### Example 2 — Failure mode (bad)

```markdown
## Threats
- Hackers could attack the system.
- We should be careful with data.
- Login should be secure.
- We use HTTPS.

## Mitigations
- HTTPS everywhere.
- Strong passwords.
- We monitor for issues.
```

Failures: no adversaries; no DFD; no STRIDE pass; threats are not threats but worries; "mitigations" are not controls but slogans. The model has done nothing.

## Common Pitfalls

### Pitfall 1 — Threat modeling without a DFD

**Symptom:** Threats are listed prose-style, not against a diagram.

**Consequence:** Threats cluster around the obvious surfaces (login); interior boundaries and inter-service flows go unexamined. Trust boundaries are invisible until incidents reveal them.

**Fix:** DFD is non-negotiable. Whiteboard photo, OWASP Threat Dragon, even pen on paper.

### Pitfall 2 — "Hacker" as adversary

**Symptom:** Threats describe "hackers" or "attackers" generically.

**Consequence:** No way to calibrate control investment. Defenses end up either uniform (over-protect commodity threats, under-protect targeted ones) or vague (no defense matches the implicit threat actor).

**Fix:** Name specific, plausible adversaries with motive and budget. The adversary list is the calibration lens.

### Pitfall 3 — STRIDE as tickbox

**Symptom:** Each element gets one threat per STRIDE category, mechanically generated, none of them realistic.

**Consequence:** The model has 200 threats; the team can't act on any of them; the model is shelved.

**Fix:** A STRIDE entry exists only when at least one named adversary plausibly pursues it. Mechanical entries are deleted, not "noted."

### Pitfall 4 — Threats without outcomes

**Symptom:** The threats table has no Control / Outcome column, or that column says "TBD" for half the rows.

**Consequence:** The model identifies threats but doesn't move the team toward defense. Threats accumulate as a backlog the team never works.

**Fix:** Each threat has Mitigated / Transferred / Accepted / Deferred. No silent unaddressed threats.

### Pitfall 5 — Threat modeling as ceremony

**Symptom:** The model is 40 pages, full of taxonomies and methodology references. Nobody reads it after it's filed.

**Consequence:** The model is performative. Real work happens despite it, not informed by it.

**Fix:** Length is a smell. A useful model fits on 3-6 pages plus the DFD. Long appendices are deferred references, not the main artifact.

### Pitfall 6 — Skipping Shostack's Q4

**Symptom:** The model has no "did we do a good job?" section.

**Consequence:** The model is "done" the moment it is written. The team never gets better at threat modeling because they never evaluate.

**Fix:** Q4 is its own section. Self-evaluation against criteria (adversary realism, DFD completeness, STRIDE coverage, etc.).

### Pitfall 7 — AI surfaces ignored

**Symptom:** A system has an LLM that processes user input and can invoke tools; the threat model treats the LLM as "a function."

**Consequence:** Prompt injection is the most likely attack surface; the model didn't address it.

**Fix:** Add the OWASP LLM Top 10 pass alongside STRIDE for systems where LLMs act on untrusted input. See [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md).

### Pitfall 8 — One-shot model, never revisited

**Symptom:** Model was written at launch; the system has since added two new boundaries.

**Consequence:** Real threats live in the new boundaries; the model doesn't see them; defense ages out.

**Fix:** Revisit triggers stated in the model. Significant change OR incident OR annual minimum.

## References

- **Adam Shostack** — *Threat Modeling: Designing for Security* (2014); the canonical book on STRIDE practice; the Four Question Framework is his. See `roles/security-expert/sources.md`.
- **OWASP** — [Threat Modeling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html); [Threat Dragon](https://owasp.org/www-project-threat-dragon/) as a free DFD tool.
- **Microsoft** — STRIDE methodology origin; the Microsoft Threat Modeling Tool ([aka.ms/tmt](https://aka.ms/tmt)).
- **Bruce Schneier** — *Secrets and Lies: Digital Security in a Networked World* (2000); the systems-thinking argument behind defense in depth.
- **MITRE** — [CWE](https://cwe.mitre.org/) (Common Weakness Enumeration) and [ATT&CK](https://attack.mitre.org/) (adversary tactics, techniques, and procedures); useful taxonomies for adversary motive/budget specification.
- **Kim Zetter** — *Countdown to Zero Day* (2014); case-driven realism about what real adversaries actually do.
- **Related Hornero skills:**
  - [`security-review`](../security-review/SKILL.md) — point-in-time review at code review or pre-launch; the model is the design-time complement.
  - [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md) — companion analysis for LLM-acting systems; runs alongside STRIDE.
  - [`pre-launch-security-audit`](../pre-launch-security-audit/SKILL.md) — workflow that runs threat-model + security-review + LLM-risk-assessment together at launch.
  - `roles/software-engineer/skills/rfc/SKILL.md` — RFCs touching sensitive surfaces should reference the threat model in their Risks section.
  - `roles/tester/skills/test-plan/SKILL.md` — controls identified here feed test cases in the plan's HTSM Structure / Operations rows.
