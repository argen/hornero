---
name: harness-check
description: Use to audit whether a repository is AI-ready — does it have AGENTS.md / CLAUDE.md, well-scoped skills, useful test feedback, and a working install path.
intent: |
  Implements Chris MDP's "harness beats prompts" principle as a checkable
  audit. Many teams adopt AI tooling without the scaffolding that makes
  it compound. This skill produces a structured report and prioritized
  recommendations.
type: workflow
theme: harness
best_for:
  - Onboarding a new repo into AI-assisted work
  - Diagnosing why an existing AI workflow feels "stuck"
  - Pre-onboarding audit before a teammate joins
  - Periodic (quarterly) review of harness health
scenarios:
  - "Auditing a recently-acquired codebase before connecting AI tooling"
  - "Diagnosing why a team that adopted AI tools 6 months ago isn't seeing compounding benefits"
  - "Preparing a repo for inclusion in the Hornero install flow"
estimated_time: 10-20 minutes
---

# Harness check

## Purpose

Audit a target repository against the components that make AI-assisted work compound over time. Produce a structured report — present/missing for each component, severity-ranked recommendations, a minimum-viable-harness path if the repo is in poor shape. The skill exists because most repos lack the scaffolding to make AI tooling productive; the difference between a repo where the agent compounds and one where it stays generic is structural, and auditable.

## Key Concepts

### Harness beats prompts

Chris MDP's first principle ([Coding with AI](https://www.chrismdp.com/coding-with-ai/)): scaffolding around requests matters more than wording. The audit checks for that scaffolding, not for prompt quality.

### Eight components of a good harness

A productive harness has the following components present and working. The audit checks each:

1. **Standing instructions** — AGENTS.md or CLAUDE.md at the repo root. Articulates project conventions, model selection, git workflow, testing discipline. Read at every session start.
2. **Skill files** — repo-local or imported skill library that the agent can invoke. Codifies durable behaviors (review, refactor, debug patterns).
3. **Test feedback** — running tests is fast and informative. Failures indicate real problems; flakiness is bounded.
4. **Type and lint feedback** — fast type checks and linters. Errors are actionable; warnings aren't ignored.
5. **CI feedback** — pipeline is reliable. Green means deploy-ready; red means something specific is broken.
6. **Reproducible setup** — `install.sh` / `make setup` / `nix develop` / equivalent. New contributor reaches productive state in ≤30 min.
7. **Memory and context separation** — secrets aren't in the repo; personal context isn't in shared methodology; project memory has a designated location.
8. **Feedback-loop ritual** — there's a place lessons land. Either an `extract-lesson` skill is invoked, or there's a manual review cadence.

### Severity ranking

Findings are categorized:

- **Blocking** — agent will misbehave or be unable to work productively. (e.g., no AGENTS.md, no way to run tests.)
- **Friction** — work is possible but slow. (e.g., slow tests, vague conventions.)
- **Improvement** — the harness works but could compound faster. (e.g., no skill files, no feedback ritual.)

The recommendation list is ranked by severity, then by ease of fix (quick wins first within each severity).

## Application

### Step 1 — Survey the repo

Use read-only tools to inventory:

- Existence of AGENTS.md / CLAUDE.md / README.md / CONTRIBUTING.md
- Presence and size of `.claude/`, `.cursor/`, or similar agent config directories
- Presence of skill files (any format) inside the above
- Test runner config (package.json scripts, Makefile, Justfile, etc.)
- Linter and type checker config
- CI configuration (`.github/workflows/`, `.gitlab-ci.yml`, etc.)
- Setup scripts (`install.sh`, `setup.sh`, `Makefile`, etc.)
- `.env.example` or equivalent (signals secret-handling discipline)
- Project memory directory if applicable

Do not modify anything. Read-only.

### Step 2 — Probe each component

For each of the eight components, classify as Present / Partial / Missing.

For Present: note quality signal (file size, recency, scope match).

For Partial: name what's there and what's missing. E.g., "AGENTS.md exists but is 3 lines and doesn't cover testing or conventions."

For Missing: state outright.

### Step 3 — Sample a test run

If tests exist, run one. Measure:

- Total time
- Whether it tells you something useful on failure (specific message vs "tests failed")
- Whether it's flaky (re-run twice; do results match?)

Don't run if running would be expensive (large test suites with paid dependencies). Note that you skipped.

### Step 4 — Produce the report

Structure:

