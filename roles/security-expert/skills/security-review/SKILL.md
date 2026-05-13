---
name: security-review
description: Use when a code change, feature, or system needs a structured security review producing findings mapped to OWASP Top 10 / ASVS, each with a reproduction, severity, and remediation.
intent: |
  Produces or evaluates a security review report. The report is the
  point-in-time complement to the design-time threat model: it
  examines what was actually built, finds specific issues, and
  produces an actionable Go / Fix-then-go / Hold recommendation.
  Resists compliance theatre by demanding reproductions for every
  finding and severity by impact, not by aesthetic.
type: component
theme: review-time-security
best_for:
  - Pre-merge review of a PR touching auth, session, crypto, or input parsing
  - Pre-launch review of a feature before public release
  - External-facing API or webhook surface review
  - A periodic audit of a high-risk area (payments, PII handling)
scenarios:
  - "Reviewing the diff that introduces a new public REST endpoint"
  - "Pre-launch review of a redesigned password-reset flow"
  - "Auditing a new third-party webhook integration that triggers writes"
  - "Reviewing the diff that adds an LLM call invoked by user input"
estimated_time: 45-120 minutes (single PR / feature); 4-8 hours (large system review)
---

# Security review

> v0 draft. Grounded in OWASP's Top 10 (2021) and ASVS (Application Security Verification Standard, v4.0.3), Adam Shostack's review-as-conversation framing, NIST SP 800-53 control catalogue (used as a reference, not a recipe), and Tavis Ormandy / Google Project Zero's vulnerability-research practice on reproductions and disclosure.

## Purpose

Produce a security review report that:

1. **Frames the scope** — what was reviewed; what tools used; what was deliberately not in scope.
2. **Lists findings** — each with the affected surface, the issue, a reproduction, an OWASP / ASVS / CWE classification, a severity, and a remediation.
3. **Names the adversary that exploits each finding** — connecting the review to the threat model (or, if no model exists, prompting one).
4. **Produces a recommendation** — Go / Fix-then-go / Hold — defensible, evidence-based.
5. **Hands off cleanly** — findings have owners, deadlines, and re-review conditions.

A security review is *not* the threat model. The threat model says what *could* go wrong by design; the review says what is *actually* wrong now. The two complement: the model frames the questions, the review answers them against the implementation.

A "security review" without reproductions, severity, or remediation is a worry list. The skill exists to make the difference unambiguous.

## Key Concepts

### OWASP Top 10 (2021)

The most-cited categorisation of web application risks. Used to classify findings:

1. **A01:2021 — Broken Access Control** — authorization bypass, IDOR, missing function-level access control.
2. **A02:2021 — Cryptographic Failures** — weak algorithms, mismanaged keys, sensitive data in transit/at rest.
3. **A03:2021 — Injection** — SQL, NoSQL, OS-command, LDAP, ORM, expression-language.
4. **A04:2021 — Insecure Design** — missing security in design (vs. implementation bug).
5. **A05:2021 — Security Misconfiguration** — defaults left enabled, unnecessary features, verbose errors.
6. **A06:2021 — Vulnerable and Outdated Components** — dependencies with known CVEs.
7. **A07:2021 — Identification and Authentication Failures** — credential stuffing, session fixation, weak password storage.
8. **A08:2021 — Software and Data Integrity Failures** — unsigned updates, deserialization, supply-chain.
9. **A09:2021 — Security Logging and Monitoring Failures** — undetectable attacks; PII in logs.
10. **A10:2021 — Server-Side Request Forgery (SSRF)** — server fetching attacker-controlled URLs.

A finding gets classified. Multiple classifications are allowed if a finding crosses categories (a credential-stuffing-enabling design choice is A04 + A07).

### ASVS — application security verification standard

OWASP's ASVS (v4.0.3) is a catalogue of ~280 testable security requirements, organised by category (authentication, session, access control, etc.) and level (1 / 2 / 3). The review uses ASVS as:

