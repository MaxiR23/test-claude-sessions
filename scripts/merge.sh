#!/usr/bin/env bash
# INFO: Squash-merges a published pull request through the REST API and reports the merge commit verification.
# STEPS:
#   <pr>
#     1. Require a positive PR number.
#     2. Read the PR: require it open, not merged, based on main.
#     3. Wait for GitHub to compute mergeability and require it mergeable.
#     4. Wait until the head commit reports the required status (REQUIRED_STATUS) and none is pending
#        (timeout 15 minutes; never merge on zero checks or without the required status), then require
#        all of them succeeded; print each one with its result.
#     5. Squash-merge with "<PR title> (#<pr>)" as the commit title, pinned to the checked head commit.
#     6. Read the merge commit through the REST commits endpoint.
#     7. Print the merge commit SHA, title, verified and reason.

set -euo pipefail

readonly REQUIRED_STATUS="Vercel"  # name of the check or status that must be reported before merging
readonly BASE="main"
readonly REPO_API="repos/{owner}/{repo}"
readonly CHECKS_INTERVAL=15  # seconds between polls
readonly CHECKS_TIMEOUT=900  # seconds before giving up on pending or missing checks

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

# Prints "<kind>\t<name>\t<verdict>" per check run and commit status of a commit.
# The verdict is success, pending, or the failing conclusion or state.
read_checks() {
  local sha="$1"
  gh api "$REPO_API/commits/$sha/check-runs?per_page=100" --jq '
    (.check_runs[] | ["check run", .name,
      (if .status != "completed" then "pending"
       elif (.conclusion == "success" or .conclusion == "neutral" or .conclusion == "skipped") then "success"
       else (.conclusion // "unknown") end)] | join("\t")),
    (if .total_count > (.check_runs | length) then "check run\t(more than 100)\tunreadable" else empty end)' \
    || die "cannot read the check runs of $sha"
  gh api "$REPO_API/commits/$sha/status?per_page=100" --jq \
    '.statuses[] | ["status", .context, .state] | join("\t")' \
    || die "cannot read the commit statuses of $sha"
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

  # 4. Wait for at least one check and none pending, then require all of them succeeded.
  local checks failing pending required kind name verdict start=$SECONDS
  while :; do
    checks="$(read_checks "$sha")"
    failing="$(awk -F'\t' '$3 != "success" && $3 != "pending"' <<<"$checks")"
    pending="$(awk -F'\t' '$3 == "pending"' <<<"$checks")"
    if [[ -n "$failing" ]]; then
      die "failing checks on $sha: $(cut -f1-3 --output-delimiter=' ' <<<"$failing" | paste -sd ';' -)"
    fi
    required="$(awk -F'\t' -v n="$REQUIRED_STATUS" '$2 == n' <<<"$checks")"
    if [[ -n "$required" && -z "$pending" ]]; then
      break
    fi
    if [[ $((SECONDS - start)) -ge $CHECKS_TIMEOUT ]]; then
      [[ -n "$required" ]] \
        || die "timed out after ${CHECKS_TIMEOUT}s: required '$REQUIRED_STATUS' not reported on $sha; refusing to merge"
      die "timed out after ${CHECKS_TIMEOUT}s waiting for: $(cut -f1-2 --output-delimiter=' ' <<<"$pending" | paste -sd ';' -)"
    fi
    if [[ -z "$required" ]]; then
      info "required '$REQUIRED_STATUS' not reported on $sha yet; waiting"
    else
      info "waiting for $(grep -c . <<<"$pending") pending check(s) on $sha"
    fi
    sleep "$CHECKS_INTERVAL"
  done
  while IFS=$'\t' read -r kind name verdict; do
    info "$kind '$name': $verdict"
  done <<<"$checks"

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
