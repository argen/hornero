# PRD — "Save Filter as a View"

**Owner:** PM (Workflows pod)
**Status:** Draft for design + eng review

## Audience

Power users of the inbox view who run the same multi-filter query at least
once per day. Internal data shows ~1,200 users currently re-apply the same
3+ filter combination ≥ 5 times per week; this PRD targets that segment.
Casual users (≤ 1 filter per session) are out of scope.

## The job

Today these users re-build their filter from scratch every time they open
the inbox. They've told us this in support tickets ("can I save this?"),
in NPS verbatim ("the filter resets every time"), and in our last user
interview round (5/8 mentioned it unprompted). The job-to-be-done: *recall
my preferred slice of work without rebuilding it.*

## What we're building

A "Save as view" affordance on the filter bar. Saved views appear in the
left rail under "Views"; clicking one applies the saved filter set. Views
are private to the user; cross-user sharing is explicitly out of scope
for v1.

## Success — outcomes, not activity

We will declare success on the **30-day retention curve of users who save
at least one view** vs. a matched cohort who don't. Mechanism: matched
pairs by tenure × seat tier × pre-period activity decile; difference in
30d active retention measured 8 weeks post-launch.

**Target:** matched-pair retention lift ≥ 3pp (absolute), p < 0.05 with
n ≥ 400 pairs.

Activity instrumentation (view-save events, view-apply events) exists for
diagnostics but is not the success bar. We will only ship view-create
prompts if matched-pair retention moves; raw view-creation count moving
without retention moving is not a win.

## Guarding against the obvious failure mode

Retention can climb because the feature kept *existing* power users alive
even as the broader inbox experience degraded. To rule that out, the same
window measures:

- Inbox-load p95 latency (cannot regress beyond +5%).
- Support volume tagged "filter" or "inbox" (cannot rise beyond noise).
- New-user week-1 activation (a population that cannot use views yet —
  acts as a placebo cohort that should be flat).

If retention moves but any of the three drifts, we treat the win as
unproven and investigate before scaling.

## Decision points

- **Cap at 25 views per user.** Above that, the left rail becomes a
  competing browse problem. We can revisit if real usage approaches the
  cap.
- **Don't auto-suggest views.** Tried in a similar shape in 2024; the
  suggestion noise outweighed the help (the team's internal write-up is
  in `decisions/2024-11-view-suggestions.md`).

## Risks

- Power users want sharing on day 1. We will say no, and document why
  (privacy review still open). If pushback is severe we revisit sharing
  in v2; v1 is a deliberately narrow cut.
- The matched-pair design requires 8 weeks of post-launch data. We will
  not ship the next feature against the same cohort in that window.

## Rollout

5% → 25% → 100% gated on the guardrails above. Two-week soak at each
step. Killswitch behind a single flag in the existing experiment
service.
