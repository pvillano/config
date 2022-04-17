#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt install ffmpeg \
    moreutils \
    python3-pip \
    thefuck \
    unzip

if [[ $(grep -iE "microsoft|msft|wsl" /proc/version) ]]; then
    echo "WSL detected"
    echo "skipping mullvad, lxd"
else
    sudo apt install lxd
    curl -L "https://mullvad.net/download/app/deb/latest/" -o mullvad.deb && \
    sudo apt install ./mullvad.deb
fi

sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

echo "Time to config manually"
if [[ $(grep -iE "microsoft|msft|wsl" /proc/version) ]]; then
    echo "WSL detected"
    echo "skipping mullvad, lxd"
else
    lxd init
    # todo
#     mullvad do something
fi