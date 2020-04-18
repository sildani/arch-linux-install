#!/bin/bash

# create ~/bin and add to path
mkdir -p ~/bin
echo "
export PATH=~/bin:\$PATH" >> ~/.zshrc

# add a vi shortcut that points to vim
ln -s /usr/bin/vim ~/bin/vi

# enable trim
sudo systemctl enable fstrim.timer

# add git aliases
echo "
alias gst=\"git status\"
alias gco=\"git add ./* && git commit -m\"
alias gpl=\"git pull --rebase\"
alias gps=\"git push\"
alias glo=\"git log --oneline --decorate --graph --all\"" >> ~/.zshrc

# enable multi-processor package building
sudo sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j\$(nproc)\"/" /etc/makepkg.conf

# install yay
git clone https://aur.archlinux.org/yay.git ~/.yay
cd ~/.yay
makepkg -si --noconfirm
cd ~/

# install reflector and update mirrorlist
yay -Sy --noconfirm reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install base packages
yay -Sy --noconfirm \
openssh dosfstools e2fsprogs ntfs-3g \
networkmanager man-db man-pages texinfo openssh

# install fonts
yay -Sy --noconfirm \
gnu-free-fonts terminus-font noto-fonts \
noto-fonts-emoji siji-git \
python-fontawesome

# install ttf fonts
yay -Sy --noconfirm --nopgpfetch --mflags "--skipchecksums --skippgpcheck" \
ttf-ms-fonts ttf-unifont ttf-hack ttf-carlito \
ttf-croscore ttf-caladea ttf-roboto-mono ttf-roboto \
ttf-font-awesome-4 ttf-ubuntu-font-family ttf-mac-fonts \
ttf-monaco ttf-dejavu ttf-dejavu-sans-code

# setup full-color emoji support
mkdir -p ~/.fonts
mkdir -p ~/.config/fontconfig/
cat << 'EOF' > ~/.config/fontconfig/fonts.conf
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Add emoji generic family -->
  <alias binding="strong">
    <family>emoji</family>
    <default>
      <family>Noto Color Emoji</family>
    </default>
  </alias>
  <!-- Aliases for the other emoji fonts -->
  <alias binding="strong">
    <family>Apple Color Emoji</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Segoe UI Emoji</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Noto Color Emoji</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Android Emoji</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Emojisymbols</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Emojione Mozilla</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Twemoji Mozilla</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias binding="strong">
    <family>Segoe Ui Symbol</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <!-- Do not allow any app to use Symbola, ever -->
  <selectfont>
    <rejectfont>
      <pattern>
        <patelt name="family">
          <string>Symbola</string>
        </patelt>
      </pattern>
    </rejectfont>
  </selectfont>
</fontconfig>
EOF
fc-cache -f -v

# set console font
sudo touch /etc/vconsole.conf
sudo bash -c 'echo "FONT=ter-v16n.psf.gz" >> /etc/vconsole.conf'
sudo setfont /usr/share/kbd/consolefonts/ter-v16n.psf.gz

# enable numlock on boot
yay -Sy --noconfirm systemd-numlockontty
sudo systemctl enable numLockOnTty

# install xorg
yay -Sy --noconfirm xorg-server xorg-xrandr xorg-xrdb

# install display driver
echo -n "
Specialized display driver? (amd/intel/vmware/none): "
read ali_display_driver_required
case "$ali_display_driver_required" in
"amd")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau"
  ;;
"intel")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="mesa lib32-mesa mesa xf86-video-intel vulkan-intel intel-media-driver"
  ;;
"vmware")
  read -p "Installing $ali_display_driver_required display driver... press enter to continue"
  ali_display_driver_pkgs="xf86-video-vmware"
  ;;
"nvidia")
  read -p "Installing $ali_display_driver_required display driver not supported... press enter to continue"
  ali_display_driver_pkgs=""
  ;;
*)
  read -p "Skipping specialized display driver installation ($ali_display_driver_required), will use vesa generic driver... press enter to continue"
  ali_display_driver_pkgs=""
  ;;
esac
sudo perl -0777 -i.original -pe 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
yay -Sy --noconfirm $ali_display_driver_pkgs

# install i3 window manager + supporting tools
yay -Sy --noconfirm i3-gaps i3status dmenu2 dmenu-extended-git polybar network-manager-applet

# install lightdm display manager
yay -Sy --noconfirm lightdm lightdm-settings lightdm-slick-greeter
sudo systemctl enable lightdm.service

# create user dir
yay -Sy --noconfirm xdg-user-dirs
xdg-user-dirs-update

# install sound support
yay -Sy --noconfirm alsa-utils pulseaudio pulseaudio-alsa pavucontrol
sudo sed -i 's/^volume = merge/volume = off/g' /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common

# install bluetooth support
yay -Sy --noconfirm bluez bluez-utils blueman pulseaudio-bluetooth
sudo systemctl enable bluetooth.service

# ensure bluetooth is enabled at boot
sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf

# configure to support xbox one bluetooth wireless controller
yay -Sy --noconfirm linux-headers
yay -Sy --noconfirm xpadneo-dkms-git
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet logo.nologo acpi_osi=Linux video.use_native_backlight=1 audit=0 bluetooth.disable_ertm=1"/g' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# desktop notifications
yay -Sy --noconfirm dunst

# install terminal
yay -Sy --noconfirm kitty

