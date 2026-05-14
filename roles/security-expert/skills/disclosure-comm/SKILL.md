---
name: disclosure-comm
description: Use when a security event requires an internal or external disclosure communication — vulnerability disclosure to a vendor or the public, a customer-facing incident notification, or a regulator filing. Owned by security with input from comms, not the reverse.
intent: |
  Drafts a technical disclosure communication for a specific security
  event. Captures the timeline of facts, what is and isn't known, what
  action recipients should take, and what the team is doing about it.
  Avoids both legalese over-cautiousness (which leaves defenders
  uninformed) and casual under-disclosure (which omits what recipients
  need to act). Anchored to Schneier's transparency-first stance,
  Project Zero's coordinated-disclosure norms, MITRE's CVE structure,
  and NIST's regulatory frameworks.
type: component
theme: disclosure
best_for:
  - Notifying customers after a confirmed security incident affecting their data
  - Disclosing a vulnerability you found in a third-party product (vendor disclosure)
  - Publishing a security advisory for a CVE in your own software
  - Filing a regulator notification under GDPR, HIPAA, or a state breach law
  - Responding to an inbound vulnerability report (researcher acknowledgment + fix-status update)
scenarios:
  - "Draft the customer notification for the credential leak incident"
  - "Write the vendor disclosure email for a stored XSS we found in a dependency"
  - "Draft the public security advisory for CVE-2025-XXXXX in our SDK"
  - "Draft the GDPR Article 33 notification to our lead supervisory authority"
  - "Write the researcher acknowledgment for the bug bounty report we received"
estimated_time: 1-2 hours per disclosure draft; legal review adds time for external communications
---

# Disclosure communication

> v0 draft. Anchored to Bruce Schneier's transparency-first stance (*Secrets and Lies*, 2000), Tavis Ormandy and Google Project Zero's coordinated-disclosure norms (90-day window; technical framing for an at-risk public), MITRE's CVE structure (vulnerability identification and advisory format), and NIST's regulatory frameworks (SP 800-61 r2 incident reporting; GDPR / HIPAA / state breach-law requirements). Disclosure is a technical security function owned by security with input from comms — not a PR exercise directed by comms with security as an afterthought.

## Purpose

Produce a disclosure communication that:

1. **States what happened** — a timeline of facts in plain language, distinguishing confirmed from unconfirmed.
2. **Names what is and isn't known** — "We have confirmed X; we are still investigating Y; we do not yet know Z." Precision over false assurance.
3. **Tells recipients what to do** — the actionable step for customers, vendors, or the public is explicit, specific, and placed prominently.
4. **States what the team is doing** — the fix timeline, the monitoring status, and the path to resolution.
5. **Hits the right level of technical detail** — enough for defenders to act; not so much that it hands attackers a working exploit.
6. **Meets applicable legal requirements** — the disclosure names the regulatory basis if applicable and conforms to its timing and content requirements.

Schneier: adversaries already know about the vulnerability (or will soon). The only people kept uninformed by non-disclosure are the defenders. Transparency is not primarily a PR choice — it's a security property of the ecosystem. Over-caution (vague language, delayed disclosure "until everything is known") leaves customers exposed longer.

Project Zero's norm: the 90-day coordinated-disclosure window exists because indefinite-vendor-hold leaves the public exposed. The norm is a specific commitment: notify the vendor; give them 90 days; publish regardless. This skill applies that discipline to outbound vendor disclosures and inbound researcher reports alike.

## Key Concepts

### Disclosure types

The skill covers four communication types, each with a different audience, purpose, and constraint:

**1. Vendor disclosure** — you have found a vulnerability in a third party's product and are notifying them. The communication enables the vendor to produce a patch before public exposure. Tone: collaborative but time-bound. Include the technical detail the vendor needs; do not include a public-ready exploit. Cite the coordinated-disclosure window you are operating under (90 days is the Project Zero standard; some researchers use 45 or 120 — be explicit).