- **A finding map.** Each finding traces to one or more ASVS requirements the system fails.
- **A coverage indicator.** The review section names which ASVS categories were considered (not necessarily passed; considered) and which were out of scope.

ASVS is the *floor*, not the ceiling — like WCAG for accessibility. A system can be ASVS-conformant and still have substantive issues.

### CWE classification for root cause

When a finding has a clear root cause (not a design choice but an implementation defect), classify by MITRE's [CWE](https://cwe.mitre.org/) — e.g., CWE-89 (SQL injection), CWE-79 (XSS), CWE-352 (CSRF), CWE-639 (IDOR by user-controlled key). The classification helps the team see whether multiple findings share a root cause that warrants a class-level fix.

### Severity by impact, not by aesthetic

Each finding has a severity. The skill uses a four-level rubric tied to impact:

- **Critical** — exploitation directly leads to data exfiltration, takeover, or persistent unauthorized access. Fix before launch; treat as incident-grade if found in production.
- **High** — exploitation degrades a primary security property under realistic conditions; user data, auth, or integrity is affected.
- **Medium** — exploitation requires unusual conditions or yields limited impact; defense in depth degraded.
- **Low** — informational; hardening opportunity; no realistic exploitation path identified.

Findings without severity are noise; inflated severity erodes trust.

### Reproduction is the load-bearing claim

Each finding includes enough information that someone else can reproduce the issue:

- The affected surface (URL, function, file:line).
- The conditions (auth state, input, environment).
- The behaviour observed (with response code, output, or specific evidence).
- The tool used (Burp request, curl command, screenshot, code reading).

A finding without a reproduction is unfalsifiable. Engineering will reject it (rightly); reviewers will distrust the report.

### Remediation, with options where they exist

Each finding has at least one remediation. Where there is genuine choice, multiple options with trade-offs. Where there isn't, the recommended fix is stated.

Remediations are specific: not "validate inputs," but "switch from string concatenation to parameterised queries in `orders/queries.py:validate_search`; the pattern is already used in `users/queries.py`."

### Findings tied to threat-model adversaries

When a threat model exists, each finding references the adversary that exploits it. This connects the review to the design-time analysis; mismatches surface gaps in either artifact.

When no threat model exists, the review opens with a brief adversary list — implicitly demanding a threat model exist before the next review.

### Recommendation discipline

The review concludes with a single recommendation: Go / Fix-then-go / Hold. The recommendation is supported by the findings; it is not a vote-counting exercise. The team can override (recorded with reasoning), but the recommendation is the reviewer's professional output.

## Application

### Step 1 — Frame the review

State:

- **Scope** — what is being reviewed (PR, feature, system).
- **Pre-reads** — RFC, threat model, prior reviews, related ADRs.
- **Tools** — code reading, dependency scan (e.g., `npm audit`, `pip-audit`, GitHub Dependabot, Snyk), SAST (semgrep, Bandit, Brakeman, etc.), DAST (ZAP, Burp), manual testing.
- **Out of scope** — what was deliberately not covered and why.

### Step 2 — Map the attack surface

For the scope, list:

- **Trust boundaries crossed** — where untrusted input enters; where trusted data leaves.
- **Privileged operations** — anything that mutates state, accesses sensitive data, or escalates capability.
- **New dependencies** — packages added in this diff or feature.
- **Auth surfaces** — anything touching authentication, authorization, or session.

If a threat model exists, cross-reference its DFD; if not, write a quick attack-surface inventory inline.

### Step 3 — Walk OWASP Top 10 against the surface

For each Top-10 category, ask: does this scope plausibly contain an issue in this category? If yes, investigate; if no, skip silently.

This is *not* a tickbox walk — it is a scoping exercise that focuses the deep investigation.

### Step 4 — Investigate each likely category

For each category warranting investigation:

