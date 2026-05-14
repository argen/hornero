# OWASP — distilled

> **OWASP Top 10** (2021), **OWASP ASVS** (Application Security Verification Standard, 4.0.3), **OWASP LLM Top 10** (1.1, 2024). The working risk catalogues for web and LLM-integrated applications. Unlike a single book, OWASP is a body of ongoing work maintained by a global open-source community — the entries evolve, but the catalogues are treated here as stable reference points anchored to specific versioned releases.

## Why it matters for AI-coding

AI-generated code reliably reproduces the OWASP Top 10 patterns it was trained on — SQL strings built from user input, hardcoded secrets, missing authorization checks, and the rest appear in AI-generated PRs at the same frequency as in human-written ones. The catalogues are how a reviewer connects "this PR has user input flowing into a SQL string" to a named, citable vulnerability class (A03:2021 — Injection), making security findings *legible* across the team without a lecture attached. Without that naming layer, every review re-invents its vocabulary; with it, "this is an A01 — fix it the way we fixed the orders endpoint" travels instantly. The LLM Top 10 extends the same infrastructure to the new attack surface AI agents introduce — prompt injection, insecure output handling, sensitive data disclosure — where no prior catalogue existed.

## Key concepts the role pulls from

- **Top 10 as the *naming layer* for findings.** When `security-review` flags an issue, citing "A02:2021 — Cryptographic Failures" is more legible than "weak crypto." The category names carry shared context; a developer who reads "A03:2021 — Injection" already knows the class of fix required without further explanation. This is infrastructure, not a checklist to tick.
- **ASVS as the *control catalogue*.** The ~280 testable requirements in ASVS (V2 Authentication, V3 Session Management, V4 Access Control) provide the procedural detail Top 10 deliberately omits. Top 10 says *what* is broken; ASVS says *what a passing control looks like*. Used as a finding map (each finding traces to the ASVS requirement it violates) and a coverage indicator (which categories were examined).
- **ASVS severity levels (L1 / L2 / L3) mapping to finding synthesis shape.** L1 controls are the floor — consumer-grade, any app. L2 is the target for most production systems handling sensitive data. L3 is for high-assurance contexts (financial, medical, safety-critical). The role's Blocker / Concern / Note synthesis shape roughly corresponds: an L1 failure is a Blocker; an L2 gap is a Concern; an L3 gap is a Note unless context elevates it.
- **LLM Top 10 for the new attack surface.** LLM01 Prompt Injection, LLM02 Insecure Output Handling, LLM06 Sensitive Information Disclosure are load-bearing for `llm-risk-assessment`. These categories cover vectors that STRIDE and the classic Top 10 don't name precisely: an LLM that faithfully executes injected instructions is not a broken-access-control bug in the classical sense, but it is LLM01, and the catalogue gives the finding a home.
- **The catalogue-not-method distinction.** OWASP names *what* to look for; Shostack provides *how* to systematically enumerate the threat space that produces those categories. Both are needed; neither replaces the other. A threat model using STRIDE identifies "tampering with this query parameter" — OWASP tells you that concrete instance is A03:2021 and shows you what the fix class looks like. Running the Top 10 as a walk without a prior threat model produces findings without adversaries; running STRIDE without OWASP produces threat categories without a remediation vocabulary.

## What to actually read (1-hour budget)

- **OWASP Top 10 2021** — the overview page plus each of the 10 entries' "Description" and "How to Prevent" sections. Skip the "Notable CWEs" tables on first pass; come back when triaging a specific finding. (~30 min)
- **OWASP LLM Top 10 1.1** — all entries in full. They are short, well-structured, and cover novel attack surface not in the classic Top 10. Read LLM01, LLM02, LLM06 first; the rest in order. (~15 min)
- **ASVS V1** (Architecture, Design and Threat Modeling), **V2** (Authentication), **V3** (Session Management), **V14** (Configuration). Skim — you are learning to use ASVS as a reference, not memorising it. (~15 min)

~1 hour total.

## What to skip

- Historical Top 10 editions (2017, 2013) unless you are researching how categories evolved or explaining why a legacy codebase has "SQL injection listed as #1." The 2021 edition supersedes them for current review work.
- ASVS chapters covering technologies you do not use (V9 Communications covers TLS configuration minutiae; V11 covers business logic patterns in specific domains). ASVS is a reference — index into it when a finding warrants it, do not read cover to cover.

## How this anchors role skills

- [`security-review`](../../roles/security-expert/skills/security-review/SKILL.md) — load-bearing. Top 10 entries are the naming layer for every finding; ASVS provides the procedural detail on what a passing control looks like. The review's classification column is "OWASP A##, ASVS V#.#.#, CWE-###."
- [`llm-risk-assessment`](../../roles/security-expert/skills/llm-risk-assessment/SKILL.md) — load-bearing. The LLM Top 10 is the entire risk taxonomy for that skill; without it the assessment has no shared vocabulary for prompt injection, insecure output handling, or model supply-chain risk.
- [`pre-launch-security-audit`](../../roles/security-expert/skills/pre-launch-security-audit/SKILL.md) — uses both catalogues as evidence anchors: Top 10 and ASVS for web surfaces, LLM Top 10 for any LLM-integrated surface. The Go / Fix-then-go / Hold recommendation names the catalogue entries driving the hold.
- [`threat-model`](../../roles/security-expert/skills/threat-model/SKILL.md) — Shostack's STRIDE produces threat categories; OWASP provides the specific named entries that categories resolve to. The two compose: STRIDE surfaces "information disclosure on this dataflow," OWASP names it A02:2021 and gives the remediation class.

## Cross-role connection

OWASP's catalogues are *legibility infrastructure*: they let security findings translate into engineer-implementable actions without a lengthy explanation attached. A developer who reads "A03:2021 — Injection" already knows what the fix class is; a finding that just says "SQL injection risk" invites debate. This is the same pattern as Nielsen's heuristics for design (H10 — Help and Documentation is more legible than "the UI is confusing") and STRIDE for threat modeling — *named-and-citable categories beat custom-vocabulary findings every time*. The methodology uses OWASP not because it is authoritative compliance but because shared vocabulary is a forcing function for clarity.
