#!/bin/bash
##################################################################
#  This file defines behaviour for Archlinux bash
#  Michael Pratt
##################################################################
if [ -e "/usr/bin/fortune" ]; then
    fortune
    echo ""
fi

# Add local slackware bin directory to the path
[ -e "${HOME}/.archlinux/bin" ] && PATH=${PATH}:${HOME}/.archlinux/bin
