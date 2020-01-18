#!/bin/bash

# NOTE: assumes 16G disk, use fdisk to get proper device

# connect to network, if necessary
#ip link
#ip link set enp0s3 up
#ping google.com

# partition disk where Arch Linux is being installed
fdisk -l
parted /dev/nvme1n1 mklabel gpt
parted /dev/nvme1n1 mkpart primary fat32 2048s 1050623s
parted /dev/nvme1n1 mkpart primary ext4 1050624s 1945135103s
parted /dev/nvme1n1 mkpart primary linux-swap 1945135104s 1953525134s
parted /dev/nvme1n1 set 1 bios_grub on

# format partitions
mkfs.fat -F32 /dev/nvme1n1p1
mkfs.ext4 /dev/nvme1n1p2
mkswap /dev/nvme1n1p3
swapon /dev/nvme1n1p3
mount /dev/nvme1n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme1n1p1 /mnt/boot

# verify partioning and formatting
lsblk