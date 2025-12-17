#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to create custom .vimrc for servers
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-vim.sh | bash -

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

  vimrc_filename='.vimrc'
  vimrc_path="${HOME}/${vimrc_filename}"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  vimrc_root_url="${setup_configs_url}/vimrc-root"
  vimrc_root_path="/root/${vimrc_filename}"

  info 'installing Vim...'

  apt_get update \
    && apt_get install vim \
    || die 'failed to install Vim'

  success 'Vim installed'

  info 'configuring Vim...'

  curl \
      --fail \
      --location \
      --output "$vimrc_path" \
      "$vimrc_root_url" \
    && sudo curl \
      --fail \
      --location \
      --output "$vimrc_root_path" \
      "$vimrc_root_url" \
    || die 'failed to configure Vim'

  success 'Vim configured'
}

main "$@"
