#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure nvm-sh and nodejs
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-nvm.sh | bash -

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

get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |
  grep tag_name |
  sed -E 's/.*"([^"]+)".*/\1/'
}

remote_raw_url="https://raw.githubusercontent.com"
remote_name_setup="xmready/setup-debian"
remote_name_nvm="nvm-sh/nvm"
nvm_version="$(get_latest_release ${remote_name_nvm})" || { err "failed to get nvm version"; exit 1; }
nvm_url="${remote_raw_url}/${remote_name_nvm}/${nvm_version}/install.sh"
NVM_DIR="${HOME}/.nvm"
nvm_auto_url="${remote_raw_url}/${remote_name_setup}/main/scripts/nvm-auto-bash.sh"
bashrc_path="${HOME}/.bashrc"

info 'installing nvm...' \
&& curl --fail --location "$nvm_url" | bash - \
&& [ -s "${NVM_DIR}/nvm.sh" ] \
&& \. "${NVM_DIR}/nvm.sh" \
&& { printf '\n'; curl --fail --location "$nvm_auto_url"; } >> "$bashrc_path" \
&& nvm install node \
&& nvm alias default node \
&& node --version \
&& npm --version \
&& success 'nvm installed'
