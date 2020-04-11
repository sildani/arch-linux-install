#!/bin/bash

# get the other install files
wget https://raw.githubusercontent.com/sildani/arch-linux-install/02_install_arch.sh
wget https://raw.githubusercontent.com/sildani/arch-linux-install/03_install_arch.sh

# update system clock
timedatectl set-ntp true

# partition the disk
cfdisk

# format disks
fdisk -l
echo -n "
Boot device: "
read ali_boot_dev
mkfs.fat -F32 $ali_boot_dev
echo -n "
Root device: "
read ali_root_dev
mkfs.ext4 $ali_root_dev
echo -n "
Swap device: "
read ali_swap_dev
mkswap $ali_swap_dev

# mount disks / swap
mount $ali_root_dev /mnt
mkdir /mnt/boot && mount $ali_boot_dev /mnt/boot
swapon $ali_swap_dev

# update mirrorlist
pacman -Sy --noconfirm reflector
reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# microcode setup
echo -n "
Microcode required? (amd/intel/none): "
read ali_microcode_required
case "$ali_microcode_required" in
"amd")
  read -p "Including amd-ucode in base installation packages... press enter to continue"
  ali_microcode_pkg="amd-ucode"
  ;;
"intel")
  read -p "Including intel-ucode in base installation packages... press enter to continue"
  ali_microcode_pkg="intel-ucode"
  ;;
*)
  read -p "Skipping microcode in base installation packages... press enter to continue"
  ali_microcode_pkg=""
  ;;
esac

# install essential packages
pacstrap /mnt base base-devel linux linux-firmware vim sudo networkmanager $ali_microcode_pkg

# fstab (UUID)
genfstab -U /mnt >> /mnt/etc/fstab

# stage the next files and prompt user to chroot
cp ./02_install_arch.sh /mnt
cp ./03_install_arch.sh /mnt
read -p "
Run 'arch-chroot /mnt' and then run 'sh /02_install_arch.sh' to continue installation.

Press enter to continue...
"