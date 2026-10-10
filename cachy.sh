#!/bin/bash

echo sudo: adding astrisks and extending timeout

sudo cp ./sudoers.d/feedback ./sudoers.d/timeout /etc/sudoers.d
sudo chmod 0440 /etc/sudoers.d/feedback /etc/sudoers.d/timeout
sudo visudo -c

echo adding waiting periods for package managers...

mkdir --parents ~/.config/uv/
cat <<EOF > ~/.config/uv/uv.toml
exclude-newer = "7 days"
EOF

cat <<EOF > ~/.npmrc
min-release-age=7 # days
ignore-scripts=true
EOF

mkdir --parents ~/Library/Preferences/pnpm/
cat <<EOF > ~/Library/Preferences/pnpm/rc
minimum-release-age=10080 # minutes
EOF

cat <<EOF > ~/.bunfig.toml
[install]
minimumReleaseAge = 604800 # seconds
EOF

echo installing yay

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed git base-devel yay

git config --global user.email "peter@saej.in"
git config --global user.name "Peter Villano"

echo please manually select :\)

yay github
yay discord
yay nodejs
yay npm
yay prusa-slicer
yay steam
yay webstorm
yay webstorm-jre
yay wireguard-tools
yay eddie

