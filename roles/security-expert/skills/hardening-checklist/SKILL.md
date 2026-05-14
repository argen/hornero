---
name: hardening-checklist
description: Use when a service or system needs a context-specific control inventory — what security controls should be in place, mapped against the actual attack surface and assets, at ASVS levels with NIST 800-53 and ATT&CK mitigations overlay.
intent: |
  Produces a tailored control table for a specific system: not a generic
  best-practices listicle but a mapping of required controls to the system's
  real assets, trust boundaries, and threat actors. Anchored to OWASP ASVS
  as the control catalogue, NIST SP 800-53 for regulated-industry overlay,
  MITRE ATT&CK mitigations as adversary-anchored vocabulary, and Shostack's
  four-question framing to keep the checklist honest — controls that don't
  trace to a threat model are checklist theatre.
type: component
theme: hardening
best_for:
  - Pre-launch control gap analysis for a new service
  - Periodic hardening review against a shifted attack surface
  - SOC 2 / ISO 27001 / HIPAA control-readiness evidence gathering
  - Post-incident hardening after a control failed in the real world
scenarios:
  - "Produce a hardening checklist before we move this payment service to production"
  - "Map our auth service controls to ASVS Level 2 for the compliance review"
  - "Assess which ATT&CK mitigations we're missing after the credential-stuffing incident"
  - "Generate a control inventory for the new LLM-backed pipeline that has DB access"
estimated_time: 2-4 hours (focused service); 1-2 days (multi-service or regulated-environment scope)
---

# Hardening checklist

> v0 draft. Anchored to OWASP ASVS v4.0.3 (control catalogue), OWASP Top 10 (2021) (failure-mode taxonomy), NIST SP 800-53 r5 (federal/regulated overlay), MITRE ATT&CK Mitigations (adversary-anchored control vocabulary), and Adam Shostack's four-question framing (a checklist that doesn't trace to a threat model is checklist theatre).

## Purpose

Produce a control inventory that:

1. **Is specific to the system at hand** — not a generic ASVS download, but a table where each control row has been evaluated against the system's real assets, trust boundaries, and plausible adversaries.
2. **Covers the attack surface** — the set of controls required maps to what an adversary would actually pursue, traced through ATT&CK mitigations where applicable.
3. **States applicability honestly** — a control is Always/Conditional/N/A with reasoning, not assumed universally applicable.
4. **Captures implementation status** — In-place/Partial/Missing with an evidence pointer so the table is both a gap analysis and an evidence register.
5. **Prioritises** — Blocker/Concern/Note tells the team what to act on before launch versus what to track.

A hardening checklist that does not trace to a threat model is checklist theatre (Shostack). The first question is always: what adversary, against which assets, justifies this control? Controls without that answer are decoration.

## Key Concepts

### OWASP ASVS — the control catalogue

OWASP's Application Security Verification Standard (v4.0.3) organises ~280 testable requirements into categories (authentication, session, access control, API, crypto, error/logging, files, configuration, communications, malicious, business logic, files, data protection) at three levels:

- **Level 1** — minimum bar for all web applications; broad, relatively shallow.
- **Level 2** — standard for most applications handling sensitive data; the default starting point for hardening-checklist work.
- **Level 3** — for high-value targets (financial systems, healthcare, critical infrastructure); adds cryptographic resistance and deeper defenses.

Level selection is not automatic. The skill maps the system's assets and adversaries to a recommended level; the team can override with documented reasoning.

ASVS is the *floor*, not the ceiling. Passing ASVS Level 2 does not mean the system is secure. It means the system satisfies the Level 2 controls — a necessary but not sufficient condition.

### NIST SP 800-53 — the regulated-industry overlay

NIST's control catalogue is the compliance reference for US federal systems and widely adopted for SOC 2, ISO 27001, HIPAA, and FedRAMP contexts. For hardening-checklist purposes, the key use is:

