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

[[ ${EUID} -ne 0 ]] || { err 'run as your normal sudo user, not root'; exit 1; }

remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
configs_url="${remote_raw_url}/${remote_name}/main/configs"
clamd_conf_url="${configs_url}/clamd.conf"
clamd_conf_path="/etc/clamav/clamd.conf"
tmp_path="/tmp/clamav"
tmpfiles_path="/etc/tmpfiles.d/clamav-tmp.conf"
alert_script="clamav-virus-alert.sh"
alert_url="${remote_raw_url}/${remote_name}/main/scripts/${alert_script}"
alert_path="/etc/clamav/virusevent.d/${alert_script}"
sudoers_tmp_path="$(mktemp)"
sudoers_path="/etc/sudoers.d/clamav-notify"
unit_path="/usr/lib/systemd/system"
unit_list='{clamdscan.service,clamdscan.timer}'

info 'installing clamav...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes clamav clamav-daemon libnotify-bin \
&& success 'clamav installed' \
&& info 'configuring clamav...' \
&& curl --fail --location ${clamd_conf_url} | sudo tee -a ${clamd_conf_path} >/dev/null \
&& sudo sed --in-place "s|current_user|${USER}|" ${clamd_conf_path} \
&& printf '%s\n' "d ${tmp_path} 0700 clamav clamav -" | sudo tee ${tmpfiles_path} >/dev/null \
&& sudo curl --fail --location --output ${alert_path} ${alert_url} \
&& sudo sed --in-place "s|current_user|${USER}|" ${alert_path} \
&& sudo chmod +x ${alert_path} \
&& printf '%s\n' '/usr/bin/dash ix,' "${alert_path} Ux," | sudo tee -a /etc/apparmor.d/local/usr.sbin.clamd >/dev/null \
&& printf '%s\n' 'Defaults:clamav env_keep += "DBUS_SESSION_BUS_ADDRESS"' "clamav ALL=(${USER}) NOPASSWD: /usr/bin/notify-send" > ${sudoers_tmp_path} \
&& sudo visudo --check --file ${sudoers_tmp_path} \
&& sudo install --mode 0440 --owner root --group root ${sudoers_tmp_path} ${sudoers_path} \
&& rm --force ${sudoers_tmp_path} \
&& sudo curl \
  --fail \
  --location \
  --output-dir ${unit_path} \
  --remote-name \
  "${configs_url}/${unit_list}" \
&& sudo mkdir --parents /root/quarantine \
&& sudo systemctl daemon-reload \
&& sudo systemctl enable clamav-daemon clamav-freshclam.service clamav-clamonacc.service clamdscan.timer \
&& success 'clamav configured' \
&& info 'waiting for freshclam to download signatures...' \
&& sudo systemctl start clamav-freshclam.service \
&& timeout 500 bash -c 'until compgen -G "/var/lib/clamav/main.c[vl]d" >/dev/null && compgen -G "/var/lib/clamav/daily.c[vl]d" >/dev/null; do sleep 5; done' \
&& success 'freshclam signatures downloaded' \
&& info 'REBOOT REQUIRED'
