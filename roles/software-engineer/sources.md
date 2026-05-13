# Software engineer — sources

The curated bibliography for the software-engineer role. Skills cite from this list. New frameworks introduced in skills must trace to a name here (or be added with rationale).

## Anchors

### Kent Beck
- *Test-Driven Development by Example* (2002)
- *Extreme Programming Explained: Embrace Change* (1999, rev. 2004)
- *Tidy First? A Personal Exercise in Empirical Software Design* (2023)
- **Why he matters:** Originator of TDD's red/green/refactor loop; XP practices (pair programming, CI, small releases, simple design) that the industry still draws from; "tidyings" as the unit of safe in-flight refactoring.
- Used in: `tdd-discipline`, `refactor-plan`, code-review skills.

### Martin Fowler
- *Refactoring: Improving the Design of Existing Code* (1999, 2nd ed. 2018)
- *Patterns of Enterprise Application Architecture* (2002)
- [martinfowler.com](https://martinfowler.com/) essays — strangler fig, branch by abstraction, feature toggles, lightweight ADRs, "is high quality software worth the cost?"
- **Why he matters:** The refactoring catalogue is the shared vocabulary of safe code change; his essays define the conservative-defaults canon for evolutionary architecture.
- Used in: `refactor-plan`, `rfc`, `adr`, evolutionary-architecture skills.

### John Ousterhout — Stanford
- *A Philosophy of Software Design* (2018, 2nd ed. 2021)
- **Why he matters:** Complexity as the central concern; "deep modules" vs "shallow modules"; "define errors out of existence"; "comments should describe things that are not obvious from the code." A modern counterpoint to Clean Code orthodoxy.
- Used in: `rfc`, `adr`, design-review, comment-discipline skills.

### Fred Brooks
- *The Mythical Man-Month: Essays on Software Engineering* (1975, anniv. ed. 1995)
- "No Silver Bullet — Essence and Accident in Software Engineering" (1986)
- **Why he matters:** Brooks's Law ("adding people to a late project makes it later"); the essence/accident distinction that frames every AI-coding productivity debate; the conceptual integrity argument.
- Used in: estimation, scope-negotiation, ai-coding-realism skills.

### Eric Evans
- *Domain-Driven Design: Tackling Complexity in the Heart of Software* (2003)
- **Why he matters:** Ubiquitous language; bounded contexts; the strategic/tactical DDD distinction. Defines how teams talk about domain models without drowning in OOP hairshirts.
- Used in: `rfc`, domain-modeling, system-decomposition skills.

### Sandi Metz
- *Practical Object-Oriented Design in Ruby* (POODR, 2012, 2nd ed. *POODR* + 2018 *99 Bottles of OOP* with Katrina Owen)
- "The Wrong Abstraction" (2016 essay) — duplication is far cheaper than the wrong abstraction
- Sandi Metz Rules for Developers (100-line classes, 5-line methods, 4-arg methods)
- **Why she matters:** Pragmatic OO design that prioritizes readability over cleverness; the "duplication is cheap" line is the antidote to premature abstraction common in AI-generated code.
- Used in: `refactor-plan`, abstraction-discipline, code-review skills.

### Google SRE — Betsy Beyer, Chris Jones, Jennifer Petoff, Niall Richard Murphy (eds.)
- *Site Reliability Engineering: How Google Runs Production Systems* (2016) — [sre.google/books](https://sre.google/books/)
- *The Site Reliability Workbook* (2018)
- *Building Secure & Reliable Systems* (2020)
- **Why it matters:** SLI/SLO/error-budget vocabulary; postmortem-without-blame culture; toil reduction; the canonical reliability engineering reference.
- Used in: slo-design, incident-postmortem, on-call-readiness skills.

### Will Larson
- *An Elegant Puzzle: Systems of Engineering Management* (2019)
- *Staff Engineer: Leadership Beyond the Management Track* (2021)
- [lethain.com](https://lethain.com/) essays
- **Why he matters:** Engineering strategy as a writing practice; canonical RFC/eng-strategy template; archetypes of the staff+ engineer role.
- Used in: `rfc`, engineering-strategy, staff-eng-judgement skills.

### Tanya Reilly
- *The Staff Engineer's Path: A Guide for Individual Contributors Navigating Growth and Change* (2022)
- "Being Glue" (2019 essay)
- **Why she matters:** How staff engineers operate without authority; design-document craft; locating and protecting the "glue work" that holds systems together.
- Used in: `rfc`, design-doc-craft, technical-influence skills.

### Gergely Orosz — The Pragmatic Engineer
- *The Software Engineer's Guidebook* (2023)
- [newsletter.pragmaticengineer.com](https://newsletter.pragmaticengineer.com/) — engineering practice essays, post-mortems, industry analysis
- **Why he matters:** Working-engineer canon; data-rich essays on what actually happens inside high-functioning teams; sharp on AI-coding adoption patterns from real engineering orgs.
- Used in: engineering-practice, ai-coding-realism, on-call-readiness skills.

## See also

- **Camille Fournier** — *The Manager's Path* (2017); pragmatic engineering leadership.
- **Dan North** — Behaviour-Driven Development; "Decisions, decisions" essay on engineering trade-offs.
- **Hillel Wayne** — formal methods and applied logic for working engineers; [hillelwayne.com](https://www.hillelwayne.com/).
- **Joel Spolsky** — Joel on Software; *Smart and Gets Things Done* — early canon on engineering culture.
- **Thoughtworks Technology Radar** — [thoughtworks.com/radar](https://www.thoughtworks.com/radar) — semi-annual adopt/trial/assess/hold list.
- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the harness-compounding article that seeds Hornero's methodology.
- **Simon Willison** — [simonwillison.net](https://simonwillison.net/) — practical LLM-tooling reportage from a working engineer.
- **Jez Humble & David Farley** — *Continuous Delivery* (2010) — shared anchor with the tester role.
- **Michael Nygard** — "Documenting Architecture Decisions" (2011); originator of the ADR format.
- **Michael Feathers** — *Working Effectively with Legacy Code* (2004); the seams-and-tests playbook for changes in untested code.

## Curation notes

This list is capped at ~10 anchors plus a "see also." If a new entry is proposed, an existing entry must be demoted. The cap exists to force prioritization: skills that cite from a 50-entry bibliography drift toward LLM-generated synthesis.

The role straddles practitioner books (Beck, Fowler, Metz, Evans) and engineering-organisation books (Larson, Reilly, Orosz, Google SRE). Both halves matter: code without context drifts into clever; context without code drifts into theatre.

If the list grows past 15 anchors, the role is too broad and should be split (e.g., into a separate `staff-engineer` or `reliability-engineer` role).
