# Adam Shostack — distilled

> *Threat Modeling: Designing for Security* (2014) and *Threats: What Every Engineer Should Learn From Star Wars* (2023). The canonical practical threat-modeling book in the industry, plus the engineer-targeted follow-on.

## Why it matters for AI-coding

Threat modeling is one of the disciplines AI agents do *worst* without scaffolding. Asked to "threat-model this auth flow," a generic LLM produces a generic STRIDE pass that catches generic concerns — most of which the framework already prevents. Shostack's specific structure (4-question framework + STRIDE-per-element + data-flow diagrams + attack-tree drilldowns where warranted) is the antidote to vibes-based threat enumeration. It forces the agent to identify *what specifically* in this system can be tampered with, by *what specific* adversary, with *what specific* outcome.

The methodology's `threat-model` skill is, structurally, Shostack's 4-question framework operationalised. The `pre-launch-security-audit` workflow uses Shostack's "threat-model refresh" as its first phase. When the security role escalates a finding from "this is a generic concern" to "this is a specific adversary X targeting specific surface Y with specific outcome Z," it's applying Shostack discipline.

## Key concepts the role pulls from

- **The 4-question framework.** (1) What are we working on? (2) What can go wrong? (3) What are we going to do about it? (4) Did we do a good job? The most-cited framing in modern threat modeling. Powers the `threat-model` skill's top-level structure.
- **STRIDE (Spoofing / Tampering / Repudiation / Information disclosure / Denial of service / Elevation of privilege).** The six-category threat taxonomy. Shostack's contribution is operationalising it as a *per-element* exercise, not a vague "STRIDE pass over the whole system." Powers the threat-model skill's element-by-element table.
- **STRIDE-per-element.** Apply STRIDE to each element of the system (each process, data store, dataflow, external entity), not to the system as a whole. This is the discipline that distinguishes a real threat model from a generic security checklist.
- **Data flow diagrams (DFDs) as the substrate.** A threat model is only as good as the diagram it sits on. DFDs (with trust boundaries marked) force the threat modeler to *see* what's actually happening — most missed threats hide behind handwaving in a missing diagram. Powers the methodology's stance that "threat-model without a diagram" is a Friction finding.
- **Attack trees (when warranted).** For high-value targets, decompose an attacker goal into sub-goals, then into specific attacks. Slower than STRIDE; appropriate when the stakes justify the depth. Cited as the deeper option when STRIDE doesn't yield enough granularity.
- **Trust boundaries.** Where the level of trust changes (across the network, across user/admin, into a third-party API). Most interesting threats cluster at trust boundaries; the threat-model skill's prompts force these to be named explicitly.

## What to actually read (1-hour budget)

- *Threat Modeling: Designing for Security* — **Part I, chapters 1-3** (the 4-question framework, STRIDE, DFDs). ~80 pages. The load-bearing material is here.
- If you have a second hour: **chapter 4** (attack trees) and **chapter 16** (threat modeling in development). The attack-tree chapter is the bridge between "threat modeling as practice" and "threat modeling as engineering deliverable."

## What to skip

- The cryptography chapter (Part V) — handled better by Schneier (and by NIST, for control-level questions); not Shostack's strength.
- *Threats: What Every Engineer Should Learn From Star Wars* (2023) — same material as the 2014 book, dressed for an engineer audience, slightly more accessible. Pick one; reading both is redundant. Pick the 2014 book if you want depth; pick *Threats* if you want a faster on-ramp.
- The appendices on threat-modeling tools (Microsoft TMT, etc.) — useful once, but the tools have moved; Shostack's frameworks travel; the tools don't.

## How this anchors role skills

- [`threat-model`](../../roles/security-expert/skills/threat-model/SKILL.md) — the 4-question framework is the skill's top-level structure; STRIDE-per-element is the threats table; DFD-with-trust-boundaries is the diagram requirement.
- [`pre-launch-security-audit`](../../roles/security-expert/skills/pre-launch-security-audit/SKILL.md) — phase 1 is "threat-model refresh"; the workflow's Go / Fix-then-go / Hold recommendation is Shostack's "did we do a good job" question operationalised.
- [`llm-risk-assessment`](../../roles/security-expert/skills/llm-risk-assessment/SKILL.md) — uses Shostack's element-by-element discipline against LLM-specific risk categories (OWASP LLM Top 10) instead of STRIDE.
- [`security-review`](../../roles/security-expert/skills/security-review/SKILL.md) — security-review consumes the threat model as input; findings cite which threat-model assumption they invalidate or confirm.

## Cross-role connection

Shostack's "what are we working on" first question parallels the methodology's `spec-the-problem` skill exactly — both refuse to start the work without an explicit, falsifiable framing of the artifact under examination. When the security role escalates "this diagram is missing trust boundaries" to a Friction finding in `harness-check`, the citation is Shostack's "the DFD is the substrate" stance.
