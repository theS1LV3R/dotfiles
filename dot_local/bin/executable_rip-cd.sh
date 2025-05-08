#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck disable=2155
# SC2155 = Declare and assign separately to avoid masking return values.

# Audio CDs use a format called Compact Disk Digital Audio [1] (CDDA), which isn't a file system,
# i.e. they can't be mounted. Therefore we use this script and these tools to rip them.
# [1]: https://en.wikipedia.org/wiki/Compact_Disc_Digital_Audio

# Sources:
# - https://wiki.archlinux.org/title/Rip_Audio_CDs
# - https://www.systutorials.com/docs/linux/man/1-icedax/
# - https://gnudb.org/howto.php
# - https://stackoverflow.com/questions/58379142/
# - https://sound.stackexchange.com/questions/48596/
# - https://xiph.org/vorbis/doc/v-comment.html
# - https://en.wikipedia.org/wiki/Compact_Disc_Digital_Audio#Bit_rate

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

set -o errexit                  # exit on error
set -o nounset                  # do not use unset variables
set -o pipefail                 # fail early in piped commands
[[ -n "${TRACE:-}" ]] && set -x # debug

#############
# Constants #
#############

readonly EXIT_OK=0
readonly EXIT_GENERAL_ERR=1
readonly EXIT_GETOPT_ERR=2
readonly EXIT_OPTIONS_ERROR=3
readonly EXIT_UNKNOWN_DEVICE=4

# Dependencies in the format of "executable:"
readonly DEPENDENCIES=(
    getopt
    icedax:Ripping the DVD/CDs themselves
    flac:Converting from raw data to flac
    sed:Various utility stuff
    date:Recording start and end times for total time spent measurement
)

readonly CLONE_DEVICE="${CLONE_DEVICE:-'/dev/cdrom'}"
readonly CDDB_ENABLED="${CDDB_ENABLED:-'1'}"
readonly CDDBP_SERVER="${CDDBP_SERVER:-'gnudb.gnudb.org'}"
readonly CDDBP_PORT="${CDDBP_PORT:-'8880'}"

readonly icedax_common_opts=(
    --verbose-level=all          # Log as much as possible
    --cddb="$CDDB_ENABLED"       # Use cddb to get media info and output to correct files
    cddbp-server="$CDDBP_SERVER" # Specify cddb server to use
    cddbp-port="$CDDBP_PORT"     # Specify cddb port on the server to use
    dev="$CLONE_DEVICE"          # What device to clone
)

readonly icedax_info_opts=(
    --info-only # Does not write, only gives information
    --gui       # Enables simple output format, for GUIs (or to extract info more easily)
)


#############
# Variables #
#############

#? general variables

#####################
# Utility functions #
#####################

usage() {
    cat <<EOF
NAME
    $0

SYNOPSIS
    $0 [OPTION...]

DESCRIPTION
    INSERT DESCRIPTION HERE

OPTIONS
    -h,          --help                 Show this message
    -v,          --verbose              Log verbose messages to console.
EOF
}

now() { date "+%Y-%m-%d %H:%M:%S"; }

get_options() {
    local parsed

    # Define short options
    local options=hv
    # Define long options
    local longopts=help,verbose

    parsed=$(getopt --options="$options" --longoptions="$longopts" --name="$0" -- "$@")

    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        # e.g. return value is 1
        #  then getopt has complained about wrong arguments to stdout
        exit "$EXIT_GETOPT_ERR"
    fi

    # read getopt’s output this way to handle the quoting right:
    eval set -- "$parsed"

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
        -h | --help)
            usage
            shift
            exit "$EXIT_OK"
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error" >&2
            exit "$EXIT_OPTIONS_ERROR"
            ;;
        esac
        shift
    done
}

