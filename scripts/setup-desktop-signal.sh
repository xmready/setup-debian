#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup the Signal messenger repo and install the latest version
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-signal.sh | bash -

pgp_keys_url="https://updates.signal.org/desktop/apt/keys.asc"
keyring_path="/usr/share/keyrings/signal-desktop-keyring.gpg"
sources_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/signal.sources"
arch="$(dpkg --print-architecture)"
sources_path="/etc/apt/sources.list.d/signal.sources"

echo -e "\n$(tput setaf 3)adding Signal repo\n$(tput sgr0)" \
&& sudo -v \
&& curl -fL "$pgp_keys_url" \
  | gpg --dearmor \
  | sudo tee "$keyring_path" > /dev/null \
&& curl -fL "$sources_url" \
  | sed s/architecture/"$arch"/ \
  | sudo tee "$sources_path" > /dev/null \
&& echo -e "\n$(tput setaf 2)Signal repo added\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)installing Signal\n$(tput sgr0)" \
&& sudo apt-get update \
&& sleep 3 \
&& sudo apt-get install -y signal-desktop \
&& echo -e "\n$(tput setaf 2)Signal installed\n$(tput sgr0)"
