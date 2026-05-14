# Task 17 — RFC: multi-region architecture migration

**Shape:** Engineer-led RFC critique with broad cross-functional implications. **Tests the upper-bound role mix (5 roles).**

**Artifact:** A 6-page RFC proposing migration from single-region (us-east-1) to multi-region (us-east-1 primary, eu-west-1 secondary) for a B2B SaaS product with EU customers. Includes: motivation (latency, compliance), proposed architecture (active-passive with manual failover), data-residency strategy (per-tenant placement), 8-week timeline, alternatives considered (active-active rejected for complexity, cell-based rejected for cost), rollback path. Two seeded issues: (1) data-residency strategy doesn't address pending GDPR/Schrems-II implications for the transit path; (2) measurement impact (region-tagged metrics, cross-region experiment validity) is not addressed at all.

**Recommended role mix (5):**

- `software-engineer` — load-bearing; Ousterhout / Larson on engineering strategy; active-passive vs active-active vs cell-based trade-off; rollback path realism.
- `product-manager` — does the migration match the customer need? EU-customer latency is the framed motivation; is that the actual customer job, or is compliance the actual driver?
- `security-expert` — cross-region data flow, secrets distribution, attack surface of failover machinery; the GDPR/Schrems-II angle on the transit path (this is the seeded gap).
- `data-scientist` — region-tagged metrics, cross-region experiment validity (SRM concerns when region is a randomisation co-variate), measurement plan for migration completion.
- `tester` — failover testing (chaos-engineering shape), regression risk during the migration window, deferred-coverage decisions.

**Why not other roles:** internal infrastructure RFC; no immediate UI or marketing surface (will come later as a "we now serve EU natively" message, but not now).

**What "good" looks like:**

- Engineer cites Ousterhout (or Larson on strategy) on the active-passive vs active-active decision; surfaces the rollback-path realism (can we actually roll back 4 weeks in?).
- PM names the compliance-vs-latency motivation question explicitly — if compliance is the real driver, the timeline/risk profile is different.
- Security catches the GDPR/Schrems-II transit-path issue (seeded). If they miss it, the synthesis should still surface the gap from cross-role triage.
- Data-scientist catches the measurement-impact gap (seeded). Names ≥1 specific concern (region-tagged metrics, experiment-validity).
- Tester proposes a failover-test plan with ≥1 specific failure-injection scenario.
- The synthesis names ≥1 *real* conflict — e.g., engineer prefers active-active for resilience; security flags the additional attack surface; PM resolves toward active-passive for the launch and active-active as a follow-on.

**Anti-patterns to watch for:**

- 5 roles producing overlapping "looks fine" findings (Dimension 2 failure at the upper-bound mix).
- "GDPR considerations" handwaved without naming Schrems-II or specific data-transit concerns (Dimension 1 failure on security).
- Measurement gap missed entirely (the synthesis should surface this even if DS didn't lead with it).

**How to run:**

1. Place the RFC at `evals/runs/17-rfc-multi-region-architecture/artifact.md` (the `roles/software-engineer/skills/rfc/SKILL.md` template applies).
2. Invoke `multi-role-review` with engineer + PM + security + data-scientist + tester (5 roles — the upper bound).
3. Score with particular attention to whether the synthesis distinguishes the 5 lenses or whether they collapse into 2-3 effective views (Dimension 2).

**Note:** like tasks 04 and 15, this exercises a non-default invocation shape (5 roles). Score in the 4-5-role cohort when aggregating; the simpler 2-3-role tasks make up the other cohort.
