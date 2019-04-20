#!/bin/bash
#
# Build everything we need for linux
CWD=$(dirname $0)
SLACKBUILDS=( 'grub-customizer/grub-customizer.SlackBuild' )

[[ "$(whoami)" != "root" ]] && echo "You need to be root in order to run this script" && exit 1
for package in ${SLACKBUILDS[@]}; do
    pkg=$(basename ${package} | sed 's/\.SlackBuild//g')
    ! [ -d "${CWD}/$(dirname ${package})" ] && echo "${CWD}/$(dirname ${package}) not found" && continue
    if [ -z $(ls /var/log/packages/ | egrep -m 1 -i "^${pkg}-") ]; then
        cd ${CWD}/$(dirname ${package})
        echo "Building ${pkg}"
        bash $(basename ${package})
        upgradepkg --install-new /tmp/${pkg}*.t?z
    else
        echo "${pkg} already installed"
    fi
done
