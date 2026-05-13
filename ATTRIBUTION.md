# Attribution

Hornero incorporates frameworks, heuristics, and practices from many experts. Where their work is directly used in a role file, skill, or playbook, this document credits them. Per-role bibliographies live in `roles/<role>/sources.md`; this is the consolidated index.

## Source articles

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the harness principles in `methodology.md`.
- **Anthropic** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — the orchestration principles in `methodology.md` and `skills/multi-role-review/`.

## Adjacent repositories

- **[Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills)** by **Dean Peters** — the structural reference for Hornero's skill anatomy, frontmatter schema, and Component/Interactive/Workflow taxonomy. Where Hornero ports synthesized PM frameworks (Vibe Prototype Canvas, PoL Probe, Altitude/Horizon, Context Engineering), Dean Peters is credited in the skill's References section.

## Per-role experts

The full curated bibliographies live in each role's `sources.md`. The names below are an index of who shows up where. Names appearing in a role's anchors are listed first; "see also" names are listed after a `—`.

### Product manager (`roles/product-manager/sources.md`)

Anchors: Marty Cagan · Teresa Torres · Martin Eriksson · Melissa Perri · Shreyas Doshi · John Cutler · Jeff Patton · Christina Wodtke · Itamar Gilad · Clayton Christensen · Geoffrey Moore.

See also: Lenny Rachitsky · Tony Ulwick · Roman Pichler · Ken Norton · Bob Moesta · Rich Mironov · Chip Heath & Dan Heath.

Synthesised content from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills) is credited in-skill where ported.

### Software engineer (`roles/software-engineer/sources.md`)

Anchors: Kent Beck · Martin Fowler · John Ousterhout · Fred Brooks · Eric Evans · Sandi Metz · Google SRE Team · Will Larson · Tanya Reilly · Gergely Orosz.

See also: Camille Fournier · Dan North · Hillel Wayne · Joel Spolsky · Thoughtworks Technology Radar · Chris MDP · Simon Willison · Jez Humble & David Farley · Michael Nygard · Michael Feathers.

### Designer (`roles/designer/sources.md`)

Anchors: Don Norman · Jakob Nielsen · Bill Buxton · Alan Cooper · Erika Hall · Steve Krug · Edward Tufte · Brad Frost · Kat Holmes · Mike Monteiro · Adam Wathan & Steve Schoger (Refactoring UI).

See also: Dieter Rams · Julie Zhuo · Frank Chimero · Josh Clark · Microsoft Inclusive Design Toolkit · Apple Human Interface Guidelines · Material Design · WCAG 2.2.

### Tester (`roles/tester/sources.md`)

Anchors: James Bach & Michael Bolton · Elisabeth Hendrickson · Lisa Crispin & Janet Gregory · Cem Kaner · Gojko Adzic · Kent Beck · Jez Humble & David Farley · John Hughes · Maaret Pyhäjärvi · Mike Cohn.

See also: Brian Marick · Jonathan Kohl · Alan Page · Google Testing Blog · Bret Pettichord.

### Security expert (`roles/security-expert/sources.md`)

Anchors: OWASP · NIST · Adam Shostack · Bruce Schneier · MITRE · Troy Hunt · Kim Zetter · Tavis Ormandy & Google Project Zero · Matt Green · Google BeyondCorp.

See also: Daniel Miessler · Chris Wysopal · Phil Zimmermann · Window Snyder · Mudge (Peiter Zatko) · Halvar Flake · MITRE ATLAS.

### Data scientist (`roles/data-scientist/sources.md`)

Anchors: Judea Pearl · Ron Kohavi · Hadley Wickham · Andrew Gelman & Richard McElreath · Cassie Kozyrkov · D. Sculley et al. · Daniel Kahneman · Cathy O'Neil · Andrej Karpathy · Wes McKinney.

See also: Hilary Mason · DJ Patil · Andrew Ng · Sebastian Raschka · Allen Downey · Galit Shmueli · Donald Rubin · Miguel Hernán & James Robins · Daniel Westreich & Sander Greenland · Tyler VanderWeele & Peng Ding · Alex Deng, Ya Xu, Ron Kohavi & Toby Walker (CUPED) · Charles Goodhart & Donald Campbell (the laws) · Google PAIR · HELM / Stanford CRFM.

### Marketing expert (`roles/marketing-expert/sources.md`)

Anchors: April Dunford · Theodore Levitt · David Ogilvy · Byron Sharp · Andy Raskin · Rory Sutherland · Bob Hoffman · Joanna Wiebe · Mark Ritson · Donald Miller.

See also: Eugene Schwartz · Philip Kotler · Lenny Rachitsky · Bob Moesta · Peep Laja & Wynter · Ann Handley · Claude Hopkins.

## How attribution works in skills

Every skill's References section must:

1. Cite the framework's original author with full work title and year where applicable.
2. Link to the corresponding entry in this role's `sources.md`.
3. Where the framework was synthesised from another repo (e.g., Dean Peters' work), name the source repo with a link.

`scripts/validate-skill.sh` checks anatomy (six sections + frontmatter). Per-citation traceability against `sources.md` is currently an editorial discipline rather than a lint rule; tightening this is a v1 follow-up.

## Corrections welcome

If a framework is attributed incorrectly, or a contributor is missing, open an issue.
