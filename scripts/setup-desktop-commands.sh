#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install custom commands globally for all users
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-commands.sh | bash -

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

commands_path="${HOME}/bin"
commands_url="https://raw.githubusercontent.com/xmready/setup-debian/main/scripts"
commands_list='{autoupgrade,temps,dnsleaktest,gdrive-start,gdrive-status,gdrive-stop,gdrive-backup,gdrive-check}'

info 'installing custom commands...' \
&& curl \
  --create-dirs \
  --fail \
  --location \
  --output-dir "$commands_path" \
  --remote-name \
  "${commands_url}/${commands_list}" \
&& chmod 500 ${commands_path}/* \
&& success 'custom commands installed'
