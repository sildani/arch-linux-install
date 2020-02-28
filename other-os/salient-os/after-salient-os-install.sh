#!/bin/bash

# set up zsh
chsh -s /bin/zsh
cp /etc/skel/.zshrc ~/.zshrc
sudo pacman -Sy zsh-theme-powerlevel9k
echo "
powerline-daemon -q
source /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc
