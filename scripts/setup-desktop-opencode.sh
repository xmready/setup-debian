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
die() { err "$@"; exit 1; }

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal user, not root'

  opencode_install_url='https://opencode.ai/v2/install'
  opencode_install="$(curl -fsSL "$opencode_install_url")" \
    || die 'failed to download opencode install script'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  opencode_conf_filename='tui.json'
  opencode_conf_url="${setup_configs_url}/${opencode_conf_filename}"
  opencode_conf_path="${HOME}/.config/opencode/${opencode_conf_filename}"

  info 'installing opencode...'

  bash -c "$opencode_install" \
    || die 'failed to install opencode'

  success 'opencode installed'

  info 'configuring opencode...'

  curl \
      --create-dirs \
      --fail \
      --location \
      --output "$opencode_conf_path" \
      "$opencode_conf_url" \
    || die 'failed to configure opencode'

  success 'opencode configured'
}

main "$@"
