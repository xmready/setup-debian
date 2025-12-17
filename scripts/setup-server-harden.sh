#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to harden server network settings with firewall and timestamps conf
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-harden.sh | bash -

time_stamps_path="/etc/sysctl.d/90-tcp_timestamps.conf"
time_stamps_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-tcp_timestamps.conf"
host_key="/etc/ssh/ssh_host_ed25519_key"
ssh_config_path="/etc/ssh/sshd_config.d/90-ssh-hardening.conf"
ssh_config_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-ssh-hardening.conf"

echo -e "\n$(tput setaf 3)disabling tcp timestamps\n$(tput sgr0)" \
&& sudo curl -fLo "$time_stamps_path" "$time_stamps_url" \
&& sudo sysctl -q --system 2> /dev/null \
&& sudo sysctl -a 2> /dev/null | grep timestamps \
&& echo -e "\n$(tput setaf 2)tcp timestamps disabled\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)configuring firewall\n$(tput sgr0)" \
&& sudo ufw default deny incoming \
&& sudo ufw default allow outgoing \
&& sudo ufw allow SSH \
&& sudo ufw --force enable \
&& sudo ufw status verbose \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)firewall configured\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)hardening sshd\n$(tput sgr0)" \
&& sudo rm /etc/ssh/ssh_host_* \
&& sudo ssh-keygen -t ed25519 -f "$host_key" -N "" \
&& sudo curl -fLo "$ssh_config_path" "$ssh_config_url" \
&& sudo chmod 644 /etc/ssh/sshd_config.d/* \
&& sudo systemctl reload sshd \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)sshd hardened\n$(tput sgr0)"