- **Control families as overlay.** When the system operates in a regulated context, the checklist's coverage extends to 800-53 control families (AC — Access Control; AU — Audit; IA — Identification and Authentication; SC — System and Communications; SI — System and Information Integrity; etc.).
- **Mapping.** NIST SP 800-53 controls map onto ASVS categories. The checklist cites both where they overlap, reducing duplication in regulated environments.
- **AI RMF for AI-acting components.** For systems that invoke models, the NIST AI RMF adds governance, accountability, and transparency controls beyond ASVS's scope.

### MITRE ATT&CK Mitigations — adversary-anchored controls

ATT&CK's Mitigation objects (prefixed M####) are controls documented as countering specific adversary techniques. For hardening-checklist purposes:

- **Technique → Mitigation.** When a threat model names an ATT&CK technique (e.g., T1110 — Brute Force), the corresponding mitigation (M1036 — Account Use Policies) is the control vocabulary.
- **Adversary-anchored applicability.** A control whose mapped ATT&CK technique is not plausible for this system's threat actors can be rated Conditional or N/A — it's not a universal requirement.
- **ATT&CK for Containers / Cloud.** For cloud-native or containerized systems, the ATT&CK Cloud and Containers matrices surface controls ASVS doesn't reach (container escape, lateral movement within a cluster, cloud-API abuse).

### Shostack's hardening check: does this trace to a threat?

A hardening checklist uncoupled from a threat model is "checklist theatre." Before marking a control as required, ask:

1. **What can go wrong** (Shostack Q2) that this control addresses?
2. **Which adversary** from the threat model pursues this? If none, is the threat plausible anyway?
3. **Is the control actually testable** — i.e., can someone verify it's in place? (Untestable controls are placeholders, not defenses.)

Controls surviving this filter have a reason to exist. The checklist table cites that reason in the Applicability column.

### Control table schema

Each row of the control inventory:

| Control | ASVS Ref | NIST 800-53 | Applicability | Status | Evidence | Priority |
|---------|----------|-------------|---------------|--------|----------|----------|

