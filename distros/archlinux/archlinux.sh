#!/bin/bash
##################################################################
#  This file defines behaviour for Archlinux bash
#  Michael Pratt
##################################################################
echo "                  -\`"
echo "                 .o+\`"
echo "                \`ooo/"
echo "               \`+oooo:"
echo "              \`+oooooo:"
echo "              -+oooooo+:"
echo "            \`/:-:++oooo+:"
echo "           \`/++++/+++++++:"
echo "          \`/++++++++++++++:"
echo "         \`/+++ooooooooooooo/\`"
echo "        ./ooosssso++osssssso+\`"
echo "       .oossssso-\`\`\`\`/ossssss+\`"
echo "      -osssssso.      :ssssssso."
echo "     :osssssss/        osssso+++."
echo "    /ossssssss/        +ssssooo/-"
echo "  \`/ossssso+/:-        -:/+osssso+-"
echo " \`+sso+:-`                 `.-/+oso:"
echo "\`++:.                           \`-/+/"
echo ".\`                                 \`"

# Add local slackware bin directory to the path
[ -e "${HOME}/.archlinux/bin" ] && PATH=${PATH}:${HOME}/.archlinux/bin
