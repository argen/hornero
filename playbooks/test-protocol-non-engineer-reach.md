# Test protocol — non-engineer reach (≤30 min)

This is the runnable test for the *non-engineer reach* roadmap item: **a designer or marketer reaches productive first use of Hornero within 30 minutes** following the documented onboarding path.

Hand this whole file to a real designer or marketer who has not used Hornero before. Ask them to follow it once, take ~30 minutes, and fill in the **Capture** sections as they go. Then `/extract-lesson` on the result to convert friction into durable improvements.

## Why this exists

Hornero's `roles/`, `skills/`, and `playbooks/` are written by an engineer (and reviewed by AI agents that are themselves trained on engineering corpora). The risk is that the surface looks usable but actually presumes a developer's habits — CLI fluency, git literacy, `commit`/`diff`/`PR` as native vocabulary, and the comfort of treating a code repository as "where my work lives."

This test catches that drift by putting a human in the loop whose work doesn't live in a repo.

## Tester profile

Choose a teammate who is:

- A working **designer** *or* working **marketer** (PMM, growth, content). Pick the one whose role you most want to validate today.
- **Has not** previously used Hornero or read its docs.
- **Has** access to Claude Code or OpenAI Codex (install if needed — that's part of the test).
- Brings **one real artifact** of their own — a screen design, a Figma flow, a positioning draft, a homepage hero, a launch brief — that they would actually want a senior peer to critique.

If you can't find a designer and marketer in the same week, run two separate sessions. The two roles will surface different friction.

## What "pass" means

The test passes if **all three** of the following are true at the 30-minute mark:

1. **Reach.** The tester ran at least one real dispatch on their own artifact.
2. **Recognition.** The output the tester got back felt like a senior peer in their role — they could point to a specific finding that they would *take to a meeting*, not just polite AI-generated prose.
3. **Continuation.** The tester knows what they would do next time without having to re-read everything.

A 30-minute walk-and-stall — install completes, methodology gets read, no real dispatch happens — is a **fail**, even if everything technically works.

## Setup (tester does this, ~10 min)

1. Open this repo on your machine and find [`playbooks/non-engineer-quickstart.md`](non-engineer-quickstart.md) — that's the primary path you're testing.
2. Start a timer for 30 minutes.
3. Follow `non-engineer-quickstart.md` top to bottom.
4. If you get stuck at any point, capture the friction in the **Capture** sections below, then either work through it or skip ahead — don't ask for help mid-test (it invalidates the signal).

## Capture (tester fills in as they go)

### Capture 1 — Front-door (first 5 minutes)

**What you read first:** (README? non-engineer-quickstart? something else?)

**What you understood Hornero is, in one sentence (your own words):**

**Anything that felt confusing, foreign, or off-putting in the first 5 minutes:** (exact words from the docs that bounced you, if you can quote them)

### Capture 2 — Setup (Terminal + clone + claude/codex)

**Did the setup work? Y/N**

**What broke or felt wrong:** (be specific — exact error, exact wrong assumption, anything that needed Googling)

**Time to a working session prompt (`>`):** ___ minutes

### Capture 3 — Your first dispatch

**Artifact you brought:** (1-line description — "homepage hero for our pricing page", "checkout-flow screenshot", etc.)

**Prompt you typed:** (verbatim, including any role / skill / slash command you used)

**Time to first useful output:** ___ minutes

**Output quality — was the response:** (circle one)
- (a) Felt like a senior peer in my role. I'd cite at least one finding in a meeting.
- (b) Reasonable but generic. Could have come from any AI tool.
- (c) Off-target or unhelpful.

**Best single finding the output produced:** (paste or paraphrase)

**Worst single finding the output produced:** (paste or paraphrase)

### Capture 4 — Continuation

**If you were going to come back tomorrow, what would you do first?** (don't re-check the docs — answer from memory)

**What would make you actually come back tomorrow vs not?** (this is the question that matters most — be honest)

**Vocabulary that bounced you** (terms you read in the docs that you would not use yourself, or that took effort to translate): list them.

## Self-scoring (tester fills in at the 30-minute mark)

| Criterion | Score (1-5) |
|---|---|
| Reach: I actually ran a real dispatch on my own artifact | |
| Recognition: the output read like a senior peer in my role | |
| Continuation: I know what to do tomorrow without re-reading | |
| Front-door clarity: the docs spoke to me, not around me | |
| Vocabulary fit: nothing made me feel like a tourist in someone else's tool | |

## What to do with the results

The repo owner runs `/extract-lesson` on the tester's filled-in form. The extracted findings should produce durable deltas in one of three places:

1. **`playbooks/non-engineer-quickstart.md`** — fix the front-door
2. **`.claude/commands/kickoff.md`** — if the guided first dispatch under-served the tester
3. **`roles/<role>/ROLE.md` or `skills/<skill>/SKILL.md`** — if the output felt generic, the skill itself needs tightening

A **pass** result graduates the roadmap item from `[ ]` to `[x]`. A **fail** result becomes the next batch of work — the tester's friction is now the directive.

## Calibration: how engineers should perform on this same test

If you run the same test on an engineer for calibration, expect a ~10-minute setup + ~5-minute dispatch + ~5-minute methodology skim. Engineers tend to score 4-5 on all five criteria. The interesting signal is the **delta** between an engineer's run and a designer/marketer's run, not the absolute number.
