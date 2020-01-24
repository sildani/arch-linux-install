#!/bin/bash

# stage disk partitioning
cp ~/arch-linux-install/office-3950X/01-partition-disk.sh ~/arch-linux-install/01-partition-disk.sh

# stage linux install
sed 's/pacstrap \/mnt base linux linux-firmware vim sudo/pacstrap \/mnt base linux linux-firmware vim sudo amd-ucode/' ~/arch-linux-install/02-install-linux.sh > /tmp/02-install-linux.sh
mv /tmp/02-install-linux.sh ~/arch-linux-install/02-install-linux.sh

# stage ui setup
sed 's/sudo pacman -Sy xf86-video-vmware/sudo pacman -Sy xf86-video-amdgpu/' ~/arch-linux-install/06-ui-setup.sh > /tmp/06-ui-setup.sh
mv /tmp/06-ui-setup.sh ~/arch-linux-install/06-ui-setup.sh