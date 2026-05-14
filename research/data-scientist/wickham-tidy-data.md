# Hadley Wickham — distilled

> "Tidy Data" (Journal of Statistical Software, 2014); *R for Data Science* (2017, with Garrett Grolemund; 2e 2023, with Mine Çetinkaya-Rundel); the tidyverse design philosophy. The canonical voice on how to organise analytical datasets and how to build tools that exploit that organisation.

## Why it matters for AI-coding

AI-generated data-analysis code defaults to bespoke dataset shapes — each script receives whatever format the upstream happens to produce and massages it into whatever the downstream happens to need. Tidy data is the shared vocabulary that makes analytical work composable: one standard structure (one observation per row, one variable per column, one observational unit per table) lets any compliant tool interoperate with any compliant dataset without a custom adapter per pair. Wickham named this structure, formalised it, and built the tidyverse to exploit it. When an AI generates analysis code, the implicit assumption is almost always "I'll handle the shape here" — Wickham's discipline insists the shape is agreed in advance, not negotiated at each step.

Concretely: the `metric-definition` skill's numerator/denominator discipline, and the data-quality gate in `pre-launch-measurement-audit`, both assume that source data is tidy or that untidiness has been detected and surfaced. Without tidy data as a baseline expectation, metric definitions are ambiguous ("active users" means different things in wide vs. long event logs) and pre-launch audits miss structural data problems.

## Key concepts the role pulls from

- **Tidy data.** Three rules: (1) every variable has its own column; (2) every observation has its own row; (3) every observational unit forms its own table. Violations — wide data, multiple variables per column, row-level aggregates mixed with raw observations — produce analysis code that is brittle, non-composable, and hard to validate. The shape contract is the foundation under `metric-definition`'s unit-of-analysis discipline.
- **Tidying as a first transform.** The "tidy → transform → model → visualise → communicate" pipeline puts tidying before any analysis. Not because tidying is glamorous but because it makes every subsequent step deterministic. Applied to the role's audit workflows: data untidiness found during measurement audit is a pre-launch blocker, not a "we'll work around it" footnote.
- **Grammar of data manipulation.** The tidyverse verbs — `filter`, `select`, `mutate`, `group_by`, `summarise`, `join` — are a composable grammar, not a collection of one-off functions. The same verbs in the same composable pattern appear in SQL, in pandas method chains, in dplyr pipes. The grammar is the interface contract; the tool is an implementation detail. Powers the role's tooling-agnosticism: pandas, polars, duckdb, and SQL all support the same conceptual operations.
- **Grammar of graphics (ggplot2).** Wickham formalised Wilkinson's "Grammar of Graphics" into a practical tool. The underlying idea — aesthetics, geometries, scales, coordinates, facets as composable layers — applies beyond ggplot2: it is the mental model for evaluating whether a visualisation is encoding the right variables and whether it could mislead. Powers the `pre-launch-measurement-audit` visualisation-quality pass.
- **Functional, pipe-first style.** The tidyverse's preference for pure functions and piped transforms reduces hidden state: at any step in the pipeline, the state of the data is explicit. The opposite of a mutating loop with mid-step side effects. This style is directly load-bearing in the role's code-review stance: pipeline clarity is testable; implicit mutation is not.

## What to actually read (1-hour budget)

- **Wickham, "Tidy Data" (2014), Sections 1-5.** The paper is 23 pages and is the primary source. Sections 1-3 define the concept; Sections 4-5 show the five most common messy-data patterns and how to resolve them. This is the note in this distilled form.
- **R for Data Science (2e), Chapters 5-6** (data tidying with tidyr). The book concretises the paper's patterns with worked examples. Chapter 6 in particular (joins) surfaces the "one observational unit per table" rule under realistic data conditions.
- **R for Data Science (2e), Part I introduction.** The "whole game" chapter sets up the pipeline metaphor — tidy → transform → model → visualise → communicate — in four pages. Enough orientation to understand where tidying sits relative to everything else.

## What to skip

- The chapters on R-specific workflow (projects, RMarkdown, Quarto) — useful for R practitioners, not for the conceptual framework.
- The ggplot2-heavy visualisation chapters on the second read; the Grammar of Graphics idea is picked up faster from the paper references than from the tutorial examples.
- *R for Data Science* Part V (programme with R: functions, vectors, iteration) — important for R practitioners, but the conceptual content for this role's purposes is in Parts I-III.

## How this anchors role skills

- [`metric-definition`](../../roles/data-scientist/skills/metric-definition/SKILL.md) — the unit-of-analysis discipline (one row = one what?) is tidy data applied to metric numerators and denominators. A metric definition that would compute differently on a wide vs. long table is not tidy-data-compliant, and that non-compliance is a source of definitional drift.
- [`pre-launch-measurement-audit`](../../roles/data-scientist/skills/pre-launch-measurement-audit/SKILL.md) — the instrumentation readiness check includes a structural data-quality gate. Tidy data is the reference shape; untidy data (mixed grains, multiple observations per row, implicit pivots) is a finding that delays the launch.

## Cross-role connection

Tidy data is a shape contract — it defines the interface between data producers and data consumers. The engineer role's interface-design discipline (stable, versioned, composable interfaces) is the same instinct applied to code. When an engineer produces an events schema and a data scientist builds analysis on top of it, tidy data is the mutual contract. When AI generates both the producer and the consumer in one pass, the contract is implicit and fragile; Wickham's vocabulary makes it explicit and checkable. The engineer's `adr` skill (recording architectural decisions) is the right artifact for documenting the tidy-data contract across team boundaries.
