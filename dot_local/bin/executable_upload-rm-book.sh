#!/usr/bin/env bash
set -euo pipefail

# Uploads a file to ReMarkable

APPNAME="$(basename "$0")"
BOOKNAME="$(basename "$1")"

notif_id="$(notify-send --print-id --app-name="$APPNAME" "Starting upload" "$BOOKNAME")"

if rmapi put "$1"; then
    notify-send --replace-id="$notif_id" --app-name="$APPNAME" "Successfully uploaded" "$BOOKNAME"
else
    notify-send --replace-id="$notif_id" --urgency="critical" --app-name="$APPNAME" "Upload failed" "$BOOKNAME"
fi
