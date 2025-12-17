#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure flatpaks
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-flatpak.sh | bash -

flathub_repo_url="https://flathub.org/repo/flathub.flatpakrepo"

echo -e "\n$(tput setaf 3)adding flathub repo\n$(tput sgr0)" \
&& sudo flatpak remote-add --if-not-exists flathub "$flathub_repo_url" \
&& echo -e "\n$(tput setaf 2)flathub repo added\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)installing flatpaks\n$(tput sgr0)" \
&& flatpak install -y flathub \
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
&& echo -e "\n$(tput setaf 2)flatpaks installed\n$(tput sgr0)"