- **A01 Broken Access Control** — read every privileged-operation endpoint. Is the auth check present? Is it at the *right* level (object-level, not just endpoint-level)? Are there indirect-object-reference patterns (IDs in URLs that could be replaced)?
- **A02 Cryptographic Failures** — read the crypto code. Are primitives used directly? Is there homemade key management? What hash function is used for passwords? Are TLS settings sane?
- **A03 Injection** — read every place untrusted input meets a parser or interpreter. SQL, OS commands, ORM expressions, template engines, regex constructed from input.
- **A04 Insecure Design** — read the design (RFC, threat model). Are the security properties stated? Is the design symmetric with how it will actually be used?
- **A05 Misconfiguration** — read the deploy config. CORS, security headers, default credentials, verbose errors, debug endpoints exposed.
- **A06 Vulnerable Components** — run dependency scan. Are dependencies pinned? Up-to-date? Maintained?
- **A07 Auth Failures** — read the auth surfaces. Rate limiting? Account-lockout? Password storage (Argon2id / scrypt / bcrypt)? MFA optional/required? Session management?
- **A08 Integrity Failures** — read the supply chain. Are updates signed? Is deserialization safe? Is CI/CD code-signed?
- **A09 Logging and Monitoring** — read the logging. What is logged? What is *not* logged that should be? Is PII redacted? Are detections wired up?
- **A10 SSRF** — search for HTTP / DNS / fetch operations where the URL is partially or fully user-controlled.

Document findings as you go. Each finding has: surface, issue, reproduction, classification, severity, suggested remediation.

### Step 5 — Run dependency / SAST tools

Tools surface a complementary class of issue:

- **Dependency scanners** find known-CVE components (A06).
- **SAST** finds patterns matching known vulnerability classes (often A01, A03, A05).
- **DAST** finds runtime issues against a deployed instance.

Tool output is *evidence*, not findings — review each result, confirm it's real, and write up only the confirmed ones. False-positive triage is part of the review.

### Step 6 — Author the report

```markdown
# Security review — <scope>

- **Reviewer:** <name>
- **Date:** <YYYY-MM-DD>
- **Scope:** <PR / feature / system>
- **Status:** Draft | In review | Issued | Closed
- **Recommendation:** Go | Fix-then-go | Hold
- **Pre-reads:** <RFC, threat model, prior review links>
- **Tools used:** <dep scan, SAST, DAST, manual>

## Summary

<3-5 sentences. The recommendation and headline reasoning. Highest-
severity findings. Out-of-scope acknowledgement.>

## Attack-surface summary

<Trust boundaries crossed; new dependencies; auth surfaces touched.>

## Findings

For each finding:

### Finding F-001 — <short title>

- **Severity:** Critical | High | Medium | Low
- **Classification:** <OWASP A##, ASVS V#.#.#, CWE-###>
- **Adversary:** <reference to threat model adversary or inline description>
- **Surface:** <file:line, URL, endpoint>
- **Issue:** <what is wrong>
- **Reproduction:** <enough detail that engineering can confirm>
- **Impact:** <what an exploitation gets the adversary>
- **Remediation:** <specific fix; options where there is genuine choice>
- **Test:** <test that would catch a regression — exists or to be written>
- **Owner:** <named person or team>
- **Status:** Open | In progress | Fixed | Accepted-risk | Wont-fix

(Repeat per finding.)

## Positive findings

<Where the system notably honours controls — worth keeping when
remediations land.>

## Tool output (not converted to findings)

<Tool results that were false positives or out-of-scope, briefly
acknowledged.>

## Severity rollup

| Severity | Count | Open |
|---|---|---|

## Out of scope

<Areas deliberately not reviewed and why.>

## Re-review conditions

<When this scope is re-reviewed. On every diff to it? After a specific
finding is fixed? Quarterly?>

## References

<OWASP / ASVS / CWE link list; related Hornero skills.>
```

### Step 7 — Walk the report with engineering and PM

