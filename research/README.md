# Research — distilled notes per role

Per-role distilled notes from the anchor works in each role's `sources.md`. The goal: a 100-200-line summary per book/article that captures (a) what the work is, (b) why it matters for AI-coding work specifically, (c) the key concepts the role's skills pull from it, and (d) what to actually read if you have an hour.

These notes are **not** a replacement for the source works — they're a working memory for the methodology. If a teammate hasn't read Beck or Fowler, the note tells them what's load-bearing in the role's skills and where to go deep next.

> **Status:** seed shipped (v0.6). Software-engineer has 5 of its 10 anchor notes. The other 6 roles now have a *top-priority* anchor note each (Cagan for PM, Norman for designer, Bach/Bolton for tester, Shostack for security, Dunford for marketing, Kohavi for data-scientist) — the same anchor a working teammate would be told to read *first* before adopting the role. The remaining notes per role follow the same pattern when active work warrants them; the structure is the point, coverage compounds.

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
| product-manager | 1 | 11 |
| designer | 1 | 11 |
| tester | 1 | 10 |
| security-expert | 1 | 10 |
| data-scientist | 1 | 10 |
| marketing-expert | 1 | 10 |

Each role's README links to its shipped notes and lists what's outstanding.
