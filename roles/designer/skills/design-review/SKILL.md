---
name: design-review
description: Use when a UI or feature change is about to be reported as complete — runs a structured design + UX + accessibility + platform-capability pass on a diff or surface and produces a Go / Fix-then-go / Hold recommendation with specific findings.
intent: |
  A workflow skill that orchestrates the designer role's component
  skills — state-audit, accessibility-audit, heuristic-review — and
  adds platform-capability verification and live exercise. The
  workflow is the designer-side complement to the engineer's tdd-
  discipline and the tester's pre-release-test-pass — the discipline
  that says UI work isn't done when the code compiles; it's done when
  someone has walked it as a user. Ports the harness-tested
  ~/.claude/skills/design-review/ skill into the role-based Hornero
  anatomy with named sources.
type: workflow
theme: design-review
best_for:
  - "Self-review before reporting UI / feature work as complete"
  - "Pre-merge design review on a diff that touches user-visible code"
  - "Independent second opinion on a contested design call"
  - "Auditing AI-agent-generated UI for the AI-aesthetic tells"
scenarios:
  - "After Claude finishes implementing a new dashboard component"
  - "Pre-merge pass on a redesigned navigation across web + mobile"
  - "Catching missing states on a generated React component"
  - "Validating a SwiftUI sheet's platform-API assumptions before submission to TestFlight"
estimated_time: 30-90 minutes (small diff); 2-4 hours (new surface or large refactor)
---

# Design review (workflow)

> v0 draft. Ported from `~/.claude/skills/design-review/SKILL.md` (the harness-tested original) into the Hornero role structure, with explicit anchoring to Nielsen, Norman, Krug, Holmes, Buxton, and platform HIGs. The original skill's checklist remains the load-bearing operational scaffold; this version expands sourcing, adds severity and recommendation discipline, and ties into the designer role's component skills.

## Purpose

Run a disciplined design pass on a diff or surface before declaring UI work complete. The workflow's central claim:

**Code that compiles and passes type-checks is not the same as code that looks right, feels right, and works for users who aren't you.**

This skill exists because the most common shipped-too-early failure on UI work is "the build is green, the tests pass, ship it" — and the most common AI-generated-UI failure is plausibly-shaped code that misses states, breaks keyboard nav, ignores platform conventions, and reads as generic.

The workflow:

1. Classifies the change so the depth of review matches the scope.
2. Walks the surface against visual coherence, state coverage, accessibility, edge cases, responsive / platform fit, platform capabilities.
3. **Actually uses the feature live** — code review is not a substitute for exercising the UI.
4. Optionally spawns an independent reviewer for a second opinion.
5. Produces a Verdict + top-3-issues + live-exercise report.

## Key Concepts

### The workflow is a contract with future-you

The workflow runs *before* "done." Skipping a section because it feels like overhead is the failure mode the workflow exists to prevent. The discipline costs minutes; the alternative — patching missing states, fixing focus traps, redoing platform-API integrations — costs days.

For AI-agent-generated UI, this matters more, not less. AI agents tend to:

- Skip empty / loading / error states (the comp showed only success).
- Add motion without `prefers-reduced-motion` gates.
- Invent new spacing / color tokens instead of reusing the design system.
- Confidently call platform APIs that don't exist in the target version.
- Center everything, round everything, gradient everything.

The workflow catches these.

### Classification first; depth follows

Three classes of UI change:

- **Polish** (copy tweak, padding nudge, single-prop change) — runs sections 2, 3, 6, 11. Quick.
- **New surface** (new screen, new component, new flow) — runs the full workflow.
- **Refactor with no visible change** — the design-review workflow doesn't apply. Run the engineer's `tdd-discipline` and `refactor-plan` workflows instead. Stop here.

Misclassification is a real failure mode: treating a new surface as "polish" skips the state-audit and accessibility-audit that the new surface needs.

### Visual coherence — does it belong in this repo?