- **Control** — short name and description.
- **ASVS Ref** — section + requirement number (e.g., V2.1.1).
- **NIST 800-53** — control family + ID (e.g., IA-5) where mapped; omit if N/A to context.
- **Applicability** — Always / Conditional (with stated condition) / N/A (with reasoning).
- **Status** — In-place / Partial (with gap stated) / Missing.
- **Evidence** — link to config, test, doc, ticket.
- **Priority** — Blocker (launch-blocking gap), Concern (should fix; doesn't block), Note (informational; low risk).

## Application

### Step 1 — Anchor to the threat model

Read the system's threat model before building the checklist. Extract:

- **Assets** — what is worth protecting (user PII, credentials, financial data, internal docs, service availability).
- **Adversaries and motives** — the plausible actors and their techniques.
- **Trust boundaries** — where controls concentrate.
- **ATT&CK techniques** — if the threat model named them; if not, map adversary behaviors to ATT&CK manually.

If no threat model exists, write a brief adversary-and-asset summary inline (and open a finding that a full threat model is pending). Do not produce a checklist without this anchor — the result will be unfocused.

### Step 2 — Select ASVS level

Based on assets and adversaries:

- **Level 1** — public, low-sensitivity service; no PII or financial data; low-plausibility targeting.
- **Level 2** — SaaS handling user data, credentials, or business-sensitive information; the default.
- **Level 3** — high-value targets: payment processors, healthcare records, identity providers, government systems.

Document the level selection and the reasoning. The team may override; document the override.

### Step 3 — Identify regulated-industry requirements

Check whether any of the following apply:

- **GDPR / CCPA** — PII data; data-subject rights.
- **HIPAA** — protected health information.
- **PCI-DSS** — cardholder data.
- **FedRAMP / SOC 2 / ISO 27001** — contractual or audit requirements.
- **NIST AI RMF** — AI-acting components in regulated contexts.

For each applicable framework, add the relevant NIST 800-53 control families to the checklist scope.

### Step 4 — Build the control table

Walk ASVS at the selected level, category by category. For each requirement:

1. **Assess applicability** — is this control relevant given the system's architecture? Mark Always, Conditional (state the condition), or N/A (state the reasoning).
2. **Check status** — evaluate the system's actual implementation. In-place (with evidence), Partial (note the gap), or Missing.
3. **Assign priority** — Blocker if Missing and high-impact; Concern if Partial or lower-impact Missing; Note if informational.
4. **Map to ATT&CK** — for high-priority rows, cite the ATT&CK technique the control counters and the ATT&CK Mitigation ID.

Do not mark a control In-place without evidence. "We think we have this" is Partial at best.

### Step 5 — Produce the summary

After the table:

- **Blocker count.** How many launch-blocking gaps.
- **Concern count.** How many non-blocking gaps to track.
- **Adversary coverage.** For each named adversary from the threat model, which techniques are now covered by controls and which are not.
- **Recommendation.** Go (all Blockers resolved) / Fix-then-go (Blockers remain; work-in-progress) / Hold (Blockers are structural and can't be fast-patched).

### Step 6 — Track and re-evaluate

The checklist is not a one-shot artifact. Re-evaluate:

- When a significant change is made to the system's architecture or data model.
- After an incident (new Missing row to explain the failure).
- On the compliance cycle for any applicable framework.
- When the threat model is updated (new adversaries may require new controls).

## Examples

### Example 1 — Partial control table for an auth service (ASVS Level 2)

Context: a login + session service handling user credentials; multi-tenant SaaS; threat model adversaries include credential-stuffing bots and a logged-in user attempting horizontal privilege escalation.

| Control | ASVS Ref | NIST 800-53 | Applicability | Status | Evidence | Priority |
|---|---|---|---|---|---|---|
| Passwords hashed with Argon2id (min m=65536, t=1, p=4) | V2.4.1 | IA-5(1) | Always | In-place | `auth/crypto.py:42`; test TC-AUTH-001 | — |
| Account lockout after ≥ 10 failed attempts (per account, not per IP) | V2.2.1 | AC-7 | Always | Partial — lockout implemented but resets on IP change | JIRA SEC-112 | Blocker |
| Session tokens are cryptographically random (≥128 bits entropy) | V3.2.1 | SC-8 | Always | In-place | `sessions/tokens.py:17`; audit log 2025-03 | — |
| Session invalidated server-side on logout | V3.3.1 | AC-12 | Always | In-place | `sessions/handlers.py:88`; TC-SESSION-005 | — |
| MFA available for all users | V2.8.1 | IA-2(1) | Always | Missing | No MFA implementation; roadmap item Q3 | Blocker |
| PBKDF2 / bcrypt / scrypt not used in place of Argon2id unless documented | V2.4.4 | IA-5(1) | Conditional — if migrating legacy users | N/A | No legacy hash users in current DB | Note |
| Credential-stuffing detection (HIBP integration or impossible-travel) | V2.2.9 | SI-3 | Always | Missing | No breach-password check at registration or login | Concern |
| ATT&CK T1110.001 (Password Guessing) → M1036 (Account Use Policies) | — | AC-7 | Always | Partial (see lockout above) | See SEC-112 | Blocker |
| Session tokens not in URL parameters | V3.4.2 | SC-8 | Always | In-place | Code review 2025-09; grep confirms no `?token=` pattern | — |
| HSTS header with min 1-year max-age | V9.1.1 | SC-8 | Always | In-place | Nginx config `/etc/nginx/sites/app.conf:14` | — |

**Summary for this scope:**
- Blockers: 2 (account lockout bypass-able; MFA absent)
- Concerns: 1 (no breach-credential check)
- Notes: 1 (legacy hash path not applicable)
- Adversary coverage: credential-stuffing bot — partially covered (lockout present but bypassable); fix SEC-112 + add HIBP before launch.
- Recommendation: Fix-then-go. Two Blockers must close before auth service goes to production.

### Example 2 — Failure mode (bad checklist)

```markdown
## Security checklist

- [x] HTTPS enabled
- [x] Passwords are hashed
- [x] We use JWT
- [ ] Add rate limiting (TODO)
- [ ] MFA (future)
```

Failures: no ASVS references; no status evidence; no priority; no adversary context; "We use JWT" is not a control (JWT misuse is a common finding, not a mitigation); "future" is not an implementation plan. The checklist can't tell whether the system is safe to launch.

## Common Pitfalls

### Pitfall 1 — Checklist theatre (no threat model anchor)

**Symptom:** The checklist is a downloaded ASVS Level 2 export with every row marked "In-place."

**Consequence:** Controls irrelevant to the system clutter the table; relevant gaps are hidden in the noise; the team checked a box rather than understood the attack surface.

**Fix:** First question before any row: what adversary, against which asset, justifies this control? If the answer is "not applicable to this system," mark N/A with reasoning.

### Pitfall 2 — In-place without evidence

**Symptom:** Status column is filled in from memory — "yes, we do that" — with no link or test reference.

**Consequence:** At the next audit (or incident), there's no way to verify the control was actually present. "We thought we had it" is a Partial, not In-place.

**Fix:** Every In-place row has a pointer: file:line, test ID, config path, doc link, ticket. If the pointer doesn't exist, the status is Partial or Missing.

### Pitfall 3 — Level inflation

**Symptom:** Team reaches for ASVS Level 3 for a low-sensitivity public marketing site.

**Consequence:** Huge list of controls that are genuinely N/A; engineering loses confidence in the checklist; real gaps buried.

**Fix:** Level selection is documented with the reasoning. A marketing site is Level 1 — document that explicitly, with the threat model note that justifies it.

### Pitfall 4 — Controls without adversary tracing

**Symptom:** Long list of controls with no mapping to threat actors or techniques.

**Consequence:** Priority is arbitrary. When time runs short, the team can't decide what to fix first. "Blocker" should mean "a named adversary exploits this absence under realistic conditions" — without adversary tracing, it's just a guess.

**Fix:** High-priority rows cite the adversary (from the threat model) and the ATT&CK technique the control counters.

### Pitfall 5 — One-time artifact

**Symptom:** The checklist is produced at design, filed, and never revisited after the system changes.

**Consequence:** Control status drifts. New data flows introduce new gaps. The filed checklist gives false assurance.

**Fix:** Re-evaluate triggers stated explicitly. Post-incident re-evaluation is non-negotiable — if a control failed in production, that row is immediately Missing regardless of what the checklist says.

### Pitfall 6 — ATT&CK mapping as decoration

**Symptom:** Every row has an ATT&CK citation but nobody checked whether the technique is plausible for this system's adversaries.

**Consequence:** The table looks thorough; it isn't. Controls countering techniques no adversary would use inflate the Concern count and dilute real priorities.

**Fix:** ATT&CK mapping only where the threat model names a plausible technique. Unneeded citations are removed.

## References

- **OWASP** — [ASVS v4.0.3](https://owasp.org/www-project-application-security-verification-standard/); [Top 10 (2021)](https://owasp.org/Top10/); [Cheat Sheet Series](https://cheatsheetseries.owasp.org/). See `roles/security-expert/sources.md`.
- **NIST** — [SP 800-53 r5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) (security controls catalogue); [AI RMF 1.0](https://www.nist.gov/itl/ai-risk-management-framework) (for AI-acting components).
- **MITRE** — [ATT&CK Mitigations](https://attack.mitre.org/mitigations/enterprise/) (adversary-technique-to-control mapping); [CWE](https://cwe.mitre.org/) (root-cause taxonomy).
- **Adam Shostack** — *Threat Modeling: Designing for Security* (2014); the "checklist without a threat model is theatre" argument.
- **Related Hornero skills:**
  - [`threat-model`](../threat-model/SKILL.md) — the required upstream artifact; the checklist's adversary/asset anchor.
  - [`security-review`](../security-review/SKILL.md) — point-in-time finding review; the checklist's evidence register feeds it.
  - [`pre-launch-security-audit`](../pre-launch-security-audit/SKILL.md) — orchestrates checklist + review + threat-model for launch decisions.
  - [`ir-runbook`](../ir-runbook/SKILL.md) — when a Missing row corresponds to a control that would have detected or contained an incident, the runbook is the remediation path.
