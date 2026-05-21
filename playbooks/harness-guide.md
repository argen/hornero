# Harness guide

> For contributors and advanced users. Explains what "deterministic" means here, what the invariants are, how to verify them, and how to extend the harness without breaking it.

---

## What "deterministic" means here

Not "the LLM gives the same output every time" — that's not achievable. What's deterministic is the *structural path*: given the same inputs, the same file schema, the same routing protocol, and the same shell commands, the harness makes the same structural decisions and produces byte-identical output in the parts that matter.

The contrast is with *ad-hoc*: a session that reinvents its methodology, scores quality by feel, records nothing, and starts from scratch next time. Hornero's determinism is the opposite of that — it compounds.

---

## The five determinism layers

### 1. Dispatcher determinism

[`DISPATCHER.md`](../DISPATCHER.md) is a six-rule state machine. Priority order is strict:

1. Explicit slash command (e.g., `/ingest`, `/orchestrate`)
2. Artifact intake signal (e.g., "here's a transcript", "critique this PRD")
3. Explicit skill or role naming (e.g., "use the strategy-kernel skill")
4. Verb + shape (e.g., "frame this problem" → `problem-framing-canvas`)
5. Trigger phrases in SKILL.md frontmatter `scenarios:` field
6. No match → ask once; do not fabricate a route

**What makes a route deterministic:** the dispatcher matches against [`CATALOG.md`](../CATALOG.md) one-liner descriptions — a flat, auto-generated index. Each entry should match exactly one job-to-be-done. Descriptions that start with "Use when..." followed by a specific trigger are more matchable than generic ones.

**Failure mode:** catalog descriptions that are too similar → ambiguous match → dispatcher should escalate to the user (Step 5: multi-match) rather than guess. If you see silent picks on ambiguous prompts, the description or scenarios field needs sharpening.

**Verification:** `bash scripts/validate-dispatcher.sh` — checks dead references in routing fixtures, description completeness, and scenarios presence.

---

### 2. Skill anatomy determinism

Every [`SKILL.md`](../skills/) follows a fixed six-section schema, enforced by [`scripts/validate-skill.sh`](../scripts/validate-skill.sh):

**Required frontmatter fields:** `name`, `description`, `type` (one of: `interactive`, `component`, `workflow`).

**Required body sections** (in order):
1. Purpose
2. Key Concepts
3. Application
4. Examples
5. Common Pitfalls
6. References

None of these sections may be empty. The `description` field must be vivid and concrete — the dispatcher matches against it.

**Sources discipline:** frameworks cited in Key Concepts must trace to the role's `sources.md`. Decorative citations (name-dropping without actual grounding) fail the editorial bar even if they pass the validator.

**Verification:** `bash scripts/validate-skill.sh roles/product-manager/skills/ skills/`

**Failure mode:** an empty Examples or Purpose section produces a skill the dispatcher can invoke but that produces weak output. The validator catches empty sections; editorial review catches thin ones.

---

### 3. Chronicle determinism

The [`chronicle/`](../chronicle/) layer is the most explicitly deterministic part of the harness:

**Schema validation:** every entry in `chronicle/entries/` is validated against [`chronicle/SCHEMA.md`](../chronicle/SCHEMA.md). Ten required fields (`id`, `title`, `date`, `status`, `confidence`, `source_role`, `sourcing`, `type`, `scope`, `affected_areas`, `decision`), all enum-typed where applicable.

**Byte-stable query output:** `scripts/chronicle.sh query` sorts results by `date desc, id asc` and emits fixed Markdown headers. Re-running the same query against the same corpus produces identical bytes.

**LLM-free write path:** the write path is `propose` → human review → `commit`. The LLM drafts; a human approves before any entry lands in `chronicle/entries/`. This means no LLM can quietly alter the chronicle.

**Append exception:** `chronicle.sh append` grows whitelisted sections row-by-row (Evidence Log on hypotheses; Open asks / Concerns / Last contact / Decision affinity on stakeholders; Usage shape / Health signals / Decision drivers / Stakeholders on customers). All other changes require supersedes.

**Verification:** `bash scripts/test-chronicle.sh` runs 33 checks — positive fixtures (5), negative fixtures (17 planted-flaw files each with a specific expected error substring), determinism checks (8 byte-stable query re-runs), and append cases.

