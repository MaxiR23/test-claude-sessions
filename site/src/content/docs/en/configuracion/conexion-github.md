---
title: Connecting to GitHub
sidebar:
  order: 3
description: The two methods to connect a Claude account to GitHub and what changes in each one.
---

Cloud sessions need GitHub to clone repos and push branches. There are two documented ways to connect the Claude account.

| Method | How it connects | Repos the sessions can reach |
| :- | :- | :- |
| **Claude GitHub App** | You authorize the App during onboarding in the browser, at claude.ai/code | Any public repo, and private ones where the App is installed |
| **`/web-setup`** | You run `/web-setup` in the Claude Code CLI | Any repo the local `gh` token can reach, whether or not the App is installed |

## What the documentation says about each method

- **`/web-setup` syncs the local `gh` token.** It reads the token that `gh auth token` prints, asks you to confirm, and sends it to Anthropic, where it is stored encrypted with the claude.ai account. If you had already connected GitHub from the browser, it warns that continuing replaces that connection.
- **The scope depends on the method**, as in the table. With the App, a private repo is reachable only if the App is installed on it. With `/web-setup`, the scope is whatever the `gh` token can see.
- **The App is required for Auto-fix.** Auto-fix, where Claude watches a pull request and responds to CI failures and review comments, requires the Claude GitHub App installed on the repo. Threads inside a project also need it on every repo they clone, whichever the method.
- **The connection is managed from the connectors page.** Disconnecting GitHub at claude.ai/customize/connectors deletes the credentials that sessions use, whether they came from the browser or from `/web-setup`. Sessions lose access until you connect GitHub again.

:::caution
If you want Auto-fix, `/web-setup` is not enough: you need the Claude GitHub App on the repo.
:::

With both methods the credentials stay encrypted on Anthropic's servers and never enter the session VM. GitHub operations go through the proxy that [The GitHub proxy](/en/configuracion/proxy-github/) explains.

This repo is connected with `/web-setup`.

:::note[Observation]
With the Claude GitHub App, label and assignee events showed up in the PR timeline with the suffix "with Claude".
:::

:::note[Observation]
After connecting GitHub with `/web-setup` instead of the App, those same events showed up without the "with Claude" suffix.
:::

For why a personal `GH_TOKEN` is not used, see [Environment variables](/en/configuracion/variables-de-entorno/).

## Sources

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Get started with Claude Code in the cloud](https://code.claude.com/docs/en/web-quickstart)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
