# Research — distilled notes per role

Per-role distilled notes from the anchor works in each role's `sources.md`. The goal: a 100-200-line summary per book/article that captures (a) what the work is, (b) why it matters for AI-coding work specifically, (c) the key concepts the role's skills pull from it, and (d) what to actually read if you have an hour.

These notes are **not** a replacement for the source works — they're a working memory for the methodology. If a teammate hasn't read Beck or Fowler, the note tells them what's load-bearing in the role's skills and where to go deep next.

> **Status:** seed shipped (v0.5). Software-engineer has 5 of its 10 anchor notes; the other 6 roles' notes follow the same pattern. The structure is the point at this stage; coverage will grow as skills get used and lessons accumulate.

## Structure

```
research/
  README.md                         # this file
  <role>/
    README.md                       # role's reading order + status
    <author-or-work-slug>.md        # one file per anchor work
```

## Note format

Each note follows this shape:

```markdown
# <Anchor name> — distilled

> One-sentence positioning: what this work *is*.

## Why it matters for AI-coding

<2-4 sentences. The specific reason an AI-coding methodology cites this work.>

## Key concepts the role pulls from

<3-7 named concepts. For each: what the concept is in one line, where it shows up in the role's skills.>

## What to actually read (1-hour budget)

<Specific chapter / essay / section pointers. Not the whole book.>

## What to skip

<If the work has chapters that have aged poorly or are tangential, name them.>

## How this anchors role skills

<List the role's SKILL.md files that draw from this work, with a one-line note per skill.>
```

## How to author a new note

1. Pick an anchor from a role's `sources.md`.
2. Create `research/<role>/<author-or-slug>.md` using the format above.
3. Update `research/<role>/README.md` to mark the note as shipped.
4. Cross-reference the note from the role's `sources.md` (optional but useful).

## What this is NOT

- A book summary service for the methodology's anchor works.
- A replacement for `sources.md` (which is the curated bibliography; notes augment, not replace).
- A place for opinions about the works. Stay descriptive; opinions live in the role's anti-patterns sections if they're load-bearing.

## Per-role status

| Role | Notes shipped | Anchors total |
|---|---|---|
| software-engineer | 5 | 10 |
| product-manager | 0 | 11 |
| designer | 0 | 11 |
| tester | 0 | 10 |
| security-expert | 0 | 10 |
| data-scientist | 0 | 10 |
| marketing-expert | 0 | 10 |

Each role's README links to its shipped notes and lists what's outstanding.
