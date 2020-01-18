#!/bin/bash

# install packages
sudo pacman -S xorg-server weston gnome gnome-extra gdm xdg-utils

# disable previous desktop manager, if required
systemctl disable lightdm.service

# enable gdm desktop manager
systemctl enable gdm.service