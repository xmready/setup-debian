#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure clamav
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-clamav.sh | bash -

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

sudo_append_line() {
  grep --quiet --line-regexp --fixed-strings -- "$1" "$2" \
    || printf '%s\n' "$1" | sudo tee -a "$2" >/dev/null
}

sudo_append_blank_line() {
  if [[ -n "$(tail -n 1 "$1")" ]]; then
    printf '\n' | sudo tee -a "$1" >/dev/null
  fi
}

sudo_replace_block() {
  local file="$1" begin="$2" end="$3" content="$4" tmp status

  if grep --quiet --line-regexp --fixed-strings -- "$begin" "$file"; then
    tmp="$(mktemp)" \
      && BEGIN="$begin" END="$end" CONTENT="$content" awk '
        $0 == ENVIRON["BEGIN"]         { print; print ENVIRON["CONTENT"]; skip = 1; next }
        $0 == ENVIRON["END"] && skip   { skip = 0 }
        !skip
        END { if (skip) exit 3 }
      ' "$file" > "$tmp" \
      && sudo tee "$file" < "$tmp" >/dev/null

    status=$?

    rm -f -- "$tmp"

    if [[ "$status" -eq 3 ]]; then
      err "setup-debian end marker missing after start marker in ${file}: ${end}"
    fi

    return "$status"
  else
    sudo_append_blank_line "$file" \
      && printf '%s\n' "$begin" "$content" "$end" | sudo tee -a "$file" >/dev/null
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  clamd_conf_filename='clamd.conf'
  clamd_conf_url="${setup_configs_url}/${clamd_conf_filename}"
  clamd_begin='# >>> setup-debian >>>'
  clamd_end='# <<< setup-debian <<<'
  clamd_conf="$(curl -fsSL "$clamd_conf_url")" \
    || die "failed to download ${clamd_conf_filename}"
  clamd_conf_path="/etc/clamav/${clamd_conf_filename}"
  clamav_tmp_path='/tmp/clamav'
  tmpfiles_path='/etc/tmpfiles.d/clamav-tmp.conf'
  setup_scripts_url="${remote_raw_url}/${setup_remote_name}/${version}/scripts"
  alert_filename='clamav-virus-alert.sh'
  alert_url="${setup_scripts_url}/${alert_filename}"
  alert_path="/etc/clamav/virusevent.d/${alert_filename}"
  apparmor_local_path='/etc/apparmor.d/local/usr.sbin.clamd'
  sudoers_tmp_path="$(mktemp)" \
    || die 'failed to create clamav sudoers tmp file'
  sudoers_path='/etc/sudoers.d/clamav-notify'
  unit_path='/etc/systemd/system'
  unit_list='{clamdscan.service,clamdscan.timer}'

  trap 'rm -f -- "$sudoers_tmp_path"' EXIT

  info 'installing clamav...'

  apt_get update \
    && apt_get install clamav clamav-daemon libnotify-bin \
    || die 'failed to install clamav'

  success 'clamav installed'

  info 'configuring clamav...'

  sudo_replace_block "$clamd_conf_path" "$clamd_begin" "$clamd_end" "$clamd_conf" \
    && sudo sed \
      --in-place \
      --follow-symlinks \
      "s|current_user|${USER}|" \
      "$clamd_conf_path" \
    && printf '%s\n' "d ${clamav_tmp_path} 0700 clamav clamav -" \
      | sudo tee "$tmpfiles_path" >/dev/null \
    && sudo curl \
      --fail \
      --location \
      --output "$alert_path" \
      "$alert_url" \
    && sudo sed \
      --in-place \
      --follow-symlinks \
      "s|current_user|${USER}|" \
      "$alert_path" \
    && sudo chmod +x "$alert_path" \
    && sudo_append_line '/usr/bin/{dash,bash} ix,' "$apparmor_local_path" \
    && sudo_append_line "${alert_path} Ux," "$apparmor_local_path" \
    && printf '%s\n' \
      'Defaults:clamav env_keep += "DBUS_SESSION_BUS_ADDRESS"' \
      "clamav ALL=(${USER}) NOPASSWD: /usr/bin/notify-send" \
      > "$sudoers_tmp_path" \
    && sudo visudo --check --file "$sudoers_tmp_path" \
    && sudo install \
      --mode 0440 \
      --owner root \
      --group root \
      "$sudoers_tmp_path" "$sudoers_path" \
    && sudo curl \
      --fail \
      --location \
      --output-dir "$unit_path" \
      --remote-name \
      "${setup_configs_url}/${unit_list}" \
    && sudo mkdir --parents /root/quarantine \
    && sudo systemctl daemon-reload \
    && sudo systemctl enable \
      clamav-clamonacc.service \
      clamav-daemon.service \
      clamav-freshclam.service \
      clamdscan.timer \
    || die 'failed to configure clamav'

  success 'clamav configured'

  info 'waiting for freshclam to download signatures...'

  sudo systemctl start clamav-freshclam.service \
    && timeout 500 bash -c 'until compgen -G "/var/lib/clamav/main.c[vl]d" >/dev/null && compgen -G "/var/lib/clamav/daily.c[vl]d" >/dev/null; do sleep 5; done' \
    || die 'failed to download freshclam signatures'

  success 'freshclam signatures downloaded'

  info 'REBOOT REQUIRED'
}

main "$@"
