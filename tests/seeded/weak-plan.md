# Plan — Add `last_active_at` to `user_sessions`

**Owner:** Platform team
**Status:** Ready for review

## What we're doing

Adding a `last_active_at TIMESTAMP NOT NULL` column to the `user_sessions`
table so the activity-feed query stops doing the expensive heartbeat lookup.

## Migration

```sql
ALTER TABLE user_sessions
  ADD COLUMN last_active_at TIMESTAMP NOT NULL DEFAULT NOW();
```

## Application changes

- Update the session-write path to set `last_active_at` on every heartbeat.
- Update the activity-feed query to `SELECT … WHERE last_active_at > $1`
  instead of joining `session_events`.
- Drop the `session_events.heartbeat_at` index (no longer used).

## Rollout

1. Open PR with the migration + code changes.
2. Merge to `main`.
3. CI runs the migration against staging on deploy. Verify the activity-feed
   query is faster.
4. Promote to prod the same day.

## Testing

- Unit tests for the new query.
- Manual: load the activity feed in staging, confirm it renders.
