#!/bin/bash

# install packages
sudo pacman -Sy --noconfirm xorg-server weston gnome gnome-extra gdm xdg-utils

# disable previous desktop manager, if required
sudo systemctl disable lightdm.service

# enable gdm desktop manager
sudo systemctl enable gdm.service