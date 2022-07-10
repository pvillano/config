#!/bin/bash
#
# Re-encode a video to a target size in MB.
# Example:
#    ./compress.sh video.mp4 15
# based on https://stackoverflow.com/a/61146975/5666845

TARGET_SIZE="${2:-8}"               # target size in MB, defaults to 8
#TARGET_SIZE="${2:-100}"             # If you have discord nitro lol
TARGET_FILE="${1%.*}.${TARGET_SIZE}MB.mp4" # filename out

# Original duration in seconds
ORIGINAL_DURATION=$(
  ffprobe \
    -v error \
    -show_entries format=duration \
    -of csv=p=0 "$1"
)

# Original audio rate
ORIGINAL_AUDIO_RATE=$(
  ffprobe \
    -v error \
    -select_streams a:0 \
    -show_entries stream=bit_rate \
    -of csv=p=0 "$1"
)

# Original audio rate in KiB/s
ORIGINAL_AUDIO_RATE=$(
  awk \
    -v arate="$ORIGINAL_AUDIO_RATE" \
    'BEGIN { printf "%.0f", (arate / 1024) }'
)

# Target size is required to be less than the size of the original audio stream
T_MINSIZE=$(
  awk \
    -v arate="$ORIGINAL_AUDIO_RATE" \
    -v duration="$ORIGINAL_DURATION" \
    'BEGIN { printf "%.2f", ( (arate * duration) / 8192 ) }'
)

# Equals 1 if target size is ok, 0 otherwise
IS_MINSIZE=$(
  awk \
    -v size="$TARGET_SIZE" \
    -v minsize="$T_MINSIZE" \
    'BEGIN { print (minsize < size) }'
)

# Give useful information if size is too small
if [[ $IS_MINSIZE -eq 0 ]]; then
  printf "%s\n" "Target size ${TARGET_SIZE}MB is too small!" >&2
  printf "%s %s\n" "Try values larger than" "${T_MINSIZE}MB" >&2
  exit 1
fi

# Set target audio bitrate
TARGET_AUDIO_RATE=$ORIGINAL_AUDIO_RATE

# Calculate target video rate - MB -> KiB/s
TARGET_VIDEO_RATE=$(
  awk \
    -v size="$TARGET_SIZE" \
    -v duration="$ORIGINAL_DURATION" \
    -v audio_rate="$ORIGINAL_AUDIO_RATE" \
    'BEGIN { print  ( ( size * 8192.0 ) / ( 1.048576 * duration ) - audio_rate) }'
)

# Perform the conversion
ffmpeg \
  -y \
  -i "$1" \
  -c:v libx264 \
  -b:v "$TARGET_VIDEO_RATE"k \
  -pass 1 \
  -an \
  -f mp4 \
  /dev/null &&
  ffmpeg \
    -i "$1" \
    -c:v libx264 \
    -b:v "$TARGET_VIDEO_RATE"k \
    -pass 2 \
    -c:a copy \
    "$TARGET_FILE"
