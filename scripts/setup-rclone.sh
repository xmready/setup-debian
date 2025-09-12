#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/system-setup
#
# Purpose:
#   A script to setup and configure rclone
#
# Non-root usage:
#   curl -fL https://raw.githubusercontent.com/xmready/system-setup/main/scripts/setup-rclone.sh | bash -

ARCH="$(dpkg --print-architecture)"
RCLONE_DEB_URL=https://downloads.rclone.org/rclone-current-linux-"$ARCH".deb
GDRIVE_UNIT_PATH=/lib/systemd/system/mnt-gdrive.service
CRYPT_UNIT_PATH=/lib/systemd/system/mnt-gdrive-crypt.service
GDRIVE_UNIT_URL=https://raw.githubusercontent.com/xmready/system-setup/main/configs/mnt-gdrive.service
CRYPT_UNIT_URL=https://raw.githubusercontent.com/xmready/system-setup/main/configs/mnt-gdrive-crypt.service
NM_SCRIPT_PATH=/etc/NetworkManager/dispatcher.d/90-ifconnected
NM_SCRIPT_URL=https://raw.githubusercontent.com/xmready/system-setup/main/configs/90-ifconnected

echo -e "\n$(tput setaf 3)installing rclone\n$(tput sgr0)" \
&& curl -fLo /tmp/rclone.deb "$RCLONE_DEB_URL" \
&& sudo apt-get install -y /tmp/rclone.deb \
&& sudo mkdir -p /mnt/gdrive /mnt/vault \
&& sudo chown "$USER":"$USER" /mnt/gdrive /mnt/vault \
&& mkdir -p ~/.config/rclone \
&& sudo curl -fLo "$GDRIVE_UNIT_PATH" "$GDRIVE_UNIT_URL" \
&& sudo curl -fLo "$CRYPT_UNIT_PATH" "$CRYPT_UNIT_URL" \
&& sudo sed -i s/^User=*/User="$USER"/ "$GDRIVE_UNIT_PATH" \
&& sudo sed -i s/^Group=*/Group="$USER"/ "$GDRIVE_UNIT_PATH" \
&& sudo sed -i s/^User=*/User="$USER"/ "$CRYPT_UNIT_PATH" \
&& sudo sed -i s/^Group=*/Group="$USER"/ "$CRYPT_UNIT_PATH" \
&& sudo curl -fLo "$NM_SCRIPT_PATH" "$NM_SCRIPT_URL" \
&& sudo chmod 755 /etc/NetworkManager/dispatcher.d/* \
&& echo -e "\n$(tput setaf 2)rclone installed\n$(tput sgr0)"
