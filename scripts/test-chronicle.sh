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
APPEND_DIR="${ROOT}/tests/chronicle/append"
APPEND_SIGNATURES="${APPEND_DIR}/bad-signatures.txt"

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

# ─── append (positive) ───────────────────────────────────────────────
#
# Each <name>.expected has a matching <name>.cmd (args passed to
# `chronicle.sh append`) and <name>.target (the entry filename to seed
# from FIXTURES_GOOD). The harness copies the target into a fresh tmp
# entries/, runs append, and diffs the result byte-for-byte against the
# expected file.

note ""
note "─── append (positive): each case mutates a fixture and matches expected bytes ──"
if [[ -d "$APPEND_DIR" ]]; then
  for expected in "$APPEND_DIR"/*.expected; do
    [[ -f "$expected" ]] || continue
    total=$((total + 1))
    name="$(basename "$expected" .expected)"
    cmd_file="${APPEND_DIR}/${name}.cmd"
    target_file="${APPEND_DIR}/${name}.target"
    if [[ ! -f "$cmd_file" || ! -f "$target_file" ]]; then
      red "${name}.expected has no matching .cmd or .target"
      fail=1; continue
    fi
    target_name="$(tr -d '\n' < "$target_file")"
    if [[ ! -f "${FIXTURES_GOOD}/${target_name}" ]]; then
      red "${name}: target ${target_name} not in fixtures/good/"
      fail=1; continue
    fi
    case_dir="$(mktemp -d -t hornero-append-pos.XXXXXX)"
    mkdir -p "$case_dir/chronicle/entries" "$case_dir/chronicle/proposals" "$case_dir/scripts"
    cp "${FIXTURES_GOOD}/${target_name}" "$case_dir/chronicle/entries/"
    ln -s "${ROOT}/scripts/chronicle.sh" "$case_dir/scripts/chronicle.sh"
    args="$(cat "$cmd_file")"
    if (cd "$case_dir" && eval "scripts/chronicle.sh append ${args}" >/dev/null 2>&1); then
      if diff -u "$expected" "$case_dir/chronicle/entries/${target_name}" >/dev/null 2>&1; then
        green "${name} — append matches expected bytes"
        passed=$((passed + 1))
      else
        red "${name} — append result diverged from expected"
        diff -u "$expected" "$case_dir/chronicle/entries/${target_name}" 2>&1 | head -40 | sed 's/^/      /' >&2
        fail=1
      fi
    else
      red "${name} — append exited non-zero"
      (cd "$case_dir" && eval "scripts/chronicle.sh append ${args}" 2>&1 | head -20 | sed 's/^/      /' >&2)
      fail=1
    fi
    rm -rf "$case_dir"
  done
else
  note "  (no tests/chronicle/append/ — skipped)"
fi

# ─── append (negative) ───────────────────────────────────────────────
#
# Each line in append/bad-signatures.txt names a case. The harness copies
# <name>.bad.target into entries/ (if it exists) and runs <name>.bad.cmd.
# The append must exit non-zero AND its stderr must include the signature
# substring.

note ""
note "─── append (negative): bad cases must fail with expected diagnostic ──"
if [[ -f "$APPEND_SIGNATURES" && -d "$APPEND_DIR" ]]; then
  while IFS=$'\t' read -r casename signature; do
    [[ -z "$casename" || "$casename" =~ ^# ]] && continue
    total=$((total + 1))
    cmd_file="${APPEND_DIR}/${casename}.bad.cmd"
    target_file="${APPEND_DIR}/${casename}.bad.target"
    if [[ ! -f "$cmd_file" ]]; then
      red "negative case missing .bad.cmd: ${casename}"
      fail=1; continue
    fi
    case_dir="$(mktemp -d -t hornero-append-neg.XXXXXX)"
    mkdir -p "$case_dir/chronicle/entries" "$case_dir/chronicle/proposals" "$case_dir/scripts"
    if [[ -f "$target_file" ]]; then
      target_name="$(tr -d '\n' < "$target_file")"
      cp "${FIXTURES_GOOD}/${target_name}" "$case_dir/chronicle/entries/"
    fi
    ln -s "${ROOT}/scripts/chronicle.sh" "$case_dir/scripts/chronicle.sh"
    args="$(cat "$cmd_file")"
    out="$(cd "$case_dir" && eval "scripts/chronicle.sh append ${args}" 2>&1 || true)"
    rc=0
    (cd "$case_dir" && eval "scripts/chronicle.sh append ${args}" >/dev/null 2>&1) || rc=$?
    if [[ $rc -eq 0 ]]; then
      red "${casename} — append exited 0 but should have failed"
      fail=1
    elif echo "$out" | grep -qF -- "$signature"; then
      green "${casename} failed for the right reason (matched: '${signature}')"
      passed=$((passed + 1))
    else
      red "${casename} did not produce expected signature: '${signature}'"
      echo "$out" | sed 's/^/      /' >&2
      fail=1
    fi
    rm -rf "$case_dir"
  done < "$APPEND_SIGNATURES"
else
  note "  (no append/bad-signatures.txt — skipped)"
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
