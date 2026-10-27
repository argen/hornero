#!/usr/bin/env bash
# test-validate-skill.sh — fixture-based tests for validate-skill.sh
#
# Each case builds a temp SKILL.md and asserts validate-skill.sh either
# passes or rejects it for the *right* reason. Run from the repo root.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="${SCRIPT_DIR}/validate-skill.sh"

if [[ ! -x "$VALIDATOR" ]]; then
  echo "✗ validator not executable at $VALIDATOR" >&2
  exit 1
fi

PASS=0
FAIL=0
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

assert_pass() {
  local name="$1" file="$2"
  if "$VALIDATOR" "$file" >/dev/null 2>&1; then
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  else
    echo "  ✗ ${name} — expected pass but failed"; FAIL=$((FAIL+1))
    "$VALIDATOR" "$file" 2>&1 | sed 's/^/      /'
  fi
}

assert_fail() {
  local name="$1" file="$2" expect_msg="$3"
  local out
  out="$("$VALIDATOR" "$file" 2>&1)" && rc=0 || rc=$?
  if [[ $rc -eq 0 ]]; then
    echo "  ✗ ${name} — expected failure but passed"; FAIL=$((FAIL+1))
  elif ! echo "$out" | grep -qF "$expect_msg"; then
    echo "  ✗ ${name} — failed but wrong reason; expected '${expect_msg}'"; FAIL=$((FAIL+1))
    echo "$out" | sed 's/^/      /'
  else
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  fi
}

assert_output() {
  local name="$1" file="$2" expect_msg="$3"
  local out
  out="$("$VALIDATOR" "$file" 2>&1)" && rc=0 || rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "  ✗ ${name} — expected pass (warning only) but failed"; FAIL=$((FAIL+1))
  elif ! echo "$out" | grep -qF "$expect_msg"; then
    echo "  ✗ ${name} — passed but missing output '${expect_msg}'"; FAIL=$((FAIL+1))
  else
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  fi
}

# write_skill <file> <name-line> <description-line> [extra body lines]
write_skill() {
  local file="$1" name_line="$2" desc_line="$3" extra="${4:-}"
  {
    echo "---"
    echo "$name_line"
    echo "$desc_line"
    echo "type: skill"
    echo "---"
    echo
    echo "## Purpose"; echo; echo "Why."; echo
    echo "## Key Concepts"; echo; echo "What."; echo
    echo "## Application"; echo; echo "How."; echo
    echo "## Examples"; echo; echo "Eg."; echo
    echo "## Common Pitfalls"; echo; echo "Watch out."; echo
    echo "## References"; echo; echo "- A source."
    [[ -n "$extra" ]] && printf '%s\n' "$extra"
  } > "$file"
}

echo "validate-skill.sh fixtures"

write_skill "$TMP/good.md" "name: good" "description: Use when planning a launch."
assert_pass "plain description passes" "$TMP/good.md"

write_skill "$TMP/quoted.md" "name: quoted" 'description: "Use when `type: stakeholder` entries change."'
assert_pass "double-quoted description with ': ' passes" "$TMP/quoted.md"

write_skill "$TMP/single.md" "name: single" "description: 'Use when type: x changes.'"
assert_pass "single-quoted description with ': ' passes" "$TMP/single.md"

write_skill "$TMP/colon.md" "name: colon" 'description: Use when `type: stakeholder` changes.'
assert_fail "unquoted description with ': ' fails" "$TMP/colon.md" \
  "frontmatter: description must be quoted (contains ': ' or YAML indicator)"

write_skill "$TMP/tick.md" "name: tick" 'description: `Backticked` start.'
assert_fail "unquoted description starting with backtick fails" "$TMP/tick.md" \
  "frontmatter: description must be quoted (contains ': ' or YAML indicator)"

write_skill "$TMP/star.md" "name: star" 'description: *emphasis* start.'
assert_fail "unquoted description starting with * fails" "$TMP/star.md" \
  "frontmatter: description must be quoted (contains ': ' or YAML indicator)"

write_skill "$TMP/namecolon.md" "name: bad: name" "description: ok."
assert_fail "unquoted name with ': ' fails" "$TMP/namecolon.md" \
  "frontmatter: name must be quoted (contains ': ' or YAML indicator)"

MSG_Q="frontmatter: description must be quoted (contains ': ' or YAML indicator)"

write_skill "$TMP/coltab.md" "name: coltab" $'description: Use when a:\tb changes.'
assert_fail "unquoted description with ':<TAB>' fails" "$TMP/coltab.md" "$MSG_Q"

write_skill "$TMP/colend.md" "name: colend" 'description: Use when the key is:'
assert_fail "unquoted description ending in ':' fails" "$TMP/colend.md" "$MSG_Q"

for ch in '-' '?' ',' ']' '}'; do
  write_skill "$TMP/ind.md" "name: ind" "description: ${ch}leading indicator."
  assert_fail "unquoted description starting with '${ch}' fails" "$TMP/ind.md" "$MSG_Q"
done

write_skill "$TMP/hash.md" "name: hash" 'description: Use when planning # not a comment.'
assert_fail "unquoted description containing ' #' fails" "$TMP/hash.md" \
  "frontmatter: description must be quoted (contains ' #' comment start)"

write_skill "$TMP/hashok.md" "name: hashok" 'description: Use when issue#12 changes.'
assert_pass "unquoted description with '#' not preceded by space passes" "$TMP/hashok.md"

write_skill "$TMP/hashq.md" "name: hashq" 'description: "Use when planning # fine."'
assert_pass "quoted description containing ' #' passes" "$TMP/hashq.md"

write_skill "$TMP/unclosed.md" "name: unclosed" 'description: "Use when the quote never closes.'
assert_fail "opening double quote without closing quote fails" "$TMP/unclosed.md" \
  "frontmatter: description has an unclosed quote"

write_skill "$TMP/unclosedn.md" "name: unclosedn" 'description: ok.' 
sed -i.bak 's/^name: unclosedn/name: "unclosedn/' "$TMP/unclosedn.md"
assert_fail "name with unclosed double quote fails" "$TMP/unclosedn.md" \
  "frontmatter: name has an unclosed quote"

long="$(printf 'a%.0s' $(seq 1 1024))"
write_skill "$TMP/len1024.md" "name: len1024" "description: ${long:0:1013}"
assert_pass "description at exactly 1024 chars passes" "$TMP/len1024.md"

write_skill "$TMP/len1025.md" "name: len1025" "description: ${long}b"
assert_fail "description over 1024 chars fails" "$TMP/len1025.md" \
  "description exceeds 1024 characters"

write_skill "$TMP/longq.md" "name: longq" "description: \"${long}b\""
assert_fail "quoted description over 1024 chars fails" "$TMP/longq.md" \
  "description exceeds 1024 characters"

write_skill "$TMP/big.md" "name: big" "description: ok." "$(seq 1 520 | sed 's/^/line /')"
assert_output "file over 500 lines warns but passes" "$TMP/big.md" \
  "⚠ over 500 lines; consider moving depth to a sibling reference.md"

echo
echo "  ${PASS} passed, ${FAIL} failed"
[[ $FAIL -eq 0 ]]
