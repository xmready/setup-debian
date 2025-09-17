# Setup System Debian
A script to automate the setup of a new Debian based operating system, tuned to my personal liking. Included are setup scripts for both Debian based desktops and servers.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
    - [Debian Desktop Usage](#debian-desktop-usage)
    - [Debian Server Usage](#debian-server-usage)
- [Setup Features](#setup-features)
    - [Debian Desktop Setup Features](#debian-desktop-setup-features)
    - [Debian Server Setup Features](#debian-server-setup-features)

## Requirements

- Debian or Debian based operating system
- Gnome or Plasma is required for desktop usage
- Access to terminal/shell where output is visible
- Terminal/shell user has sudo privileges
- `bash` & `curl` must be installed already
- Working internet connection

## Usage

### Debian Desktop Usage
```
curl -fL \
   https://raw.githubusercontent.com/xmready/system-setup/main/setup-system.sh \
   | bash -
```
### Debian Server Usage
```
curl -fL \
   https://raw.githubusercontent.com/xmready/system-setup/main/setup-server.sh \
   | bash -
```

## Setup Features

### Debian Desktop Setup Features

For Debian desktop systems `setup-system.sh` will do the following:

1. Update & upgrade all packages with `apt-get`
2. Install the following packages with `apt-get`
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
3. Customize `.bashrc` for the current user
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Customize prompt to display time, working dir, & current Git branch if applicable
    - Replace prompt symbol with arrow
    - Place prompt symbol & user input on newline
4. Install [Tor](https://torproject.org)
    - Add Tor repository
    - Install `tor` & `deb.torproject.org-keyring`
    - Disable `tor.service` from starting automatically
5. Install [Signal](https://signal.org)
    - Add Signal repository
    - Install `signal-desktop`
6. Install [Node Version Manager](https://github.com/nvm-sh/nvm)
    - Install latest `nvm` version to current user
    - Update `.bashrc` to use `nvm` automatically in directories with a `.nvmrc` file
    - Install latest stable version of Node.js
    - Creates the `nvm` alias `default` which points to the latest stable release
7. Install & configure [Vim](https://www.vim.org)
    - Install `vim-nox` & [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) dependencies
    - Install `ycmcompile` script & place in `/usr/local/bin/`
    - Clone [vim-config repository](https://github.com/xmready/vim-config) to `~/.vim`
    - Create symlink in `~` to custom `.vimrc`
    - Install custom `.vimrc` for root user
    - Install the following Nerd Fonts for current user
        - DejaVuSansMono
        - FiraCode
        - Hack
        - JetBrainsMono
8. Install & configure [Rclone](https://rclone.org)
    - Install latest `rclone` version
    - Create directories for mounting Google Drive VFS
    - Create directory `~/.config/rclone/`
    - Install systemd unit files for running `rclone` as a service
    - Install dispatcher script so `rclone` runs when connected to the internet
9. Autoremove and clean packages using `apt-get`
10. Install verified [Flatpak](https://flatpak.org) apps
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
11. Install custom scripts/commands for all users
    - `autoupgrade` (requires sudo)
    - `temps`
    - `dnsleaktest`
12. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy with `ufw`
    - Enable `ufw`
13. Reboot system after 60 seconds

### Debian Server Setup Features

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
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Increase `HISTSIZE` & `HISTFILESIZE`
4. Configure [Vim](https://www.vim.org)
    - Install custom `.vimrc` for current user
    - Install custom `.vimrc` for root user
5. Autoremove and clean packages using `apt-get`
6. Install custom scripts/commands for all users
    - `autoupgrade` (requires sudo)
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
