#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to install and configure packages with apt
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-apt.sh | bash -

echo -e "\n$(tput setaf 3)upgrading packages\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get full-upgrade -y \
&& echo -e "\n$(tput setaf 2)packages upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& sudo -v \
&& echo -e "\n$(tput setaf 3)installing packages\n$(tput sgr0)" \
&& sudo apt-get install -y \
  bash-completion \
  build-essential \
  checkinstall \
  curl \
  fastfetch \
  flatpak \
  fprintd \
  fzf \
  git \
  gnome-software-plugin-flatpak \
  gnupg \
  libpam-fprintd \
  lm-sensors \
  lxc \
  network-manager-openvpn-gnome \
  nmap \
  openvpn \
  pipx \
  python3-pip \
  qrencode \
  rename \
  rsync \
  ssh-audit \
  ufw \
  wget \
&& echo -e "\n$(tput setaf 2)packages installed\n$(tput sgr0)"
