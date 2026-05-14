# Non-engineer Quick Start

You don't need to be a developer to use Hornero. This guide gets a designer, PM, marketer, or data scientist to their **first useful dispatch in under 30 minutes** — no git or build tooling required after the initial install.

If you already use a terminal daily, you might be better served by [`onboarding.md`](onboarding.md). This file is for the case where the terminal isn't where you live.

## What Hornero is, in one sentence

A library of role personas (designer, PM, marketer, security, tester, data scientist, engineer), each grounded in canonical experts, that you can invoke from inside Claude Code or OpenAI Codex to critique your work or help you produce a high-quality artifact.

You get back something that reads like a senior partner in that role, not like generic AI prose.

## What to bring on Day 1

Pick **one** artifact you actually have in hand right now. The dispatch works best when there's a real thing to look at.

| Your role | One-line artifact to bring |
|---|---|
| **Designer** | A screenshot of a screen or flow, a Figma share link, a list of the states a flow needs to support, or a microcopy draft |
| **PM** | A PRD draft (any format), a problem statement, a draft OKR set, or a roadmap slide |
| **Marketer** | Your current homepage hero, a draft positioning statement, a launch brief outline, or a strategic-narrative slide |
| **Data scientist** | A draft A/B test brief, a metric definition you're auditing, or a causal claim someone made in a meeting |
| **Tester** | A bug report, a feature about to ship, or a test plan draft |
| **Security** | A new auth/data-flow design, a third-party integration about to ship, or an LLM-touching feature |

You don't need a polished artifact. A first draft is better — that's what the reviewer mode is for.

## One-time setup (~10 min, mostly waiting)

Ask an engineer on your team to do this for you if it's faster, or follow the steps:

1. Install [Claude Code](https://claude.com/claude-code) or [OpenAI Codex](https://github.com/openai/codex). Both walk you through sign-in.
2. Open a Terminal app (macOS: Spotlight → "Terminal"; Windows: Win+R → "wt"; or use the built-in terminal in VS Code).
3. Clone Hornero — paste this and press enter:
   ```
   git clone https://github.com/<your-org>/hornero.git
   cd hornero
   ```
4. Start your AI tool from inside that directory:
   ```
   claude        # for Claude Code
   codex         # for OpenAI Codex
   ```

That's the entire setup. You will not need to run another terminal command to use Hornero after this.

## Your first dispatch (5 min)

Inside the session, type:

```
/kickoff
```

The agent will ask one short question, then walk you through a single real dispatch on your artifact. It will pick the right role and skill, **declare its choice in one line** before starting, and produce a real output you can use.

If you prefer to skip the guided walkthrough, dispatch directly. Pick the recipe for your role:

### Designer

```
/role designer Run a heuristic review on this screen. Here it is: <paste screenshot, Figma URL, or written state list>
```

Or, for accessibility:

```
/role designer Audit this surface for WCAG 2.2 — focus on contrast, focus order, and announcement: <artifact>
```

What you'll get back: severity-ranked findings citing Nielsen's heuristics, with concrete remediation suggestions. Not a checklist — a senior-designer voice that flags the two or three things that actually matter.

### PM

```
/role product-manager Critique this PRD draft — is the problem statement load-bearing, are the success metrics measurable, and what's the riskiest assumption: <artifact>
```

Or, when there's a launch question:

```
/orchestrate Plan the <product> launch — is it ready?
```

The first invokes a single PM lens. The second has the PM frame the question as a cross-functional customer job, dispatch the right role mix (designer + marketing + tester + data-scientist as needed), and synthesise into a decision recommendation. Use `/orchestrate` when the answer needs more than one expert lens.

### Marketer

```
/role marketing-expert Critique my homepage hero — is the positioning sharp or generic? Audience: <who>. Alternative: <what they use today>. Hero: <paste>
```

Or, for a draft positioning:

```
/role marketing-expert Review this positioning canvas draft — flag anything generic, anything not evidenced, and anything that conflates audience with category: <artifact>
```

> **A note on positioning evidence.** The `positioning-canvas` skill normally expects 15-30 customer interviews and sales-call recordings as input. You can absolutely invoke its **reviewer mode** on a draft canvas without that evidence base — the reviewer will tell you what's strong, what's generic, and what's missing. Don't let the producer-mode prerequisites stop you from using the skill to critique a draft.

### Data scientist

```
/role data-scientist Audit this experiment design — is the OEC right, are the guardrails sufficient, and is the MDE / sample-size plausible: <artifact>
```

Or, for a metric:

```
/role data-scientist Critique this metric definition — gaming surface, counter-metric, unit of analysis, and ownership: <artifact>
```

### Tester or security expert

Same shape — `/role tester …` or `/role security-expert …` with your artifact. See the [`role-cheatsheet.md`](role-cheatsheet.md) for the watch-fors.

## What good output looks like

The dispatch should land within ~60-180 seconds for a single role, longer for `/orchestrate`. Look for:

- **A one-line declaration** at the start — `Adopting designer / heuristic-review — surface is a checkout flow; broad pass first, then drill in.`
- **Findings cite sources** — Nielsen's heuristic numbers, OWASP refs, Christensen's JTBD framing, Dunford's positioning components, etc. Generic AI prose without anchored sources is a smell.
- **Severity-ranked, not flat lists** — the role distinguishes high-impact issues from minor polish.
- **Concrete remediation, not vague advice** — "move the promo-code field above the totals" beats "improve the layout."
- **Out-of-scope items named explicitly** — a designer should say "consult security on token handling" rather than improvising security advice.

If the output feels generic, the prompt was probably under-briefed. Add the artifact directly into the prompt, name the audience, name the constraint.

## What to do at the end of the session

```
/extract-lesson
```

This is the habit that compounds. It scans the conversation for surprises, things you corrected the agent on, things that worked unexpectedly well, and proposes durable updates to your project's `CLAUDE.md` / `AGENTS.md`. Run it at least weekly.

## When you're ready to go deeper

- [`onboarding.md`](onboarding.md) — the full 30-min walkthrough (engineer-shaped but works for anyone)
- [`role-cheatsheet.md`](role-cheatsheet.md) — what each role watches for, and what each one stays out of
- [`orchestration-heuristics.md`](orchestration-heuristics.md) — when to invoke 1 vs 4 vs 7 roles
- [`../CATALOG.md`](../CATALOG.md) — the full one-liner index of every shipped role and skill (or run `/catalog`)

If you find yourself reaching for the same role often, read the matching `roles/<role>/ROLE.md` in full — it's the role's mindset, heuristics, and anchor experts in one place.
