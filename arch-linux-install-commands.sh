##############################################
# assumes booting into Live Arch Linux ISO
##############################################

# connect to network, if necessary
ip link
ip link set enp0s3 up
ping google.com

# ensure synchornization with time
timedatectl set-ntp true
timedatectl status

# partition disk where Arch Linux is being installed
fdisk -l
parted /dev/sda 

##############################################
# now you're in parted
##############################################

# commands here are for a 16GB VirtualBox virtual disk
mklabel gpt
unit s
p free
mkpart primary fat32 2048s 1050623s
mkpart primary ext4 1050624s 29358079s
mkpart primary linux-swap 29358080s 33554398s
set 1 bios_grub on
quit

##############################################
# now you're back in the shell
##############################################

# format partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# verify partioning and formatting
lsblk

# edit mirror list to move US mirrors to top of list
vim /etc/pacman.d/mirrorlist

# install Arch Linux onto disk + other base packages
pacstrap /mnt base linux linux-firmware vim amd-ucode

# generate file system table on new disk, and chroot into the root of the new install
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

##############################################
# now you're in the new file system
##############################################

# set the timezone
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

# generate locale; look for and uncomment en_US.UTF8 UTF8 in locale.gen
vim /etc/locale.gen
locale-gen

# define LANG env variable (LANG=en_US.UTF-8) in locale.conf
vim /etc/locale.conf

# define hostname
vim /etc/hostname

# bootstrap /etc/hosts - replace 127.0.0.1 with static IP if machine has one, replace $HOSTNAME with actual hostname as defined in /etc/hostname
# 127.0.0.1	localhost
# ::1		localhost
# 127.0.1.1	$HOSTNAME.localdomain $HOSTNAME
vim /etc/hosts

# set root password
passwd

# setup grub
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# install other supporting programs
pacman -S dosfstools e2fsprogs ntfs-3g networkmanager zsh sudo man-db man-pages texinfo

# create user account
useradd -m -s /bin/zsh daniel

# set user password
passwd daniel

# add daniel ALL=(ALL) ALL to sudoers file
EDITOR=vim visudo

# get a copy of the commands run for future review and exit chroot
history >> /root/install-cmds-chroot
exit

##############################################
# now you're back in the shell
##############################################

# get a copy of the commands run for future review, un-mount disk, and reboot
history >> /mnt/root/install-cmds-root
umount -R /mnt
reboot

##############################################
# Now log in as your new shiny sudo user and
# finish setting up your user. The key
# things to do:
#
# 0. Set up the network
# 1. Update pacman mirrorlist
# 2. Set up the GUI
# 3. Install desktop apps
#    a. Chrome browser
#    b. Code text editor
#    c. Tilix terminal emulator
# 4. Set up oh-my-zsh
# 
# When you first log in, you will be prompted
# to set up zsh - ignore that, because you
# will set up oh-my-zsh as part of the
# initial config
##############################################

# setup the network
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
ping google.com

# install base devel, git, and update the mirrorlist
sudo pacman -S base-devel git reflector
sudo reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# install X, Xfce desktop environment, lightdm display manager, xdg user dirs
sudo pacman -S xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xdg-user-dirs

# install suitable driver
# list the devices then query packages for the right package
lspci | grep -e VGA -e 3D
pacman -Ss xf86-video
sudo pacman -S xf86-video-vmware

# enable lightdm service
systemctl enable lightdm.service

# create common user directories
xdg-user-dirs-update

# install Chrome AUR
# makepkg.conf edit:
#     un-comment MAKEFLAGS="-j2" and change the '2' to the number of processors you have
sudo vim /etc/makepkg.conf
mkdir ~/AUR && cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git 
cd google-chrome
makepkg -si

# install Code text editor and Tilix terminal emulator
sudo pacman -S code tilix

# setup oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# reboot
reboot

##############################################
# From here on out, you can set up your
# system however you want it.
#
# Some things I like to install / configure:
# 
# - Look and feel
#   (desktop, taskbar, launcher, themes, fonts)
# - ACPI event controls
# - Sound
# - Bluetooth
# - Gaming support (Wine, 3D Drivers, Lutris)
# - Emoji font
# - Clipboard manager
# - My own scripts in ~/bin
#   (e.g., mount an NTFS drive)
##############################################