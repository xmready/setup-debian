#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup and configure kmonad
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-kmonad.sh | bash -

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

get_keyboard() {
  local dev
  for dev in /dev/input/by-path/*-0-event-kbd /dev/input/by-path/*-event-kbd; do
    [[ -e "$dev" && "$dev" != *-usb* ]] || continue
    printf '%s\n' "$dev"
    return 0
  done
  return 1
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  ghcup_env_path="${HOME}/.ghcup/env"
  binary_source_path="${HOME}/.cabal/bin/kmonad"
  binary_target_path='/usr/local/bin/kmonad'
  configs_path='/etc/kmonad'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  configs_list='{config.kbd,k100air.kbd}'
  device_file="$(get_keyboard)" \
    || die 'failed to get keyboard device'
  unit_filename='kmonad@.service'
  unit_path="/etc/systemd/system/${unit_filename}"
  unit_url="${setup_configs_url}/kmonad%40.service"
  udev_filename='99-kmonad.rules'
  udev_path="/etc/udev/rules.d/${udev_filename}"
  udev_url="${setup_configs_url}/${udev_filename}"

  info 'installing kmonad...'

  [[ -f "$ghcup_env_path" ]] \
    && \. "$ghcup_env_path" \
    && cabal update \
    && cabal install --overwrite-policy=always kmonad \
    && sudo install \
      --mode 0755 \
      "$binary_source_path" "$binary_target_path" \
    || die 'failed to install kmonad'

  success 'kmonad installed'

  info 'configuring kmonad...'

  sudo mkdir --parents "$configs_path" \
    && sudo curl \
      --fail \
      --location \
      --output-dir "$configs_path" \
      --remote-name \
      "${setup_configs_url}/${configs_list}" \
    && sudo sed \
      --in-place \
      --follow-symlinks \
      "s|device_file|${device_file}|" \
      "$configs_path"/config.kbd \
    && sudo curl \
      --fail \
      --location \
      --output "$unit_path" \
      "$unit_url" \
    && sudo curl \
      --fail \
      --location \
      --output "$udev_path" \
      "$udev_url" \
    && sudo udevadm control --reload \
    && sudo udevadm trigger \
    && sudo systemctl daemon-reload \
    && sudo systemctl enable kmonad@ \
    || die 'failed to configure kmonad'

  success 'kmonad configured'
}

main "$@"
