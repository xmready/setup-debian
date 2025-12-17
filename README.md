# Setup Debian
A script to automate the setup of a new Debian based operating system, tuned to my personal liking. Included are setup scripts for both Debian based desktops and servers.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
    - [Import Signing Key](#import-signing-key)
    - [Desktop Setup](#desktop-setup)
    - [Server Setup](#server-setup)
- [Setup Features](#setup-features)
    - [Desktop Setup Features](#desktop-setup-features)
    - [Server Setup Features](#server-setup-features)

## Requirements

- Debian or Debian based operating system
- Gnome or Plasma is required for desktop usage
- Access to terminal/shell where output is visible
- Terminal/shell user has sudo privileges
- `bash` & `curl` must be installed already
- `gpg` recommended for signature verification
- Working internet connection

## Usage

### Import Signing Key

Add [xmready's PGP signing key](https://keys.openpgp.org/vks/v1/by-fingerprint/31310B484B30ADABE8527D0E17AF13F5D2F5013A) to your keyring
```
gpg --keyserver "hkps://keys.openpgp.org" --recv-keys 17AF13F5D2F5013A
```

### Desktop Setup

1. Change working directory to `/tmp`
```
cd /tmp
```
2. Download `setup-desktop.sh` with the checksums & signature from the [latest release](https://github.com/xmready/setup-debian/releases)
```
curl --output-dir "$PWD" -fLO "https://github.com/xmready/setup-debian/releases/latest/download/{setup-desktop.sh,SHA256SUMS_DESKTOP,SHA256SUMS_DESKTOP.sign}"
```
3. Verify the PGP signature
```
gpg --verify SHA256SUMS_DESKTOP.sign SHA256SUMS_DESKTOP
```
4. Verify the checksum of `setup-desktop.sh` against `SHA256SUMS_DESKTOP`
```
sha256sum --ignore-missing -c SHA256SUMS_DESKTOP
```
5. Run the setup script
```
chmod +x setup-desktop.sh && ./setup-desktop.sh
```

### Server Setup

1. Change working directory to `/tmp`
```
cd /tmp
```
2. Download `setup-server.sh` with the checksums & signature from the [latest release](https://github.com/xmready/setup-debian/releases)
```
curl --output-dir "$PWD" -fLO "https://github.com/xmready/setup-debian/releases/latest/download/{setup-server.sh,SHA256SUMS_SERVER,SHA256SUMS_SERVER.sign}"
```
3. Verify the PGP signature
```
gpg --verify SHA256SUMS_SERVER.sign SHA256SUMS_SERVER
```
4. Verify the checksum of `setup-server.sh` against `SHA256SUMS_SERVER`
```
sha256sum --ignore-missing -c SHA256SUMS_SERVER
```
5. Run the setup script
```
chmod +x setup-server.sh && ./setup-server.sh
```

## Setup Features

### Desktop Setup Features

For Debian desktop systems `setup-desktop.sh` will do the following:

1. Update & upgrade all packages with `apt-get`
2. Install the following packages with `apt-get`
    - bash-completion
    - build-essential
    - checkinstall
    - curl
    - fastfetch
    - ffmpeg
    - flatpak
    - fprintd
    - fzf
    - git
    - gnupg
    - incus
    - libpam-fprintd
    - lm-sensors
    - nmap
    - pipx
    - python3-pip
    - qrencode
    - rename
    - rsync
    - ssh-audit
    - ufw
    - wget
3. Customize `.bashrc` for the current user
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Customize prompt to display time, working dir, & current Git branch if applicable
    - Replace prompt symbol with arrow
    - Place prompt symbol & user input on newline
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Set up fzf key bindings and fuzzy completion
4. Enable fingerprint authentication
5. Install [Tor](https://torproject.org)
    - Add Tor repository
    - Install `tor` & `deb.torproject.org-keyring`
    - Disable `tor.service` from starting automatically
6. Install [Signal](https://signal.org)
    - Add Signal repository
    - Install `signal-desktop`
7. Install [Node Version Manager](https://github.com/nvm-sh/nvm)
    - Install latest `nvm` version to current user
    - Update `.bashrc` to use `nvm` automatically in directories with a `.nvmrc` file
    - Install latest stable version of Node.js
    - Creates the `nvm` alias `default` which points to the latest stable release
8. Install & configure [Vim](https://www.vim.org)
    - Install `vim-nox` & [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) dependencies
    - Install `ycmcompile` script in `~/bin/`
    - Install custom `.vimrc` for current user
    - Install custom `.vimrc` for root user
    - Install custom template files in `~/.vim/templates/`
    - Install the following Nerd Fonts for current user
        - DejaVuSansMono
        - FiraCode
        - Hack
        - JetBrainsMono
9. Install & configure [Rclone](https://rclone.org)
    - Install latest `rclone` version
    - Create directories for mounting Google Drive VFS
    - Create directory `~/.config/rclone/`
    - Install systemd unit files for running `rclone` as a service
10. Autoremove and clean packages using `apt-get`
11. Install verified [Flatpak](https://flatpak.org) apps
    - Firefox
    - GIMP
    - GnuCash
    - Kdenlive
    - KeePassXC
    - Kleopatra
    - Plex
    - qBittorrent
    - Rnote
    - Thunderbird
    - Ungoogled Chromium
12. Install custom commands in `~/bin/`
    - `autoupgrade` (requires sudo)
    - `temps`
    - `dnsleaktest`
13. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy with `ufw`
    - Enable `ufw`
14. Reboot system after 60 seconds

### Server Setup Features

For Debian server systems `setup-server.sh` will do the following:

1. Update & upgrade all packages with `apt-get`
2. Install the following packages with `apt-get`
    - curl
    - fail2ban
    - git
    - gnupg
    - lm-sensors
    - rsync
    - screen
    - ufw
3. Customize `.bashrc` for the current user
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
4. Configure [Vim](https://www.vim.org)
    - Install custom `.vimrc` for current user
    - Install custom `.vimrc` for root user
5. Autoremove and clean packages using `apt-get`
6. Install custom commands in `/usr/local/bin/`
    - `autoupgrade-server` (requires sudo)
    - `temps`
    - `dnsleaktest`
7. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy with `ufw`
    - Allow incoming connections on port 22 with `ufw`
    - Enable `ufw`
    - Generate a new & strong ssh host key with `ssh-keygen`
    - Install hardened ssh config file
8. Reboot system after 60 seconds
