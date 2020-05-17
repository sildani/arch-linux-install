#!/bin/bash

# get user inputs
echo "
Gathering user input for script...
"
ali_username=`whoami`
echo -n "
What would you like your computer hostname to be? "
read ali_hostname
read -p "
Here are your inputs...

username=$ali_username
hostname=$ali_hostname

Press enter to continue, or Ctrl-C to exit and try again. (If you have not updated your system yet, Ctrl-C out and do that first.)
"

# change host name
sudo hostnamectl set-hostname $ali_hostname

# setup zsh and powerlevel10k
sudo apt install zsh
sudo chsh --shell /bin/zsh $ali_username
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$ali_username/.oh-my-zsh
cp /home/$ali_username/.oh-my-zsh/templates/zshrc.zsh-template /home/$ali_username/.zshrc
sudo mkdir /usr/share/fonts/truetype/meslolgs-nf
sudo cp ~/.arch_linux_install/resources/fonts/MesloLGS\ NF\ * /usr/share/fonts/truetype/meslolgs-nf/
fc-cache -f -v
sed -i 's/ZSH_THEME="robbyrussell"/# ZSH_THEME="robbyrussell"/g' ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
echo "
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

# git aliases
echo "
# git aliases
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# configure pulse audio
mkdir ~/.config/pulse
sudo cp /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common.orig
sudo sed -i 's/^volume = merge/volume = off/g' /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common
echo "
amixer -c \`aplay -l | grep USB2.0 | head -1 | cut -b 5-6\` set PCM 80%" >> ~/.profile
sudo apt install pavucontrol

# vim
sudo apt install vim

# termdown
sudo apt install python3-pip
pip3 install termdown
echo "
# add pip3 installed package path to \$PATH
PATH=\$PATH:~/.local/bin" >> ~/.zshrc

# add custom scripts to /usr/local/bin
git clone https://github.com/sildani/scripts ~/.scripts
ali_script_dir_listing=`ls ~/.scripts/linux`
ali_scripts=( $ali_script_dir_listing )
for ali_script in ${ali_scripts[*]}; do
    ali_target=`echo "$ali_script" | cut -d'.' -f 1`
    sudo ln -s ~/.scripts/linux/$ali_script /usr/local/bin/$ali_target
done
sudo git clone https://github.com/andreafabrizi/Dropbox-Uploader /usr/local/share/dropbox_uploader_git
sudo ln -s /usr/local/share/dropbox_uploader_git/dropbox_uploader.sh /usr/local/bin/dropbox_uploader

# wallpapers
sudo cp -R ~/.arch_linux_install/resources/wallpaper/* /usr/share/backgrounds/

# restore desktop environment config (dconf)
dconf load /org/gnome/ < ~/.arch_linux_install/resources/os/pop_os/gnome_settings

# add neofetch to new terminal windows
sudo apt install neofetch
mkdir ~/.config/neofetch
cp ~/.arch_linux_install/resources/dotfiles/.config/neofetch/config.conf ~/.config/neofetch/config.conf
echo "
# print sys info on new term
neofetch" >> ~/.zshrc

# install printer support
sudo apt install hplip

# enable sshd
sudo apt install openssh-server
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo sed -i 's/#AddressFamily any/AddressFamily any/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress ::/ListenAddress ::/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# cue next steps to be done manually / optionally
cat << 'EOF' > ~/apps_to_install.md
## Apps to install via Pop!_Shop

- Gnome Tweaks
- Visual Studio Code
- Lutris
- Steam
- [Clipboard Indicator](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator)

## Other things to install

- [Vivaldi](https://vivaldi.com/download/)
EOF

echo "
Check ~/apps_to_install.md for some next steps not yet automated.

Done!
"
