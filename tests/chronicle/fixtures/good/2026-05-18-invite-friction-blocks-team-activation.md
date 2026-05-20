---
id: 2026-05-18-invite-friction-blocks-team-activation
title: Invite-link friction blocks team activation under 50 seats
date: 2026-05-18
status: open
confidence: 0.55
source_role: product-manager
provenance: verbal
type: hypothesis
scope: [activation, growth]
affected_areas: ["onboarding/", "src/invite/"]
decision: Invite-link friction is the primary blocker for teams of <50 seats reaching the activation event.
review_after: 2026-07-01
---

## Assumption

Teams under 50 seats hit a single-admin bottleneck during onboarding — the admin who signs up has to invite the rest of the team manually, one at a time, and tends to drop off before completing the full team load.

## Prediction

If we ship a bulk-invite endpoint and a paste-emails CSV widget, time-to-activation for <50-seat teams drops by 30% within 60 days of the rollout, and the share of those teams that ever reach the activation event rises by at least 10pp.

## Falsifier

Either of these refutes the hypothesis:

- Time-to-activation stays within ±10% after the bulk-invite ships and at least 25% of new admins use the feature.
- We discover via discovery interviews that admins who drop off were blocked by a different step (e.g. SSO config, billing setup) regardless of invite UX.

## Evidence Log

- 2026-05-18 — verbal — 4 of 6 admins in last week's discovery sessions described the per-person invite flow as "tedious", but none specifically said it was why they stopped onboarding.
- 2026-05-18 — documented — Mixpanel: median time between first admin signup and second seat invited = 4.2 hours for <50-seat teams; >50-seat teams are at 18 minutes (different shape, possibly different selection).

## Resolution

Open. Will resolve when either the bulk-invite ships and we have 60 days of post-rollout data, or when discovery reveals the bottleneck is elsewhere.

## Notes

This hypothesis sits underneath the broader bet that "team activation, not single-user activation, is what drives expansion revenue." Don't conflate the two — the broader bet is the topic of a separate entry.
