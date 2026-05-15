# Spec — Password reset flow

**Owner:** Platform / Auth
**Status:** Ready for review

## What it is

A self-serve password reset for end users. User enters their email; we send a
reset link; clicking the link lets them set a new password. The flow needs to
land before the marketing push next month.

## Endpoints

### `POST /auth/password-reset/request`

**Body:** `{ "email": "user@example.com" }`

**Behaviour:**

- If the email is in the `users` table: generate a single-use reset token,
  store it in `password_reset_tokens` (TTL 1 hour), email the user a link of
  the form `https://app/reset?token=<token>`.
  - Response: `200 { "status": "sent" }`
- If the email is **not** in the `users` table:
  - Response: `404 { "error": "no such email" }`

### `POST /auth/password-reset/confirm`

**Body:** `{ "token": "...", "new_password": "..." }`

**Behaviour:** Look up the token, ensure not expired, update the user's
password hash, delete the token.

## Storage

- Reset tokens are 32-byte random strings (hex-encoded, 64 chars in URLs).
- Stored in plaintext in `password_reset_tokens.token` for simple lookup.

## Rate limits

- 60 requests per minute per IP on `/request` (existing global middleware).

## Out of scope

- Account lockout after N failed attempts.
- 2FA changes.
