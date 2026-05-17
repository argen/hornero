---
name: google-calendar
description: Google Calendar — events, calendars, attendees, free/busy. Used by PMs and data scientists to read meeting load, schedule actions, and surface scheduling context for planning work.
type: data-source
status: stable
mcp:
  server: "claude.ai integration (mcp__claude_ai_Google_Calendar__)"
  install: "Enable via claude.ai Settings → Integrations → Google Calendar (OAuth)"
  auth_env: []
  auth: oauth
  capabilities: [events, calendars, freebusy, attendees]
object_model: [Calendar, Event, Attendee, FreeBusy]
used_by: []
fallback: curl
---

## Purpose

Google Calendar surfaces the meeting context that shapes how people actually spend their time. Hornero skills can read event schedules, check free/busy availability, and analyse attendee patterns — giving PM and data-scientist roles the scheduling context they need for planning, capacity analysis, or meeting-load audits. Creating or updating events supports scheduling coordination use cases.

## MCP Server

**Canonical integration:** `mcp__claude_ai_Google_Calendar__` — the native Google Calendar integration in claude.ai. Enable it via **Settings → Integrations → Google Calendar** and complete the Google OAuth flow.

The integration uses an OAuth handshake (`authenticate` → `complete_authentication`) before the full event and calendar tools become available. Run the authenticate tool once per session to activate the integration.

**Capabilities (post-auth):**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `events` | Read/create/update/delete events | (future: scheduling, meeting-load) |
| `calendars` | List and read calendar metadata | (future: scheduling) |
| `freebusy` | Query availability windows | (future: scheduling coordination) |
| `attendees` | Read attendee lists and RSVP status | (future: meeting-load analysis) |

**Auth:** OAuth via claude.ai. Grant at minimum `https://www.googleapis.com/auth/calendar.readonly`; add `.events` scope if skills need to create or modify events.

### Self-hosted alternative

```sh
# Community server
claude mcp add google-calendar -- npx -y @modelcontextprotocol/server-google-calendar
```

Auth: OAuth 2.0 credentials JSON from Google Cloud Console. Set `GOOGLE_OAUTH_CREDENTIALS` to the credentials file path.

## Object Model

- **Calendar** — a named collection of events. `id` is typically an email address or `primary`. Has `summary` (display name), `timeZone`, `accessRole` (owner/writer/reader/freeBusyReader). The primary calendar `id` = the user's Google account email.
- **Event** — a single calendar entry. `id` is the event ID. Has `summary` (title), `description`, `start`/`end` (dateTime or date for all-day), `status` (confirmed/tentative/cancelled), `attendees`, `organizer`, `recurringEventId` (for instances of recurring events), `hangoutLink`/`conferenceData` for meet links.
- **Attendee** — a participant on an event. Has `email`, `displayName`, `responseStatus` (accepted/declined/tentative/needsAction), `organizer` flag, `self` flag (true if it's the authenticated user).
- **FreeBusy** — availability query result. Not an object in the data model — queried via the `freebusy.query` endpoint. Returns a map of calendar ID → list of `{start, end}` busy intervals within a requested window.

**Relationships:**
- Calendar → 0..N Events (one event lives in exactly one calendar)
- Event → 0..N Attendees
- Recurring event series → N Event instances (share `recurringEventId`)

## Common Gotchas

- **`primary` is a magic alias.** Passing `calendarId=primary` always refers to the authenticated user's primary calendar. It resolves to the user's email address — useful when you don't know the ID in advance.
- **All-day events use `date`, not `dateTime`.** All-day events have `start.date: "2026-05-17"` (no time, no tz). Timed events have `start.dateTime: "2026-05-17T10:00:00-07:00"`. Mixing the two formats on read/write will cause type errors.
- **Recurring event instances vs. the series.** A recurring event has one "series" event with an `RRULE`; each occurrence is a separate `instance` sharing `recurringEventId`. `events.list` with `singleEvents=true` expands recurrences to individual instances — needed for free/busy analysis. Without `singleEvents=true`, you get the series event, not instances.
- **Cancelled instances are returned, not removed.** `events.list` includes cancelled instances with `status: cancelled`. Always filter them unless you specifically want deleted instances.
- **Time zone handling.** Events store their time zone in `start.timeZone`. When querying with `timeMin`/`timeMax`, pass RFC3339 timestamps with explicit offsets (e.g., `2026-05-17T00:00:00-07:00`). Naive UTC comparisons will skew results for users in other zones.
- **`freeBusyReader` access role is enough for availability queries.** If all you need is free/busy (not event details), request that minimal scope — it doesn't expose event titles or descriptions.
- **Token refresh.** Google OAuth tokens expire in 1 hour. The claude.ai integration handles refresh transparently; self-hosted servers must implement token refresh or re-authenticate.

## Fallback Without MCP

List upcoming events on the primary calendar:

```sh
curl -G "https://www.googleapis.com/calendar/v3/calendars/primary/events" \
  -H "Authorization: Bearer ${GOOGLE_OAUTH_TOKEN}" \
  --data-urlencode "timeMin=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --data-urlencode "singleEvents=true" \
  --data-urlencode "orderBy=startTime" \
  --data-urlencode "maxResults=50"
```

Query free/busy for a time window:

```sh
curl -X POST "https://www.googleapis.com/calendar/v3/freeBusy" \
  -H "Authorization: Bearer ${GOOGLE_OAUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "timeMin": "2026-05-17T00:00:00Z",
    "timeMax": "2026-05-18T00:00:00Z",
    "items": [{"id": "primary"}]
  }'
```

## References

- Calendar API overview — <https://developers.google.com/calendar/api/guides/overview>
- Events resource — <https://developers.google.com/calendar/api/v3/reference/events>
- FreeBusy query — <https://developers.google.com/calendar/api/v3/reference/freebusy/query>
- OAuth scopes — <https://developers.google.com/calendar/api/auth>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently.
