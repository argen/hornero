# James Bach & Michael Bolton — distilled

> Rapid Software Testing (RST) methodology (continuously developed since 2003 by Bach, with Michael Bolton from 2006), the Heuristic Test Strategy Model (HTSM, public-domain), and *Lessons Learned in Software Testing* (2001, with Cem Kaner and Bret Pettichord). Satisfice / DevelopSense.

## Why it matters for AI-coding

AI-generated test suites default to mechanical happy-path coverage plus a perfunctory error case — what Bach calls "the testing of conformance." RST's stance is that testing is *inquiry*, not *conformance checking*, and the gap between the two is where every production bug lives. The HTSM is the antidote to "I wrote tests, we have coverage" mush — it gives a tester real categories (Time, Operations, Platform, Data, Sequence, Operations, Resources, Side-effects...) to ask coverage questions against.

The methodology's tester role is, in one reading, a working application of RST. The `test-plan` skill's risk-driven structure refuses to start with "what to test"; it starts with "what's at stake." The `exploratory-charter` skill is Hendrickson's framing (covered separately) operationalised inside RST's "skill > script" stance. The `pre-release-test-pass` workflow is RST's "release-decision" discipline — what evidence do we have that the system will work in the wild, not just in the test environment.

## Key concepts the role pulls from

- **HTSM (Heuristic Test Strategy Model).** A one-page model organising coverage by Product Elements (Structure, Function, Data, Platform, Operations, Time) and Quality Criteria (Capability, Reliability, Usability, Charisma, Security, Scalability, Compatibility, Performance, Installability, Development). Powers `test-plan`'s HTSM coverage-by-dimension table.
- **Skill > script.** Tests scripted in detail by someone who hasn't tested the system rarely catch interesting bugs. Testing skill (sapient inquiry) plus structured techniques beats step-by-step scripts. Underwrites the `exploratory-charter` skill's existence.
- **Testing vs checking.** Checking is automated verification of a known fact (this test passes when the condition holds). Testing is investigation — what *don't* I know about this system? Both are necessary. AI-generated test suites are 100% checking; the tester role's job is to ensure the testing half exists.
- **Oracles.** How do you know a test result is correct? An oracle is a heuristic for recognising a problem when you see one (consistency with history, consistency with comparable products, consistency with claims, consistency with user expectations). Powers the methodology's "what makes this test's pass/fail signal trustworthy" critique in `test-plan`.
- **Risk-driven coverage.** Coverage is not "every branch / every line / every endpoint"; coverage is "everything that, if it broke, would matter." Powers `test-plan`'s ranked-Risk-table structure (worst-case + likelihood + mitigation, not "X% line coverage").
- **Context-driven principles.** (With Kaner.) The value of a practice depends on its context. Methodology shouldn't be applied mechanically; the tester's job includes choosing what's appropriate for *this* system, *this* team, *this* release. Resists certification-style testing checklists.

## What to actually read (1-hour budget)

- **The HTSM document itself** — a one-page PDF available free from satisfice.com. Read it first; everything else is context.
- **RST class notes (public)** — the introductory materials from satisfice.com cover the core methodology in ~30 pages.
- **Lessons Learned in Software Testing** — pick lessons by chapter title, not in order. The book is structured as 293 short lessons; the high-leverage ones for AI-coding work are in chapters 4 (Testing Techniques), 5 (Bug Reporting), 7 (Test Documentation), and 9 (Test Management).

## What to skip

- RST's long-running debates with the testing-certification industry (ISTQB, etc.) — historically important, operationally tangential.
- The deep-history material on the testing schools (Analytical, Standard, Quality, Context-Driven, Agile) — useful framing once, not load-bearing for skill critique.
- Most of Bach's polemic blog posts — sharper than the actual methodology suggests; read his books and the HTSM, not the takes.

## How this anchors role skills

- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — the HTSM coverage table is the skill's central artifact; the risk-driven structure is RST's risk-driven-coverage stance; the "deliberately deferred" line in every plan is RST's context-driven principles operationalised.
- [`exploratory-charter`](../../roles/tester/skills/exploratory-charter/SKILL.md) — the mission/time-box/oracle structure descends from RST's session-based test management.
- [`pre-release-test-pass`](../../roles/tester/skills/pre-release-test-pass/SKILL.md) — the Go / Fix-then-go / Hold recommendation shape is RST's release-decision discipline: what evidence do we have, what risks remain, can we live with them.
- General review heuristic: when the tester role flags a test as "checking without testing" or "scripted without skill," the citation is Bach/Bolton.

## Cross-role connection

RST's oracles concept maps onto data-scientist's "what's the falsification criterion for this experiment" discipline — both ask "how would we know if we were wrong?" RST's context-driven principles parallel the methodology's role-mix selection in `/orchestrate` — the right set of reviewers depends on *this* artifact, not on a fixed checklist.
