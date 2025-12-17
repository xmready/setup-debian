#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup a new debian based desktop/laptop
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/setup-desktop.sh | bash -

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

if ! sudo --validate; then
  err "sudo authentication failed"
  exit 1
fi

info 'downloading setup files...'

remote_url="https://github.com"
remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
setup_desktop_file="setup-desktop.sh"
setup_desktop_path="/tmp/${setup_desktop_file}"
version="v1.0.0"
scripts_url="${remote_raw_url}/${remote_name}/${version}/scripts"
setup_desktop_url="${scripts_url}/${setup_desktop_file}"

if [ ! -f "$setup_desktop_path" ]; then
  curl --fail --location --show-error --silent --output "$setup_desktop_path" "$setup_desktop_url" || {
    err "download failed for ${setup_desktop_url}"
    exit 1
  }
fi

script_files=(
  "setup-desktop-apt.sh"
  "setup-desktop-shell.sh"
  "setup-desktop-tor.sh"
  "setup-desktop-signal.sh"
  "setup-nvm.sh"
  "setup-desktop-vim.sh"
  "setup-desktop-rclone.sh"
  "setup-apt-clean.sh"
  "setup-desktop-flatpak.sh"
  "setup-desktop-opencode.sh"
  "setup-desktop-commands.sh"
  "setup-desktop-harden.sh"
)

cleanup() { rm /tmp/setup-*.sh /tmp/SHA256SUMS_*; }
trap cleanup EXIT

for file in "${script_files[@]}"; do
  outfile="/tmp/${file}"

  if ! curl --fail --location --show-error --silent --output "$outfile" "${scripts_url}/${file}"; then
    err "download failed for ${file}"
    exit 1
  fi

  if ! chmod +x "$outfile"; then
    err "chmod failed for ${outfile}"
    exit 1
  fi
done

success "setup files downloaded"

sha256sums_file="SHA256SUMS_DESKTOP"
sha256sums_path="/tmp/${sha256sums_file}"
sha256sums_url="${remote_url}/${remote_name}/releases/download/${version}/${sha256sums_file}"

if [ ! -f "$sha256sums_path" ]; then
  curl --fail --location --show-error --silent --output "$sha256sums_path" "$sha256sums_url" || {
    err "download failed for ${sha256sums_url}"
    exit 1
  }
fi

if ! cd /tmp; then
  err 'failed to change working directory to /tmp'
  exit 1
fi

if sha256sum --check --quiet "$sha256sums_path"; then
  success "checksums verified"
else
  err "checksum verification failed"
  exit 1
fi

for file in "${script_files[@]}"; do
  runfile="/tmp/${file}"

  if ! bash "$runfile"; then
    err "${runfile} failed"
    exit 1
  fi
done

if sudo shutdown --reboot +1; then
  info "SYSTEM WILL REBOOT IN 60 SECONDS"
  exit 0
else
  err "system reboot failed"
  exit 1
fi
