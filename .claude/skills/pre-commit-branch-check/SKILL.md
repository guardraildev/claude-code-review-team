---
name: pre-commit-branch-check
description: Run before any git commit, push, merge, rebase, or cherry-pick. Confirms the current branch is the one we intend to change and stops on shared branches.
---

1. Run `git branch --show-current`.
2. State the branch name to the user in one line: "Current branch: <name>".
3. If the branch is `main`, `master`, or `develop`, stop and ask whether to create a feature branch instead.
4. If the user named a target branch earlier in the conversation and it does not match, stop and ask.
5. Only then continue with the git operation.
