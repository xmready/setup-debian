#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure packages with apt
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-apt.sh | bash -

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

set_flatpak_plugin() {
  case "$XDG_CURRENT_DESKTOP" in
    GNOME)
      flatpak_plugin="gnome-software-plugin-flatpak"
      ;;
    KDE)
      flatpak_plugin="plasma-discover-backend-flatpak"
      ;;
    *)
      echo "Error: Only Gnome and Plasma environments are supported: $XDG_CURRENT_DESKTOP" >&2
      flatpak_plugin="unknown-plugin"  # Default value if no match is found
      return 2
      ;;
  esac
}

info "upgrading packages" \
&& sudo apt-get update \
&& sudo apt-get upgrade --assume-yes \
&& sudo apt-get full-upgrade --assume-yes \
&& sudo --validate \
&& success "packages upgraded" \
&& sleep 3 \
&& info "installing packages" \
&& set_flatpak_plugin \
&& sudo apt-get install --assume-yes \
  bash-completion \
  build-essential \
  checkinstall \
  curl \
  fastfetch \
  ffmpeg \
  flatpak \
  "$flatpak_plugin" \
  fprintd \
  fzf \
  git \
  gnupg \
  incus \
  libpam-fprintd \
  lm-sensors \
  nmap \
  pipx \
  python3-pip \
  qrencode \
  rename \
  rsync \
  ssh-audit \
  ufw \
  wget \
&& success "packages installed"
