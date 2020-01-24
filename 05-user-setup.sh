#!/bin/bash

# setup the network
# TODO - can we systemctl with sudo?
systemctl start NetworkManager.service
systemctl enable NetworkManager.service

# setup ntp
timedatectl set-ntp true
timedatectl status

# add bin to path
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# install base devel and update the mirrorlist
# TODO - can we use yay instead of pacman for noninteractive install?

sudo pacman -Sy base-devel reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# remove 05 script to leave a clean userspace
rm ~/05-user-setup.sh