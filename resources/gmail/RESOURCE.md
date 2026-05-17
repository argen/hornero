---
name: gmail
description: Gmail inbox — threads, drafts, labels, search. Used by PMs and marketers to read customer replies, draft stakeholder updates, and label/triage incoming email signal.
type: data-source
status: stable
mcp:
  server: "claude.ai integration (mcp__claude_ai_Gmail__)"
  install: "Enable via claude.ai Settings → Integrations → Gmail (OAuth)"
  auth_env: []
  auth: oauth
  capabilities: [threads, drafts, labels, search]
object_model: [Thread, Message, Draft, Label]
used_by: []
fallback: curl
---

## Purpose

Gmail is where stakeholder communication, customer replies, and async signal live outside of Slack and issue trackers. Hornero skills can read threads, search for signal by query, draft replies, and manage labels for triage. Primary consumers: PMs (customer-email triage, stakeholder comms), marketing (campaign reply handling), data scientists (survey responses surfaced via search).

## MCP Server

**Canonical integration:** `mcp__claude_ai_Gmail__` — the native Gmail integration in claude.ai. Enable it via **Settings → Integrations → Gmail** and complete the Google OAuth flow. No API key or local server needed.

**Capabilities exposed:**

| Capability | Tools | Hornero skills |
|---|---|---|
| Thread reading | `get_thread`, `search_threads` | (future: email-triage) |
| Draft management | `create_draft`, `list_drafts` | (future: stakeholder-update) |
| Label CRUD | `create_label`, `update_label`, `delete_label`, `list_labels` | (future: email-triage) |
| Label application | `label_message`, `label_thread`, `unlabel_message`, `unlabel_thread` | (future: email-triage) |

**Auth:** OAuth via claude.ai. The integration uses Google OAuth; grant the minimum Gmail scopes (read + labels). Write scopes (compose, send) are only needed if a skill creates or sends drafts.

### Self-hosted alternative

For team deployments or CI environments where the claude.ai integration isn't available:

```sh
# Community server (verify before adoption — no official MCP org server yet)
claude mcp add gmail -- npx -y @gptscript-ai/mcp-server-gmail
```

Auth: `GMAIL_CREDENTIALS_FILE` pointing at an OAuth 2.0 JSON credentials file downloaded from Google Cloud Console. Scopes: `https://www.googleapis.com/auth/gmail.readonly` (+ `.modify` for label writes, `.compose` for drafts).

## Object Model

- **Thread** — a conversation consisting of one or more messages sharing a `threadId`. `id` = `threadId`. Has `snippet` (first ~100 chars), `historyId`, and a list of `messages`.
- **Message** — individual email within a thread. `id` is unique; `threadId` links back. Payload has `headers` (From, To, Subject, Date) and `body` (MIME parts, base64url-encoded). Label IDs are on the message, not the thread.
- **Draft** — unsent message. `id` is the draft ID; `message` is the embedded `Message` object. `create_draft` returns the draft ID for later `send` via the REST API.
- **Label** — user-created or system label. System labels: `INBOX`, `SENT`, `TRASH`, `SPAM`, `UNREAD`, `STARRED`, `IMPORTANT`. User labels have `type: user`.

**Relationships:**
- Thread → 1..N Messages (chronological)
- Message → 0..N Labels
- Label → N Messages (many-to-many)

## Common Gotchas

- **Threads vs. messages are not interchangeable.** `search_threads` returns thread IDs; `get_thread` returns all messages. Don't assume the latest message in a thread is the first returned — order is oldest-first by default.
- **Base64url body encoding.** Message body parts are base64url-encoded (not standard base64). Decode with `base64.urlsafe_b64decode` in Python or `Buffer.from(data, 'base64url')` in Node. Standard `atob`/base64 decoders will fail on padding-free variants.
- **`search_threads` uses Gmail query syntax.** Queries like `from:user@example.com newer_than:7d is:unread` are the full Gmail search language. `label:inbox` filters to inbox threads. Quote exact phrases. Max 500 results per search; paginate via `nextPageToken`.
- **System labels can't be deleted or renamed.** Attempting to delete `INBOX` or `SENT` returns a 400. Only user-type labels are mutable.
- **Label IDs ≠ label names.** System labels use string IDs (`INBOX`, `UNREAD`); user labels get opaque IDs (`Label_12345`). Always resolve via `list_labels` and map by `name` to get the stable `id` before applying.
- **`create_draft` does not send.** To send a draft, call the Gmail REST API `POST /gmail/v1/users/me/drafts/{id}/send` separately — the MCP integration exposes draft creation but not send.
- **Rate limits: 250 quota units/user/second.** `search_threads` costs 5 units, `get_thread` costs 5, `create_draft` costs 10. Bulk thread reads of large inboxes will throttle; add exponential back-off on 429s.
- **Attachments are MIME parts, not first-class objects.** To read an attachment, fetch the message, walk the `payload.parts` tree to find `mimeType != text/*`, extract the `body.attachmentId`, then call `GET /gmail/v1/users/me/messages/{messageId}/attachments/{attachmentId}` via the REST API.

## Fallback Without MCP

If the integration isn't available, use the Gmail REST API directly:

```sh
# Search threads (requires OAuth token — not an API key)
curl -G "https://gmail.googleapis.com/gmail/v1/users/me/threads" \
  -H "Authorization: Bearer ${GMAIL_OAUTH_TOKEN}" \
  --data-urlencode "q=from:customer@example.com newer_than:7d" \
  --data-urlencode "maxResults=50"
```

```sh
# Get a specific thread
curl "https://gmail.googleapis.com/gmail/v1/users/me/threads/THREAD_ID?format=full" \
  -H "Authorization: Bearer ${GMAIL_OAUTH_TOKEN}"
```

OAuth tokens can be obtained via `gcloud auth application-default login` (for dev/local) or a service account with domain-wide delegation (for server-side). The REST API supports the full Gmail scope set — see References.

## References

- Gmail API overview — <https://developers.google.com/gmail/api/guides>
- Gmail search operators — <https://support.google.com/mail/answer/7190>
- Gmail OAuth scopes — <https://developers.google.com/gmail/api/auth/scopes>
- Rate limits — <https://developers.google.com/gmail/api/reference/quota>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently.