**2. Security advisory (your own product)** — you are publishing a CVE or security advisory for a vulnerability in software you maintain. The audience is users of your software who need to patch. Format anchors to CVE/NVD structure. Technical detail is calibrated to help defenders patch and assess exposure — not to enable exploitation.

**3. Customer incident notification** — you are notifying customers that their data or accounts may have been affected by a security incident. The audience is non-technical in the main. Technical detail is lower; action steps are higher. Regulatory requirements (GDPR, HIPAA, state breach laws) specify minimum content and timing.

**4. Regulator filing** — you are filing the legally-required incident notification with a supervisory authority (GDPR Art. 33 to the lead DPA; HIPAA Breach Notification to HHS OCR; state AG filings under state breach laws). Content requirements are prescribed by regulation; the disclosure fills in the prescribed fields.

### Schneier's transparency-first stance

The argument from *Secrets and Lies*: security through obscurity is not security. When a vulnerability exists, attackers who are motivated will find it (or have already found it). Withholding disclosure means the defenders — the customers, the system administrators, the users — are the last to know. They cannot act on information they don't have.

Practical implication for disclosure communications: the instinct to be vague ("we identified a potential security issue") helps nobody. Customers who need to change their passwords need to be told their passwords are at risk. The communication's job is to give them that information in time to act.

### Project Zero's coordinated-disclosure norm

Project Zero's operational norm (Ormandy and colleagues):

- **Notify the vendor** with enough technical detail to reproduce and fix the vulnerability.
- **Set the disclosure window** — 90 calendar days is the standard; note it explicitly in the notification.
- **Publish at 90 days** regardless of patch status. If the vendor needs more time and has made credible progress, a single 14-day grace extension is reasonable. Beyond that, the public's exposure outweighs the vendor's schedule.
- **Why the norm matters:** Indefinite hold serves the vendor's PR interests, not the public's security. The 90-day norm creates accountability and has demonstrably improved industry patch cadence.

When receiving a vulnerability report (inbound), apply the same discipline in reverse: acknowledge within 24 hours, commit to a patch timeline, and honor the researcher's disclosure window.

### CVE structure for security advisories

MITRE's CVE (Common Vulnerabilities and Exposures) provides the standard identifier and advisory format. For security advisories about your own software:

- **CVE ID** — obtain via CVE Numbering Authority (CNA) process if your organization is a CNA, or via MITRE directly.
- **CVSS score** — CVSS v3.1 or v4.0 base score with the full vector string; the score is an input to prioritization, not a substitute for plain-language severity.
- **Affected versions** — be specific; do not round up to "all versions before X."
- **Fixed versions** — the specific version containing the fix.
- **Workaround** — if a configuration change mitigates before patching is possible.
- **Credit** — researcher acknowledgment if applicable; Project Zero and HackerOne practice makes this standard.

### Regulatory requirements by framework

| Framework | Trigger | Notification target | Timing |
|---|---|---|---|
| GDPR Art. 33 | Personal data breach | Lead supervisory authority (DPA) | Within 72 hours of becoming aware |
| GDPR Art. 34 | High-risk breach (likely harm to individuals) | Affected data subjects (customers) | Without undue delay |
| HIPAA Breach Notification Rule | PHI breach > 500 individuals | HHS OCR + affected individuals + media (if >500 in a state) | Within 60 days |
| US state breach laws | PII breach affecting state residents | State AG + affected individuals | 30-90 days (varies by state) |
| PCI DSS | Cardholder data breach | Card brands + acquiring bank | Immediately (within 24 hours of suspicion) |

The regulator filing is separate from the customer notification. The customer notification is typically written to be human-readable; the regulator filing fills in the authority's prescribed form. Both are required for incidents that meet the thresholds.

### What to include vs. omit in each type

