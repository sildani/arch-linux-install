#!/bin/bash

# set the timezone
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

# generate locale; look for and uncomment en_US.UTF8 UTF8 in locale.gen
echo "
en_US.UTF8 UTF8" >> /etc/locale.gen
locale-gen

# define LANG env variable (LANG=en_US.UTF-8) in locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# define hostname
echo "azeroth" >> /etc/hostname

# bootstrap /etc/hosts - replace 127.0.0.1 with static IP if machine has one, replace $HOSTNAME with actual hostname as defined in /etc/hostname
echo "
127.0.0.1 localhost
::1       localhost
127.0.1.1 azeroth.localdomain azeroth" >> /etc/hosts

# set root password
passwd

# setup grub
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# install other supporting programs
pacman -S dosfstools e2fsprogs ntfs-3g networkmanager zsh sudo man-db man-pages texinfo

# create user account
useradd -m -s /bin/zsh daniel

# set user password
passwd daniel

# add daniel ALL=(ALL) ALL to sudoers file
EDITOR=vim visudo

# exit shell (chroot)
exit