---
title: Introduction
sidebar:
  order: 1
description: What to prepare so a Claude Code cloud session works well in this repo.
---

A cloud session starts from a clean clone of the repo on a virtual machine managed by Anthropic. There is no personal git configuration, no local variables, and no `gh` session of yours. Everything the session needs has to come from the cloud environment or from files committed to the repo.

This chapter follows the order in which the setup is built:

1. [Environment variables](/en/configuracion/variables-de-entorno/): the git identity used to sign commits.
2. [Connecting to GitHub](/en/configuracion/conexion-github/): how the Claude account reaches your repos.
3. [The GitHub proxy](/en/configuracion/proxy-github/): what the proxy does and what limits it imposes.
4. [Attribution](/en/configuracion/atribucion/): how to stop Claude Code from signing commits and PRs.

:::caution
Never print, log or show the value of an environment variable. This applies to tokens, to the identity and to any other variable.
:::

What each page calls an observation is something I saw while testing this repo. It is not described in the official documentation and it may change. It always goes in a separate box.

## Sources

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
