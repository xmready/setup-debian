# Setup Debian
A script to automate the setup of a new Debian based operating system, tuned to my personal liking. Included are setup scripts for Debian based desktops, servers and sandboxed development VMs.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
    - [Import Signing Key](#import-signing-key)
    - [Desktop Setup](#desktop-setup)
    - [Server Setup](#server-setup)
    - [Dev Setup](#dev-setup)
- [Setup Features](#setup-features)
    - [Desktop Setup Features](#desktop-setup-features)
    - [Server Setup Features](#server-setup-features)
    - [Dev Setup Features](#dev-setup-features)

## Requirements

- Debian or Debian based operating system
- Gnome or Plasma is required for desktop usage
- Hardware virtualization (KVM) enabled for development VMs
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

### Dev Setup

Run these on the desktop host after `setup-desktop.sh` has finished and the system has rebooted.

1. Change working directory to `/tmp`
```
cd /tmp
```
2. Download `setup-dev.sh` with the checksums & signature from the [latest release](https://github.com/xmready/setup-debian/releases)
```
curl --output-dir "$PWD" -fLO "https://github.com/xmready/setup-debian/releases/latest/download/{setup-dev.sh,SHA256SUMS_DEV,SHA256SUMS_DEV.sign}"
```
3. Verify the PGP signature
```
gpg --verify SHA256SUMS_DEV.sign SHA256SUMS_DEV
```
4. Verify the checksum of `setup-dev.sh` against `SHA256SUMS_DEV`
```
sha256sum --ignore-missing -c SHA256SUMS_DEV
```
5. Create the base VM, then wait until `incus list` shows it with an IPv4 address
```
incus launch images:debian/trixie dev-base --vm -c limits.cpu=4 -c limits.memory=8GiB
```
6. Create a user with sudo privileges in the VM
```
incus exec dev-base -- apt-get install --assume-yes curl sudo
incus exec dev-base -- adduser dev
incus exec dev-base -- usermod --append --groups sudo dev
```
7. Copy the verified files into the VM
```
incus file push --uid 1000 --gid 1000 setup-dev.sh SHA256SUMS_DEV dev-base/tmp/
```
8. Log in to the VM as the new user and run the setup script
```
incus exec dev-base -- su --login dev
cd /tmp && chmod +x setup-dev.sh && ./setup-dev.sh
```
9. After the VM reboots, snapshot it as the template for project VMs
```
incus snapshot create dev-base clean
```
10. Create a VM for each project from the template
```
incus copy dev-base/clean proj-example
incus start proj-example
```

## Setup Features

### Desktop Setup Features

For Debian desktop systems `setup-desktop.sh` will do the following:

1. Update & upgrade all deb packages with `apt-get`
2. Install the following deb packages with `apt-get`
    - bash-completion
    - btop
    - build-essential
    - btrfs-progs
    - checkinstall
    - clamav
    - clamav-daemon
    - curl
    - fastfetch
    - ffmpeg
    - flatpak
    - fprintd
    - fzf
    - git
    - gnupg
    - incus
    - libnotify-bin
    - libpam-fprintd
    - lm-sensors
    - myrepos
    - nmap
    - pipx
    - qrencode
    - rename
    - ripgrep
    - rsync
    - ssh-audit
    - tmux
    - ufw
    - virt-viewer
    - wget
    - wl-clipboard
3. Customize `.bashrc` for the current user
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Customize prompt PS1
    - Set `EDITOR=vim`
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Set up fzf key bindings and fuzzy completion
4. Download `.tmux.conf` files to current user & root home directory
5. Enable fingerprint authentication
6. Install [Tor](https://torproject.org)
    - Add Tor repository
    - Install `tor` & `deb.torproject.org-keyring`
    - Disable `tor.service` from starting automatically
7. Install [Signal](https://signal.org)
    - Add Signal repository
    - Install `signal-desktop`
8. Install & configure [Vim](https://vim.org)
    - Install `vim-nox` & [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) dependencies, including `nodejs` & `npm`
    - Install `ycm-compile` script in `~/bin/`
    - Install custom `vimrc` for current user
    - Install custom `vimrc` for root user
    - Install custom template files in `~/.config/vim/templates/`
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
10. Configure [clamav](https://clamav.net)
    - Download configs and unit files
    - Enable the following services:
        - `clamav-clamonacc.service`
        - `clamav-daemon.service`
        - `clamav-freshclam.service`
        - `clamdscan.timer`
11. Install [GHCup](https://haskell.org/ghcup/)
    - Install latest `ghcup` to current user
    - Install latest stable version of `cabal`
    - Install the following `cabal` packages
        - kmonad
12. Configure [kmonad](https://github.com/kmonad/kmonad) as systemd service
    - Create config path `/etc/kmonad`
    - Download config, udev and unit files
    - Copy `kmonad` bin file to `/usr/local/bin`
    - Update `config.kbd` with device file path
    - Reload udev rules and enable kmonad service
13. Install verified [Flatpak](https://flatpak.org) apps
    - Firefox
    - GIMP
    - GnuCash
    - Kdenlive
    - KeePassXC
    - Kleopatra
    - qBittorrent
    - Rnote
    - Thunderbird
    - Ungoogled Chromium
14. Install & configure [Incus](https://linuxcontainers.org/incus/) for sandboxed development VMs
    - Install `incus` and add the current user to the `incus-admin` group
    - Create the `sandbox` btrfs storage pool, as a subvolume on btrfs hosts or a sparse file on other filesystems
    - Create the `incusbr0` network bridge
    - Give VMs from the `default` profile a 30 GiB disk and the `sandbox` firewall rules
    - Block VMs from reaching the host, the local network and each other, while allowing internet access
    - Allow VMs to reach the host only for DHCP and DNS with `ufw`
15. Install custom commands in `~/bin/`
    - `autoupgrade-desktop` (requires sudo)
    - `dnsleaktest`
    - `gdrive-backup`
    - `gdrive-check`
    - `gdrive-resync`
    - `gdrive-start`
    - `gdrive-status`
    - `gdrive-stop`
    - `temps`
16. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy with `ufw`
    - Enable `ufw`
17. Autoremove and clean packages using `apt-get`
18. Reboot system after 10 minutes

### Server Setup Features

For Debian server systems `setup-server.sh` will do the following:

1. Update & upgrade all packages with `apt-get`
2. Install the following packages with `apt-get`
    - curl
    - fail2ban
    - fzf
    - git
    - gnupg
    - lm-sensors
    - openssh-server
    - rsync
    - screen
    - tmux
    - ufw
    - vim
3. Customize `.bashrc` for the current user
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Customize prompt PS1
    - Set `EDITOR=vim`
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Set up fzf key bindings and fuzzy completion
4. Download `.tmux.conf` files to current user & root home directory
5. Configure [Vim](https://www.vim.org)
    - Install custom `vimrc` for current user
    - Install custom `vimrc` for root user
6. Install custom commands in `/usr/local/bin/`
    - `autoupgrade-server` (requires sudo)
    - `dnsleaktest`
    - `temps`
7. Harden network security
    - Disable tcp timestamps
    - Set default firewall policy with `ufw`
    - Allow incoming connections on port 22 with `ufw`
    - Enable `ufw`
    - Generate a new & strong ssh host key with `ssh-keygen`
    - Install hardened ssh config file
8. Autoremove and clean packages using `apt-get`
9. Reboot system after 10 minutes

### Dev Setup Features

For Debian development VMs `setup-dev.sh` will do the following:

1. Update & upgrade all packages with `apt-get`
2. Install the following packages with `apt-get`
    - bash-completion
    - build-essential
    - curl
    - fzf
    - git
    - jq
    - openssh-client
    - ripgrep
    - rsync
    - tmux
    - unzip
    - vim-nox
    - wget
3. Customize `.bashrc` for the current user
    - Increase `HISTSIZE` & `HISTFILESIZE`
    - Customize prompt PS1
    - Set `EDITOR=vim`
    - Disable Flow Control
    - Append current session's command history to the history file
    - Read any new lines from the history file
    - Set up fzf key bindings and fuzzy completion
4. Download `.tmux.conf` files to current user & root home directory
5. Install & configure [Vim](https://vim.org)
    - Install `vim-nox`
    - Install custom `vimrc` for current user
    - Install custom `vimrc` for root user
    - Install custom template files in `~/.config/vim/templates/`
6. Install [Homebrew](https://github.com/Homebrew/install)
    - Install latest `brew` version to the current user
    - Update `.bashrc` to add `brew` to `$PATH`
    - Disable Homebrew analytics
7. Install [Node Version Manager](https://github.com/nvm-sh/nvm)
    - Install latest `nvm` version to current user
    - Update `.bashrc` to use `nvm` automatically in directories with a `.nvmrc` file
    - Install latest stable version of Node.js
    - Creates the `nvm` alias `default` which points to the latest stable release
8. Install and configure [OpenCode](https://opencode.ai)
    - Install latest `opencode` version to current user
    - Download `tui.json` config file to `~/.config/opencode/`
9. Install custom commands in `~/bin/`
    - `autoupgrade-dev` (requires sudo)
10. Autoremove and clean packages using `apt-get`
11. Reboot system after 10 minutes