# setup powerlevel10k zsh theme
sed -i 's/ZSH_THEME="robbyrussell"/# ZSH_THEME="robbyrussell"/g' ~/.zshrc
yay -Sy --noconfirm zsh-theme-powerlevel10k
echo "
# powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=()" >> ~/.zshrc

# install htop
yay -Sy --noconfirm htop

# install rsync
yay -Sy --noconfirm rsync

# install file browser + basic file manager services
yay -Sy --noconfirm thunar gvfs

# install web browser
yay -Sy --noconfirm vivaldi
sudo /opt/vivaldi/update-ffmpeg

# install text editor
yay -Sy --noconfirm visual-studio-code-bin

# install printer support
yay -Sy --noconfirm cups

# install pacman contrib (contains utlities like checkupdates)
yay -Sy --noconfirm pacman-contrib

# install clipit
yay -Sy --noconfirm clipit

# install desktop wallpaper support
yay -Sy --noconfirm feh \
archlinux-wallpaper elementary-wallpapers-git \
deepin-wallpapers deepin-community-wallpapers

# install screen locker
yay -Sy --noconfirm betterlockscreen

# install autolocker
yay -Sy --noconfirm xautolock

# install screen shot taker
yay -Sy --noconfirm flameshot

# install ui themer
yay -Sy --noconfirm lxappearance-gtk3

# install starter ui themes
yay -Sy --noconfirm \
breeze-gtk breeze-icons \
arc-gtk-theme arc-icon-theme \
deepin-gtk-theme deepin-icon-theme \
qogir-gtk-theme-git qogir-icon-theme-git \
gnome-icon-theme

# install polkit
yay -Sy --noconfirm \
polkit polkit-qt5 polkit-gnome gnome-keyring

# install compton (compositor)
yay -Sy --noconfirm compton

# install dunst (notiications)
yay -Sy --noconfirm dunst

# install pamac
yay -Sy --noconfirm pamac

# install pkgfile (for querying package metadata, to find which package a command belongs to)
yay -Sy --noconfirm pkgfile

# install file roller (file archive gui)
yay -Sy --noconfirm file-roller

# install nomacs (image viewer)
yay -Sy --noconfirm nomacs

# setup alsi on new zsh shell
yay -Sy --noconfirm alsi
echo "
# print sys info on new term
alsi -l" >> ~/.zshrc

# install gaming apps / support
yay -Sy --noconfirm --needed \
wine wine-mono wine-gecko giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap \
gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils \
libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins \
alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite \
lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses \
lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva \
gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader \
lib32-vulkan-icd-loader lib32-mesa vulkan-radeon lib32-vulkan-radeon lutris steam

# install other software I like to use
yay -Sy --noconfirm \
obs-studio gimp zoom wowmatrix transmission-gtk virtualbox teams termdown

# create hint file for reversing mouse scrolling
echo "For natural (reverse) scrolling, add the following to /usr/share/X11/xorg.conf.d/40-libinput.conf (requires sudo), for the pointer/touchpad InputClass section:

Option \"NaturalScrolling\" \"True\"
" > ~/reverse_scrolling.txt
read -p "
For natural (reverse) scrolling, please see ~/reverse_scrolling.txt for more information. Press any key to continue.
"

# create trash dir
mkdir -p ~/.local/share/Trash/files

# ssh config
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo sed -i 's/#AddressFamily any/AddressFamily any/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
sudo sed -i 's/#ListenAddress ::/ListenAddress ::/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl enable sshd

# seed default dotfiles and other resources for this install
git clone https://github.com/sildani/arch-linux-install ~/.arch_linux_install
cp ~/.arch_linux_install/resources/alsa/set_default_sound_settings.sh ~/bin/
cp ~/.arch_linux_install/resources/betterlockscreen/betterlockscreen_update_bg.sh ~/bin/
cp -R ~/.arch_linux_install/dotfiles/.vimrc ~/
cp -R ~/.arch_linux_install/dotfiles/.vscode ~/
cp -R ~/.arch_linux_install/dotfiles/.config/i3 ~/.config/
cp -R ~/.arch_linux_install/dotfiles/.config/polybar ~/.config/
cp -R ~/.arch_linux_install/dotfiles/.config/kitty ~/.config/
cp -R ~/.arch_linux_install/dotfiles/.config/dunst ~/.config/
cp -R ~/.arch_linux_install/dotfiles/.config/dmenu-extended ~/.config/
cp -R ~/.arch_linux_install/dotfiles/.config/compton.conf ~/.config/
sudo cp -R ~/.arch_linux_install/resources/wallpaper /usr/share/backgrounds/daniel
sudo cp -R ~/.arch_linux_install/resources/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp -R ~/.arch_linux_install/resources/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf

# prompt to set video mode
xrandr
echo -n "
Set xrandr in i3 config?

Example: --output DisplayPort-1 --mode 2560x1440 --rate 120.00

Hit enter to skip
> "
read ali_xrandr_command
case "$ali_xrandr_command" in
"")
  echo ""
  ;;
*)
  read -p "Adding \`xrandr $ali_xrandr_command\` to i3 config... press enter to continue"
  echo "
# video setup
exec_always --no-startup-id xrandr $ali_xrandr_command
" >> ~/.config/i3/config
  ;;
esac

# cue next step
echo "
Installation complete. Exit this shell, then exit chroot, then reboot.

Enjoy! :)

"

# clean up files
sudo rm /02_install_arch.sh /03_install_arch.sh