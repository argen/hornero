# Research — security-expert

Distilled notes from the security-expert role's anchor bibliography. See [`../../roles/security-expert/sources.md`](../../roles/security-expert/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the security-expert role on a non-trivial task and you've never read these, here's the priority order:

1. **[`shostack-threat-modeling.md`](shostack-threat-modeling.md)** — the canonical practical threat-modeling book; the 4-question framework + STRIDE-per-element + DFDs that power `threat-model`.
2. **[`owasp-top10-asvs-llm.md`](owasp-top10-asvs-llm.md)** — the working risk catalogues (Top 10, ASVS, LLM Top 10); the naming layer for findings; powers `security-review` and `llm-risk-assessment`.
3. **[`schneier-secrets-and-lies.md`](schneier-secrets-and-lies.md)** — systems-thinking posture; security as a property of the whole, not a feature; attack trees; adversary realism.
4. **[`nist-control-frameworks.md`](nist-control-frameworks.md)** — SP 800-63 AAL tiers, SP 800-53 control families, AI RMF; translates findings into auditor-legible evidence.
5. **Greshake et al. — Indirect Prompt Injection** (note pending) — the LLM-era academic landmark; powers `llm-risk-assessment`. OWASP LLM Top 10 covers this attack surface for the role's practical skills; the Greshake note remains deferred.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| Adam Shostack | ✓ [`shostack-threat-modeling.md`](shostack-threat-modeling.md) | `threat-model`, `pre-launch-security-audit` |
| OWASP | ✓ [`owasp-top10-asvs-llm.md`](owasp-top10-asvs-llm.md) | `security-review`, `llm-risk-assessment`, `pre-launch-security-audit`, `threat-model` |
| NIST | ✓ [`nist-control-frameworks.md`](nist-control-frameworks.md) | `security-review`, `llm-risk-assessment`, `pre-launch-security-audit`, `threat-model` |
| Bruce Schneier | ✓ [`schneier-secrets-and-lies.md`](schneier-secrets-and-lies.md) | `threat-model`, `security-review`, `pre-launch-security-audit`, `llm-risk-assessment` |
| MITRE | ✓ [`mitre-attack-cwe-atlas.md`](mitre-attack-cwe-atlas.md) | `threat-model`, `security-review`, `llm-risk-assessment`, `pre-launch-security-audit` |
| Tavis Ormandy / Project Zero | ✓ [`ormandy-project-zero.md`](ormandy-project-zero.md) | `security-review`, `pre-launch-security-audit`, `threat-model`, `llm-risk-assessment` |
| Matt Green | ✓ [`green-applied-crypto.md`](green-applied-crypto.md) | `security-review`, `pre-launch-security-audit`, `threat-model`, `llm-risk-assessment` |
| Kim Zetter | ✓ [`zetter-adversary-realism.md`](zetter-adversary-realism.md) | `threat-model`, `security-review`, `pre-launch-security-audit`, `llm-risk-assessment` |
| Troy Hunt | ✓ [`hunt-credential-security.md`](hunt-credential-security.md) | `security-review`, `pre-launch-security-audit`, `threat-model`, `llm-risk-assessment` |
| Google BeyondCorp | ✓ [`google-beyondcorp.md`](google-beyondcorp.md) | `security-review`, `threat-model`, `pre-launch-security-audit`, `llm-risk-assessment` |
| Halvar Flake | — | reverse-engineering perspective |
| Simon Willison | — | LLM-specific risk (`llm-risk-assessment` — pending sources.md promotion) |

## See also

- `../../roles/security-expert/sources.md` — the full bibliography these notes summarise.
- `../../roles/security-expert/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
