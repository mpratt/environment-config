#!/bin/bash
##################################################################
#  This scripts bootstraps all the installation routine
#  Michael Pratt <pratt@hablarmierda.net>
##################################################################
set -e
LOCATION=$(realpath $(dirname $0))

##################################################################
# The logic
##################################################################
mkdir -p ~/.bin/
if [ -w "/etc/fstab" ] &&  [ -z "$(grep -i '64e868cc-05f2-4096-a321-d5af6b36eb8b' /etc/fstab)" ]; then
    [ -w "/mnt" ] && mkdir -p /mnt/storage && mkdir -p /mnt/share && mkdir -p /mnt/windows
    echo "Adding External Mount Points to /etc/fstab"
    cat ${LOCATION}/config/fstab/fstab >> /etc/fstab
    echo ""
fi

[ ! -e "${HOME}/.ssh/config" ] && mkdir -p ${HOME}/.ssh/ && touch ${HOME}/.ssh/config
if [ -z "$(grep -i -o 'ServerAliveInterval 60' ${HOME}/.ssh/config)" ]; then
    echo "Adding General ssh config into ${HOME}/.ssh/config"
    cat ${LOCATION}/config/ssh/main >> ${HOME}/.ssh/config
fi

HOSTNAMEFILE="/etc/HOSTNAME"
if [ -e "/etc/hostname" ]; then
    HOSTNAMEFILE="/etc/hostname"
fi

HOSTS=( 'adrastea' 'pasiphae' 'amalthea' )
for h in ${HOSTS[@]}; do
    if [ -z $(grep -i -o ${h} ${HOME}/.ssh/config) ]; then
        echo "Adding ssh host info from ${h} to ${HOME}/.ssh/config"
        cat ${LOCATION}/config/ssh/${h} >> ${HOME}/.ssh/config
    else
        echo "${h} already in ${HOME}/.ssh/config"
    fi

    if [ -z "$(grep -i -o ${h} /etc/hosts)" ] && [ -w "/etc/hosts" ]; then
        echo "Adding ${h} to /etc/hosts"
        line=$(cat ${LOCATION}/config/hosts/${h})
        sed -i "\$i ${line}"  /etc/hosts
    fi

    if [ -n "$(grep -i -o ${h} ${HOSTNAMEFILE})" ]; then

        # Pasiphae Settings only
        if [[ "${h}" == "pasiphae" ]]; then
            if [ -w "/etc/udev/rules.d/" ]; then
                echo "Adding Touchpad udev rules (disable when mouse is connected)"
                cat ${LOCATION}/config/udev/01-touchpad.rules > /etc/udev/rules.d/01-touchpad.rules
                echo ""
            fi

            if [ -w "/etc/X11/xorg.conf.d/" ]; then
                echo "Adding Touchpad configuration options to X11"
                cat ${LOCATION}/config/X11/60-synaptics.conf > /etc/X11/xorg.conf.d/60-synaptics.conf
                echo ""
            fi
        fi

        # Amalthea Settings only
        if [[ "${h}" == "amalthea" ]]; then
            if [ -w "/etc/X11/xorg.conf" ]; then
                if [ -z $(grep -o 'ACER' '/etc/X11/xorg.conf') ]; then
                    echo "Adding dual monitor support to amalthea Xorg.conf"
                    cat ${LOCATION}/config/X11/xorg.amalthea.conf > /etc/X11/xorg.conf
                    echo ""
                fi
            fi
        fi
    fi
done

if [ -w "/etc/sudoers.d/" ]; then
    echo "Adding pratt sudoers config"
    cat ${LOCATION}/config/sudo/50-pratt.conf > /etc/sudoers.d/50-pratt
    chmod 0440 /etc/sudoers.d/50-pratt
    echo ""
fi

if [ -w "/etc/" ]; then
    if ! [ -d "/etc/chromium/" ]; then
        mkdir -p /etc/chromium/
    fi

    echo "Adding Chromium customization"
    cat ${LOCATION}/config/chromium/90-kwallet.conf > /etc/chromium/90-kwallet.conf
    chmod 644 /etc/chromium/90-kwallet.conf
    echo ""
fi

if [ -e "/etc/slackware-version" ] && [ -e "${LOCATION}/distros/slackware/slackware-install.sh" ]; then
    bash "${LOCATION}/distros/slackware/slackware-install.sh" "${LOCATION}"
fi

if [ -e "/etc/arch-release" ] && [ -e "${LOCATION}/distros/archlinux/archlinux-install.sh" ]; then
    bash "${LOCATION}/distros/archlinux/archlinux-install.sh" "${LOCATION}"
fi

read -p "Do you want to install Essential software? (y/n) " INSTALLPKGS
if [[ "${INSTALLPKGS}" == "y" ]]; then
    if [ -e "/etc/slackware-version" ]; then
        bash "${LOCATION}/packages/slackware/slackware-pkgs.sh" "${LOCATION}"
    fi

    if [ -e "/etc/arch-release" ]; then
        bash "${LOCATION}/packages/archlinux/archlinux-pkgs.sh" "${LOCATION}"
    fi
fi

if [ -e "/etc/slackware-version" ] && [ -e "${LOCATION}/distros/slackware/slackware-post-install.sh" ]; then
    bash "${LOCATION}/distros/slackware/slackware-post-install.sh" "${LOCATION}"
fi

if [ -e "/etc/arch-release" ] && [ -e "${LOCATION}/distros/archlinux/archlinux-post-install.sh" ]; then
    bash "${LOCATION}/distros/archlinux/archlinux-post-install.sh" "${LOCATION}"
fi

if ! [ -e "${HOME}/.bin/psysh" ]; then
    echo "Installing psysh"
    wget http://psysh.org/psysh -O ~/.bin/psysh
    chmod +x ~/.bin/psysh
    echo ""
fi

if ! [ -e "${HOME}/.bin/phpunit" ]; then
    echo "Installing phpunit ${PVER}"
    wget https://phar.phpunit.de/phpunit-8.phar -O ~/.bin/phpunit
    chmod +x ~/.bin/phpunit
    echo ""
fi

if ! [ -e "${HOME}/.bin/phploc" ]; then
    echo "Installing phploc"
    curl -L "https://phar.phpunit.de/phploc.phar" > ${HOME}/.bin/phploc
    chmod +x ${HOME}/.bin/phploc
    echo ""
fi

if ! [ -e "${HOME}/.bin/phpmd" ]; then
    echo "Installing PHP Mess Detector"
    curl -L "http://static.phpmd.org/php/latest/phpmd.phar" > ${HOME}/.bin/phpmd
    chmod +x ${HOME}/.bin/phpmd
    echo ""
fi

if ! [ -e "${HOME}/.bin/phpcs" ] || ! [ -e "${HOME}/.bin/phpcbf" ]; then
    echo "Installing PHP Code Sniffer"
    curl -L "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar" > ${HOME}/.bin/phpcs
    curl -L "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar" > ${HOME}/.bin/phpcbf
    chmod +x ${HOME}/.bin/phpcs
    chmod +x ${HOME}/.bin/phpcbf
    echo ""
fi

