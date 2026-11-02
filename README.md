# Claude Code Review Team

Video walkthrough (public from 2026-11-11): https://www.youtube.com/watch?v=7JK8book1yw

Three reviewer subagents read every staged diff in parallel. A Hook blocks the commit until all three pass.

| File | What it does |
|---|---|
| `.claude/agents/bug-hunter.md` | Subagent. Bugs only: wrong conditions, off-by-one, dropped error paths. Read-only tools, `sonnet`, 8 turns max |
| `.claude/agents/secret-scanner.md` | Subagent. Keys, tokens, passwords, emails, hostnames. Never repeats the secret. `haiku`, 6 turns max |
| `.claude/agents/scope-checker.md` | Subagent. Compares every hunk against the task you asked for. Flags drive-by renames, import reordering, extra comments, new dependencies |
| `.claude/skills/review-team/SKILL.md` | Skill. Runs `git diff --staged`, launches the three subagents **in parallel, in one message**, shows one table, and writes the marker only when all three say PASS |
| `.claude/hooks/require-review.sh` | Hook (PreToolUse on Bash). Refuses `git commit` unless `.claude/.reviewed` holds the hash of the current staged diff. Consumes the marker on success |
| `.claude/settings.json` | Read-only commands allowed without prompts, a few denied, and the Hook registration |
| `CLAUDE.md` | Branch, staging, secrets and scope rules Claude reads every session |

## Try it

```bash
git clone https://github.com/guardraildev/claude-code-review-team
cd claude-code-review-team
chmod +x .claude/hooks/require-review.sh
claude
```

Ask Claude to change `app/retry.py` and commit. It checks the branch, runs the review team, shows the table, and commits only on three PASS. To see a failure, add a hardcoded token to the file first.

Writing the marker touches `.claude/`, so Claude asks once for permission. Approve it; the marker is a 12-character hash, nothing else.

## Make it yours

- Change the three jobs to the things your team keeps missing in review. Keep one job per agent, and keep the `PASS`/`FAIL` first line so the Skill can read it.
- Keep reviewer tools read-only. A reviewer that can edit files is not a reviewer.
- Give the Skill a name nothing else on your machine has. A personal Skill with the same name wins silently.

## What the Hook does not stop

It is a guardrail against forgetting, not a security boundary.

- It matches the text `git commit`. `git -C . commit`, `git -c key=value commit` and aliases are not recognised. A command that only mentions the text, such as `grep -r "git commit" docs`, is blocked.
- The marker proves that a file with the right hash exists, not that the reviewers ran.
- The hash covers the staged diff when the command starts. `git commit -a` or `git add x && git commit` can include changes the review never saw.
- If the script cannot start, Claude Code shows a `hook error` notice and the commit goes through. On Claude Code v2.1.295 or later, add `"onFailure": "block"` to the hook entry to block instead.
- The deny rules match command text too. They stop the spellings listed, not every way to force-push or delete.

## Changed after the video (2026-11-02)

- The hook path in `settings.json` is quoted. Before, a project path with a space stopped the Hook from starting, and commits went through.
- The Hook no longer needs python3. Before, a machine without python3 let every commit through.
- `Bash(git branch*)` and `Bash(rg *)` are no longer allowed without asking. They also matched `git branch -D` and `rg --pre`, which runs a program. Read-only commands such as `ls`, `cat`, `grep` and read-only `git` run without a prompt anyway.
- More spellings of force-push and `rm -rf` are denied.
