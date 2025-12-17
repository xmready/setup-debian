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

success() { local msg="$*"; echo "${green}${bold}${msg}${reset}"; }
info() { local msg="$*"; echo "${yellow}${bold}${msg}${reset}"; }
err() { local msg="$*"; echo "${red}${bold}${msg}${reset}${bel}" >&2; }

if ! sudo -v; then
  err "Error: sudo authentication failed"
  exit 1
else
  info 'Downloading files..'
fi

github_url="https://github.com/xmready/setup-debian"
github_raw_url="https://raw.githubusercontent.com/xmready/setup-debian"
setup_desktop_file="setup-desktop.sh"
setup_desktop_path="/tmp/${setup_desktop_file}"
setup_desktop_url="${github_url}/releases/latest/download/${setup_desktop_file}"

if [ ! -f "$setup_desktop_path" ]; then
  curl --fail --location --show-error --silent --output "$setup_desktop_path" "$setup_desktop_url" || {
    err "Error: download failed for ${setup_desktop_url}"
    exit 1
  }
fi

get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |
  grep tag_name |
  sed -E 's/.*"([^"]+)".*/\1/'
}

version="$(get_latest_release xmready/setup-debian)" || { err "Error: failed to get setup-debian version"; exit 1; }
script_url_base="${github_raw_url}/${version}/scripts"
script_urls=(
  "${script_url_base}/setup-desktop-apt.sh"
  "${script_url_base}/setup-desktop-shell.sh"
  "${script_url_base}/setup-desktop-tor.sh"
  "${script_url_base}/setup-desktop-signal.sh"
  "${script_url_base}/setup-nvm.sh"
  "${script_url_base}/setup-desktop-vim.sh"
  "${script_url_base}/setup-desktop-rclone.sh"
  "${script_url_base}/setup-apt-clean.sh"
  "${script_url_base}/setup-desktop-flatpak.sh"
  "${script_url_base}/setup-desktop-commands.sh"
  "${script_url_base}/setup-desktop-harden.sh"
)

for url in "${script_urls[@]}"; do
  outfile="/tmp/$(basename "$url")"

  if ! curl --fail --location --show-error --silent --output "$outfile" "$url"; then
    err "Error: download failed for ${url}"
    exit 1
  fi

  if ! chmod +x "$outfile"; then
    err "Error: chmod failed for ${outfile}"
    exit 1
  fi
done

sha256sums_file="SHA256SUMS_DESKTOP"
sha256sums_path="/tmp/${sha256sums_file}"
sha256sums_url="${github_url}/releases/latest/download/${sha256sums_file}"

if [ ! -f "$sha256sums_path" ]; then
  curl --fail --location --show-error --silent --output "$sha256sums_path" "$sha256sums_url" || {
    err "Error: download failed for ${sha256sums_url}"
    exit 1
  }
fi

if ! cd /tmp; then
  err "Error: failed to change working directory to /tmp"
  exit 1
fi

if sha256sum --check --status "$sha256sums_path"; then
  success "Checksum verification successful"
else
  err "Error: checksum verification failed for ${sha256sums_path}"
  exit 1
fi

for url in "${script_urls[@]}"; do
  outfile="/tmp/$(basename "$url")"

  if ! bash "$outfile"; then
    err "Error: ${outfile} failed"
    exit 1
  fi
done

if sudo shutdown -r +1; then
  info "SYSTEM WILL REBOOT IN 60 SECONDS"
  exit 0
else
  err "Error: System reboot failed"
  exit 1
fi
