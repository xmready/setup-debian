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

success() { local msg="$*"; echo "${green}${bold}${msg}${reset}"; }
info() { local msg="$*"; echo "${yellow}${bold}${msg}${reset}"; }
err() { local msg="$*"; echo "${red}${bold}Error: ${msg}${reset}${bel}" >&2; }

user_path="/home/${USER}"
remote_url="https://github.com"
remote_raw_url="https://raw.githubusercontent.com"
remote_name_setup="xmready/setup-debian"
remote_name_plug="junegunn/vim-plug"
remote_name_nerd="ryanoasis/nerd-fonts"
ycm_compile_path="${user_path}/bin/ycm-compile"
ycm_compile_url="${remote_raw_url}/${remote_name_setup}/main/scripts/ycm-compile.sh"
vimrc_path="${user_path}/.vimrc"
vimrc_url="${remote_raw_url}/${remote_name_setup}/main/configs/.vimrc"
vimrc_root_path="/root/.vimrc"
vimrc_root_url="${remote_raw_url}/${remote_name_setup}/main/configs/.vimrc-root"
plug_path="${user_path}/.vim/autoload/plug.vim"
plug_url="${remote_raw_url}/${remote_name_plug}/master/plug.vim"
templates_path="${user_path}/.vim/templates"
templates_url="${remote_raw_url}/${remote_name_setup}/main/templates"
nerd_url="${remote_url}/${remote_name_nerd}/releases/latest/download"
nerd_list='{DejaVuSansMono.tar.xz,FiraCode.tar.xz,Hack.tar.xz,JetBrainsMono.tar.xz}'
fonts_path="${user_path}/.local/share/fonts"

info "installing vim" \
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
&& success "vim installed" \
&& sleep 3 \
&& info "install ycmcompile script" \
&& curl --fail --location --output "$ycm_compile_path" --create-dirs "$ycm_compile_url" \
&& chmod 700 "$ycm_compile_path" \
&& success "ycmcompile installed" \
&& sleep 3 \
&& info "configuring vim" \
&& curl --fail --location --output "$vimrc_path" "$vimrc_url" \
&& sudo curl -fLo "$vimrc_root_path" "$vimrc_root_url" \
&& curl --fail --location --output "$plug_path" --create-dirs "$plug_url" \
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
&& success "vim configured"
