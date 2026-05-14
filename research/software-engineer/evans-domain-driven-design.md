# Eric Evans — distilled

> *Domain-Driven Design: Tackling Complexity in the Heart of Software* (2003, Addison-Wesley). The foundational text of DDD; Evans coined most of the vocabulary the field still uses.

## Why it matters for AI-coding

AI tools generate code without a shared domain model — they optimise for syntax, not semantics. The result is code that compiles and passes tests but erodes the ubiquitous language that keeps a codebase comprehensible to its team. Evans's bounded-context discipline is the structural answer: it defines the seams at which AI-generated work can be integrated without contaminating adjacent models. A refactor that crosses bounded contexts without deliberate translation is a corruption risk; bounded contexts make that boundary legible and enforceable.

## Key concepts the role pulls from

- **Ubiquitous language.** A shared vocabulary, developed jointly by engineers and domain experts, that appears in the code, the model, the tests, and the conversations — with no translation layer between them. The methodology's strongest argument for naming that reflects domain reality rather than implementation convenience.
- **Bounded context.** A boundary within which a particular domain model applies consistently. Two contexts can use the same word ("customer") to mean different things; translation happens at the boundary, explicitly. The primary unit of modularity in strategic DDD.
- **Context map.** A diagram of bounded contexts and their relationships (Shared Kernel, Customer/Supplier, Anticorruption Layer, etc.). Forces teams to name the seams between their models rather than letting them erode into coupling.
- **Anticorruption layer.** A translation layer that protects a context's model from a foreign model's vocabulary. Essential when integrating third-party systems or legacy code. The explicit design artifact for "we don't let their naming pollute ours."
- **Aggregates and aggregate roots.** A cluster of domain objects treated as one unit for data consistency — modified only through the root. The load-bearing tactical pattern for defining transactional boundaries in the domain.
- **Strategic vs tactical DDD.** Strategic (bounded contexts, context maps) is about partitioning the domain. Tactical (entities, value objects, aggregates, domain services) is about implementing within a context. The methodology prioritises strategic DDD; tactical patterns follow once the model is clear.

## What to actually read (1-hour budget)

- **Part I — "Putting the Domain Model to Work"** (ch. 1-4) — ubiquitous language, model-driven design, and the distinction between entities and value objects.
- **Part IV — "Strategic Design"** (ch. 14-17) — bounded contexts, context maps, and the relationship patterns. This is the part that travels best to non-greenfield work.
- Eric Evans's 2015 DDD Europe talk ("DDD Isn't Done") is freely available and updates the 2003 text with Evans's own retrospective; worth an hour over Part II or III.

## What to skip

- **Part II — "The Building Blocks of a Model-Driven Design"** and **Part III — "Refactoring Toward Deeper Insight"** — valuable for deep DDD practitioners but lower priority for the methodology's strategic use of the work. Return to them when implementing within a bounded context.
- Chapters on domain-specific languages and supple design — interesting but rarely load-bearing for the methodology's skill invocations.

## How this anchors role skills

- [`refactor-plan`](../../roles/software-engineer/skills/refactor-plan/SKILL.md) — when a refactor crosses or reshapes a bounded context, the plan names the context boundary and the translation strategy (anticorruption layer, shared kernel, etc.). Evans is the citation when the refactor is really a domain-model restructuring, not just a code-shape change.
- [`rfc`](../../roles/software-engineer/skills/rfc/SKILL.md) — RFCs for new services or significant service-boundary changes invoke Evans's context-map framing: what relationship pattern (Customer/Supplier, Conformist, Published Language) governs this boundary?
- [`adr`](../../roles/software-engineer/skills/adr/SKILL.md) — ADRs that establish an anticorruption layer or define an aggregate root are Evans citations; the ADR captures which model is the source of truth at a given boundary.

## Cross-role connection

Evans's ubiquitous language is the engineering-side analogue of the product-manager's jobs-to-be-done. Both insist that the vocabulary used to describe the system must be grounded in what the user is actually trying to accomplish — not in implementation convenience, not in database schema, not in legacy naming. A PM doing JTBD discovery and an engineer mapping bounded contexts are, at best, calibrating the same shared vocabulary from opposite sides of the problem.
