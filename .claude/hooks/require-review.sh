#!/usr/bin/env bash
# PreToolUse hook for Bash.
# Constraint: a `git commit` is refused until .claude/.reviewed exists for the current staged diff.
# If you remove this file, Claude can commit without running the review-team skill.

input=$(cat)
cmd=$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)

case "$cmd" in
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
