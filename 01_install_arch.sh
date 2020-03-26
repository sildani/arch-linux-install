#!/bin/bash

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
pacman -Sy reflector
reflector --country "United States" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# microcode setup
echo -n "
Microcode required? (amd/intel/none): "
read ali_microcode_required
case "$ali_microcode_required" in
"amd")
  echo "Including amd-ucode in installation packages"
  ali_microcode_pkg="amd-ucode"
  ;;
"intel")
  echo "Including intel-ucode in installation packages"
  ali_microcode_pkg="intel-ucode"
  ;;
*)
  ali_microcode_pkg=""
  ;;
esac

# install essential packages
pacstrap /mnt base linux linux-firmware vim sudo $ali_microcode_pkg

# fstab (UUID)
genfstab -U /mnt >> /mnt/etc/fstab

# stage the second file and prompt user to chroot
cp ./02_install_arch.sh /mnt
read -p "
Run 'arch-chroot /mnt' now and run 02_install_arch.sh to continue installation.

Press enter to continue...
"