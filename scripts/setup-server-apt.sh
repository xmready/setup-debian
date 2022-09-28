#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure packages with apt
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-apt.sh | bash -

echo -e "\n$(tput setaf 3)upgrading packages\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get full-upgrade -y \
&& echo -e "\n$(tput setaf 2)packages upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& sudo -v \
&& echo -e "\n$(tput setaf 3)installing packages\n$(tput sgr0)" \
&& sudo apt-get install -y \
  curl \
  fail2ban \
  git \
  gnupg \
  lm-sensors \
  rsync \
  screen \
  ufw \
&& sudo -v \
&& echo -e "\n$(tput setaf 2)packages installed\n$(tput sgr0)"
