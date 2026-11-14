#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup a new debian based development VM
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev.sh | bash -

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

tmp_path='/tmp'

cleanup() {
  local status=$?
  if [[ "$status" -eq 0 ]]; then
    rm -f -- "$tmp_path"/setup-*.sh "$tmp_path"/SHA256SUMS_*
  else
    rm -f -- "$tmp_path"/setup-dev-*.sh "$tmp_path"/setup-apt*.sh
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  info 'downloading setup files...'

  remote_url='https://github.com'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  setup_dev_filename='setup-dev.sh'
  setup_dev_path="${tmp_path}/${setup_dev_filename}"
  version='v2.0.0'
  setup_scripts_url="${remote_raw_url}/${setup_remote_name}/${version}/scripts"
  setup_dev_url="${setup_scripts_url}/${setup_dev_filename}"

  if [[ ! -f "$setup_dev_path" ]]; then
    curl --fail --location --show-error --silent --output "$setup_dev_path" "$setup_dev_url" \
      || die "download failed for ${setup_dev_url}"
  fi

  setup_files=(
    'setup-dev-apt.sh'
    'setup-dev-shell.sh'
    'setup-dev-vim.sh'
    'setup-dev-homebrew.sh'
    'setup-dev-nvm.sh'
    'setup-dev-opencode.sh'
    'setup-dev-commands.sh'
    'setup-apt-clean.sh'
  )

  trap cleanup EXIT

  for file in "${setup_files[@]}"; do
    outfile="${tmp_path}/${file}"

    curl --fail --location --show-error --silent --output "$outfile" "${setup_scripts_url}/${file}" \
      || die "download failed for ${file}"
  done

  success 'setup files downloaded'

  sha256sums_filename='SHA256SUMS_DEV'
  sha256sums_path="${tmp_path}/${sha256sums_filename}"
  sha256sums_url="${remote_url}/${setup_remote_name}/releases/download/${version}/${sha256sums_filename}"

  if [[ ! -f "$sha256sums_path" ]]; then
    curl --fail --location --show-error --silent --output "$sha256sums_path" "$sha256sums_url" \
      || die "download failed for ${sha256sums_url}"
  fi

  cd "$tmp_path" || die "failed to change working directory to ${tmp_path}"

  sha256sum --check --quiet "$sha256sums_path" || die 'checksum verification failed'
  success 'checksums verified'

  for file in "${setup_files[@]}"; do
    runfile="${tmp_path}/${file}"

    bash "$runfile" "$version" || die "${runfile} failed"
  done

  sudo shutdown --reboot +10 || die 'system reboot failed'
  info 'SYSTEM WILL REBOOT IN 10 MINUTES'
  exit 0
}

main "$@"
