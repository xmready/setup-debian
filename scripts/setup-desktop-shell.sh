#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to configure .bashrc & fingerprint auth for the current user
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-shell.sh | bash -

echo -e "\n$(tput setaf 3)customizing bashrc\n$(tput sgr0)" \
&& sed -i 's/^HISTSIZE.*/HISTSIZE=10000/' ~/.bashrc \
&& sed -i 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' ~/.bashrc \
&& echo \
  $'\nexport PS1=\'\\n ${debian_chroot:+($debian_chroot)}\[\\033[01;35m\]\\t \[\\033[34m\]\w \[\\033[36m\]$(git branch -v 2>/dev/null)\[\\033[00m\]\\n └─❭ \'' \
  >> ~/.bashrc \
&& echo -e "\n"'stty -ixon' \
  >> ~/.bashrc \
&& echo -e "\n"'export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' \
  >> ~/.bashrc \
&& echo -e "\n"'# Set up fzf key bindings and fuzzy completion'"\n"'eval "$(fzf --bash)"' \
  >> ~/.bashrc \
&& echo -e "\n$(tput setaf 2)bashrc customized\n$(tput sgr0)" \
&& sleep 3 \
&& echo -e "\n$(tput setaf 3)enabling fingerprint authentication\n$(tput sgr0)" \
&& sudo pam-auth-update --enable fprintd \
&& echo -e "\n$(tput setaf 2)fingerprint authentication enabled\n$(tput sgr0)"
