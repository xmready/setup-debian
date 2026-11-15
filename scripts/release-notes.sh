#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to print the release notes for a release tag, made from the
#   release notes template and the conventional commits since the last tag
#
# Usage:
#   Run from a checkout with the release tag fetched:
#     ./scripts/release-notes.sh v1.0.1

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; printf '%s\n' "${green}${bold}success: ${msg}${reset}"; }
info() { local msg="$*"; printf '%s\n' "${yellow}${bold}info: ${msg}${reset}"; }
err() { local msg="$*"; printf '%s\n' "${red}${bold}error: ${msg}${reset}${bel}" >&2; }
die() { err "$@"; exit 1; }

print_section() {
  local title="$1"

  shift

  if (( $# > 0 )); then
    printf '\n### %s\n\n' "$title"
    printf -- '- %s\n' "$@"
  fi
}

main() {
  release_version="${1:-}"
  scripts_path="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  template_path="${scripts_path}/../.github/release-notes-template.md"
  repo_url='https://github.com/xmready/setup-debian'
  subject_pattern='^([a-z]+)(\(([^)]+)\))?(!)?: (.+)$'
  breaking=()
  features=()
  fixes=()
  docs=()
  others=()

  [[ -n "$release_version" ]] \
    || die 'no version given (e.g. release-notes.sh v1.0.1)'

  [[ "$release_version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    || die "${release_version} is not a valid version (e.g. v1.0.1)"

  git rev-parse --quiet --verify "refs/tags/${release_version}" > /dev/null \
    || die "tag ${release_version} does not exist"

  [[ "$(git rev-parse --is-shallow-repository)" == 'false' ]] \
    || die 'the repo is a shallow clone, fetch the full history first'

  [[ -f "$template_path" ]] \
    || die "release notes template not found at ${template_path}"

  previous_version="$(git describe --tags --abbrev=0 --match 'v*' "${release_version}^" 2>/dev/null)" \
    || previous_version=''

  if [[ -n "$previous_version" ]]; then
    commit_range="${previous_version}..${release_version}"
  else
    commit_range="$release_version"
  fi

  commits="$(git rev-list --no-merges --reverse "$commit_range")" \
    || die "failed to list the commits in ${commit_range}"

  for commit in $commits; do
    subject="$(git log -1 --format='%s' "$commit")" \
      && body="$(git log -1 --format='%b' "$commit")" \
      && short_hash="$(git rev-parse --short "$commit")" \
      || die "failed to read commit ${commit}"

    [[ "$subject" != Release\ v* ]] || continue

    if [[ ! "$subject" =~ $subject_pattern ]]; then
      others+=("${subject} (${short_hash})")
      continue
    fi

    type="${BASH_REMATCH[1]}"
    scope="${BASH_REMATCH[3]}"
    bang="${BASH_REMATCH[4]}"
    description="${BASH_REMATCH[5]}"
    entry="${description} (${short_hash})"

    if [[ -n "$scope" ]]; then
      entry="**${scope}:** ${entry}"
    fi

    footer="$(printf '%s\n' "$body" | sed -n '/^BREAKING[ -]CHANGE: /,/^$/p' | sed 's/^BREAKING[ -]CHANGE: //' | tr '\n' ' ' | sed 's/ *$//')"

    if [[ -n "$footer" ]]; then
      breaking+=("${footer} (${short_hash})")
    elif [[ -n "$bang" ]]; then
      breaking+=("$entry")
    fi

    case "$type" in
      feat) features+=("$entry") ;;
      fix) fixes+=("$entry") ;;
      docs) docs+=("$entry") ;;
      *) others+=("$entry") ;;
    esac
  done

  cat -- "$template_path" \
    || die 'failed to read the release notes template'

  printf '\n## Changes\n'
  print_section 'Breaking changes' ${breaking[@]+"${breaking[@]}"}
  print_section 'Features' ${features[@]+"${features[@]}"}
  print_section 'Fixes' ${fixes[@]+"${fixes[@]}"}
  print_section 'Documentation' ${docs[@]+"${docs[@]}"}
  print_section 'Other changes' ${others[@]+"${others[@]}"}

  if [[ -n "$previous_version" ]]; then
    printf '\n**Full Changelog**: %s/compare/%s...%s\n' "$repo_url" "$previous_version" "$release_version"
  fi
}

main "$@"
