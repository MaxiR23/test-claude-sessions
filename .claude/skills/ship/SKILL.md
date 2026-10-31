---
name: ship
description: >-
  Takes a finished issue of this repo to its pull request: commits by
  explicit path through scripts/ship.sh, writes the PR body, publishes, removes
  the attribution footer and stops at a PR ready to review. Use when the
  loop reaches its last step,
  or when asked to "ship issue #N", "prepare the PR" or "publish the PR".
---

# Ship

`scripts/ship.sh` does everything mechanical (branch, commit, push, PR).
This skill does the two parts that need judgment: which files belong to the
change, and the PR body.

**Mutation posture.** Prepare commits on a `type/short-description`
branch and writes to `.claude/loop/`. Publish pushes and opens or updates
one PR, then removes the attribution footer. It never merges: a person
reviews and merges.

## Prepare

1. Preconditions: `scripts/loop-path.sh` printed `short`, or a
   `review-<N>.md` exists in `.claude/loop/` and every BLOCKING or
   IMPORTANT finding was fixed (then `verify-<N>.md` exists). Minors still
   open go in the body. If a precondition fails, stop and say what is
   missing.
2. List the files of the change with `git status --short`. Keep only those
   the plan, the fix list or the issue justify. A file none of them
   mentions: stop and name it.
3. Run `scripts/ship.sh prepare <N> <path> <path> ...`. If it fails, show
   its error and stop.
4. Write `.claude/loop/pr-<N>.body.md`:
   - First line exactly `Closes #<N>`.
   - `## Summary`: what changed, a few bullets.
   - `## Verification`: what the gate, the review or a check verified.
   - `## Still to check by eye`: what only a person in a browser can
     judge, if anything.
   - `## Open minors`: unfixed MINOR findings, if any.
   - No HTML comments. No attribution to an AI tool anywhere: the word
     "Claude" alone makes publish fail, so describe the footer as "the
     attribution footer".

## Publish

Run `scripts/ship.sh publish <N>` right after prepare, without waiting for
approval. Then follow the footer removal step in `CLAUDE.md` with the
built-in GitHub tools only, and read the PR back to confirm.

Report the PR URL and the last 3 lines of the body, then stop. The loop ends
at a PR ready to review; a person reviews and merges it.

## Critical gotchas

1. Never read previous PRs, commits or branches to learn their shape.
2. Never stage by hand, never `git add .`, `-A` or `-p`: paths go to the
   script.
3. Never `--no-verify`, never force push, never push to `main`, never
   merge a pull request in any way.
4. If the script stops, do not work around it. Report the error.
5. Nothing to deliver means saying so, never inventing a change.
6. Never offer to watch the PR afterwards.
7. Never print, log or echo the value of any environment variable.
