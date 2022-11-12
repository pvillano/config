#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt install -y ffmpeg \
    moreutils \
    python3-pip \
    thefuck \
    unzip

echo 'eval $(thefuck --alias)' >> ~/.bashrc

if [[ $(grep -iE "microsoft|msft|wsl" /proc/version) ]]; then
    echo "WSL detected"
    echo "skipping mullvad, lxd"
else
    sudo apt install -y lxd
    curl -L "https://mullvad.net/download/app/deb/latest/" -o mullvad.deb && \
    sudo apt install -y ./mullvad.deb
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

#if [[ its a server]]
#  sudo apt install avahi-daemon
#fi