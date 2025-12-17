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
die() { err "$@"; exit 1; }

apt_get() {
  sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFNEW=1 apt-get --assume-yes \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confnew \
    "$@"
}

ensure_final_newline() {
  if [[ -n "$(tail -c 1 "$1")" ]]; then
    printf '\n' >> "$1"
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  ghcup_url='https://get-ghcup.haskell.org'
  ghcup_install="$(curl -fsSL "$ghcup_url")" \
    || die 'failed to download ghcup install script'
  bashrc_path="${HOME}/.bashrc"
  ghcup_env_path="${HOME}/.ghcup/env"

  info 'installing ghcup dependencies...'

  apt_get update \
    && apt_get install \
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
    || die 'failed to install ghcup dependencies'

  success 'ghcup dependencies installed'

  info 'installing ghcup...'

  BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=1 bash -c "$ghcup_install" \
    || die 'failed to install ghcup'

  success 'ghcup installed'

  info 'configuring ghcup...'

  ensure_final_newline "$bashrc_path" \
    && [[ -f "$ghcup_env_path" ]] \
    && \. "$ghcup_env_path" \
    || die 'failed to configure ghcup'

  ghcup --version \
    || die 'ghcup is not working'

  success 'ghcup configured'
}

main "$@"
