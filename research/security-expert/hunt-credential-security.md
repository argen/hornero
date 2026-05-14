# Troy Hunt — distilled

> **Have I Been Pwned** (haveibeenpwned.com, 2013–present); **troyhunt.com** (applied web security writing); the empirical case study literature on credential-breach patterns. Hunt is not a framework author — he is the empirical voice on credential security: what actually happens when password databases are breached, which anti-patterns persist at scale, and what modern credential hygiene looks like in production. His contribution to the methodology is data-grounded correction of the password folk wisdom that AI-generated auth flows reproduce.

## Why it matters for AI-coding

AI-generated authentication flows reliably reproduce the password anti-patterns that the security community spent a decade retiring. Minimum-length requirements that are too short, complexity rules that impede passphrases, security questions, periodic forced rotations, blocking pasting from password managers, SHA-1 password hashing — these appear in AI-generated code because they appeared in training data where they were treated as standard practice. Hunt's empirical work on billions of breach records is the clearest available evidence of *which specific patterns are still failing at scale* and *why* — not as theory but as data from real incidents. His HIBP service has catalogued over 600 million breached credentials; his writing translates that data into actionable anti-patterns.

When a `security-review` or `pre-launch-security-audit` finds "password hashed with MD5" or "no check against known-breached passwords at registration," Hunt's empirical work is the citation that makes the severity defensible. This is not a theoretical risk; it is a pattern documented across thousands of real breaches.

## Key concepts the role pulls from

- **Breached-credential checking at registration and login.** HIBP's core service: before accepting a new password, check it against the corpus of previously-breached credentials. NIST SP 800-63B codified this as a requirement (AAL1+): "Verifiers SHALL compare prospective secrets against a list that contains values known to be commonly-used, expected, or compromised." Hunt's HIBP k-anonymity API is the practical implementation of that requirement. Any generated auth flow missing this check is missing an NIST-required control, not just a best practice.
- **Why complexity rules are the wrong intervention.** Hunt's empirical work (backed by NIST 800-63B) shows that password complexity rules — "must include uppercase, lowercase, number, symbol" — produce predictable patterns (P@ssword1!) that weaker hash functions and dictionary attacks defeat trivially. The correct intervention is *length* (passphrases), *breach checking*, and *MFA* — not complexity rules. AI-generated forms that apply complexity rules are applying a pattern that has been empirically shown not to work.
- **The paste-blocking anti-pattern.** Blocking paste in password fields — a common "security theatre" control seen in AI-generated UI — makes password managers harder to use, which pushes users toward shorter, memorable passwords, which are weaker. Hunt documented this pattern and the harm it causes. The designer role's "password-manager-friendly form" affordance is anchored in this finding.
- **Forced periodic rotation as a harmful control.** Prior security policy mandated periodic password changes (every 90 days). Hunt's empirical analysis — aligned with NIST's revision of 800-63B — shows that forced rotation produces predictable increments (Password1 → Password2) and increases user fatigue without security benefit. NIST removed the recommendation; Hunt's data explains why. AI-generated auth systems that implement forced rotation are applying a deprecated pattern.
- **Breach notification as a security property.** HIBP's original insight: users cannot protect themselves from breaches they don't know about. The service exists to close the information gap. For product teams, breach monitoring (checking whether employees or users appear in new breach sets) is a security control, not just a nice-to-have. `pre-launch-security-audit` should verify whether a credential-monitoring strategy exists for the system's user base.
- **The scale of credential stuffing.** Hunt's data quantifies the credential-stuffing attack surface: billions of credential pairs from previous breaches are available to attackers. A system with weak password storage is not protecting a password in isolation — it is contributing credentials to the corpus that fuels stuffing attacks against every other site where users reuse them. This framing makes password storage strength a *social* security obligation, not just a per-system one.

## What to actually read (1-hour budget)

- **troyhunt.com** — search for "HIBP", "password", "have i been pwned"; read the five or six most-linked posts. "The Only Secure Password Is The One You Can't Remember" and the data-breach-analysis posts are the load-bearing ones.
- **NIST SP 800-63B, section 5.1.1** (memorised secrets): the normative grounding for the practices Hunt describes empirically. Ten minutes; positions Hunt's empirical work in the standards context.
- **HIBP k-anonymity API documentation** — understand how to query the API without sending the full password hash. This is the implementation reference for "check against known-breached passwords."

## What to skip

- Hunt's conference talks are good but largely duplicate the blog posts. Pick one if you prefer video; don't watch several expecting new material.
- Older posts pre-2018 where the specific numbers (count of records in a breach) have been superseded. The arguments are durable; the specific breach counts are outdated.

## How this anchors role skills

- [`security-review`](../../roles/security-expert/skills/security-review/SKILL.md) — credential-storage findings (A07:2021 — Identification and Authentication Failures; CWE-916 — Use of Password Hash with Insufficient Computational Effort) cite Hunt's empirical work as the severity anchor. A review that finds MD5 password hashing without citing the breach corpus evidence is producing a severity claim without evidence.
- [`pre-launch-security-audit`](../../roles/security-expert/skills/pre-launch-security-audit/SKILL.md) — the audit's auth-surface check includes: breach-checking at registration? Password storage algorithm correct (Argon2id / bcrypt / scrypt)? Paste allowed in password fields? Forced rotation absent? These derive from Hunt's canon.
- [`threat-model`](../../roles/security-expert/skills/threat-model/SKILL.md) — the A2 "credential-stuffing botnet" adversary in the example threat model exists because Hunt's data quantifies exactly how realistic this adversary is. Plausibility is "high" because the corpus exists and the tooling is cheap.
- [`llm-risk-assessment`](../../roles/security-expert/skills/llm-risk-assessment/SKILL.md) — LLM06 (Sensitive Information Disclosure) includes credential disclosure; Hunt's framework for what constitutes a breach event is the definitional anchor.

## Cross-role connection

Hunt's work on password-field UX — specifically blocking paste, hiding generation affordances, adding complexity rules that constrain rather than strengthen — is directly actionable for the designer role. The designer's "password-manager-friendly form" affordance is empirically grounded by Hunt's breach data: forms that block paste force users to type passwords, which means shorter, less-random passwords, which means more crackable credentials. The Hunt–designer connection is one of the clearest examples in the methodology of empirical security research driving UX decisions.
