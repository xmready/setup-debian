#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to install custom commands globally for all users
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-commands.sh | bash -

AUTO_UPGRADE_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/autoupgrade.sh
TEMPS_URL=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/temps.sh
DNS_LEAK_TEST_URL=https://raw.githubusercontent.com/macvk/dnsleaktest/refs/heads/master/dnsleaktest.sh

echo -e "\n$(tput setaf 3)installing custom commands\n$(tput sgr0)" \
&& sudo curl -fLo /usr/local/bin/autoupgrade "$AUTO_UPGRADE_URL" \
&& sudo curl -fLo /usr/local/bin/temps "$TEMPS_URL" \
&& sudo curl -fLo /usr/local/bin/dnsleaktest "$DNS_LEAK_TEST_URL" \
&& sudo chmod +x /usr/local/bin/* \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)custom commands installed\n$(tput sgr0)"
