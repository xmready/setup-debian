#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to autoremove and clean packages using apt
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-apt-clean.sh | bash -

echo -e "\n$(tput setaf 3)cleaning up packages\n$(tput sgr0)" \
&& sudo apt-get autoremove -y \
&& sudo apt-get autoclean -y \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)package cleanup complete\n$(tput sgr0)"
