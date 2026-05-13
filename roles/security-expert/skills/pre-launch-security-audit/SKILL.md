---
name: pre-launch-security-audit
description: Use when a feature or system is approaching launch and the team needs a disciplined security pass — threat-model refresh, focused review, control-readiness check — producing a Go / Fix-then-go / Hold recommendation.
intent: |
  A workflow that orchestrates the security-expert role's component
  skills — threat-model, security-review, llm-risk-assessment — for
  a launch-readiness decision. The workflow exists to resist three
  launch-time failure modes: green-pipeline-is-enough, compliance-
  signoff-is-security, and gut-feel approval. Mirrors the tester
  role's pre-release-test-pass in shape and intent.
type: workflow
theme: release-readiness
best_for:
  - High-stakes launches (public-facing, regulated, data-sensitive)
  - First-time launches where the system has never been pen-tested
  - Launches that introduce a new trust boundary (new auth, new integration, new public API)
  - Launches of LLM-acting systems with tool access
  - Periodic audits of mature systems where surfaces have drifted
scenarios:
  - "Pre-launch audit of a redesigned password-reset flow"
  - "Pre-launch audit of an admin console going from internal to customer-facing"
  - "Pre-launch audit of a customer-support agent with DB read access"
  - "Annual security audit of the payments service"
estimated_time: 4-12 hours (single launch); scales to days for major launches
---

# Pre-launch security audit (workflow)

> v0 draft. A workflow that composes [`threat-model`](../threat-model/SKILL.md), [`security-review`](../security-review/SKILL.md), and [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md). Grounded in OWASP's [Security Verification Standard (ASVS)](https://owasp.org/www-project-application-security-verification-standard/) audit methodology, NIST's risk-management framing, Google SRE's release-engineering practice, and Adam Shostack's review-as-conversation framing.

## Purpose

Run a disciplined security pass before launch, producing:

1. **A refreshed threat model** — does the design-time analysis still match what's about to ship?
2. **A point-in-time security review** — focused on the launch's actual surface, with reproductions and remediation.
3. **An LLM risk assessment** — if the system is LLM-acting.
4. **A control-readiness check** — required controls (auth, logging, rate limiting, monitoring) in place and tested.
5. **A launch-readiness recommendation** — Go / Fix-then-go / Hold with evidence.

The workflow is the security-side complement to the tester role's [`pre-release-test-pass`](../../../tester/skills/pre-release-test-pass/SKILL.md). The two skills follow the same shape (frame → re-assess → execute → audit → synthesise → recommend) deliberately — different lenses, common discipline.

## Key Concepts

### Threat model refresh, not rewrite

The launch audit doesn't rewrite the threat model — it refreshes it. The questions:

- Have any of the adversaries gained capability since the model was written? (New attack technique published; an industry-public incident; a vendor breach.)
- Has the system's attack surface changed since the model? (New endpoints, new dependencies, new data flowing across trust boundaries.)
- Are the model's controls still implemented as designed? (Some controls drift in implementation; some never get implemented.)

If the answer to any of those is "yes," the model gets updated rows. If the model doesn't exist, the audit's first step is producing a minimum-viable one.

### Focused review, not a full re-audit

A pre-launch security review is *focused on the launch's actual surface* — the diff since the last review, the new endpoints, the new flows. A full re-audit is the wrong scope; the team won't do it under time pressure, and a partial full re-audit is worse than a focused one.

The focused review hits the surfaces most likely to be new or changed; relies on the threat model for what's "static and previously reviewed."

### Control readiness — the boring half

The audit verifies that required controls are *in place and tested*. The standard list:

- **Auth controls.** Login, MFA, session management, password reset. Tested by what? Pointing at what evidence?
- **Authorization controls.** Object-level checks at every privileged operation. Tested for IDOR.
- **Logging and monitoring.** Security-relevant events logged. Detections wired. PII redacted.
- **Rate limiting and abuse prevention.** Per-account / per-IP / per-token quotas; lockout policy; CAPTCHA where warranted.
- **Crypto and secrets.** Keys in KMS / HSM; secrets not in code; TLS configured sanely.
- **Dependency hygiene.** Pinned; recent; scanned; known-CVEs addressed.
- **Backup and recovery.** Backups exist; restore tested.

Each control either: has evidence of being in place + tested, or is named as a missing control with a finding.

