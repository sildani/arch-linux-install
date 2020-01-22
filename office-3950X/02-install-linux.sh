#!/bin/bash

# edit mirror list to move US mirrors to top of list
pacman -Sy reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install Arch Linux onto disk + other base packages
# add amd-ucode or intel-ucode if not running on a vm
pacstrap /mnt base linux linux-firmware vim sudo amd-ucode

# generate file system table on new disk, and chroot into the new file system
genfstab -U /mnt >> /mnt/etc/fstab
cp ~/arch-linux-install/03-config-linux.sh /mnt
cp ~/arch-linux-install/05-user-setup.sh /mnt
cp ~/arch-linux-install/06-ui-setup.sh /mnt
cp -R ~/arch-linux-install/other-scripts /mnt/
arch-chroot /mnt