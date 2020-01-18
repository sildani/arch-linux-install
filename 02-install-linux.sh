#!/bin/bash

# edit mirror list to move US mirrors to top of list
pacman -S reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install Arch Linux onto disk + other base packages
# add amd-ucode or intel-ucode if not running on a vm
pacstrap /mnt base linux linux-firmware vim 

# generate file system table on new disk, and chroot into the new file system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt