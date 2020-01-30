#!/bin/bash

# Latest info can be found at:
# https://wiki.winehq.org/Ubuntu
# https://github.com/lutris/lutris/wiki/Installing-drivers

# enable 32 bit architecture
sudo dpkg --add-architecture i386

# download and add the repository key
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
rm winehq.key

# add the repo
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main'

# update packages
sudo apt update

# install wine
sudo apt install --install-recommends winehq-staging

# install support for 32-bit games
sudo apt install libgl1-mesa-dri:i386

# install support for Vulkan API
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386

# install lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt-get update
sudo apt-get install lutris

# reboot to complete the install
reboot