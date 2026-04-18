#!/bin/bash

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

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed git base-devel yay

yay discord nodejs npm prusa-slicer steam webstorm webstorm-jre wireguard-tools eddie


echo "\`sudo visudo\` and then add 'Default pwfeedback' to enable asterisks"
