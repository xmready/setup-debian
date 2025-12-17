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

remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
configs_path="/etc/kmonad"
configs_url="${remote_raw_url}/${remote_name}/main/configs"
configs_list='{config.kbd,k100air.kbd}'
device_file="$(ls /dev/input/by-path/*0-event-kbd 2>/dev/null | head -n 1)"
unit_file='kmonad@.service'
unit_path="/etc/systemd/system/${unit_file}"
unit_url="${configs_url}/kmonad%40.service"
udev_file="99-kmonad.rules"
udev_path="/etc/udev/rules.d/${udev_file}"
udev_url="${configs_url}/${udev_file}"

info 'installing kmonad...'
if [[ -x "${HOME}/.cabal/bin/kmonad" ]]; then
  info "kmonad already installed, skipping"
else
  cabal install --overwrite-policy=always kmonad || exit 1
  success 'kmonad installed'
fi

info 'configuring kmonad...' \
&& sudo mkdir --parents "$configs_path" \
&& sudo ln -sf ${HOME}/.cabal/bin/kmonad /usr/bin/kmonad \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$configs_path" \
  --remote-name \
  "${configs_url}/${configs_list}" \
&& sudo sed -i "s|device_file|${device_file}|" ${configs_path}/config.kbd \
&& sudo curl --fail --location --output "$unit_path" "$unit_url" \
&& sudo curl --fail --location --output "$udev_path" "$udev_url" \
&& sudo udevadm control --reload \
&& sudo udevadm trigger \
&& sudo systemctl daemon-reload \
&& sudo systemctl enable kmonad@ \
&& success 'kmonad configured'
