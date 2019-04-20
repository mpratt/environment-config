#!/bin/bash
###############################################
#  Install Slackware Packages
#  Michael Pratt
###############################################
set -e
ROOTLOCATION=${1}
CURRENTLOCATION="${ROOTLOCATION}/packages/slackware"
NOTINSTALLED=()

if [[ "$(whoami)" != "root" ]]; then
    echo "On Slackware, you need to be root in order to install packages"
    exit 0
fi

# Source functions
source "${ROOTLOCATION}/functions.sh"

if [ -n "$(ls /var/log/packages/ | grep 'slackpkg+')" ] && [ -z "$(ls /var/log/packages/ | grep chromium)" ]; then
    echo "Using slackpkg/slackpkg+ to install alienbob stuff"
    slackpkg update
    slackpkg update gpg

    alienpkgs="chromium vlc2 wine libreoffice"
    for p in ${alienpkgs}; do
        slackpkg install ${p}
    done

    bash ${ROOTLOCATION}/slackware/slackbuilds/build-all.sh
else
    echo "Skipping slackpkg+ stuff"
fi

# Get all packages
LIST=$(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages.list)
if [[ "$(uname -m)" == "x86_64" ]]; then
    LIST=$(echo -e "${LIST} \n $(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages64.list)")
fi

if [[ "$(uname -m)" == "i686" ]]; then
    LIST=$(echo -e "${LIST} \n $(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages32.list)")
fi

if [ -z "$(ls /var/log/packages/ | grep sbopkg)" ]; then
    echo "Please Install sbopkg and JDK Manually"
    exit 0
fi

if [[ "$(uname -m)" != "x86_64" ]] || [ -n "$(ls /var/log/packages/ | grep compat32)" ]; then
    LIST=$(echo -e "${LIST} \n $(grep -v '^$\|^\s*\#' ${CURRENTLOCATION}/packages32.list)")
fi

echo "Running Sbopkg"
sbopkg -r

if ! [ -e "/var/lib/sbopkg/queues/mysql-workbench.sqf" ]; then
    echo "Creating Queue files and dependencies"
    if [ -e "/usr/sbin/sqg" ]; then
        /usr/sbin/sqg -a
    else
        /usr/doc/sbopkg-$(sbopkg -v)/contrib/sqg -a
    fi
fi

for pkg in ${LIST}; do
    if [ -z $(ls /var/log/packages/ | egrep -m 1 -i "^${pkg}-") ]; then
        echo "Installing ${pkg}"
        if [ -e "/var/lib/sbopkg/queues/${pkg}.sqf" ]; then
            echo "Using Queue ${pkg}.sqf"
            echo "Using Queue ${pkg}.sqf" >> "${HOME}/package-install.log"
            sleep 2
            sbopkg -B -k -e continue -i ${pkg}.sqf
        else
            NOTINSTALLED+=("${pkg}")
        fi
    else
        echo "${pkg} already installed"
    fi
done

suffix=""
for i in ${NOTINSTALLED[@]}; do
    echo "Going to install: ${i}"
    echo "Going to install: ${i}" >> "${HOME}/package-install.log"
    suffix="${suffix} -i ${i}"
done
echo "Preparing Instalation"
sleep 5

sbopkg -k -e continue ${suffix}
