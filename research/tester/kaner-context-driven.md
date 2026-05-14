# Cem Kaner — distilled

> *Lessons Learned in Software Testing* (2001, with James Bach and Bret Pettichord); *Testing Computer Software* (1988, rev. 1999); the seven principles of context-driven testing. Florida Tech, Kaner Fiedler & Associates.

## Why it matters for AI-coding

AI tools generate testing recommendations with confident universality: "always aim for 80% branch coverage," "integration tests should run in under 30 seconds," "mocking dependencies is best practice for unit tests." Kaner's context-driven school is the intellectual tradition that most directly targets this failure mode. Its central claim — there are good practices in context, but no best practices — is the antidote to cargo-culted testing advice, whether that advice comes from a certification manual or a language model.

For AI-assisted teams, Kaner matters doubly: the AI proposes approaches without knowing the team's risk profile, regulatory context, legacy constraints, or the specific failure history of the system. Applying those proposals without examination is exactly what the context-driven principles argue against. The tester's job, in this framing, is to be the context-holder — the person who knows why this system is different from the generic case.

## Key concepts the role pulls from

- **Seven principles of context-driven testing.** The foundational axioms: (1) the value of any practice depends on its context; (2) there are good practices in context, but no best practices; (3) people, working together, are the most important part of any project's context; (4) projects unfold over time in ways that are often not predictable; (5) the product is a solution; if the problem isn't solved, the product doesn't work; (6) good software testing is a challenging intellectual process; (7) only through judgment and skill, exercised cooperatively throughout the project, are we able to do the right things at the right times to effectively test our products. Powers the "deliberately deferred" lines in every `test-plan` and the reasoning column in the risk table.
- **Testing as intellectual work.** Kaner's repeated emphasis that testing requires judgment — it cannot be automated into a procedure or reduced to a metric. Powers the role's resistance to coverage-percentage-as-proxy-for-quality.
- **Bug advocacy.** *Testing Computer Software* introduced the discipline of writing bug reports as persuasion documents: enough information to reproduce, enough context to prioritise, clear description of actual vs expected. The `regression-test` skill's naming-the-bug discipline inherits from this.
- **Epistemology of testing.** Kaner asks "how do you know what a test result means?" before asking "what test do I write?" This oracle-first framing underpins the `test-plan`'s oracle and assertion-quality checks.
- **The "software testing is not quality assurance" distinction.** Testing finds information; it doesn't assure quality. Quality assurance is a process discipline. Testers who present test results as quality assurances miscommunicate their role to stakeholders and inflate confidence.

## What to actually read (1-hour budget)

- *Lessons Learned in Software Testing* — not in order; by chapter title. High-leverage chapters for AI-coding work: ch. 4 (Testing Techniques), ch. 5 (Bug Reporting and Advocacy), ch. 7 (Test Documentation). Read as 293 short lessons — each is one page; pick 20 relevant ones.
- The seven context-driven principles — available as a one-page summary from kaner.com. Read this first; everything else is elaboration.
- *Testing Computer Software* ch. 5 (Finding Bugs) if the team needs to improve bug-report quality.

## What to skip

- Most of *Testing Computer Software* outside ch. 5 — the earlier chapters are historically important but the specific technique catalogues have been absorbed into more current texts (Bach/Bolton's HTSM, Hendrickson's tours).
- Kaner's extensive legal and academic writing on software quality — important in its context; tangential to the methodology's practical use.

## How this anchors role skills

- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — context-driven principles appear explicitly in the Key Concepts section; the "deliberate non-coverage" and "out-of-scope" sections of the plan template are context-driven principles 1 and 2 operationalised.
- [`regression-test`](../../roles/tester/skills/regression-test/SKILL.md) — bug-advocacy discipline; the "name the bug in the test" discipline reflects Kaner's persuasion-document framing for bug reports.

## Cross-role connection

Kaner's empirical, anti-universalist stance mirrors the marketing-expert role's positioning discipline: both resist "best practices" in favor of "what's true for this product, this market, this moment." The positioning-canvas skill's insistence on named competitive alternatives and specific customer segments over generic category claims is the marketing equivalent of context-driven testing's refusal of universal methodologies. In cross-role review sessions, this shared epistemological stance means the tester and the marketing-expert are natural allies against methodology cargo-culting — both will ask "why does this practice make sense for us, specifically?" rather than accepting a framework at face value.

