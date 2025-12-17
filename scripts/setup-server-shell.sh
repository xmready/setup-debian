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

success() { local msg="$*"; printf '%s\n' "${green}${bold}success: ${msg}${reset}"; }
info() { local msg="$*"; printf '%s\n' "${yellow}${bold}info: ${msg}${reset}"; }
err() { local msg="$*"; printf '%s\n' "${red}${bold}error: ${msg}${reset}${bel}" >&2; }

bashrc_path="${HOME}/.bashrc"

info 'customizing bashrc...' \
&& sed -i 's/^HISTSIZE.*/HISTSIZE=10000/' "$bashrc_path" \
&& sed -i 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' "$bashrc_path" \
&& printf '\n%s\n' \
  'stty -ixon' \
  'export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' \
  >> "$bashrc_path" \
&& success 'bashrc customized'
