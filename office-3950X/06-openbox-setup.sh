#!/bin/bash

# required packages for script (assumes amd gpu)
# TODO - do I really need xdg-user-dirs?
sudo pacman -S xorg-server openbox obconf nitrogen tint2 arc-gtk-theme breeze lxappearance pcmanfm archlinux-xdg-menu lightdm lightdm-gtk-greeter xdg-user-dirs numlockx archlinux-wallpaper xf86-video-amdgpu code tilix htop

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
# TODO - file replacement for tilix
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc
dconf write /com/gexperts/Tilix/terminal-title-show-when-single false
dconf write /com/gexperts/Tilix/terminal-title-style "'small'"
dconf write /com/gexperts/Tilix/theme-variant "'dark'"

# setup ob theme
git clone https://github.com/addy-dclxvi/openbox-theme-collections ~/.themes
# TODO - add window snapping to rc.xml keybinds area
# TODO - automate the staging of these files
mv ~/triste-folly-theme-rc.xml ~/.config/openbox/rc.xml

# setup taskbar
rm -rf ~/.config/tint2
git clone https://github.com/addy-dclxvi/tint2-theme-collections ~/.config/tint2 --depth 1
cp ~/.config/tint2/minima/minima.tint2rc ~/.config/tint2/tint2rc
# TODO - add further configuration to tint2rc

# TODO - theme gtk and qt windows (breeze and lxappearance)
# ...

# desktop wallpaper manager (nitrogen)
# TODO - automate the staging of these files
mv ~/nitrogen-bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
mv ~/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# TODO - setup rofi (https://wiki.archlinux.org/index.php/Rofi)

# setup session autostart
echo "tint2 &
nitrogen --restore" >> ~/.config/openbox/autostart





# window tiling manager (aka gtile ??????)
# is there a way to setup from command line?

# TODO - bring over other things we do from 06-ui-setup.sh

### NOT USED BELOW THIS LINE ###

# terminal (rxvt)
# sudo pacman -S rxvt-unicode
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