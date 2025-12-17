#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install opencode
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-opencode.sh | bash -

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

opencode_install_url="https://opencode.ai/install"
remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
opencode_config_url="${remote_raw_url}/${remote_name}/main/configs/tui.json"
opencode_config_path="${HOME}/.config/opencode/tui.json"

info 'installing opencode...' \
&& curl --fail --location "$opencode_install_url" | bash - \
&& curl --create-dirs --fail --location --output "$opencode_config_path" "$opencode_config_url" \
&& success 'opencode installed'
