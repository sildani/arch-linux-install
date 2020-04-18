#!/bin/bash

# Adds my custom scripts to my machine

ali_current_user=`whoami`
ali_current_user_bin="/home/$ali_current_user/bin"
ali_base_scripts_dir="/home/$ali_current_user/.scripts"
ali_scripts_dir="$ali_base_scripts_dir/linux"

git clone https://github.com/sildani/scripts $ali_base_scripts_dir

ali_script_dir_listing=`ls $ali_scripts_dir`
ali_scripts=( $ali_script_dir_listing )

for ali_script in ${ali_scripts[*]}; do
    ali_target=`echo "$ali_script" | cut -d'.' -f 1`
    ln -s $ali_scripts_dir/$ali_script $ali_current_user_bin/$ali_target
done

sudo git clone https://github.com/andreafabrizi/Dropbox-Uploader /usr/share/dropbox_uploader_git
sudo ln -s /usr/share/dropbox_uploader_git/dropbox_uploader.sh /usr/local/bin/dropbox_uploader
