#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup and configure rclone
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-rclone.sh | bash -

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

arch="$(dpkg --print-architecture)" || { err "failed to get system architecture"; exit 1; }
rclone_deb_path="/tmp/rclone.deb"
rclone_deb_url="https://downloads.rclone.org/rclone-current-linux-${arch}.deb"
gdrive_path="/mnt/gdrive"
vault_path="/mnt/vault"
unit_path="/lib/systemd/system"
unit_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs"
unit_list='{mnt-gdrive.service,mnt-gdrive-crypt.service}'

info 'installing rclone...' \
&& sudo --validate \
&& curl --fail --location --output "$rclone_deb_path" "$rclone_deb_url" \
&& sudo apt-get install --assume-yes "$rclone_deb_path" \
&& sudo install --directory --owner="$USER" --group="$USER" "$gdrive_path" "$vault_path" \
&& mkdir --parents ~/.config/rclone \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$unit_path" \
  --remote-name \
  "${unit_url}/${unit_list}" \
&& sudo sed -i "s/^User=.*/User=${USER}/" ${unit_path}/mnt-gdrive* \
&& sudo sed -i "s/^Group=.*/Group=${USER}/" ${unit_path}/mnt-gdrive* \
&& success 'rclone installed'
