#!/bin/bash

# stage disk partitioning
sed 's/16GB disk/1TB disk/; s/parted \/dev\/sda/parted \/dev\/nvme1n1/; s/\/dev\/sda1/\/dev\/nvme1n1p1/; s/\/dev\/sda2/\/dev\/nvme1n1p2/; s/\/dev\/sda3/\/dev\/nvme1n1p3/; s/29358079s/1945135103s/; s/29358080s 33554398s/1945135104s 1953525134s/' ~/arch-linux-install/01-partition-disk.sh > /tmp/01-partition-disk.sh
mv /tmp/01-partition-disk.sh ~/arch-linux-install/01-partition-disk.sh

# stage linux install
sed 's/pacstrap \/mnt base linux linux-firmware vim sudo/pacstrap \/mnt base linux linux-firmware vim sudo amd-ucode/' ~/arch-linux-install/02-install-linux.sh > /tmp/02-install-linux.sh
mv /tmp/02-install-linux.sh ~/arch-linux-install/02-install-linux.sh

# stage ui setup
sed 's/xf86-video-vmware/xf86-video-amdgpu/' ~/arch-linux-install/06-setup-gui.sh > /tmp/06-setup-gui.sh
mv /tmp/06-setup-gui.sh ~/arch-linux-install/06-setup-gui.sh