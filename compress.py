#!/bin/python3

import subprocess
import sys

USAGE = """Usage: compress FILE [SIZE]
Compress the given file into an mp4 of size SIZE, in MB. Defaults to 8MB if not given.
Special value "overwatch" trims the video to 00:05-0:17 before compressing to 8MB
"""
DEFAULT_MB = 8


def dprint(*args, sep=" ", end="\n"):
    if __debug__:
        print(*args, sep=sep, end=end, file=sys.stderr)


def main():
    argv, argc = sys.argv, len(sys.argv)
    if argc < 2 or argc > 3:
        print(USAGE)
        return
    filename = argv[1]
    if argc == 2:
        size = 8
    else:
        size_str = sys.argv[2]
        if size_str.lower() == "overwatch":
            raise NotImplementedError("todo lol")
        size = int(size_str)

    compress(filename, size)


def get_duration(filename) -> float:
    # https://ffmpeg.org/ffprobe.html
    completed_process = subprocess.run(
        [
            "ffprobe",
            "-v",
            "error",
            "-show_entries",
            "format=duration",  # SECTION_NAME=LOCAL_SECTION_ENTRIES
            "-print_format",  # output format
            "csv=print_section=0",
            filename,
        ],
        capture_output=True,
        check=True,
    )
    duration_str = completed_process.stdout
    dprint(f"{completed_process=}")
    exit()
    return float(duration_str)


def compress(filename, size):
    duration = get_duration(filename)
    # # Original audio rate
    # ORIGINAL_AUDIO_RATE=$(
    #   ffprobe \
    #     -v error \
    #     -select_streams a:0 \
    #     -show_entries stream=bit_rate \
    #     -of csv=p=0 "$1"
    # )
    #
    # # Original audio rate in KiB/s
    # ORIGINAL_AUDIO_RATE=$(
    #   awk \
    #     -v arate="$ORIGINAL_AUDIO_RATE" \
    #     'BEGIN { printf "%.0f", (arate / 1024) }'
    # )
    #
    # # Target size is required to be less than the size of the original audio stream
    # T_MINSIZE=$(
    #   awk \
    #     -v arate="$ORIGINAL_AUDIO_RATE" \
    #     -v duration="$ORIGINAL_DURATION" \
    #     'BEGIN { printf "%.2f", ( (arate * duration) / 8192 ) }'
    # )
    #
    # # Equals 1 if target size is ok, 0 otherwise
    # IS_MINSIZE=$(
    #   awk \
    #     -v size="$TARGET_SIZE" \
    #     -v minsize="$T_MINSIZE" \
    #     'BEGIN { print (minsize < size) }'
    # )
    #
    # # Give useful information if size is too small
    # if [[ $IS_MINSIZE -eq 0 ]]; then
    #   printf "%s\n" "Target size ${TARGET_SIZE}MB is too small!" >&2
    #   printf "%s %s\n" "Try values larger than" "${T_MINSIZE}MB" >&2
    #   exit 1
    # fi
    #
    # # Set target audio bitrate
    # TARGET_AUDIO_RATE=$ORIGINAL_AUDIO_RATE
    #
    # # Calculate target video rate - MB -> KiB/s
    # TARGET_VIDEO_RATE=$(
    #   awk \
    #     -v size="$TARGET_SIZE" \
    #     -v duration="$ORIGINAL_DURATION" \
    #     -v audio_rate="$ORIGINAL_AUDIO_RATE" \
    #     'BEGIN { print  ( ( size * 8192.0 ) / ( 1.048576 * duration ) - audio_rate) }'
    # )


def convert(in_file, out_file, target_rate, target_audio_rate):
    # https://ffmpeg.org/ffmpeg-all.html

    first_pass_process = subprocess.run(
        [
            "ffmpeg",
            "-y",  # Overwrite output files without asking (global)
            "-i",
            in_file,
            "-codec:v",
            "libx264",
            "-b:v",  # set bitrate
            f"{target_rate}k",  # todo
            "-pass",
            "1",
            "-an",  # skip audio stream
            "-f",  # output
            "rawvideo",  # "encode" into raw video
            "/dev/null",  # dump to null
        ],
        capture_output=False,
        check=True,
    )
    second_pass_process = subprocess.run(
        [
            "ffmpeg",
            "-i",
            in_file,
            "-c:v",
            "libx264",
            "-b:v",
            f"{target_rate}k",  # todo
            "-pass",
            "2",
            "-c:a",  # select audio codec: don't change it
            "copy",
            out_file,
            "",
        ],
        capture_output=False,
        check=True,
    )


if __name__ == "__main__":
    main()
