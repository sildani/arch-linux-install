#!/bin/bash

# install core packages
sudo apt install vim code i3 zsh nitrogen dunst pasystray lxappearance

# install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/daniel/.oh-my-zsh
cp /home/daniel/.oh-my-zsh/templates/zshrc.zsh-template /home/daniel/.zshrc
echo "
ZSH_THEME=\"dallas\"

if [ \`tput colors\` = \"256\" ]; then  
  ZSH_THEME=\"robbyrussell\"  
fi

source \$ZSH/oh-my-zsh.sh" >> /home/daniel/.zshrc
chown -R daniel:daniel /home/daniel/.oh-my-zsh
chown daniel:daniel /home/daniel/.zshrc
chsh -s /bin/zsh

# setup terminal
# TODO

# desktop wallpaper manager (nitrogen)
sudo cp -R resources/wallpaper /usr/share/backgrounds/daniel
mkdir -p ~/.config/nitrogen
cp resources/i3/bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
cp resources/i3/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# setup i3status
mkdir -p ~/.config/i3status
cp resources/i3/i3status.conf ~/.config/i3status/config

# setup dunst
mkdir -p ~/.config/dunst
cp resources/i3/dunstrc ~/.config/dunst

# setup i3
mkdir -p ~/.config/i3
cp resources/i3/config ~/.config/i3/config

# reboot
reboot