Wathan/Schoger (*Refactoring UI*): a strong UI has a point of view — typography, weight, hierarchy, density — that the change must honour. The most common AI tells: `rounded-2xl` + drop shadow + gradient + emoji icons + center-everything + "Get started" copy. Three or more applied is a smell.

### Live exercise is not optional

The single highest-leverage step. The reviewer (or the implementer) starts the dev server / simulator / device build and walks the feature as a user. Type-checks and unit tests verify code correctness; live exercise verifies feature correctness. Skipping this is the most common path to "works on my machine, broken in prod."

If the reviewer can't run the UI in their environment (no display, no simulator, locked to a remote build), the workflow's report **says so explicitly**. Claimed success on un-exercised code is a lie of omission.

### Platform-API verification

For changes relying on a platform API (file system, notifications, clipboard, camera, geolocation, biometric, payments, share sheet, push, deep links, IPC, permissions-gated web APIs, native plugin APIs), the workflow verifies:

- The capability *exists* in the version / runtime / framework targeted.
- The permission flow is well-shaped (prompt copy acceptable; deny path designed; revoke-later path designed).
- The failure mode is designed (network down, permission denied, capability unavailable on this platform / OS version).

This is the single biggest source of cross-platform "works on my machine, broken in prod."

### Subagent second opinion

For new-surface or large-refactor diffs, an independent reviewer (a fresh agent with no context from the current conversation, or a human peer) catches issues self-review's blind spots miss. The workflow names when to invoke this and how to brief them.

### Output discipline

The final report is short — Verdict + top-3-issues + live-exercise statement + a "things a human reviewer should look at twice" pointer. Two paragraphs maximum. Long reports get skimmed; short ones get acted on.

## Application

### Step 1 — Classify the change

```bash
git status
git diff --stat
git diff
```

Decide:

- **Polish** → run sections 2, 3, 6, 11. Skip the rest.
- **New surface** → run the whole workflow.
- **Refactor without visible change** → stop; this workflow doesn't apply. Run engineer's `tdd-discipline` and `refactor-plan` instead.

If the diff is >300 lines or touches >3 components, plan for the optional subagent pass at step 10.

### Step 2 — Visual coherence

- Does the change match the **design system already in the repo**? Look for existing tokens, primitives, spacing scale, type scale, color palette before introducing new values. If new tokens were added, justify them or remove them.
- Does it read as **generic**? The AI-aesthetic checklist: `rounded-2xl` + drop shadow + gradient + emoji icons + center-everything + "Get started" copy. Three or more apply → the design needs a stronger point of view.
- Are typography, weight, and hierarchy doing actual work? A heading that's the same size as body text isn't a heading.
- Is information density appropriate to the surface? A dashboard is not a marketing landing page.

### Step 3 — State coverage

Run [`state-audit`](../state-audit/SKILL.md) in compact form on each interactive surface. The four core states must exist and be intentional:

- **Loading** — skeleton / spinner / progressive reveal. Not a blank white screen.
- **Empty** — first-time-user view. Distinguish first-time empty from cleared empty if both apply.
- **Error** — recoverable with a clear next action. Not "Something went wrong" with no recovery path.
- **Success / populated** — the obvious one.

For multi-call surfaces, the **partial** state is also required.

Missing any of these is the most common shipped-too-early failure mode.

### Step 4 — Accessibility

Run [`accessibility-audit`](../accessibility-audit/SKILL.md) in compact form against this surface:

- **Keyboard navigation.** Tab through the feature with no mouse. All interactive elements reachable; focus order logical; focus ring visible; no traps.
- **Screen reader semantics.** Real elements (`button`, `a`, `nav`, `main`, `h1–h6`) before reaching for `div role="..."`; labels for form controls; alt text for meaningful images; `aria-*` only when no semantic alternative exists.
- **Color contrast.** WCAG 2.2 AA minimum: 4.5:1 for body text, 3:1 for large text and UI elements. Test computed colors, not design-system token names.
- **Reduced motion.** Animations gated behind `prefers-reduced-motion: reduce` (or the platform equivalent).
- **Touch targets.** 44×44 pt minimum on touch surfaces (iOS HIG / Material); 24×24 CSS px minimum on web (WCAG 2.2). Hover-only affordances are unreachable on touch.

