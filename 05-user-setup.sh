#!/bin/bash

# setup the network
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
#ping google.com

# setup ntp
timedatectl set-ntp true
timedatectl status

# add bin to path
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# install base devel and update the mirrorlist
sudo pacman -S base-devel reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# remove 05 script to leave a clean userspace
rm ~/05-user-setup.sh