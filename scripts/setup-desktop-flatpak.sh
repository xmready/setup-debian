#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure flatpaks
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-flatpak.sh | bash -

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

  flathub_repo_url='https://dl.flathub.org/repo/flathub.flatpakrepo'

  info 'installing flatpak...'

  apt_get update \
    && apt_get install flatpak \
    || die 'failed to install flatpak'

  success 'flatpak installed'

  info 'adding flathub repo...'

  flatpak remote-add --user --if-not-exists flathub "$flathub_repo_url" \
    || die 'failed to add flathub repo'

  success 'flathub repo added'

  info 'installing flatpaks...'

  flatpak install --user --noninteractive flathub \
      com.github.flxzt.rnote \
      io.github.ungoogled_software.ungoogled_chromium \
      org.gimp.GIMP \
      org.gnucash.GnuCash \
      org.kde.kdenlive \
      org.kde.kleopatra \
      org.keepassxc.KeePassXC \
      org.mozilla.firefox \
      org.mozilla.Thunderbird \
      org.qbittorrent.qBittorrent \
    || die 'failed to install flatpaks'

  success 'flatpaks installed'
}

main "$@"
