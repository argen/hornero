# Security expert — sources

The curated bibliography for the security-expert role. Skills cite from this list. New frameworks introduced in skills must trace to a name here.

## Anchors

### OWASP (Open Worldwide Application Security Project)
- OWASP Top 10 (2021, periodically updated) — web application risks
- OWASP ASVS (Application Security Verification Standard) — control requirements
- OWASP Threat Modeling Cheat Sheet
- OWASP LLM Top 10 — AI-specific risks (prompt injection, training-data poisoning, model theft)
- OWASP Cheat Sheet Series
- **Why it matters:** The de facto open standard for application security. Top 10 is the industry baseline; ASVS is the verifiable control framework; LLM Top 10 is the canonical AI risk taxonomy.
- Used in: top-10-audit, asvs-review, llm-threat-model skills.

### NIST (US National Institute of Standards and Technology)
- NIST SP 800-53 — security controls catalog
- NIST SP 800-63 — digital identity guidelines (authentication)
- NIST Cybersecurity Framework (CSF) 2.0
- NIST AI Risk Management Framework (AI RMF)
- **Why it matters:** The reference framework for security controls in regulated industries; AI RMF is now widely cited for AI-system risk governance.
- Used in: controls-mapping, csf-assessment, ai-rmf-review skills.

### Adam Shostack
- *Threat Modeling: Designing for Security* (2014)
- *Threats: What Every Engineer Should Learn From Star Wars* (2023)
- STRIDE methodology (formalized at Microsoft; popularized by Shostack)
- Four-question frame: What are we building? What can go wrong? What are we going to do about it? Did we do a good job?
- **Why he matters:** The canonical practitioner voice on threat modeling for software engineers. Makes threat modeling teachable.
- Used in: threat-model, stride-pass, four-questions skills.

### Bruce Schneier
- *Applied Cryptography* (1996, rev. 2015)
- *Secrets and Lies: Digital Security in a Networked World* (2000, rev. 2004)
- *Liars and Outliers* (2012)
- schneier.com — Crypto-Gram newsletter; ongoing analysis
- **Why he matters:** Long-standing voice on security as systems thinking, not crypto-as-magic; the public-facing translator between security research and practice.
- Used in: threat-realism, security-economics skills.

### MITRE
- ATT&CK framework — adversary tactics and techniques taxonomy
- CWE (Common Weakness Enumeration) — software weakness taxonomy
- CVE — vulnerability identification
- **Why it matters:** ATT&CK is the standard adversary-modeling reference; CWE classifies weakness root causes; CVE is the universal vulnerability namespace.
- Used in: attack-mapping, weakness-classification skills.

### Troy Hunt
- Have I Been Pwned (haveibeenpwned.com) — breach data service
- troyhunt.com — applied web security writing
- "The 123456 problem" and password-policy critique
- **Why he matters:** Empirical voice on credential security; the canonical practitioner on real-world breach patterns and modern password practice.
- Used in: credential-hygiene, breach-response skills.

### Kim Zetter
- *Countdown to Zero Day: Stuxnet and the Launch of the World's First Digital Weapon* (2014)
- Long-form security journalism (Wired, then independent)
- **Why she matters:** Threat realism through case studies; the canonical narrative reference for sophisticated adversary behavior. Counterweight to abstract threat modeling.
- Used in: threat-realism, case-study skills.

### Tavis Ormandy + Google Project Zero
- Project Zero research blog (googleprojectzero.blogspot.com)
- 90-day disclosure norm
- **Why they matter:** Set the bar for adversarial-mindset security research. Public methodology for finding flaws in widely-deployed software. Project Zero practice has reshaped industry disclosure norms.
- Used in: adversarial-pass, disclosure-policy skills.

### Matt Green
- cryptographyengineering.com
- Crypto teaching and research at Johns Hopkins
- *A Few Thoughts on Cryptographic Engineering* (blog)
- **Why he matters:** Working-cryptographer voice on what crypto choices to make and avoid in production systems. Translator between academic crypto and applied engineering.
- Used in: crypto-review, key-management skills.

### Google BeyondCorp (whitepapers)
- *BeyondCorp: A New Approach to Enterprise Security* (Ward & Beyer, 2014)
- BeyondCorp implementation papers (2016-2018)
- Zero-trust architecture as deployed at scale
- **Why they matter:** Articulated the zero-trust model in concrete operational terms; the reference for moving away from perimeter-based security.
- Used in: zero-trust-review, network-segmentation skills.

## See also

- **Daniel Miessler** — danielmiessler.com; pragmatic security philosophy.
- **Chris Wysopal** — Veracode co-founder; AppSec practice voice.
- **Phil Zimmermann** — PGP creator; long-standing voice on privacy and crypto policy.
- **Window Snyder** — secure SDLC practice; ex-Apple Chief Security Officer.
- **Mudge (Peiter Zatko)** — security research / disclosure voice; Twitter whistleblower case.
- **Halvar Flake** — reverse engineering and binary analysis.
- **MITRE ATLAS** — adversarial ML threat matrix; companion to ATT&CK.

## Curation notes

Cap is ~10 anchors plus "see also." Adding a new anchor requires demoting an existing one.

The security domain has a wide tradition. The anchor selection deliberately covers: standards bodies (OWASP, NIST, MITRE), practitioner voices (Shostack, Schneier, Hunt, Green), adversarial research (Project Zero), case-based realism (Zetter), and modern architecture (BeyondCorp). Skills citing only "OWASP says..." or only "Schneier wrote..." are too narrow; good security thinking integrates standards with adversarial mindset and case realism.

AI-specific security (prompt injection, training-data poisoning, jailbreaks, agent abuse) is currently covered via OWASP LLM Top 10 and NIST AI RMF anchors. As the field matures, expect a dedicated AI-security anchor (Simon Willison's prompt-injection writing is a candidate).
