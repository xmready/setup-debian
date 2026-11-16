#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to set the git user name and email for the current user in a development VM
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-dev-git.sh | bash -

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

read_tty() {
  local prompt="$1" reply

  { : < /dev/tty; } 2>/dev/null \
    && read -r -p "$prompt" reply < /dev/tty \
    && printf '%s\n' "$reply"
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal user, not root'

  email_pattern='^[^@[:space:]]+@[^@[:space:]]+$'
  git_name="$(git config --global user.name)" || git_name=''
  git_email="$(git config --global user.email)" || git_email=''

  info 'setting git user name and email...'

  if [[ -z "$git_name" ]]; then
    git_name="$(read_tty 'git user name (e.g. your GitHub name): ')" \
      || die 'failed to read the git user name, run this from a terminal'
  fi

  [[ -n "$git_name" ]] \
    || die 'the git user name cannot be empty'

  if [[ -z "$git_email" ]]; then
    git_email="$(read_tty 'git user email (e.g. your GitHub noreply address): ')" \
      || die 'failed to read the git user email, run this from a terminal'
  fi

  [[ "$git_email" =~ $email_pattern ]] \
    || die "${git_email} is not a valid email address"

  git config --global user.name "$git_name" \
    || die 'failed to set git user name'

  git config --global user.email "$git_email" \
    || die 'failed to set git user email'

  success "git user set to ${git_name} <${git_email}>"
}

main "$@"
