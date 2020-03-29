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

# install blueman (bluetooth gui)
yay -S --noconfirm --needed blueman

# ensure bluetooth is enabled at boot
sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf

# configure to support xbox one wireless controller
yay -aS --noconfirm --needed --answerdiff=None linux-headers
yay -aS --noconfirm --needed --answerdiff=None xpadneo-dkms-git
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet logo.nologo acpi_osi=Linux video.use_native_backlight=1 audit=0"/GRUB_CMDLINE_LINUX_DEFAULT="quiet logo.nologo acpi_osi=Linux video.use_native_backlight=1 audit=0 bluetooth.disable_ertm=1"/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# install emoji font
sudo pacman -S --noconfirm noto-fonts-emoji
sudo cp ~/code/arch-linux-install/other-os/salient-os/resources/fonts-local.conf /etc/fonts/local.conf

# enable trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# setup xautolock
sed -i 's/#exec --no-startup-id xautolock/exec --no-startup-id xautolock/g' ~/.config/i3/config

# fix keyboard rate entry
sed -i 's/exec xset r rate 300 30/exec --no-startup-id xset r rate 300 30/g' ~/.config/i3/config

# fix i3exit reference in i3 config
sed -i 's/i3exit/\$HOME\/bin\/i3exit/g' ~/.config/i3/config

# fix pulse audio entries
sed -i 's/exec --no-startup-id pulseaudio --start/exec --no-startup-id start-pulseaudio-x11/g' ~/.config/i3/config
sudo sed -i 's/^volume = merge/volume = off/g' /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common

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

# setup powerlevel10k zsh theme
sed -i 's/ZSH_THEME="robbyrussell"/# ZSH_THEME="robbyrussell"/g' ~/.zshrc
sudo pacman -Sy --noconfirm zsh-theme-powerlevel10k
echo "
# powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
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

# ssh config
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo sed -i 's/#AddressFamily any/AddressFamily any/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress ::/ListenAddress ::/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl enable sshd
sudo systemctl start sshd