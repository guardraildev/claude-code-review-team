#!/usr/bin/env bash
# PreToolUse hook for Bash.
# Constraint: a `git commit` is refused until .claude/.reviewed exists for the current staged diff.
# If you remove this file, Claude can commit without running the review-team skill.
# Matches the raw stdin JSON on purpose: parsing it with python3 or jq would let every commit through
# on a machine where that tool is missing. It still only sees the literal text "git commit" (see README).

input=$(cat)

case "$input" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

marker="$CLAUDE_PROJECT_DIR/.claude/.reviewed"
staged_hash=$(git -C "$CLAUDE_PROJECT_DIR" diff --staged | shasum | cut -c1-12)

if [ -f "$marker" ] && [ "$(cat "$marker")" = "$staged_hash" ]; then
  rm -f "$marker"
  exit 0
fi

echo "Blocked: run the review-team skill on the staged diff first, then commit." >&2
exit 2
