---
title: The GitHub proxy
sidebar:
  order: 4
description: How GitHub operations go through the cloud session proxy and what limits it has.
---

In Anthropic-hosted environments, all GitHub operations go through a dedicated proxy that keeps the real credentials outside the VM. It applies regardless of the environment's network access level.

## `gh` and the `proxy-injected` placeholder

The `gh` CLI comes preinstalled in sessions and reads `GH_TOKEN` on its own, so `gh auth login` is never needed. When there is no `GH_TOKEN` or `GITHUB_TOKEN` in the environment, both variables hold the text `proxy-injected` inside the session and the proxy substitutes the real credentials in outgoing requests to GitHub.

:::caution
`gh` works in that case, but a script that reads the variable directly gets the placeholder, not a usable token.
:::

## REST instead of GraphQL

The proxy serves only a fixed set of GraphQL operations for pull request flows and rejects everything else with a 403 that names the REST alternative: `gh api repos/{owner}/{repo}/...`. The restriction applies to every request that goes through the proxy, with any credential, so a `GH_TOKEN` in the environment gets the same 403.

Several `gh` subcommands use GraphQL under the hood: `gh pr list`, `gh pr view` and `gh repo view`, among others. That is why `scripts/ship.sh`, `scripts/issue.sh` and `scripts/merge.sh` read over REST, and `scripts/ship.sh` only falls back to the REST API when `gh pr create` or `gh pr edit` fails.

:::tip
To read an issue without GraphQL, use the REST form:

```text frame="terminal" title="read an issue over REST"
gh api repos/[USUARIO]/[REPO]/issues/[N]
```
:::

## Other proxy rules

- **Push protection.** `git push` through the proxy works only against the session's current working branch. Cloning, fetching and operating on pull requests work normally.
- **Per-repo scope.** Requests to the GitHub API reach only the repos attached to the session. Any other repo gets a 403.

:::note[Observation]
The session is told to push to a `claude/...` branch, but `scripts/ship.sh` pushes the `type/short-description` branch it created. The push worked anyway.
:::

:::note[Observation]
Renaming a repo breaks `gh api` through the proxy. A session cloned under the old name resolves the placeholders with that name, GitHub answers with a redirect to a path with a numeric ID, and the proxy rejects that path with a 403. With the new name there is also a 403 if the session does not have the repo attached under that name. `git fetch` and `git push` with the old name kept working. The `gh api` calls stayed broken until the repo was attached to the session under the new name.
:::

## Sources

- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
- [REST API: issues](https://docs.github.com/en/rest/issues/issues)
- [REST API: pull requests](https://docs.github.com/en/rest/pulls/pulls)
