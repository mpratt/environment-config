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

echo "Linking Archlinux Stuff"
symlinkIt ${ROOTLOCATION}/distros/archlinux ~/.archlinux
symlinkIt ${ROOTLOCATION}/distros/archlinux/archlinux.sh ~/.archlinux.sh
echo ""

if [[ $(whoami) == "root" ]]; then
    if ! id -u pratt > /dev/null 2>&1; then
        useradd -m -s /bin/bash pratt
        echo "Password for Pratt:"
        passwd pratt
    fi
fi
