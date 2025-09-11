#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to create custom .vimrc for servers
#
# sudo usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/setup-server-vim.sh | bash -

VIMRC_ROOT_URL=https://raw.githubusercontent.com/xmready/vim-config/main/.vimrc-root

echo -e "\n$(tput setaf 3)configuring Vim\n$(tput sgr0)" \
&& curl -fLo ~/.vimrc "$VIMRC_ROOT_URL" \
&& sudo curl -fLo /root/.vimrc "$VIMRC_ROOT_URL" \
&& sleep 3 \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)Vim configured\n$(tput sgr0)"
