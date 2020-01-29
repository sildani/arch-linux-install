#!/bin/bash

# edit mirror list to move US mirrors to top of list
pacman -Sy --noconfirm reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install Arch Linux onto disk + other base packages
# add amd-ucode or intel-ucode if not running on a vm
pacstrap /mnt base linux linux-firmware vim sudo

# generate file system table on new disk, and chroot into the new file system
genfstab -U /mnt >> /mnt/etc/fstab
cp ~/arch-linux-install/03-config-linux.sh /mnt
cp ~/arch-linux-install/05-setup-network.sh /mnt
cp ~/arch-linux-install/06-setup-user-account.sh /mnt
cp ~/arch-linux-install/07-setup-gui.sh /mnt
cp -R ~/arch-linux-install/other-scripts /mnt/
arch-chroot /mnt