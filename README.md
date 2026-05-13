# Hornero

> A shareable AI-coding methodology with expert-infused, role-based skills.

*Hornero* is Argentina's national bird (*Furnarius rufus*) — known for building elaborate clay-oven nests in patient, methodical layers. The metaphor fits the project: each session adds a layer; the structure outlasts any single conversation.

## What this is

Hornero is a self-contained repo that gives any team — across functions, not just engineering — a shared methodology for working with AI coding assistants. It provides:

- **Role personas** for software engineer, product manager, designer, tester, security expert, data scientist, and marketing expert — each grounded in canonical expert sources, not LLM platitudes.
- **Skills** that those roles invoke: artifacts they produce, interactive flows they run, workflows they orchestrate.
- **Multi-agent orchestration** — a protocol for invoking multiple roles in parallel and synthesizing their findings.
- **Templates and playbooks** so a teammate can apply the methodology to any new repo.

## Who this is for

Teams adopting AI-assisted work who want:

- A shared vocabulary across functions
- Standing instructions that compound week-over-week instead of starting fresh each session
- Expert-anchored frameworks rather than LLM-generated generic advice
- A repeatable way to invoke multiple expert lenses on important decisions

## Source articles

The methodology draws on two:

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — governs how the harness compounds (five principles).
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — governs how roles collaborate as a team (orchestrator-worker pattern).

See `methodology.md` for the full synthesis.

## Quick start

```bash
git clone <this-repo>
cd hornero
./install.sh          # copies skills into your ~/.claude
```

Then open `playbooks/onboarding.md`.

## Status

**v0 — under construction.** The **software-engineer**, **tester**, **designer**, and **product-manager** roles have ROLE + sources + first-draft skills. The remaining three roles (security-expert, data-scientist, marketing-expert) have ROLE.md + sources.md scaffolded; their skills land in later phases. Cross-role process skills (`spec-the-problem`, `multi-role-review`, `extract-lesson`, `harness-check`, `context-reset-check`) are shipped.

## Repo structure

```
roles/                  # One folder per role — ROLE.md, sources.md, skills/
skills/                 # Cross-role process skills (spec-the-problem, extract-lesson, multi-role-review, ...)
agents/                 # Optional Claude Code subagent wrappers
templates/              # AGENTS.md, CLAUDE.md, settings.json drop-in templates
playbooks/              # Human-readable workflow guides
research/               # Distilled book notes per role
scripts/                # validate-skill.sh, catalog.sh
examples/               # Annotated sample sessions
methodology.md          # The two-layer synthesis
ATTRIBUTION.md          # Credits to incorporated experts
install.sh              # Copies skills + agents into ~/.claude
```

## License

MIT (forthcoming).

## Acknowledgements

See `ATTRIBUTION.md` for the full list of expert sources whose work this methodology incorporates.
