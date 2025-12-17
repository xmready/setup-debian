#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to setup and configure rclone
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-rclone.sh | bash -

arch="$(dpkg --print-architecture)" || { echo "Error: failed to get system architecture"; exit 1; }
rclone_deb_path="/tmp/rclone.deb"
rclone_deb_url="https://downloads.rclone.org/rclone-current-linux-${arch}.deb"
unit_path="/lib/systemd/system"
unit_url="https://raw.githubusercontent.com/xmready/setup-debian/main/configs"
unit_list='{mnt-gdrive.service,mnt-gdrive-crypt.service}'

echo -e "\n$(tput setaf 3)installing rclone\n$(tput sgr0)" \
&& curl -fLo "$rclone_deb_path" "$rclone_deb_url" \
&& sudo apt-get install -y "$rclone_deb_path" \
&& sudo mkdir -p /mnt/gdrive /mnt/vault \
&& sudo chown "$USER":"$USER" /mnt/gdrive /mnt/vault \
&& mkdir -p ~/.config/rclone \
&& sudo curl \
  --fail \
  --location \
  --output-dir "$unit_path" \
  --remote-name \
  "${unit_url}/${unit_list}" \
&& sudo sed -i s/^User=*/User="$USER"/ "$gdrive_unit_path" \
&& sudo sed -i s/^Group=*/Group="$USER"/ "$gdrive_unit_path" \
&& sudo sed -i s/^User=*/User="$USER"/ "$crypt_unit_path" \
&& sudo sed -i s/^Group=*/Group="$USER"/ "$crypt_unit_path" \
&& echo -e "\n$(tput setaf 2)rclone installed\n$(tput sgr0)"
