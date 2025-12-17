#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/vim-config
#
# Purpose:
#   A script to install vim and configure it with vim-config.
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/vim-config/main/setup-desktop-vim.sh | bash -

ycm_compile_path="/home/${USER}/bin/ycm-compile"
ycm_compile_url="https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/ycm-compile.sh"
vimrc_path="/home/${USER}/.vimrc"
vimrc_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/.vimrc"
vimrc_root_path="/root/.vimrc"
vimrc_root_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/.vimrc-root"
plug_path="/home/${USER}/.vim/autoload/plug.vim"
plug_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
templates_path="/home/${USER}/.vim/templates"
templates_url="https://raw.githubusercontent.com/xmready/setup-debian/main/templates"
nerd_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
nerd_list='{DejaVuSansMono.tar.xz,FiraCode.tar.xz,Hack.tar.xz,JetBrainsMono.tar.xz}'
fonts_path="/home/${USER}/.local/share/fonts"

echo -e "\n$(tput setaf 3)installing vim\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get install -y \
  build-essential \
  cmake \
  curl \
  golang \
  mono-complete \
  openjdk-21-jdk \
  openjdk-21-jre \
  python3-dev \
  vim-nox \
&& echo -e "\n$(tput setaf 2)vim installed\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)install ycmcompile script\n$(tput sgr0)" \
&& curl -fLo "$ycm_compile_path" --create-dirs "$ycm_compile_url" \
&& chmod +x "$ycm_compile_path" \
&& echo -e "\n$(tput setaf 2)ycmcompile installed\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)configuring vim\n$(tput sgr0)" \
&& curl -fLo "$vimrc_path" "$vimrc_url" \
&& sudo curl -fLo "$vimrc_root_path" "$vimrc_root_url" \
&& curl -fLo "$plug_path" --create-dirs "$plug_url" \
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
&& mkdir -p "$fonts_path" \
&& cat /tmp/fonts/*.tar.xz | tar -xJi -C "$fonts_path" \
&& fc-cache -vf "$fonts_path" \
&& echo -e "\n$(tput setaf 2)vim configured\n$(tput sgr0)"
