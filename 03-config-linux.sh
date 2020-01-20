#!/bin/bash

# install fonts, set console font
sudo pacman -S gnu-free-fonts terminus-font noto-fonts-emoji
sudo touch /etc/vconsole.conf
sudo bash -c 'echo "FONT=ter-v16n.psf.gz" >> /etc/vconsole.conf'
setfont /usr/share/kbd/consolefonts/ter-v16n.psf.gz

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
echo "#######################################
#                                     #
#        Setting root password        #
#                                     #
#######################################"
passwd

# setup grub
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# install other supporting programs
pacman -S dosfstools e2fsprogs ntfs-3g networkmanager zsh sudo man-db man-pages texinfo git openssh

# create user account
useradd -m -s /bin/zsh daniel

# set user password
echo "#######################################
#                                     #
#        Setting user password        #
#                                     #
#  Afterwards will put you in visudo  #
#      copy root entry for user       #
#                                     #
#######################################"
passwd daniel

# add daniel ALL=(ALL) ALL to sudoers file
EDITOR=vim visudo

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/daniel/.oh-my-zsh
cp /home/daniel/.oh-my-zsh/templates/zshrc.zsh-template /home/daniel/.zshrc
echo "
ZSH_THEME=\"dallas\"

if [ \`tput colors\` = \"256\" ]; then  
  ZSH_THEME=\"robbyrussell\"  
fi

source \$ZSH/oh-my-zsh.sh" >> /home/daniel/.zshrc
chown -R daniel:daniel /home/daniel/.oh-my-zsh
chown daniel:daniel /home/daniel/.zshrc

# prep scripts for use after reboot and user account login
cp /05-user-setup.sh /home/daniel/
cp /06-ui-setup.sh /home/daniel/
chown daniel:daniel /home/daniel/*.sh
mkdir /home/daniel/bin
chown daniel:daniel /home/daniel/bin

# prompt user exit shell (chroot)
echo "#######################################
#                                     #
#  Type \`exit\` to quit chroot now     #
#  Run 04-umount-and-reboot.sh after  #
#                                     #
#######################################"