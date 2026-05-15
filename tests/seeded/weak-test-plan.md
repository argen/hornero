# Test Plan — Checkout flow rewrite

**Owner:** QA / FE
**Status:** Ready for review

## What we're testing

The rewritten checkout flow: cart → address → payment → review → confirmation.
Replaces the legacy 4-step flow with the new 5-step Stripe Elements integration.

## Test cases

### TC-1: Happy path — single item, credit card

1. Add one item to the cart.
2. Go to checkout.
3. Enter a valid US address.
4. Enter a valid test credit card (4242 4242 4242 4242).
5. Click "Review."
6. Click "Confirm."

**Expected:** Order confirmation screen renders with the order ID.

### TC-2: Happy path — multiple items, Apple Pay

Same flow as TC-1 with three items in the cart and Apple Pay selected.

**Expected:** Order confirmation screen renders.

### TC-3: Happy path — returning customer

User has a saved address and saved card.

1. Go to checkout.
2. Click "Use saved address."
3. Click "Use saved card."
4. Click "Confirm."

**Expected:** Order confirmation screen.

## Coverage

- We will achieve >80% line coverage on `checkout/*.ts` per the CI rule.
- Each test will use Playwright with screenshots on success.

## Out of scope

- International addresses (separate ticket).
- Refund flow (separate ticket).
