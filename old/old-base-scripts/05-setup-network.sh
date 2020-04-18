#!/bin/bash

# setup the network
sudo systemctl start NetworkManager.service
sudo systemctl enable NetworkManager.service

# clean up
rm ~/05-setup-network.sh

# prompt user to check network
echo "#######################################
#                                     #
#  Network enabled. Please check the  #
#  network is up by using \`ip\` or     #
#  \`ping\` command prior to running    #
#  the next script.                   #
#                                     #
#######################################"