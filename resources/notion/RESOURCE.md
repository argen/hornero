---
name: notion
description: Notion docs and databases — pages, databases, blocks, properties. Used by PMs as a PRD/RFC home — read existing specs, append review notes, query roadmap databases.
type: data-source
status: stretch
mcp:
  server: "@notionhq/notion-mcp-server"
  install: "claude mcp add notion -- npx -y @notionhq/notion-mcp-server"
  auth_env: [NOTION_API_TOKEN]
  capabilities: [pages, databases, blocks, search, query_database, comments]
object_model: [Workspace, Page, Database, Block, Property, User, Comment, File]
used_by: []
fallback: curl
---

## Purpose

Notion is the PRD/RFC/decision-record home for most PM-heavy teams. Hornero skills use it to read existing specs before drafting new ones, append structured review notes back to a page, and query roadmap databases for prioritisation context. Because Notion's object model is recursive (pages contain blocks contain blocks) and access is opt-in per page, skills must be deliberate about fetch depth and scope. No Hornero skills currently depend on it — this resource is scaffolded for future PM skills around PRD drafting, roadmap-database triage, and decision-record persistence.

## MCP Server

**Canonical server:** `@notionhq/notion-mcp-server` — Notion's official npm server. Source at <https://github.com/makenotion/notion-mcp-server>.

**Install:**

```sh
claude mcp add notion -- npx -y @notionhq/notion-mcp-server
```

**Auth:** set `NOTION_API_TOKEN` to a Notion **Internal Integration token**. Tokens begin with `secret_` (legacy) or `ntn_`. Create one at *Settings → My Integrations → New integration* — set it as Internal, not Public.

**Critical setup step:** an integration token has access **only to pages explicitly shared with it**. After creating the integration, visit each top-level page (or database) you want to expose → *…menu → Add connections → select your integration*. Until you do this, the token sees nothing — easily mistaken for an auth failure.

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `search` | Find pages/databases by title | (forward-ref: `prd-review`) |
| `retrieve_page`, `retrieve_database` | Page metadata and DB schema | (forward-ref: `prd-review`) |
| `retrieve_block_children` | Page body (recursive fetch needed) | (forward-ref: `prd-review`) |
| `query_database` | Filtered rows from a roadmap DB | (forward-ref: `roadmap-triage`) |
| `append_block_children` | Write review notes back to a page | (forward-ref: `prd-review`) |
| `retrieve_comments`, `create_comment` | Read/write inline comments | (forward-ref: `prd-review`) |

## Object Model

- **Workspace** — top-level tenant. An integration token is workspace-scoped; it can only see what's been explicitly shared with it within that workspace.
- **Page** — two flavours:
  - *Page-as-child-of-page*: a regular document with a title and free-form body.
  - *Page-as-row-in-database*: every column (Property) is structured; the page body is optional additional content.
- **Database** — a typed collection whose schema is the set of its Properties. Queried via filter DSL; not SQL.
- **Block** — the atom of content. Pages are trees of blocks; a page's ID doubles as its root block ID for child listing. Common types: `paragraph`, `heading_1/2/3`, `bulleted_list_item`, `numbered_list_item`, `to_do`, `toggle`, `code`, `quote`, `callout`, `image`, `divider`, `child_page`, `child_database`, `table`, `table_row`. Blocks can nest; recursive fetch is the common pattern.
- **Property** — a typed column on a Database. Types: `title`, `rich_text`, `number`, `select`, `multi_select`, `date`, `people`, `files`, `checkbox`, `url`, `email`, `phone_number`, `formula`, `relation`, `rollup`, `created_time`, `last_edited_time`, `status`, `unique_id`. Each database has exactly one `title` property.
- **User** — workspace member. Type: `person` or `bot`.
- **Comment** — page-level or block-level. Separate endpoint from blocks.
- **File** — external URL or Notion-hosted. Notion-hosted URLs are short-lived signed URLs (see Gotchas).

