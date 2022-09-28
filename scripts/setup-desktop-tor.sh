#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure tor
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-tor.sh | bash -

PGP_KEYS_URL=https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc
KEYRING_PATH=/usr/share/keyrings/deb.torproject.org-keyring.gpg
SOURCES_URL=https://raw.githubusercontent.com/xmready/setup-debian/main/configs/tor.sources
SOURCES_PATH=/etc/apt/sources.list.d/tor.sources
DISTRO="$(lsb_release -s -c)"
ARCH="$(dpkg --print-architecture)"

echo -e "\n$(tput setaf 3)adding tor repo\n$(tput sgr0)" \
&& curl -fL "$PGP_KEYS_URL" \
  | gpg --dearmor \
  | sudo tee "$KEYRING_PATH" > /dev/null \
&& curl -fL "$SOURCES_URL" \
  | sed s/distribution/"$DISTRO"/ \
  | sed s/architecture/"$ARCH"/ \
  | sudo tee "$SOURCES_PATH" > /dev/null \
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
