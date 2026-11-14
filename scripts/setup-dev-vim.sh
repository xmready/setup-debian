#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure vim in a development VM
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev-vim.sh | bash -

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
die() { err "$@"; exit 1; }

apt_get() {
  sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFNEW=1 apt-get --assume-yes \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confnew \
    "$@"
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  vim_state_path="${XDG_STATE_HOME:-${HOME}/.local/state}/vim"
  vim_conf_path="${XDG_CONFIG_HOME:-${HOME}/.config}/vim"
  vimrc_filename='vimrc'
  vimrc_path="${vim_conf_path}/${vimrc_filename}"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  vimrc_url="${setup_configs_url}/${vimrc_filename}-dev"
  vimrc_root_path="/root/.config/vim/${vimrc_filename}"
  vimrc_root_url="${setup_configs_url}/${vimrc_filename}-root"
  plug_path="${vim_conf_path}/autoload/plug.vim"
  plug_remote_name='junegunn/vim-plug'
  plug_url="${remote_raw_url}/${plug_remote_name}/master/plug.vim"
  templates_path="${vim_conf_path}/templates"
  templates_url="${remote_raw_url}/${setup_remote_name}/${version}/templates"
  templates_list='skeleton.html'

  info 'installing Vim...'

  apt_get update \
    && apt_get install \
      vim-nox \
    || die 'failed to install Vim'

  success 'Vim installed'

  info 'configuring Vim...'

  mkdir --parents "$vim_state_path" \
    && curl \
      --create-dirs \
      --fail \
      --location \
      --output "$vimrc_path" \
      "$vimrc_url" \
    && sudo curl \
      --create-dirs \
      --fail \
      --location \
      --output "$vimrc_root_path" \
      "$vimrc_root_url" \
    && curl \
      --create-dirs \
      --fail \
      --location \
      --output "$plug_path" \
      "$plug_url" \
    && curl \
      --create-dirs \
      --fail \
      --location \
      --output-dir "$templates_path" \
      --remote-name \
      "${templates_url}/${templates_list}" \
    || die 'failed to configure Vim'

  success 'Vim configured'
}

main "$@"
