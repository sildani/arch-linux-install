#!/bin/bash

# generate locale; look for and uncomment en_US.UTF8 UTF8 in locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# define LANG env variable (LANG=en_US.UTF-8) in locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# define hostname
echo -n "
Hostname: "
read ali_hostname
echo $ali_hostname >> /etc/hostname

# bootstrap /etc/hosts - replace 127.0.0.1 with static IP if machine has one, replace $HOSTNAME with actual hostname as defined in /etc/hostname
echo "
127.0.0.1 localhost
::1       localhost
127.0.1.1 azeroth.localdomain azeroth" >> /etc/hosts

# setup grub
pacman -Sy --noconfirm grub os-prober efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
os-prober
grub-mkconfig -o /boot/grub/grub.cfg

# set root password
echo "
Setting root password"
until passwd; do
  sleep 1
done

# arch-chroot fin
echo "
Installation complete. Exit arch-chroot, reboot, log in as root, and then run sh /03_post_install_arch.sh to install a i3 and some helpful GUI tools.
"
