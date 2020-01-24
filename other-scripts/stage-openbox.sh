#!/bin/bash

cd ~/arch-linux-install && git pull --rebase && cd
cp -R ~/arch-linux-install/resources/* ~/
mv ~/06-ui-setup.sh ~/06-ui-setup.sh.orig
cp ~/arch-linux-install/other-scripts/06-openbox-setup.sh ~/06-ui-setup.sh
