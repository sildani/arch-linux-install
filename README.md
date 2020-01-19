My personal scripts for installing Arch Linux.

These are tailored made for a 16GB VM and my preferences.

After getting into Arch Live CD, install Git, clone this repo, and start running the scripts one by one. It would look something like this:

pacman -Sy git
git clone https://github.com/sildani/arch-linux-install.git
cd arch-linux-install
./00-time-setup.sh

I suggest you edit /etc/pacman.d/mirrorlist to put some servers local to you up at the top. However, my scripts automatically update the mirrorlist, so this is not required for full setup.