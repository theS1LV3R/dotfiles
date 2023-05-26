#!/usr/bin/env bash

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly DEVICE="${DEVICE:-/dev/video2}"
readonly NOTIFICATION_TIME="${NOTIFICATION_TIME:-3}"

readonly ARG="${1:-'No args provided'}"
ABSOLUTE=0
AUTO=0

case "$ARG" in
auto) {
    AUTO=1
} ;;

far) {
    ABSOLUTE=0
    AUTO=0
} ;;

close) {
    ABSOLUTE=200
    AUTO=0
} ;;

*) echo "Unknown arg: $ARG" && exit 0 ;;
esac

v4l2-ctl -d "$DEVICE" -c focus_automatic_continuous="$AUTO"
[[ $AUTO == 0 ]] && v4l2-ctl -d "$DEVICE" -c focus_absolute="$ABSOLUTE"

if [[ $NOTIFICATION_TIME -gt 0 ]]; then
    notify-send --icon="camera" --urgency="critical" --wait --app-name="Webcam" "Set focus: $ARG" &
    notification_id=$!

    sleep "$NOTIFICATION_TIME"
    kill -INT "$notification_id"
fi
