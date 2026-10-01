# Cloud session setup and rule enforcement

How this repository is configured for Claude Code cloud sessions, what each setting solves, and what was observed while testing. Documented behavior comes only from the official pages listed in [References](#6-references). Anything seen while testing is labeled as an observation in [section 5](#5-observed-behavior-in-this-repo).

## 1. Cloud environment variables

A cloud environment is the saved configuration a cloud session runs in. It controls network access, environment variables, and setup scripts. Environment variables use `.env` format, one `KEY=value` pair per line, and a session reads them into ordinary environment variables that any command run in the session can read.

Two things apply to every variable set this way:

- **Visibility.** Anyone who uses the environment can read the values. The environment form says the same next to the variables box. Do not put a value there that other users of the environment must not see.
- **When they apply.** A session reads the environment's values when it is created, and again each time Claude Code starts in the session's VM, which happens when an idle VM is restored or when a reclaimed VM is rebuilt. After a variable is edited, added, or removed, an existing session keeps the values it last read until its VM is next restored or rebuilt. In practice: save the variables, then start a new session.

This repository relies on two groups of variables.

### Git identity

| Variable | Purpose |
| :- | :- |
| `GIT_AUTHOR_NAME` | Name recorded as the commit author |
| `GIT_AUTHOR_EMAIL` | Email recorded as the commit author |
| `GIT_COMMITTER_NAME` | Name recorded as the committer |
| `GIT_COMMITTER_EMAIL` | Email recorded as the committer |

Git reads these variables before any `user.name` or `user.email` configuration. A cloud session starts from a fresh clone with no personal git configuration, so without them the commits a session creates are authored as `Claude <noreply@anthropic.com>`. That is the identity observed in this repository before the variables were set, not a behavior the official pages describe.

Set all four to your own name and email. For the email, use the noreply address that GitHub provides for your account, in the form `<id>+<username>@users.noreply.github.com`, so commits are linked to your GitHub account without exposing a personal address. The real value is not written here on purpose.

### `GH_TOKEN`

`GH_TOKEN` is a GitHub personal access token that the session uses for GitHub API calls. The official pages document the two cases:

- **Token set.** The value passes through to the container unchanged, so scripts and the `gh` CLI use it directly. Requests are then made as the account that owns the token, in this repository the owner, instead of through the Claude GitHub App.
- **Token not set.** The GitHub proxy authenticates for the session. See [section 3](#3-github-access-from-cloud-sessions).

For this repository the token is a fine-grained personal access token with:

- **Repository access** limited to this repository only.
- **Permissions**: Contents, Issues, and Pull requests, each set to read and write.
- **An expiration date**, so a leaked or forgotten token stops working on its own.

A token set as an environment variable is visible to anyone who uses the environment, like any other variable. Never commit it, never paste it into an issue, a pull request, or a document, and never print it from a session. To check whether it is present, test only that the variable is non-empty.

## 2. Attribution settings

By default Claude Code adds attribution to the commits and pull requests it creates. The `attribution` setting customizes or hides it. It can live in any settings file. This repository sets it in `.claude/settings.json`, because a cloud session reads only what is in the clone, and the official pages say that to change a setting for a cloud session with one repository you commit the key to that repository's `.claude/settings.json`.

```json
{
  "attribution": {
    "commit": "",
    "pr": "",
    "sessionUrl": false
  }
}
```

| Key | Type | What it controls |
| :- | :- | :- |
| `attribution.commit` | string | Changes or hides the trailer Claude Code adds to commit messages. `""` hides it |
| `attribution.pr` | string | Changes or hides the attribution line in pull request descriptions. `""` hides it |
| `attribution.sessionUrl` | boolean | Whether cloud and Remote Control commits include the claude.ai session link. `false` omits it |

The older `includeCoAuthoredBy` setting is deprecated. `attribution` replaces it.

### What these settings do not cover

- **The git author and committer identity.** `attribution.commit` only controls the trailer appended to the commit message. The name and email recorded on the commit come from the git identity in [section 1](#git-identity).
- **The footer added to pull request bodies.** Setting `attribution.pr` to `""` did not stop a footer from being appended to pull request bodies in this repository. See [section 5](#5-observed-behavior-in-this-repo). The official pages do not describe this footer, so treat it as an observation.

## 3. GitHub access from cloud sessions

In Anthropic-hosted environments, all GitHub operations go through a dedicated GitHub proxy that keeps the real GitHub credentials outside the session's VM. The proxy applies regardless of the environment's network access level.

### `gh` and the `proxy-injected` placeholder

The `gh` CLI is pre-installed in cloud sessions and reads `GH_TOKEN` automatically, so `gh auth login` is never needed. When neither `GH_TOKEN` nor `GITHUB_TOKEN` is set in the environment, both variables read as the placeholder string `proxy-injected` inside the session, and the proxy substitutes the real credentials on outbound GitHub requests. `gh` works in that case, but a script that reads the variable directly gets the placeholder, not a usable token.

When `GH_TOKEN` is set in the environment, as in this repository, the value is used directly and the requests are made as the token's owner.

### REST instead of GraphQL

The proxy serves only a pinned set of GraphQL operations for pull request workflows and rejects everything else on the GraphQL endpoint with a 403 that names the REST fallback, `gh api repos/{owner}/{repo}/...`. The restriction applies to every request through the proxy regardless of the credentials supplied, so a `GH_TOKEN` set in the environment gets the same 403.

Several `gh` subcommands use GraphQL under the hood, among them `gh pr list`, `gh pr view`, and `gh repo view`. That is why `scripts/ship.sh` reads issues, labels, and pull requests through REST with `gh api` and only falls back to the REST API when `gh pr create` or `gh pr edit` fails.

### Other proxy rules worth knowing

- **Push protection.** `git push` through the proxy works only against the session's current working branch. Cloning, fetching, and pull request operations work normally.
- **Repository scope.** GitHub API requests reach only repositories attached to the session. A request for any other repository gets a 403.

## 4. Rule enforcement with `scripts/ship.sh`

### Why rules are enforced by code

`CLAUDE.md` states the branch, commit, and pull request rules of this repository, and every cloud session loads it. Instructions, however, are advice: a session can misread them, forget them after a long conversation, or follow a harness instruction that contradicts them, such as the branch name a cloud session is told to push to. A script cannot be talked out of a check. `scripts/ship.sh` turns each rule into a test that either passes or stops the run with a message, so a session that follows `CLAUDE.md` and a session that does not both end up with the same branch name, the same commit message, and the same pull request shape.

The script enforces, among other things:

- Exactly one type label on the issue, and an issue title of the form `type: description` whose type matches the label.
- A branch named `type/short-description`, created from an up-to-date `main`, with the type taken from the issue label.
- The commit message taken from the issue title, so it follows Conventional Commits by construction.
- A refusal to commit as an Anthropic noreply identity, and a refusal of `Co-Authored-By` and `Claude-Session` trailers.
- A refusal to stage environment files, local settings, and working files under `.claude/loop/`.
- A pull request body whose first line is `Closes #<issue>` and that contains no attribution.

### The `prepare`, approval, `publish` workflow

1. **`scripts/ship.sh prepare <issue> [path ...]`** reads the issue, checks the label and the title, fetches `origin`, creates the branch when on `main`, validates every path, commits the paths with the issue title as the message, and writes `.claude/loop/pr-<issue>.meta` with the title, label, base, branch, commit, and mode (`create` or `update #<pr>`). It then prints the meta file and the branch log and stops.
2. **The session writes `.claude/loop/pr-<issue>.body.md`** and waits. Nothing has been pushed at this point. The owner reads the branch log and the body and decides whether to approve.
3. **`scripts/ship.sh publish <issue>`** runs only after the owner's approval. It validates the body, re-reads the meta file, requires the same branch and the same commit with no uncommitted tracked changes, checks that the label exists, re-checks the open pull request against the recorded mode, pushes the branch, and creates or updates the pull request with the base, title, label, assignee, and body.

The split matters: `prepare` is cheap to redo and touches nothing outside the clone, while `publish` is the only step that reaches GitHub for writes, and it refuses to run if anything changed since `prepare`. `.claude/loop/` is listed in `.gitignore`, so the meta and body files never enter a commit.

## 5. Observed behavior in this repo

The following was observed while testing cloud sessions on this repository. None of it is described by the official pages in [section 6](#6-references), so treat it as observation, not documented behavior, and expect it to change.

- **A "Generated by Claude Code" footer was appended to pull request bodies**, both when the pull request was created and when it was edited, even with `attribution.pr` set to `""`. The `attribution.pr` setting documents the attribution line in the description; the footer seen here was added on top of the body passed to `gh`.
- **Label and assignee events showed "with Claude"** in the pull request timeline when the session acted through the Claude GitHub App, that is, without `GH_TOKEN` set. This is one reason the repository sets `GH_TOKEN`: with it, the same events are attributed to the owner.
- **Pushing to a branch other than the session-assigned one worked.** A cloud session is told to push to a `claude/...` branch, while `scripts/ship.sh` pushes the `type/short-description` branch it created. The push went through.
- **A renamed repository breaks `gh api repos/{owner}/{repo}/...` through the proxy.** This repository was renamed from `test-clause-sessions` to `test-claude-sessions`. A session cloned under the old name resolves the placeholders to the old name, GitHub answers with a redirect to a numeric-ID path, and the proxy rejects that path with a 403. Requests under the new name get a 403 as well when the session is not attached to the repository under that name. `git fetch` and `git push` through the old name keep working.

## 6. References

- [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Get started with Claude Code in the cloud](https://code.claude.com/docs/en/web-quickstart)
- [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
- [Settings reference](https://code.claude.com/docs/en/settings-reference)
