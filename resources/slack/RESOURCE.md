---
name: slack
description: Slack team comms — channels, messages, threads, users, search. Used by PMs to gather async feedback, surface customer signal, and stitch together cross-functional context.
type: data-source
status: stretch
mcp:
  server: "@modelcontextprotocol/server-slack"
  install: "claude mcp add slack -- npx -y @modelcontextprotocol/server-slack"
  auth_env: [SLACK_BOT_TOKEN, SLACK_TEAM_ID]
  capabilities: [channels, messages, users, threads, search, reactions, files]
object_model: [Workspace, Channel, User, Message, Thread, File, Reaction, Bookmark]
used_by: []
fallback: curl
---

## Purpose

Slack is where async context lives: customer feedback threads, cross-functional sync, incident channels, PM ↔ eng back-and-forth that never lands in Linear or GitHub. Hornero skills touch Slack to surface that signal — surfacing customer complaints buried in a support channel, stitching together the discussion that preceded a priority call, or auditing reaction patterns on announcements. Primary consumers: PMs (customer-signal triage, async-feedback synthesis). Skills using Slack are scaffolded for future work; none are live yet.

## MCP Server

**Canonical server:** `@modelcontextprotocol/server-slack` — the reference implementation maintained in the MCP org. See References for source.

**Install:**

```sh
claude mcp add slack -- npx -y @modelcontextprotocol/server-slack
```

**Auth:** set `SLACK_BOT_TOKEN` to a Bot User OAuth Token (begins `xoxb-`). Generate by creating a Slack App in your workspace and installing it. Set `SLACK_TEAM_ID` to the workspace ID (T-prefixed) to scope to the right workspace.

Required bot token scopes (typical read-only use):

| Scope | Grants |
|---|---|
| `channels:read`, `channels:history` | Public channel list + message history |
| `groups:read`, `groups:history` | Private channel list + history |
| `users:read` | User list, display names, timezones |
| `users:read.email` | User emails — separate scope, request only if needed |
| `reactions:read` | Emoji reactions on messages |
| `im:read`, `im:history` | DM history — needs explicit inclusion |
| `search:read` | Full-text search (Enterprise Grid only; see Gotchas) |
| `files:read` | File metadata + download URLs |

Add `chat:write` only if a skill needs to post. Keep the token scope minimal — over-broad tokens are an incident waiting to happen.

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `channels` | List/join channels | (future: signal-triage) |
| `messages` | Read channel history | (future: signal-triage) |
| `threads` | Read thread replies | (future: signal-triage) |
| `users` | Resolve user IDs to names | (future: signal-triage) |
| `search` | Full-text across workspace | (Enterprise Grid only) |
| `reactions` | Emoji signal on messages | (future: signal-triage) |
| `files` | Attached artifacts | (future) |

## Object Model

- **Workspace** (Team) — T-prefixed ID. The root scope; `SLACK_TEAM_ID` pins to one.
- **Channel** — C-prefixed ID (unified for public and private in the modern `conversations.*` API). Has `name`, `topic`, `purpose`, `is_archived`, `is_member`. Bot must be a member to read history.
- **User** — U-prefixed (humans), B-prefixed (bots — easy to conflate with real users). Fields: `real_name`, `display_name`, `email` (gated by `users:read.email`), `tz`.
- **Message** — identified by `ts` (e.g. `1234567890.123456`, seconds.microseconds since epoch). `ts` is both the timestamp and the unique ID within a channel. Reply messages carry `thread_ts` pointing at the parent.
- **Thread** — not a first-class API object. Reconstructed from a parent message and its replies via `thread_ts` linkage. Fetch with `conversations.replies` using parent's `ts`.
- **File** — uploaded artifact. `url_private` requires an `Authorization` header on download (not pre-signed). Needs `files:read` scope.
- **Reaction** — emoji name + user + timestamp on a message. Custom emoji return name only — no rendering data from the API.
- **Bookmark** — channel-level pinned link.

**Relationships:**
- Channel → 0..N Messages; Message → 0..1 Thread (via `thread_ts`)
- Message → 0..N Reactions, 0..N Files
- User → N Channel memberships

## Common Gotchas

- **Bot must be in the channel.** `channels:history` scope alone is insufficient for channels the bot hasn't joined. For public channels use `conversations.join`; for private, someone must manually invite the bot. Silently missing channels are the most common auth puzzle.
- **`ts` is the message ID.** `1234567890.123456` — pass the parent's `ts` as `thread_ts` to reply in-thread. Passing your own message's `ts` instead creates a new thread off the wrong message.
- **Rate limits are tier-based.** `conversations.history` (Tier 2) ~20 req/min; `search.messages` (Tier 1) ~1 req/min. Bursts are allowed but averages are enforced. Always use cursor pagination.
- **Cursor pagination, not offset.** Use `next_cursor` from `response_metadata`. Offset-style page indexing does not exist in the Conversations API.
- **`search.messages` is Enterprise Grid only.** Free and Pro workspaces cannot search via bot token — bot search is gated behind Enterprise Grid licensing. On standard workspaces, replicate search by fetching channel history and filtering client-side; expensive but the only option.
- **`groups.*` family is deprecated.** Private channels historically used G-prefixed IDs and `groups.*` methods. Modern API uses C-prefix and `conversations.*` for everything. Old code works but will eventually break — migrate to `conversations.*`.
- **Email is a separate scope.** `users:read` gives name/display_name/tz; email requires the additional `users:read.email` scope. Don't request it unless a skill actually needs to resolve identities to email.
- **DM history is opt-in.** `im:history` + `im:read` scopes are required and will raise flags in your Slack App review. Request only if the use case genuinely needs DMs.
- **File download requires auth.** `url_private` is not pre-signed — attach `Authorization: Bearer ${SLACK_BOT_TOKEN}` to the download request. `url_private_download` (if present) is the same; both need the header.
- **Message edits don't bump `ts`.** Check the `edited` sub-object on the message for the current text and edit timestamp. The original `ts` is stable.
- **User token (`xoxp-`) vs. bot token (`xoxb-`).** User tokens give broader access (including `search` on non-Enterprise) but require user OAuth and carry the user's permissions. Bot tokens are simpler, auditable, and preferred for automated skills.

## Fallback Without MCP

If the MCP server isn't available, use the Slack Web API directly via `curl`. The base URL is `https://slack.com/api/`.

List channels (public + private the bot is in):

```sh
curl -G "https://slack.com/api/conversations.list" \
  -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
  --data-urlencode "types=public_channel,private_channel" \
  --data-urlencode "limit=200"
```

Read recent messages from a channel:

```sh
curl -G "https://slack.com/api/conversations.history" \
  -H "Authorization: Bearer ${SLACK_BOT_TOKEN}" \
  --data-urlencode "channel=C012345ABCD" \
  --data-urlencode "limit=100"
```

Paginate using `next_cursor` from `response_metadata.next_cursor`; pass it as `cursor=` on the next request.

For app management and OAuth setup, `slack-cli` (<https://api.slack.com/automation/cli>) handles manifest deployment and app installs — it is not intended for reading messages day-to-day.

## References

- Slack Web API — <https://api.slack.com/web>
- Conversations API (`conversations.history`) — <https://api.slack.com/methods/conversations.history>
- Scope reference — <https://api.slack.com/scopes>
- Rate limits — <https://api.slack.com/docs/rate-limits>
- MCP Slack server — <https://github.com/modelcontextprotocol/servers/tree/main/src/slack>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. Slack is scaffolded for future PM skills around customer-signal triage and async-feedback synthesis.
