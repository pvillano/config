#!/bin/python3

import subprocess
import sys

USAGE = """Usage: compress FILE.mp4 [SIZE]
Compress the given file into an mp4 of size SIZE, in MB. Defaults to 25MB if not given.
new file name is FILE.SIZEmb.mp4
"""
DEFAULT_MB = 25


def main():
    argv, argc = sys.argv, len(sys.argv)
    if argc < 2 or argc > 3:
        print(USAGE)
        return
    filename = argv[1]
    if argc == 2:
        size = DEFAULT_MB
    else:
        size = int(sys.argv[2])
    compress_to_size(filename, size)


def get_duration(filename) -> float:
    # https://ffmpeg.org/ffprobe.html
    completed_process = subprocess.run(
        [
            "ffprobe",
            "-loglevel", "error",
            "-show_entries", "format=duration",  # in the format section, the duration value
            "-print_format", "csv=print_section=0",  # use csv with no section names
            filename,
        ],
        capture_output=True,
        check=True,
    )
    return float(completed_process.stdout)


def get_audio_bitrate(filename) -> float:
    completed_process = subprocess.run(
        [
            "ffprobe",
            "-loglevel", "error",
            "-select_streams", "a:0",  # first audio stream
            "-show_entries", "stream=bit_rate",  # in the stream section, the bit rate
            "-print_format", "csv=print_section=0",  # use csv with no section names
            filename,
        ],
        capture_output=True,
        check=True,
    )
    return float(completed_process.stdout)


def compress_to_size(filename, size_megabytes) -> None:
    duration = get_duration(filename)
    original_audio_bitrate = get_audio_bitrate(filename)
    target_min_size_bits = original_audio_bitrate * duration
    target_min_size_megabytes = target_min_size_bits / (8 * 1000 ** 2)
    if size_megabytes < target_min_size_megabytes:
        raise ValueError(f"Target size too small, minimum size is {target_min_size_megabytes}")
    target_video_bitrate = (size_megabytes * 8 * 1000 ** 2) / duration - original_audio_bitrate
    in_file = filename
    out_file = filename[:-len(".mp4")] + f".{size_megabytes}mb.mp4"
    compress_to_bitrate(in_file, out_file, target_video_bitrate)


def compress_to_bitrate(in_file, out_file, target_video_bitrate) -> None:
    # https://ffmpeg.org/ffmpeg-all.html

    subprocess.run(
        [
            "ffmpeg",
            "-y",  # Overwrite output files without asking (global)
            "-i", in_file,  # input file
            "-codec:v", "libx264",  # video codec
            "-b:v", f"{target_video_bitrate}",  # target video bitrate
            "-pass", "1",  # first pass
            "-an",  # skip audio stream
            "-f", "rawvideo",  # output format raw video
            "/dev/null",  # dump to null
        ],
        capture_output=False,
        check=True,
    )
    subprocess.run(
        [
            "ffmpeg",
            "-i", in_file,  # input file
            "-c:v", "libx264",  # video codec
            "-b:v", f"{target_video_bitrate}",  # target video bitrate
            "-pass", "2",  # 2nd pass
            "-c:a", "copy",  # set audio codec copy only
            out_file,
        ],
        capture_output=False,
        check=True,
    )


if __name__ == "__main__":
    main()