### LLM risk assessment if applicable

If the launch includes an LLM-acting component, the assessment runs in parallel. The assessment may surface launch-blocking issues that the threat model and review don't see — particularly trifecta presence and indirect-injection paths.

### Recommendation, defensible

The audit closes with a single Go / Fix-then-go / Hold recommendation. The recommendation is supported by the findings; not by ceremony, not by vote.

A Fix-then-go recommendation names the specific fixes; once they land and re-verify, the recommendation flips to Go without another full audit.

### Same blameless framing as SRE

Following Google SRE's blameless-postmortem culture: the audit surfaces problems; problems are facts; the recommendation is about the launch candidate, not the team's competence. Adversarial in posture toward the system, not the team.

## Application

The workflow has six steps. Small launch: 4-6 hours, one auditor. Large launch: multiple days, possibly multiple auditors.

### Step 1 — Frame the audit (30-60 minutes)

Gather:

- **Launch scope.** Exactly what is going from where to where. Internal → customer-facing? Beta → general availability? New region? New tenant tier?
- **Time to launch.** When is the cut? When does customer traffic flip?
- **Stakeholders.** Who receives the recommendation? Who can override?
- **Existing artifacts.** Threat model (if any), prior security reviews, RFC, dependency scans, prior pen-test results, incident history for this area.

Output: a one-page audit charter — scope, time-box, stakeholders, link to pre-reads.

### Step 2 — Threat model refresh (60-120 minutes)

Using [`threat-model`](../threat-model/SKILL.md):

- Re-read the existing model (or produce a minimum-viable one if none exists).
- Walk the DFD against current system state — mark drifts.
- Re-walk the adversary list — new capabilities? New plausibility?
- Re-walk STRIDE on changed/new elements.
- Mark each threat row with current status: control verified / control degraded / control missing / risk acceptance current.

Output: an updated threat-model document with a clear "what changed since last review" appendix.

### Step 3 — Focused security review (120-240 minutes)

Using [`security-review`](../security-review/SKILL.md):

- Define the focused surface (diff since last review; new endpoints; new flows).
- Walk OWASP Top 10 against the focused surface.
- Run dependency / SAST / DAST tools on the focused surface; triage results.
- Produce findings — each with surface, reproduction, severity, remediation, owner.

Output: a focused security-review report.

### Step 4 — LLM risk assessment (if applicable; 120-240 minutes)

Using [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md):

- Map LLM-touching surfaces.
- Run the trifecta analysis.
- Walk the LLM Top 10.

Output: an LLM-specific assessment. Skip if no LLM components.

### Step 5 — Control-readiness check (45-90 minutes)

A targeted checklist walk against the system. For each control class:

```markdown
## Control readiness

| Control class | Required? | In place? | Tested? | Evidence | Notes |
|---|---|---|---|---|---|
| Auth: login + MFA | Y | Y | Y | TC-2001-2008 | MFA optional; recommend enforced for admin |
| Auth: session mgmt | Y | Y | Partial | TC-2101 | Session-fixation regression test missing — F-007 |
| Authorization: object-level | Y | Y | Y | TC-1019, TC-1020 | Regression for BUG-1119 |
| Logging: security events | Y | Y | N | n/a | F-011: logging is in place but detections are not wired |
| Rate limiting: login | Y | Y | Y | TC-2004 | Per-IP + per-account; CAPTCHA at >5 failures |
| Rate limiting: password reset | Y | N | n/a | n/a | F-012: no rate limit; trivial enumeration |
| Crypto: TLS config | Y | Y | Y | SSL Labs A+ rating, 2025-11-01 | Re-test before launch |
| Crypto: password hashing | Y | Y | n/a | code: Argon2id with sensible cost | OK |
| Crypto: key management | Y | Y | n/a | KMS-managed; rotation policy quarterly | OK |
| Dependencies: scan | Y | Y | Y | Snyk 2025-11-04: 2 medium, 0 high/critical | Mediums tracked; not launch-blocking |
| Backups + restore | Y | Y | Y | restore drill 2025-09-12 | OK |
| Monitoring: dashboards | Y | Y | Y | Grafana board #2371 | OK |
| Monitoring: detections | Y | N | n/a | n/a | F-011 (see above) |
```

Output: a control-readiness table with gaps named as findings.