process_file() {
    local raw_trackname="$1"
    local cdindex_discid cddb_discid album_artist album_title track_title track_number channels endianess

    cdindex_discid=$(sed -nr "s|CDINDEX_DISCID=\s+'(.*)'$|\1|p" "$raw_trackname.inf")
    cddb_discid=$(sed -nr "s|CDDB_DISCID=\s+(.*)$|\1|p" "$raw_trackname.inf")
    album_artist=$(sed -nr "s|Albumperformer=\s+'(.*)'$|\1|p" "$raw_trackname.inf")
    album_title=$(sed -nr "s|Albumtitle=\s+'(.*)'$|\1|p" "$raw_trackname.inf")
    track_title=$(sed -nr "s|Tracktitle=\s+'(.*)'$|\1|p" "$raw_trackname.inf")
    track_number=$(sed -nr "s|Tracknumber=\s+([0-9]+)$|\1|p" "$raw_trackname.inf")
    channels=$(sed -nr "s|Channels=\s+([0-9]+)$|\1|p" "$raw_trackname.inf")
    endianess=$(sed -nr "s|Endianess=\s+(.*)$|\1|p" "$raw_trackname.inf")

    local date genre
    date=$(sed -nr "s|DYEAR=(.*)$|\1|p" "audio.cddb")
    genre=$(sed -nr "s|DGENRE=(.*)$|\1|p" "audio.cddb")

    local flac_opts=(
        --endian="$endianess"     # Set endianess to the correct value. This cannot be hardcoded, as that will create borked files
        --channels="$channels"    # Explicitly set channel count from file information
        --sample-rate=44100       # Highest supported by CDDA, also icedax default
        --sign=signed             # CDDA is always signed
        --bps=16                  # Bits per sample. Icedax outputs in 16 @ 44100Hz
        --best                    # Best compression without losing quality
        --exhaustive-model-search # Higher CPU time; Try to find better compression
        --verify                  # Verify correct encoding by decoding in parallel and comparing to original

        # Add tags for programs like lidarr to use to identify the track
        # Definitions: https://xiph.org/vorbis/doc/v-comment.html
        --tag="CDINDEX=$cdindex_discid"
        --tag="CDDB=$cddb_discid"
        --tag="ARTIST=$album_artist"
        --tag="ALBUM=$album_title"
        --tag="TITLE=$track_title"
        --tag="TRACKNUMBER=$track_number"
        --tag="TRACKTOTAL=$track_count"
        --tag="DATE=$date"
        --tag="GENRE=$genre"
        --tag="ENCODER=$USER"

        --output-name="$track_number - $track_title.flac" # Output filename
        "$raw_trackname.raw"                              # Input filename
    )

    # Convert the raw data to a flac file
    flac "${flac_opts[@]}"
}

##################
# Main functions #
##################

main() {
    check_dependencies "${DEPENDENCIES[@]}"
    get_options "$@"

    if [[ ! -e "$CLONE_DEVICE" ]]; then
        log_error "Unknown device $CLONE_DEVICE. Cannot rip."
        exit "$EXIT_UNKNOWN_DEVICE"
    fi

    local start
    start=$(date +%s)
    log_info "Started at $start"

    # Extract track count
    #   -n = Quiet (dont print unless explicitly asked)
    #   -r = Extended regexp
    #   .../p' = Print (aka explicitly asked)
    #   Regex:
    #     Tracks: - Match "Tracks:" explicitly
    #     ([0-9]+) - Match 1 or more numbers, create a group (\1)
    #     " .*" - Match a space followed by any amount of any characters (excluding newlines)
    #     \1 - Replace the matched string with group 1, aka the numbers matched earlier
    log_info "Extracting information from $CLONE_DEVICE"
    local information track_count
    information=$(icedax "${icedax_info_opts[@]}" "${icedax_common_opts[@]}" 2>&1)
    track_count=$(echo "$information" | sed -nr 's|Tracks:([0-9]+) .*|\1|p')
    log_info "$track_count tracks on the disk"

    # sudo for setting realtime (A warning pops up without it)
    # Outputs to "track_XX.{raw,inf}" files
    local icedax_clone_opts=(
        --stereo                 # Output both audio tracks
        --max                    # Maximum (CD) quality
        "--output-format=raw"      # Output raw bytes instead of doing any post-processing. We do that later on.
        "--track=1+$track_count" # Ouput tracks 1 through <amount of tracks>. Required for --bulk to output all files instead of just the first track
        --bulk                   # Output to separate files
    )
    log_info "Ripping drive $CLONE_DEVICE"
    sudo icedax "${icedax_clone_opts[@]}" "${icedax_common_opts[@]}"

    # Create the "orig" folder for all the raw files
    log_info "Ensuring directory exists for original files"
    mkdir -v orig || true

    # Process all the audio files
    local post_process_files post_process_files_count
    post_process_files=(audio_*.raw)
    post_process_files_count=${#post_process_files}

    log_info "Starting post-processing for $post_process_files_count file(s)"
    local i
    i=0
    for file in "${post_process_files[@]}"; do
        ((i++))
        log_info "$i/$post_process_files_count - $file"
        # Extract the filename by removing the file extension
        raw_trackname="${file%%.*}"

        process_file "$raw_trackname"

        log_info "Moving source files to orig dir"
        mv -v "$raw_trackname".* orig
    done

    local end
    end=$(date +%s)
    log_info "Ended at $end"

    local runtime
    runtime=$(date -d@$((end - start)) -u +%Hh%Mm%S.%2Ns)
    log_info "Finished. Processed $post_process_files_count file(s). Took $runtime"
}

main "$@"
