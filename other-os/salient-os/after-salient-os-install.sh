#!/bin/bash

# setup mirrors
echo "[++] Updating mirrorlist... "
sudo pacman-mirrors --country United_States
echo "[++] DONE\n\n"

# update system
echo "[++] Updating system... "
sudo pacman -Syyu --noconfirm
echo "[++] DONE\n\n"

# install vivaldi
yay -aS --noconfirm --needed --answerdiff=None vivaldi
sudo /opt/vivaldi/update-ffmpeg
sudo /opt/vivaldi/update-widevine
sed -i 's/chromium/vivaldi-stable/g' ~/.config/i3/config

# install visual studio code
yay -aS --noconfirm --needed --answerdiff=None visual-studio-code-bin

# install emoji font
sudo pacman -S --noconfirm noto-fonts-emoji
sudo cp ~/code/arch-linux-install/other-os/salient-os/resources/fonts-local.conf /etc/fonts/local.conf

# enable trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/polybar-config ~/.config/polybar/config

# setup xautolock
sed -i 's/#exec --no-startup-id xautolock/exec --no-startup-id xautolock/g' ~/.config/i3/config

# fix keyboard rate entry
sed -i 's/exec xset r rate 300 30/exec --no-startup-id xset r rate 300 30/g' ~/.config/i3/config

# fix i3exit reference in i3 config
sed -i 's/i3exit/\$HOME\/bin\/i3exit/g' ~/.config/i3/config

# fix pulse audio entries
sed -i 's/exec --no-startup-id pulseaudio --start/exec --no-startup-id start-pulseaudio-x11/g' ~/.config/i3/config
sudo sed -i 's/^volume = merge/volume = off/g' /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common

# fix screen resolution (specific to AOC 27" display)
sed -i 's/#exec --no-startup-id xrandr --output VGA-1 --mode 1920x1080 --rate 60/exec --no-startup-id xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.91/g' ~/.config/i3/config

# fix dpms settings (set display to go to sleep after 20 minutes)
sed -i 's/#exec --no-startup-id xset dpms 0 0 1200/exec --no-startup-id xset dpms 0 0 1200/g' ~/.config/i3/config

# set max window size for floating windows
sed -i 's/floating_maximum_size -1 x -1/floating_maximum_size 1920 x 1080/g' ~/.config/i3/config

# change resize binding
sed -i 's/bindsym Mod1+r/bindsym \$mod+r/g' ~/.config/i3/config

# remove workspace assignments that come built-in
sed 's/assign/#assign/g' ~/.config/i3/config

# set up morc_menu
git clone https://github.com/boruch-baum/morc_menu ~/code/morc_menu
cd ~/code/morc_menu
sudo make install
echo "
#-------------------------------------------------------------------------
#                               morc_menu                                |
#-------------------------------------------------------------------------
bindsym \$mod+z exec --no-startup-id morc_menu" >> ~/.config/i3/config
mkdir -p ~/.config/morc_menu
cp ~/code/arch-linux-install/other-os/salient-os/resources/morc_menu_v1.conf ~/.config/morc_menu/

# setup clipboard manager
yay -aS --noconfirm --needed --answerdiff=None clipit
echo "
#-------------------------------------------------------------------------
#                           clipboard manager                            |
#-------------------------------------------------------------------------
exec --no-startup-id clipit" >> ~/.config/i3/config

# custom floating window definitions
echo "
#-------------------------------------------------------------------------
#                          custom window config                          |
#-------------------------------------------------------------------------
for_window [title="TradeSkillMaster*"] floating enable
for_window [title="TSM*"] floating enable
for_window [title="run_in_term.sh"] floating enable"  >> ~/.config/i3/config

# make room for polybar at the top
echo "
#-------------------------------------------------------------------------
#                          make room for polybar                         |
#-------------------------------------------------------------------------
gaps top 30"  >> ~/.config/i3/config

# set the volume levels of the master and desktop devices
echo "
#-------------------------------------------------------------------------
#                           alsa device setup                            |
#-------------------------------------------------------------------------
exec_always --no-startup-id amixer set Master 50%; sleep 1; amixer -c 2 set PCM 80%"  >> ~/.config/i3/config

# update betterlockscreen image cache
echo "
#-------------------------------------------------------------------------
#                      betterlockscreen image cache                      |
#-------------------------------------------------------------------------
exec --no-startup-id betterlockscreen -u /usr/share/backgrounds"  >> ~/.config/i3/config

# setup screenshot support
mkdir -p ~/Pictures/shots
# sudo pacman -Sy --noconfirm flameshot
# echo "
# #-------------------------------------------------------------------------
# #                      flameshot (screenshot util)                       |
# #-------------------------------------------------------------------------
# exec --no-startup-id flameshot
# bindsym \$mod+Ctrl+Shift+s exec flameshot gui" >> ~/.config/i3/config

# send notification to start up xfce4-notifyd
echo "
#-------------------------------------------------------------------------
#                send notification to start xfce4-notifyd                |
#-------------------------------------------------------------------------
exec --no-startup-id notify-send \"i3wm\" \"i3wm is now loaded\""  >> ~/.config/i3/config

# change shell to zsh
chsh -s /bin/zsh

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# put $HOME/bin on shell path
echo "
# put ~/bin on PATH
export PATH=~/bin:\$PATH" >> ~/.zshrc

# setup powerline support
echo "
# powerline plugin
powerline-daemon -q
source /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh" >> ~/.zshrc

# setup powerlevel9k zsh theme
sed -i 's/ZSH_THEME="robbyrussell"/# ZSH_THEME="robbyrussell"/g' ~/.zshrc
sudo pacman -Sy --noconfirm zsh-theme-powerlevel9k
echo "
# powerlevel9k theme
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()" >> ~/.zshrc

# add zsh git aliases
echo "
# git aliases
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# setup alsi on new zsh shell
echo "
# print sys info on new term
alsi -l" >> ~/.zshrc

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

# ssh config
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo sed -i 's/#AddressFamily any/AddressFamily any/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress ::/ListenAddress ::/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl enable sshd
sudo systemctl start sshd