#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to update, upgrade, and full-upgrade using apt
#
# sudo usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/command-server-autoupgrade.sh | bash -

echo -e "\n$(tput setaf 3)upgrading apt\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get full-upgrade -y \
&& echo -e "\n$(tput setaf 2)apt upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)cleaning apt\n$(tput sgr0)" \
&& sudo apt-get autoremove -y \
&& sudo apt-get autoclean -y
