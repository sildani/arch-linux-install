#!/bin/bash

exit

# Below this line is stuff that I'm stashing for future potential usage

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