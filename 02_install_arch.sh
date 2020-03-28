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

# setup the network
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
sleep 3

# set the clock and timezone
timedatectl set-ntp true
hwclock --systohc
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime

# create user account
pacman -Sy --noconfirm zsh
echo "
Creating user and setting password"
echo -n "
Base user username: "
read ali_username
useradd -m -s /bin/zsh $ali_username
until passwd $ali_username; do
  sleep 1
done

# setup oh-my-zsh
pacman -Sy --noconfirm git
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$ali_username/.oh-my-zsh
cp /home/$ali_username/.oh-my-zsh/templates/zshrc.zsh-template /home/$ali_username/.zshrc
chown -R $ali_username:$ali_username /home/$ali_username/.oh-my-zsh
chown $ali_username:$ali_username /home/$ali_username/.zshrc

# add the user to sudoers file
sed -i "s/root ALL=(ALL) ALL/root ALL=(ALL) ALL\n$ali_username ALL=(ALL) ALL/g" /etc/sudoers

# run the rest of the commands as the base user
su -c "sh /03_install_arch.sh" - daniel

# cue next step
read -p "
Installation complete. Reboot and enjoy.

Press enter to continue...
"