# CLAUDE.md

Strict rules for this repository. Read `docs/workflow.md` before running
the loop: it holds the full workflow, the conventions and the recovery
cases.

## Hard rules

- Never commit, push, create branches or open pull requests by hand. Only
  `scripts/ship.sh`, through the `ship` skill.
- Never create issues by hand. Only `scripts/issue.sh`, through the
  `create-issue` skill.
- Never merge pull requests. The owner merges, with squash and merge.
- Never use GraphQL: it is blocked in cloud sessions. That rules out
  `gh issue create`, `gh issue edit`, `gh issue view`, `gh pr create` and
  `gh pr edit` as direct calls. Read with `gh api` (REST) or the built-in
  GitHub tools.
- After every `publish` and every issue `create`, remove the attribution
  footer with the built-in GitHub tools only, never `gh` or `gh api`, and
  read it back to confirm. See `docs/workflow.md`.
- Never print, log or echo the value of any environment variable.
- Never write a secret, token, email or attribution to an AI tool in code,
  content, commits, issues or pull requests.
- Never offer to watch a pull request after publishing.
- Code, comments, commits, branches, issues and pull requests: English.

## Loop

You are the orchestrator. Dispatch each stage by name with a one-line
prompt (issue number, plan path, mode). Do not read the agent definitions
and do not implement.

    create-issue / refine-issue   (skills, only when needed)
    plan-issue                    (agent, only for non-trivial issues)
    implement-issue               (agent)
    scripts/loop-path.sh          (short -> ship, full -> review)
    review-changes                (agent, full path)
    verify-findings               (agent, only on BLOCKING or IMPORTANT)
    implement-issue, fix mode     (agent, only if verify confirmed fixes)
    ship                          (skill: prepare, publish, footer removal)

There is no owner approval at any stage. The only stop is a BLOCKING open
question in the issue: write it in the issue and stop the loop on it.

## Gate

None declared yet. When the site stack is chosen, the gate command goes
here, and `implement-issue` runs it.