#!/bin/bash

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
sudo sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sudo sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
yay -Sy --noconfirm $ali_display_driver_pkgs
