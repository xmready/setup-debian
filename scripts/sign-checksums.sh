#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to generate setup file checksums and sign them with pgp
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/sign-checksums.sh | bash -

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; echo "${green}${bold}${msg}${reset}"; }
info() { local msg="$*"; echo "${yellow}${bold}${msg}${reset}"; }
err() { local msg="$*"; echo "${red}${bold}Error: ${msg}${reset}${bel}" >&2; }

if [ -d ./scripts ]; then
  cd ./scripts || { err "changing to scripts directory failed"; exit 1; }
fi

if [ -d ../scripts ]; then
  cd ../scripts || { err "changing to scripts directory failed"; exit 1; }
fi

if [ ! "$(basename "$PWD")" = "scripts" ]; then
  err 'must be in the setup-debian/scripts/ directory'
  exit 1
fi

sha256sums_desktop_path="/tmp/SHA256SUMS_DESKTOP"
sha256sums_server_path="/tmp/SHA256SUMS_SERVER"
readonly sha256sums_desktop_path sha256sums_server_path

if ! sha256sum setup-desktop* setup-apt-clean.sh setup-nvm.sh > "$sha256sums_desktop_path"; then
  err "desktop checksum generation failed"
  exit 1
fi

if ! sha256sum setup-server* setup-apt-clean.sh > "$sha256sums_server_path"; then
  err "server checksum generation failed"
  exit 1
fi

keyid="D2F5013A"
readonly keyid

if ! gpg --list-secret-keys "$keyid" >/dev/null; then
  err "private key ${keyid} not found"
  exit 1
fi

if ! gpg --local-user "$keyid" --detach-sign --armor --output "${sha256sums_desktop_path}.sign" "$sha256sums_desktop_path"; then
  err "signature of desktop checksums failed"
  exit 1
fi

if ! gpg --local-user "$keyid" --detach-sign --armor --output "${sha256sums_server_path}.sign" "$sha256sums_server_path"; then
  err "signature of server checksums failed"
  exit 1
fi

success 'Checksum and signature files created successfully in /tmp'

exit 0
