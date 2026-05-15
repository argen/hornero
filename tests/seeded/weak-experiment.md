# Experiment — Pricing-page CTA copy

**Owner:** Growth
**Status:** Ready to launch

## Hypothesis

Changing the pricing-page primary CTA from "Get started" to "Start free trial"
will increase signup conversion.

## Design

- **Variants:** Control ("Get started") vs Treatment ("Start free trial").
- **Allocation:** 50/50 by hashed visitor ID.
- **Primary metric:** signup conversion rate (signup_event / pricing_page_view).
- **Window:** 2 weeks.

## Decision rule

We will check the dashboard daily. If at any point the treatment is
significantly better at p < 0.05, we ship the treatment and end the
experiment early. If after 2 weeks the result is not significant, we keep
the control.

## Pre-existing context

- Pricing page gets ~20,000 unique visitors per week.
- Current signup conversion rate is around 4%.
- We didn't model an effect size in advance — we'll know it when we see it.

## Implementation

- Variant served via existing feature-flag service; assignment is sticky per
  visitor ID.
- Events fire on pricing-page view and on signup completion.
- No additional logging required.

## Out of scope

- Pricing changes themselves (separate experiment).
- Mobile pricing page (not yet redesigned).
