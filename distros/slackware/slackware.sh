#!/bin/bash
##################################################################
#  This file defines behaviour for slackware linux bash
#  Michael Pratt
##################################################################
echo "   _____ __           __                          "
echo "  / ___// /___ ______/ /___      ______ _________ "
echo "  \__ \/ / __  / ___/ //_/ | /| / / __  / ___/ _\\"
echo " ___/ / / /_/ / /__/ ,<  | |/ |/ / /_/ / /  /  __/"
echo "/____/_/\__,_/\___/_/|_| |__/|__/\__,_/_/   \___/  $(awk '{print $2}' /etc/slackware-version)"

# Standard Slackware Scripts
for profile_script in /etc/profile.d/*.sh ; do
    if [ -x "${profile_script}" ]; then
        source ${profile_script}
    fi
done
unset profile_script

# Non-root Alias for Administration tools
if [ "$(whoami)" != "root" ]; then
    alias sbopkg="sudo sbopkg"
    alias installpkg="sudo /sbin/installpkg"
    alias upgradepkg="sudo /sbin/upgradepkg"
    alias removepkg="sudo /sbin/removepkg"
    alias shutdown="sudo /sbin/shutdown"
    alias reboot="sudo /sbin/reboot"
    alias halt="sudo /sbin/halt"
    alias slackpkg="su -c 'slackpkg update && slackpkg install-new && slackpkg upgrade-all'"
    alias su="su -l"
fi

# Add local slackware bin directory to the path
[ -e "${HOME}/.slackware/bin" ] && PATH=${PATH}:${HOME}/.slackware/bin

# Add /usr/sbin to $PATH
PATH=${PATH}:/usr/sbin/
