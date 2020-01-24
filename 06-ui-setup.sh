#!/bin/bash

# required packages for script
sudo pacman -Sy \
xorg-server lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper \
xf86-video-vmware alsa alsa-utils pulseaudio bluez bluez-utils code tilix htop \
xfce4 xfce4-goodies

# setup display manager
systemctl enable lightdm.service
echo "
[Seat:*]
greeter-setup-script=/usr/bin/numlockx on" >> /tmp/numlock.tmp
sudo bash -c 'cat /tmp/numlock.tmp >> /etc/lightdm/lightdm.conf'
rm /tmp/numlock.tmp
# TODO - configure lightdm background

# setup bluetooth
systemctl enable bluetooth.service

# create user dirs
xdg-user-dirs-update
sudo pacman -Rn xdg-user-dirs

# setup terminal
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc
dconf write /com/gexperts/Tilix/terminal-title-show-when-single false
dconf write /com/gexperts/Tilix/terminal-title-style "'small'"
dconf write /com/gexperts/Tilix/theme-variant "'dark'"

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# enable multi-processor package building (in preparation for building and installing AURs)
cp /etc/makepkg.conf ~/
sed 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j4"/' ~/makepkg.conf > makepkg.conf.new
sudo mv ~/makepkg.conf.new /etc/makepkg.conf
rm ~/makepkg.conf

# install yay
mkdir ~/AUR
cd ~/AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install Chrome AUR
yay -aS --noconfirm --answerdiff=None google-chrome
ln -s /usr/bin/google-chrome-stable ~/bin/chrome

# add readme to desktop
echo "From here on out, you can set up your system however you want it.

Some things I like to install / configure:

- Look and feel
  (desktop, taskbar, launcher, themes, fonts)
- ACPI event controls
- Gaming support (Wine, 3D Drivers, Lutris)
- Clipboard manager

See ~/bin/other-scripts for some options. Enjoy!" >> ~/Desktop/README.md

# add a vi shortcut that points to vim
ln -s /usr/bin/vim ~/bin/vi

# clean up
rm ~/06-ui-setup.sh

# prompt user exit shell (chroot)
echo "#######################################
#                                     #
#  Type \`reboot\` to reboot now and    #
#  launch your new UI. :)             #
#                                     #
#######################################"