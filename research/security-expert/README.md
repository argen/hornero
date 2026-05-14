# Research — security-expert

Distilled notes from the security-expert role's anchor bibliography. See [`../../roles/security-expert/sources.md`](../../roles/security-expert/sources.md) for the full curated list.

## Reading order for a new agent

If you're an agent about to adopt the security-expert role on a non-trivial task and you've never read these, here's the priority order:

1. **[`shostack-threat-modeling.md`](shostack-threat-modeling.md)** — the canonical practical threat-modeling book; the 4-question framework + STRIDE-per-element + DFDs that power `threat-model`.
2. **OWASP — Top 10 + ASVS + LLM Top 10** (note pending) — the working risk catalogues; powers `security-review` and `llm-risk-assessment`.
3. **Schneier — Secrets and Lies** (note pending) — adversary realism; the systems-thinking case for security as a property of the whole, not a feature.
4. **NIST SP 800-63 / SP 800-53** (note pending) — auth-flow + control catalogue standards; powers detailed control critique.
5. **Greshake et al. — Indirect Prompt Injection** (note pending) — the LLM-era academic landmark; powers `llm-risk-assessment`.

## Status

| Anchor | Note shipped | Skill(s) that draw from it |
|---|---|---|
| Adam Shostack | ✓ [`shostack-threat-modeling.md`](shostack-threat-modeling.md) | `threat-model`, `pre-launch-security-audit` |
| OWASP | — | `security-review`, `llm-risk-assessment` |
| NIST | — | control critique, `pre-launch-security-audit` |
| Bruce Schneier | — | adversary realism, `threat-model` |
| MITRE | — | CWE / ATT&CK referencing |
| Tavis Ormandy / Project Zero | — | vulnerability research patterns |
| Matt Green | — | crypto literacy in `security-review` |
| Kim Zetter | — | adversary case-studies |
| Halvar Flake | — | reverse-engineering perspective |
| Simon Willison | — | LLM-specific risk (`llm-risk-assessment` — pending sources.md promotion) |

## See also

- `../../roles/security-expert/sources.md` — the full bibliography these notes summarise.
- `../../roles/security-expert/ROLE.md` — the role's mindset / heuristics / anti-patterns; sources are referenced from there.
