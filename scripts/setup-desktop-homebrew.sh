#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure Homebrew
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-homebrew.sh | bash -

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
remote_name_homebrew="Homebrew/install"
homebrew_url="${remote_raw_url}/${remote_name_homebrew}/HEAD/install.sh"
bashrc_path="${HOME}/.bashrc"

info 'installing homebrew dependencies...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes \
  build-essential \
  gcc \
&& success 'homebrew dependencies installed' \
&& info 'installing homebrew...' \
&& curl --fail --location "$homebrew_url" | bash - \
&& printf '\n%s' 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> "$bashrc_path" \
&& eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)" \
&& brew analytics off \
&& brew install \
  clamav \
  ktlint \
&& success 'homebrew installed'
