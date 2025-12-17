#!/usr/bin/bash

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

info "compiling YouCompleteMe" \
&& cd "${HOME}/.vim/plugged/YouCompleteMe" \
&& python3 install.py \
  --clangd-completer \
  --cs-completer \
  --go-completer \
  --ts-completer \
  --rust-completer \
  --java-completer \
&& success "YouCompleteMe compiled"
