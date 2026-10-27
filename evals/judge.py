#!/usr/bin/env python3
"""Provider-agnostic LLM-as-judge scorer for multi-role-review evals.

Reads rubric.md + synthesis.md from a run directory, calls the chosen LLM
provider to score the synthesis on four rubric dimensions, and writes
score_llm.json.

Supported providers (lazy-imported — install only the SDK you use):
    anthropic  → `pip install anthropic`       (env: ANTHROPIC_API_KEY)
    openai     → `pip install openai`          (env: OPENAI_API_KEY)
    gemini     → `pip install google-genai`    (env: GEMINI_API_KEY)

Usage:
    python evals/judge.py evals/runs/<task-slug>
    python evals/judge.py evals/runs/<task-slug> --provider openai
    python evals/judge.py evals/runs/<task-slug> --provider gemini --model gemini-2.5-pro
    python evals/judge.py evals/runs/<task-slug> --dry-run

Defaults:
    --provider: anthropic (override with EVAL_JUDGE_PROVIDER env var)
    --model:    provider-specific default (override with EVAL_JUDGE_MODEL env var)
"""

import argparse
import json
import os
import sys
from abc import ABC, abstractmethod
from datetime import datetime, timezone
from pathlib import Path

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


# ─── Provider abstraction ─────────────────────────────────────────────

class Judge(ABC):
    """Abstract judge — implement `score()` to call a specific provider."""

    name: str = ""
    default_model: str = ""
    api_key_env: str = ""
    install_hint: str = ""

    def __init__(self, model: str | None = None):
        self.model = model or os.environ.get("EVAL_JUDGE_MODEL") or self.default_model

    def require_api_key(self) -> None:
        if not os.environ.get(self.api_key_env):
            print(f"{self.api_key_env} not set", file=sys.stderr)
            sys.exit(1)

    @abstractmethod
    def score(self, system: str, user: str) -> str:
        """Return the raw text response from the model."""


class AnthropicJudge(Judge):
    name = "anthropic"
    default_model = "claude-sonnet-5-5"
    api_key_env = "ANTHROPIC_API_KEY"
    install_hint = "pip install anthropic"

    def score(self, system: str, user: str) -> str:
        try:
            import anthropic
        except ImportError:
            print(f"anthropic SDK not installed. Run: {self.install_hint}", file=sys.stderr)
            sys.exit(1)
        client = anthropic.Anthropic()
        response = client.messages.create(
            model=self.model,
            max_tokens=1024,
            system=system,
            messages=[{"role": "user", "content": user}],
        )
        return response.content[0].text


class OpenAIJudge(Judge):
    name = "openai"
    # Unverified: confirm the current OpenAI model id before relying on this default.
    default_model = "gpt-5"
    api_key_env = "OPENAI_API_KEY"
    install_hint = "pip install openai"

    def score(self, system: str, user: str) -> str:
        try:
            import openai
        except ImportError:
            print(f"openai SDK not installed. Run: {self.install_hint}", file=sys.stderr)
            sys.exit(1)
        client = openai.OpenAI()
        response = client.chat.completions.create(
            model=self.model,
            max_tokens=1024,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": user},
            ],
        )
        return response.choices[0].message.content or ""


class GeminiJudge(Judge):
    name = "gemini"
    default_model = "gemini-2.5-pro"
    api_key_env = "GEMINI_API_KEY"
    install_hint = "pip install google-genai"

    def score(self, system: str, user: str) -> str:
        try:
            from google import genai
            from google.genai import types
        except ImportError:
            print(f"google-genai SDK not installed. Run: {self.install_hint}", file=sys.stderr)
            sys.exit(1)
        client = genai.Client(api_key=os.environ[self.api_key_env])
        response = client.models.generate_content(
            model=self.model,
            contents=user,
            config=types.GenerateContentConfig(
                system_instruction=system,
                max_output_tokens=1024,
            ),
        )
        return response.text or ""


PROVIDERS: dict[str, type[Judge]] = {
    "anthropic": AnthropicJudge,
    "openai": OpenAIJudge,
    "gemini": GeminiJudge,
}


# ─── Prompt assembly + response parsing ───────────────────────────────

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


# ─── CLI ──────────────────────────────────────────────────────────────

def main() -> None:
    default_provider = os.environ.get("EVAL_JUDGE_PROVIDER", "anthropic")

    parser = argparse.ArgumentParser(
        description="Provider-agnostic LLM-as-judge scorer for multi-role-review evals",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
Defaults can be overridden with env vars:
  EVAL_JUDGE_PROVIDER   default provider (anthropic, openai, gemini)
  EVAL_JUDGE_MODEL      default model for the selected provider

Required API key env var by provider:
  anthropic  → ANTHROPIC_API_KEY
  openai     → OPENAI_API_KEY
  gemini     → GEMINI_API_KEY
""",
    )
    parser.add_argument("run_dir", help="Run directory containing synthesis.md")
    parser.add_argument(
        "--provider",
        default=default_provider,
        choices=sorted(PROVIDERS.keys()),
        help=f"LLM provider (default: {default_provider})",
    )
    parser.add_argument(
        "--model",
        default=None,
        help="Model name (default: provider-specific; see --provider)",
    )
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

    judge = PROVIDERS[args.provider](model=args.model)

    if args.dry_run:
        print(f"=== PROVIDER: {judge.name} | MODEL: {judge.model} ===")
        print()
        print("=== SYSTEM PROMPT ===")
        print(JUDGE_SYSTEM)
        print()
        print("=== USER PROMPT ===")
        print(user_prompt)
        print("=== END (dry run — no API call made) ===")
        return

    judge.require_api_key()

    print(f"Scoring {run_dir.name} with {judge.name} / {judge.model}...")

    try:
        raw_text = judge.score(JUDGE_SYSTEM, user_prompt)
    except Exception as exc:
        print(f"Provider error ({judge.name}): {exc}", file=sys.stderr)
        sys.exit(1)

    try:
        result = extract_json(raw_text)
        validate_result(result)
    except (ValueError, json.JSONDecodeError) as exc:
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
        "judge_provider": judge.name,
        "judge_model": judge.model,
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
