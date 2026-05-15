---
name: hubspot
description: HubSpot's CRM — Contacts, Companies, Deals, Tickets, Pipelines, Marketing Hub. Used by PMs to read pipeline signal, customer accounts, and renewal/churn risk.
type: data-source
status: stretch
mcp:
  server: "hubspot-mcp-server"
  install: "claude mcp add hubspot -- npx -y @hubspot/mcp-server"
  auth_env: [HUBSPOT_ACCESS_TOKEN]
  capabilities: [contacts, companies, deals, tickets, engagements, properties, search]
object_model: [Contact, Company, Deal, Ticket, Pipeline, Stage, Property, Owner, Engagement, List, Workflow]
used_by: []
fallback: curl
---

## Purpose

HubSpot is the CRM most GTM-facing teams run day-to-day: sales uses Deals and Pipelines, support uses Tickets, marketing uses Contacts and Lists. For Hornero, the primary consumer is the PM role — reading pipeline health, renewal/churn risk, customer account state, and engagement history without leaving the agent session. Skills use the CRM Search API as the core query primitive; the Properties API to resolve custom field names; and Engagements to surface recent customer activity tied to an account or deal.

## MCP Server

**Canonical server:** HubSpot launched an official MCP server in 2025 — `hubspot-mcp-server` at <https://github.com/hubspot/hubspot-mcp-server>. Prefer the official server; fall back to community npm packages only if unavailable in your install path.

**Install (official, recommended):**

```sh
# Check https://github.com/hubspot/hubspot-mcp-server for the current binary or npx form:
claude mcp add hubspot -- npx -y @hubspot/mcp-server
```

**Auth:** set `HUBSPOT_ACCESS_TOKEN` to a **Private App access token** (begins with `pat-`). Generate at *Settings → Integrations → Private Apps* — create a new app, grant the required CRM scopes, copy the token. API keys (`hapikey`) are fully deprecated; ignore any guide that shows them.

**Minimum scopes for read-only CRM work:**
- `crm.objects.contacts.read`
- `crm.objects.companies.read`
- `crm.objects.deals.read`
- `crm.objects.tickets.read`
- `crm.schemas.contacts.read` (for Properties API)

Add `*.write` scopes only if a skill creates or updates records.

**Capabilities exposed:**

| Capability | Purpose | Hornero skills |
|---|---|---|
| `search_contacts`, `get_contact` | Customer lookup, churn triage | (forward-ref: `hubspot-pipeline-signal`) |
| `search_companies`, `get_company` | Account health | (forward-ref) |
| `search_deals`, `get_deal` | Pipeline snapshot, renewal dates | (forward-ref) |
| `search_tickets`, `get_ticket` | Support volume per account | (forward-ref) |
| `list_properties` | Resolve custom property names | (forward-ref) |
| `get_engagements` | Recent notes, calls, emails on a record | (forward-ref) |

## Object Model

- **Contact** — person record. HubSpot assigns a numeric `vid` (record ID); email is the natural external ID. Default properties: `firstname`, `lastname`, `email`, `lifecyclestage`, `hs_lead_status`, `hubspot_owner_id`. Custom props must be looked up via the Properties API.
- **Company** — account/org. Domain is the natural external ID (`domain` property). Associated to Contacts and Deals via the Associations API.
- **Deal** — revenue opportunity. Key fields: `dealname`, `amount`, `closedate`, `dealstage`, `pipeline`, `hubspot_owner_id`. Associated to Contacts, Companies, Tickets.
- **Ticket** — support case. Has its own pipeline + stage (mirrors the Deal model). Associated to Contacts and Companies.
- **Pipeline** — deal pipeline or ticket pipeline. Each pipeline has an ID and an ordered list of Stages. Multiple pipelines can coexist (e.g. New Business vs. Renewal).
- **Stage** — pipeline-scoped. The stage ID is an internal string (`closedwon`, or a per-pipeline guid); the display label is separate and can be renamed. Always resolve by ID.
- **Property** — every CRM object has default and custom properties. Custom property internal names use `snake_case` and must be fetched via `GET /crm/v3/properties/{objectType}`. Never assume a prop name; look it up.
- **Owner** — a HubSpot user. Has a numeric `ownerId` (not the same as their email). `GET /crm/v3/owners` lists all.
- **Engagement** — Note, Email, Call, Meeting, or Task. Linked to records via associations. Fetched via `GET /crm/v3/objects/engagements` or the v1 Engagements endpoint (still in use for some event types).
- **List** — static or dynamic (active) contact list. Lists don't appear in the CRM Search API; use `GET /contacts/v1/lists`.
- **Workflow** — automation. Not directly addressable via REST for structure; you can read a contact's workflow enrollment via `GET /automation/v4/enrollments`.

**Relationships that matter:**

