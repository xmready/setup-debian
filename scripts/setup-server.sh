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
err() { local msg="$*"; echo "${red}${bold}Error: ${msg}${reset}${bel}" >&2; }

if ! sudo --validate; then
  err "sudo login failed"
  exit 1
fi

info 'Downloading setup files..'

remote_url="https://github.com"
remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
setup_server_file="setup-server.sh"
setup_server_path="/tmp/${setup_server_file}"
setup_server_url="${remote_url}/${remote_name}/releases/latest/download/${setup_server_file}"

if [ ! -f "$setup_server_path" ]; then
  curl --fail --location --show-error --silent --output "$setup_server_path" "$setup_server_url" || {
    err "download failed for ${setup_server_url}"
    exit 1
  }
fi

get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |
  grep tag_name |
  sed -E 's/.*"([^"]+)".*/\1/'
}

version="$(get_latest_release ${remote_name})" || { err "failed to get ${remote_name} version"; exit 1; }
scripts_url="${remote_raw_url}/${remote_name}/${version}/scripts"
script_files=(
  "setup-server-apt.sh"
  "setup-server-shell.sh"
  "setup-server-vim.sh"
  "setup-apt-clean.sh"
  "setup-server-commands.sh"
  "setup-server-harden.sh"
)

for file in "${script_files[@]}"; do
  outfile="/tmp/${file}"

  if ! curl --fail --location --show-error --silent --output "$outfile" "${scripts_url}/$file"; then
    err "download failed for ${file}"
    exit 1
  fi

  if ! chmod +x "$outfile"; then
    err "chmod failed for ${outfile}"
    exit 1
  fi
done

success "Setup files successfully downloaded"

sha256sums_file="SHA256SUMS_SERVER"
sha256sums_path="/tmp/${sha256sums_file}"
sha256sums_url="${remote_url}/${remote_name}/releases/latest/download/${sha256sums_file}"

if [ ! -f "$sha256sums_path" ]; then
  curl --fail --location --show-error --silent --output "$sha256sums_path" "$sha256sums_url" || {
    err "download failed for ${sha256sums_url}"
    exit 1
  }
fi

if ! cd /tmp; then
  err "failed to change working directory to /tmp"
  exit 1
fi

if sha256sum --check --status "$sha256sums_path"; then
  success "Checksum verification successful"
else
  err "checksum verification failed for ${sha256sums_path}"
  exit 1
fi

for file in "${script_files[@]}"; do
  runfile="/tmp/${file}"

  if ! bash "$runfile"; then
    err "${runfile} failed"
    exit 1
  fi
done

if sudo shutdown -r +1; then
  info "SYSTEM WILL REBOOT IN 60 SECONDS"
  exit 0
else
  err "System reboot failed"
  exit 1
fi
