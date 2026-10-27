#!/usr/bin/env bash
# check-md-links.sh — fail if a tracked *.md links to a relative path that does not exist
#
# Usage: check-md-links.sh [repo-root]
#
# Skips #anchor targets and anything with a URI scheme (http, mailto, ...), strips #fragment, resolves the
# rest against the linking file's directory. Links inside fenced code blocks
# (``` or ~~~) and inline code spans are ignored; <angle-bracket> targets may
# contain spaces. evals/runs/, chronicle/source/ and chronicle/proposals/ are
# excluded (captured run output and ingested material, not authored docs).

set -uo pipefail

ROOT="$(cd "${1:-.}" && pwd)"
cd "$ROOT"

BROKEN=0
CHECKED=0

while IFS= read -r md; do
  [[ -f "$md" ]] || continue
  dir="$(dirname "$md")"
  while IFS= read -r target; do
    case "$target" in
      \#*|"") continue ;;
    esac
    [[ "$target" =~ ^[a-z][a-z0-9+.-]*: ]] && continue
    path="${target%%#*}"
    [[ -z "$path" ]] && continue
    CHECKED=$((CHECKED+1))
    if [[ ! -e "$dir/$path" ]]; then
      echo "  ✗ $md -> $target"
      BROKEN=$((BROKEN+1))
    fi
  done < <(awk '/^[[:space:]]*(```|~~~)/{f=!f; next} !f {gsub(/`[^`]*`/, ""); print}' "$md" | grep -oE '\]\((<[^>]+>|[^)[:space:]]+)' | sed -e 's/^](//' -e 's/^<//' -e 's/>$//')
done < <(git ls-files '*.md' | grep -v -E '^(evals/runs|chronicle/source|chronicle/proposals)/')

if [[ $BROKEN -eq 0 ]]; then
  echo "✓ $CHECKED relative markdown links resolve"
else
  echo "✗ $BROKEN broken relative markdown link(s)" >&2
  exit 1
fi
