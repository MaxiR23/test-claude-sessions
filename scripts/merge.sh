#!/usr/bin/env bash
# INFO: Squash-merges a published pull request through the REST API and reports the merge commit verification.
# STEPS:
#   <pr>
#     1. Require a positive PR number.
#     2. Read the PR: require it open, not merged, based on main.
#     3. Wait for GitHub to compute mergeability and require it mergeable.
#     4. Require no failing check runs and no failing commit statuses on the head commit.
#     5. Squash-merge with "<PR title> (#<pr>)" as the commit title, pinned to the checked head commit.
#     6. Read the merge commit through the REST commits endpoint.
#     7. Print the merge commit SHA, title, verified and reason.

set -euo pipefail

readonly BASE="main"
readonly REPO_API="repos/{owner}/{repo}"

die() {
  printf 'merge: %s\n' "$*" >&2
  exit 1
}

info() {
  printf 'merge: %s\n' "$*"
}

usage() {
  die "usage: scripts/merge.sh <pr>"
}

read_pr() {
  gh api "$REPO_API/pulls/$1" --jq \
    '[.state, (.merged | tostring), .base.ref, (.mergeable | tostring), .mergeable_state, .head.sha] | join("\t")' \
    || die "cannot read PR #$1"
}

main() {
  [[ $# -eq 1 ]] || usage
  local pr="$1"
  cd "$(git rev-parse --show-toplevel)"

  # 1. PR number.
  [[ "$pr" =~ ^[1-9][0-9]*$ ]] || die "PR must be a positive number, got '$pr'"

  # 2. State, merged flag and base.
  local fields state merged base mergeable mstate sha title
  fields="$(read_pr "$pr")"
  IFS=$'\t' read -r state merged base mergeable mstate sha <<<"$fields"
  title="$(gh api "$REPO_API/pulls/$pr" --jq '.title')" || die "cannot read the title of PR #$pr"
  [[ "$state" == open ]] || die "PR #$pr is not open (state: $state)"
  [[ "$merged" == false ]] || die "PR #$pr is already merged"
  [[ "$base" == "$BASE" ]] || die "PR #$pr is based on '$base', not '$BASE'"
  [[ -n "$sha" ]] || die "cannot read the head commit of PR #$pr"

  # 3. Mergeability: null while GitHub computes it.
  local attempt=1
  while [[ "$mergeable" == null && $attempt -lt 10 ]]; do
    sleep 3
    attempt=$((attempt + 1))
    fields="$(read_pr "$pr")"
    IFS=$'\t' read -r state merged base mergeable mstate sha <<<"$fields"
  done
  [[ "$mergeable" == true ]] || die "PR #$pr is not mergeable (mergeable: $mergeable, state: $mstate)"
  [[ "$state" == open && "$merged" == false && "$base" == "$BASE" ]] \
    || die "PR #$pr changed while waiting for mergeability"

  # 4. Failing checks on the head commit. Pending checks do not stop the merge.
  local failed_runs failed_statuses
  failed_runs="$(gh api "$REPO_API/commits/$sha/check-runs?per_page=100" --jq \
    '[.check_runs[] | select(.conclusion == "failure" or .conclusion == "timed_out" or .conclusion == "cancelled" or .conclusion == "action_required" or .conclusion == "startup_failure")] | length')" \
    || die "cannot read the check runs of $sha"
  failed_statuses="$(gh api "$REPO_API/commits/$sha/status" --jq \
    '[.statuses[] | select(.state == "failure" or .state == "error")] | length')" \
    || die "cannot read the commit statuses of $sha"
  [[ "$failed_runs" == 0 && "$failed_statuses" == 0 ]] \
    || die "failing checks on $sha (check runs: $failed_runs, statuses: $failed_statuses)"

  # 5. Squash merge pinned to the checked head commit.
  local commit_title merge_sha
  commit_title="$title (#$pr)"
  merge_sha="$(gh api -X PUT "$REPO_API/pulls/$pr/merge" \
    -f merge_method=squash -f commit_title="$commit_title" -f sha="$sha" --jq '.sha')" \
    || die "GitHub refused to merge PR #$pr"
  [[ -n "$merge_sha" ]] || die "merge of PR #$pr returned no commit SHA"

  # 6. Merge commit verification.
  local verification
  verification="$(gh api "$REPO_API/commits/$merge_sha" --jq \
    '.commit.verification | "verified: \(.verified)\nreason: \(.reason)"')" \
    || die "PR #$pr is merged as $merge_sha but its verification cannot be read"

  # 7. Report.
  info "merge commit: $merge_sha"
  info "title: $commit_title"
  printf '%s\n' "$verification"
}

main "$@"
