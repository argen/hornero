# Attribution

Hornero incorporates frameworks, heuristics, and practices from many experts. Where their work is directly used in a role file, skill, or playbook, this document credits them. Per-role bibliographies live in `roles/<role>/sources.md`; this is the consolidated index.

## Source articles

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the harness principles in `methodology.md`.
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — the orchestrator-worker pattern in `methodology.md`.

## Adjacent repositories

- **[Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills)** by **Dean Peters** — the structural reference for Hornero's skill anatomy, frontmatter schema, and Component/Interactive/Workflow taxonomy. Where Hornero ports synthesized PM frameworks, Dean Peters is credited in the skill's References section with a synthesis-cue line; the upstream skill is CC BY-NC-SA 4.0, Hornero's re-synthesis is MIT. Skills with this lineage so far: `altitude-horizon-framework`, `director-readiness-advisor`, `executive-onboarding-playbook`, `product-sense-interview-answer`, `ai-shaped-readiness-advisor`, `context-engineering-advisor`, `opportunity-solution-tree`, `proto-persona`, `customer-journey-map`, `acquisition-channel-advisor`, `pestel-analysis`, `company-research`, `press-release`, `workshop-facilitation`, `user-story-mapping`, `saas-revenue-growth-metrics`, `saas-economics-efficiency-metrics`, `finance-metrics-quickref`, `tam-sam-som-calculator`, `feature-investment-advisor`, `finance-based-pricing-advisor`, `business-health-diagnostic`.

## Per-role experts

The full curated bibliographies live in each role's `sources.md`. The names below are an index of who shows up where. Names appearing in a role's anchors are listed first; "see also" names are listed after a `—`.

### Product manager (`roles/product-manager/sources.md`)

Anchors: Marty Cagan · Teresa Torres · Martin Eriksson · Melissa Perri · Shreyas Doshi · John Cutler · Jeff Patton · Christina Wodtke · Itamar Gilad · Clayton Christensen · Geoffrey Moore.

See also: Lenny Rachitsky · Tony Ulwick · Roman Pichler · Ken Norton · Bob Moesta · Rich Mironov · Chip Heath & Dan Heath.

Synthesised content from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) is credited in-skill where ported.

## How attribution works in skills

Every skill's References section must:

1. Cite the framework's original author with full work title and year where applicable.
2. Link to the corresponding entry in this role's `sources.md`.
3. Where the framework was synthesised from another repo (e.g., Dean Peters' work), name the source repo with a link.

`scripts/validate-skill.sh` checks anatomy (six sections + frontmatter). Per-citation traceability against `sources.md` is currently an editorial discipline rather than a lint rule; tightening this is a v1 follow-up.

## Corrections welcome

If a framework is attributed incorrectly, or a contributor is missing, open an issue.
