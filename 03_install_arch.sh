#!/bin/bash

# create ~/bin and add to path
mkdir -p ~/bin
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# add a vi shortcut that points to vim
ln -s /usr/bin/vim ~/bin/vi

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# enable multi-processor package building
echo -n "
How many processors do you have? "
read ali_num_procs
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$ali_num_procs\"/" /etc/makepkg.conf

# install yay
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~/

# install reflector and update mirrorlist
yay -Sy --noconfirm reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install base packages
yay -Sy --noconfirm \
openssh dosfstools e2fsprogs ntfs-3g \
networkmanager man-db man-pages texinfo openssh

# install fonts
yay -Sy --noconfirm \
gnu-free-fonts terminus-font noto-fonts noto-fonts-emoji siji-git

# install ttf fonts
yay -Sy --noconfirm --nopgpfetch --mflags "--skipchecksums --skippgpcheck" \
ttf-ms-fonts ttf-unifont ttf-hack ttf-carlito \
ttf-croscore ttf-caladea ttf-roboto-mono ttf-roboto \
ttf-font-awesome ttf-ubuntu-font-family ttf-mac-fonts \
ttf-monaco ttf-dejavu ttf-dejavu-sans-code

# setup full-color emoji support
mkdir -p ~/.fonts
mkdir -p ~/.config/fontconfig/
cat << 'EOF' > ~/.config/fontconfig/fonts.conf
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<match>
 <test name="family"><string>sans-serif</string></test>
 <edit name="family" mode="prepend" binding="strong">
 <string>Noto Color Emoji</string>
 </edit>
 </match>
<match>
 <test name="family"><string>serif</string></test>
 <edit name="family" mode="prepend" binding="strong">
 <string>Noto Color Emoji</string>
 </edit>
 </match>
<match>
 <test name="family"><string>Apple Color Emoji</string></test>
 <edit name="family" mode="prepend" binding="strong">
 <string>Noto Color Emoji</string>
 </edit>
 </match>
EOF
fc-cache -f -v

# set console font
touch /etc/vconsole.conf
bash -c 'echo "FONT=ter-v16n.psf.gz" >> /etc/vconsole.conf'
setfont /usr/share/kbd/consolefonts/ter-v16n.psf.gz

# enable numlock on boot
yay -Sy --noconfirm systemd-numlockontty
sudo systemctl enable numLockOnTty

# install xorg
yay -Sy --noconfirm xorg-server xorg-xrandr

# install display driver
echo -n "
Specialized display driver? (amd/intel/vmware/none): "
read ali_display_driver_required
case "$ali_display_driver_required" in
"amd")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau"
  ;;
"intel")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="mesa lib32-mesa mesa xf86-video-intel vulkan-intel intel-media-driver"
  ;;
"vmware")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="xf86-video-vmware"
  ;;
"nvidia")
  read -p "Installing $ali_display_driver_required display driver not supported... press enter to continue"
  ali_display_driver_pkgs=""
  ;;
*)
  read -p "Skipping specialized display driver installation ($ali_display_driver_required), will use vesa generic driver... press enter to continue"
  ali_display_driver_pkgs=""
  ;;
esac
sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
yay -Sy --noconfirm $ali_display_driver_pkgs

# install i3 window manager + supporting tools
yay -Sy --noconfirm i3-gaps i3lock i3status dmenu polybar network-manager-applet

# install lightdm display manager
yay -Sy --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service

# create user dir
yay -Sy --noconfirm xdg-user-dirs
xdg-user-dirs-update

# install sound support
yay -Sy --noconfirm alsa-utils pulseaudio pulseaudio-alsa

# install bluetooth support
yay -Sy --noconfirm bluez bluez-utils pulseaudio-bluetooth
sudo systemctl enable bluetooth.service

# desktop notifications
yay -Sy --noconfirm dunst

# install terminal
yay -Sy --noconfirm kitty

# install htop
yay -Sy --noconfirm htop

# install file browser
yay -Sy --noconfirm thunar

# install web browser
yay -Sy --noconfirm vivaldi
sudo /opt/vivaldi/update-ffmpeg

# install text editor
yay -Sy --noconfirm visual-studio-code-bin

# install gaming apps / support
yay -Sy --noconfirm --needed wine wine-mono wine-gecko giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-radeon lib32-vulkan-radeon lutris steam

# install printer support
yay -Sy --noconfirm cups

# install pacman contrib (contains utlities like checkupdates)
yay -Sy --noconfirm pacman-contrib

# install clipit
yay -Sy --noconfirm clipit

# install desktop wallpaper support
yay -Sy --noconfirm feh \
archlinux-wallpaper elementary-wallpapers \
deepin-wallpapers deepin-community-wallpapers

# install screen locker
yay -Sy --noconfirm betterlockscreen

# install screen shot taker
yay -Sy --noconfirm flameshot

# install ui themer
yay -Sy --noconfirm lxappearance-gtk3

# install starter ui themes
yay -Sy --noconfirm \
breeze-gtk breeze-icons
arc-gtk-theme arc-icon-theme
deepin-gtk-theme deepin-icon-theme

# pasystray dunst
# arc-gtk-theme breeze

# clean up files
sudo rm /02_install_arch.sh /03_install_arch.sh

# cue next step
echo "
Installation complete. Exit this shell, then exit chroot, then reboot.

Enjoy! :)

"