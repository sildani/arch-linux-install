#!/bin/bash

# setup mirrors
echo "[++] Updating mirrorlist... "
sudo pacman-mirrors --country United_States
echo "[++] DONE\n\n"

# update system
echo "[++] Updating system... "
sudo pacman -Syyu
echo "[++] DONE\n\n"

# install vivaldi
yay -aS --noconfirm --needed --answerdiff=None vivaldi
sudo /opt/vivaldi/update-ffmpeg
sudo /opt/vivaldi/update-widevine
sed -i 's/chromium/vivaldi-stable/g' ~/.config/i3/config

# install visual studio code
yay -aS --noconfirm --needed --answerdiff=None visual-studio-code-bin

# enable trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/polybar-config ~/.config/polybar/config

# setup xautolock
sed -i 's/#exec --no-startup-id xautolock/exec --no-startup-id xautolock/g' ~/.config/i3/config

# fix i3exit reference in i3 config
sed -i 's/i3exit/\$HOME\/bin\/i3exit/g' ~/.config/i3/config

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

# setup xfce4-power-manager
echo "
#-------------------------------------------------------------------------
#                          xfce4-power-manager                           |
#-------------------------------------------------------------------------
exec --no-startup-id xfce4-power-manager" >> ~/.config/i3/config

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

# set screen resolution (specific to AOC 27" display)
echo "
#-------------------------------------------------------------------------
#                          set screen resolution                         |
#-------------------------------------------------------------------------
exec --no-startup-id xrandr --output DisplayPort-1 --mode 2560x1440 --rate 143.91
for_window [title="TradeSkillMaster*"] floating enable" >> ~/.config/i3/config

# setup screenshot support
mkdir -p ~/Pictures/shots
# sudo pacman -Sy --noconfirm flameshot
# echo "
# #-------------------------------------------------------------------------
# #                      flameshot (screenshot util)                       |
# #-------------------------------------------------------------------------
# exec --no-startup-id flameshot
# bindsym \$mod+Ctrl+Shift+s exec flameshot gui" >> ~/.config/i3/config

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
echo "
For natural (reverse) scrolling, add the following to /usr/share/X11/xorg.conf.d/40-libinput.conf, for the pointer InputClass section:

        Option \"NaturalScrolling\" \"True\"
"
read -p "Copy the above to the clipboard and press any key to edit the file in vim..."
sudo vim /usr/share/X11/xorg.conf.d/40-libinput.conf
echo "DONE"