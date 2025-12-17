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
die() { err "$@"; exit 1; }

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  stamps_conf_filename='90-tcp_timestamps.conf'
  stamps_conf_path="/etc/sysctl.d/${stamps_conf_filename}"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  stamps_conf_url="${setup_configs_url}/${stamps_conf_filename}"

  info 'disabling tcp timestamps...'

  sudo curl \
      --fail \
      --location \
      --output "$stamps_conf_path" \
      "$stamps_conf_url" \
    && sudo sysctl --quiet --load="$stamps_conf_path" \
    && [[ "$(sysctl -n net.ipv4.tcp_timestamps)" == 0 ]] \
    || die 'failed to disable tcp timestamps'

  success 'tcp timestamps disabled'

  info 'configuring firewall...'

  sudo ufw default deny incoming \
    && sudo ufw default allow outgoing \
    && sudo ufw --force enable \
    || die 'failed to configure firewall'

  success 'firewall configured'

  sudo ufw status verbose \
    || die 'failed to get ufw status'
}

main "$@"