| Element | Vendor disclosure | Security advisory | Customer notification | Regulator filing |
|---|---|---|---|---|
| Technical reproduction steps | Yes — vendor needs to reproduce | Summary only — defenders patch, attackers read too | No | No |
| CVSS / CVE | N/A (pre-CVE) | Yes | Optional (CVSS score alone is not user-actionable) | Yes if available |
| Root cause | Yes | Yes | No — customers need action steps, not post-mortems | Yes |
| Affected data categories | N/A | N/A | Yes — specific data types affected | Yes |
| Number of affected users | N/A | N/A | Approximate (avoid false precision) | Yes — required |
| Researcher credit | Yes | Yes | No | No |
| Regulator notification status | N/A | N/A | Mention if relevant | N/A (this IS the filing) |

### Tone calibration

Technical disclosure is not a PR exercise and not a legal brief. The failure modes are:

- **Legalese over-caution:** "We are writing to inform you that we recently identified a potential anomaly which we have been investigating." → The customer doesn't know if they need to act.
- **Casual under-disclosure:** "Hey, found an XSS. Attaching a POC. Fix it when you can." → The vendor has no severity signal; the disclosure window isn't stated; there's no CVE path.
- **False precision:** "No data was accessed." (When you don't actually know.) → False assurance is worse than acknowledged uncertainty.

The right tone is: **direct, factual, specific about what is and isn't known, actionable.** Legal review adds legal language as a layer; it should not replace the factual, actionable core.

## Application

### Step 1 — Identify disclosure type and audience

State:
- Which of the four types (vendor disclosure, security advisory, customer notification, regulator filing).
- The primary audience and their technical sophistication.
- Applicable regulatory requirements (what framework, what timing, what required fields).
- Whether a coordinated-disclosure window applies and, if so, who set it and when it runs out.

### Step 2 — Assemble the facts

Before drafting, collect:

- **Timeline** — when was the vulnerability or breach first introduced? When was it first detected? When was it confirmed? When was it remediated?
- **What happened** — the specific vulnerability or incident class.
- **What data or systems were affected** — data types, approximate user count, affected versions or services.
- **What was done** — containment steps taken, patch status, monitoring added.
- **What is not yet known** — name the open questions explicitly; do not paper over them.

If facts are still being gathered, the first disclosure may be a holding notification: "We are investigating a security incident. We will update you within [timeframe]." That is preferable to a delayed disclosure with false completeness.

### Step 3 — Draft the disclosure

Use the template for the applicable type (see Application sub-sections below). Follow this structure for all types:

1. **Subject / headline** — direct, specific, not alarming-but-vague.
2. **Summary** — one paragraph: what happened, what was affected, what to do.
3. **Timeline** — dated facts; distinguish confirmed from "we believe."
4. **What was affected** — data types, user count, systems, versions.
5. **What you should do** — the recipient's action items, specific and prominent.
6. **What we are doing** — fix timeline, monitoring, future prevention.
7. **Contact / escalation** — who to reach for questions; a dedicated security contact, not a generic support queue.

### Step 4 — Calibrate technical detail

- **Vendor disclosure:** include the reproduction steps, the affected code path, and ideally a PoC (marked as restricted). The vendor needs to reproduce to fix.
- **Security advisory:** include CVSS vector, affected versions, fixed version, workaround. Omit exploitation details that hand attackers a ready-made weapon.
- **Customer notification:** omit technical root cause; include only the action the customer needs to take and what data was at risk.
- **Regulator filing:** fill in the prescribed fields; include data category specifics and user count; reference CVE if applicable.

### Step 5 — Legal review gate

External communications (anything that leaves the organization) go through legal review before sending. The legal review adds:

- Jurisdiction-specific language (especially for regulator filings).
- Liability framing.
- Confirmation that regulatory timing is met.

Legal review should take hours, not days, for time-sensitive disclosures. If legal review will miss a regulatory deadline, document the constraint and send the best-available draft.

### Step 6 — Send and record

- Send the disclosure via the committed channel.
- Record the send timestamp; for regulator filings, preserve the transmission receipt.
- For vendor disclosures, note the response date and the next disclosure-window checkpoint.
- For customer notifications, track open/delivery metrics if possible (for regulatory evidence).

### Step 7 — Follow up

- Vendor disclosure: follow up at 45 days (halfway through the 90-day window) if no acknowledgment or patch timeline has been received.
- Security advisory: monitor for researcher questions; patch the CVE entry if new information emerges.
- Customer notification: publish a "resolved" update once the incident is fully contained and remediated.
- Regulator filing: respond to regulator follow-up within stated timelines.

## Examples

### Example 1 — Vendor disclosure (to a maintainer of an open-source library)

```markdown
Subject: [Security] Stored XSS in acme-widget v2.x — coordinated disclosure

Hi [maintainer name],

I'm a security researcher. I've found a stored cross-site scripting vulnerability in acme-widget versions 2.0.0 through 2.4.1.

**Summary**

A stored XSS exists in the `renderWidget()` function when a `title` parameter longer than 512 bytes is passed. The title is interpolated into the DOM without sanitization, allowing an attacker with write access to widget configuration to inject arbitrary JavaScript executed in any user's browser that views the widget.

**Reproduction**

Library version: 2.4.1
Environment: Node 20, Chrome 128

```js
const widget = new AcmeWidget({
  title: 'x'.repeat(512) + '<script>alert(document.cookie)</script>',
  containerId: 'target'
});
widget.render(); // alert fires in browser
```

Observed: `alert(document.cookie)` executes in the victim browser.
Expected: the title is escaped before DOM insertion.

**Impact**

Any user who views a page containing a widget whose title was set by an untrusted party (e.g., multi-tenant SaaS where tenants configure widget titles) is vulnerable to session hijacking.

**Suggested fix**

Escape or sanitize the `title` value before DOM insertion. The rest of the library already uses `DOMPurify.sanitize()` in `renderContent()` — applying the same pattern here would be consistent.

**Disclosure timeline**

I am operating under a 90-day coordinated disclosure window starting today, 2025-10-14. I plan to publish my findings on 2026-01-12 regardless of patch status. I am happy to coordinate on timing if a patch ships before then.

Please confirm receipt. I'm available to discuss the technical details or provide further test cases.

[Researcher name + contact]
```

### Example 2 — Customer incident notification (credential leak)

```markdown
Subject: Important security notice: action required for your account

Dear [Customer name],

We are writing to tell you about a security incident that affected your account and what you should do right now.

**What happened**

On October 8, 2025, we discovered that a set of API credentials used to access our platform had been exposed in a public code repository. We have confirmed that the exposed credentials could have been used to access your account's data. We revoked the credentials immediately on discovery.

**What data may have been accessed**

The exposed credentials had read access to: your account settings, your API usage history, and your registered email address. They did not have access to your payment information, which is stored with our payment processor and was not affected.

**What you should do right now**

1. **Rotate your API keys.** Log into your account → Settings → API Keys → Revoke all and generate new. This prevents any access using the old credentials.
2. **Review your API activity log** for any requests you don't recognize between September 15 and October 8, 2025. [Link to activity log]
3. If you see activity you don't recognize, contact us at security@example.com.

**What we are doing**

We have revoked the exposed credentials, added automated scanning to prevent credentials from appearing in public repositories, and are reviewing our access controls. We have no evidence that your data was accessed by a third party, but we cannot rule it out.

**Questions**

Contact us at security@example.com. We will respond within 4 hours on business days.

We're sorry this happened. We are committed to protecting your data and will publish a full post-incident summary at [link] by October 20, 2025.

The [Company] security team
```

### Example 3 — Failure mode (bad disclosure)

```markdown
Subject: Security update

Dear customer,

We recently identified a potential security anomaly in our systems. We take security very seriously and have taken steps to address this matter. There is no indication that any data was impacted. Please contact support if you have questions.

The [Company] team
```

Failures: no timeline; no specifics on what happened; "potential anomaly" and "no indication" are both meaningless to a customer deciding whether to rotate credentials; no action item; no regulatory acknowledgment; no contact escalation path specific to security. The customer cannot assess their risk or take any action.

## Common Pitfalls

### Pitfall 1 — Disclosure by comms, reviewed by security

**Symptom:** The customer notification is written by the marketing team, softened for brand protection, and security is asked to "approve the wording."

**Consequence:** The disclosure omits the technical facts customers need to act. "We take security seriously" replaces the action item. Customers stay exposed.

**Fix:** Disclosure is a security function. Security drafts; comms reviews for tone and channel. Not the reverse. The technical facts are non-negotiable.

### Pitfall 2 — False assurance

**Symptom:** "We have no evidence that any data was accessed." (When the investigation is incomplete.)

**Consequence:** When evidence of access is later found, the organization has a worse disclosure problem than if they'd stated uncertainty initially.

**Fix:** State what you know and what you don't. "We have no evidence of unauthorized access as of the time of this notice; our investigation is ongoing" is accurate. "No data was accessed" is a factual claim that requires evidence.

### Pitfall 3 — Indefinite vendor hold

**Symptom:** Vendor disclosure sent; vendor responds "we're working on it"; you wait indefinitely for a patch before publishing.

**Consequence:** Users of the vulnerable product are exposed indefinitely. The vendor's patch timeline is not the public's security problem.

**Fix:** Commit to the 90-day window at the time of disclosure. State it in the initial notification. Honor it — with a single, reasonable extension if the vendor is making credible progress.

### Pitfall 4 — Missing regulatory requirements

**Symptom:** Customer notification goes out 10 days after incident discovery; GDPR required 72 hours.

**Consequence:** Regulatory penalty; reputational damage worse than the incident itself.

**Fix:** The IR runbook (see [`ir-runbook`](../ir-runbook/SKILL.md)) pre-stages the regulatory requirements and their timings. Disclosure-comm drafts against those requirements; legal review confirms compliance before sending.

### Pitfall 5 — Technical detail that enables exploitation

**Symptom:** The security advisory includes the full proof-of-concept exploit code "to help users understand the severity."

**Consequence:** Users who haven't patched are now facing active exploitation within hours of the advisory publishing.

**Fix:** CVE advisories include enough to patch and assess exposure; not enough to exploit. Reproduction steps are in the vendor-disclosure channel, not the public advisory.

### Pitfall 6 — Action item buried or absent

**Symptom:** The customer notification is four paragraphs of what happened and what the company is doing; the action item ("rotate your API key") is in paragraph four.

**Consequence:** Customers who skim (most customers) don't take the action. The disclosure has not actually reduced their risk.

**Fix:** The customer's action item is in the first three sentences and formatted for scanability (bold, numbered step). The narrative can follow.

## References

- **Bruce Schneier** — *Secrets and Lies: Digital Security in a Networked World* (2000); the transparency-first stance on disclosure as a security property of the ecosystem, not a PR choice.
- **Tavis Ormandy / Google Project Zero** — [Project Zero blog](https://googleprojectzero.blogspot.com/); the 90-day coordinated disclosure norm; public methodology for framing technical findings for an at-risk public. See `roles/security-expert/sources.md`.
- **MITRE** — [CVE Program](https://www.cve.org/) (vulnerability identification); [NVD / CVSS](https://nvd.nist.gov/) (scoring and advisory format); the CVE structure for security-advisory disclosures.
- **NIST** — [SP 800-61 r2](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final) (incident-handling and notification guidance); GDPR Art. 33/34; HIPAA Breach Notification Rule; state breach-law frameworks.
- **Kim Zetter** — *Countdown to Zero Day* (2014); case-study realism on disclosure timing, attacker knowledge assumptions, and what defenders actually need to act.
- **Related Hornero skills:**
  - [`ir-runbook`](../ir-runbook/SKILL.md) — the runbook pre-stages communication templates; this skill drafts and refines them.
  - [`hardening-checklist`](../hardening-checklist/SKILL.md) — post-disclosure hardening review updates the checklist with the control that failed.
  - [`threat-model`](../threat-model/SKILL.md) — Shostack's fourth question ("did we do a good job?") applies post-disclosure: update the threat model with any adversary behavior or attack path the incident revealed.
  - [`security-review`](../security-review/SKILL.md) — a security advisory for your own product typically follows a security review that identified the finding; cross-link.
