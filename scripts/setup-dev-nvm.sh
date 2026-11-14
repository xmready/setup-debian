#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure nvm-sh and nodejs
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev-nvm.sh | bash -

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

get_latest_release() {
  curl --fail --silent "https://api.github.com/repos/$1/releases/latest" |
  grep --max-count=1 '"tag_name":' |
  sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
}

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
  [[ "$EUID" -ne 0 ]] || die 'run as your normal user, not root'

  remote_raw_url='https://raw.githubusercontent.com'
  nvm_remote_name='nvm-sh/nvm'
  nvm_version="$(get_latest_release "$nvm_remote_name")" \
    || die 'failed to get nvm version'
  nvm_install_url="${remote_raw_url}/${nvm_remote_name}/${nvm_version}/install.sh"
  nvm_install="$(curl -fsSL "$nvm_install_url")" \
    || die 'failed to download nvm install script'
  NVM_DIR="${HOME}/.nvm"
  bashrc_path="${HOME}/.bashrc"
  nvm_auto_begin='# >>> nvm auto bash >>>'
  nvm_auto_end='# <<< nvm auto bash <<<'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_scripts_url="${remote_raw_url}/${setup_remote_name}/${version}/scripts"
  nvm_auto_filename='nvm-auto-bash.sh'
  nvm_auto_url="${setup_scripts_url}/${nvm_auto_filename}"
  nvm_auto="$(curl -fsSL "$nvm_auto_url")" \
    || die "failed to download ${nvm_auto_filename}"

  info 'installing nvm...'

  bash -c "$nvm_install" \
    || die 'failed to install nvm'

  success 'nvm installed'

  info 'configuring nvm...'

  [[ -s "${NVM_DIR}/nvm.sh" ]] \
    && \. "${NVM_DIR}/nvm.sh" \
    && nvm install --lts \
    && nvm alias default --lts node \
    && replace_block "$bashrc_path" "$nvm_auto_begin" "$nvm_auto_end" "$nvm_auto" \
    || die 'failed to configure nvm'

  node --version \
    || die 'node is not working'

  npm --version \
    || die 'npm is not working'

  success 'nvm configured'
}

main "$@"
