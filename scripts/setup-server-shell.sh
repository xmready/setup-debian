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
custom_ps1='\n ${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\t \[\033[34m\]\w \[\033[36m\]$(git branch --show-current 2>/dev/null)\[\033[00m\]\n └─❭ '
remote_raw_url="https://raw.githubusercontent.com"
remote_name="xmready/setup-debian"
tmux_config_root_url="${remote_raw_url}/${remote_name}/main/configs/.tmux.conf-root"
tmux_config_path="${HOME}/.tmux.conf"
tmux_config_root_path="/root/.tmux.conf"

info 'customizing bashrc...' \
&& sed -i 's/^HISTSIZE.*/HISTSIZE=10000/' "$bashrc_path" \
&& sed -i 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' "$bashrc_path" \
&& printf '\n%s\n' \
  "export PS1='${custom_ps1}'" \
  'export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' \
  'export EDITOR=vim' \
  'stty -ixon' \
  'eval "$(fzf --bash)"' \
  '[[ -z $TMUX && -z $VIMRUNTIME ]] && { tmux attach || tmux new -s admin; }' \
  >> "$bashrc_path" \
&& success 'bashrc customized' \
&& sleep 3 \
&& info 'downloading tmux config file...' \
&& curl --fail --location --output "$tmux_config_path" "$tmux_config_root_url" \
&& sudo curl --fail --location --output "$tmux_config_root_path" "$tmux_config_root_url" \
&& success 'tmux config file downloaded'
