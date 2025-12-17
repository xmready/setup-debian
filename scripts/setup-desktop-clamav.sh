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
brew_path="/home/linuxbrew/.linuxbrew"
configs_path="${brew_path}/etc/clamav"
configs_url="${remote_raw_url}/${remote_name}/main/configs"
configs_list='{clamd.conf,freshclam.conf}'
scripts_url="${remote_raw_url}/${remote_name}/main/scripts"
alert_path="/usr/local/sbin"
alert_list='{clamav-virus-alert.sh,clamav-startscan-alert.sh,clamav-endscan-alert.sh}'
unit_path="/etc/systemd/system"
unit_list='{freshclam.service,clamd.service,clamdscan.service,clamdscan.timer,clamonacc.service}'

info 'installing clamav...'
if [[ -x "${brew_path}/sbin/clamd" ]]; then
  info "clamav already installed, skipping"
else
  brew install clamav || exit 1
  success 'clamav installed'
fi

info 'configuring clamav...' \
&& sudo apt-get update \
&& sudo apt-get install --assume-yes libnotify-bin \
&& sudo ln -sf ${brew_path}/bin/freshclam /usr/bin/ \
&& sudo ln -sf ${brew_path}/sbin/clamd /usr/sbin/ \
&& sudo ln -sf ${brew_path}/bin/clamdscan /usr/bin/ \
&& sudo ln -sf ${brew_path}/sbin/clamonacc /usr/sbin/ \
&& sudo mkdir --parents /etc/clamav \
&& curl \
  --fail \
  --location \
  --output-dir "$configs_path" \
  --remote-name \
  "${configs_url}/${configs_list}" \
&& sudo ln -sf ${configs_path}/freshclam.conf /etc/clamav/ \
&& sudo ln -sf ${configs_path}/clamd.conf /etc/clamav/ \
&& sed -i "s|current_home|${HOME}|" ${configs_path}/clamd.conf \
&& sed -i "s|current_user|${USER}|" ${configs_path}/freshclam.conf \
&& sudo chown root: ${configs_path}/{clamd.conf,freshclam.conf} \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$alert_path" \
  --remote-name \
  "${scripts_url}/${alert_list}" \
&& sudo sed -i "s|current_user|${USER}|" ${alert_path}/{clamav-virus-alert.sh,clamav-startscan-alert.sh,clamav-endscan-alert.sh} \
&& sudo chmod +x ${alert_path}/{clamav-virus-alert.sh,clamav-startscan-alert.sh,clamav-endscan-alert.sh} \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$unit_path" \
  --remote-name \
  "${configs_url}/${unit_list}" \
&& echo 'fs.inotify.max_user_watches=524288' | sudo tee /etc/sysctl.d/99-clamav-inotify.conf \
&& sudo sysctl -p /etc/sysctl.d/99-clamav-inotify.conf \
&& sudo systemctl daemon-reload \
&& sudo systemctl enable freshclam.service clamd.service clamdscan.timer clamonacc.service \
&& sudo systemctl start freshclam.service \
&& success 'clamav configured'
