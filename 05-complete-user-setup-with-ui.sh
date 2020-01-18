#!/bin/bash

## >><< ##

# Now log in as your new shiny sudo user and finish setting up your user. The key things to do:
#
# 0. Set up the network
# 1. Set up fonts
# 2. Set up oh-my-zsh
# 3. Update pacman mirrorlist
# 4. Set up the GUI
# 5. Install desktop apps
#    a. Chrome browser
#    b. Code text editor
#    c. Tilix terminal emulator
#
# When you first log in, you will be prompted to set up zsh - ignore that, because you will set up oh-my-zsh as part of the initial config.

# setup the network
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
ping google.com

# install fonts, set console font
sudo pacman -S gnu-free-fonts terminus-font
sudo touch /etc/vconsole.conf
sudo bash -c 'echo "FONT=ter-v16n.psf.gz" >> /etc/vconsole.conf'
setfont /usr/share/kbd/consolefonts/ter-v16n.psf.gz

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
. ~/.zshrc
echo "
ZSH_THEME=\"daveverwer\"

if [ \`tput colors\` = \"256\" ]; then  
  ZSH_THEME=\"robbyrussell\"  
fi

source \$ZSH/oh-my-zsh.sh" >> ~/.zshrc

# install base devel, git, and update the mirrorlist
sudo pacman -S base-devel git reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install X, Xfce desktop environment, lightdm display manager, xdg user dirs
sudo pacman -S xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xdg-user-dirs

# install suitable driver
# list the devices then query packages for the right package
#lspci | grep -e VGA -e 3D
#pacman -Ss xf86-video
sudo pacman -S xf86-video-vmware

# optionally run query to see if there are other vmware related packages you should install
# install anything you like with sudo pacman -S package_name
pacman -Ss vmware

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

# reboot
reboot

##############################################
# From here on out, you can set up your
# system however you want it.
#
# Some things I like to install / configure:
# 
# - Look and feel
#   (desktop, taskbar, launcher, themes, fonts)
# - ACPI event controls
# - Sound
# - Bluetooth
# - Gaming support (Wine, 3D Drivers, Lutris)
# - Emoji font
# - Clipboard manager
# - My own scripts in ~/bin
#   (e.g., mount an NTFS drive)
##############################################