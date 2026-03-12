export AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-120}"
export AWWW_TRANSITION_STEP="${AWWW_TRANSITION_STEP:-4}"

WALLPAPER_DIR="$HOME/images/wallpapers/awww"

current_wallpaper=$(awww query --json | jq .\"\"[].displaying.image -r | rev | cut -d/ -f 1 | rev)

file=$(find "$WALLPAPER_DIR" -type f -iname '*.png' | grep -v "$current_wallpaper" | sort --random-sort | tail -n1)

awww img --resize="crop" "$file"