- Contact ↔ Company (many-to-many, via Associations)
- Contact ↔ Deal (many-to-many, via Associations)
- Company ↔ Deal (many-to-many, via Associations)
- Deal → 1 Pipeline → N Stages
- Ticket → 1 Pipeline (separate from Deal pipelines)
- Engagement → 0..N Contacts, Companies, Deals (via Associations)

## Common Gotchas

- **API key auth is deprecated.** New integrations must use private-app tokens. Many old tutorials show `?hapikey=` — ignore them entirely.
- **Properties: default vs. custom.** Default props (`firstname`, `email`, `amount`) have stable internal names. Custom props have names you must fetch from the Properties API before querying. Never hard-code a custom prop name without first checking it exists in the target portal.
- **Object IDs are numeric; Contact's natural key is email.** Use CRM Search to find a contact by email — don't try to list-and-filter; it won't paginate correctly for large portals.
- **Pagination is `after`-cursor, not offset.** Max page size is 100 for most endpoints. The v3 API differs structurally from v1; v1 examples don't port cleanly.
- **Associations are a separate round-trip.** Getting a Deal's associated Contacts requires a call to `GET /crm/v3/associations/deals/contacts/batch/read` (or the associations endpoint). A naive loop is N+1 calls — use the batch read endpoints.
- **Rate limits: 100 requests per 10 seconds** per private app on the standard tier (Starter/Professional). The 429 response includes `Retry-After`; implement exponential backoff. Enterprise portals get higher limits but the MCP server won't surface quota state.
- **Deal stage IDs are pipeline-scoped.** `closedwon` is a default stage ID; custom pipelines use generated IDs like `7834521`. "Closed Won" (display name) can be renamed by any admin — always use the ID.
- **Lifecycle stage is a Contact property**, not a separate object. Value is one of `subscriber`, `lead`, `marketingqualifiedlead`, `salesqualifiedlead`, `opportunity`, `customer`, `evangelist`, `other`.
- **Marketing email events live in a separate Events API** (`/marketing/v3/events`), not in CRM Search. Don't expect email open/click data from a CRM Search query.
- **CRM Search is the right query primitive.** For any non-trivial filter or sort, use `POST /crm/v3/objects/{objectType}/search` with `filterGroups`. The GET list endpoints are unfiltered and useless at scale.

## Fallback Without MCP

HubSpot REST API v3 via `curl`. The base URL is `https://api.hubapi.com`. Auth is always `Authorization: Bearer ${HUBSPOT_ACCESS_TOKEN}`.

**Search a Contact by email:**

```sh
curl -X POST https://api.hubapi.com/crm/v3/objects/contacts/search \
  -H "Authorization: Bearer ${HUBSPOT_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "filterGroups": [{
      "filters": [{
        "propertyName": "email",
        "operator": "EQ",
        "value": "jane@example.com"
      }]
    }],
    "properties": ["firstname", "lastname", "email", "lifecyclestage", "hubspot_owner_id"]
  }'
```

**List open Deals in a pipeline, sorted by close date:**

```sh
curl -X POST https://api.hubapi.com/crm/v3/objects/deals/search \
  -H "Authorization: Bearer ${HUBSPOT_ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "filterGroups": [{
      "filters": [
        {"propertyName": "pipeline", "operator": "EQ", "value": "default"},
        {"propertyName": "dealstage", "operator": "NEQ", "value": "closedwon"},
        {"propertyName": "dealstage", "operator": "NEQ", "value": "closedlost"}
      ]
    }],
    "sorts": [{"propertyName": "closedate", "direction": "ASCENDING"}],
    "properties": ["dealname", "amount", "closedate", "dealstage", "hubspot_owner_id"],
    "limit": 50
  }'
```

**Resolve all custom Contact properties for a portal:**

```sh
curl https://api.hubapi.com/crm/v3/properties/contacts \
  -H "Authorization: Bearer ${HUBSPOT_ACCESS_TOKEN}" | jq '[.results[] | {name, label, type}]'
```

Paginate using the `after` cursor in the `paging.next` response field. Max page size is 100; loop until `paging.next` is absent.

## References

- HubSpot API overview — <https://developers.hubspot.com/docs/api/overview>
- CRM Search API — <https://developers.hubspot.com/docs/api/crm/search>
- Private Apps auth — <https://developers.hubspot.com/docs/api/private-apps>
- Properties API — <https://developers.hubspot.com/docs/api/crm/properties>
- Associations API — <https://developers.hubspot.com/docs/api/crm/associations>
- HubSpot MCP server (official) — <https://github.com/hubspot/hubspot-mcp-server> (verify availability; if unavailable, start from <https://developers.hubspot.com/>)
- MCP spec — <https://modelcontextprotocol.io>
- Related Hornero skills: none currently. HubSpot is scaffolded for future PM skills around customer signal triage and revenue-architecture validation.
