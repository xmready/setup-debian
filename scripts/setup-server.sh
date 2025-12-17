#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup a new debian based server install
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/setup-server.sh | bash -

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
  err "Error: sudo login failed"
  exit 1
else
  info 'Downloading files..'
fi

github_url="https://github.com/xmready/setup-debian"
github_raw_url="https://raw.githubusercontent.com/xmready/setup-debian"
setup_server_file="setup-server.sh"
setup_server_path="/tmp/${setup_server_file}"
setup_server_url="${github_url}/releases/latest/download/${setup_server_file}"

if [ ! -f "$setup_server_path" ]; then
  curl --fail --location --show-error --silent --output "$setup_server_path" "$setup_server_url" || {
    err "Error: download failed for ${setup_server_url}"
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
  "${script_url_base}/setup-server-apt.sh"
  "${script_url_base}/setup-server-shell.sh"
  "${script_url_base}/setup-server-vim.sh"
  "${script_url_base}/setup-apt-clean.sh"
  "${script_url_base}/setup-server-commands.sh"
  "${script_url_base}/setup-server-harden.sh"
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

sha256sums_file="SHA256SUMS_SERVER"
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
