# CLAUDE.md

Rules for working in this repository. These are strict. Follow them exactly.

## Branches

- Never commit directly to `main`.
- Branch format: `type/short-description`
  - Lowercase, words separated by hyphens.
  - Examples: `feat/login-page`, `fix/header-bug`, `docs/setup-notes`
- Allowed types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `style`, `perf`, `ci`, `build`
- Do not use any other prefix.

## Commits

- Follow Conventional Commits: `type(optional-scope): short description`
  - Examples: `feat: add login page`, `fix(header): correct alignment`, `docs: add setup notes`
- Same allowed types as branches.
- Write commit messages in English, imperative mood, lowercase description, no trailing period.
- One logical change per commit.

## Language

- Code, comments, commits, branches, and pull requests: English.