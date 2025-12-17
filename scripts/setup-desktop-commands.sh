#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install custom commands globally for all users
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-commands.sh | bash -

commands_path="/home/${USER}/bin"
commands_url="https://raw.githubusercontent.com/xmready/setup-debian/main/scripts"
commands_list='{autoupgrade,temps,dnsleaktest,gdrive-start,gdrive-status,gdrive-stop}'

echo -e "\n$(tput setaf 3)installing custom commands\n$(tput sgr0)" \
&& curl \
  --create-dirs \
  --fail \
  --location \
  --output-dir "$commands_path" \
  --remote-name \
  "${commands_url}/${commands_list}" \
&& chmod +x "${commands_path}/*" \
&& echo -e "\n$(tput setaf 2)custom commands installed\n$(tput sgr0)"
