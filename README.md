My personal scripts for installing Arch Linux.

These are tailored made for a 16GB VM and my preferences.

After getting into Arch Live CD, install Git, clone this repo, and start running the scripts one by one. Optionally, I suggest you edit /etc/pacman.d/mirrorlist ahead of installing git to put some servers local to you up at the top. However, my scripts automatically update the mirrorlist, so this is not required for full setup.

The start of the process would look something like this:

1. vim /etc/pacman.d/mirrorlist
1. pacman -Sy git
1. git clone https://github.com/sildani/arch-linux-install.git
1. cd arch-linux-install
1. ./00-time-setup.sh
1. (... and so on)

You can optionally run ./other-scripts/openbox/stage-openbox.sh before running ./00-time-setup.sh to stage Openbox GUI instead of Xfce.
