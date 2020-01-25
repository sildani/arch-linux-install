#!/bin/bash

# setup the network
sudo systemctl start NetworkManager.service
sudo systemctl enable NetworkManager.service

# setup ntp
sudo timedatectl set-ntp true
timedatectl status

# add a vi shortcut that points to vim
ln -s /usr/bin/vim ~/bin/vi

# add bin to path
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# install base devel and update the mirrorlist
sudo pacman -Sy --noconfirm base-devel reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install yay
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~/

# remove 05 script to leave a clean userspace
rm ~/05-setup-user-account.sh