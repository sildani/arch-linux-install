#!/bin/bash

cd ~/arch-linux-install && git pull --rebase && cd
cp ~/arch-linux-install/resources/* ~/
#sed 's/amdgpu/vmware/' ~/arch-linux-install/office-3950X/06-openbox-setup.sh > ~/bin/06-openbox-setup.sh
cp ~/arch-linux-install/06-openbox-setup.sh ~/bin/06-openbox-setup.sh
chmod +x ~/bin/06-openbox-setup.sh
