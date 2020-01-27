#!/bin/bash

# Partitions a disk as a GPT disk with an efi boot partition, a root partition, and a swap partition

# Script requires review before execution
echo "#######################################
#                                     #
#  By default, this script assumes a  #
#  16GB disk at /dev/sda. Use fdisk   #
#  to get proper device, edit this    #
#  script accordingly, and comment    #
#  out or remove the exit command     #
#  once you're ready.                 #
#                                     #
#######################################"
exit

# wipe the slate clean first
dd if=/dev/zero of=/dev/sda bs=1M

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