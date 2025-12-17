#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/vim-config
#
# Purpose:
#   A script to create custom .vimrc for servers
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/vim-config/main/setup-server-vim.sh | bash -

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; echo "${green}${bold}${msg}${reset}"; }
info() { local msg="$*"; echo "${yellow}${bold}${msg}${reset}"; }
err() { local msg="$*"; echo "${red}${bold}Error: ${msg}${reset}${bel}" >&2; }

vimrc_path="/home/${USER}/.vimrc"
vimrc_root_path="/root/.vimrc"
vimrc_root_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/.vimrc-root"

info "configuring Vim" \
&& sudo --validate \
&& curl --fail --location --output "$vimrc_path" "$vimrc_root_url" \
&& sudo curl --fail --location --output "$vimrc_root_path" "$vimrc_root_url" \
&& sleep 3 \
&& success "Vim configured"
