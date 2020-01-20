#!/bin/bash

# install X, Xfce desktop environment, lightdm display manager, xdg user dirs
sudo pacman -S xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper

# install suitable driver
sudo pacman -S xf86-video-amdgpu

# setup audio
sudo pacman -S alsa alsa-utils pulseaudio

# setup bluetooth
sudo pacman -S bluez bluez-utils
systemctl enable bluetooth.service

# enable lightdm service
systemctl enable lightdm.service

# create common user directories
xdg-user-dirs-update

# install Chrome AUR
# makepkg.conf edit:
#     un-comment MAKEFLAGS="-j2" and change the '2' to the number of processors you have
sudo vim /etc/makepkg.conf
mkdir ~/AUR && cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git 
cd google-chrome
makepkg -si

# install Code text editor and Tilix terminal emulator
sudo pacman -S code tilix

# add tilix config to avoid errors
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc

# add readme to desktop
echo "From here on out, you can set up your system however you want it.

Some things I like to install / configure:

- Look and feel
  (desktop, taskbar, launcher, themes, fonts)
- ACPI event controls
- Gaming support (Wine, 3D Drivers, Lutris)
- Clipboard manager

See ~/bin/other-scripts for some options. Enjoy!" >> ~/Desktop/README.md

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# setup numlock enabled by default
echo "
[Seat:*]
greeter-setup-script=/usr/bin/numlockx on" >> /tmp/numlock.tmp
sudo bash -c 'cat /tmp/numlock.tmp >> /etc/lightdm/lightdm.conf'
rm /tmp/numlock.tmp

# remove 06 script to leave a clean userspace
rm ~/06-ui-setup.sh

# prompt user exit shell (chroot)
echo "#######################################
#                                     #
#  Type \`reboot\` to reboot now and  #
#  launch your new UI. :)             #
#                                     #
#######################################"