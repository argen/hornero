---
name: intercom
description: Intercom's customer messaging platform — conversations, contacts, companies, tickets. Used by PMs and data scientists to read support signal, surface churn risk, and understand customer pain points.
type: data-source
status: stable
mcp:
  server: "claude.ai integration (mcp__claude_ai_Intercom__)"
  install: "Enable via claude.ai Settings → Integrations → Intercom (OAuth)"
  auth_env: []
  auth: oauth
  capabilities: [conversations, contacts, companies, tickets, tags, search]
object_model: [Conversation, Contact, Company, Message, Tag, Team, Ticket]
used_by: []
fallback: curl
---

## Purpose

Intercom is where live customer support signal lives — support threads, product questions, churn signals, feature requests surfaced in conversation. Hornero skills can search conversations for recurring pain points, read contact and company data to understand who is complaining, and surface aggregate patterns for PM triage. Primary consumers: PMs (customer-pain triage, churn signal), data scientists (support volume and sentiment analysis), customer success (contact and company health).

## MCP Server

**Canonical integration:** `mcp__claude_ai_Intercom__` — the native Intercom integration in claude.ai. Enable it via **Settings → Integrations → Intercom** and complete the OAuth flow.

The integration uses an OAuth handshake (`authenticate` → `complete_authentication`) before the full conversation and contact tools become available. Run the authenticate tool once per session.

**Capabilities (post-auth):**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `conversations` | Read and search customer conversations | (future: support-signal-triage) |
| `contacts` | Read user and lead profiles | (future: support-signal-triage) |
| `companies` | Read company accounts, ARR, health | (future: churn-signal) |
| `tickets` | Read and manage support tickets | (future: support-signal-triage) |
| `tags` | Read conversation and contact tags | (future: support-signal-triage) |
| `search` | Full-text search across conversations | (future: support-signal-triage) |

**Auth:** OAuth via claude.ai. Intercom's OAuth uses workspace-level access — the authenticated user determines which conversations and contacts are visible. Request `read` scopes for triage skills; add `write` scopes only for skills that assign, tag, or resolve conversations.

### Self-hosted alternative

```sh
# Community server (verify before adoption)
claude mcp add intercom -- npx -y @intercom/mcp-server
```

Auth: `INTERCOM_ACCESS_TOKEN` — generate a personal access token or an OAuth app token at **Settings → Developers → Developer Hub → Your App → Authentication**.

## Object Model

- **Conversation** — a support thread. `id` is numeric. Has `created_at`, `updated_at`, `state` (open/closed/snoozed), `source` (chat/email/in-app/twitter), `assignee` (admin or team), `contact_ids` (participants), `tags`, `conversation_parts` (messages).
- **Contact** — a person (user or lead). `id` is an opaque string. Has `email`, `name`, `created_at`, `last_seen_at`, `plan`, `custom_attributes`. Contacts belong to 0..N Companies.
- **Company** — an account. `company_id` is the canonical ID (often maps to your internal account ID). Has `name`, `plan`, `monthly_spend`, `user_count`, `created_at`, `custom_attributes`.
- **Message** / **Conversation Part** — a single message within a conversation. Has `author` (admin, bot, or user), `body` (HTML), `created_at`, `part_type` (comment/note/assignment/etc.). Notes (internal) vs. comments (customer-visible) are distinguished by `part_type`.
- **Tag** — a label applied to conversations or contacts. Has `id` and `name`. Many-to-many with both.
- **Team** — a group of admins (agents). `id` is numeric. Used for routing conversations.
- **Ticket** — structured support request (distinct from conversations in newer Intercom versions). Has `ticket_type`, `state`, `contacts`, and custom attributes defined by your ticket type schema.

**Relationships:**
- Conversation → 1..N Contacts (participants)
- Conversation → 0..1 Assignee (Admin or Team)
- Conversation → 0..N Tags
- Conversation → 1..N Conversation Parts (messages)
- Contact → 0..N Companies
- Company → 0..N Contacts

## Common Gotchas

- **`state` filtering is coarse.** There's no native "open and unresolved" vs. "open and waiting for reply" filter via the API — those distinctions exist in the UI but are approximated via `last_part_type` (last message author type) in the API response. Build your own logic on top.
- **Cursor-based pagination only.** Intercom uses `starting_after` (a cursor value from the previous page's last item) — not page numbers or offsets. Cache `starting_after` values to resume pagination. Max page size is 150 for conversations.
- **Rate limits: 1,000 requests/minute (OAuth apps), 500 requests/minute (personal tokens).** Bulk conversation reads of large workspaces will throttle. Use the `search` endpoint to filter server-side rather than listing everything and filtering client-side.
- **HTML body, not plain text.** `Conversation Part.body` is HTML. Strip tags for text analysis or NLP — don't treat raw HTML as plain text.
- **Notes are internal, comments are public.** `part_type: note` is visible to agents only. `part_type: comment` is visible to the customer. Mixing them in a sentiment analysis pipeline will pollute results with internal agent commentary.
- **`custom_attributes` keys are workspace-specific.** Attribute names vary per Intercom workspace — there's no standard schema. Always inspect a sample of contacts/companies to understand the actual attribute set before relying on a specific key.
- **Contacts and users are unified.** Intercom merged "users" and "leads" into a single "contacts" object. The `role` field (`user` or `lead`) is the distinction. `user` = identified (has `user_id`), `lead` = anonymous.
- **Workspace vs. test workspace.** Intercom provides a test workspace for development. OAuth tokens are workspace-scoped — a token for the test workspace will not return production data. Verify which workspace you're authenticating against.

## Fallback Without MCP

Search conversations (requires Bearer token):

```sh
curl -X POST "https://api.intercom.io/conversations/search" \
  -H "Authorization: Bearer ${INTERCOM_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Intercom-Version: 2.11" \
  -d '{
    "query": {
      "field": "state",
      "operator": "=",
      "value": "open"
    },
    "pagination": {"per_page": 50}
  }'
```

Read a contact:

```sh
curl "https://api.intercom.io/contacts/CONTACT_ID" \
  -H "Authorization: Bearer ${INTERCOM_ACCESS_TOKEN}" \
  -H "Intercom-Version: 2.11"
```

The `Intercom-Version` header pins the API version — use the latest stable version (currently `2.11`). Omitting it uses the workspace's default, which may change without notice.

## References

- Intercom REST API — <https://developers.intercom.com/docs/references/rest-api/openapi.yaml>
- Conversations search — <https://developers.intercom.com/docs/references/rest-api/api.intercom.io/Conversations/SearchConversations/>
- Rate limits — <https://developers.intercom.com/docs/build-an-integration/learn-more/rate-limiting/>
- OAuth guide — <https://developers.intercom.com/docs/build-an-integration/getting-started/authentication/>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently.
