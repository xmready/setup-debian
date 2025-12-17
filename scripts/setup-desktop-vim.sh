#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/vim-config
#
# Purpose:
#   A script to install vim and configure it with vim-config.
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/vim-config/main/setup-desktop-vim.sh | bash -

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; printf '%s\n' "${green}${bold}success: ${msg}${reset}"; }
info() { local msg="$*"; printf '%s\n' "${yellow}${bold}info: ${msg}${reset}"; }
err() { local msg="$*"; printf '%s\n' "${red}${bold}error: ${msg}${reset}${bel}" >&2; }

remote_url="https://github.com"
remote_raw_url="https://raw.githubusercontent.com"
remote_name_setup="xmready/setup-debian"
remote_name_plug="junegunn/vim-plug"
remote_name_nerd="ryanoasis/nerd-fonts"
ycm_compile_path="${HOME}/bin/ycm-compile"
ycm_compile_url="${remote_raw_url}/${remote_name_setup}/main/scripts/ycm-compile.sh"
vimrc_path="${HOME}/.vimrc"
vimrc_url="${remote_raw_url}/${remote_name_setup}/main/configs/.vimrc"
vimrc_root_path="/root/.vimrc"
vimrc_root_url="${remote_raw_url}/${remote_name_setup}/main/configs/.vimrc-root"
plug_path="${HOME}/.vim/autoload/plug.vim"
plug_url="${remote_raw_url}/${remote_name_plug}/master/plug.vim"
templates_path="${HOME}/.vim/templates"
templates_url="${remote_raw_url}/${remote_name_setup}/main/templates"
nerd_url="${remote_url}/${remote_name_nerd}/releases/latest/download"
nerd_list='{DejaVuSansMono.tar.xz,FiraCode.tar.xz,Hack.tar.xz,JetBrainsMono.tar.xz}'
fonts_path="${HOME}/.local/share/fonts"

info 'installing Vim...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes \
  build-essential \
  cmake \
  curl \
  golang \
  mono-complete \
  openjdk-21-jdk \
  openjdk-21-jre \
  python3-dev \
  vim-nox \
&& success 'Vim installed' \
&& sleep 3 \
&& info 'installing ycm-compile script...' \
&& curl --create-dirs --fail --location --output "$ycm_compile_path" "$ycm_compile_url" \
&& chmod 500 "$ycm_compile_path" \
&& success 'ycm-compile installed' \
&& sleep 3 \
&& info 'configuring Vim...' \
&& curl --fail --location --output "$vimrc_path" "$vimrc_url" \
&& sudo curl --fail --location --output "$vimrc_root_path" "$vimrc_root_url" \
&& curl --create-dirs --fail --location --output "$plug_path" "$plug_url" \
&& curl \
  --create-dirs \
  --fail \
  --location \
  --output-dir "$templates_path" \
  --remote-name \
  "${templates_url}/skeleton.html" \
&& curl \
  --create-dirs \
  --fail \
  --location \
  --output-dir "/tmp/fonts" \
  --remote-name \
  "${nerd_url}/${nerd_list}" \
&& mkdir --parents "$fonts_path" \
&& cat /tmp/fonts/*.tar.xz | tar -xJi -C "$fonts_path" \
&& fc-cache --force "$fonts_path" \
&& success 'Vim configured'
