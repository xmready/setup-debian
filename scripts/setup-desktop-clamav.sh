#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup and configure clamav
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

remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
configs_url="${remote_raw_url}/${remote_name}/main/configs"
config_clamd_url="${configs_url}/clamd.conf"
config_clamd_path="/etc/clamav/clamd.conf"
tmp_clam_path="/tmp/clamav"
extend_conf_path="/etc/systemd/system/clamav-daemon.service.d/extend.conf"
alert_virus_script="clamav-virus-alert.sh"
alert_virus_url="${remote_raw_url}/${remote_name}/main/scripts/${alert_virus_script}"
alert_virus_path="/etc/clamav/virusevent.d/${alert_virus_script}"
unit_path="/usr/lib/systemd/system"
unit_list='{clamdscan.service,clamdscan.timer}'

info 'installing clamav...'
if [[ -x "/usr/sbin/clamd" ]]; then
  info "clamav already installed, skipping"
else
  sudo apt-get update || exit 1
  sudo apt-get install -y clamav clamav-daemon || exit 1
  success 'clamav installed'
fi

info 'configuring clamav...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes libnotify-bin \
&& curl --fail --location ${config_clamd_url} | sudo tee -a ${config_clamd_path} >/dev/null \
&& sudo sed -i "s|current_user|${USER}|" ${config_clamd_path} \
&& printf '%s\n%s\n' "ExecStartPre=/bin/mkdir -p ${tmp_clam_path}" "ExecStartPre=/bin/chown clamav ${tmp_clam_path}" | sudo tee -a ${extend_conf_path} >/dev/null \
&& sudo curl --fail --location --output ${alert_virus_path} ${alert_virus_url} \
&& sudo sed -i "s|current_user|${USER}|" ${alert_virus_path} \
&& sudo chmod +x ${alert_virus_path} \
&& sudo curl \
  --fail \
  --location \
  --output-dir ${unit_path} \
  --remote-name \
  "${configs_url}/${unit_list}" \
&& sudo mkdir --parents /root/quarantine \
&& sudo systemctl daemon-reload \
&& sudo systemctl enable clamav-freshclam.service clamav-clamonacc.service clamdscan.timer \
&& sudo systemctl start clamav-freshclam.service \
&& success 'clamav configured'
