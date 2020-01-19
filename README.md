My personal scripts for installing Arch Linux.

These are tailored made for a 16GB VM and my preferences.

After getting into Arch Live CD, install Git, clone this repo, and start running the scripts one by one. Optionally, I suggest you edit /etc/pacman.d/mirrorlist ahead of installing git to put some servers local to you up at the top. However, my scripts automatically update the mirrorlist, so this is not required for full setup.

The start of the process would look something like this:

vim /etc/pacman.d/mirrorlist
pacman -Sy git
git clone https://github.com/sildani/arch-linux-install.git
cd arch-linux-install
./00-time-setup.sh

