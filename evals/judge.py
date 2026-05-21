#!/usr/bin/env python3
"""LLM-as-judge scorer for multi-role-review evals.

Reads rubric.md + synthesis.md from a run directory, calls Claude to score
the synthesis on four rubric dimensions, and writes score_llm.json.

Usage:
    python evals/judge.py evals/runs/<task-slug>            # score one run
    python evals/judge.py evals/runs/<task-slug> --dry-run  # print prompt, no API call

Requires:
    ANTHROPIC_API_KEY environment variable
    pip install anthropic
"""

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

MODEL = "claude-sonnet-4-6"
RUBRIC_VERSION = "v0"
VALID_SCORES = frozenset({0.0, 0.25, 0.5, 0.75, 1.0})

JUDGE_SYSTEM = """\
You are a strict evaluator of AI-generated product management synthesis quality.

Score the provided synthesis against the rubric. Be honest. Round down when uncertain.
Use only these score values: 0, 0.25, 0.5, 0.75, 1.0 — no finer granularity.

Return ONLY a valid JSON object with this exact structure, no surrounding text:
{
  "source_citation_rate": <score>,
  "source_citation_rationale": "<one sentence>",
  "finding_distinctness": <score>,
  "finding_distinctness_rationale": "<one sentence>",
  "conflict_surfacing": <score>,
  "conflict_surfacing_rationale": "<one sentence>",
  "actionability": <score>,
  "actionability_rationale": "<one sentence>"
}\
"""


def load_rubric(evals_dir: Path) -> str:
    return (evals_dir / "rubric.md").read_text()


def build_user_prompt(rubric: str, synthesis: str) -> str:
    return f"""RUBRIC:

{rubric}

---

SYNTHESIS TO EVALUATE:

{synthesis}

---

Score all four dimensions against the rubric above and return the JSON object."""


def extract_json(text: str) -> dict:
    start = text.find("{")
    end = text.rfind("}") + 1
    if start == -1 or end == 0:
        raise ValueError(f"No JSON object in response (first 300 chars): {text[:300]}")
    return json.loads(text[start:end])


def call_claude(user_prompt: str) -> dict:
    try:
        import anthropic
    except ImportError:
        print("anthropic package not installed. Run: pip install anthropic", file=sys.stderr)
        sys.exit(1)

    client = anthropic.Anthropic()
    response = client.messages.create(
        model=MODEL,
        max_tokens=1024,
        system=JUDGE_SYSTEM,
        messages=[{"role": "user", "content": user_prompt}],
    )
    return extract_json(response.content[0].text)


def validate_result(result: dict) -> None:
    dims = [
        "source_citation_rate",
        "finding_distinctness",
        "conflict_surfacing",
        "actionability",
    ]
    for dim in dims:
        if dim not in result:
            raise ValueError(f"Missing dimension in response: {dim}")
        score = result[dim]
        if float(score) not in VALID_SCORES:
            raise ValueError(
                f"Invalid score for {dim}: {score!r} — must be one of {sorted(VALID_SCORES)}"
            )
        rationale_key = f"{dim}_rationale"
        if not result.get(rationale_key, "").strip():
            raise ValueError(f"Empty rationale for {dim}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="LLM-as-judge scorer for multi-role-review evals"
    )
    parser.add_argument("run_dir", help="Run directory containing synthesis.md")
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the judge prompt without making an API call",
    )
    args = parser.parse_args()

    run_dir = Path(args.run_dir)
    if not run_dir.is_dir():
        print(f"Not a directory: {run_dir}", file=sys.stderr)
        sys.exit(1)

    synthesis_path = run_dir / "synthesis.md"
    if not synthesis_path.exists():
        print(
            f"Missing synthesis at {synthesis_path} — run multi-role-review first.",
            file=sys.stderr,
        )
        sys.exit(1)

    evals_dir = Path(__file__).parent
    rubric = load_rubric(evals_dir)
    synthesis = synthesis_path.read_text()
    user_prompt = build_user_prompt(rubric, synthesis)

    if args.dry_run:
        print("=== SYSTEM PROMPT ===")
        print(JUDGE_SYSTEM)
        print()
        print("=== USER PROMPT ===")
        print(user_prompt)
        print("=== END (dry run — no API call made) ===")
        return

    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("ANTHROPIC_API_KEY not set", file=sys.stderr)
        sys.exit(1)

    print(f"Scoring {run_dir.name} with {MODEL}...")

    try:
        result = call_claude(user_prompt)
    except Exception as exc:
        print(f"API error: {exc}", file=sys.stderr)
        sys.exit(1)

    try:
        validate_result(result)
    except ValueError as exc:
        print(f"Invalid response: {exc}", file=sys.stderr)
        sys.exit(1)

    cite = float(result["source_citation_rate"])
    distinct = float(result["finding_distinctness"])
    conflict = float(result["conflict_surfacing"])
    action = float(result["actionability"])
    mean = round((cite + distinct + conflict + action) / 4, 3)

    output = {
        "task": run_dir.name,
        "scored_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "rubric_version": RUBRIC_VERSION,
        "judge": "llm",
        "source_citation_rate": cite,
        "source_citation_rationale": result["source_citation_rationale"],
        "finding_distinctness": distinct,
        "finding_distinctness_rationale": result["finding_distinctness_rationale"],
        "conflict_surfacing": conflict,
        "conflict_surfacing_rationale": result["conflict_surfacing_rationale"],
        "actionability": action,
        "actionability_rationale": result["actionability_rationale"],
        "mean": mean,
    }

    score_file = run_dir / "score_llm.json"
    score_file.write_text(json.dumps(output, indent=2) + "\n")

    print(f"\nWrote {score_file}")
    print(f"  citation:    {cite}")
    print(f"  distinct:    {distinct}")
    print(f"  conflict:    {conflict}")
    print(f"  actionable:  {action}")
    print(f"  mean:        {mean:.3f}")
    print()
    print("Run ./evals/score.sh --aggregate to see the running mean (human vs LLM).")


if __name__ == "__main__":
    main()
