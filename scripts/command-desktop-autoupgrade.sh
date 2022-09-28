#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to update, upgrade, and full-upgrade using apt
#
# sudo usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/command-desktop-autoupgrade.sh | bash -

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
  grep tag_name |
  sed -E 's/.*"([^"]+)".*/\1/'
}

NVM_LATEST="$(get_latest_release nvm-sh/nvm)"
NVM_URL=https://raw.githubusercontent.com/nvm-sh/nvm/"$NVM_LATEST"/install.sh

echo -e "\n$(tput setaf 3)upgrading apt\n$(tput sgr0)" \
&& sudo apt-get update \
&& sudo apt-get upgrade -y \
&& sudo apt-get full-upgrade -y \
&& echo -e "\n$(tput setaf 2)apt upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)upgrading rclone\n$(tput sgr0)" \
&& sudo rclone selfupdate --package deb \
&& echo -e "\n$(tput setaf 2)rclone upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)cleaning apt\n$(tput sgr0)" \
&& sudo apt-get -y autoremove \
&& sudo apt-get -y autoclean \
&& echo -e "\n$(tput setaf 2)apt cleaned\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)upgrading flatpaks\n$(tput sgr0)" \
&& flatpak update -y \
&& echo -e "\n$(tput setaf 2)flatpaks upgraded\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)upgrading nvm\n$(tput sgr0)" \
&& curl -fL "$NVM_URL" | bash - \
&& echo -e "\n$(tput setaf 2)nvm upgraded\n$(tput sgr0)"