### Step 5 — Edge cases

Mentally (or actually) feed the UI:

- **Long text** — a 200-char username, a 2-line product title, a paragraph in a button.
- **Many items** — 1, 5, 50, 500, 10,000. Does layout / scroll / performance hold?
- **Zero / one / N** — singular vs plural copy; empty-list vs one-item layout.
- **Missing data** — null name, missing avatar, undefined date.
- **Slow / offline / failed network** — does it hang, retry, give up gracefully?
- **Wrong locale / RTL** — direction flip; non-Latin script if the product supports it.

### Step 6 — Responsive / viewport / platform fit

- Resize from narrow (320 px or platform-equivalent) to wide. Layout adapts or breaks?
- Platform conventions respected? Native iOS back-swipe, macOS traffic-light spacing, Windows snap, web back-button — none of these should feel violated.
- Dark mode rendered correctly (or explicitly opted out)?
- Print stylesheet — only if the feature is plausibly printed.

### Step 7 — Platform-API capabilities

If the change relies on a platform API, verify:

- **The capability exists** in the version, runtime, and framework targeted. Read the docs; check the framework's capability table. Don't assume.
- **The permission flow.** Prompt copy acceptable? Deny path designed? Revoke-later path designed?
- **The failure mode.** Network down, permission denied, capability unavailable on this OS version.

This step is non-negotiable for changes touching: file system, notifications, clipboard, camera, geolocation, biometric, payments, share sheet, push, deep links, IPC, web APIs gated by permissions, native plugin APIs.

### Step 8 — Live exercise

**Actually use the feature.**

- Start the dev server / simulator / device build.
- Walk the **golden path** end-to-end as a user would.
- Walk **two edge cases** from step 5 you think most likely to break.
- Watch the console for errors, warnings, layout shift, dropped frames.

If you cannot run the UI in this environment (no display, no simulator, locked to a remote build), **state this explicitly** in the report. Do not claim success on code that has not been exercised.

### Step 9 — Code-level smell check

A quick pass on the diff itself:

- Inline styles or magic numbers that should be tokens?
- Component doing too much (props list >10, rendering branches on >3 conditions)? Probably needs splitting.
- Re-implementation of something the design system already provides?
- New dependency for a 5-line problem?
- `any` / `unknown` / `// @ts-expect-error` added without comment?
- Test coverage for new branches?

### Step 10 — Optional: subagent / peer second opinion

For new-surface or large-refactor diffs, spawn an independent reviewer with no context from the current conversation. Independent context catches what self-review's blind spots miss.

Briefing template:

> Review the diff on the current branch for design + UX quality. Goal: catch issues a fresh reviewer would see that the author missed. Check: visual coherence with the rest of the codebase, state coverage (loading / empty / error / partial), accessibility, edge cases, platform conventions. Flag anything that reads as generic or AI-templated. Report: 5-10 specific issues with file paths, ranked by severity. Under 400 words.

If a human reviewer is available, prefer them for high-stakes surfaces; the agent suffices for routine reviews.

### Step 11 — Report

Two paragraphs maximum, with this shape:

```markdown
**Verdict.** Go | Fix-then-go | Hold.

**Top 3 things to fix.**
1. file:line — what — why.
2. file:line — what — why.
3. file:line — what — why.

(If there are more than three, the work isn't ready — reduce to three blockers
and list the rest under "follow-ups".)

**What I exercised live.**
<Golden path walked: yes/no. Edge cases tried: list. Or: "couldn't run UI in
this environment.">

**What a human reviewer should look at twice.**
<1-2 specific items where a second pair of eyes would be high-leverage.>
```

The reader (user, PM, another designer, the implementer) should be able to act on this report inside two minutes.

## Examples

### Example 1 — Dashboard feature, full workflow (good)

