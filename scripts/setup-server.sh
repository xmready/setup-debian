#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup a new debian based server install
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server.sh | bash -

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
    rm -f -- "$tmp_path"/setup-server-*.sh "$tmp_path"/setup-apt*.sh
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  info 'downloading setup files...'

  remote_url='https://github.com'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  setup_server_filename='setup-server.sh'
  setup_server_path="${tmp_path}/${setup_server_filename}"
  version='v1.0.1'
  setup_scripts_url="${remote_raw_url}/${setup_remote_name}/${version}/scripts"
  setup_server_url="${setup_scripts_url}/${setup_server_filename}"

  if [[ ! -f "$setup_server_path" ]]; then
    curl --fail --location --show-error --silent --output "$setup_server_path" "$setup_server_url" \
      || die "download failed for ${setup_server_url}"
  fi

  setup_files=(
    'setup-server-apt.sh'
    'setup-server-shell.sh'
    'setup-server-vim.sh'
    'setup-server-commands.sh'
    'setup-server-harden.sh'
    'setup-apt-clean.sh'
  )

  trap cleanup EXIT

  for file in "${setup_files[@]}"; do
    outfile="${tmp_path}/${file}"

    curl --fail --location --show-error --silent --output "$outfile" "${setup_scripts_url}/${file}" \
      || die "download failed for ${file}"
  done

  success 'setup files downloaded'

  sha256sums_filename='SHA256SUMS_SERVER'
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
