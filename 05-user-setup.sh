#!/bin/bash

# setup the network
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
#ping google.com

# install fonts, set console font
sudo pacman -S gnu-free-fonts terminus-font noto-fonts-emoji
sudo touch /etc/vconsole.conf
sudo bash -c 'echo "FONT=ter-v16n.psf.gz" >> /etc/vconsole.conf'
setfont /usr/share/kbd/consolefonts/ter-v16n.psf.gz

# setup ntp
timedatectl set-ntp true
timedatectl status

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
. ~/.zshrc
echo "
ZSH_THEME=\"daveverwer\"

if [ \`tput colors\` = \"256\" ]; then  
  ZSH_THEME=\"robbyrussell\"  
fi" >> ~/.zshrc

# add bin to path
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# add one final sourcing of zshrc
echo "
source \$ZSH/oh-my-zsh.sh" >> ~/.zshrc

# install base devel and update the mirrorlist
sudo pacman -S base-devel reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# remove 05 script to leave a clean userspace
rm ~/05-user-setup.sh