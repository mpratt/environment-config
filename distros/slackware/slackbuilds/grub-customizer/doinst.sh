[ -f "/etc/default/grub.orig" ] && rm -rf /etc/default/grub.orig
cp /etc/default/grub /etc/default/grub.orig
sed -i 's@sed s/Slackware /Slackware-/ /etc/slackware-version@cat /etc/slackware-version | tr [:blank:] -@' /etc/default/grub
