---
name: review-team
description: Run before any git commit. Sends the staged diff to three reviewer subagents in parallel (bugs, secrets, scope), reports their findings, and writes the review marker the commit hook requires only when all three pass.
---

1. Run `git diff --staged`. If it is empty, say so and stop.
2. Launch these three subagents **in parallel, in one message**, each with the task the user asked for in the prompt:
   - `bug-hunter`
   - `secret-scanner`
   - `scope-checker`
3. Wait for all three. Show the user one table: reviewer, PASS/FAIL, findings.
4. If any reviewer says FAIL, stop. Do not write the marker. Fix only what the user agrees to fix, then start again from step 1.
5. If all three say PASS, write the marker:
   ```bash
   git diff --staged | shasum | cut -c1-12 > .claude/.reviewed
   ```
6. Tell the user the review passed and the commit is unblocked.
