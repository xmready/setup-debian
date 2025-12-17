#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to harden server network settings with firewall and timestamps conf
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-harden.sh | bash -

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

time_stamps_path="/etc/sysctl.d/90-tcp_timestamps.conf"
time_stamps_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-tcp_timestamps.conf"
host_key="/etc/ssh/ssh_host_ed25519_key"
ssh_config_path="/etc/ssh/sshd_config.d/90-ssh-hardening.conf"
ssh_config_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-ssh-hardening.conf"

info 'disabling tcp timestamps...' \
&& sudo curl --fail --location --output "$time_stamps_path" "$time_stamps_url" \
&& sudo sysctl --quiet --system 2> /dev/null \
&& sudo sysctl --all 2> /dev/null | grep timestamps \
&& success 'tcp timestamps disabled' \
&& sleep 3 \
&& info 'configuring firewall...' \
&& sudo ufw default deny incoming \
&& sudo ufw default allow outgoing \
&& sudo ufw allow SSH \
&& sudo ufw --force enable \
&& sudo ufw status verbose \
&& sudo --validate \
&& success 'firewall configured' \
&& sleep 3 \
&& info 'hardening sshd...' \
&& sudo rm /etc/ssh/ssh_host_* \
&& sudo ssh-keygen -t ed25519 -f "$host_key" -N "" \
&& sudo curl --fail --location --output "$ssh_config_path" "$ssh_config_url" \
&& sudo chmod 644 /etc/ssh/sshd_config.d/* \
&& sudo systemctl reload sshd \
&& sudo --validate \
&& success 'sshd hardened'
