#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure Homebrew
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev-homebrew.sh | bash -

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

append_blank_line() {
  if [[ -n "$(tail -n 1 "$1")" ]]; then
    printf '\n' >> "$1"
  fi
}

append_line() {
  grep --quiet --line-regexp --fixed-strings -- "$1" "$2" \
    || { append_blank_line "$2" && printf '%s\n' "$1" >> "$2"; }
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  remote_raw_url='https://raw.githubusercontent.com'
  homebrew_remote_name='Homebrew/install'
  homebrew_url="${remote_raw_url}/${homebrew_remote_name}/HEAD/install.sh"
  homebrew_install="$(curl -fsSL "$homebrew_url")" \
    || die 'failed to download homebrew install script'
  bashrc_path="${HOME}/.bashrc"
  brew_shellenv='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"'

  info 'installing homebrew dependencies...'

  apt_get update \
    && apt_get install \
      build-essential \
      curl \
      file \
      git \
      procps \
    || die 'failed to install homebrew dependencies'

  success 'homebrew dependencies installed'

  info 'installing homebrew...'

  NONINTERACTIVE=1 bash -c "$homebrew_install" \
    && append_line "$brew_shellenv" "$bashrc_path" \
    && eval "$brew_shellenv" \
    && brew analytics off \
    || die 'failed to install homebrew'

  success 'homebrew installed'
}

main "$@"
