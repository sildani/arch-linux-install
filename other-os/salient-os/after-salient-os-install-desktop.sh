#!/bin/bash

# call the core script
~/code/arch-linux-install/other-os/salient-os/after-salient-os-install-core.sh

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/desktop-polybar-config ~/.config/polybar/config

# fix screen resolution (specific to AOC 27" display)
sed -i 's/#exec --no-startup-id xrandr --output VGA-1 --mode 1920x1080 --rate 60/exec --no-startup-id xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.91/g' ~/.config/i3/config

# fix dpms settings (set display to go to sleep after 20 minutes)
sed -i 's/#exec --no-startup-id xset dpms 0 0 1200/exec --no-startup-id xset dpms 0 0 1200/g' ~/.config/i3/config

# set max window size for floating windows
sed -i 's/floating_maximum_size -1 x -1/floating_maximum_size 1920 x 1080/g' ~/.config/i3/config

# reverse mouse wheel scroll
echo -n "
For natural (reverse) scrolling, add the following to /usr/share/X11/xorg.conf.d/40-libinput.conf, for the pointer InputClass section:

        Option \"NaturalScrolling\" \"True\"
"
read -p "Copy the above to the clipboard and press any key to edit the file in vim... "
sudo vim /usr/share/X11/xorg.conf.d/40-libinput.conf
echo "DONE"

# update resolution and wallpapers
xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.91
betterlockscreen -u /usr/share/backgrounds