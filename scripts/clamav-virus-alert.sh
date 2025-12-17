#!/usr/bin/bash

virus_file="$CLAM_VIRUSEVENT_FILENAME"
virus_name="$CLAM_VIRUSEVENT_VIRUSNAME"

hash="$(echo "${virus_file}:${virus_name}" | md5sum | cut -d' ' -f1)"
stamp_file="/run/clamav/.clamav-alert-${hash}"

if [[ -f "$stamp_file" ]] && [[ $(( $(date +%s) - $(stat -c %Y "$stamp_file") )) -lt 10 ]]; then
  exit 0
fi
touch "$stamp_file"

desktop_user="current_user"
desktop_uid="$(id -u "$desktop_user")"

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${desktop_uid}/bus"

runuser -u "$desktop_user" -- \
  notify-send \
    --urgency=critical \
    --app-name="ClamAV" \
    "DETECTION WARNING" \
    "${virus_name} found in ${virus_file}"
