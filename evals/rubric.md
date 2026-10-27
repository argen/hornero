# Review quality rubric

> Source for the `type: llm` graders in `evals/cases/*/graders/quality.md`. Those graders adapt the four dimensions below to a single-role PM output as PASS/FAIL conditions; this file keeps the full 0-1 scale for human spot checks.

> Each run is scored on four dimensions. Each dimension gets one of `{0, 0.25, 0.5, 0.75, 1.0}`. The run's score is the mean of the four. Target across 20 tasks: **mean ≥ 0.8**.

Use this as a judge. Be honest. Round down when uncertain.

---

## Dimension 1 — Source-citation rate

**Question:** What fraction of the synthesis's findings cite a named author / work / framework that traces to the role's `sources.md`?

| Score | Criterion |
|---|---|
| **1.0** | Every finding cites a specific named source by author + work (e.g., "Fowler, *Refactoring*"), and every source traces to the role's `sources.md`. |
| **0.75** | All-but-one findings cite a source; one or two cite a vague "best-practices say…" instead of a named source. |
| **0.5** | About half of the findings cite a named source. The rest are asserted from training data or generic experience. |
| **0.25** | Most findings have no citation; one or two name an author but the citation is decorative (the author wouldn't actually have said that thing). |
| **0.0** | No citations, or worse — fabricated citations to people / works that don't exist. |

**Why this matters:** the whole point of role-based skills is grounding in expert canon. A synthesis that recommends "you should refactor X" without ever invoking Fowler / Beck / Metz is generic AI advice in costume.

---

## Dimension 2 — Finding distinctness

**Question:** Do the role reviews surface *non-overlapping* findings, or do multiple roles return the same things wearing different hats?

| Score | Criterion |
|---|---|
| **1.0** | Each role surfaces at least one finding that no other role surfaced. The synthesis distinguishes them clearly. |
| **0.75** | All but one role contributes a distinct finding; one role's contribution is redundant with another's. |
| **0.5** | Roughly half the roles contribute distinct findings; significant overlap between the rest. |
| **0.25** | Most roles return overlapping findings — the synthesis is largely one finding repeated four times. |
| **0.0** | Every role returns essentially the same set of findings; the multi-role dispatch added no value over single-role review. |

**Why this matters:** if a 4-role review produces what a 1-role review would have produced, you spent 4× the tokens for nothing. The roles must each pull from their distinct lens.

---

## Dimension 3 — Conflict surfacing

**Question:** Does the synthesis name explicit conflicts between roles? Are the conflicts worth naming (real tensions, not manufactured drama)?

| Score | Criterion |
|---|---|
| **1.0** | The synthesis names ≥1 real, non-trivial conflict between roles, frames it as a trade-off, and proposes a way to resolve (or asks the user). |
| **0.75** | A conflict is named but the framing is shallow ("X recommends A, Y recommends B" without examining the trade-off). |
| **0.5** | A conflict exists in the data but the synthesis didn't name it explicitly — the reader has to find it. |
| **0.25** | The synthesis claims "no conflicts" but a careful reader could find at least one. |
| **0.0** | The synthesis is conflict-free *and* the roles unanimously agree — almost certainly because they were too similar (see Dimension 2). |

**Note:** "no conflicts found" is a legitimate 1.0 *if* the synthesis says so explicitly and the reader agrees on inspection. Hiding a real conflict is worse than naming a non-conflict.

**Why this matters:** the value of a multi-role review is often in the tension between lenses. A synthesis that papers over real conflicts misses its most useful output.

---

## Dimension 4 — Actionability

**Question:** Could a reader of the synthesis act on it without going back to the role-level artifacts?

| Score | Criterion |
|---|---|
| **1.0** | The synthesis ends with 1-3 concrete actions, each owned by a named role / person, each with a specific deliverable. A reader could close the doc and start work. |
| **0.75** | Concrete actions are named but ownership is fuzzy ("the team should…") or deliverables are vague ("improve X"). |
| **0.5** | The synthesis identifies what's wrong but stops short of what to do about it; the reader has to translate findings to actions themselves. |
| **0.25** | The synthesis is a summary of findings without recommendations. Useful as a reference, not as a decision artifact. |
| **0.0** | "More research needed" / "the team should align" / "we recommend further investigation." Theatre, not action. |

**Why this matters:** orchestration produces decisions, not meeting transcripts. The whole point of synthesis is to converge on action.

---

## How to score a run

1. Read the synthesis end-to-end. Don't peek at per-role artifacts yet.
2. Score each dimension against the rubric above. Use the integer levels (0, 0.25, 0.5, 0.75, 1.0) — not finer.
3. If a dimension is hard to score, note **why** in the rationale field. The note is more useful than the number.
4. The run's score is the mean of the four. Note it next to the grader verdict for that case.

## Calibration drift

Re-calibrate periodically: pick 3-5 already-scored runs and re-score them blind. If the new scores are systematically higher or lower than the old ones, the rubric or the judges have drifted. Document the recalibration; adjust the target if needed.
