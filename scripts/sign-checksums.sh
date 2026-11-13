#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to generate setup file checksums and sign them with pgp
#
# Usage:
#   Run from a checkout of the release tag, with the signing key in your keyring:
#     ./scripts/sign-checksums.sh

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
  scripts_path="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  tmp_path='/tmp'
  sha256sums_desktop_path="${tmp_path}/SHA256SUMS_DESKTOP"
  sha256sums_server_path="${tmp_path}/SHA256SUMS_SERVER"
  key_fingerprint='31310B484B30ADABE8527D0E17AF13F5D2F5013A'

  cd "$scripts_path" || die "failed to change working directory to ${scripts_path}"

  repo_status="$(git status --porcelain)" \
    || die 'failed to get repo status'

  [[ -z "$repo_status" ]] \
    || die 'repo has uncommitted or untracked files, commit them before signing'

  mapfile -t desktop_files < <(git ls-files 'setup-desktop*' 'setup-apt*')
  mapfile -t server_files < <(git ls-files 'setup-server*' 'setup-apt*')
  mapfile -t setup_files < <(git ls-files 'setup-*')

  (( ${#desktop_files[@]} > 0 && ${#server_files[@]} > 0 )) \
    || die 'no setup files found to checksum'

  git ls-files --error-unmatch setup-desktop.sh setup-server.sh > /dev/null 2>&1 \
    || die 'setup-desktop.sh or setup-server.sh is missing from the repo'

  gpg --list-secret-keys "$key_fingerprint" > /dev/null \
    || die "private key ${key_fingerprint} not found"

  info 'creating checksums...'

  sha256sum -- "${desktop_files[@]}" > "$sha256sums_desktop_path" \
    && sha256sum -- "${server_files[@]}" > "$sha256sums_server_path" \
    || die 'failed to create checksums'

  success 'checksums created'

  info 'signing checksums...'

  gpg \
      --local-user "$key_fingerprint" \
      --detach-sign \
      --armor \
      --yes \
      --output "${sha256sums_desktop_path}.sign" \
      "$sha256sums_desktop_path" \
    && gpg \
      --local-user "$key_fingerprint" \
      --detach-sign \
      --armor \
      --yes \
      --output "${sha256sums_server_path}.sign" \
      "$sha256sums_server_path" \
    || die 'failed to sign checksums'

  success "checksum and signature files created in ${tmp_path}"

  info 'copying setup files...'

  cp -- "${setup_files[@]}" "$tmp_path" \
    || die 'failed to copy setup files'

  success "setup files copied to ${tmp_path}"

  info 'verifying checksums and signatures...'

  cd "$tmp_path" \
    && sha256sum --check "$sha256sums_desktop_path" \
    && sha256sum --check "$sha256sums_server_path" \
    && gpg --verify "${sha256sums_desktop_path}.sign" "$sha256sums_desktop_path" \
    && gpg --verify "${sha256sums_server_path}.sign" "$sha256sums_server_path" \
    || die 'failed to verify checksums'

  success 'checksums and signatures verified'
}

main "$@"
