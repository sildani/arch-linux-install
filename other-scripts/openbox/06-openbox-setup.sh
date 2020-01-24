#!/bin/bash

# required packages for script
sudo pacman -Sy \
xorg-server lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper \
xf86-video-vmware alsa alsa-utils pulseaudio bluez bluez-utils code tilix htop \
openbox obconf nitrogen tint2 arc-gtk-theme breeze lxappearance pcmanfm archlinux-xdg-menu rofi

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

# grab resources this script depends on from the repo
git clone https://github.com/sildani/arch-linux-install ~/arch-linux-install
cp -R ~/arch-linux-install/resources/openbox/* ~/

# setup taskbar
rm -rf ~/.config/tint2
git clone https://github.com/addy-dclxvi/tint2-theme-collections ~/.config/tint2 --depth 1
sed 's/panel_items = TSC/panel_items = LTSC/' ~/.config/tint2/minima/minima.tint2rc > /tmp/tint2rc
sed 's/panel_position = bottom center horizontal/panel_position = top center horizontal/' /tmp/tint2rc > ~/.config/tint2/tint2rc
rm /tmp/tint2rc

# desktop wallpaper manager (nitrogen)
sudo mv ~/wallpaper /usr/share/backgrounds/daniel
mkdir -p ~/.config/nitrogen
mv ~/bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
mv ~/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# setup rofi
mkdir -p ~/.config/rofi
mv ~/config.rasi ~/.config/rofi/

# install Alsa-Tray AUR
yay -aS --noconfirm --answerdiff=None alsa-tray

# create openbox config dir
mkdir -p ~/.config/openbox

# setup ob theme
git clone https://github.com/addy-dclxvi/openbox-theme-collections ~/.themes
mv ~/rc.xml ~/.config/openbox/rc.xml

# setup application menu
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>

<openbox_menu xmlns=\"http://openbox.org/3.4/menu\">

<menu id=\"root-menu\" label=\"Openbox 3\">
  <menu id=\"applications\" label=\"Applications\" execute=\"xdg_menu --format openbox3-pipe --root-menu /etc/xdg/menus/arch-applications.menu\" />
  <separator />
  <item label=\"Log Out\">
    <action name=\"Exit\">
      <prompt>yes</prompt>
    </action>
  </item>
</menu>

</openbox_menu>" >> ~/.config/openbox/menu.xml

# setup session autostart
echo "tint2 &
alsa-tray &
nitrogen --restore" >> ~/.config/openbox/autostart

# clean up
rm ~/06-ui-setup.sh
rm -rf ~/arch-linux-install

# prompt user to reboot
echo "#######################################
#                                     #
#  Type \`reboot\` to reboot now and    #
#  launch your new UI. :)             #
#                                     #
#######################################"