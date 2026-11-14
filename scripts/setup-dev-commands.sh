#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install custom commands for the current user in a development VM
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev-commands.sh | bash -

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

  commands_path="${HOME}/bin"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_scripts_url="${remote_raw_url}/${setup_remote_name}/${version}/scripts"
  commands=(
    'autoupgrade-dev'
  )
  commands_list="{$(IFS=,; printf '%s' "${commands[*]}")}"

  info 'installing custom commands...'

  curl \
      --create-dirs \
      --fail \
      --location \
      --output-dir "$commands_path" \
      --remote-name \
      "${setup_scripts_url}/${commands_list}" \
    && chmod 700 -- "${commands[@]/#/${commands_path}/}" \
    || die 'failed to install custom commands'

  success 'custom commands installed'
}

main "$@"