**Failure mode:** removing a required frontmatter field without migrating existing entries. The validator will catch it on the next validate run; the symptom is `validate` failing on previously valid files.

---

### 4. Lifecycle hook determinism

Two session-lifecycle hooks in [`hooks/hooks.json`](../hooks/hooks.json):

**SessionStart:** emits a one-line banner and runs a lightweight structural guard (`hooks/session-start-check.sh`). The guard checks that `CATALOG.md`, `DISPATCHER.md`, and `chronicle/SCHEMA.md` are present. Warns on stderr if any are missing — does not block the session (end users don't modify harness files).

**Stop:** runs [`hooks/auto-extract-lesson.sh`](../hooks/auto-extract-lesson.sh), which:
1. Reads Claude Code's Stop hook payload from stdin
2. If `stop_hook_active == true`, exits silently (the agent already addressed the directive — don't re-loop)
3. Otherwise, emits a `decision: block` directive instructing the agent to run `extract-lesson`

The idempotency check (`stop_hook_active`) is the key invariant. Without it, the Stop hook would re-fire in a loop. The extraction result is a set of proposals; no harness file changes until the user explicitly approves each one.

**Opt-out:** `HORNERO_NO_AUTO_EXTRACT=1` before launching Claude Code.

**Verification:** review `hooks/hooks.json` (two hooks: banner + structural guard on SessionStart, extract-lesson on Stop). Review `hooks/auto-extract-lesson.sh` line 31 for the idempotency check.

---

### 5. Build-time consistency checks

[`scripts/smoke-check.sh`](../scripts/smoke-check.sh) runs 11 checks in sequence:

| Step | What it checks |
|---|---|
| 1 | Every SKILL.md passes `validate-skill.sh` anatomy lint |
| 2 | Every ROLE.md has `name`, `description`, `mode` frontmatter |
| 3 | Every `agents/*.md` has `name`, `description`, `tools` frontmatter |
| 4 | `CATALOG.md` is up to date (no drift from `catalog.sh`) |
| 5 | Every CATALOG entry resolves to a real directory on disk |
| 6 | `install.sh --dry-run` reports the expected file count |
| 7 | Every per-role skill has a top-level `skills/<name>` symlink; no dangling symlinks |
| 8 | `.codex-plugin/plugin.json` valid + in sync with `.claude-plugin/`; Codex agent TOMLs parse and match Markdown sources |
| 9 | Every RESOURCE.md passes `validate-resource.sh` anatomy lint |
| 10 | Skill `resources:` → RESOURCE.md and RESOURCE.md `used_by:` → SKILL.md are bidirectionally consistent |
| 11 | Chronicle: `validate` (schema) + `test-chronicle.sh` (33 determinism checks) |
| 12 | `validate-dispatcher.sh`: routing fixture dead references, catalog description completeness, scenarios presence |

Step 13 (optional, `--install` flag): real install against `~/.claude` with manifest count verification.

Other build-time scripts:
- `scripts/catalog.sh` — regenerates `CATALOG.md` from SKILL.md / ROLE.md frontmatter. Run after any description change.
- `scripts/build-plugin-skills.sh` — recreates `skills/<name>/` symlinks from `roles/*/skills/`. Run after adding a role skill.
- `scripts/build-codex-agents.sh` — regenerates `.codex/agents/*.toml` from `agents/*.md`. Run after any agent change.

All three are idempotent. `smoke-check.sh` fails if any drift is detected.

---

## Running the full verification suite

To verify end-to-end before a release or after a significant change:

```bash
# Full pre-release gate (11 deterministic checks + catalog regen)
bash scripts/smoke-check.sh

# Chronicle layer only (33 checks, fast)
bash scripts/test-chronicle.sh

# Skills only
bash scripts/validate-skill.sh roles/product-manager/skills/ skills/

# Resources only
bash scripts/validate-resource.sh resources/

# Dispatcher routing fixtures only
bash scripts/validate-dispatcher.sh

# Verify catalog is current
bash scripts/catalog.sh && git diff CATALOG.md
```

All of these are run in CI on every PR. Run them locally with `scripts/install-git-hooks.sh` to catch failures before push.

**Quick health table:**

| What you changed | Commands to run |
|---|---|
| Added / renamed a skill | `catalog.sh` + `smoke-check.sh` |
| Edited a skill description | `catalog.sh` + `validate-dispatcher.sh` |
| Added a role skill | `build-plugin-skills.sh` + `catalog.sh` + `smoke-check.sh` |
| Changed an agent | `build-codex-agents.sh` + `smoke-check.sh` |
| Added a chronicle entry | `chronicle.sh validate` + `test-chronicle.sh` |
| Changed a resource | `validate-resource.sh` + `smoke-check.sh` (cross-ref check) |
| Changed hooks | Review `hooks/hooks.json` + test session start manually |

---

## Extending the harness without breaking determinism

**TDD discipline** — write tests before implementation for all script changes:

**Adding a skill:**
1. Create the `SKILL.md` directory scaffold
2. Run `validate-skill.sh` on the empty file — confirm it fails with expected errors
3. Populate each required section
4. Run `validate-skill.sh` again — must pass
5. Run `catalog.sh` and review the CATALOG.md diff
6. Add a representative prompt to `tests/dispatcher/routes.tsv`
7. Run `validate-dispatcher.sh` — must pass

**Adding a chronicle query:**
1. Write the expected output to `tests/chronicle/expected/<query-name>.md` first
2. Implement the query in `scripts/chronicle.sh`
3. Run the query and diff against the expected file — must match exactly

**Adding a script:**
1. Write `tests/expected/<script-name>.txt` with expected stdout first
2. Implement the script
3. Run and diff — must be byte-identical

**What is forbidden:**
- Removing a required frontmatter field from the schema without migrating all existing entries
- Changing `chronicle.sh query` output format without updating all expected fixtures in `tests/chronicle/expected/`
- Adding a hook that isn't idempotent (re-fires on the result of its own output)
- Editing `CATALOG.md` by hand (it's auto-generated; hand edits are silently overwritten by `catalog.sh`)

---

## Harness calibration for evals

The eval harness at [`evals/`](../evals/) measures output quality (not structural validity). It uses a human + LLM dual-score approach to balance throughput with accuracy:

- **Human score** → `score_human.json`: the authority; scored interactively via `evals/score.sh <run-dir>`
- **LLM score** → `score_llm.json`: throughput tool; scored automatically via `python evals/judge.py <run-dir>` — provider-agnostic (anthropic / openai / gemini), records `judge_provider` + `judge_model`
- **Calibration target:** mean |human − LLM| delta < 0.1 across scored runs
- **Workflow:** LLM scores all 20 tasks first; human reviews the 5-10 with the highest |delta| ≥ 0.25 flags; `score.sh --aggregate` shows both side-by-side

If the LLM delta is consistently > 0.1 on a specific dimension, the judge prompt needs a concrete example for that dimension. Cross-provider judging (running the same runs through Anthropic *and* OpenAI *and* Gemini) is a useful precision technique — if providers disagree, the provider is the variable and the human score breaks the tie. Recalibrate quarterly or after any rubric change. Document offsets in [`evals/README.md`](../evals/README.md).

---

## Common failure modes and diagnosis

| Symptom | Likely cause | Fix |
|---|---|---|
| Dispatcher picks a skill on an unrelated prompt | CATALOG.md description too generic | Sharpen the "Use when..." to name the specific trigger |
| `smoke-check.sh` fails at step 4 | `catalog.sh` not re-run after a description edit | `bash scripts/catalog.sh` + commit the diff |
| `test-chronicle.sh` fails on a determinism check | Output format changed (whitespace, sort order) | Update `tests/chronicle/expected/` to match the new canonical output |
| Stop hook fires in a loop | `stop_hook_active` check not working | Verify `hooks/auto-extract-lesson.sh` line 31; check JSON payload is being read from stdin |
| `validate-skill.sh` fails on a newly added skill | Missing required section (often References) | Add the section; leave it non-empty (one line is enough) |
| `validate-dispatcher.sh` fails on dead reference | Skill renamed or removed but `routes.tsv` not updated | Update `tests/dispatcher/routes.tsv` to use the new name |
