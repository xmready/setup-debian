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
die() { err "$@"; exit 1; }

ensure_authorized_key() {
  local ssh_path="${HOME}/.ssh"
  local auth_keys_path="${ssh_path}/authorized_keys"
  local key

  ssh-keygen -l -f "$auth_keys_path" > /dev/null 2>&1 && return 0

  if ! { : < /dev/tty; } 2>/dev/null; then
    err "no SSH key in ${auth_keys_path} and no terminal to ask for one"
    return 1
  fi

  info "No SSH key found in ${auth_keys_path}."
  info 'Password logins are about to be disabled.'
  info 'Paste your public key (the contents of e.g. ~/.ssh/id_ed25519.pub) and press Enter:'

  while true; do
    read -r key < /dev/tty || return 1
    key="${key%$'\r'}"
    if ssh-keygen -l -f - <<< "$key" > /dev/null 2>&1; then
      break
    fi
    err 'that is not a valid SSH public key, try again (Ctrl-D to cancel)'
  done

  install -d -m 0700 "$ssh_path" \
    && printf '%s\n' "$key" >> "$auth_keys_path" \
    && chmod 600 "$auth_keys_path"
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  ensure_authorized_key || die 'an SSH key is required before password logins are disabled'

  stamps_conf_filename='90-tcp_timestamps.conf'
  stamps_conf_path="/etc/sysctl.d/${stamps_conf_filename}"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  stamps_conf_url="${setup_configs_url}/${stamps_conf_filename}"
  host_key_path='/etc/ssh/ssh_host_ed25519_key'
  ssh_conf_filename='90-ssh-hardening.conf'
  ssh_conf_path="/etc/ssh/sshd_config.d/${ssh_conf_filename}"
  ssh_conf_url="${setup_configs_url}/${ssh_conf_filename}"

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
    && sudo ufw allow ssh \
    && sudo ufw --force enable \
    || die 'failed to configure firewall'

  success 'firewall configured'

  sudo ufw status verbose \
    || die 'failed to get ufw status'

  info 'hardening sshd...'

  sudo rm --force /etc/ssh/ssh_host_* \
    && sudo ssh-keygen -t ed25519 -f "$host_key_path" -N '' \
    && sudo curl \
      --fail \
      --location \
      --output "$ssh_conf_path" \
      "$ssh_conf_url" \
    && sudo chmod 644 "$ssh_conf_path" \
    || die 'failed to harden sshd'

  trap 'sudo rm --force -- "$ssh_conf_path"' EXIT

  sudo sshd -t \
    || die 'sshd rejected the hardened config, it was removed'

  trap - EXIT

  sudo systemctl reload ssh \
    || die 'failed to reload ssh config'

  success 'sshd hardened'
}

main "$@"
