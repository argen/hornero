# DISPATCHER.md — Hornero

> Host-agnostic dispatcher protocol. Loaded on demand by [`CLAUDE.md`](CLAUDE.md)
> (Claude Code) and [`AGENTS.md`](AGENTS.md) (Codex). **Edit here.** The host
> files are thin shims — they should never duplicate the content of this file.

Hornero ships **one role today** (`product-manager`) plus six cross-role
skills. The dispatcher protocol below is the design target — it was authored
when seven roles shipped and is retained verbatim so that re-expansion (more
roles back under `roles/`, more reviewers back under `agents/`) is a
content-only change, not a protocol rewrite.

Until then, every multi-match / parallel-fan-out path degrades gracefully:
the only role available is PM, so steps 2–5 below resolve to "use
product-manager + the matching PM skill". Users should not need to memorise
which one to invoke. When a prompt arrives, run the dispatcher.

## The dispatcher protocol

### 0. Chronicle preamble (cold-start situational awareness)

If `chronicle/SUMMARY.md` exists in the working repo, read it once at the
top of the first dispatch in a session. It is auto-regenerated and kept short
on purpose — a digest of the project's committed decisions, newest first.
This is cheap situational awareness: knowing what postures bind, what's been
refuted, and what's superseded, before any specific work begins.

For scoped recall during the work, invoke
[`chronicle-recall`](skills/chronicle-recall/SKILL.md) — the read-side skill
that queries `chronicle/entries/` with deterministic filters. Reviewer
subagents should run a Chronicle scan as the first step of every review.

If `chronicle/` does not exist, skip the preamble. (Legacy projects may have
a looser `memory/decisions/` directory consumed by [`memory-query`](skills/memory-query/SKILL.md) —
honour that too; the two layers can coexist.)

### 1. Scan the catalog first

Read [`CATALOG.md`](CATALOG.md) at the repo root. It is a one-line-per-entry
index of every shipped role and skill. Do not load full ROLE.md or SKILL.md
files at this step — the catalog is designed so you don't have to.

### 2. Match the prompt against the catalog

In rough order of authority:

- **Slash commands win** if the user typed one. Commands are defined in
  [`.claude/commands/`](.claude/commands/) — read the matching file and follow
  it. (The same files are the source of truth for Codex; if your Codex install
  loads commands from a different directory, mirror them there or invoke them
  by reading the file content directly.)
- **Explicit naming wins.** If the user names a role ("as the security
  expert…") or a skill ("draft an ADR for…", "run the design-review skill"),
  use it. No further matching.
- **Verb + artifact shape.** "Review X" → reviewer mode of the role whose
  artifacts include X. "Produce / draft / write X" → producer mode + the
  component skill that makes X. "Audit before launch" → the relevant
  `pre-launch-*` workflow skill.
- **Triggers in `ROLE.md`** and **`scenarios:` in `SKILL.md` frontmatter**
  describe real invocation contexts. Match against those, not against your
  prior intuitions about role boundaries.

### 3. Declare the choice in one line

Before reading the full files or doing the work, state which role and skill
you are adopting, and why — in a single line:

```
Adopting `product-manager` / `prd` — prompt asks for a problem-driven spec
of a feature change, so a PRD is the artifact.
```

This is the user's correction point. They can redirect with one word
("designer instead", "skip the role thing"). Honour it without argument.

### 4. Then load the full files

Only after the declaration:

- `roles/<role>/ROLE.md` — for mindset, heuristics, anti-patterns.
- `roles/<role>/skills/<skill>/SKILL.md` — for the actual procedure.
- `roles/<role>/sources.md` — only if you need a citation or to defend a
  framework choice.

Never load every skill up front. The catalog exists so you don't have to.

### 5. Multi-match → escalate, don't guess

If two or more roles' triggers fire strongly on the same prompt (e.g. "review
this payments PR" → engineer + tester + security; "plan the launch" → PM +
marketing + designer), do not pick one and silently drop the others.

- If the integrating thread is a **customer job / product decision**, route to
  [`/orchestrate`](.claude/commands/orchestrate.md) — the PM as
  cross-functional orchestrator.
- Otherwise, the dispatcher would route to direct multi-role-review without
  PM framing. **That path is dormant** while Hornero ships PM-only — the
  `/review` command and the `multi-role-review` skill have been retired
  pending re-expansion. Use `/orchestrate` instead and let the PM run the
  available role (itself); re-expansion will restore the non-PM-framed path.

In either path, fan reviewer subagents out in parallel and synthesise their
findings yourself. **How** you spawn them is host-specific — see your host's
session-start file ([`CLAUDE.md`](CLAUDE.md) for the Agent tool,
[`AGENTS.md`](AGENTS.md) for the `codex exec` script). With only one role
shipped today the fan-out degenerates to a single PM reviewer; the structure
of the call site is preserved for re-expansion.

**Reviewer subagents are read-only by construction.** They explore, critique,
and report — they do not edit, commit, or run destructive tools. The
orchestrator (the turn doing the synthesis) is the writer. Keep the split
clean: parallel read-only exploration fans out wide for context; the single
write-mode turn that follows acts on the synthesis. Mixing exploration and
editing in the same context window pollutes both — review fidelity drops, and
the editing turn drifts into re-exploring instead of acting.

### 6. No-match → ask, don't fabricate

If nothing in the catalog matches well, say so:

```
The catalog doesn't have a strong match for this. Closest are `<a>` and
`<b>`. Want me to use one of those, or just answer directly?
```

Do not invent a role or skill name that isn't in `CATALOG.md`. Do not pretend
a forward-reference skill (one named in `ROLE.md` but not yet shipped) is
available.

## When the dispatcher does NOT apply

- The user is editing a specific file and wants direct help, not structured
  critique. Default to a plain answer. Mention "we have a `<skill>` skill if
  you want the structured pass" only if it genuinely matches.
- The user explicitly disables dispatch ("just answer", "don't adopt a role",
  "skip the methodology"). Honour it for the rest of the session unless they
  re-enable.
- Trivial edits (typos, renames, formatting) — no role adoption needed.

## Loading hierarchy (cheat sheet)

| File | Always loaded? | When |
|---|---|---|
| Host session-start file (`CLAUDE.md` or `AGENTS.md`) | Yes | Session start |
| `DISPATCHER.md` (this file) | Yes | First dispatch in a session |
| `chronicle/SUMMARY.md` | Yes (if present) | First dispatch in a session — cold-start situational awareness |
| `CATALOG.md` | Yes | First dispatch scan per prompt |
| `.claude/commands/<name>.md` | No | When the user types `/<name>` |
| `roles/<role>/ROLE.md` | No | After role is chosen |
| `roles/<role>/skills/<skill>/SKILL.md` | No | After skill is chosen |
| `roles/<role>/sources.md` | No | Only if a citation is needed |
| `chronicle/entries/<id>.md` | No | Loaded on demand by `chronicle-recall` / explicit dereference |
| `methodology.md` | No | Only if the user asks about Hornero itself |
| `CONTRIBUTING.md` | No | Only if you're editing roles/skills/catalog |
