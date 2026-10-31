# Team rules

## Before any commit, push, merge, or rebase

1. Run `git branch --show-current`.
2. Tell me the branch name before you do anything else.
3. If it is `main`, `master`, or `develop`, stop and ask me.

## Staging

- Never run `git add -A` or `git add .`.
- Name every file you stage.

## Secrets

- No credentials, tokens, emails, or connection strings in commit messages, PR text, or code comments.
- Before committing, read `git diff --staged` and remove anything that looks like a secret.

## Scope

- Change only what I asked for. No drive-by renames, import reordering, or extra comments.
