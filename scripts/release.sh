#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to set the release version in the setup scripts, commit, tag,
#   and sign the checksums for a new release
#
# Usage:
#   Run from a checkout of main, with the signing key in your keyring:
#     ./scripts/release.sh v1.0.1

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

main() {
  release_version="${1:-}"
  scripts_path="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  setup_files=(
    'setup-desktop.sh'
    'setup-server.sh'
  )
  version_pattern="^([[:space:]]*)version='[^']*'$"

  [[ -n "$release_version" ]] \
    || die 'no version given (e.g. release.sh v1.0.1)'

  [[ "$release_version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    || die "${release_version} is not a valid version (e.g. v1.0.1)"

  cd "$scripts_path" || die "failed to change working directory to ${scripts_path}"

  repo_status="$(git status --porcelain)" \
    || die 'failed to get repo status'

  [[ -z "$repo_status" ]] \
    || die 'repo has uncommitted or untracked files, commit them before releasing'

  ! git rev-parse --quiet --verify "refs/tags/${release_version}" > /dev/null \
    || die "tag ${release_version} already exists"

  [[ "$(git branch --show-current)" == 'main' ]] \
    || die 'releases must be made from the main branch'

  info "setting version to ${release_version}..."

  for file in "${setup_files[@]}"; do
    [[ "$(grep --count --extended-regexp -- "$version_pattern" "$file")" -eq 1 ]] \
      || die "expected exactly one version line in ${file}"
  done

  sed \
      --in-place \
      --follow-symlinks \
      --regexp-extended \
      --expression "s/${version_pattern}/\1version='${release_version}'/" \
      "${setup_files[@]}" \
    || die 'failed to set version'

  for file in "${setup_files[@]}"; do
    [[ "$(grep --count --extended-regexp -- "^[[:space:]]*version='${release_version//./\\.}'$" "$file")" -eq 1 ]] \
      || die "no version line was updated in ${file}"
  done

  success "version set to ${release_version}"

  info "committing and tagging ${release_version}..."

  git commit --quiet --message "Release ${release_version}" -- "${setup_files[@]}" \
    && git tag --annotate --message "Release ${release_version}" "$release_version" \
    || die 'failed to commit and tag'

  success "${release_version} committed and tagged"

  bash "${scripts_path}/sign-checksums.sh" \
    || die "${release_version} is committed and tagged but not signed, run sign-checksums.sh to retry"

  info 'push the commit and tag, then upload the release files:'
  info "${reset}  git push --atomic origin HEAD ${release_version}"
}

main "$@"
