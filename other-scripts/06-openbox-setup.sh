#!/bin/bash

# required packages for script
sudo pacman -Sy xorg-server openbox obconf nitrogen tint2 arc-gtk-theme breeze lxappearance pcmanfm archlinux-xdg-menu lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper xf86-video-vmware code tilix htop rofi alsa alsa-utils pulseaudio bluez bluez-utils

# setup display manager
systemctl enable lightdm.service
# TODO - configure lightdm background

# setup application menu
mkdir -p ~/.config/openbox
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

# setup terminal
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc
dconf write /com/gexperts/Tilix/terminal-title-show-when-single false
dconf write /com/gexperts/Tilix/terminal-title-style "'small'"
dconf write /com/gexperts/Tilix/theme-variant "'dark'"

# setup ob theme
git clone https://github.com/addy-dclxvi/openbox-theme-collections ~/.themes
mv ~/rc.xml ~/.config/openbox/rc.xml

# setup taskbar
rm -rf ~/.config/tint2
git clone https://github.com/addy-dclxvi/tint2-theme-collections ~/.config/tint2 --depth 1
sed 's/panel_items = TSC/panel_items = LTSC/' ~/.config/tint2/minima/minima.tint2rc > /tmp/tint2rc
sed 's/panel_position = bottom center horizontal/panel_position = top center horizontal/' /tmp/tint2rc > ~/.config/tint2/tint2rc
rm /tmp/tint2rc

# desktop wallpaper manager (nitrogen)
sudo mv ~/wallpaper /usr/share/backgrounds/daniel
mkdir -p ~/.config/nitrogen
mv ~/nitrogen-bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
mv ~/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# setup rofi
mkdir -p ~/.config/rofi
mv ~/config.rasi ~/.config/rofi/

# setup bluetooth
systemctl enable bluetooth.service

# create user dirs
xdg-user-dirs-update
sudo pacman -Rn xdg-user-dirs

# enable multi-processor package building (in preparation for building and installing AURs)
cp /etc/makepkg.conf ~/
sed 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j4"/' ~/makepkg.conf > makepkg.conf.new
sudo mv ~/makepkg.conf.new /etc/makepkg.conf
rm ~/makepkg.conf
mkdir ~/AUR

# install yay
cd ~/AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# install Chrome AUR
yay -aS --noconfirm --answerdiff=None google-chrome
ln -s /usr/bin/google-chrome-stable ~/bin/chrome

# install Alsa-Tray AUR
yay -aS --noconfirm --answerdiff=None alsa-tray

# setup numlock enabled by default
echo "
[Seat:*]
greeter-setup-script=/usr/bin/numlockx on" >> /tmp/numlock.tmp
sudo bash -c 'cat /tmp/numlock.tmp >> /etc/lightdm/lightdm.conf'
rm /tmp/numlock.tmp

# add a vi shortcut that points to vim
ln -s /usr/bin/vim ~/bin/vi

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# setup session autostart
echo "tint2 &
alsa-tray &
nitrogen --restore" >> ~/.config/openbox/autostart

# clean up after yourself
rm ~/06-ui-setup.sh
rm ~/06-ui-setup.sh.orig

# prompt user exit shell (chroot)
echo "#######################################
#                                     #
#  Type \`reboot\` to reboot now and    #
#  launch your new UI. :)             #
#                                     #
#######################################"

exit ### NOT USED BELOW THIS LINE ###

# TODO - theme gtk and qt windows (breeze and lxappearance)
# TODO - automate the staging of these files
# mkdir -p ~/.config/gtk-2.0 && mv ~/gtk-2-gtkfilechooser.ini ~/.config/gtk-2.0/gtkfilechooser.ini
# mkdir -p ~/.config/gtk-3.0 && mv ~/gtk-3-settings.ini ~/.config/gtk-3.0/settings.ini

# terminal (rxvt)
# sudo pacman -Sy rxvt-unicode
# echo "
# \!--------------------xdefauls
# urxvt*termName: rxvt
# urxvt*scrollBar: false
# urxvt*matcher.button: 1
# urxvt.transparent: false
# urxvt.boldFont:
# Xft*dpi: 96
# Xft*antialias: true
# Xft*hinting: true
# Xft*hintstyle: hintfull
# Xft*rgba: rgb
# URxvt*geometry: 85x20
# *internalBorder: 23
# URxvt*fading: 0
# URxvt*tintColor: #ffffff
# URxvt*shading: 0
# URxvt*inheritPixmap: False
# \! special
# *.foreground:   #c5c8c6
# *.background:   #333232
# *.cursorColor:  #c5c8c6

# \! black
# *.color0:       #585c69
# *.color8:       #585c69

# \! red
# *.color1:       #cab0a1
# *.color9:       #cab0a1

# \! green
# *.color2:       #9f8578
# *.color10:      #9f8578

# \! yellow
# *.color3:       #986c5b
# *.color11:      #986c5b

# \! blue
# *.color4:       #808178
# *.color12:      #808178

# \! magenta
# *.color5:       #979892
# *.color13:      #979892

# \! cyan
# *.color6:       #cab0a1
# *.color14:      #cab0a1

# \! white
# *.color7:       #707880
# *.color15:      #707880" >> ~/.Xdefaults
# # is there a way to setup from command line?

# fix the menu (obmenu-generator, perl-data-dump)
# sudo vim /etc/makepkg.conf <--- REQUIRED?
# mkdir ~/AUR && cd ~/AUR <--- REQUIRED?
# cd ~/AUR
# git clone https://aur.archlinux.org/perl-linux-desktopfiles.git
# cd perl-linux-desktopfiles
# makepkg -si
# cd ~/AUR
# git clone https://aur.archlinux.org/obmenu-generator.git
# cd obmenu-generator
# makepkg -si
# obmenu-generator -p
