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
bindsym \$mod+z exec --no-startup-id morc_menu" >> ~/.config/i3/config
mkdir -p ~/.config/morc_menu
cp ~/code/arch-linux-install/other-os/salient-os/resources/morc_menu_v1.conf ~/.config/morc_menu/

# setup polybar
cp ~/code/arch-linux-install/other-os/salient-os/resources/polybar-config ~/config/polybar/config

# setup alsi on new shell
echo "alsi -l" >> ~/.zshrc
