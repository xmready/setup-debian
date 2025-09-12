# Setup-System
A script to automate the setup of a new Debian based operating system, tuned to my personal liking. Included are versions for both Debian based desktops and servers.

## Table of Contents

- [Prerequisites](#prerequisites)
- [What It Does](#what-it-does)

## Prerequisites

1. Debian or Debian based operating system
2. Access to terminal/shell where output is visible
3. Terminal/shell user has sudo privileges
4. `curl` must be installed already
5. Working internet connection

## What It Does

### For Debian desktop systems `setup-system.sh` will do the following:
1. Update, upgrade, & install packages with `apt-get`
   - bash-completion
   - build-essential
   - checkinstall
   - curl
   - fastfetch
   - flatpak
   - fprintd
   - fzf
   - git
   - gnome-software-plugin-flatpak
   - gnupg
   - libpam-fprintd
   - lm-sensors
   - lxc
   - nmap
   - pipx
   - python3-pip
   - qrencode
   - rename
   - rsync
   - ssh-audit
   - ufw
   - wget
2. Customize `.bashrc` for the current user
   - Disable Flow Control
   - Append current session's command history to the history file
   - Read any new lines from the history file
   - Customize prompt to display time, working dir, & current Git branch if applicable
   - Replace prompt symbol with arrow
   - Place prompt symbol & user input on newline
3. Install Tor
   - Add Tor repository
   - Install `tor` & `deb.torproject.org-keyring`
   - Disable `tor.service` from starting automatically
4. Install Signal
   - Add Signal repository
   - Install `signal-desktop`
5. Install Node Version Manager
   - Install latest `nvm` version to current user
   - Update `.bashrc` to use `nvm` automatically in directories with a `.nvmrc` file
   - Install latest stable version of Node.js
   - Creates the `nvm` alias `default` which points to the latest stable release
6. Install & configure Vim
   - Install `vim-nox` & YouCompleteMe dependencies
   - Install `ycmcompile` script & place in `/usr/local/bin/`
   - Clone [vim-config repository](https://github.com/xmready/vim-config) to `~/.vim`
   - Create symlink in `~` to custom `.vimrc`
   - Install custom `.vimrc` for root user
   - Install Nerd Fonts for current user
      - DejaVuSansMono
      - FiraCode
      - Hack
      - JetBrainsMono
7. Install & configure Rclone
   - Install latest `rclone` version
   - Create directories for mounting Google Drive VFS
   - Create directory `~/.config/rclone/`
   - Install systemd unit files for running `rclone` as a service
   - Install dispatcher script so `rclone` runs when connected to the internet
8. Autoremove and clean packages using `apt-get`
9. Install verified Flatpak apps
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
10. Install custom scripts/commands for all users
    - `autoupgrade` (requires sudo)
    - `temps`
    - `dnsleaktest`
11. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy
    - Enable `ufw`
12. Reboot system after 60 seconds
