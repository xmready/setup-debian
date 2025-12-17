#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure tor
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-tor.sh | bash -

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

pgp_keys_url="https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc"
keyring_path="/usr/share/keyrings/deb.torproject.org-keyring.gpg"
sources_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/tor.sources"
distro="$(lsb_release --short --codename)" || { err "failed to get distro codename"; exit 1; }
arch="$(dpkg --print-architecture)" || { err "failed to get system architecture"; exit 1; }
sources_path="/etc/apt/sources.list.d/tor.sources"

info 'adding tor repo...' \
&& sudo --validate \
&& curl --fail --location "$pgp_keys_url" \
  | gpg --dearmor \
  | sudo tee "$keyring_path" > /dev/null \
&& curl --fail --location "$sources_url" \
  | sed "s/distribution/${distro}/" \
  | sed "s/architecture/${arch}/" \
  | sudo tee "$sources_path" > /dev/null \
&& success 'tor repo added' \
&& sleep 3 \
&& info 'installing tor...' \
&& sudo apt-get update \
&& sleep 3 \
&& sudo apt-get install --assume-yes tor deb.torproject.org-keyring \
&& success 'tor installed' \
&& sleep 3 \
&& info 'disabling tor service...' \
&& sudo --validate \
&& sudo systemctl disable tor.service \
&& success 'tor service disabled'
