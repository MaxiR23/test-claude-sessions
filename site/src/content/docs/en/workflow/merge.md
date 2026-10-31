---
title: Merge
sidebar:
  order: 7
description: How the PR is merged after review.
---

The loop ends with the PR open and ready for review. A person reviews it and, if it is fine, merges it.

## What the PR needs before the merge

- Base on `main`, mergeable and with no failing checks.
- The required `Vercel` status reported and successful.

## How

Squash is the only method enabled in the repo settings. The commit title is `<PR title> (#<N>)`, and it lands on `main` as a single commit signed by GitHub.

## Sources

- [Merge a pull request](https://docs.github.com/en/rest/pulls/pulls#merge-a-pull-request)
- [Configuring commit squashing for pull requests](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests)
