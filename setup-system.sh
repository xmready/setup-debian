#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to setup a new debian based desktop/laptop
#
# sudo usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/setup-system.sh | bash -

SETUP_APT_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-apt.sh
SETUP_SHELL_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-shell.sh
SETUP_TOR_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-tor.sh
SETUP_SIGNAL_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-signal.sh
SETUP_NVM_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-nvm.sh
SETUP_VIM_URL=https://raw.githubusercontent.com/xmready/vim-config/main/setup-vim.sh
SETUP_RCLONE_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-rclone.sh
CLEAN_APT_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/clean-apt.sh
SETUP_FLATPAK_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-flatpak.sh
SETUP_COMMANDS_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-commands.sh
HARDEN_NETWORK_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/harden-network.sh

curl -fL "$SETUP_APT_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_SHELL_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_TOR_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_SIGNAL_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_NVM_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_VIM_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_RCLONE_URL" | bash - \
&& sleep 3 \
&& curl -fL "$CLEAN_APT_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_FLATPAK_URL" | bash - \
&& sleep 3 \
&& curl -fL "$SETUP_COMMANDS_URL" | bash - \
&& sleep 3 \
&& curl -fL "$HARDEN_NETWORK_URL" | bash - \
&& sleep 3 \
&& echo -e \
  "\n$(tput setaf 1)$(tput bold)SYSTEM WILL REBOOT IN 60 SECONDS\n$(tput sgr0)$(tput bel)" \
&& sudo shutdown -r
