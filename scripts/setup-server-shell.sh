#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to configure .bashrc for the current user
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-shell.sh | bash -

echo -e "\n$(tput setaf 3)customizing bashrc\n$(tput sgr0)" \
&& sed -i 's/^HISTSIZE.*/HISTSIZE=10000/' ~/.bashrc \
&& sed -i 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' ~/.bashrc \
&& echo -e "\n"'stty -ixon' >> ~/.bashrc \
&& echo -e "\n"'export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' >> ~/.bashrc \
&& echo -e "\n$(tput setaf 2)bashrc customized\n$(tput sgr0)"
