# Research — distilled notes per role

Per-role distilled notes from the anchor works in each role's `sources.md`. The goal: a 100-200-line summary per book/article that captures (a) what the work is, (b) why it matters for AI-coding work specifically, (c) the key concepts the role's skills pull from it, and (d) what to actually read if you have an hour.

These notes are **not** a replacement for the source works — they're a working memory for the methodology. If a teammate hasn't read Beck or Fowler, the note tells them what's load-bearing in the role's skills and where to go deep next.

> **Status:** v1 coverage shipped (v0.9). All seven roles now have a note for **every anchor** in their `sources.md` main list. The notes range from 35-48 lines each, follow the eight-section format below, and cross-reference each role's actual SKILL.md files (relative-path links). See-also entries in each `sources.md` are not anchored at note-depth — those follow when active work warrants them.

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
| software-engineer | 10 | 10 |
| product-manager | 11 | 11 |
| designer | 11 | 11 |
| tester | 10 | 10 |
| security-expert | 10 | 10 |
| data-scientist | 10 | 10 |
| marketing-expert | 10 | 10 |

Each role's README links to its shipped notes and lists what's outstanding.
