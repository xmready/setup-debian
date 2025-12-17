#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure ghcup
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-ghcup.sh | bash -

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

ghcup_url="https://get-ghcup.haskell.org"
bashrc_path="${HOME}/.bashrc"

info 'installing ghcup dependencies...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes \
  build-essential \
  curl \
  libffi-dev \
  libffi8 \
  libgmp-dev \
  libgmp10 \
  libncurses-dev \
  libncurses6 \
  libtinfo6 \
  pkg-config \
&& success 'ghcup dependencies installed' \
&& info 'installing ghcup...' \
&& curl --fail --location "$ghcup_url" | bash - \
&& [[ -f "/home/${USER}/.ghcup/env" ]] \
&& \. "/home/${USER}/.ghcup/env" \
&& cabal update \
&& cabal install --overwrite-policy=always \
  kmonad \
&& success 'ghcup installed'
