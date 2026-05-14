# Cathy O'Neil — distilled

> *Weapons of Math Destruction: How Big Data Increases Inequality and Threatens Democracy* (Crown, 2016). The canonical voice on harm from opaque, scaled, consequential models. O'Neil (mathematician, ex-quantitative hedge fund analyst) introduces a three-part harm taxonomy and applies it to credit scoring, recidivism prediction, college rankings, teacher evaluation, and targeted advertising.

## Why it matters for AI-coding

AI scaling makes opaque-model harm a default state, not an edge case. Every model that (a) is opaque to the people it affects, (b) operates at scale, and (c) drives consequential decisions is, in O'Neil's vocabulary, a potential Weapon of Math Destruction — a WMD. The three conditions are individually unremarkable; their combination is what creates harm. AI-generated models are almost always opaque (the process that produced them is automated and rarely explained), they are deployed at scale by design, and they increasingly drive consequential decisions (hiring, credit, benefits, policing). O'Neil is not an argument against models — she is an argument for a harm-audit discipline before deployment, and the discipline she describes is what the `pre-launch-measurement-audit` workflow operationalises for the data-scientist role.

Without O'Neil's vocabulary, the default data-science stance is that accuracy implies fairness and that model error is random. Neither is true for consequential scaled models: error is systematically distributed across demographic groups, and the people most harmed are least positioned to contest the model's output.

## Key concepts the role pulls from

- **The WMD three-part test.** A model is a weapon when it is: (1) *opaque* — the affected person cannot see, understand, or contest its outputs; (2) *scaled* — it affects many people through automated application; (3) *consequential* — its outputs drive decisions that meaningfully affect people's lives (employment, credit, housing, criminal justice). Any of the three alone is manageable; all three together create self-reinforcing harm. Powers the `pre-launch-measurement-audit` harm-audit gate: every model must be assessed against the three-part test before launch.
- **Feedback loops of harm.** WMDs often create feedback loops: a model predicts high recidivism for a neighbourhood → police patrol the neighbourhood more heavily → more arrests → more "crime" data → model prediction confirmed. The model didn't just predict harm; it produced it. Powers the `causal-dag` application to consequential models: the DAG must include the model's own predictions as a cause of future inputs.
- **Proxy variables and protected attributes.** Models that are forbidden to use race, gender, or religion as features will use zip code, name frequency, and shopping behaviour — which are correlated with the protected attributes. Removing a variable from the feature set does not remove its influence from the model. Powers the role's feature-engineering review: what is each feature a proxy for, and what does that proxy relationship imply for differential impact?
- **Lack of feedback and model stasis.** Virtuous models (Kahneman-style: calibrated against reality, subject to error correction) update when their predictions are wrong. WMDs rarely get feedback on their individual predictions — the loan was denied so no one knows if the person would have repaid; the résumé was filtered so no one knows if the person would have been a good hire. Without error feedback, the model cannot improve and the harm accumulates. Powers the `pre-launch-measurement-audit`'s feedback-loop requirement: what mechanism will tell us when the model is systematically wrong about a population?
- **The victims can't fight back.** The people harmed by WMDs are typically those with the least power to contest the model: low-income applicants can't afford the legal challenge; people with criminal records can't access the records used against them; job applicants can't see the screening algorithm. The harm audit must include "who is least positioned to contest this output?" Powers the role's fairness-review: consider the most affected populations, not the average user.
- **Scale as an amplifier.** A single biased human makes biased decisions one at a time; a biased model makes the same biased decision millions of times per day. Scale turns a manageable human-error problem into a systemic injustice problem. Powers the `pre-launch-measurement-audit`'s scale-aware harm framing: what is the worst-case harm if this model is wrong, at the scale it will operate?

## What to actually read (1-hour budget)

- ***Weapons of Math Destruction*, Chapters 1-3.** The conceptual framework (opaque, scaled, consequential) and the first two case studies (teacher evaluation, recidivism scoring). O'Neil writes accessibly; these three chapters establish the full vocabulary.
- **Chapter 9** (targeting citizens — political advertising and voter manipulation) and **Chapter 10** (conclusion: the hope for a new damage-aware data science). The conclusion is the most direct statement of the harm-audit discipline O'Neil advocates.
- **O'Neil's ORCAA (O'Neil Risk Consulting and Algorithmic Auditing) methodology notes** — available through her firm's website; the operational translation of the book's concepts into an audit checklist.

## What to skip

- Chapters 4-8 are case studies in specific domains (insurance, advertising, college rankings, policing). Each is well-argued but covers one sector in depth; the conceptual content is captured in Chapters 1-3. Read the case studies if you work in that sector; skim otherwise.

## How this anchors role skills

- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the harm-audit gate (WMD three-part test, feedback-loop requirement, scale-aware worst-case analysis, fairness-review across affected populations) is O'Neil's framework operationalised into a pre-launch checklist. The `Hold` recommendation fires when any of the three WMD conditions is met without a corresponding mitigation.
- [`metric-definition`](../../roles/data-scientist/skills/metric-definition/SKILL.md) — the gaming-surface analysis includes O'Neil's proxy-variable critique: what is the feature (or metric) a proxy for, and does that proxy relationship systematically disadvantage a population?

## Cross-role connection

O'Neil's harm-audit lens and the security expert's threat-model discipline are structurally parallel: both surface unintended scaled consequences of systems that were designed with a narrow objective. The security expert models adversarial exploitation; O'Neil models structural harm from well-intentioned systems. When the methodology's `multi-role-review` includes both roles on an ML system review, the security expert names the intentional attack surface; the data scientist (with O'Neil's lens) names the unintentional harm surface. Both are pre-launch blockers. The PM's `prd` skill is also implicated: O'Neil would require the PRD's success-criteria section to include a harm metric ("the false-positive rate for population X must not exceed Y") alongside the product metric.

Kahneman's noise-audit and O'Neil's feedback-loop requirement also converge: a model that cannot receive error feedback (because the affected person cannot contest its output) cannot correct the noise in its training labels — so O'Neil's opacity condition and Kahneman's noise diagnosis are two lenses on the same structural failure.
