#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup a new debian based desktop/laptop
#
# sudo usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/setup-desktop.sh | bash -

# Declare variables for setup-desktop.sh
setup_desktop_url="https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/setup-desktop.sh"
setup_desktop_path="/tmp/setup-desktop.sh"

# Define an array of script URLs
script_urls=(
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-apt.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-shell.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-tor.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-signal.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-nvm.sh"
  "https://raw.githubusercontent.com/xmready/vim-config/v1.0.0/setup-desktop-vim.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-rclone.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-apt-clean.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-flatpak.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-commands.sh"
  "https://raw.githubusercontent.com/xmready/setup-debian/v1.0.0/scripts/setup-desktop-harden.sh"
)

# Declare variables for checksum file
sha256sums_url="https://github.com/xmready/setup-debian/releases/download/v1.0.0/SHA256SUMS_DESKTOP"
sha256sums_path="/tmp/SHA256SUMS_DESKTOP"

# Prompt sudo login
if ! sudo -v; then
  echo "Error: sudo login failed" >&2
  exit 1
fi

# Check for setup-desktop.sh in /tmp
if [ ! -f "$setup_desktop_path" ]; then
  curl --fail --location --show-error --silent --output "$setup_desktop_path" "$setup_desktop_url" || {
    echo "Error: download failed for $setup_desktop_url" >&2
    exit 1
  }
fi

# Loop and download setup scripts to /tmp
for url in "${script_urls[@]}"; do
  outfile="/tmp/$(basename "$url")"

  if ! curl --fail --location --show-error --silent --output "$outfile" "$url"; then
    echo "Error: download failed for $url" >&2
    exit 1
  fi

  if ! chmod +x "$outfile"; then
    echo "Error: chmod failed for $outfile" >&2
    exit 1
  fi
done

# Check for checksums file
if [ ! -f "$sha256sums_path" ]; then
  curl --fail --location --show-error --silent --output "$sha256sums_path" "$sha256sums_url" || {
    echo "Error: download failed for $sha256sums_url" >&2
    exit 1
  }
fi

# Change working directory to /tmp
if ! cd /tmp; then
  echo "Error: failed to change working directory to /tmp" >&2
  exit 1
fi

# Verify all script checksums
if ! sha256sum --check --status "$sha256sums_path"; then
  echo "Error: checksum verification failed" >&2
  exit 1
fi

# Loop and run setup scripts with bash
for url in "${script_urls[@]}"; do
  outfile="/tmp/$(basename "$url")"

  if ! bash "$outfile"; then
    echo "Error: $outfile failed" >&2
    exit 1
  fi
done

# Reboot after 60 seconds
if sudo shutdown -r +1; then
  echo -e "\n$(tput setaf 1)$(tput bold)SYSTEM WILL REBOOT IN 60 SECONDS\n$(tput sgr0)$(tput bel)" >&2
  exit 0
fi
