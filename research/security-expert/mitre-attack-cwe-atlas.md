# MITRE — distilled

> **ATT&CK** (Adversarial Tactics, Techniques, and Common Knowledge), **CWE** (Common Weakness Enumeration), **CVE** (Common Vulnerabilities and Exposures), **ATLAS** (Adversarial Threat Landscape for Artificial-Intelligence Systems). Four interrelated MITRE projects covering distinct layers: ATT&CK names what adversaries *do* post-intrusion; CWE names the *weaknesses* in code that make intrusion possible; CVE is the universal *identifier* for specific disclosed vulnerabilities; ATLAS extends ATT&CK's adversary vocabulary to attacks against machine-learning systems. Together they form the reference taxonomy that makes threat models, security reviews, and LLM risk assessments legible to a global security community.

## Why it matters for AI-coding

AI tools generate attack scenarios without anchoring them to known tactics, techniques, and procedures. A threat model that says "an attacker could escalate privileges" is useful; one that says "an attacker uses T1548 (Abuse Elevation Control Mechanism) after initial access via T1190 (Exploit Public-Facing Application)" is *actionable* — it names the specific technique, which links to known mitigations, detection logic, and industry precedent. ATT&CK is the corrective vocabulary that makes threat models legible to red teams, detection engineers, and SOC analysts — the people who will evaluate whether the model's findings are realistic and whether the controls are well-matched.

CWE fills a complementary role: where ATT&CK describes adversary behavior, CWE describes the code-level weakness that the adversary exploits. A review finding that cites CWE-89 (SQL injection) is more actionable than one that says "the query is unsafe" — it names the weakness class, which links to CWE's remediation guidance, OWASP's corresponding category, and historical CVE instances.

ATLAS extends this vocabulary to ML attacks — model inversion, membership inference, adversarial examples, supply-chain poisoning — where ATT&CK has no direct coverage.

## Key concepts the role pulls from

- **ATT&CK tactics as the adversary narrative arc.** ATT&CK organises adversary behavior into a kill chain of tactics: Reconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, Command and Control, Exfiltration, Impact. Each tactic contains techniques (the *how*). The threat-model adversary list becomes more concrete when adversary paths are traced through ATT&CK tactics — not just "an attacker could steal credentials" but "an adversary using T1078 (Valid Accounts) for Initial Access following T1566 (Phishing) for Credential Access." Powers the adversary-naming step in `threat-model`.
- **ATT&CK techniques as detection anchors.** Each ATT&CK technique entry includes detection opportunities and mitigations. When a threat model names a technique, the linked mitigations are the starting point for controls — and the detection opportunities are the starting point for logging requirements. This connects threat modeling directly to monitoring design, which `security-review` checks in A09 (Security Logging and Monitoring Failures).
- **CWE as root-cause classification.** CWE classifies software weaknesses by root cause — not "this is vulnerable" but "the weakness type is CWE-79 (Improper Neutralisation of Input During Web Page Generation — XSS)." Root-cause classification matters because multiple surface-level findings can share one root cause: if three endpoints have CWE-89, the fix is a class-level change (switch to parameterised queries everywhere), not three individual patches. The `security-review` skill's finding template includes CWE classification; this is the field that surfaces class-level remediation opportunities.
- **CWE weakness categories and views.** CWE organises weaknesses into views (e.g., CWE Top 25 Most Dangerous Software Weaknesses; CWE for hardware; research concepts). The Top 25 is the practical entry point — the 25 most impactful weaknesses by frequency and severity, overlapping heavily with the OWASP Top 10 but providing finer-grained root-cause distinctions.
- **CVE as the vulnerability identifier.** When a `security-review` finding involves a known vulnerability in a dependency, CVE is the identifier. A finding citing "CVE-2021-44228 (Log4Shell) in log4j 2.14.0" is globally unambiguous; one citing "old logging library" is not. Dependency scans produce CVE references; the skill's Step 5 (run dependency / SAST tools) produces CVE-cited findings.
- **MITRE ATLAS for ML-specific adversary tactics.** ATLAS mirrors ATT&CK's structure but covers attacks targeting ML systems: ML Model Access (reconnaissance), ML Attack Staging (resource development), ML-specific techniques like Model Inversion, Membership Inference Attack, Adversarial Patch, Backdoor ML Model. For systems where the model itself is an asset (fine-tuned models, RAG corpora, embeddings), MITRE ATLAS provides the adversary-vocabulary complement to OWASP's LLM Top 10 risk catalogue (ATLAS names *what the adversary does*; LLM Top 10 names *what the system gets wrong*). Powers the `llm-risk-assessment` supply-chain and data-poisoning sections.

## What to actually read (1-hour budget)

- **ATT&CK for Enterprise** — the [tactics overview](https://attack.mitre.org/tactics/enterprise/) and three or four techniques in the Initial Access and Credential Access tactics. The goal is familiarity with the structure, not memorisation of the catalogue. (~20 min)
- **CWE Top 25** — the [current year's list](https://cwe.mitre.org/top25/) with the description of the top 10. Focus on CWE-89 (SQL injection), CWE-79 (XSS), CWE-352 (CSRF), CWE-639 (IDOR), CWE-287 (improper authentication). These are the entries most likely to appear in AI-generated code. (~15 min)
- **ATLAS** — the [matrix overview](https://atlas.mitre.org/) and the Reconnaissance and ML Attack Staging tactic entries. (~15 min)
- CVE itself needs no reading — it's a numbering scheme. Understand the format (CVE-YYYY-NNNNN) and how to look up entries via the NVD (nvd.nist.gov).

## What to skip

- ATT&CK for ICS and ATT&CK for Mobile unless the system under review explicitly targets those environments.
- CWE research-view hierarchies in full — the parent/child weakness taxonomy is useful for tool builders, not for security reviews. Stick to Top 25 and look up individual CWEs when a finding warrants it.
- ATLAS subtechniques in full on first pass; come back when assessing a specific ML attack scenario.

## How this anchors role skills

- [`threat-model`](../../roles/security-expert/skills/threat-model/SKILL.md) — ATT&CK techniques anchor the adversary-naming step; technique citations make the STRIDE table rows legible to red teams and detection engineers.
- [`security-review`](../../roles/security-expert/skills/security-review/SKILL.md) — CWE classification is the root-cause field in every finding; CVE identifiers anchor dependency-scan findings. The finding template's "Classification" column is "OWASP A##, ASVS V#.#.#, CWE-###."
- [`llm-risk-assessment`](../../roles/security-expert/skills/llm-risk-assessment/SKILL.md) — ATLAS provides the ML-specific adversary vocabulary for supply-chain (LLM03), data poisoning (LLM04), and excessive agency (LLM06) risk entries.
- [`pre-launch-security-audit`](../../roles/security-expert/skills/pre-launch-security-audit/SKILL.md) — ATT&CK mitigations and detection opportunities are the checklist behind "does the system have monitoring for the threats we named?"

## Cross-role connection

ATT&CK's structure — tactics containing techniques, techniques linked to mitigations and detection — is a measurement taxonomy in the data-scientist's sense: it organises a space of possible events by type, with a clear ontology and version history. The data-scientist role's emphasis on precise metric definition (what exactly is being measured?) parallels ATT&CK's insistence on technique precision (exactly what does the adversary do?). Both disciplines resist the same failure: a vague category that cannot be measured or detected.
