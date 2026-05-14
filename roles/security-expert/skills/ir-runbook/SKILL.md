---
name: ir-runbook
description: Use before an incident — not during — to produce a pre-staged incident-response runbook for a specific incident class (credential leak, public exploit in a dependency, suspected data exfiltration, supply-chain compromise).
intent: |
  Produces a pre-staged, class-specific incident-response runbook. The
  artifact is created in calm, reviewed by the team, and available
  when the pager fires. A runbook produced during an incident is too late.
  Anchored to NIST SP 800-61 (incident-handling lifecycle), MITRE ATT&CK
  (technique-anchored detection and response), BeyondCorp operational
  discipline (live-response hygiene), and Zetter-style incident realism
  (what real incidents look like vs. textbook).
type: component
theme: incident-response
best_for:
  - Pre-staging response procedures before a known incident class is plausible
  - Onboarding a new on-call engineer who needs to understand escalation paths
  - Post-incident retro that reveals the team had no pre-staged runbook
  - Compliance requirements mandating documented IR procedures (SOC 2, ISO 27001)
scenarios:
  - "Write a pre-staged runbook for a credential leak before we launch the auth service"
  - "We just added a dependency on a popular open-source package — produce a runbook for public-exploit-in-dependency incidents"
  - "Document the response playbook for suspected data exfiltration"
  - "Pre-stage a supply-chain compromise runbook for our CI/CD pipeline"
estimated_time: 2-4 hours per runbook class; reviewed with the team before filing
---

# IR runbook

> v0 draft. Anchored to NIST SP 800-61 r2 (Computer Security Incident Handling Guide), MITRE ATT&CK (technique-anchored detection signals and response moves), Bruce Schneier's *Secrets and Lies* (security is a process, not a product — IR is the operational expression of that), Kim Zetter's case-study realism (what real incidents look like vs. textbook), and Google BeyondCorp operational patterns (discipline for live response under uncertainty).

## Purpose

Produce a pre-staged incident-response runbook for a specific incident class that:

1. **Is written before the incident** — the runbook produced during a live incident is improvised and unreliable. Pre-staging is the only form that counts.
2. **Is class-specific** — not a generic IR checklist but a playbook keyed to a defined incident type: credential leak, public exploit in a dependency, suspected data exfiltration, supply-chain compromise, or another class the team explicitly scopes.
3. **Names detection signals** — what alerts, logs, or external notifications indicate this class is occurring. Anchored to ATT&CK detection guidance where available.
4. **Has a severity rubric** — not every alert is a P0; the runbook calibrates severity so the on-call can act proportionally.
5. **Captures containment steps with reversibility noted** — some containment actions are destructive or disruptive; the runbook notes which ones cannot be easily undone.
6. **Includes evidence preservation** — what to collect, from where, before containment destroys it.
7. **Has a communication plan** — internal escalation roster, external customer communication template, regulator notification timing and contacts.
8. **Triggers post-incident review** — the runbook's last step is always "schedule the retrospective."

Schneier: security is a process, not a product. The IR runbook is where that process becomes operational. A team that has never written a runbook will improvise under pressure; improvisation under pressure produces evidence loss, missed containment steps, and communication failures. Pre-staging replaces improvisation with a verified checklist.

## Key Concepts

### NIST SP 800-61 — the incident-handling lifecycle

NIST's Computer Security Incident Handling Guide (SP 800-61 r2) defines four phases:

- **Preparation** — building the runbook (this skill), setting up tooling, training the team. The only phase that can be done before an incident.
- **Detection and Analysis** — identifying that an incident has occurred, classifying it, and assessing severity.
- **Containment, Eradication, and Recovery** — stopping the bleeding, removing the attacker's foothold, restoring service.
- **Post-Incident Activity** — lessons learned, runbook update, root-cause fix.

The runbook is the Preparation phase's primary artifact. It front-loads the Detection and Containment decision trees so that during the incident the team executes rather than designs.

### MITRE ATT&CK — technique-anchored detection and response

ATT&CK's techniques (T####) describe what adversaries actually do. For IR purposes:

- **Detection signals** — ATT&CK detection guidance for a technique tells you *what log sources and alert patterns correspond to that technique being executed*. The runbook maps each incident class to its probable techniques and cites ATT&CK detection guidance.
- **Response moves** — ATT&CK mitigations (M####) are the control-side countermeasures; the runbook's containment steps cite them.
- **Narrative anchor** — ATT&CK gives the "what happened" framework. When an incident is still unfolding, the team can map observed signals to ATT&CK techniques to reason about likely next moves (lateral movement post-credential-theft; data staging before exfiltration).

### Containment reversibility

Live-response decisions have asymmetric consequences. Some containment steps are easily reversible (blocking an IP, revoking a session token); others are expensive or destructive to reverse (rotating all secrets, taking a service down, wiping a host). The runbook explicitly tags:

- **Reversible** — can be undone if it turns out to be a false positive.
- **Disruptive** — causes service degradation; get explicit approval before executing.
- **Destructive** — can't be undone; execute only at stated severity levels or with CISO approval.

BeyondCorp operational discipline: in live response, assume your systems are compromised and your decisions are being watched. Log every action taken during the incident with a timestamp and rationale.

### Evidence preservation before containment

Zetter-style realism: in real incidents, the most common evidence-loss pattern is enthusiastic containment that overwrites the logs and memory that would have explained the breach. The runbook captures what to preserve before taking containment actions:

- Memory dump (for malware analysis).
- Logs (rotated logs, ephemeral container logs, cloud-provider access logs).
- Network captures (if available pre-containment).
- Authentication logs from the affected period.

Evidence is preserved to a write-once destination (S3 with object lock, immutable log storage, or a separate evidence bucket not accessible from the affected environment).

### Communication plan: three audiences

Every IR communication plan covers three audiences, with different timing and content:

1. **Internal** — CISO, legal, engineering lead, on-call SRE, data-privacy officer. Escalation happens immediately; no customer or regulator notification until this group assesses.
2. **Customer-facing** — what customers need to know; what they should do; what the team is doing; contact channel. Drafted as a template in the runbook; filled in with specifics at incident time.
3. **Regulator / legal** — notification requirements vary by jurisdiction and data type (GDPR: 72 hours; HIPAA: 60 days; state breach laws: 30-90 days). The runbook names the applicable requirements for this system's data types and jurisdiction.

### Incident classes

The runbook is class-specific. Common classes:

- **Credential leak** — credentials for a service or user accounts exposed (in a repo, via a breach, via phishing).
- **Public exploit in a dependency** — a CVE is published for a dependency in production; PoC may be available.
- **Suspected data exfiltration** — anomalous outbound data transfer; attacker presence suspected.
- **Supply-chain compromise** — a dependency or build tool is found to be backdoored; a vendor announces a compromise.

A runbook can cover a class (all credential leaks) or a sub-class (a specific credential type, a specific dependency ecosystem). The more specific the runbook, the more useful — but start with a class-level runbook if none exists.

## Application

### Step 1 — Define the incident class and system scope

State:

- The incident class (from the list above, or a custom class).
- The system in scope (the service or services where this class would occur).
- The assets at risk (data types, services, downstream systems).
- The plausible threat actors (from the threat model, if one exists).

### Step 2 — Map detection signals

For the incident class, list:

- **Alert sources** — which monitoring tools, SIEMs, or log queries would surface this class.
- **ATT&CK techniques** — which techniques correspond to this class; cite ATT&CK detection guidance for each.
- **External notification paths** — CVE feeds, HaveIBeenPwned alerts, vendor security bulletins, bug bounty reports.

The signal list is the "how do we know this is happening" section. If the team can't name three distinct signals, the detection gap is itself a finding.

### Step 3 — Draft the severity rubric

Define what makes this incident P0 / P1 / P2 / P3:

- **P0** — data actively exfiltrating or confirmed exfiltrated; active attacker present; customer data at risk.
- **P1** — foothold confirmed; no confirmed exfiltration; containment window still open.
- **P2** — indicator of compromise; not yet confirmed; investigation phase.
- **P3** — security event; likely false positive; investigation without escalation.

Calibrate to the specific incident class. A credential leak that's a test account in a private repo is P3; a credential leak of production SMTP credentials is P0.

### Step 4 — Write the containment steps

For each severity level, list:

- **Immediate actions** — within 15 minutes of P0 declaration (revoke tokens, block IPs, take service offline if warranted).
- **Short-term actions** — within 2 hours (rotate affected secrets, force-logout all sessions, patch the CVE).
- **Extended actions** — within 24 hours (root-cause investigation, hardening fixes, external notification if required).

Each step: what to do; who owns it; reversibility tag (Reversible / Disruptive / Destructive); what to log.

### Step 5 — Evidence preservation checklist

Before containment steps run, collect:

- Which log sources; how to extract them; destination (write-once storage).
- Whether a memory dump is warranted and how to take it for this environment.
- What to snapshot before rotating credentials or tearing down hosts.

### Step 6 — Communication templates

Draft templates, not prose reminders:

- **Internal escalation message** — who to page; what to say; in what channel.
- **Customer notification template** — with `[FILL: timeline]`, `[FILL: data affected]`, `[FILL: action needed]` placeholders.
- **Regulator notification template** — the legal requirements for this system's jurisdiction and data types; the template maps to those requirements.

### Step 7 — Post-incident review trigger

The last step of every incident execution is: "Schedule the retrospective within 5 business days." The retrospective:

- Updates the runbook with what didn't work.
- Opens tickets for hardening gaps.
- Feeds a hardening-checklist re-evaluation (see [`hardening-checklist`](../hardening-checklist/SKILL.md)).

### Step 8 — Walk and review with the team

The runbook is walked through with at least the on-call SRE, the security lead, the engineering lead, and (for regulated environments) legal/compliance. Reviewers exercise it against a tabletop scenario. Issues surface before the pager fires.

File the reviewed runbook in the security-docs repo. Cross-link from the service's README and the on-call rotation documentation.

## Examples

### Example 1 — Partial runbook: credential leak for an SMTP service account

```markdown
# IR Runbook — SMTP Credential Leak
**System:** transactional email service (SendGrid API key + fallback SMTP)
**Incident class:** API key or SMTP credential exposed externally (repo, paste, breach)
**Last reviewed:** 2025-10-01 by: Aisha (security), James (SRE), Priya (eng lead)

---

## Detection signals

- **GitHub secret scanning alert** (automated; fires within minutes of a public commit)
- **SendGrid activity anomaly** — volume spike > 3x baseline outside business hours (alert: `sendgrid-volume-spike` in OpsGenie)
- **ATT&CK T1078.004 (Cloud Account compromise)** — cloud-provider access log shows API key used from an unrecognized IP or region; detection query: `[link to Splunk saved search]`
- **External report** — security researcher or bug bounty report; triage within 4 hours of receipt

---

## Severity rubric

| Severity | Condition |
|---|---|
| P0 | Key actively used by third party; spam campaign or exfiltration in progress |
| P1 | Key confirmed exposed (in public repo, paste) but no confirmed abuse yet |
| P2 | Suspected exposure; under investigation |
| P3 | Likely false positive; low-entropy match in scanner |

---

## Containment steps

### P0 / P1 — execute within 15 minutes

1. **Revoke the exposed API key in SendGrid dashboard.** [link]
   *Reversibility: Reversible — a new key can be generated immediately. Service email delivery pauses until Step 2 completes.*
2. **Generate a new API key** with the same permissions; update in production secrets manager (Vault path: `secret/prod/email/sendgrid_api_key`). [link to Vault runbook]
   *Reversibility: Reversible. Do not re-use the old key value.*
3. **Force-rotate the fallback SMTP password** at [link to SMTP provider admin].
   *Reversibility: Disruptive — all SMTP clients must pick up the new credential; rotation propagates via Vault within 10 minutes.*
4. **Notify internal escalation roster** (see §Communication).
5. **Preserve logs** — export SendGrid activity log for [incident start - 30 days] to `s3://evidence-bucket/[incident-id]/sendgrid-activity.json` before any account changes. *Destructive risk: account reset could overwrite activity log on some providers — export first.*

### P1 — within 2 hours

6. **Audit all messages sent from exposed key** — check for spam indicators; if found, escalate to P0.
7. **Rotate any other credentials stored alongside the leaked key** (least-privilege audit of who has access to the leaked path in the secrets manager).
8. **Check git history** for other secrets in the same file/commit range.

---

## Evidence to preserve

- [ ] SendGrid activity log (API): `GET /v3/stats?start_date=<incident-30d>` → S3 evidence bucket
- [ ] Vault audit log for `secret/prod/email/*` path for preceding 30 days
- [ ] GitHub secret-scanning alert payload (includes commit SHA, exposure window)
- [ ] Cloud-provider access log for the API key identity (AWS CloudTrail or GCP Audit Log)

---

## Communication

**Internal escalation (immediate, P0/P1):**
Page: Aisha (security), James (SRE on-call), Priya (eng lead), Maya (CISO).
Slack channel: `#security-incidents`. Message template:
> "SMTP credential leak incident opened [INCIDENT-ID]. Severity: [P0/P1]. Key revoked at [time]. Investigation in progress. Bridge: [Zoom link]."

**Customer notification (P0 only — if spam was sent from leaked key):**
Template: see `docs/ir-templates/smtp-leak-customer.md`. Key fill-ins: [timeline], [volume of affected sends], [whether PII was in email bodies].
Send timeline: within 24 hours of P0 confirmation.

**Regulator:** No direct regulator notification for SMTP credential leak unless email bodies contained regulated data (GDPR Art. 33 applies if EU PII was in message bodies — 72-hour GDPR notification window starts at P0 declaration).

---

## Post-incident review

Trigger: within 5 business days of incident close.
Agenda: root-cause (how did the key leak?); detection gap (was the GitHub alert the first signal?); hardening tickets opened; runbook updates.
```

### Example 2 — Failure mode (bad runbook)

```markdown
## If credentials leak

Contact the security team. Rotate the passwords. Notify affected users.
```

Failures: no detection signals; no severity rubric; no step ownership; no reversibility notes; no evidence preservation; no communication templates; "notify affected users" with no template, no timing, and no regulator acknowledgment. Written during a previous incident and never updated. A team reading this during a live P0 has nothing operational to work with.

## Common Pitfalls

### Pitfall 1 — The runbook written during the incident

**Symptom:** The team writes the playbook in the war room at 2 AM.

**Consequence:** Under pressure, steps are skipped; evidence is destroyed by containment before it's preserved; communication goes out without legal review; the team improvises and disagrees about what to do next.

**Fix:** The skill exists explicitly to prevent this. Pre-stage before the incident class is plausible. A runbook that took 3 hours to write in calm saves 12+ hours of costly improvisation.

### Pitfall 2 — Generic runbook, not class-specific

**Symptom:** One IR runbook for all incident types — "assess severity, escalate, contain, recover."

**Consequence:** The on-call has to invent the class-specific steps during the incident. A credential-leak response and a ransomware response share a lifecycle but differ entirely in containment, evidence, and communication.

**Fix:** One runbook per incident class. Start with the classes most plausible for the system.

### Pitfall 3 — No reversibility notes on containment steps

**Symptom:** The runbook says "rotate all secrets" without noting that this will take production down for 20 minutes.

**Consequence:** The on-call rotates everything at 4 AM, takes down the service, and wakes up the rest of the team unnecessarily — during a P2 that turned out to be a false positive.

**Fix:** Every containment step has a reversibility tag and an impact note. Disruptive and Destructive steps require stated approval (P0 declaration, CISO consent, etc.).

### Pitfall 4 — Evidence destroyed by containment

**Symptom:** The team revokes the API key and wipes the host before exporting the audit logs.

**Consequence:** The attacker's access pattern, exfiltrated data volume, and initial access vector are gone. The post-incident report says "unknown."

**Fix:** Evidence preservation step is first in the containment sequence. Explicitly tagged as "do this before Step 2."

### Pitfall 5 — Communication plan as an afterthought

**Symptom:** "We'll figure out the notification when we know more."

**Consequence:** GDPR 72-hour window closes before anyone drafts the notification. Legal finds out about the incident after the customer email goes out. The CEO hears from a journalist before the internal escalation reaches them.

**Fix:** Communication templates are in the runbook at authoring time. Regulator requirements are noted with their timings. The decision tree for when to notify customers is explicit.

### Pitfall 6 — Runbook filed and never reviewed

**Symptom:** The runbook is written once, filed, and referenced never — until a real incident reveals it's three major infrastructure changes out of date.

**Consequence:** Escalation roster has people who left the company. Vault paths have changed. The playbook tells the team to revoke in a dashboard that no longer exists.

**Fix:** Post-incident-review trigger is the last step. Also: annotate the runbook with the review date and trigger a review on significant infrastructure changes.

## References

- **NIST** — [SP 800-61 r2](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final) (Computer Security Incident Handling Guide); the lifecycle structure this skill follows.
- **MITRE** — [ATT&CK Techniques and Detection guidance](https://attack.mitre.org/); technique-to-signal mapping; [ATT&CK Mitigations](https://attack.mitre.org/mitigations/enterprise/) for response-move vocabulary.
- **Bruce Schneier** — *Secrets and Lies: Digital Security in a Networked World* (2000); security-as-process framing; IR as the operational expression of that thesis.
- **Kim Zetter** — *Countdown to Zero Day* (2014); case-study realism on how real incidents unfold vs. textbook sequences; evidence destruction and attribution gaps in real responses.
- **Google BeyondCorp** — *BeyondCorp: A New Approach to Enterprise Security* (Ward & Beyer, 2014); operational discipline for live response in a zero-trust posture; the "log every action with timestamp and rationale" norm.
- **Troy Hunt** — [Have I Been Pwned](https://haveibeenpwned.com/); the canonical external signal source for credential-leak detection; breach notification patterns.
- **Related Hornero skills:**
  - [`threat-model`](../threat-model/SKILL.md) — the runbook's adversary and technique inventory comes from the threat model.
  - [`hardening-checklist`](../hardening-checklist/SKILL.md) — post-incident retro opens missing-control rows in the checklist; runbook and checklist are complementary artifacts.
  - [`disclosure-comm`](../disclosure-comm/SKILL.md) — when the incident requires external notification, the disclosure-comm skill drafts the artifact.
  - [`pre-launch-security-audit`](../pre-launch-security-audit/SKILL.md) — pre-launch audit should verify that runbooks exist for the incident classes most plausible for the system going to production.
