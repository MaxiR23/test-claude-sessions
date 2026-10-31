---
title: Review
sidebar:
  order: 4
description: How the short or full path is chosen, and what the review looks like.
---

`scripts/loop-path.sh` prints `short` or `full` depending on the changed files.

## Short path

It prints `short` only when all changed files are `.md` and none is `CLAUDE.md` or under `.claude/` or `.github/`. Anything else is `full`. There is no partial path: the script decides, not anyone's judgment.

```text frame="terminal" title="short path"
implement-issue -> scripts/loop-path.sh -> ship
```

## Full path

1. `review-changes` runs once, on the diff against `origin/main` plus whatever is uncommitted.
2. `verify-findings` runs only if the review reports BLOCKING or IMPORTANT findings.
3. `implement-issue` in fix mode fixes what `verify-findings` confirmed, in a single cycle.

Minor findings that remain open are listed in the PR body, for review before the merge.

## Sources

- [Subagents](https://code.claude.com/docs/en/sub-agents)
