#!/usr/bin/bash

desktop_user="current_user"
desktop_uid="$(id -u "$desktop_user")"

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${desktop_uid}/bus"

runuser -u "$desktop_user" -- \
  notify-send \
    --urgency=critical \
    --app-name="ClamAV" \
    "VIRUS SCAN STARTED" \
    "Performance Reduced Until Scan Completes"