The review is delivered as a conversation, not a memo. Reviewers can argue with severity, remediation, or classification — they cannot argue with reproductions. Disputes log with the dispute and a decision date.

### Step 8 — Track remediation; re-review

Each finding has an owner and a status. Critical and High findings re-review before launch. Medium and Low can be tracked through subsequent reviews unless they aggregate to a risk threshold.

The review is filed in the security-docs repo. Cross-link from the PR description / launch ticket.

## Examples

### Example 1 — Useful finding (good)

```markdown
### Finding F-007 — IDOR on /api/orders/{id}

- **Severity:** Critical
- **Classification:** OWASP A01:2021; ASVS V4.2.1; CWE-639 (Authorization Bypass Through User-Controlled Key)
- **Adversary:** A1 — Logged-in customer trying to read another customer's data (per threat model 2025-09-15)
- **Surface:** `services/orders/handlers.py:48` in `get_order_handler`
- **Issue:** The handler fetches the order by id but does not verify the order's `user_id` matches the session's `user_id`. Any authenticated user can pass another user's order id in the URL and read it.
- **Reproduction:**
  ```bash
  # As user-1, create an order. Note the order id.
  curl -X POST -H "Authorization: Bearer $USER1" \
    -d '{"sku":"WIDGET-1","qty":2}' \
    https://staging.example.com/api/orders
  # Response includes {"order_id":"ord_42abc..."}

  # As user-2, fetch user-1's order:
  curl -H "Authorization: Bearer $USER2" \
    https://staging.example.com/api/orders/ord_42abc...
  # Response: 200 OK with user-1's order details, including
  # shipping address and line items.
  ```
- **Impact:** Full read of any customer's order including shipping addresses (PII), product preferences, and totals. Trivially enumerable since order ids are sequential-ish.
- **Remediation:** Add an authorization check immediately after the order fetch:
  ```python
  order = orders_repo.get(order_id)
  if order is None or order.user_id != request.session.user_id:
      raise NotFound()  # not Forbidden — don't leak existence
  ```
  The pattern is already used in `services/invoices/handlers.py:31`. Consider introducing a decorator `@requires_owner('order')` for consistency across all object-scoped endpoints.
- **Test:** TC-1019 (positive: user-1 can read own order) and TC-1020 (negative: user-2 gets 404 on user-1's order). Both regression tests for BUG-1119. Currently missing for this endpoint specifically.
- **Owner:** Orders team — Aisha
- **Status:** Open. Target fix: before launch. PR-2231 in flight.
```

A reviewer can argue with the severity (some might say High, not Critical, because the user count is small); they can verify the reproduction; they can read the remediation and trust the pattern points to existing code. The finding is actionable.

### Example 2 — Failure mode (bad)

```markdown
## Findings
- The orders endpoint might have authorization issues.
- We should review the crypto.
- Some dependencies are old.
- Probably need rate limiting.

## Recommendation: Hold.
```

Failures: no surface citations; no reproductions; no severity; no remediation; no classification; "might have" is not a finding; "Hold" is not defensible against engineering pushback. The reviewer asked the team to slow down without giving them anything to act on.

## Common Pitfalls

### Pitfall 1 — Finding without reproduction

**Symptom:** "Possible IDOR in the orders endpoint." No example, no curl command, no specific id.

**Consequence:** Engineering can't verify or fix. The finding is bounced back. Trust erodes.

**Fix:** Every finding cites surface + reproduction. If you only have a hunch, the finding is "needs investigation" and gets investigated before going into the report.

### Pitfall 2 — Tool output dumped without triage

**Symptom:** The findings section is 80 SAST results pasted in.

**Consequence:** Most are false positives. Engineering loses trust in the review. The few real findings are lost in the noise.

**Fix:** Triage tool results. Convert real ones into findings with the reviewer's own reproduction and analysis. Acknowledge false positives in a separate section, briefly.

### Pitfall 3 — Compliance scoring instead of risk analysis

