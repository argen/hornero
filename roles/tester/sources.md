# Tester — sources

The curated bibliography for the tester role. Skills cite from this list. New frameworks introduced in skills must trace to a name here.

## Anchors

### James Bach & Michael Bolton — Satisfice / DevelopSense
- Rapid Software Testing (RST) methodology
- Heuristic Test Strategy Model (HTSM)
- *Lessons Learned in Software Testing* (2001, with Cem Kaner and Bret Pettichord)
- **Why they matter:** RST is the leading context-driven testing methodology; HTSM is the canonical heuristic framework for what to test and how to think about coverage. Sharp critics of certification-driven test theatre.
- Used in: test-strategy, heuristic-test-pass, exploratory-charter skills.

### Elisabeth Hendrickson
- *Explore It! Reduce Risk and Increase Confidence with Exploratory Testing* (2013)
- **Why she matters:** The clearest practitioner guide to structured exploratory testing; "test charters" as the unit of exploration; nines of touring heuristics (feature tour, claims tour, configuration tour, etc.).
- Used in: exploratory-charter, touring-heuristics skills.

### Lisa Crispin & Janet Gregory
- *Agile Testing* (2009)
- *More Agile Testing* (2014)
- *Agile Testing Condensed* (2019)
- Agile Testing Quadrants (with Brian Marick's original)
- **Why they matter:** Defined what testing looks like inside agile teams; the quadrants model that aligns test purpose with audience (business-facing vs technical-facing, supporting vs critiquing).
- Used in: agile-test-strategy, quadrant-mapping skills.

### Cem Kaner — Florida Tech, Context-Driven Testing
- *Testing Computer Software* (1988, rev. 1999)
- *Lessons Learned in Software Testing* (2001, co-authored)
- Seven principles of context-driven testing
- **Why he matters:** Foundational legal/academic voice on software testing; the context-driven principles are the philosophical underpinning of modern testing practice.
- Used in: context-assessment, test-principles skills.

### Gojko Adzic — Neuri Consulting
- *Specification by Example* (2011)
- *Bridging the Communication Gap* (2009)
- *Impact Mapping* (2012)
- **Why he matters:** Ties testing to product outcomes via examples that double as specifications and tests; impact mapping for whole-team measurement.
- Used in: specification-by-example, impact-mapping skills.

### Kent Beck
- *Test-Driven Development by Example* (2002)
- *Extreme Programming Explained* (1999)
- **Why he matters:** TDD originator; the red-green-refactor loop is the foundational microcycle of test-first development. (Shared anchor with software-engineer role.)
- Used in: tdd-discipline, red-green-refactor skills.

### Jez Humble & David Farley
- *Continuous Delivery* (2010)
- *Accelerate* (Humble, with Nicole Forsgren and Gene Kim, 2018)
- **Why they matter:** Defined the deployment pipeline as a testing artifact; the four DORA metrics ground tester effectiveness in business outcomes.
- Used in: deployment-pipeline, dora-metrics skills.

### John Hughes — Chalmers / Quviq
- "QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs" (2000)
- *Software Foundations* contributions
- **Why he matters:** Founded property-based testing — the discipline of generating thousands of inputs from a property specification rather than hand-writing examples. Now adopted across languages (Hypothesis, fast-check, ScalaCheck).
- Used in: property-based-testing skills.

### Maaret Pyhäjärvi
- *Exploratory Testing* (2017)
- *Mob Programming Guidebook* contributions
- **Why she matters:** Working-practitioner voice on combining exploratory and automated testing; the "ensemble testing" approach (mob testing).
- Used in: ensemble-testing, exploratory-charter skills.

### Mike Cohn — Mountain Goat Software
- *Succeeding with Agile* (2009)
- *Agile Estimating and Planning* (2005)
- Test Pyramid (popularized in *Succeeding with Agile*)
- **Why he matters:** The test pyramid is the most-cited mental model for test distribution (lots of unit, fewer integration, fewer end-to-end). It is also the most-misapplied — necessary anchor for skills that critique misuse.
- Used in: test-pyramid, test-distribution skills.

## See also

- **Brian Marick** — original Agile Testing Quadrants; "Examples and Anti-Examples" framing.
- **Jonathan Kohl** — *Tap Into Mobile Application Testing*; mobile-specific exploratory practice.
- **Alan Page** — *How We Test Software at Microsoft* (2008, with Ken Johnston and Bj Rollison) — historical reference for big-org test engineering.
- **Google Testing Blog** — engineering-practice patterns from a high-volume context.
- **Bret Pettichord** — co-author of *Lessons Learned in Software Testing*; voice on test management.

## Curation notes

Cap is ~10 anchors plus "see also." Adding a new anchor requires demoting an existing one.

The tester role spans multiple traditions: context-driven exploratory (Bach/Bolton/Kaner/Hendrickson), agile-integrated (Crispin/Gregory), specification-based (Adzic), test-first (Beck), continuous-delivery (Humble/Farley), and formal property-based (Hughes). The anchor selection covers each tradition deliberately. Mike Cohn appears as anchor not because his test pyramid is unimpeachable (it's frequently misapplied) but because skills critiquing real-world test distributions need it as a referent.

Test automation tools (Selenium, Cypress, Playwright, JUnit, pytest, etc.) are deliberately not anchors — they're tools, not frameworks of thought. Skills can mention them; they don't drive the conceptual scaffolding.
