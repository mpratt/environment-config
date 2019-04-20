#!/bin/bash
##################################################################
#  Install Archlinux stuff
#  Michael Pratt
##################################################################
set -e
ROOTLOCATION=${1}
CURRENTLOCATION="${ROOTLOCATION}/distros/archlinux"

# Source functions
echo "Archlinux Detected - Sourcing functions"
source "${ROOTLOCATION}/functions.sh"

echo "Enable System Services"
if [[ $(whoami) == "root" ]]; then
    echo "Enable Login Daemon LXDM"
    systemctl enable lxdm.service

    echo "Enable Network Manager Service"
    systemctl enable NetworkManager.service

    echo "Enable Firewall Service"
    systemctl enable ufw.service
fi
