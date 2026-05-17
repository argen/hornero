---
name: google-drive
description: Google Drive — files, folders, permissions, search. Used by PMs to read PRDs and specs, share documents, and search across team knowledge bases.
type: data-source
status: stable
mcp:
  server: "claude.ai integration (mcp__claude_ai_Google_Drive__)"
  install: "Enable via claude.ai Settings → Integrations → Google Drive (OAuth)"
  auth_env: []
  auth: oauth
  capabilities: [files, folders, search, permissions, export]
object_model: [File, Folder, Permission, Revision]
used_by: []
fallback: curl
---

## Purpose

Google Drive is where team knowledge lives — PRDs, RFCs, specs, spreadsheets, design exports. Hornero skills can search for documents, read their content (including Google Docs/Sheets export), list folder structures, and manage sharing permissions. Primary consumers: PMs (spec retrieval, document organisation), data scientists (data file access, spreadsheet reads), engineers (RFC and ADR lookup).

## MCP Server

**Canonical integration:** `mcp__claude_ai_Google_Drive__` — the native Google Drive integration in claude.ai. Enable it via **Settings → Integrations → Google Drive** and complete the Google OAuth flow.

The integration uses an OAuth handshake (`authenticate` → `complete_authentication`) before the full file and folder tools become available. Run the authenticate tool once per session.

**Capabilities (post-auth):**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `files` | Read, create, update, delete files | (future: document-retrieval) |
| `folders` | List and navigate folder hierarchies | (future: document-retrieval) |
| `search` | Full-text and metadata search across Drive | (future: document-retrieval) |
| `permissions` | Read and manage sharing permissions | (future: permissions-audit) |
| `export` | Download Google Docs/Sheets/Slides as PDF, DOCX, CSV | (future: document-retrieval) |

**Auth:** OAuth via claude.ai. Minimum scope: `https://www.googleapis.com/auth/drive.readonly`. Add `drive.file` (files created by the app) or `drive` (full access) only if skills write files.

### Self-hosted alternative

```sh
# Official MCP org server
claude mcp add gdrive -- npx -y @modelcontextprotocol/server-gdrive
```

Auth: OAuth 2.0 credentials JSON from Google Cloud Console. Follow the server's README for the credentials setup — it handles the OAuth flow on first launch.

## Object Model

- **File** — any Drive item that is not a folder. `id` is the stable resource ID (a 33-char opaque string). `name` is the display name. `mimeType` identifies the type: `application/vnd.google-apps.document` (Docs), `application/vnd.google-apps.spreadsheet` (Sheets), `application/vnd.google-apps.presentation` (Slides), or standard MIME types for uploaded binaries.
- **Folder** — a special file with `mimeType: application/vnd.google-apps.folder`. Folders have the same `id`/`name` structure as files. The root is aliased as `root` or `My Drive`.
- **Permission** — an ACL entry on a file or folder. Has `role` (owner/organiser/fileOrganiser/writer/commenter/reader), `type` (user/group/domain/anyone), and `emailAddress` (for user/group). Inherited from parent folder unless explicitly overridden.
- **Revision** — a saved version of a file. Primarily relevant for Docs/Sheets where auto-save creates revisions. Binary files only have revisions on explicit upload.

**Relationships:**
- File → 1 parent Folder (every file has exactly one parent in Drive's current model; Drive shortcuts can create multi-parent illusions)
- File → 0..N Permissions (inherited + direct)
- File → 0..N Revisions

## Common Gotchas

- **Google Workspace files can't be downloaded directly.** Docs, Sheets, and Slides have no binary content — they must be exported to a format (PDF, DOCX, CSV, etc.) via `files.export`. Passing a Google Workspace MIME type to a regular download endpoint returns a 403.
- **`files.list` doesn't return all fields by default.** The Drive API uses field masks — to get `name`, `mimeType`, `parents`, and `size`, pass `fields=files(id,name,mimeType,parents,size)`. Missing fields in the response mean they weren't requested, not that they're empty.
- **`root` and `My Drive` are aliases, not IDs.** Use `root` as the `parents[]` value or as a `q` filter target (`'root' in parents`). The actual root folder ID is a regular opaque string; `root` is a Drive-maintained alias.
- **Shared drives need `supportsAllDrives=true`.** Files in shared drives (previously "Team Drives") are invisible unless `supportsAllDrives=true` and `includeItemsFromAllDrives=true` are set on list/get calls. Omitting them silently hides shared-drive content.
- **Trash is not deleted.** Files in the trash are returned by `files.list` unless you filter with `trashed=false`. Always add that filter if you don't want trashed files in results.
- **Rate limits: 20,000 requests/100 seconds/user.** Bulk tree traversals of large shared drives will throttle. Cache folder listings and avoid stat-on-every-node patterns.
- **Permissions inheritance is not surfaced by the API.** `permissions.list` on a file only shows permissions directly on that file. Inherited permissions from the folder hierarchy are not returned — you'd have to walk the parent chain to reconstruct the effective ACL.
- **Large file downloads require chunked reads.** Use `alt=media` with a `Range` header for files > 10MB; the full file in one request will time out or hit memory limits.

## Fallback Without MCP

Search for files:

```sh
curl -G "https://www.googleapis.com/drive/v3/files" \
  -H "Authorization: Bearer ${GOOGLE_OAUTH_TOKEN}" \
  --data-urlencode "q=name contains 'PRD' and trashed=false" \
  --data-urlencode "fields=files(id,name,mimeType,modifiedTime)" \
  --data-urlencode "pageSize=50"
```

Export a Google Doc as plain text:

```sh
curl -G "https://www.googleapis.com/drive/v3/files/FILE_ID/export" \
  -H "Authorization: Bearer ${GOOGLE_OAUTH_TOKEN}" \
  --data-urlencode "mimeType=text/plain" \
  -o output.txt
```

List the contents of a specific folder:

```sh
curl -G "https://www.googleapis.com/drive/v3/files" \
  -H "Authorization: Bearer ${GOOGLE_OAUTH_TOKEN}" \
  --data-urlencode "q='FOLDER_ID' in parents and trashed=false" \
  --data-urlencode "fields=files(id,name,mimeType,size)" \
  --data-urlencode "pageSize=100"
```

## References

- Drive API overview — <https://developers.google.com/drive/api/guides/about-sdk>
- Files resource — <https://developers.google.com/drive/api/v3/reference/files>
- Search query syntax — <https://developers.google.com/drive/api/guides/search-files>
- Export MIME types — <https://developers.google.com/drive/api/guides/mime-types>
- OAuth scopes — <https://developers.google.com/drive/api/guides/api-specific-auth>
- MCP server (official MCP org) — <https://github.com/modelcontextprotocol/servers/tree/main/src/gdrive>
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently.
