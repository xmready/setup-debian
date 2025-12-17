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

flathub_repo_url="https://flathub.org/repo/flathub.flatpakrepo"

info 'adding flathub repo...' \
&& sudo flatpak remote-add --if-not-exists flathub "$flathub_repo_url" \
&& success 'flathub repo added' \
&& sleep 3 \
&& info 'installing flatpaks...' \
&& flatpak install --assumeyes flathub \
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
  tv.plex.PlexDesktop \
&& success 'flatpaks installed'
