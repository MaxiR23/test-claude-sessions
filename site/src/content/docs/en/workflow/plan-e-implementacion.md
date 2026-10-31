---
title: Plan and implementation
sidebar:
  order: 3
description: When there is a plan, how it is implemented and what the gate is.
---

## When there is a plan

`plan-issue` runs for issues that add or change behavior, a page, a component or the structure of the site. A typo, a documentation-only tweak or a configuration change goes straight to `implement-issue`, and the issue's scope and acceptance criteria act as the plan.

The plan is in force as written: there is no confirmation step.

## Implement

`implement-issue` reads the plan, not the sources the plan cites, and returns the diff stat when it finishes.

## Verify locally: the gate

The gate is the command that `CLAUDE.md` declares. In this repo it is the site build.

```text frame="terminal" title="gate"
pnpm --dir site build
```

`implement-issue` runs it only once, when the plan is implemented. If it fails, it fixes and runs it again, up to three attempts. After that it stops and reports. If `CLAUDE.md` declares no gate, it says so and moves on.

## Sources

- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Astro CLI reference](https://docs.astro.build/en/reference/cli-reference/)
