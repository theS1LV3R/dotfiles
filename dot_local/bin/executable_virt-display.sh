#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly DIS_NAME="DP-1-3"  # Don't change it unless you know what it is
mode_name="mode_tablet"     # Set whatever name you like, you may need to change
width=2000                  # Size of a Galaxy Tab A7; 1368 for iPad Pro
height=1200                 # Size of a Galaxy Tab A7; 1024 for iPad Pro
randr_pos="--right-of"      # Default position setting for xrandr command
show_help=0

while [[ "$#" -gt 0 ]]; do
    case $1 in
    -l | --left)  randr_pos="--left-of" ;;
    -r | --right) randr_pos="--right-of" ;;
    -a | --above) randr_pos="--above" ;;
    -b | --below) randr_pos="--below" ;;
    -p | --portrait)
        tmp=$width
        width=$height
        height=$tmp
        mode_name="${mode_name}_port"
        ;;
    --hidpi)
        width=$((width * 2))
        height=$((height * 2))
        mode_name="${mode_name}_hidpi"
        ;;
    -h | --help) show_help=1 ;;
    *)
        echo "'$1' cannot be a monitor position"
        exit 1
        ;;
    esac
    shift
done

if [[ $show_help -eq 1 ]]; then
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
    -l, --left          Position the monitor to the left
    -r, --right         Position the monitor to the right
    -a, --above         Position the monitor above
    -b, --below         Position the monitor below
    -p, --portrait      Rotate the monitor to portrait mode
    --hidpi             Enable HiDPI mode
    -h, --help          Display this help message
EOF
    exit 0
fi

log_info "Getting primary display"
# Example:
# eDP-1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 344mm x 194mm
primary_display=$(xrandr | grep 'connected primary' | awk '{ print $1 }')

log_info "Adding display mode '$mode_name' to display '$DIS_NAME'"
randr_mode=$(cvt "$width" "$height" 60 | sed '2s/^.*Modeline\s*\".*\"//;2q;d' | tail -c+3 | head -c-1)

if ! xrandr --addmode "$DIS_NAME" "$mode_name" 2>/dev/null; then
    readonly orig_ifs=$IFS
    unset IFS
    # shellcheck disable=SC2086 # Double quote to prevent globbing and word splitting. (We want splitting in this case)
    xrandr --newmode "$mode_name" $randr_mode
    IFS=$orig_ifs
    xrandr --addmode "$DIS_NAME" "$mode_name"
fi

log_info "Setting display '$DIS_NAME' to mode '$mode_name'"
xrandr --output "$DIS_NAME" --mode "$mode_name"

log_info "Sleeping and moving display '$DIS_NAME' to position '$randr_pos' of '$primary_display'"
sleep 2
xrandr --output "$DIS_NAME" "$randr_pos" "$primary_display"

finish() {
    echo

    log_warn "Disabling display '$DIS_NAME'"
    xrandr --output "$DIS_NAME" --off

    log_warn "Deleting mode '$mode_name' from '$DIS_NAME'"
    xrandr --delmode "$DIS_NAME" "$mode_name"

    log_warn "Removing mode '$mode_name'"
    xrandr --rmmode "$mode_name"
}

trap finish EXIT

clip_pos=$(xrandr | grep "$DIS_NAME" | awk '{ print $3 }')
log_info "Display position: $clip_pos"

log_warn "Display active. CTRL+C to exit"
read -r
