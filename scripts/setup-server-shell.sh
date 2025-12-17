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
die() { err "$@"; exit 1; }

append_blank_line() {
  if [[ -n "$(tail -n 1 "$1")" ]]; then
    printf '\n' >> "$1"
  fi
}

replace_block() {
  local file="$1" begin="$2" end="$3" content="$4" tmp status

  if grep --quiet --line-regexp --fixed-strings -- "$begin" "$file"; then
    tmp="$(mktemp)" \
      && BEGIN="$begin" END="$end" CONTENT="$content" awk '
        $0 == ENVIRON["BEGIN"]         { print; print ENVIRON["CONTENT"]; skip = 1; next }
        $0 == ENVIRON["END"] && skip   { skip = 0 }
        !skip
        END { if (skip) exit 3 }
      ' "$file" > "$tmp" \
      && cat "$tmp" > "$file"

    status=$?

    rm -f -- "$tmp"

    if [[ "$status" -eq 3 ]]; then
      err "setup-debian end marker missing after start marker in ${file}: ${end}"
    fi

    return "$status"
  else
    append_blank_line "$file" \
      && printf '%s\n' "$begin" "$content" "$end" >> "$file"
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  bashrc_path="${HOME}/.bashrc"
  bashrc_begin='# >>> setup-debian >>>'
  bashrc_end='# <<< setup-debian <<<'
  custom_ps1='\n ${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\t \[\033[34m\]\w \[\033[36m\]$(git branch --show-current 2>/dev/null)\[\033[00m\]\n └─❭ '
  bashrc_block="$(printf '%s\n' \
    "PS1='${custom_ps1}'" \
    'PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"' \
    'export EDITOR=vim' \
    'stty -ixon' \
    'eval "$(fzf --bash)"' \
    '[[ -z $TMUX && -z $VIMRUNTIME ]] && tmux new -A -s "$USER"')"
  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  tmux_conf_filename='.tmux.conf'
  tmux_conf_root_url="${setup_configs_url}/${tmux_conf_filename}-root"
  tmux_conf_path="${HOME}/${tmux_conf_filename}"
  tmux_conf_root_path="/root/${tmux_conf_filename}"

  info 'customizing bashrc...'

  sed \
      --in-place \
      --follow-symlinks \
      --expression 's/^HISTSIZE.*/HISTSIZE=10000/' \
      --expression 's/^HISTFILESIZE.*/HISTFILESIZE=20000/' \
      "$bashrc_path" \
    && replace_block "$bashrc_path" "$bashrc_begin" "$bashrc_end" "$bashrc_block" \
    || die 'failed to customize bashrc'

  success 'bashrc customized'

  info 'downloading tmux config files...'

  curl \
      --fail \
      --location \
      --output "$tmux_conf_path" \
      "$tmux_conf_root_url" \
    && sudo curl \
      --fail \
      --location \
      --output "$tmux_conf_root_path" \
      "$tmux_conf_root_url" \
    || die 'failed to download tmux config files'

  success 'tmux config files downloaded'
}

main "$@"
