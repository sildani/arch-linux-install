#!/bin/bash

# NOTE: assumes 16G disk, use fdisk to get proper device

# partition disk where Arch Linux is being installed
fdisk -l
parted /dev/sda mklabel gpt
parted /dev/sda mkpart primary fat32 2048s 1050623s
parted /dev/sda mkpart primary ext4 1050624s 29358079s
parted /dev/sda mkpart primary linux-swap 29358080s 33554398s
parted /dev/sda set 1 bios_grub on

# format partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# verify partioning and formatting
lsblk