# Gojko Adzic — distilled

> *Specification by Example* (2011); *Bridging the Communication Gap* (2009); *Impact Mapping* (2012). Neuri Consulting.

## Why it matters for AI-coding

AI-generated tests describe what the implementation does. Specification by example describes what the product is supposed to do — and the difference survives refactors. When an implementation is rewritten, tests that assert internal behaviour break; tests written as executable specifications (in the language of the problem domain) continue to pass or fail based on whether the intent is met.

This is the load-bearing distinction for AI-assisted teams: the AI can generate a broad suite of implementation-following tests in seconds. The team's job is to ensure that a layer of intent-capturing specification-tests also exists — authored in domain language, derived from real examples that business stakeholders recognise, and durable enough to serve as living documentation. Without this layer, the test suite tells you about the code; it does not tell you about the product.

## Key concepts the role pulls from

- **Specification by example.** The discipline of using concrete examples — drawn from real conversations between business stakeholders, testers, and developers — as the primary form of system specification. Each example is unambiguous, testable, and written in the domain's language, not the implementation's. Powers `test-plan`'s "Specification-by-Example scenarios" inventory section.
- **Key examples.** Not all examples are equal; key examples are the minimal set that captures the full range of business rules. Adzic distinguishes key examples from exhaustive examples — the former drive specification; the latter are for regression. The methodology's test-plan template distinguishes these two by putting specification-by-example scenarios in their own section.
- **Living documentation.** A test suite authored in domain language, kept green, and named after business rules is a form of documentation that stays current by definition. It cannot drift from the implementation because it is tested against the implementation. Powers the `regression-test` skill's "name the bug in the test" discipline — a named, domain-language test is readable as a rule, not just as code.
- **Gherkin / given-when-then.** The most widespread notation for executable specifications. Adzic didn't invent Gherkin but his work gave the structure its conceptual grounding: Given (context), When (action), Then (outcome). The notation disciplines teams into writing specifications from the user's perspective, not the code's.
- **Bridging the communication gap.** The core claim of *Bridging the Communication Gap*: the gap between what stakeholders want and what developers build is a specification problem. Examples, when gathered in three-amigo sessions (business, developer, tester), surface mismatches before code is written.

## What to actually read (1-hour budget)

- *Specification by Example* — Chapter 1 (what SbE is and why the pattern matters for software delivery), Chapter 3 (deriving scope from goals), Chapter 5 (illustrating using examples), Chapter 8 (automating acceptance tests without coupling to implementation). These four chapters are the conceptual core.
- *Impact Mapping* — short (100 pages); read whole if you have two hours. The impact map is how you decide which features deserve a specification — by connecting them to measurable business outcomes.

## What to skip

- *Specification by Example* chapters 12-15 (implementation case studies from 2010-era projects) — tool-specific details have aged; the principles haven't.
- *Bridging the Communication Gap* if you've read *Specification by Example* — the latter supersedes the former conceptually.

## How this anchors role skills

- [`test-plan`](../../roles/tester/skills/test-plan/SKILL.md) — "Specification-by-Example scenarios" is a named section of the plan template; the skill's Key Concepts section cites Adzic's given-when-then and key-examples distinction directly.
- [`regression-test`](../../roles/tester/skills/regression-test/SKILL.md) — "examples as specifications" powers the skill's insistence that test names read as domain rules ("credit card with month 13 is rejected") rather than implementation labels ("test_validation_works").

## Cross-role connection

Specification by example is the tester's version of the product-manager's PRD evidence section: both anchor a feature's acceptance criteria in concrete, observable outcomes rather than abstract requirements. A PM who writes "users can successfully complete checkout with a saved payment method" and a tester who writes a Given/When/Then scenario for the same intent are producing the same artifact from different starting points. The methodology's `prd` skill and `test-plan` skill deliberately share a risk/outcome vocabulary for this reason. In three-amigo sessions (business, developer, tester) — Adzic's recommended practice for gathering key examples — the PM and tester are co-authoring specifications, not doing separate work that must later be aligned.


