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
die() { err "$@"; exit 1; }

apt_get() {
  sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFNEW=1 apt-get --assume-yes \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confnew \
    "$@"
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  tor_url='https://deb.torproject.org/torproject.org'
  distro="$(lsb_release --short --codename)" \
    || die 'failed to get distro codename'
  pgp_keys_url="${tor_url}/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc"
  keyring_path='/usr/share/keyrings/deb.torproject.org-keyring.gpg'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  sources_filename='tor.sources'
  sources_url="${setup_configs_url}/${sources_filename}"
  arch="$(dpkg --print-architecture)" \
    || die 'failed to get system architecture'
  sources_path="/etc/apt/sources.list.d/${sources_filename}"

  curl --fail --silent --head "${tor_url}/dists/${distro}/Release" >/dev/null \
    || die "tor repo has no suite for ${distro}"

  info 'adding tor repo...'

  curl --fail --location "$pgp_keys_url" \
      | gpg --dearmor \
      | sudo tee "$keyring_path" >/dev/null \
    && curl --fail --location "$sources_url" \
      | sed "s/distribution/${distro}/" \
      | sed "s/architecture/${arch}/" \
      | sudo tee "$sources_path" >/dev/null \
    || die 'failed to add tor repo'

  success 'tor repo added'

  info 'installing tor...'

  apt_get update \
    && apt_get install tor deb.torproject.org-keyring \
    || die 'failed to install tor'

  success 'tor installed'

  sudo --validate || die 'sudo authentication failed'

  info 'disabling tor service...'

  sudo systemctl disable tor.service \
    || die 'failed to disable tor service'

  success 'tor service disabled'
}

main "$@"
