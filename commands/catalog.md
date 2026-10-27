---
description: Show what Hornero ships — roles, cross-role skills, and per-role skills — as a scannable index. Use when the user wants to know what's available without reading the full files.
---

# /catalog

The user wants to see what's in the box.

## What to do

1. **Read [`CATALOG.md`](../CATALOG.md)** — the generated one-liner index of every shipped role and skill.

2. **Present it compactly**, not by dumping the whole file. Group as:
   - **Roles** — one line each, with the trigger phrase (only `product-manager` ships today).
   - **Cross-role process skills** — one line each, as listed in `CATALOG.md` (for example `spec-the-problem`, `harness-check`, `extract-lesson`, `context-reset-check`).
   - **Per-role skills** — group by role; one line per skill.
   - **Slash commands** — `/orchestrate`, `/review`, `/role`, `/kickoff`, `/catalog`, `/extract-lesson`, `/audit`.

3. **End with the invocation hints**:
   - Natural language always works (the dispatcher matches and declares its choice before acting).
   - `/role <name> <task>` for a single role.
   - `/review <target>` for multi-role.
   - `/orchestrate <task>` for PM-led cross-functional work.

If `CATALOG.md` is stale relative to recent changes, mention `./scripts/catalog.sh` regenerates it.