```markdown
**Verdict.** Fix-then-go.

**Top 3 things to fix.**
1. `dashboard/widgets/MetricCard.tsx:42` — focus ring is `outline: none`
   without replacement; keyboard users cannot see focus. Add the design
   system's `--focus-ring` token.
2. `dashboard/page.tsx:88` — no loading state; on first paint, the page
   renders as a stretched skeleton-less blank. Add the design system's
   `<Skeleton />` primitive for each card while data is in flight.
3. `dashboard/widgets/MetricCard.tsx:78` — animation is unconditional;
   ignores `prefers-reduced-motion`. Gate the count-up animation; show
   the final value immediately when reduced motion is requested.

**Follow-ups (not blocking):**
- Cross-sell rail uses a new `rounded-3xl` token not in the system —
  either justify in the system or use existing `rounded-xl`.
- Long metric names (>30 chars) wrap awkwardly. Truncate at 24 with
  tooltip on hover/long-press.

**What I exercised live.**
Yes — ran `pnpm dev`; walked the golden path (load → view 4 metrics →
drill into one); tried "no data" (empty state surfaced cleanly); tried
"slow network" via DevTools throttle (revealed the missing loading state
above).

**What a human reviewer should look at twice.**
The keyboard nav order across the 6 cards on the dashboard — I tabbed
through and it followed source order, but I want to confirm the visual
order matches because the cards are placed in a CSS grid that might
re-order at narrow widths.
```

The implementer can act on each item; the live-exercise statement is honest about what was tested; the human-second-look pointer is specific.

### Example 2 — Polish change, compact workflow (good)

```markdown
**Verdict.** Go.

**Top 3.**
1. (None.) The change is a single-line copy tweak from "Sign in" to
   "Log in" for consistency with the rest of the product surface.

**What I exercised live.**
Yes — confirmed the new copy renders in both light and dark modes, the
focus ring is unaffected, and the click target is unchanged.

**Note.** Considered whether this triggers any analytics-event renames;
no, the event name is decoupled from the button copy.
```

For polish, the workflow is short — and that's correct. The report still confirms live exercise.

### Example 3 — Failure mode (bad)

```markdown
**Verdict.** Go.

Looks good. Lighthouse passes. Tests pass. Shipping.
```

Failures: no classification of the change; no state-coverage check; no accessibility walk-through; no live-exercise statement; "looks good" is not a finding; Lighthouse's pass is conflated with usability ("WCAG-compliant ≠ accessible"); no human-second-look pointer.

## Common Pitfalls

### Pitfall 1 — Compile-success conflated with feature-success

**Symptom:** "Tests pass, types pass, shipping." No live exercise reported.

**Consequence:** Bugs that only surface in motion (focus management, async timing, layout shift, missing states) ship. The team learns to distrust the test suite for the wrong reason — the tests were not asserting what mattered.

**Fix:** Live exercise is required. If you can't, the report says so explicitly.

### Pitfall 2 — Misclassifying as polish

**Symptom:** A change that adds a new surface, modal, or flow is treated as "polish" and the abbreviated workflow runs.

**Consequence:** State coverage, accessibility, platform-capability are skipped; the new surface ships with the standard set of missing-state failures.

**Fix:** Classify carefully. "Polish" is single-prop / copy / padding. Anything that adds new interactive surface area is "new surface" and gets the full workflow.

### Pitfall 3 — AI-aesthetic uncritically accepted

**Symptom:** Generated UI uses generic rounded-2xl + gradient + drop-shadow + center-everything; reviewer doesn't flag because "it looks fine."

**Consequence:** Product loses its visual identity; design system fragments; users learn to distrust the surface as "AI-generated".

**Fix:** Explicit AI-tell checklist (visual coherence step). Three-of-six triggers a rework before merge.

### Pitfall 4 — Platform-API assumed, not verified

**Symptom:** Code calls `navigator.share()` / `UNUserNotificationCenter.current()` / `vibrate()` without checking the capability is available in the target platform's version.

**Consequence:** "Works on my dev environment" → broken on production; sometimes uncaught (silent failure); sometimes a hard crash.

