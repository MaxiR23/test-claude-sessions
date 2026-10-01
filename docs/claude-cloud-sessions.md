# Working with Claude Code cloud sessions

Study notes on how Claude Code cloud sessions work and how this repository is set up for them. Everything here comes from the official documentation listed in [References](#references).

## 1. What a cloud session is

A cloud session is a Claude Code session that runs on cloud infrastructure instead of on your machine. By default it runs on infrastructure Anthropic manages. The session keeps running after you close your laptop, and you can check on it or steer it from any device.

You can start a cloud session from:

- **Browser**: [claude.ai/code](https://claude.ai/code), also called Claude Code on the web
- **Mobile**: the **Code** tab in the Claude app
- **Desktop app**: select **Cloud** instead of **Local** when you start a session
- **Terminal**: `claude --cloud "task description"`

When you submit a task, the session runs in four steps:

1. **Clone and prepare**: the repository is cloned to an Anthropic-managed VM, and the environment's setup script runs if one is configured.
2. **Configure network**: internet access is set based on the environment's access level.
3. **Work**: Claude analyzes code, makes changes, runs tests, and checks its work.
4. **Push the branch**: when Claude reaches a stopping point, it pushes its branch to GitHub. You review the diff, leave inline comments, create a PR, or send another message to keep going.

The session does not close when the branch is pushed. PR creation and further edits happen within the same conversation.

### How it differs from a local session

Claude Code behaves the same everywhere. What changes is where the session runs and whether your local configuration is available.

| | Cloud session | Local session |
| :- | :- | :- |
| **Code runs on** | Cloud VM, Anthropic-managed by default | Your machine |
| **You start it from** | claude.ai/code, the mobile app, the Desktop app with **Cloud** selected, or `claude --cloud` | Your terminal, your IDE, or the Desktop app with **Local** selected |
| **Uses your local config** | No, repo only | Yes |
| **Requires GitHub** | Yes | No |
| **Keeps running if you disconnect** | Yes | No |
| **Permission modes** | Accept edits, Plan, Auto | All modes in the terminal |
| **Network access** | Configurable per environment | Your machine's network |

Cloud sessions do not offer the Manual or Bypass permissions modes.

Each cloud session runs in an isolated, Anthropic-managed VM running Ubuntu 24.04 on x86_64, with the repository cloned and common toolchains pre-installed. Git credentials stay outside the sandbox. GitHub operations from the VM go through a GitHub proxy that attaches the credential on the server side.

Cloud sessions stop after a period of inactivity and the VM is reclaimed. Reopening the session from claude.ai/code provisions a fresh VM with the conversation history restored.

## 2. What carries over from the repo and what does not

Cloud sessions start from a fresh clone of the repository. Anything committed to the repo is available. Anything installed or configured only on your own machine is not available in the session.

| | Available in cloud sessions | Why |
| :- | :- | :- |
| The repo's `CLAUDE.md` | Yes | Part of the clone |
| The repo's `.claude/settings.json` hooks and permission rules | Yes, in a session with one repository | Part of the clone |
| The repo's `.claude/rules/` | Yes | Part of the clone |
| The repo's `.claude/skills/`, `.claude/agents/`, `.claude/commands/` | Yes | Part of the clone |
| The repo's `.mcp.json` MCP servers | Yes, in a session with one repository | Part of the clone |
| Plugins declared in the repo's `.claude/settings.json` | No | A cloud session does not install the plugins a repository turns on under `enabledPlugins` |
| Your user `~/.claude/CLAUDE.md` | No | Lives on your machine, not in the repo |
| Your user `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/commands/` | No | Live on your machine, not in the repo. Commit them to the repo's `.claude/` directory instead |
| Plugins enabled only in your user settings | No | User-scoped `enabledPlugins` lives in `~/.claude/settings.json` on your machine |
| MCP servers added with `claude mcp add` at local or user scope | No | Those write to `~/.claude.json` on your machine, not the repo |

The rule of thumb from the docs: to make your own configuration available in cloud sessions, commit it to the repo.

### Subagents in `.claude/agents/`

Subagents defined in the repo's `.claude/agents/` are picked up automatically in cloud sessions and work the same way they do locally. Claude can spawn them with the Agent tool to offload research or parallel work into a separate context window.

Each subagent is a Markdown file with YAML frontmatter. Only `name` and `description` are required:

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

When several locations define a subagent with the same name, Claude Code uses the highest-priority one. Project subagents in `.claude/agents/` take priority over user subagents in `~/.claude/agents/`. The docs recommend checking project subagents into version control so the team can use and improve them collaboratively.

## 3. How attribution is disabled in this repo

By default, Claude Code adds attribution to the commits and pull requests it creates. The `attribution` setting customizes or hides it. It has three keys:

| Key | Type | What it controls |
| :- | :- | :- |
| `attribution.commit` | String | The trailer Claude Code adds to commits. Set to `""` to hide it |
| `attribution.pr` | String | The attribution line in pull request descriptions. Set to `""` to hide it |
| `attribution.sessionUrl` | Boolean | Whether cloud and Remote Control commits include the claude.ai session link. Set to `false` to omit it |

This repo disables all three in `.claude/settings.json`:

```json
{
  "attribution": {
    "commit": "",
    "pr": "",
    "sessionUrl": false
  }
}
```

The older `includeCoAuthoredBy` setting is deprecated. `attribution` replaces it.

### Why it lives in `.claude/settings.json`

Claude Code reads settings from several files. In order of precedence, highest first:

1. Managed settings, deployed by your organization
2. Local project settings: `.claude/settings.local.json`
3. Project settings: `.claude/settings.json`
4. User settings: `~/.claude/settings.json`

The `attribution` setting can be placed in any of these files. For this repo it has to be in the project file for two reasons:

- A cloud session only reads what is in the clone. The user file `~/.claude/settings.json` lives on your machine and is never seen by a cloud session, so a setting placed there would not apply.
- `.claude/settings.local.json` is meant for machine-local overrides and is typically gitignored, so it would not be in the clone either.

`.claude/settings.json` is committed, so every cloud session on this repo reads it. The docs confirm this path: to change a setting for a cloud session in a session with one repository, commit the key to that repository's `.claude/settings.json`.

## 4. Repo rules from CLAUDE.md

`CLAUDE.md` is part of the clone, so these rules load at the start of every cloud session.

### Branches

- Never commit directly to `main`.
- Branch format: `type/short-description`, lowercase, words separated by hyphens.
- Examples: `feat/login-page`, `fix/header-bug`, `docs/setup-notes`
- Allowed types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`, `perf`, `ci`, `build`
- No other prefix is allowed.

### Commits

- Follow Conventional Commits: `type(optional-scope): short description`
- Examples: `feat: add login page`, `fix(header): correct alignment`, `docs: add setup notes`
- Same allowed types as branches.
- Commit messages are written in English, imperative mood, lowercase description, no trailing period.
- One logical change per commit.

### Language

- Code, comments, commits, branches, and pull requests are written in English.

## 5. Setup steps done so far

1. **Connected the GitHub account at claude.ai/code.** This is a one-time step. After signing in with a claude.ai account, claude.ai/code prompts you to connect GitHub and sends you to GitHub's authorization page.
2. **Created this private repo with a README.** Cloud sessions work with existing GitHub repositories. To start a new project, create an empty repository on GitHub first.
3. **Installed the Claude GitHub App on this repo only.** With the GitHub connection, a session can clone any public repository, but can work in a private repository only when the Claude GitHub App is installed on it. Installing it also enables Auto-fix, which lets Claude respond to CI failures and review comments on pull requests.
4. **Kept the Default cloud environment with Trusted network access.** A cloud environment is the saved configuration that controls network access, environment variables, and setup scripts. On Pro and Max plans, onboarding creates the **Default** environment automatically. It uses **Trusted** network access and defines no environment variables or setup script. The four access levels are:

   | Level | Outbound connections |
   | :- | :- |
   | **None** | No outbound network access through the session's network |
   | **Trusted** | Allowlisted domains only: package registries, GitHub, cloud SDKs |
   | **Full** | Any domain |
   | **Custom** | Your own allowlist, optionally including the defaults |

   Whichever level is picked, sessions can still reach GitHub through its separate proxy and the Anthropic API for Claude Code's own requests.

5. **Cloned the repo locally over SSH.** The local checkout is what the terminal uses to pull a cloud session in with `claude --teleport <session-id>`. Teleport must be run from a checkout of the same repository, with a clean git state, and while authenticated to the same claude.ai account. It fetches and checks out the branch from the cloud session and loads the conversation history into the terminal.
6. **Added `.claude/settings.json` to disable attribution.** See [section 3](#3-how-attribution-is-disabled-in-this-repo).
7. **Added `CLAUDE.md` with branch and commit rules.** See [section 4](#4-repo-rules-from-claudemd).

## References

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Get started with Claude Code in the cloud](https://code.claude.com/docs/en/web-quickstart)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
- [Settings reference](https://code.claude.com/docs/en/settings-reference)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
