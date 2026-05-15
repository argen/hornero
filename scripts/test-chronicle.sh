#!/usr/bin/env bash
# test-chronicle.sh — deterministic harness for the Chronicle layer.
#
# Three test classes:
#   1. POSITIVE — each fixture in tests/chronicle/fixtures/good/ must pass
#      `scripts/chronicle.sh validate`.
#   2. NEGATIVE — each fixture in tests/chronicle/fixtures/bad/ must FAIL
#      validation, AND the failure message must mention the expected
#      diagnostic substring listed in tests/chronicle/bad-signatures.txt.
#   3. DETERMINISM — `scripts/chronicle.sh query` run against the frozen
#      corpus (= tests/chronicle/fixtures/good/) must produce byte-identical
#      output for each query fixture in tests/chronicle/expected/.
#
# The harness uses a TEMP chronicle directory so it never mutates the live
# repo's chronicle/entries/. This means a passing harness on an empty repo
# is the same byte-for-byte as a passing harness on a repo with 200 entries.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURES_GOOD="${ROOT}/tests/chronicle/fixtures/good"
FIXTURES_BAD="${ROOT}/tests/chronicle/fixtures/bad"
EXPECTED_DIR="${ROOT}/tests/chronicle/expected"
SIGNATURES_FILE="${ROOT}/tests/chronicle/bad-signatures.txt"

fail=0
total=0
passed=0

note() { echo "$*"; }
red()  { echo "  ✗ $*" >&2; }
green(){ echo "  ✓ $*"; }

# ─── positive ────────────────────────────────────────────────────────

note "─── positive: good fixtures must validate ─────────────────────────"
if [[ -d "$FIXTURES_GOOD" ]]; then
  for f in "$FIXTURES_GOOD"/*.md; do
    [[ -f "$f" ]] || continue
    total=$((total + 1))
    rel="${f#$ROOT/}"
    if "${ROOT}/scripts/chronicle.sh" validate "$f" >/dev/null 2>&1; then
      green "${rel} validates"
      passed=$((passed + 1))
    else
      red "${rel} should validate but does not"
      "${ROOT}/scripts/chronicle.sh" validate "$f" 2>&1 | sed 's/^/      /' >&2
      fail=1
    fi
  done
else
  note "  (no fixtures/good/ — skipped)"
fi

# ─── negative ────────────────────────────────────────────────────────

note ""
note "─── negative: bad fixtures must fail validation with expected signature ──"
if [[ -f "$SIGNATURES_FILE" && -d "$FIXTURES_BAD" ]]; then
  while IFS=$'\t' read -r filename signature; do
    [[ -z "$filename" || "$filename" =~ ^# ]] && continue
    total=$((total + 1))
    fixture="${FIXTURES_BAD}/${filename}"
    if [[ ! -f "$fixture" ]]; then
      red "signature listed for missing fixture: ${filename}"
      fail=1; continue
    fi
    out="$("${ROOT}/scripts/chronicle.sh" validate "$fixture" 2>&1 || true)"
    if echo "$out" | grep -qF -- "$signature"; then
      # Also confirm the validator exited non-zero
      if ! "${ROOT}/scripts/chronicle.sh" validate "$fixture" >/dev/null 2>&1; then
        green "${filename} failed for the right reason (matched: '${signature}')"
        passed=$((passed + 1))
      else
        red "${filename} matched signature but validator exit-code was 0"
        fail=1
      fi
    else
      red "${filename} did not produce expected signature: '${signature}'"
      echo "$out" | sed 's/^/      /' >&2
      fail=1
    fi
  done < "$SIGNATURES_FILE"
else
  note "  (no bad-signatures.txt or no fixtures/bad/ — skipped)"
fi

# ─── determinism ─────────────────────────────────────────────────────

note ""
note "─── determinism: query against frozen corpus must match expected bytes ──"
if [[ -d "$EXPECTED_DIR" ]]; then
  # Build a temp chronicle workspace, copy good fixtures into entries/
  tmpdir="$(mktemp -d -t hornero-chronicle.XXXXXX)"
  trap 'rm -rf "$tmpdir"' EXIT

  mkdir -p "$tmpdir/chronicle/entries" "$tmpdir/chronicle/proposals" "$tmpdir/scripts"
  cp "$FIXTURES_GOOD"/*.md "$tmpdir/chronicle/entries/" 2>/dev/null || true

  # Symlink the script into the temp tree so its ROOT resolves to the tmpdir
  ln -s "${ROOT}/scripts/chronicle.sh" "$tmpdir/scripts/chronicle.sh"
  touch "$tmpdir/chronicle/SUMMARY.md"

  for expected in "$EXPECTED_DIR"/*.expected; do
    [[ -f "$expected" ]] || continue
    total=$((total + 1))
    name="$(basename "$expected" .expected)"
    cmd_file="${EXPECTED_DIR}/${name}.cmd"
    if [[ ! -f "$cmd_file" ]]; then
      red "${name}.expected has no matching ${name}.cmd"
      fail=1; continue
    fi
    args="$(cat "$cmd_file")"
    actual="$(cd "$tmpdir" && eval "scripts/chronicle.sh ${args}" 2>&1 || true)"
    if diff -u "$expected" <(echo "$actual") >/dev/null 2>&1; then
      green "${name} — query output is byte-identical to expected"
      passed=$((passed + 1))
    else
      red "${name} — query output diverged from expected"
      diff -u "$expected" <(echo "$actual") 2>&1 | head -40 | sed 's/^/      /' >&2
      fail=1
    fi
  done
else
  note "  (no expected/ dir — skipped)"
fi

# ─── summary ─────────────────────────────────────────────────────────

note ""
if [[ $fail -eq 0 ]]; then
  echo "✓ chronicle harness: ${passed}/${total} checks passed"
  exit 0
else
  echo "✗ chronicle harness: $((total - passed))/${total} checks FAILED" >&2
  exit 1
fi