**Fix:** Platform-API verification is a non-negotiable step. Capability tables are linked from the platform's docs; check them.

### Pitfall 5 — Subagent / peer skipped on large diffs

**Symptom:** New-surface or 600-line diff reviewed by the implementer only.

**Consequence:** Implementer's blind spots ship. The subagent or peer would have caught at least one issue the implementer missed.

**Fix:** Diff size triggers the second-opinion pass. For high-stakes surfaces, prefer a human peer; for routine, the subagent suffices.

### Pitfall 6 — Long report

**Symptom:** The report is 800 words across six sections.

**Consequence:** Skimmed; the top-3 fixes get lost in the noise; the verdict isn't acted on.

**Fix:** Two paragraphs maximum. If you have more than three blockers, the verdict is "Hold" — reduce to three and list the rest as follow-ups.

### Pitfall 7 — Verdict by feeling

**Symptom:** Verdict is "Go" with three "high-severity" issues unfixed.

**Consequence:** Issues go to production. The verdict-issues mismatch trains the team that the verdict is decorative.

**Fix:** Verdict is rule-driven: blockers ⇒ Hold or Fix-then-go. Zero blockers ⇒ Go. Don't soften the verdict to be agreeable.

### Pitfall 8 — Self-review never escalates

**Symptom:** Implementer self-reviews every change; the second-opinion step never fires.

**Consequence:** Self-review's blind spots become institutional.

**Fix:** New-surface / large-diff / contested-design changes trigger the second-opinion step automatically. The workflow names the trigger so it doesn't depend on the implementer's judgement in the moment.

## References

- **Original skill** — `~/.claude/skills/design-review/SKILL.md` — the harness-tested workflow this skill ports. Operational checklist preserved; sourcing and integration expanded.
- **Don Norman** — *The Design of Everyday Things* (rev. ed. 2013); affordances, signifiers, feedback. See `roles/designer/sources.md`.
- **Jakob Nielsen** — 10 Usability Heuristics; informs the visual-coherence and state-coverage steps. [nngroup.com](https://www.nngroup.com/articles/ten-usability-heuristics/).
- **Steve Krug** — *Don't Make Me Think* (3rd ed. 2014); obvious-beats-clever; the "live exercise" step echoes Krug's usability-test-with-five-users discipline.
- **Bill Buxton** — *Sketching User Experiences* (2007); the fidelity-matches-stage argument that justifies the polish-vs-new-surface classification.
- **Kat Holmes** — *Mismatch* (2018); the inclusive-design lens incorporated into accessibility and edge-case steps.
- **Adam Wathan & Steve Schoger** — *Refactoring UI* (2018); the visual-coherence point-of-view argument; the AI-aesthetic anti-pattern list draws on their critique of generic SaaS design.
- **Apple Human Interface Guidelines** and **Material Design Guidelines** — platform-conventions reference for the platform-fit step.
- **W3C** — [WCAG 2.2](https://www.w3.org/WAI/WCAG22/quickref/); the accessibility floor.
- **Mike Monteiro** — *Ruined by Design* (2019); the ethical stakes that make the dark-pattern check load-bearing in the visual-coherence step.
- **Related Hornero skills:**
  - [`state-audit`](../state-audit/SKILL.md) — compact pass at step 3; full audit when the diff introduces a new surface.
  - [`accessibility-audit`](../accessibility-audit/SKILL.md) — compact pass at step 4; full audit when warranted by surface scope.
  - [`heuristic-review`](../heuristic-review/SKILL.md) — when contested design choices need a structured framework to settle.
  - `skills/multi-role-review/SKILL.md` — for cross-functional surfaces, the design-review is one of multiple critique lenses.
  - `roles/software-engineer/skills/tdd-discipline/SKILL.md` — the engineer-side complement; this skill picks up where TDD leaves off (correctness verified → usability now needed).
  - `roles/tester/skills/pre-release-test-pass/SKILL.md` — at release time, the design-review's findings feed the tester's risk re-assessment.
