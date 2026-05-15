# Design — Saved Searches panel

**Owner:** Design team
**Status:** Draft for eng handoff

## What it is

A right-rail panel on the dashboard that lists the user's saved searches. The
user can click a saved search to re-run it, or click the star icon next to a
recent search in the main view to add it to the panel.

## Flow

1. User runs a search from the main search bar.
2. A small star icon appears next to the search result header.
3. User clicks the star. A toast says "Saved." The search appears at the top
   of the right-rail Saved Searches panel.
4. User clicks a saved search in the panel. The main view rerenders with that
   search's results.
5. User can drag-to-reorder the panel entries.

## Visual treatment

- Panel: 280px wide, white background, 1px border in `--border-subtle`.
- Each row: 36px tall, search query in `text-sm`, star icon (filled) on the
  right.
- Hover state: row background shifts to `--surface-hover`.
- Active row (the search currently rendered in the main view): left border in
  `--accent` (4px).

## Interactions

- Click row → re-run search.
- Drag handle on hover → reorder.
- Long-press / right-click → context menu with "Rename" and "Remove."

## Out of scope for v1

- Folders / nesting.
- Sharing saved searches with teammates.
- Cross-device sync (uses local storage for v1).