```markdown
# Harness check — <repo name>

**Date.** <YYYY-MM-DD>
**Overall.** <one-sentence verdict: e.g., "Functional but missing skill files and feedback ritual.">

## Component status

| Component | Status | Notes |
|---|---|---|
| Standing instructions | Present | AGENTS.md, 180 lines, covers conventions + testing |
| Skill files | Missing | No .claude/skills or equivalent |
| Test feedback | Friction | Test suite runs in 4 minutes; failure messages are useful |
| Type/lint | Present | tsc + eslint, fast, configured |
| CI | Present | GitHub Actions, reliable |
| Reproducible setup | Partial | `npm install` works; no env vars documented |
| Memory separation | Present | .env.example, .gitignore covers .env |
| Feedback ritual | Missing | No skill or doc for capturing lessons |

## Blocking findings
- None.

## Friction findings
- F1. Test suite at 4 minutes — slow enough that agents will skip running it
  mid-session. Fix: introduce a fast unit-only subset reachable by `npm run test:fast`.

## Improvement findings
- I1. No skill files. Install Hornero (this repo) for a starting set.
- I2. No feedback ritual. Adopt `playbooks/feedback-ritual.md` for a weekly cadence.
- I3. Setup doc incomplete. Add an `install.sh` and document required env vars.

## Recommended next step
Address friction findings before introducing more skills — slow tests
will undermine the new harness components.
```

### Step 5 — Propose a minimum-viable-harness path

If the repo has more than 2 Blocking findings, the harness is not viable yet. Propose a minimum-viable path:

1. Create a starter AGENTS.md or CLAUDE.md.
2. Add an `install.sh` and `.env.example`.
3. Ensure tests can be run with one command.

Hold off on skills and feedback rituals until the foundation works.

## Examples

### Example 1 — Healthy repo (success)

**Target:** A 2-year-old Next.js monorepo with active development.

**Findings:** All eight components present. Test suite is 90 seconds. AGENTS.md is 250 lines and has been updated four times in the last quarter. Two skill files exist (one for migration writing, one for component scaffolding).

**Verdict:** Working harness. Improvement recommendation: introduce `extract-lesson` to formalize the already-happening informal lesson capture.

### Example 2 — Broken harness (failure)

**Target:** A 5-year-old Python service.

**Findings:** No AGENTS.md. No CLAUDE.md. No CI. Test suite exists but `pytest` returns 17 errors before running any tests (broken imports). No `requirements.txt` pin; environment is undocumented.

**Verdict:** Three Blocking findings. The audit stops at minimum-viable-path recommendation: "Skill files cannot help until the basics work. Start by fixing pytest, adding a requirements.lock, and writing a 30-line AGENTS.md."

## Common Pitfalls

### Pitfall 1 — Auditing what's there, missing what's absent

**Symptom:** The report lavishly describes existing files; gives one-line treatment to missing ones.

**Consequence:** The user reads it and thinks the repo is healthier than it is.

**Fix:** Structure the report by component, not by file. Each of the eight components gets equal treatment. Missing-ness is explicitly named.

### Pitfall 2 — Skill recommendation creep

**Symptom:** The recommendation list includes "add a skill for X, Y, Z, A, B..." for every potential skill.

**Consequence:** Overwhelm; the team doesn't add any of them.

**Fix:** Recommend at most 3 skills. Prefer skills the team will actually use given their current pain points (visible in the friction findings).

### Pitfall 3 — Ignoring the test feedback dimension

**Symptom:** The audit checks for the existence of tests; doesn't probe whether they're fast or informative.

**Consequence:** A repo with slow flaky tests gets a misleading "Present" rating; the actual feedback loop is broken.

**Fix:** Step 3 — actually run a test or sample of tests when possible. Slow or flaky tests are Friction findings.

### Pitfall 4 — Over-prescribing Hornero

**Symptom:** Every Improvement finding recommends installing Hornero.

**Consequence:** Recommendation reads like marketing; user is correctly skeptical.

**Fix:** Hornero is one option; a team-rolled skill library is another; importing from PM-Skills or other repos is a third. Recommend the right tool, not always your own.

### Pitfall 5 — Auditing personal repos as if they were team repos

**Symptom:** Personal hobby project gets dinged for not having CI, multi-role coverage, etc.

**Consequence:** Recommendations are inappropriate to context; user dismisses them.

**Fix:** Step 1 should establish context — solo? team? prod? hobby? — and adjust the bar accordingly. A solo hobby repo with AGENTS.md and a working `make test` has a *fine* harness.

## References

- **Chris MDP** — ["Coding with AI"](https://www.chrismdp.com/coding-with-ai/) — the "harness beats prompts" principle is the foundation of this skill.
- **Anthropic Engineering** — ["How we built our multi-agent research system"](https://www.anthropic.com/engineering/multi-agent-research-system) — tool description quality is a harness property; bad tool descriptions send agents down wrong paths.
- **Related Hornero skills:**
  - `skills/spec-the-problem/SKILL.md` — for repos passing harness-check, the next gateway skill at session start.
  - `skills/extract-lesson/SKILL.md` — the feedback-ritual dimension of the audit is implemented by this skill.
- **Related templates:**
  - `templates/AGENTS.md` — starter standing-instructions file for repos missing one.
  - `templates/settings.json` — recommended Claude Code settings.
