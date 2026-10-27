#!/usr/bin/env bash
# test-check-md-links.sh — fixture tests for check-md-links.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKER="${SCRIPT_DIR}/check-md-links.sh"

PASS=0
FAIL=0
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

new_repo() {
  local d="$TMP/$1"
  mkdir -p "$d/sub" "$d/chronicle/source/x"
  git -C "$d" init -q
  echo "$d"
}

expect() {
  local name="$1" want_rc="$2" want_msg="$3" repo="$4"
  git -C "$repo" add -A
  local out rc
  out="$("$CHECKER" "$repo" 2>&1)" && rc=0 || rc=$?
  if [[ $rc -ne $want_rc ]]; then
    echo "  ✗ ${name} — exit $rc, wanted $want_rc"; FAIL=$((FAIL+1)); echo "$out" | sed 's/^/      /'
  elif [[ -n "$want_msg" ]] && ! grep -qF "$want_msg" <<<"$out"; then
    echo "  ✗ ${name} — missing '${want_msg}'"; FAIL=$((FAIL+1)); echo "$out" | sed 's/^/      /'
  else
    echo "  ✓ ${name}"; PASS=$((PASS+1))
  fi
}

echo "check-md-links.sh fixtures"

r=$(new_repo ok)
echo "x" > "$r/sub/target.md"
printf '[a](sub/target.md) [b](sub/target.md#frag) [c](https://example.com) [d](#top) [e](mailto:a@b.c)\n' > "$r/README.md"
printf '[up](../README.md)\n' > "$r/sub/other.md"
expect "valid, anchor, http, mailto and ../ links pass" 0 "" "$r"

r=$(new_repo broken)
printf '[gone](sub/missing.md)\n' > "$r/README.md"
expect "missing target fails and is named" 1 "README.md -> sub/missing.md" "$r"

r=$(new_repo broken_frag)
printf '[gone](missing.md#section)\n' > "$r/README.md"
expect "fragment is stripped before the existence check" 1 "README.md -> missing.md" "$r"

r=$(new_repo rel)
printf '[gone](../nope.md)\n' > "$r/sub/a.md"
expect "relative to the linking file's directory" 1 "sub/a.md -> ../nope.md" "$r"

r=$(new_repo excluded)
printf '[gone](missing.md)\n' > "$r/chronicle/source/x/synthesis.md"
expect "chronicle/source is excluded" 0 "" "$r"

r=$(new_repo dirlink)
printf '[d](sub)\n' > "$r/README.md"
expect "directory targets resolve" 0 "" "$r"

r=$(new_repo codespan)
printf 'Use `[x](nope.md)` syntax and `a](b)` too. [real](README.md)\n' > "$r/README.md"
expect "links inside inline code spans are ignored" 0 "" "$r"

r=$(new_repo scheme)
printf '[a](ftp://x.com/f) [b](tel:+123) [c](vscode://file/x) [d](data:text/plain,hi)\n' > "$r/README.md"
expect "any URI scheme is skipped" 0 "" "$r"

r=$(new_repo angle)
echo x > "$r/sub/with space.md"
printf '[a](<sub/with space.md>)\n' > "$r/README.md"
expect "angle-bracket target with spaces resolves" 0 "" "$r"

r=$(new_repo angle_broken)
printf '[a](<sub/no such.md>)\n' > "$r/README.md"
expect "broken angle-bracket target fails" 1 "README.md -> sub/no such.md" "$r"

r=$(new_repo tilde)
printf '~~~\n[a](nope.md)\n~~~\n[b](README.md)\n' > "$r/README.md"
expect '~~~ fences are ignored like backtick fences' 0 "" "$r"

echo
echo "  ${PASS} passed, ${FAIL} failed"
[[ $FAIL -eq 0 ]]
