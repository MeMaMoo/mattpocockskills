#!/usr/bin/env bash
set -euo pipefail

# Local delta check for the `live` branch (MeMaMoo/mattpocockskills). Upstream's
# `code-review` skill is renamed `code-review-two-axis` here so it never shadows
# or gets confused with Claude Code's built-in `/code-review`. Every upstream
# merge brings new text that says `code-review`; run this after resolving the
# merge, and fix every hit it prints.
#
# Allowed, and so not reported:
#   - aihero.dev/skills-code-review URLs: Matt's site, not a skill name.
#   - Lines that talk about Claude Code's own built-in `/code-review`.
#   - CHANGELOG.md and .changeset/: release history, left as upstream wrote it.

REPO="$(cd "$(dirname "$0")/.." && pwd)"

hits="$(
  git -C "$REPO" grep -nP '(?<!skills-)\bcode-review(?!-two-axis|er)\b' -- . ':!CHANGELOG.md' ':!.changeset' ':!scripts/check-rename.sh' \
    | grep -vE "(Claude Code's own|Claude Code ships its own) \`/code-review\`" \
    || true
)"

if [ -n "$hits" ]; then
  echo "code-review not renamed to code-review-two-axis:" >&2
  echo "$hits" >&2
  exit 1
fi
echo "ok: every code-review reference is code-review-two-axis"
