# Attribution

Hornero incorporates frameworks, heuristics, and practices from many experts. Where their work is directly used in a role file, skill, or playbook, this document credits them. Per-role bibliographies live in `roles/<role>/sources.md`; this is the consolidated index.

## Source articles

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the harness principles in `methodology.md`.
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — the orchestration principles in `methodology.md` and `skills/multi-role-review/`.

## Adjacent repositories

- **[Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills)** by **Dean Peters** — the structural reference for Hornero's skill anatomy, frontmatter schema, and Component/Interactive/Workflow taxonomy. Where Hornero ports synthesized PM frameworks (Vibe Prototype Canvas, PoL Probe, Altitude/Horizon, Context Engineering), Dean Peters is credited in the skill's References section.

## Per-role experts

The full curated bibliographies live in each role's `sources.md`. The names below are an index of who shows up where.

### Product manager (`roles/product-manager/sources.md`)
Marty Cagan · Teresa Torres · Martin Eriksson · Melissa Perri · Shreyas Doshi · John Cutler · Jeff Patton · Christina Wodtke · Itamar Gilad · Clayton Christensen · Geoffrey Moore · Lenny Rachitsky · Tony Ulwick · Roman Pichler · Ken Norton · Bob Moesta · Dean Peters

### Software engineer (`roles/software-engineer/sources.md` — phase 2+)
Kent Beck · Martin Fowler · John Ousterhout · Fred Brooks · Eric Evans · Sandi Metz · Google SRE Team · Will Larson · Tanya Reilly · Gergely Orosz · Camille Fournier · Dan North · Hillel Wayne · Joel Spolsky · Thoughtworks Technology Radar · Chris MDP · Simon Willison

### Designer (`roles/designer/sources.md` — phase 2+)
Don Norman · Jakob Nielsen · Bill Buxton · Alan Cooper · Erika Hall · Steve Krug · Edward Tufte · Brad Frost · Kat Holmes · Mike Monteiro · Adam Wathan · Steve Schoger · Dieter Rams · Julie Zhuo · Frank Chimero · Josh Clark · Microsoft Inclusive Design Toolkit · Apple HIG · Material Design · WCAG

### Tester (`roles/tester/sources.md` — phase 2+)
James Bach · Michael Bolton · Elisabeth Hendrickson · Lisa Crispin · Janet Gregory · Cem Kaner · Gojko Adzic · Kent Beck · Jez Humble · David Farley · John Hughes · Maaret Pyhäjärvi · Mike Cohn · Brian Marick · Jonathan Kohl · Alan Page

### Security expert (`roles/security-expert/sources.md` — phase 3+)
OWASP · NIST · Adam Shostack · Bruce Schneier · MITRE · Troy Hunt · Kim Zetter · Tavis Ormandy · Google Project Zero · Matt Green · Google BeyondCorp · Daniel Miessler · Chris Wysopal · Phil Zimmermann · Window Snyder · Mudge (Peiter Zatko)

### Data scientist (`roles/data-scientist/sources.md` — phase 3+)
Judea Pearl · Ron Kohavi · Hadley Wickham · Andrew Gelman · Richard McElreath · Cassie Kozyrkov · D. Sculley · Daniel Kahneman · Cathy O'Neil · Andrej Karpathy · Wes McKinney · Hilary Mason · DJ Patil · Andrew Ng · Sebastian Raschka · Allen Downey · Google PAIR · HELM/Stanford CRFM

### Marketing expert (`roles/marketing-expert/sources.md` — phase 4+)
April Dunford · Theodore Levitt · David Ogilvy · Byron Sharp · Andy Raskin · Rory Sutherland · Bob Hoffman · Joanna Wiebe · Mark Ritson · Donald Miller · Eugene Schwartz · Philip Kotler · Lenny Rachitsky · Bob Moesta · Peep Laja · Ann Handley

## How attribution works in skills

Every skill's References section must:

1. Cite the framework's original author with full work title and year where applicable.
2. Link to the corresponding entry in this role's `sources.md`.
3. Where the framework was synthesized from another repo (e.g., Dean Peters' work), name the source repo with a link.

`scripts/validate-skill.sh` checks that every Key Concept introduced in a skill traces to a name in its role's `sources.md`. Skills without proper citations fail lint.

## Corrections welcome

If a framework is attributed incorrectly, or a contributor is missing, open an issue.
