---
title: Issues
sidebar:
  order: 2
description: How to write an issue so the loop can work on it.
---

Every change starts in an issue.

- **Title**: `type: short description`, lowercase, one line, no trailing period. `scripts/issue.sh` builds it from the type and the description.
- **Allowed types**: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`, `perf`, `ci`, `build`.
- **Label**: exactly one, equal to the type. `scripts/ship.sh` takes the branch type from the label and the commit message from the title.
- **Body**: `## Scope`, `## Out of scope`, `## Acceptance criteria` (as checkboxes) and `## Open questions` only if there are any, each one marked BLOCKING or DEFERRABLE.

```text title="example title"
docs: write the setup and workflow guide
```

The `create-issue` skill drafts it and creates it with `scripts/issue.sh`. The `refine-issue` skill fills in the missing sections of an existing issue. An issue that already has the three sections is not refined.

Issues are created only with `scripts/issue.sh`, never with `gh issue create`, which uses GraphQL and the proxy blocks it. See [The GitHub proxy](/en/configuracion/proxy-github/).

:::tip
Freeze the scope: the scope is the issue body when the loop starts. What shows up midway is a new issue, not an expansion of the one that is running.
:::

:::caution
A BLOCKING question stops the loop on that issue until the answer is written in the issue. Nothing is planned on an assumption.
:::

## Sources

- [REST API: issues](https://docs.github.com/en/rest/issues/issues)
- [Skills](https://code.claude.com/docs/en/skills)