### Step 6 — Synthesise and recommend (30-60 minutes)

Combine the threat-model refresh, the focused review, the LLM assessment, and the control-readiness check. Three categories:

- **Blockers** — Critical findings, missing required controls, unmitigated trifecta. Launch held until fixed.
- **Warnings** — High / Medium findings that should be tracked through launch.
- **Follow-ups** — work for after launch (low findings, hardening opportunities, threat-model updates).

Issue the recommendation:

```markdown
# Pre-launch security audit — <launch / RC ID>

- **Lead auditor:** <name>
- **Date:** <YYYY-MM-DD>
- **Scope:** <launch scope>
- **Recommendation:** GO | FIX-THEN-GO | HOLD

## Summary

<3-5 sentences. The recommendation, the headline reasoning, the
condition for change.>

## Updated threat model

<Link to refreshed model; one-paragraph "what changed.">

## Focused security review

<Link to focused review; severity rollup.>

## LLM risk assessment (if applicable)

<Link to assessment; trifecta status; headline finding.>

## Control readiness

<The table above; gaps cross-referenced to findings.>

## Blockers

| F# | Description | Reference | Owner | Target |
|---|---|---|---|---|

## Warnings

<Tracked through launch; not blocking.>

## Follow-ups

<Post-launch work.>

## Acceptance

<Sign-off, if required, from named recipients.>
```

The recommendation is circulated. Stakeholders can override with reasoning recorded. Audit artifacts are committed to the repo.

## Examples

### Example 1 — Useful launch audit (sketch)

**Launch scope:** New customer-support agent (LLM-powered, tool-using) going from internal beta to all customers. Launch Tuesday; audit Thursday-Friday of preceding week; 1.5 days budgeted.

**Step 2 — Threat model refresh.** Existing model covers the support service; doesn't cover the LLM agent. Added an LLM-DFD section. Added two adversaries: "support-ticket author exploiting indirect injection" and "compromised KB-doc author" (since KB ingests from a Slack channel any employee can post to). STRIDE re-walk on new elements surfaced two new threat rows.

**Step 3 — Focused security review.** Diff covers two new services and modifications to the auth boundary. Walked Top 10; found:
- F-001 IDOR-equivalent on the agent's `get_ticket` tool (Critical) — tool retrieves any ticket id, not just the caller's.
- F-002 PII in agent reasoning logs (High) — full ticket text including customer email/phone is logged at INFO.
- F-003 Dep scan: 2 medium CVEs in `langchain` and `openai` — tracked, not blocking.
- F-007 SAST flagged a SQL-injection-pattern in a debug endpoint — gated to staging only; verified.

**Step 4 — LLM risk assessment.** Trifecta present (KB content + customer DB + email tool). Restructured: agent has read-only DB tool but no email tool; email is a separate non-LLM service. KB ingestion adds source-attribution + denial of "instruction-like" content. Indirect injection finding (LLM01) → F-001 already covers tool-side; added F-008 indirect-injection probe needed for KB pipeline.

**Step 5 — Control readiness.**
- Auth controls OK.
- Authorization: F-001 (tool-side IDOR) is a control gap; blocking.
- Logging: F-002 (PII in logs) is a control gap; high.
- Rate limiting: agent calls per-user limited; OK.
- Monitoring: no detection for "agent attempted to invoke not-allowed tool" — F-009; medium.

**Step 6 — Recommendation: HOLD.** GO once F-001, F-002, F-008 are landed and re-verified; F-009 tracked as warning through launch. Communicated to product + SRE + support; head-of-engineering accepts the hold; targets Wednesday +1.

Re-verification cleared Wednesday; recommendation flipped to GO with the warnings as documented follow-ups. Launched Thursday; no incidents in first 30 days.

### Example 2 — Failure mode (bad)

```markdown
# Pre-launch security audit

The team ran dependency scan — 0 critical issues. SAST passed. The
threat model from launch-1 still applies. Recommend: Go.
```

