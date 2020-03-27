#!/bin/bash

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

# run script as user (requires user being sudo enabled)
su -c "/04_post_install_arch.sh" -s /bin/sh $ali_username

# clean up
cp /02_install_arch.sh /tmp
cp /03_post_install_arch.sh /tmp
cp /04_post_install_arch.sh /tmp