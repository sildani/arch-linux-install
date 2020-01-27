#!/bin/bash

# required packages for script
sudo pacman -Sy --noconfirm \
xorg-server lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper \
xf86-video-vmware alsa alsa-utils pulseaudio bluez bluez-utils code tilix htop \
i3-wm i3status nitrogen rofi

# setup display manager
sudo systemctl enable lightdm.service
echo "
[Seat:*]
greeter-setup-script=/usr/bin/numlockx on" >> /tmp/numlock.tmp
sudo bash -c 'cat /tmp/numlock.tmp >> /etc/lightdm/lightdm.conf'
rm /tmp/numlock.tmp
# TODO - configure lightdm background

# create user dirs
xdg-user-dirs-update
sudo pacman -Rn --noconfirm xdg-user-dirs

# setup bluetooth
sudo systemctl enable bluetooth.service

# setup terminal
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc
dconf write /com/gexperts/Tilix/terminal-title-show-when-single false
dconf write /com/gexperts/Tilix/terminal-title-style "'small'"
dconf write /com/gexperts/Tilix/theme-variant "'dark'"
dconf write /com/gexperts/Tilix/window-style "'borderless'"

# enable multi-processor package building (in preparation for building and installing AURs)
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j4"/' /etc/makepkg.conf

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

# grab resources this script depends on from the repo
git clone https://github.com/sildani/arch-linux-install ~/arch-linux-install
cp -R ~/arch-linux-install/resources/i3/* ~/
cp -R ~/arch-linux-install/resources/wallpaper ~/

# desktop wallpaper manager (nitrogen)
sudo mv ~/wallpaper /usr/share/backgrounds/daniel
mkdir -p ~/.config/nitrogen
mv ~/bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
mv ~/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# setup rofi
mkdir -p ~/.config/rofi
mv ~/config.rasi ~/.config/rofi/

# setup i3status
mkdir -p ~/.config/i3status
mv ~/i3status.conf ~/.config/i3status/config

# setup i3
mkdir -p ~/.config/i3
mv ~/config ~/.config/i3/config

# clean up
rm ~/06-setup-gui.sh

# prompt user to reboot
echo "#######################################
#                                     #
#  Type \`reboot\` to reboot now and    #
#  launch your new UI. :)             #
#                                     #
#######################################"