#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to harden server network settings with firewall and timestamps conf
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/scripts/harden-server-network.sh | bash -

TIME_STAMPS_PATH=/etc/sysctl.d/90-tcp_timestamps.conf
TIME_STAMPS_URL=https://raw.githubusercontent.com/xmready/system-setup/main/configs/90-tcp_timestamps.conf
HOST_KEY=/etc/ssh/ssh_host_ed25519_key
SSH_HARDEN=/etc/ssh/sshd_config.d/90-ssh-hardening.conf
SSHD_URL=https://raw.githubusercontent.com/xmready/system-setup/main/configs/90-ssh-hardening.conf

echo -e "\n$(tput setaf 3)disabling tcp timestamps\n$(tput sgr0)" \
&& sudo curl -fLo "$TIME_STAMPS_PATH" "$TIME_STAMPS_URL" \
&& sudo sysctl -q --system 2> /dev/null \
&& sudo sysctl -a 2> /dev/null | grep timestamps \
&& echo -e "\n$(tput setaf 2)tcp timestamps disabled\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)configuring firewall\n$(tput sgr0)" \
&& sudo ufw default deny incoming \
&& sudo ufw default allow outgoing \
&& sudo ufw allow 22/tcp \
&& sudo ufw --force enable \
&& sudo ufw status verbose \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)firewall configured\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)hardening sshd\n$(tput sgr0)" \
&& sudo rm /etc/ssh/ssh_host_* \
&& sudo ssh-keygen -t ed25519 -f "$HOST_KEY" -N "" \
&& sudo curl -fLo "$SSH_HARDEN" "$SSHD_URL" \
&& sudo chmod 644 /etc/ssh/sshd_config.d/* \
&& sudo systemctl reload sshd \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)sshd hardened\n$(tput sgr0)"
