# NIST — distilled

> **NIST SP 800-63** (digital identity guidelines, rev. 3 / rev. 4 draft), **SP 800-53** (security and privacy controls catalogue, rev. 5), **AI Risk Management Framework (AI RMF 1.0, 2023)**. The US federal reference frameworks that regulatory auditors, enterprise procurement, and compliance certifications treat as authoritative. Three distinct documents; one shared role: translating security intent into verifiable, citable controls.

## Why it matters for AI-coding

AI-generated code rarely cites controls by ID. A generated auth flow will say "use strong passwords and MFA" without naming NIST SP 800-63B AAL2 as the requirement that makes that statement auditor-legible. This gap matters because regulated industries — finance, healthcare, federal contracting — evaluate systems against specific control identifiers, not general intent. When a security finding says "A02:2021 — Cryptographic Failures," NIST SP 800-53 control SC-12 (cryptographic key establishment) or SC-28 (protection of information at rest) is the bridge from "this is a problem" to "this is the control a SOC 2 or FedRAMP auditor expects to see." Similarly, AI RMF's four core functions (Govern, Map, Measure, Manage) provide the governance vocabulary that transforms a one-off LLM risk assessment into a repeatable, auditable process — which is what enterprise customers buying AI-integrated products are evaluating against.

The NIST anchor fills a gap that OWASP deliberately leaves: OWASP names categories; NIST names the specific, numbered controls that satisfy them.

## Key concepts the role pulls from

- **SP 800-63 AAL tiers (Authenticator Assurance Levels).** AAL1 / AAL2 / AAL3 define the credential strength required for different risk levels. AAL2 (phishing-resistant MFA) is the practical bar for most production systems handling sensitive data. Any generated auth flow should be positioned against an AAL tier — not left as "use MFA" without specificity. Powers the control-critique dimension of `security-review` and `pre-launch-security-audit`.
- **SP 800-53 control families as the finding-map vocabulary.** 800-53 r5 organises ~1,000 controls into 20 families (AC — Access Control, IA — Identification and Authentication, SC — System and Communications Protection, SI — System and Information Integrity, etc.). A `security-review` finding mapped to AC-3 (access enforcement) or IA-5 (authenticator management) gives regulated-industry teams the citation they need to track remediation against a compliance baseline.
- **SP 800-53 baselines (Low / Moderate / High).** Not all controls apply to every system. NIST defines three baselines keyed to the impact level of the system (federal classification) — the same logic applies in commercial: a low-impact internal tool and a system processing PII have different applicable control sets. The role uses baselines to scope which controls to check, not to apply every control universally.
- **AI RMF core functions: Govern, Map, Measure, Manage.** The 2023 AI RMF provides a risk-governance vocabulary for AI systems. Govern = policies and accountabilities around AI risk; Map = identify AI risks in context; Measure = quantify and track them; Manage = respond and recover. For `llm-risk-assessment`, the Map function is directly operational: it names the same step as the assessment itself. Govern and Measure are what convert a point-in-time assessment into an ongoing program.
- **AI RMF subcategories for trustworthiness.** The framework defines trustworthy AI properties: valid and reliable, safe, secure and resilient, explainable and interpretable, privacy-enhanced, fair with harmful-bias managed, accountable and transparent. "Secure and resilient" links directly to prompt-injection and supply-chain concerns from the OWASP LLM Top 10; "valid and reliable" covers the misinformation surface (LLM09). Having both taxonomies available lets the assessment speak to both security teams and AI-governance stakeholders.
- **NIST Cybersecurity Framework (CSF) 2.0 as organisational layer.** CSF organises cybersecurity outcomes into six functions: Govern, Identify, Protect, Detect, Respond, Recover. When a `pre-launch-security-audit` produces a Go / Fix-then-go / Hold, the CSF vocabulary helps PM and leadership frame what "fix-then-go" means operationally — is the gap in Protect (missing control) or Detect (no monitoring)?

## What to actually read (1-hour budget)

- **SP 800-63B** (authentication and lifecycle management), sections 4-5: the AAL tier definitions and what each requires. Thirty minutes is enough to anchor the tiers in memory.
- **SP 800-53 r5**: the control family introductions (not individual controls — those are reference material). AC, IA, SC, SI families first. Use as a lookup table thereafter.
- **AI RMF 1.0** — the "core" section (~20 pages). The Govern / Map / Measure / Manage functions and their sub-functions. The profiles section is context-specific; skip until a specific profile applies.
- Skip the CSF subcategory detail on first read; treat it as a reference to reach for when framing a finding for a non-technical stakeholder.

## What to skip

- SP 800-53 individual control descriptions in full — this is a reference catalogue. Read family introductions; look up specific controls when a finding warrants it. Reading cover-to-cover is counterproductive.
- SP 800-63A and 800-63C (identity proofing and federation) unless the system under review does identity proofing or runs an identity federation. 800-63B (authentication) is the practical entry point for most applications.
- NIST CSF 1.1 — superseded by CSF 2.0 (2024). Any reference to "the five CSF functions" (Identify, Protect, Detect, Respond, Recover) is the older version; CSF 2.0 adds Govern as the sixth.
- The SP 800-53 overlays (privacy, supply chain) on first pass — useful for specific regulated contexts; not load-bearing for the role's core skills.

## How this anchors role skills

- [`security-review`](../../roles/security-expert/skills/security-review/SKILL.md) — NIST control IDs (SP 800-53) provide the auditor-legible citation layer on top of OWASP classifications. A finding citing "OWASP A07; ASVS V2.1; CWE-307; NIST IA-11" is complete for enterprise teams.
- [`llm-risk-assessment`](../../roles/security-expert/skills/llm-risk-assessment/SKILL.md) — AI RMF Map function is the structural parallel to the assessment's risk-enumeration phase. AI RMF's trustworthy-AI properties map LLM risks to governance vocabulary.
- [`pre-launch-security-audit`](../../roles/security-expert/skills/pre-launch-security-audit/SKILL.md) — CSF 2.0 functions provide the organisational framing for the audit's Go / Fix-then-go / Hold; SP 800-53 baselines set the control scope for the specific impact level of the system being launched.
- [`threat-model`](../../roles/security-expert/skills/threat-model/SKILL.md) — SP 800-63 AAL tiers help calibrate adversary budget at Step 4 (name the adversaries): an AAL1 system is exploitable by commodity phishing; AAL2 raises the attacker's required investment.

## Cross-role connection

NIST controls translate directly into PM acceptance criteria for regulated-industry features. A PM whose product must meet NIST Moderate baseline needs "AAL2 MFA required for all admin operations" as a testable acceptance criterion, not "security is important." When the security role maps a finding to SP 800-53 IA-5(1) (password-based authenticator strength), the PM can convert that directly into a user story with a verifiable condition — the same bridge NIST was designed to support.
