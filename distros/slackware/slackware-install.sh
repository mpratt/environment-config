#!/bin/bash
##################################################################
#  Install slackware stuff
#  Michael Pratt
##################################################################
set -e
ROOTLOCATION=${1}
CURRENTLOCATION="${ROOTLOCATION}/distros/slackware"
MAXRES=$(xrandr --current | egrep -o 'current [^,]+' | sed 's/current//g' | tr -d [:blank:] | sed 's/x/:/g')

# Source functions
echo "Slackware Detected - Sourcing functions"
source "${ROOTLOCATION}/functions.sh"

if [ -w "/etc/inetd.conf" ]; then
    echo "Comment all inetd.conf services"
    sed -i 's/^#//g;s/^/#/g' /etc/inetd.conf
    echo ""
fi


if [ -w "/etc/kde/kdm/Xsetup" ]; then
    if [ -z "$(grep -o 'xrandr' '/etc/kde/kdm/Xsetup')" ]; then
        echo "Adding dual monitor initialization scripts to kdm"
        cat ${ROOTLOCATION}/config/dual-monitors/dual-monitors | egrep -v '^#' >> /etc/kde/kdm/Xsetup
        echo ""
    fi
fi

if [ -z "$(egrep -i '^ ?All' /etc/hosts.deny)" ] && [ -w "/etc/hosts.deny" ]; then
    echo "Closing hosts.deny"
    sed -i 's/^#//g;s/^/#/g' /etc/hosts.deny
    sed -i "\$i All: All"  /etc/hosts.deny
fi

LINES=( 'sshd:192.168.0.,192.168.1.,10.42.0.,127.0.0.1' 'httpd:127.0.0.1' )
for l in ${LINES[@]}; do
    if [ -z $(grep -i ${l} /etc/hosts.allow) ] && [ -w "/etc/hosts.allow" ]; then
        echo "Adding line ${l} to /etc/hosts.allow"
        sed -i "\$i ${l}"  /etc/hosts.allow
    fi
done

echo "Linking Slackware Stuff"
symlinkIt ${ROOTLOCATION}/distros/slackware ~/.slackware
symlinkIt ${ROOTLOCATION}/distros/slackware/slackware.sh ~/.slackware.sh
echo ""

if [ -w "/etc/rc.d/" ]; then
    echo "Copying scripts to /etc/rc.d/"
    copyIt ${CURRENTLOCATION}/config/rc.firewall /etc/rc.d/rc.firewall
    copyIt ${CURRENTLOCATION}/config/rc.local /etc/rc.d/rc.local
    copyIt ${CURRENTLOCATION}/config/rc.local_shutdown /etc/rc.d/rc.local_shutdown
    echo ""

    if [ -z "$(grep -i 'bootsplash' /etc/rc.d/rc.S)" ]; then
        echo "Applying Bootsplash patch"

        cd /etc/rc.d/
        cat ${CURRENTLOCATION}/config/bootsplash.patch | sed 's/{SCALE}/'${MAXRES}'/g' > /etc/rc.d/bootsplash.patch
        patch -p1 -N < bootsplash.patch
        rm -rf /etc/rc.d/bootsplash.patch
        mkdir -p /boot/video
        echo ""
    fi
fi

if [[ $(whoami) == "root" ]]; then

    if ! grep ^vboxusers: /etc/group 2>&1 > /dev/null; then
        echo "Creating vboxusers group!"
        groupadd -g 215 vboxusers
        echo ""
    fi

    if ! grep ^docker: /etc/group 2>&1 > /dev/null; then
        echo "Creating docker group!"
        groupadd -r -g 281 docker
        echo ""
    fi

    if ! grep ^mongo: /etc/group 2>&1 > /dev/null; then
        echo "Creating mongodb group!"
        groupadd -g 285 mongo
        useradd -u 285 -d /var/lib/mongodb -s /bin/false -g mongo mongo
        echo ""
    fi

    if ! grep ^couchdb: /etc/group 2>&1 > /dev/null; then
        echo "Creating couchdb group!"
        groupadd -g 231 couchdb
        useradd -u 231 -g couchdb -d /var/lib/couchdb -s /bin/sh couchdb
        echo ""
    fi
fi