**Key relationships:**
- Page → 1 parent (page, database, or workspace), 0..N child Blocks, 0..N Properties (if row)
- Database → 1..N Properties (schema), 0..N Pages (rows)
- Block → 0..1 parent Block or Page, 0..N child Blocks

## Common Gotchas

- **Integration access is opt-in per page.** A fresh token with no shared pages sees nothing. Verify by calling `search` with an empty query — zero results means no pages have been connected yet, not an auth error.
- **Page metadata ≠ page body.** `GET /v1/pages/{id}` returns title, properties, and parent but not the content. Call `GET /v1/blocks/{id}/children` to get body blocks. Nested blocks require recursive calls.
- **Page IDs and Block IDs are identical in shape.** Both are UUIDs; a page's ID is also the root block ID for `block.children` calls.
- **Rich text is a typed array, not a string.** Each segment carries `annotations` (bold, italic, color, link) and a `plain_text` field. Flatten to `plain_text` for text extraction; don't treat the raw array as a string.
- **Database query filter DSL is not SQL.** Uses `{"property": "…", "[type]": {"operator": value}}` shapes. Compound filters nest under `"and"` / `"or"` arrays. Malformed filters return a 400, not empty results.
- **Relation properties return IDs only.** Resolving related rows' content = one extra fetch per row. Design for N+1 before it bites you.
- **Title vs Name property.** The display-name column in any database is a `title`-type property. You can rename it in the UI, but the API still sees it as `type: title`. Each database has exactly one.
- **Pagination:** `next_cursor` + `has_more`. Max `page_size` is 100. Don't assume a single response is complete.
- **Rate limit: ~3 requests/second** (average). Burst allowed; 429 with `Retry-After` on overage. Recursive block fetches on large pages burn quota fast.
- **`Notion-Version` header is required.** Always send `Notion-Version: 2022-06-28` (or the version your integration targets). Omitting it risks unpredictable behaviour as Notion evolves the API.
- **Notion-hosted file URLs expire in ~1 hour.** A signed URL from a block response will 403 the next day. Re-fetch the parent block to get a fresh URL; never cache Notion file URLs long-term.

## Fallback Without MCP

Notion REST API v1 via `curl`. All requests require `Authorization: Bearer ${NOTION_API_TOKEN}` and `Notion-Version: 2022-06-28`.

Read a page's properties (title, status, owner — no body):

```sh
curl "https://api.notion.com/v1/pages/{page_id}" \
  -H "Authorization: Bearer ${NOTION_API_TOKEN}" \
  -H "Notion-Version: 2022-06-28"
```

Read a page's body blocks (first page; follow `next_cursor` for more):

```sh
curl "https://api.notion.com/v1/blocks/{page_id}/children?page_size=100" \
  -H "Authorization: Bearer ${NOTION_API_TOKEN}" \
  -H "Notion-Version: 2022-06-28"
```

Query a database — filter to rows with Status = "In review":

```sh
curl -X POST "https://api.notion.com/v1/databases/{database_id}/query" \
  -H "Authorization: Bearer ${NOTION_API_TOKEN}" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{"filter": {"property": "Status", "select": {"equals": "In review"}}, "page_size": 50}'
```

The fallback path is verbose for deeply nested documents. For PRD review use cases, limit to two depths (page → top-level blocks → first-level children) to bound request count.

## References

- Notion API intro — <https://developers.notion.com/reference/intro>
- Database query endpoint — <https://developers.notion.com/reference/post-database-query>
- Block reference (all block types) — <https://developers.notion.com/reference/block>
- Notion-Version header / versioning — <https://developers.notion.com/reference/versioning>
- Notion MCP server (official) — <https://github.com/makenotion/notion-mcp-server>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. Notion is scaffolded for future PM skills around PRD drafting, roadmap-database triage, and decision-record persistence.
