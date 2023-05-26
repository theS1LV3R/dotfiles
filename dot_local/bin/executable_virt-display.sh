#!/usr/bin/env bash

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly WIDTH=2000              # 1368 for iPad Pro
readonly HEIGHT=1200             # 1024 for iPad Pro
readonly MODE_NAME="mode_tablet" # Set whatever name you like, you may need to change
readonly DIS_NAME="DP-1-3"       # Don't change it unless you know what it is
RANDR_POS="--right-of"           # Default position setting for xrandr command
SHOW_HELP=0

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -l | --left) RANDR_POS="--left-of" ;;
  -r | --right) RANDR_POS="--right-of" ;;
  -a | --above) RANDR_POS="--above" ;;
  -b | --below) RANDR_POS="--below" ;;
  -p | --portrait)
    TMP=$WIDTH
    WIDTH=$HEIGHT
    HEIGHT=$TMP
    MODE_NAME="${MODE_NAME}_port"
    ;;
  --hidpi)
    WIDTH=$((WIDTH * 2))
    HEIGHT=$((HEIGHT * 2))
    MODE_NAME="${MODE_NAME}_hidpi"
    ;;
  -h | --help) SHOW_HELP=1 ;;
  *)
    echo "'$1' cannot be a monitor position"
    exit 1
    ;;
  esac
  shift
done

if [[ $SHOW_HELP -eq 1 ]]; then
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
PRIMARY_DISPLAY=$(xrandr | grep 'connected primary' | awk '{ print $1 }')

log_info "Adding display mode '$MODE_NAME' to display '$DIS_NAME'"
RANDR_MODE=$(cvt "$WIDTH" "$HEIGHT" 60 | sed '2s/^.*Modeline\s*\".*\"//;2q;d' | tail -c+3 | head -c-1)

if ! xrandr --addmode "$DIS_NAME" "$MODE_NAME" 2>/dev/null; then
  ORIG_IFS=$IFS
  unset IFS
  xrandr --newmode "$MODE_NAME" $RANDR_MODE
  IFS=$ORIG_IFS
  xrandr --addmode "$DIS_NAME" "$MODE_NAME"
fi

log_info "Setting display '$DIS_NAME' to mode '$MODE_NAME'"
xrandr --output "$DIS_NAME" --mode "$MODE_NAME"

log_info "Sleeping and moving display '$DIS_NAME' to position '$RANDR_POS' of '$PRIMARY_DISPLAY'"
sleep 2
xrandr --output "$DIS_NAME" "$RANDR_POS" "$PRIMARY_DISPLAY"

finish() {
  echo

  log_warn "Disabling display '$DIS_NAME'"
  xrandr --output "$DIS_NAME" --off

  log_warn "Deleting mode '$MODE_NAME' from '$DIS_NAME'"
  xrandr --delmode "$DIS_NAME" "$MODE_NAME"

  log_warn "Removing mode '$MODE_NAME'"
  xrandr --rmmode "$MODE_NAME"
}

trap finish EXIT

CLIP_POS=$(xrandr | grep "$DIS_NAME" | awk '{ print $3 }')
log_info "Display position: $CLIP_POS"

log_warn "Display active. CTRL+C to exit"
read
