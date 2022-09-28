#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure packages with apt
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-apt.sh | bash -

set_flatpak_plugin() {
  case "$XDG_CURRENT_DESKTOP" in
    GNOME)
      FLATPAK_PLUGIN="gnome-software-plugin-flatpak"
      ;;
    KDE)
      FLATPAK_PLUGIN="plasma-discover-backend-flatpak"
      ;;
    *)
      echo "Error: Only Gnome and Plasma environments are supported: $XDG_CURRENT_DESKTOP" >&2
      FLATPAK_PLUGIN="unknown-plugin"  # Default value if no match is found
      return 2
      ;;
  esac
}

echo -e "\n$(tput setaf 3)upgrading packages\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get full-upgrade -y \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)packages upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)installing packages\n$(tput sgr0)" \
&& set_flatpak_plugin \
&& sudo apt-get install -y \
  bash-completion \
  build-essential \
  checkinstall \
  curl \
  fastfetch \
  flatpak \
  "$FLATPAK_PLUGIN" \
  fprintd \
  fzf \
  git \
  gnupg \
  libpam-fprintd \
  lm-sensors \
  lxc \
  nmap \
  pipx \
  python3-pip \
  qrencode \
  rename \
  rsync \
  ssh-audit \
  ufw \
  wget \
&& echo -e "\n$(tput setaf 2)packages installed\n$(tput sgr0)"
