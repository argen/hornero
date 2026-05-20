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
| `provenance` | enum | One of: `documented`, `verbal`, `intuition`, `industry`. The **weakest** source the decision rests on — so a `documented` entry rests entirely on durable evidence, while an `industry` entry leans at least partly on generic field knowledge. Ordered strongest → weakest: documented > verbal > intuition > industry. |
| `type` | enum | One of: `decision`, `hypothesis`. A `decision` entry follows Rumelt's strategy kernel (Diagnosis → Decision → Coherent actions → Alternatives → Validation plan). A `hypothesis` entry is an open assumption under test, with a different body shape (Assumption → Prediction → Falsifier → Evidence Log → Resolution). A hypothesis resolves into a decision entry (or is refuted) as evidence accumulates. |
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

For both types, `## Notes` may be empty. The other five must have a non-empty body. The validator does not deeply parse the prose; it only enforces the section headers exist in the right order for the entry's declared type.

The hypothesis shape is borrowed from the discipline of testable claims: an Assumption without a Falsifier is just an opinion. The Evidence Log is the only section that grows after the entry is committed — see [`skills/chronicle-record/SKILL.md`](../skills/chronicle-record/SKILL.md) for the mutation rules.

## Filename

`chronicle/entries/<id>.md` where `<id>` matches the `id` frontmatter field. A file whose name doesn't match its `id` fails validation.

## Why this shape

- **`id` = date + slug** → entries sort naturally by date; cross-references are stable and human-readable.
- **`status`** → makes "what's still load-bearing?" answerable by a `status: validated` filter.
- **`confidence`** → makes "how much should I trust this?" visible. Decisions made under low confidence get re-examined sooner.
- **`provenance`** → makes "what's this resting on?" visible at a glance. A `validated` entry with `provenance: intuition` is a signal — the team committed, but the source layer is thin and the entry is exposed if a documented finding contradicts it. PM Brain's hierarchy (documented > verbal > intuition > industry) is the reference; Hornero applies it at the entry level rather than per-claim because the entry is the unit the validator can enforce.
- **`evidence` + `supersedes`** → forms a citable DAG; future-you can trace why a posture exists.
- **Body sections** are the Rumelt kernel (Diagnosis → Decision → Coherent actions) plus the validation plan — same shape as the legacy `decision-record` skill, just enforced.

## Worked example

See [`tests/chronicle/fixtures/good/2026-05-12-refuse-smb-segment.md`](../tests/chronicle/fixtures/good/2026-05-12-refuse-smb-segment.md) for a canonical entry.

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
9. `provenance` ∈ legal set
10. `type` ∈ legal set
11. All `evidence` IDs resolve to existing entries
12. All required body sections present, in order — branched on `type`
13. No CRLF, no trailing whitespace on frontmatter lines

Failure modes are reported one per entry with a short diagnostic.
