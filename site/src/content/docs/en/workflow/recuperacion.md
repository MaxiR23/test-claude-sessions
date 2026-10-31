---
title: Recovery
sidebar:
  order: 8
description: What to do when a loop stage fails.
---

| What failed | What to do |
| :- | :- |
| Three gate failures in `implement-issue`, plan mode | `plan-issue` writes an addendum from the failing output and `implement-issue` implements it. If that run also fails three times, or the failure was in issue or fix mode, stop and report to the owner with the output |
| `scripts/ship.sh prepare` | If it is about the change, fix it with `implement-issue` in fix mode; otherwise, follow the script's message. Then `prepare` again |
| `scripts/ship.sh publish` before the push | Follow the script's message and go back to `prepare` |
| `scripts/ship.sh publish` after the push and before the PR exists ("branch is pushed but has no open PR") | Retry with `publish` |
| An open decision raised by `implement-issue` | If it is a product or design decision, write it in the issue as a BLOCKING question and stop the loop on that issue |

:::caution
Never run `prepare` after the push: retry with `publish`.
:::

## Sources

- [Subagents](https://code.claude.com/docs/en/sub-agents)
