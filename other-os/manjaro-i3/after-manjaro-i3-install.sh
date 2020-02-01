#!/bin/bash

# setup mirrors and update system
sudo pacman-mirrors --country United_States && sudo pacman -Syyu

# packages
sudo pacman -Sy --needed --noconfirm base-devel nitrogen bluez bluez-utils blueman i3lock tilix

# setup bluetooth
sudo systemctl enable bluetooth.service

# enable trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/daniel/.oh-my-zsh
cp /home/daniel/.oh-my-zsh/templates/zshrc.zsh-template /home/daniel/.zshrc
sed -i 's/source \$ZSH\/oh-my-zsh.sh//' /home/daniel/.zshrc
echo "
ZSH_THEME=\"dallas\"

if [ \`tput colors\` = \"256\" ]; then  
  ZSH_THEME=\"robbyrussell\"  
fi

source \$ZSH/oh-my-zsh.sh" >> /home/daniel/.zshrc
chsh -s /bin/zsh

# add bin to path
mkdir -p ~/bin
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# setup tilix terminal
echo "
if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi" >> ~/.zshrc
dconf write /com/gexperts/Tilix/terminal-title-show-when-single false
dconf write /com/gexperts/Tilix/terminal-title-style "'small'"
dconf write /com/gexperts/Tilix/theme-variant "'dark'"
dconf write /com/gexperts/Tilix/window-style "'borderless'"

# install yay
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~/

# install chrome
yay -aS --noconfirm --needed --answerdiff=None google-chrome

# install visual studio code
yay -aS --noconfirm --needed --answerdiff=None visual-studio-code-bin

# clone my arch-linux-install repo
mkdir -p ~/code
git clone https://github.com/sildani/arch-linux-install ~/code/arch-linux-install

# desktop wallpaper manager (nitrogen)
sudo cp -R ~/code/arch-linux-install/resources/wallpaper /usr/share/backgrounds/daniel
mkdir -p ~/.config/nitrogen
cp ~/code/arch-linux-install/resources/i3/bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
cp ~/code/arch-linux-install/resources/i3/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg

# setup conky
sudo cp /usr/bin/start_conky_maia ~/bin/
sudo chown daniel:daniel ~/bin/start_conky_maia
mkdir -p ~/.conky
sudo cp /usr/share/conky/conky_maia ~/.conky/
sudo cp /usr/share/conky/conky1.10_shortcuts_maia ~/.conky/
sudo chown daniel:daniel ~/.conky/*
sed -i 's/\/usr\/share\/conky/~\/.conky/g' ~/bin/start_conky_maia
sed -i 's/gap_y = 13/gap_y = 50/g' ~/.conky/conky_maia

# setup i3
sed -i 's/palemoon/google-chrome-stable/g' ~/.i3/config
sed -i 's/\# exec --no-startup-id blueman-applet/exec --no-startup-id blueman-applet/g' ~/.i3/config
sed -i 's/position bottom/position top/g' ~/.i3/config
sed -i 's/bindsym \$mod+Return exec terminal/bindsym \$mod+Return exec i3-sensible-terminal/g' ~/.i3/config
sed -i 's/start_conky_maia/~\/bin\/start_conky_maia/g' ~/.i3/config
sed -i 's/Pale Moon.desktop/google-chome.desktop/g' ~/.config/mimeapps.list
sed -i 's/palemoon/google-chrome-stable/g' ~/.profile
echo "export TERMINAL=/usr/bin/tilix" >> ~/.profile

# setup i3status
cp ~/code/arch-linux-install/other-os/manjaro-i3/resources/i3status.conf ~/.i3status.conf
