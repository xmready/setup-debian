#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to harden network settings with firewall and timestamps conf
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-harden.sh | bash -

TIMESTAMPS_PATH=/etc/sysctl.d/90-tcp_timestamps.conf
TIMESTAMPS_URL=https://raw.githubusercontent.com/xmready/setup-debian/main/configs/90-tcp_timestamps.conf

echo -e "\n$(tput setaf 3)disabling tcp timestamps\n$(tput sgr0)" \
&& sudo curl -fLo "$TIMESTAMPS_PATH" "$TIMESTAMPS_URL" \
&& sudo sysctl -q --system 2> /dev/null \
&& sudo sysctl -a 2> /dev/null | grep timestamps \
&& echo -e "\n$(tput setaf 2)tcp timestamps disabled\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)configuring firewall\n$(tput sgr0)" \
&& sudo ufw default deny incoming \
&& sudo ufw default allow outgoing \
&& sudo ufw --force enable \
&& sudo ufw status verbose \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)firewall configured\n$(tput sgr0)"