Failures: no scope statement; no threat-model refresh (the model from launch-1 may not cover what's changed); no focused review (tools alone are not a review); no LLM assessment (the launch includes an agent!); no control readiness; no findings; recommendation made without evidence.

## Common Pitfalls

### Pitfall 1 — Tools-only audit

**Symptom:** The audit is the output of `npm audit` + a SAST run.

**Consequence:** Tools catch a subset. Logic flaws, design issues, missing controls, prompt-injection risks all pass through.

**Fix:** Tools complement the human walk. The audit's spine is threat-model refresh + focused review.

### Pitfall 2 — Skipping threat-model refresh

**Symptom:** "The threat model from version 1 still applies."

**Consequence:** Surfaces drift; new adversaries emerge; controls degrade. The model that "still applies" actually doesn't, but nobody checks.

**Fix:** Refresh is mandatory. Even a 30-minute refresh catches drift that a static model misses.

### Pitfall 3 — LLM assessment skipped because "we're not really an AI product"

**Symptom:** The system has one LLM call ("just for summarisation"); the audit treats it as a non-issue.

**Consequence:** That one LLM call has tool access and reads user input. Trifecta is present and unmitigated.

**Fix:** Any LLM call that touches user-controlled input *and* has tool access *or* sees sensitive data triggers an LLM risk assessment. No exceptions for "small" usage.

### Pitfall 4 — Control readiness as inventory

**Symptom:** Control table is filled in by listing the controls; no verification that they're actually working.

**Consequence:** Controls listed as "in place" turn out to be misconfigured or never tested. The first probe finds them broken.

**Fix:** Each control listed cites the evidence (test case, configuration check, dashboard, audit log). "In place" without evidence is "not in place" for the audit's purposes.

### Pitfall 5 — Recommendation by political will

**Symptom:** Audit found Critical issues; recommendation is GO because the launch date is fixed.

**Consequence:** The audit's authority erodes; the team learns the audit doesn't actually block. Real risk ships.

**Fix:** Recommendation by evidence. If political pressure overrides, it's logged as an explicit override with reasoning — the auditor's recommendation stands as the professional output.

### Pitfall 6 — No re-verification

**Symptom:** Blockers are fixed; the launch goes ahead without re-checking the fixes.

**Consequence:** Some fixes are wrong; some introduce new issues. Launch ships with the regression.

**Fix:** Fix-then-go recommendations name specific fixes; once landed, the named fixes are re-verified before the recommendation flips.

### Pitfall 7 — Audit not filed

**Symptom:** Audit conversation happens; no artifact committed to the repo.

**Consequence:** Next launch starts from scratch. Industry-public incidents that mirror local issues don't get connected to prior findings.

**Fix:** All four artifacts (threat-model refresh, security review, LLM assessment, control-readiness, recommendation) committed to the security-docs repo. Cross-link from the launch ticket / PR description.

### Pitfall 8 — Audit fatigue

**Symptom:** Lead auditor runs every audit; quality degrades through the year.

**Consequence:** Important launches get less attention than the date implies. Bus factor of one.

**Fix:** Rotate the lead role; pair on high-stakes audits; treat the workflow as a team practice with one named lead per audit.

## References

- **OWASP** — [Application Security Verification Standard (ASVS) v4.0.3](https://owasp.org/www-project-application-security-verification-standard/); the canonical control catalogue used in step 5.
- **NIST** — [SP 800-53 r5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) (control catalogue); [Cybersecurity Framework (CSF)](https://www.nist.gov/cyberframework) for the protect/detect/respond/recover frame.
- **Adam Shostack** — *Threat Modeling: Designing for Security* (2014); the review-as-conversation framing the workflow inherits.
- **Google SRE** — *Site Reliability Engineering* (2016, eds. Beyer, Jones, Petoff, Murphy), ch. 8 (Release Engineering) and ch. 15 (Postmortem Culture). The blameless framing.
- **Anthropic** — published patterns on agentic system safety; used in the LLM-launch path.
- **Related Hornero skills:**
  - [`threat-model`](../threat-model/SKILL.md) — refreshed at step 2.
  - [`security-review`](../security-review/SKILL.md) — focused review at step 3.
  - [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md) — at step 4 when LLM components are in scope.
  - `roles/tester/skills/pre-release-test-pass/SKILL.md` — sibling workflow; same shape, different lens; for cross-functional launches the two run in parallel.
  - `skills/multi-role-review/SKILL.md` — orchestrates this audit with engineer / tester / designer perspectives for the highest-stakes launches.
  - `skills/extract-lesson/SKILL.md` — post-launch incidents feed lessons back into the threat model and the next audit.