**Symptom:** Review is an ASVS-checklist conformance score (e.g., "ASVS Level 2: 87 of 120 controls passing").

**Consequence:** Engineering optimises the score, not the security. ASVS controls technically present but practically broken pass the score.

**Fix:** ASVS-mapping is a classification aid for findings, not the review's spine. The review's spine is the attack-surface walk and the findings produced.

### Pitfall 4 — Severity inflation

**Symptom:** Every finding is Critical or High.

**Consequence:** Engineering can't prioritise. Real Critical findings are treated as "another one to fix." Launch decisions get political.

**Fix:** Apply the rubric honestly. Critical = direct exfiltration / takeover under realistic conditions. Be willing to defend each severity.

### Pitfall 5 — Remediation as slogan

**Symptom:** "Validate inputs." "Add auth check." "Use HTTPS." Nothing specific to the surface.

**Consequence:** Engineering improvises remediations; some fixes are wrong; new issues introduced; trust erodes.

**Fix:** Specific file:line remediations; cite existing patterns in the codebase; note trade-offs where genuine choice exists.

### Pitfall 6 — Review without recommendation

**Symptom:** "Here are 14 findings. Discuss." No Go / Fix-then-go / Hold.

**Consequence:** PMs and engineers decide based on aesthetic. The reviewer's professional judgement is omitted from the most important moment.

**Fix:** Always include a recommendation. Defend it. If pushed back, log the override with reasoning.

### Pitfall 7 — No re-review

**Symptom:** Findings are marked "Open" and never revisited.

**Consequence:** Findings rot. New diffs introduce new issues; nobody is mapping the trend; old findings drift back into "we forgot about that."

**Fix:** Re-review condition stated. Critical / High findings have a target re-review date; the system gets re-reviewed on a stated cadence or trigger.

### Pitfall 8 — Adversary-free review

**Symptom:** Findings list issues without saying who would exploit them or why.

**Consequence:** The team can't calibrate the urgency. A theoretical issue gets the same weight as one that a credential-stuffing botnet is actively probing right now.

**Fix:** Each finding references an adversary (from the threat model or inline). If you can't name one, ask whether the finding is real.

## References

- **OWASP** — [Top 10 (2021)](https://owasp.org/Top10/); [ASVS v4.0.3](https://owasp.org/www-project-application-security-verification-standard/); [Cheat Sheet Series](https://cheatsheetseries.owasp.org/). See `roles/security-expert/sources.md`.
- **MITRE** — [CWE](https://cwe.mitre.org/) for root-cause classification of implementation bugs; [ATT&CK](https://attack.mitre.org/) for adversary TTP context.
- **NIST** — [SP 800-53 r5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) (control catalogue), [SP 800-63](https://pages.nist.gov/800-63-3/) (digital identity guidelines).
- **Adam Shostack** — *Threat Modeling: Designing for Security* (2014); the review-as-conversation framing.
- **Tavis Ormandy / Google Project Zero** — public bug reports as a model of reproduction-first vulnerability research; [bugs.chromium.org/p/project-zero](https://bugs.chromium.org/p/project-zero/).
- **Matt Green** — [Cryptography Engineering blog](https://blog.cryptographyengineering.com/); the why behind crypto-failure findings (A02).
- **Related Hornero skills:**
  - [`threat-model`](../threat-model/SKILL.md) — design-time complement; findings reference the model's adversaries.
  - [`llm-risk-assessment`](../llm-risk-assessment/SKILL.md) — for systems where LLM input/output is a surface, run alongside the OWASP Top 10 walk.
  - [`pre-launch-security-audit`](../pre-launch-security-audit/SKILL.md) — workflow that orchestrates this skill with threat-model and LLM-risk-assessment for launch decisions.
  - `roles/software-engineer/skills/rfc/SKILL.md` — RFCs touching security surfaces should reference the relevant review and threat model.
  - `roles/tester/skills/regression-test/SKILL.md` — Critical / High findings get regression tests authored here.
