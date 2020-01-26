#!/bin/bash
###############################################
#  Install Archlinux Packages
#  Michael Pratt
###############################################
set -e
ROOTLOCATION=${1}
CURRENTLOCATION="${ROOTLOCATION}/packages/archlinux"
NOTINSTALLED=()
CMD="pacman"

if [[ "$(whoami)" == "root" ]]; then
    # Updating the system
    ${CMD} -Syu

    # Install Git
    ${CMD} -S --noconfirm git

    # Install Linux Zen Kernels
    ${CMD} -S linux-zen
    ${CMD} -S linux-zen-headers

    # Install Linux LTS Kernels
    ${CMD} -S linux-lts
    ${CMD} -S linux-lts-headers

    # Install Linux Nvidia Drivers
    ${CMD} -S --no-confirm nvidia-dkms
    ${CMD} -S --no-confirm nvidia-settings
    ${CMD} -S --no-confirm nvidia-utils

    LIST=$(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages.list)
    for pkg in ${LIST}; do
        echo "Installing: ${pkg}"
        ${CMD} -S --noconfirm --needed ${pkg}
        echo ""
        echo ""
    done
fi


# Install Yay
if ! [ -e "/usr/bin/yay" ]; then
    git clone https://aur.archlinux.org/yay.git ~/yay-tmp
    cd ~/yay-tmp
    makepkg -si
fi

LIST=$(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/aur-packages.list)
for pkg in ${LIST}; do
    echo "Installing: ${pkg}"
    yay -S  --noconfirm ${pkg}
    echo ""
    echo ""
done
