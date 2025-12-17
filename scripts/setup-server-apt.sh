#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure packages with apt
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-apt.sh | bash -

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

info 'upgrading packages...' \
&& sudo apt-get update \
&& sudo apt-get upgrade --assume-yes \
&& sudo apt-get full-upgrade --assume-yes \
&& success 'packages upgraded' \
&& sleep 3 \
&& sudo --validate \
&& info 'installing packages...' \
&& sudo apt-get install --assume-yes \
  curl \
  fail2ban \
  git \
  gnupg \
  lm-sensors \
  rsync \
  screen \
  ufw \
&& sudo --validate \
&& success 'packages installed'
