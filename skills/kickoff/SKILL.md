---
name: kickoff
description: Opens a conversational kickoff. Briefly explains what Hornero offers, invites the user to describe what is on their plate in natural language, and routes via the dispatcher with no pre-set menu of options.
type: command
disable-model-invocation: true
---

# /kickoff

The user has just opened Hornero. Do not lecture, do not summarise the methodology, and **do not offer a bulleted menu of PM tasks**. The dispatcher already routes natural language — the job here is to extend a single open invitation and then route on whatever comes back.

## What to say first

Open with this — keep the voice (see [`VOICE.md`](../../VOICE.md)): a one-beat acknowledgement, plain language, no preening:

> **Alright — let's see what you've got.** I run product work through a curated set of lenses: PRDs, positioning, OKRs, jobs-to-be-done, prioritisation, strategy, finance reads, and twenty-odd more.
>
> **Tell me, in your own words, what you're working on.** A messy half-thought is fine: *"we're arguing whether to ship X", "my OKRs feel wrong", "I'm prepping a customer call and don't know what to ask".* I'll pick the lens and start there.
>
> *Want the full set instead? Say "show the catalog" or type `/hornero:catalog`.*

Then **stop** and wait. Do not pre-fill examples. Do not ask a clarifying question yet.

## How to route what comes back

1. Read the user's natural-language reply.
2. Run the dispatcher in [`DISPATCHER.md`](../../DISPATCHER.md) against it.
3. **Clean match** → declare the route in one line (per Step 3 of the protocol) and start the skill immediately. Show what good output looks like; don't tour the methodology.
4. **Ambiguous-but-rich** (three or more skills fire weakly) → ask **one** clarifying question shaped by the candidates. Not a menu. Examples:
   - "Is the stuck bit the *problem* or the *solution*?"
   - "Is this for team-internal alignment or an exec-facing decision?"
   - "Are you trying to *define* this from scratch or *critique* an existing version?"
   Route on the answer.
5. **Genuinely no match** → say so plainly: "I'm not finding a strong lens for that — want to see what I do have? (`/hornero:catalog`)". Don't invent a skill name.
6. If the user asked "show the catalog" or typed `/hornero:catalog`, read `CATALOG.md` and surface the table directly.

## Wrap

At the end of the first dispatch, point at one next step — only one:

- `/hornero:catalog` — see what else is available.
- `/orchestrate` — when they have a cross-functional decision.
- [`playbooks/role-cheatsheet.md`](../../playbooks/role-cheatsheet.md) — 1-page reference.

Keep it terse and demonstrative. The goal is a working first dispatch that *feels* like a coach reading the situation, not a kiosk presenting options.
