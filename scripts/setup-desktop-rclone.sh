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

  arch="$(dpkg --print-architecture)" \
    || die 'failed to get system architecture'
  rclone_deb_path="$(mktemp --suffix=.deb)" \
    || die 'failed to create rclone deb tmp file'
  rclone_deb_url="https://downloads.rclone.org/rclone-current-linux-${arch}.deb"
  gdrive_path='/mnt/gdrive'
  vault_path='/mnt/vault'
  unit_path='/etc/systemd/system'
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  unit_files=(
    'mnt-gdrive.service'
    'mnt-gdrive-crypt.service'
  )
  unit_list="{$(IFS=,; printf '%s' "${unit_files[*]}")}"

  trap 'rm -f -- "$rclone_deb_path"' EXIT

  info 'installing rclone...'

  curl \
      --fail \
      --location \
      --output "$rclone_deb_path" \
      "$rclone_deb_url" \
    && chmod 644 "$rclone_deb_path" \
    && apt_get install "$rclone_deb_path" \
    || die 'failed to install rclone'

  success 'rclone installed'

  info 'configuring rclone...'

  sudo install \
      --directory \
      --owner="$USER" \
      --group="$USER" \
      "$gdrive_path" "$vault_path" \
    && mkdir --parents "${HOME}/.config/rclone" \
    && sudo curl \
      --fail \
      --location \
      --output-dir "$unit_path" \
      --remote-name \
      "${setup_configs_url}/${unit_list}" \
    && sudo sed \
      --in-place \
      --follow-symlinks \
      --expression "s/^User=.*/User=${USER}/" \
      --expression "s/^Group=.*/Group=${USER}/" \
      "${unit_files[@]/#/${unit_path}/}" \
    && sudo systemctl daemon-reload \
    || die 'failed to configure rclone'

  success 'rclone configured'
}

main "$@"
