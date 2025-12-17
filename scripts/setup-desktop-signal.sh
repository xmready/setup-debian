#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup the Signal messenger repo and install the latest version
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-signal.sh | bash -

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

pgp_keys_url="https://updates.signal.org/desktop/apt/keys.asc"
keyring_path="/usr/share/keyrings/signal-desktop-keyring.gpg"
sources_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/signal.sources"
arch="$(dpkg --print-architecture)" || { err "failed to get system architecture"; exit 1; }
sources_path="/etc/apt/sources.list.d/signal.sources"

info 'adding Signal repo...' \
&& sudo --validate \
&& curl --fail --location "$pgp_keys_url" \
  | gpg --dearmor \
  | sudo tee "$keyring_path" > /dev/null \
&& curl --fail --location "$sources_url" \
  | sed s/architecture/"$arch"/ \
  | sudo tee "$sources_path" > /dev/null \
&& success 'Signal repo added' \
&& sleep 3 \
&& info 'installing Signal...' \
&& sudo --validate \
&& sudo apt-get update \
&& sleep 3 \
&& sudo apt-get install --assume-yes signal-desktop \
&& success 'Signal installed'
