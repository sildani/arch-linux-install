#!/bin/bash

# set up zsh
chsh -s /bin/zsh
cp /etc/skel/.zshrc ~/.zshrc
sudo pacman -Sy --noconfirm zsh-theme-powerlevel9k
echo "
powerline-daemon -q
source /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc

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

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/polybar-config ~/.config/polybar/config

# install software
yay -aS --noconfirm --needed --answerdiff=None vivaldi
yay -aS --noconfirm --needed --answerdiff=None visual-studio-code-bin

# enable trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# setup flameshot
# sudo pacman -Sy --noconfirm flameshot
# echo "
# #-------------------------------------------------------------------------
# #                               flameshot                                |
# #-------------------------------------------------------------------------
# exec --no-startup-id flameshot
# bindsym \$mod+Ctrl+Shift+s exec flameshot gui" >> ~/.config/i3/config

# setup xfce4-power-manager
echo "
#-------------------------------------------------------------------------
#                          xfce4-power-manager                           |
#-------------------------------------------------------------------------
exec --no-startup-id xfce4-power-manager" >> ~/.config/i3/config
echo "
Run xfce-power-manager-settings to configure sleep/stanby settings"

# setup clipboard manager
yay -aS --noconfirm --needed --answerdiff=None clipit
echo "
#-------------------------------------------------------------------------
#                           clipboard manager                            |
#-------------------------------------------------------------------------
exec --no-startup-id clipit" >> ~/.config/i3/config

# reverse mouse wheel scroll
echo "
For natural (reverse) scrolling, add the following to /usr/share/X11/xorg.conf.d/40-libinput.conf, for the pointer InputClass section:

        Option \"NaturalScrolling\" \"True\"
"
read -p "Copy the above to the clipboard and press any key to edit the file in vim..."
sudo vim /usr/share/X11/xorg.conf.d/40-libinput.conf
echo "DONE"

# custom floating window definitions
echo "
#-------------------------------------------------------------------------
#                          custom window config                          |
#-------------------------------------------------------------------------
for_window [title="TradeSkillMaster*"] floating enable
for_window [title="TSM*"] floating enable
for_window [title="run_in_term.sh"] floating enable"  >> ~/.config/i3/config

# setup xautolock
sed -i 's/#exec --no-startup-id xautolock/exec --no-startup-id xautolock/g' ~/.config/i3/config

# setup alsi on new shell
echo "
alsi -l" >> ~/.zshrc
