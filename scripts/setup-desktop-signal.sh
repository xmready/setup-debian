#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup the Signal messenger repo and install the latest version
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-signal.sh | bash -

PGP_KEYS_URL=https://updates.signal.org/desktop/apt/keys.asc
KEYRING_PATH=/usr/share/keyrings/signal-desktop-keyring.gpg
SOURCES_URL=https://raw.githubusercontent.com/xmready/setup-debian/main/configs/signal.sources
SOURCES_PATH=/etc/apt/sources.list.d/signal.sources
ARCH="$(dpkg --print-architecture)"

echo -e "\n$(tput setaf 3)adding Signal repo\n$(tput sgr0)" \
&& curl -fL "$PGP_KEYS_URL" \
  | gpg --dearmor \
  | sudo tee "$KEYRING_PATH" > /dev/null \
&& curl -fL "$SOURCES_URL" \
  | sed s/architecture/"$ARCH"/ \
  | sudo tee "$SOURCES_PATH" > /dev/null \
&& echo -e "\n$(tput setaf 2)Signal repo added\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)installing Signal\n$(tput sgr0)" \
&& sudo apt-get update \
&& sleep 3 \
&& sudo apt-get install -y signal-desktop \
&& echo -e "\n$(tput setaf 2)Signal installed\n$(tput sgr0)"
