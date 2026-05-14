# Task 06 — Dashboard redesign spec review

**Shape:** Design + PM + data-scientist critique of a dashboard redesign spec.

**Artifact:** A spec for redesigning a B2B analytics dashboard's "Overview" tab. Includes a Figma link, an information-architecture rationale, a list of metrics shown, and a stated goal of "improve at-a-glance understanding of business health."

**Recommended role mix (3):**

- `designer` — IA, hierarchy, state inventory, accessibility, platform conventions, visualisation integrity (Tufte).
- `product-manager` — does this dashboard support a stated decision? What outcome will tell us the redesign was right?
- `data-scientist` — visualisation integrity (truncated axes, dual-axis, log-without-indication); are the metrics shown the right ones; counter-metrics paired?

**Why not other roles:** internal-tools UI change, no auth or data-flow trust boundary → no security. No launch (internal feature) → no marketing. Engineering is consuming the spec, not reviewing it for product fit at this stage.

**What "good" looks like:**

- Designer enumerates the six states for each interactive surface; cites Nielsen on visibility of state or Norman on information mapping.
- PM frames at least one finding around "this dashboard exists to support which decision" — the build-trap test (Perri) often fires here.
- Data-scientist checks visualisation integrity (Tufte is in designer sources, but the data-scientist applies it here) — cites at least one specific viz hazard (truncated axes, dual-axis, missing baseline).
- The synthesis names ≥1 conflict — likely PM wanting more density / more metrics, designer wanting fewer / cleaner, data-scientist wanting counter-metrics paired with each headline.

**Anti-patterns to watch for:**

- Designer review reduces to "use a different blue" (style critique, not UX).
- PM review wanders into "I'd prefer to see chart X instead" (design adjudication).
- Data-scientist review approves the spec because the metrics are "directionally right" without checking definitions.

**How to run:**

1. Provide a synthetic spec or use a real one from the team's design archive.
2. Invoke `multi-role-review` with the three roles.
3. Score.
