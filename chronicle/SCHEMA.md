# Chronicle entry schema

Every file in `chronicle/entries/<id>.md` MUST start with YAML frontmatter conforming to this schema. The validator (`scripts/chronicle.sh validate`) is strict — extra fields are rejected, missing required fields fail the entry.

## Required fields

| Field | Type | Constraint |
|---|---|---|
| `id` | string | `<YYYY-MM-DD>-<kebab-slug>`. Must match the filename (sans `.md`). |
| `title` | string | One line, ≤ 120 chars. Human-readable; used as the SUMMARY anchor. |
| `date` | string | ISO 8601 date (`YYYY-MM-DD`). Must equal the date in `id`. |
| `status` | enum | One of: `validated`, `open`, `superseded`, `refuted`. |
| `confidence` | number | `0.0`–`1.0` inclusive. Two decimals. |
| `source_role` | enum | One of the live roles. Today: `product-manager`, plus the literal `cross-role` when a multi-role review produced the decision. (Re-expansion adds: `software-engineer`, `designer`, `tester`, `security-expert`, `marketing-expert`, `data-scientist`.) |
| `sourcing` | enum | One of: `documented`, `verbal`, `intuition`, `industry`. The **weakest** source the decision rests on — so a `documented` entry rests entirely on durable evidence, while an `industry` entry leans at least partly on generic field knowledge. Ordered strongest → weakest: documented > verbal > intuition > industry. |
| `type` | enum | One of: `decision`, `hypothesis`, `stakeholder`, `customer`. A `decision` entry follows Rumelt's strategy kernel. A `hypothesis` entry is an open assumption under test (Assumption → Prediction → Falsifier → Evidence Log → Resolution). A `stakeholder` entry is a per-person profile (Role & influence → Open asks → Concerns → Last contact → Decision affinity). A `customer` entry is a per-B2B-account profile (Account profile → Usage shape → Health signals → Decision drivers → Stakeholders). A hypothesis resolves into a decision entry (or is refuted) as evidence accumulates; stakeholder and customer entries track one person/account over time and are updated by supersedes when the profile materially changes. |
| `scope` | string list | 1–6 short tags. Free-form, but consistent within a project. Examples: `strategy`, `pricing`, `positioning`, `success-metrics`, `migrations`, `auth`. |
| `affected_areas` | string list | 1+ paths or domains the decision binds. Globs allowed. |
| `decision` | string | One sentence stating what was chosen. Must appear in the body too; this field is the index-friendly copy. |

## Optional fields

| Field | Type | Notes |
|---|---|---|
| `alternatives_considered` | string list | Options that were rejected. |
| `rejected_reason` | string list | One reason per alternative, or a single summary string. |
| `evidence` | string list | IDs of other Chronicle entries cited as support. Validator checks every ID resolves. |
| `supersedes` | string | ID of an entry this one replaces. Validator checks the target exists and flips its `status` to `superseded` on commit. |
| `superseded_by` | string | Set by the validator on commit; do not author by hand. |
| `review_after` | string | ISO date when the decision should be re-examined regardless of outcome. |
| `session_id` | string | Optional grouping tag (e.g. a multi-role review session). |

## Body sections

The Markdown body MUST contain six `##` headers, in fixed order. The shape depends on `type`:

**`type: decision`** — Rumelt's strategy kernel + a validation plan:

```
## Diagnosis
## Decision
## Coherent actions
## Alternatives rejected
## Validation plan
## Notes
```

**`type: hypothesis`** — assumption under test:

```
## Assumption
## Prediction
## Falsifier
## Evidence Log
## Resolution
## Notes
```

**`type: stakeholder`** — one person the team coordinates with:

```
## Role & influence
## Open asks
## Concerns
## Last contact
## Decision affinity
## Notes
```

**`type: customer`** — one B2B account (the company, not an individual):

```
## Account profile
## Usage shape
## Health signals
## Decision drivers
## Stakeholders
## Notes
```

For all four types, `## Notes` may be empty. The other five must have a non-empty body. The validator does not deeply parse the prose; it only enforces the section headers exist in the right order for the entry's declared type.

The hypothesis shape is borrowed from the discipline of testable claims: an Assumption without a Falsifier is just an opinion. The stakeholder shape is borrowed from CRM practice: one record per person, asks and concerns appended over time, last-contact tracked so atrophy is visible. The customer shape is the account-level sibling of stakeholder, scoped to B2B startups where the company is the unit of revenue: profile, usage, health, and the stakeholders inside it are first-class fields.

