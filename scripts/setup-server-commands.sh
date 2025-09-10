#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to install custom server commands globally for all users
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-server-commands.sh | bash -

AUTOUPGRADE=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/autoupgrade.sh
TEMPS=https://raw.githubusercontent.com/xmready/system-setup/main/scripts/temps.sh
DNS_LEAK_TEST_URL=https://raw.githubusercontent.com/macvk/dnsleaktest/refs/heads/master/dnsleaktest.sh

echo -e "\n$(tput setaf 3)installing custom server commands\n$(tput sgr0)" \
&& sudo curl -fLo /usr/local/bin/autoupgrade "$AUTOUPGRADE" \
&& sudo curl -fLo /usr/local/bin/temps "$TEMPS" \
&& sudo curl -fLo /usr/local/bin/whatsmyip "$DNS_LEAK_TEST_URL" \
&& sudo chmod +x /usr/local/bin/* \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)custom server commands installed\n$(tput sgr0)"
