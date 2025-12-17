#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to harden network settings with firewall and timestamps conf
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-harden.sh | bash -

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

timestamps_path="/etc/sysctl.d/90-tcp_timestamps.conf"
timestamps_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-tcp_timestamps.conf"

info 'disabling tcp timestamps...' \
&& sudo curl --fail --location --output "$timestamps_path" "$timestamps_url" \
&& sudo sysctl --quiet --system 2> /dev/null \
&& sudo sysctl --all 2> /dev/null | grep timestamps \
&& success 'tcp timestamps disabled' \
&& sleep 3 \
&& info 'configuring firewall...' \
&& sudo ufw default deny incoming \
&& sudo ufw default allow outgoing \
&& sudo ufw --force enable \
&& sudo ufw status verbose \
&& sudo --validate \
&& success 'firewall configured'