The Evidence Log (for hypotheses), Open asks + Last contact (for stakeholders), and Usage shape + Health signals (for customers) are the sections that grow after the entry is committed — see the **Append exception** below.

## Append exception

Committed entries are immutable except via supersedes — with one structural carve-out. A handful of body sections grow row-by-row (evidence accumulating on a hypothesis, asks arriving on a stakeholder, health signals piling up on a customer). Forcing supersedes for each new row would churn the chronicle and dissolve the audit trail.

The exception is the `chronicle.sh append` subcommand. It accepts an entry id, a section name, and a content string; writes `- YYYY-MM-DD — <content>` into the named section; and re-runs the validator against the modified entry. If the validator fails, the entry is restored from backup and the append errors out.

The whitelist is per `type`:

| Type | Appendable sections | Immutable sections (supersedes-only) |
|---|---|---|
| `decision` | _(none — decisions only change via supersedes)_ | All six |
| `hypothesis` | Evidence Log | Assumption, Prediction, Falsifier, Resolution, Notes |
| `stakeholder` | Open asks, Concerns, Last contact, Decision affinity | Role & influence, Notes |
| `customer` | Usage shape, Health signals, Decision drivers, Stakeholders | Account profile, Notes |

Row shape is `- YYYY-MM-DD — <content>` so each appended row carries its own provenance date. `Last contact` is the sole **prepend** section — newest first — so the cold-read shows the most recent touch at the top and the weekly `/review` staleness check finds the freshest date on its first match. All other appendable sections grow chronologically (oldest at top, newest at bottom).

Sections outside the whitelist — Diagnosis, Falsifier, Account profile, Role & influence, etc. — remain immutable. A change to those is a material change to the entry's character, which is what supersedes is for.

The skills that drive this exception are [`hypothesis-track`](../skills/hypothesis-track/SKILL.md), [`stakeholder-update`](../skills/stakeholder-update/SKILL.md), and [`customer-update`](../skills/customer-update/SKILL.md). Each is a thin wrapper that prompts for the row content, calls `chronicle.sh append`, and surfaces "this trigger crossed a threshold — open a new hypothesis / propose a decision via supersedes" when the appended row implies a deeper change.

## Filename

`chronicle/entries/<id>.md` where `<id>` matches the `id` frontmatter field. A file whose name doesn't match its `id` fails validation.

## Why this shape

- **`id` = date + slug** → entries sort naturally by date; cross-references are stable and human-readable.
- **`status`** → makes "what's still load-bearing?" answerable by a `status: validated` filter.
- **`confidence`** → makes "how much should I trust this?" visible. Decisions made under low confidence get re-examined sooner.
- **`sourcing`** → makes "what's this resting on?" visible at a glance. A `validated` entry with `sourcing: intuition` is a signal — the team committed, but the source layer is thin and the entry is exposed if a documented finding contradicts it. PM Brain's hierarchy (documented > verbal > intuition > industry) is the reference; Hornero applies it at the entry level rather than per-claim because the entry is the unit the validator can enforce.
- **`evidence` + `supersedes`** → forms a citable DAG; future-you can trace why a posture exists.
- **Body sections** are the Rumelt kernel (Diagnosis → Decision → Coherent actions) plus the validation plan — same shape as the legacy `decision-record` skill, just enforced.

## Worked example

See [`tests/chronicle/fixtures/good/2026-05-15-refuse-smb-segment-for-fy26.md`](../tests/chronicle/fixtures/good/2026-05-15-refuse-smb-segment-for-fy26.md) for a canonical entry.

## Validator reference

The validator is implemented in `scripts/chronicle.sh validate`. It enforces:

1. Frontmatter starts with `---` on line 1
2. All required fields present
3. No unknown fields
4. `id` matches filename
5. `date` matches the date in `id`
6. `status` ∈ legal set
7. `confidence` ∈ [0, 1]
8. `source_role` ∈ legal set
9. `sourcing` ∈ legal set
10. `type` ∈ legal set
11. All `evidence` IDs resolve to existing entries
12. All required body sections present, in order — branched on `type`
13. No CRLF, no trailing whitespace on frontmatter lines

Failure modes are reported one per entry with a short diagnostic.
