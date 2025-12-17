#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure tor
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-tor.sh | bash -

pgp_keys_url="https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc"
keyring_path="/usr/share/keyrings/deb.torproject.org-keyring.gpg"
sources_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/tor.sources"
distro="$(lsb_release -s -c)"
arch="$(dpkg --print-architecture)"
sources_path="/etc/apt/sources.list.d/tor.sources"

echo -e "\n$(tput setaf 3)adding tor repo\n$(tput sgr0)" \
&& sudo -v \
&& curl -fL "$pgp_keys_url" \
  | gpg --dearmor \
  | sudo tee "$keyring_path" > /dev/null \
&& curl -fL "$sources_url" \
  | sed s/distribution/"$distro"/ \
  | sed s/architecture/"$arch"/ \
  | sudo tee "$sources_path" > /dev/null \
&& echo -e "\n$(tput setaf 2)tor repo added\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)installing tor\n$(tput sgr0)" \
&& sudo apt-get update \
&& sleep 3 \
&& sudo apt-get install -y tor deb.torproject.org-keyring \
&& echo -e "\n$(tput setaf 2)tor installed\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)disabling tor.service\n$(tput sgr0)" \
&& sudo systemctl disable tor.service \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)tor.service disabled\n$(tput sgr0)"
