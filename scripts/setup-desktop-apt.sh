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

set_flatpak_plugin() {
  case "${XDG_CURRENT_DESKTOP:-}" in
    *GNOME*)
      flatpak_plugin='gnome-software-plugin-flatpak'
      ;;
    *KDE*)
      flatpak_plugin='plasma-discover-backend-flatpak'
      ;;
    *)
      die "only Gnome and Plasma environments are supported: ${XDG_CURRENT_DESKTOP:-current desktop not set}"
      ;;
  esac
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  set_flatpak_plugin

  info 'upgrading deb packages...'

  apt_get update \
    && apt_get upgrade \
    && apt_get full-upgrade \
    || die 'failed to upgrade deb packages'

  success 'deb packages upgraded'

  sudo --validate || die 'sudo authentication failed'

  info 'installing deb packages...'

  apt_get install \
      bash-completion \
      btop \
      btrfs-progs \
      build-essential \
      checkinstall \
      clamav \
      clamav-daemon \
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
      libnotify-bin \
      libpam-fprintd \
      lm-sensors \
      myrepos \
      nmap \
      pipx \
      qrencode \
      rename \
      ripgrep \
      rsync \
      ssh-audit \
      tmux \
      ufw \
      virt-viewer \
      wget \
      wl-clipboard \
    || die 'failed to install deb packages'

  success 'deb packages installed'
}

main "$@"
