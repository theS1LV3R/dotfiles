#!/usr/bin/env bash

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly NOTIFICATION_TIME="${NOTIFICATION_TIME:-3}"
DEVICE="${DEVICE:-}"

if [[ -z "$DEVICE" ]]; then
    DEVICE=$(v4l2-ctl --list-devices | grep "Logi 4K Stream Edition" -A1 | tail -n1 | awk '{ print $1 }')
fi

readonly ARG="${1:-}"
ABSOLUTE=0
AUTO=0
PRINT_DATA=0

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

"") {
    PRINT_DATA=1
} ;;

*) echo "Unknown arg: $ARG" && exit 0 ;;
esac

if [[ $PRINT_DATA == 1 ]]; then
    info=$(v4l2-ctl -d "$DEVICE" --all)

    focus_automatic_continuous=$(echo "$info" | grep "focus_automatic_continuous" | awk '{ print $6 }')
    focus_absolute=$(echo "$info" | grep "focus_absolute" | awk '{ print $9 }')

    echo "Autofocus: $focus_automatic_continuous"
    echo "Focus: $focus_absolute"

    exit 0
fi

v4l2-ctl -d "$DEVICE" -c focus_automatic_continuous="$AUTO"
[[ $AUTO == 0 ]] && v4l2-ctl -d "$DEVICE" -c focus_absolute="$ABSOLUTE"

if [[ $NOTIFICATION_TIME -gt 0 ]]; then
    notify-send --icon="camera" --urgency="critical" --wait --app-name="Webcam" "Set focus: $ARG" &
    notification_id=$!

    sleep "$NOTIFICATION_TIME"
    kill -INT "$notification_id"
fi
