#!/bin/bash

# set the timezone
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

# generate locale; look for and uncomment en_US.UTF8 UTF8 in locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
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
echo "Setting root password"
passwd

# setup grub
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# install other supporting programs
pacman -S dosfstools e2fsprogs ntfs-3g networkmanager zsh sudo man-db man-pages texinfo git

# create user account
useradd -m -s /bin/zsh daniel

# set user password
echo "Setting user password"
passwd daniel

# add daniel ALL=(ALL) ALL to sudoers file
EDITOR=vim visudo

# prep 05 script to use on reboot and user account login
cp /05-user-setup.sh /home/daniel/
cp /06-ui-setup.sh /home/daniel/
chown daniel:daniel /home/daniel/*..sh
mkdir /home/daniel/bin
cp -R /other-scripts /home/daniel/bin/
chown -R daniel:daniel /home/daniel/bin/other-scripts

# prompt user exit shell (chroot)
echo "####################################
#                                  #
#  Type `exit` to exit chroot now  #
#                                  #
####################################"