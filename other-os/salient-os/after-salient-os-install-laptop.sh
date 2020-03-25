#!/bin/bash

# call the core script
~/code/arch-linux-install/other-os/salient-os/after-salient-os-install-core.sh

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/laptop-polybar-config ~/.config/polybar/config

# setup lid closing behavior
sudo cp /etc/systemd/logind.conf /etc/systemd/logind.conf.orig
sudo cp ~/code/arch-linux-install/other-os/salient-os/resources/laptop-logind.conf /etc/systemd/logind.conf
sudo cp ~/code/arch-linux-install/other-os/salient-os/resources/lock.service /etc/systemd/system/lock.service
sudo systemctl enable lock.service

# fix dpms settings (set display to go to sleep after 5 minutes)
sed -i 's/#exec --no-startup-id xset dpms 0 0 1200/exec --no-startup-id xset dpms 0 0 300/g' ~/.config/i3/config

# set max window size for floating windows
sed -i 's/floating_maximum_size -1 x -1/floating_maximum_size 1600 x 900/g' ~/.config/i3/config

# reverse mouse wheel scroll
echo -n "
For natural (reverse) scrolling, add the following to /usr/share/X11/xorg.conf.d/40-libinput.conf, for the touchpad InputClass section:

        Option \"NaturalScrolling\" \"True\"
"
read -p "Copy the above to the clipboard and press any key to edit the file in vim... "
sudo vim /usr/share/X11/xorg.conf.d/40-libinput.conf
echo "DONE"

# set up screen brightness keybinds
sudo usermod -a -G video daniel
yay -S --noconfirm light
light -N 5
echo "
#-------------------------------------------------------------------------
#                keybinds for adjusting screen brightness                |
#-------------------------------------------------------------------------
bindsym XF86MonBrightnessDown exec --no-startup-id light -U 10
bindsym XF86MonBrightnessUp exec --no-startup-id light -A 10"  >> ~/.config/i3/config