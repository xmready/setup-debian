#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure nvm-sh and nodejs
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-nvm.sh | bash -

get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |
  grep tag_name |
  sed -E 's/.*"([^"]+)".*/\1/'
}

nvm_version="$(get_latest_release nvm-sh/nvm)" || { echo "Error: failed to get nvm version"; exit 1; }
nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh"
nvm_auto_url="https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/nvm-auto-bash.sh"

echo -e "\n$(tput setaf 3)installing nvm\n$(tput sgr0)" \
&& curl -fL "$nvm_url" | bash - \
&& export NVM_DIR="$HOME/.nvm" \
&& [ -s "$NVM_DIR/nvm.sh" ] \
&& \. "$NVM_DIR/nvm.sh" \
&& echo -e "\n" >> ~/.bashrc \
&& curl -fL "$nvm_auto_url" >> ~/.bashrc \
&& nvm install node \
&& nvm alias default node \
&& node -v \
&& npm -v \
&& echo -e "\n$(tput setaf 2)nvm installed\n$(tput sgr0)"
