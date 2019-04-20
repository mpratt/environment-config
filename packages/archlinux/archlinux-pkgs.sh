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

if [[ "$(whoami)" != "root" ]]; then
    echo "On Archlinux, you need to be root in order to install packages"
    exit 0
fi

# Updating the system
${CMD} -Syu

# Install Linux LTS Kernels
${CMD} -S linux-lts
${CMD} -S linux-lts-headers

LIST=$(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages.list)
for pkg in ${LIST}; do
    echo "Installing: ${pkg}"
    ${CMD} -S --noconfirm ${pkg}
done

LIST=$(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/aur-packages.list)
for pkg in ${LIST}; do
    echo "Installing: ${pkg}"
    #${CMD} -S --noconfirm ${pkg}
done
