#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

set -o errexit                  # exit on error
set -o nounset                  # do not use unset variables
set -o pipefail                 # fail early in piped commands
[[ -n "${TRACE:-}" ]] && set -x # debug

#id
#pos
#prio
#rot

#!/usr/bin/env bash

# --- Default states ---
HDMI_ENABLED="disable"
RES_X_OFFSET="0"

# --- Check for parameter to enable display 4 ---
if [[ "${1:-}" == "--enable-hdmi" ]]; then
    HDMI_ENABLED="enable"
    RES_X_OFFSET="1920"
fi

# Displays
DISPLAYS=("HDMI-A-1" "DP-4" "DP-3" "DP-2")

# Enable/disable state
ENABLED=("$HDMI_ENABLED" "enable" "enable" "enable")

# Settings
RESOLUTIONS=("mode.1920x1080@60"   "mode.2560x1440@165"                  "mode.2560x1440@165"                      "mode.2560x1440@165")

# Y = If cursor is higher on right than on left, lower number.
POSITIONS=("position.0,0"          "position.$((RES_X_OFFSET+0)),0"      "position.$((RES_X_OFFSET + 1440)),470"   "position.$((RES_X_OFFSET + 1440 + 2560)),470")
PRIORITIES=("priority.4"           "priority.3"                          "priority.1"                              "priority.2")
ROTATIONS=("rotation.none"         "rotation.right"                      "rotation.none"                           "rotation.none")

# --- Collect all arguments ---
ARGS=()

# Always apply enable/disable first
for i in "${!DISPLAYS[@]}"; do
    ARGS+=("output.${DISPLAYS[$i]}.${ENABLED[$i]}")
done

# List of setting arrays
SETTING_NAMES=("RESOLUTIONS" "POSITIONS" "PRIORITIES" "ROTATIONS")

# Iterate settings using declare -n for less repetition
for i in "${!DISPLAYS[@]}"; do
    for setting_name in "${SETTING_NAMES[@]}"; do
        declare -n CURRENT_SETTING="$setting_name"
        [[ "${ENABLED[$i]}" == "enable" ]] && \
            ARGS+=("output.${DISPLAYS[$i]}.${CURRENT_SETTING[$i]}")
    done
done

kscreen-doctor "${ARGS[@]}"
sleep 1

timeout 2 kquitapp6 plasmashell ; killall -9 plasmashell ; kstart5 plasmashell
