#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to configure .bashrc for the current user
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-server-shell.sh | bash -

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; echo "${green}${bold}${msg}${reset}"; }
info() { local msg="$*"; echo "${yellow}${bold}${msg}${reset}"; }
err() { local msg="$*"; echo "${red}${bold}Error: ${msg}${reset}${bel}" >&2; }

info "customizing bashrc" \
&& sed -i 's/^HISTSIZE.*/HISTSIZE=10000/' ~/.bashrc \
&& sed -i 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' ~/.bashrc \
&& echo -e "\n"'stty -ixon' >> ~/.bashrc \
&& echo -e "\n"'export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' >> ~/.bashrc \
&& success "bashrc customized"
