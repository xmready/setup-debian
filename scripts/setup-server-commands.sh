#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install custom server commands globally for all users
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-commands.sh | bash -

commands_path="/usr/bin"
commands_url="https://raw.githubusercontent.com/xmready/setup-debian/main/scripts"
commands_list='{autoupgrade-server,temps,dnsleaktest}'

echo -e "\n$(tput setaf 3)installing custom server commands\n$(tput sgr0)" \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$commands_path" \
  --remote-name \
  "${commands_url}/${commands_list}" \
&& sudo chmod +x "${commands_path}/*" \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)custom server commands installed\n$(tput sgr0)"
